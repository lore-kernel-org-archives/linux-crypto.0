Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723406;
	b=ia97ftczXAveBuh21PVqygfqP6LadlEZqOlSHMZXg3CiGc8vtCn4A/FBcuHNNyN51fHP
	 iK7Zwd3/WJXkZYamsZWjV1Aaj1vdgT5VMlExyiQNfOZw6SBqMYfrsV/CZd05KF/SCQOgO
	 Rwu9pBv9dPV9ALbyjOriWJJGnB38WixLGm278MJsU0+acOKHVOIyUMyjn9zQOyfyowTOI
	 5LiXOA4gvqvyRMoMWC4l8vUycbLQxlCIVkQwtnYGd5FW7UeK5KkXceNV9r35ISHktAlJp
	 7NHJpwRqrqKHaMU88yE1jfOnuuHR57o1D+3PnSDlhZLaom65XQLaKMVyZwQMULUTBhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723406;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Hd9PQQ8ozOYSKti/kNoYNT++gNKLWkbtNoIAA4opdCA=;
	b=HungH1gcpS//WoXhKUCYGQgm4ppEjwmZYUHDD9buUjW8iULN9ud6L3TTFHNDSwSPXziC
	 ozgnzqRPkIndCnWbPAfvmh6EwWExT/4x173NBpdMJDN8t29DRC+dmAmP7NiUffkDYXyEJ
	 uWqi7lP+5X1nJkkgMRPFsf7kJFYnwX+OE5aDFkbWnzRDKZN1WhgkrCiZip5Pt1sK+QYAd
	 AcQmuyewqx+xAFG5YJ8bR/MgkxZotE5fbMTrIvY26jeYmauaICQ2LX5dDiQbcVAwsV33r
	 G850vY2xWw6u6fjH4tdYQQG4kgs4sVmzEpZ9ZtxIeuUJeHz8rrc+B6qPsKF7WNEb4ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUDG7NQ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A27E606D803;
	Tue,  3 Nov 2026 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUDG7NQ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F95D1F00A18;
	Tue,  3 Nov 2026 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723405;
	bh=Hd9PQQ8ozOYSKti/kNoYNT++gNKLWkbtNoIAA4opdCA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BUDG7NQ0/lHzpiPu+jwuqlL3hP4gXpULtNXG71tbvKd7XNAbKnAEOb7mM5tAOKBmp
	 V4zFYcVXK6yxmaFiSNoyTxVUxRCZaD0vyn74BoNYq5yzDEwwUAe/aarppwewp5MTi+
	 YJDja6RS7HEB3jsDZnWrMG/LXQn/b0oNiQASY89GENa7kUD+co788voxYh1D7fAcod
	 rtJnif45tnei/4F/3SF+RYK+SHMP3OduGweo3THRK3LuigIAQS5wktAvdz3Mzv6tgh
	 PrIcll1od/N+ENujX8eeBW6VTgxGF84TK5A4HsraJ3YjWhN+LYqr95ZHJGj42Q3k46
	 PAdtk+zkT10MA==
Message-ID: <sashiko-outbox-195727@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/9] greybus: operation: keep request active across
 message_send
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
In-Reply-To: <20261103-gb-uart-transport-v5-1-f8e326d6561f@beagleboard.org>
References: <20261103-gb-uart-transport-v5-0-f8e326d6561f@beagleboard.org>
 <20261103-gb-uart-transport-v5-1-f8e326d6561f@beagleboard.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 16:30:04 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] greybus: operation: double put in gb_operation_request_send() =
on send error
- [Critical] greybus: operation: race between gb_operation_get_active() cal=
ls on send
--

commit 1f5c8fb4470157e5c81c1041163bd49efb2ea63b
Author: Ayush Singh <ayush@beagleboard.org>

greybus: operation: keep request active across message_send

This commit takes an extra reference and active count on the Greybus
operation across gb_message_send() in gb_operation_request_send() so that
operation cancellation waits for the host driver's send path to return.

> diff --git a/drivers/greybus/operation.c b/drivers/greybus/operation.c
> index 7e12ffb2dd60d..a63bc2eb164e9 100644
> --- a/drivers/greybus/operation.c
> +++ b/drivers/greybus/operation.c
> @@ -766,7 +766,25 @@ int gb_operation_request_send(struct gb_operation *o=
peration,
>  	if (ret)
>  		goto err_put;
> =20
> +	/*
> +	 * Completion can drop the reference and active count above while the
> +	 * host driver is still sending. Hold another of each across the send, =
so
> +	 * that cancelling the operation waits for the host driver to return.
> +	 */
> +	gb_operation_get(operation);
> +	ret =3D gb_operation_get_active(operation);
> +	if (ret) {
> +		/*
> +		 * The connection is being torn down, and the operation, which is
> +		 * already on its list, will be cancelled and completed.
> +		 */
> +		gb_operation_put(operation);
> +		return 0;
> +	}

[Severity: Critical]
Because the first gb_operation_get_active(operation) call adds operation->l=
inks
to connection->operations with operation->active =3D=3D 1 and then drops
connection->lock before the second reference and active count are acquired,
can a concurrent teardown race in the window between the two
gb_operation_get_active() calls?

1. If gb_connection_disable() or gb_connection_disable_forced() runs right
after the first gb_operation_get_active() unlocks connection->lock,
gb_connection_cancel_operations() -> gb_operation_cancel() queues
gb_operation_work(). If gb_operation_work() runs before this thread reaches
the second gb_operation_get(operation), it invokes operation->callback(),
decrements operation->active to 0 (waking gb_operation_cancel() before
gb_message_send() has even started), and drops the completion reference. For
asynchronous callers whose callback drops the caller's own reference (such =
as
gb_loopback_async_operation_callback() in drivers/staging/greybus/loopback.=
c),
operation->kref can reach 0 and free operation before the second
gb_operation_get() and gb_operation_get_active() touch it.

2. For GB_OPERATION_FLAG_CORE operations, gb_operation_get_active() permits
operations when connection->state is GB_CONNECTION_STATE_DISCONNECTING:

drivers/greybus/operation.c:gb_operation_get_active() {
	...
	case GB_CONNECTION_STATE_DISCONNECTING:
		if (!gb_operation_is_core(operation))
			goto err_unlock;
		break;
	...
}

If a core operation passes the first gb_operation_get_active() in
GB_CONNECTION_STATE_ENABLED, and gb_connection_disable() transitions to
GB_CONNECTION_STATE_DISCONNECTING and cancels/completes the operation in the
window before the second gb_operation_get_active(), won't the second
gb_operation_get_active() still succeed in DISCONNECTING, re-add the already
completed operation to connection->operations, and send it?

Conversely, in drivers/greybus/connection.c, gb_connection_disable() and
_gb_connection_enable() call gb_connection_cancel_operations() when entering
GB_CONNECTION_STATE_DISCONNECTING, but not when subsequently setting
connection->state =3D GB_CONNECTION_STATE_DISABLED:

drivers/greybus/connection.c:gb_connection_disable() {
	...
	spin_lock_irq(&connection->lock);
	connection->state =3D GB_CONNECTION_STATE_DISCONNECTING;
	gb_connection_cancel_operations(connection, -ESHUTDOWN);
	spin_unlock_irq(&connection->lock);
	...
	connection->state =3D GB_CONNECTION_STATE_DISABLED;
}

If a core operation passes the first gb_operation_get_active() while in
GB_CONNECTION_STATE_DISCONNECTING and connection->state transitions to
GB_CONNECTION_STATE_DISABLED before the second gb_operation_get_active(), t=
he
second call returns -ENOTCONN and this path returns 0 without dropping the
first active count or reference and without anyone cancelling the operation,
leaking operation and hanging synchronous callers waiting on
operation->completion.

> +
>  	ret =3D gb_message_send(operation->request, gfp);
> +	gb_operation_put_active(operation);
> +	gb_operation_put(operation);
>  	if (ret)
>  		goto err_put_active;

[Severity: Critical]
What happens if gb_operation_cancel() cancels the operation while
gb_message_send() is in progress, and gb_message_send() then returns a
non-zero error code?

While gb_message_send() is running, operation is on connection->operations
with operation->errno set to -EINPROGRESS. If a concurrent teardown calls
gb_connection_cancel_operations() -> gb_operation_cancel(operation, -ESHUTD=
OWN):

drivers/greybus/operation.c:gb_operation_cancel() {
	...
	if (gb_operation_result_set(operation, errno)) {
		gb_message_cancel(operation->request);
		queue_work(gb_operation_completion_wq, &operation->work);
	}
	...
}

gb_operation_work() will run operation->callback(operation) and call
gb_operation_put_active(operation) and gb_operation_put(operation), consumi=
ng
the initial completion active count and reference.

If gb_message_send() also returns an error (for example, on disconnect or TX
failure), gb_operation_request_send() drops the send active count and
reference here, and then jumps to err_put_active:

	ret =3D gb_message_send(operation->request, gfp);
	gb_operation_put_active(operation);
	gb_operation_put(operation);
	if (ret)
		goto err_put_active;
	...
err_put_active:
	gb_operation_put_active(operation);
err_put:
	gb_operation_put(operation);

Wouldn't jumping to err_put_active drop the completion active count and
operation->kref a second time (three puts for two gets), underflowing
operation->active to -1, underflowing operation->kref into a use-after-free,
and running both the asynchronous completion callback and the synchronous
error return path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-gb-uart-tr=
ansport-v5-0-f8e326d6561f@beagleboard.org?part=3D1
