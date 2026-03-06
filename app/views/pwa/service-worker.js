self.addEventListener("push", async (event) => {
  const payload = await event.data.json()
  const title = payload.title || "SICA"
  const options = payload.options || {}
  event.waitUntil(self.registration.showNotification(title, options))
})

self.addEventListener("notificationclick", (event) => {
  event.notification.close()
  const targetPath = event.notification.data?.path || "/admin"

  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then((clientList) => {
      for (let i = 0; i < clientList.length; i += 1) {
        const client = clientList[i]
        const clientPath = (new URL(client.url)).pathname
        if (clientPath === targetPath && "focus" in client) {
          return client.focus()
        }
      }

      if (clients.openWindow) return clients.openWindow(targetPath)
      return undefined
    })
  )
})
