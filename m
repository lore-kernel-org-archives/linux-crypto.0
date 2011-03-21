From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: RSA signature verification
Date: Mon, 21 Mar 2011 16:04:41 +0200
Message-ID: <4D875AF9.4060302@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:34423 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab1CUOE1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2011 10:04:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I work on kernel RSA verification for IMA/EVM.

Currently I have a patch which provides "direct" API like ksign_verify()
to get signature verified.
I was thinking about doing it via crypto interface as usual but for now
I have done it directly.
I have found some very old (5y) patches where someone tried to have it
as kind of hash API.
update(), update(), final...

As RSA, in contrast to hash, has like sign/verify operations.
For the kernel there is only verify.

Snippet from the code:

-----------------------------------------------------------------------
    desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(shash),
               GFP_KERNEL);
    if (!desc)
        goto err;

    desc->tfm = shash;
    desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;

    crypto_shash_init(desc);
    crypto_shash_update(desc, digest, digestlen);
    crypto_shash_update(desc, sig, sizeof(*sh));
    crypto_shash_final(desc, h);

    kfree(desc);

    /* pass signature mpis address */
    err = ksign_verify_rsa(key, sig + sizeof(*sh), siglen - sizeof(*sh),
                 h, sizeof(h));

-----------------------------------------------------------------------

So hash is calculated which is then verified against
signature.

Do you think it make sense to have it as a crypto "algo"
What kind of API you would have in mind?

Thanks,
Dmitry
