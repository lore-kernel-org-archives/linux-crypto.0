Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723238;
	b=TgWP0TszlY7YDUP57rF9ljxh2SPwsCBfZPWHSSCQv9jDEfJZxoT023+3qwKNCqjzK1pc
	 Ikg8jRQJOopQwksZfUIdfYbZRFDRIW70izTNTFfOVKjy2Loqx/65OQJsWadxm0gte5qSO
	 Qm3o9N1VJrOjPSxZLBccsosPNO5la0iGKy29Dwy8KWp9aNAkJuZoCWtKb8Tp80N0gmL8Y
	 c03DSzf2uwAtdfMxEx3DKVO6cByhbTGCPEJC28UyC/r9ZZreYC+gNySwseNB50EsRs6K/
	 vP5O2r8VsT4kHXi721lVyZQbn7MlB840T76fU2XuPTrvIl1oH6Ad05jGT8ge6d2/CJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723238;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=I1AWzUFA3Oachr2Qibp7GjIpzBQCVcrtm0Vca+qYnFA=;
	b=t2rmpy0gk2SljlPRu54b1nKPCfYiZjcSlOPo1WwiF7yG05Bn5f4mVEK/TbmcpGWwvm0N
	 JTlVPXKqbbFnFy25CqPv6nQZVKnolB1Z2JVtrxUgbo5Nb3ocN32A3W4Bi2DnblZr2IYqO
	 6wXacl6XEgQZNaksqpG+zNawkIwrEEXze+4x5fFPpIqsXtobJfwcs23lpdemQupegUtB/
	 ypP9/Smcl2KVLzgQ6kqjK6QtkZtQp+DBCNpxRGqOGhzHXwCUYT0Y4c/7Vpie+fHWb36Cw
	 VzsRyAv1HGynBSJ7s8T1usZ5/YQqs6TVB07OJFvbwIIbOA7UpTH1KOZ7spXQJtVj35A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RqOZ/p14";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB85606A324;
	Tue,  3 Nov 2026 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RqOZ/p14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75A61F000C1;
	Tue,  3 Nov 2026 16:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723238;
	bh=I1AWzUFA3Oachr2Qibp7GjIpzBQCVcrtm0Vca+qYnFA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RqOZ/p141KX5CE7URn51HZuraohH8+lJo7k9l8Kch8ZKCn6wL2XqKCbrxKbNiW7pO
	 txJfpFepSQSkoYuuTOiDx+9OBWBXvOdyxkUcrOV6cWb/9BEORZAURSFWOKaJlvvPNv
	 16foK7rKGa8nIgKBnchrH5K9nsRG47s9uvoQKax1VfNrVKRwUgQGTuA5VxgTIbCsLQ
	 VUin3vAr89++wATIoIA6A/iYF/nmDvMow8qYG5V+jvJ9azGXqcY7GcWeFgultGdF1x
	 miSMeCXdWbdOpEvDNFmTIb52O3GmU+Q+2HPeId5ICcP3xyTMnA0xIcd7OBq9NDILtO
	 jZWst9iw6QrOQ==
Message-ID: <sashiko-outbox-195721@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/9] greybus: operation: arm request timeout before
 sending
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ayush Singh" <ayush@beagleboard.org>, "Jason Kridner" <jkridner@beagleboard.org>, robertcnelson@gmail.com, "Johan
 Hovold" <johan@kernel.org>, "Alex Elder" <elder@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>, =?utf-8?b?Qmo=?=
 =?utf-8?b?w7ZybiBSb3kgQmFyb24=?= <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>, "Alexandre
 Courbot" <acourbot@nvidia.com>, =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Eric
 Biggers" <ebiggers@kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>, "Ayush
 Singh" <ayush@beagleboard.com>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Markus
 Probst" <markus.probst@posteo.de>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261103-gb-uart-transport-v5-3-f8e326d6561f@beagleboard.org>
References: <20261103-gb-uart-transport-v5-0-f8e326d6561f@beagleboard.org>
 <20261103-gb-uart-transport-v5-3-f8e326d6561f@beagleboard.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 16:27:16 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] greybus: operation: UAF and ref underflow in gb_operation_requ=
est_send()
- [Critical] greybus: operation: UAF from early timeout in gb_operation_req=
uest_send()
- [Critical] greybus: operation: timer leak in gb_operation_request_send() =
on cancel
--

commit 7b73a81d11f2d699f2c8ebeafd18ae6352191433
Author: Ayush Singh <ayush@beagleboard.org>

greybus: operation: arm request timeout before sending

This commit arms the operation timeout timer before calling
gb_message_send() in gb_operation_request_send() so that a fast response
completing before gb_message_send() returns does not leave an armed timer
behind, and calls timer_delete_sync() in the err_put_active error path.

> diff --git a/drivers/greybus/operation.c b/drivers/greybus/operation.c
> index a63bc2eb164e9..2d37acedf36f8 100644
> --- a/drivers/greybus/operation.c
> +++ b/drivers/greybus/operation.c
> @@ -782,20 +782,25 @@ int gb_operation_request_send(struct gb_operation *=
operation,
>  		return 0;
>  	}
> =20
> +	/*
> +	 * Arm the timeout before sending: the response can arrive, and the
> +	 * operation complete, before the host driver returns.
> +	 */
> +	if (timeout) {
> +		operation->timer.expires =3D jiffies + msecs_to_jiffies(timeout);
> +		add_timer(&operation->timer);
> +	}

[Severity: Critical]
Could an operation still be cancelled between gb_operation_get_active() and
add_timer(&operation->timer) in gb_operation_request_send(), leaking an
armed timer in operation->timer?

Earlier in gb_operation_request_send(), operation->errno is initialized to
-EINPROGRESS and the first gb_operation_get_active() adds operation->links
to connection->operations.

If a concurrent thread disables the connection via gb_connection_disable()
or gb_connection_disable_forced() after the second
gb_operation_get_active() succeeds and before add_timer(&operation->timer)
runs:

CPU0                                    CPU1
gb_operation_request_send()
  gb_operation_result_set(-EINPROGRESS)
  gb_operation_get_active()
  gb_operation_get_active()
                                        gb_connection_cancel_operations()
                                          gb_operation_cancel(-ESHUTDOWN)
                                            gb_operation_result_set(-ESHUTD=
OWN)
                                            queue_work(&operation->work)

                                        gb_operation_work()
                                          timer_delete_sync(&operation->tim=
er)
                                          operation->callback(operation)
                                          gb_operation_put_active(operation)
                                          gb_operation_put(operation)
  add_timer(&operation->timer)
  gb_message_send() -> returns 0

Because gb_operation_work() runs timer_delete_sync(&operation->timer) before
CPU0 calls add_timer(&operation->timer), nothing deletes operation->timer
afterward. When the caller later drops its reference via gb_operation_put(),
_gb_operation_destroy() frees struct gb_operation while operation->timer is
still queued in the timer wheel.

> +
>  	ret =3D gb_message_send(operation->request, gfp);

[Severity: Critical]
What happens if operation->timer expires after add_timer(&operation->timer)
is called, but before the host driver in gb_message_send() has submitted its
transport request?

For an asynchronous host driver such as drivers/greybus/es2.c, if the
sending thread is delayed or preempted before message_send() assigns
message->hcpriv and calls usb_submit_urb():

drivers/greybus/es2.c:message_send() {
	...
	spin_lock_irqsave(&es2->cport_out_urb_lock, flags);
	message->hcpriv =3D urb;
	spin_unlock_irqrestore(&es2->cport_out_urb_lock, flags);
	...
	retval =3D usb_submit_urb(urb, gfp_mask);
}

If operation->timer fires first, gb_operation_timeout() sets
operation->errno to -ETIMEDOUT and schedules gb_operation_work():

gb_operation_timeout()
  gb_operation_result_set(operation, -ETIMEDOUT)
  queue_work(gb_operation_completion_wq, &operation->work)

gb_operation_work()
  timer_delete_sync(&operation->timer)
  gb_message_cancel(operation->request)
    es2.c:message_cancel() -> no-op because message->hcpriv is not yet acti=
ve
  operation->callback(operation)
  gb_operation_put_active(operation)
  gb_operation_put(operation)

When the sending thread resumes in es2.c:message_send(), it submits the URB
and returns 0 to gb_operation_request_send(). Because operation->callback()
has already completed the operation, the caller can drop the final reference
to operation via gb_operation_put(), freeing operation->request and
operation->request->buffer in _gb_operation_destroy() while the URB is still
in flight.

>  	gb_operation_put_active(operation);
>  	gb_operation_put(operation);
>  	if (ret)
>  		goto err_put_active;
> =20
> -	if (timeout) {
> -		operation->timer.expires =3D jiffies + msecs_to_jiffies(timeout);
> -		add_timer(&operation->timer);
> -	}
> -
>  	return 0;
> =20
>  err_put_active:
> +	timer_delete_sync(&operation->timer);
>  	gb_operation_put_active(operation);
>  err_put:
>  	gb_operation_put(operation);

[Severity: Critical]
Can this error path underflow operation->active and operation->kref and
trigger a use-after-free on struct gb_operation when gb_message_send() fails
after operation->timer has already expired (or after gb_operation_cancel()
has been called)?

In gb_operation_request_send(), two pairs of kref and active references are
taken before gb_message_send(): one pair for operation completion, and one
pair held across gb_message_send().

With operation->timer armed before gb_message_send(), if gb_message_send()
sleeps or takes longer than timeout before returning an error (for example,
hdlc_tx_frames() in gb-beagleplay.c waiting on a full TX circular buffer
before returning -EAGAIN, or write_all() in gb_uart_node.rs returning
-EINTR), operation->timer can fire while gb_message_send() is still running:

gb_operation_timeout()
  if (gb_operation_result_set(operation, -ETIMEDOUT))
      queue_work(gb_operation_completion_wq, &operation->work);

gb_operation_work() then runs on gb_operation_completion_wq, invokes
operation->callback(operation), and drops the completion reference pair:

gb_operation_work()
  ...
  operation->callback(operation);
  gb_operation_put_active(operation);
  gb_operation_put(operation);

When gb_message_send() returns a non-zero ret, gb_operation_request_send()
drops the send-guard reference pair and jumps to err_put_active:

  ret =3D gb_message_send(operation->request, gfp);
  gb_operation_put_active(operation);
  gb_operation_put(operation);
  if (ret)
      goto err_put_active;

In err_put_active, timer_delete_sync(&operation->timer) only waits for the
timer callback to finish; it does not cancel the already-queued
operation->work, nor does err_put_active check gb_operation_result_set() to
see whether completion was already claimed.

Consequently, err_put_active drops gb_operation_put_active(operation) and
gb_operation_put(operation) a third time when only two pairs were acquired,
underflowing operation->active to -1 (which also causes wait_event() in
gb_operation_cancel() to hang) and dropping the caller's own kref on
operation (or accessing operation after it was already freed if an
asynchronous callback such as gb_loopback_async_operation_callback() dropped
the caller's reference before gb_operation_put() prior to err_put_active).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-gb-uart-tr=
ansport-v5-0-f8e326d6561f@beagleboard.org?part=3D3
