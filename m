From: Kyle Rose <krose@krose.org>
Subject: KPP questions and confusion
Date: Mon, 17 Jul 2017 17:00:44 +0200
Message-ID: <CAJU8_nUhapH=nKkL=NEa2uW5f-vdAX3kvi5Ua7b_bA8d=BjRLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35216 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdGQPAq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 11:00:46 -0400
Received: by mail-qt0-f182.google.com with SMTP id b40so108290335qtb.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 08:00:46 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I am confused about several things in the new key agreement code.

net/bluetooth/smp.c in two places generates random bytes for the
private_key argument to
net/bluetooth/ecdh_helper.c:generate_ecdh_keys, which suggests the
private key is static within the function. However, there is a do ...
while(true) loop within generate_ecdh_keys, with the following near
the end:

/* Private key is not valid. Regenerate */
if (err == -EINVAL)
            continue;

which suggests that it expects a different private key to be generated
on each iteration of the loop. But it looks like it runs through the
loop yet again with the same private key generated in the caller,
which suggests it would infinitely loop on a bad private key value. Is
this incorrect?

Furthermore, since req->src == NULL via the call to
kpp_request_set_input, ecc_make_pub_key will always be called in
ecdh.c:ecdh_compute_value, in which case -EINVAL would be returned
only by invalid input (!private_key or bad curve_id) that AFAICT
cannot happen, or at least wouldn't be resolved by another run through
the loop.

OTOH, -EAGAIN would be returned by ecc_make_pub_key if the public key
turns out to be the zero point, which is at least one reason why you'd
want to generate a new private key (if that loop were to do that.)

I'm a little confused about some other things:

* The bluetooth code doesn't seem to use ecc_gen_privkey, opting to
instead just generate random bytes and hope for the best.
* There doesn't appear to be any way for ecc_gen_privkey to get called
from crypto/ecdh.c:ecdh_set_secret, as it starts with a call to
crypto/ecdh_helper.c:crypto_ecdh_decode_key that returns -EINVAL if
decoding fails, meaning that both params.key != NULL and (if I'm
reading this correctly) params.key_size > 0. Is that dead code, or is
there a way it is intended to be used?

The context for this email is that I have need for the same basic
functionality in net/bluetooth/ecdh_helper.c for a non-BT purpose, so
it seems like this should be part of crypto/ecdh_helper.c (abstracted
to work for any curve). Basically, I need to do basic ECDH key
agreement:

* Generate a new (valid) ephemeral private key, or potentially re-use
an existing one
* Compute the corresponding public key for the curve
* Compute the shared secret based on my private and peer's public

Is KPP intended to be an abstract interface to all of the above, e.g.,
for both ECDH and FFDH? Right now it seems like layer violations are
required as there doesn't appear to be any way to (for example)
generate a fresh private key via kpp_*.

Thanks,
Kyle
