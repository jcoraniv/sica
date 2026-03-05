module ApplicationHelper
  def invoice_status_label(invoice)
    return t("enums.invoice.status.paid") if invoice.paid?
    return t("enums.invoice.status.pending") if invoice.pending?

    invoice.status.to_s.humanize
  end

  def invoice_status_badge_class(invoice)
    return "status-badge status-badge-paid" if invoice.paid?
    return "status-badge status-badge-pending" if invoice.pending?

    "status-badge bg-neutral-100 text-neutral-700 ring-1 ring-neutral-200"
  end

  def invoice_status_options
    Invoice.statuses.keys.map { |status| [t("enums.invoice.status.#{status}"), status] }
  end

  def user_role_label(role)
    t("enums.user.role.#{role}")
  end

  def user_role_options
    User.roles.keys.map { |role| [user_role_label(role), role] }
  end
end
