Received: from mail.w13.tutanota.de (mail.w13.tutanota.de [185.205.69.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7392F8BEE
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.205.69.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783958571; cv=none; b=W7MAaCbRVAJHTbaR9znzJSO1uNJ1O//til7QxYniLA9dpXGpDLCsgIyFqxF3CKvIpUIfgDrEloLpdHbcjhd3PTcB2Woge6E+ASVINERIlaXsGCKyAOg8mckk4Unup/WYmfcdrCmzrl0YUMgJGtwrBB7/T5/y04Xn17RT4n4Ux9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783958571; c=relaxed/simple;
	bh=e44nlkk3G4gp7yMrOCYwWS6K8LFPr1657xtd8C6ifIU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jU67EvtZdKIaWSh54fynmGv7phRGWrkveMbBaO8VmDnhR69qyCs4rw9s/YPQ9RjZ/1SIqg4UGfUi9bOEcoKMVbrysbwXem14uDSfAKSp8kATroLOCJcSjVkHeQHqfTWVhhOj8vRwdNG4OyIICpeZc1TtuQxBVm5nMgRS1u8JIAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com; spf=pass smtp.mailfrom=tutanota.com; dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b=CVk0I+q7; arc=none smtp.client-ip=185.205.69.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="CVk0I+q7"
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w13.tutanota.de (Postfix) with ESMTP id 4289B15D7AA78
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 18:02:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783958562;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=e44nlkk3G4gp7yMrOCYwWS6K8LFPr1657xtd8C6ifIU=;
	b=CVk0I+q7iEf6+uKbe991F0jlNyXjPfxfS4dSESBTLVzkbdm9+tLhaZg/WlEDJV4q
	KLOYcMaSAEUgycWKshsZUfAb+6biffwp/39y6w4iVv8nGbmXZllwZ1CyB8sis8D6wa0
	T1V2DyRrNzHHwbhDQI7dZ6BmFx0o5P32VjKzHL8wAnUWd5EhZzsrFpwSPxg41+zL6fc
	VpWvVEXzv+6DhUzO2BXqTLvQR5tDoZVbb9rdvtg5bXOkp16xHsO/q+vp4T3rDKieSIY
	0xhLsEizL/ucr6QtVjD60I70EbyfX7hEaZ4viDINuLWJXNSRGYG0bJqglL+3IgBJlKw
	LP6Si+81sw==
Date: Mon, 13 Jul 2026 18:02:42 +0200 (CEST)
From: cyper@tutanota.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Davem <davem@davemloft.net>, Linux Crypto <linux-crypto@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <OxRB4MX--J-9@tutanota.com>
In-Reply-To: <alRE8Mqf-W0Qqpnq@gondor.apana.org.au>
References: <OwDrEgL--F-9@tutanota.com> <alRE8Mqf-W0Qqpnq@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_aead - stop recvmsg looping after a
 completed request
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Feedback-ID: 01c31dc8a5d4d6751b6f6ac02a78e46dc8b122f05e0198c33d2725066fef6ebaf2fef8f8a5859fcd950990ed82c624bcd61f0c6ba63d9a3ddbf9efb21fe5671f4a:TurnOnPrivacy!:tutamail

> The point of this loop is to wait for a new sendmsg on the socket
> which is supposed to set ctx->init to true again. So are you saying
> that even a new sendmsg cannot get out of this wait?

Thanks -- you're right about the mechanism, and my changelog was
imprecise. Let me correct it with what actually happens.

A new sendmsg *does* get out of that particular wait: it sets
ctx->init =3D true and af_alg_data_wakeup() wakes the sleeper, so
af_alg_wait_for_data() returns and _aead_recvmsg() processes the new
request. What it does *not* do is make the recvmsg() return: the
"while (msg_data_left(msg))" loop only stops once the output buffer is
full, so after processing the new request it just loops back and blocks
again in af_alg_wait_for_data() for the *next* one.

So the blocking read() as a whole never completes until the caller sends
enough separate requests to fill the entire output buffer (or a signal
arrives). I confirmed this on a live socket with stock gcm(aes), one
initial request (48B PT -> 64B result) and a 256-byte read buffer, using
a helper thread that sends additional full requests:

=C2=A0 extra sendmsgs | read() returns=C2=A0=C2=A0 | elapsed
=C2=A0 ---------------+------------------+------------------------------
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 64 (watchdog)=C2=A0=C2=A0=C2=A0 | 4.00s=C2=A0 hung
=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 128 (watchdog)=C2=A0=C2=A0 | 4.00s=C2=A0 hung=C2=A0 (advance=
d, re-blocked)
=C2=A0=C2=A0 3 (fills 256) | 256=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1.80s=C2=A0 returned on its own

i.e. one extra sendmsg advanced the result 64 -> 128 and then blocked
again; the read() only returned by itself once four requests had filled
the 256-byte buffer exactly. (The "elapsed 4.00s" rows returned only
because a 4s alarm interrupted the sleep, which makes the loop bail out
returning the bytes accumulated so far -- that is also why a signal or
strace made my original repro "work".)

So my one-line summary "hangs forever" was wrong; the accurate statement
is: a blocking recvmsg() into a buffer larger than the data the caller
intends to send does not return -- it waits to fill the rest of the
buffer from further requests that a one-shot caller has no reason to
send (it did not set MSG_MORE).

Why I still think this is worth fixing rather than "size your buffer":
it breaks the poll()/read() contract. After a non-MSG_MORE request is
consumed, af_alg_poll() reports EPOLLIN:

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ctx->more || ctx->used)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 mask |=3D EPOLLIN | EPOLLRDNORM;

(!ctx->more is true), so a poll()-driven caller is told the socket is
readable, but the subsequent blocking read() then sleeps in
af_alg_wait_for_data() instead of returning the data poll() promised.
Same test:

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sendmsg =3D 48
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 poll rc=3D1 revents=3D0x1 POLLIN=
=3D1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read=3D64 elapsed=3D4.00s
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> poll() said POLLIN but read()=
 blocked

That is what libkcapi/OpenSSL/cryptsetup avoid today only by always
sizing the RX buffer exactly to the expected output; anything larger
trips it.

On the fix itself: stopping the loop once a non-MSG_MORE request is fully
consumed (ctx->more =3D=3D 0 && ctx->used =3D=3D 0) turns that case into a =
normal
short read, which is what poll() already advertises. It deliberately does
not change:

=C2=A0 - MSG_MORE streaming: ctx->more !=3D 0 -> no break, keeps waiting fo=
r the
=C2=A0=C2=A0=C2=A0 rest of the message;
=C2=A0 - partial / AIO output: _*_recvmsg() leaves ctx->used > 0 -> no brea=
k;
=C2=A0 - the -EIOCBQUEUED / -EBADMSG paths: handled by the existing err <=
=3D 0
=C2=A0=C2=A0=C2=A0 branch before the new check (the check is only reached a=
fter
=C2=A0=C2=A0=C2=A0 "ret +=3D err", i.e. after a pass that made forward prog=
ress).

The only behaviour it removes is coalescing *multiple independent*
non-MSG_MORE requests into a single oversized read(). That case is not
something a caller can reach or rely on deterministically:

=C2=A0 - A single thread cannot even set it up: after one non-MSG_MORE requ=
est
=C2=A0=C2=A0=C2=A0 the next sendmsg hits the "ctx->init && !ctx->more" gate=
 with
=C2=A0=C2=A0=C2=A0 ctx->used !=3D 0 and fails with -EINVAL (verified). Coal=
escing is only
=C2=A0=C2=A0=C2=A0 reachable if a *second* context sends further requests w=
hile the first
=C2=A0=C2=A0=C2=A0 is blocked inside read() draining ctx->used.

=C2=A0 - How many requests get coalesced then depends purely on scheduling =
(how
=C2=A0=C2=A0=C2=A0 much of the buffer is filled before the next send lands)=
, so the
=C2=A0=C2=A0=C2=A0 result length is nondeterministic -- not an API contract=
 anything can
=C2=A0=C2=A0=C2=A0 depend on.

=C2=A0 - For AEAD it is meaningless anyway: each request has its own tag an=
d
=C2=A0=C2=A0=C2=A0 independent result, so splitting them across separate re=
ads loses
=C2=A0=C2=A0=C2=A0 nothing.

With the fix that pattern returns a short read (the first request's
output) and the caller reads again -- which is exactly what poll() already
tells it to do. No single-threaded, MSG_MORE, or poll()/nonblock-driven
caller sees any change.

If you'd prefer, I can respin with the changelog rewritten around the
poll()/read() inconsistency (which is the concrete, indefensible part),
or take a different approach if you had one in mind. Happy to add a
selftest as well.

Reproducers (single-threaded hang, the poll test, and the multi-thread
sendmsg test above) are available if useful.

Thanks,
Qiguang
