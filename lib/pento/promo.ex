defmodule Pento.Promo do
  @moduledoc """
  Context module `Promo`
  """

  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient, attrs) do
    # send email to promo recipient
  end
end
