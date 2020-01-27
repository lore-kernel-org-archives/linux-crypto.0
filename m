Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3C4C32771
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 08:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEC222071E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 08:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="XpJkwm3z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgA0IEi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 03:04:38 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46667 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0IEi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 03:04:38 -0500
Received: by mail-ua1-f66.google.com with SMTP id l6so3085127uap.13
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2020 00:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Dd1uQbbEeuZKBdMMGYg6LsCBUEaMJRt4GAhfQIGnjyw=;
        b=XpJkwm3zGSKngtRR/yxRetfuEA4WYHE1yRBm3w9OXbNWUA61OOSbJmJupph/kQCSVL
         AIHSjMqy7tHL5VSFbWq2sCZ2kUstRdGqy8G57mrmz4OE/HzLpAPVkLFBMZzSWpFOWZHx
         XAzjNqM6lNp7N6apdCrH4srLBj/vIOBVoiHazvIN3aiRRLclEkFGsZAqY2ZYwlQJZ8QO
         lCgGUcVq0+qHx0x8gKhpI7ObgB0GLuWX/kPfYpOvZ/WnL9hn4QeO0LT6AWLi8vHk660q
         ElFX0JcD0iUeGIseqRhmB6jEGB3yCEZmLxqbH93eufBYqctMEZ0JeJ/Ou1NsfzhNF7H6
         hBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Dd1uQbbEeuZKBdMMGYg6LsCBUEaMJRt4GAhfQIGnjyw=;
        b=sjWDGOUqxSkP1QaAEAhF6d/0ITy5oGq/nERQdjoi3/vu5rKXziH9pPESEA7AG1zaIk
         S9OXdgX5r24+oXwwjUPoHRtBaiKWdOG91jlJ0nfPIEzwQjs2Kb7cu2k8Tu+d2ziE9Hol
         CNk306eSwIfWJOJxJR9RhsC/489bhNHJod9hG1L16kTqQPgAABV+48gu+XlSvSks0Gbr
         ak7EbAkNzxtknoSDOmuCDOY39lLLmF2BuZeu1XK63KrqSY8IwVvI2PXZkx7N1fARXxEE
         YqJvukbvKTezCU8aCq9mAE1JpQkl8uVdfd23nnHcRrineQeIGyuh6MgeGkymwNsvUZEM
         qEHA==
X-Gm-Message-State: APjAAAWTqAF23uoQbMdGjycutxv1Ht42N2YcvZ+B28YoC9UEvmx7rtQD
        YSo0m9UYI3oGjyGrWaKmv1ONbKA0auyOkmcylCNqbY2Ehp1fHaVl
X-Google-Smtp-Source: APXvYqzgJRFpfT3qOSRSyDxAIb44eApsVA5cAKBvx9d1WAjeD3uvPxPgz1erY+N1B0fEPXw/kjUrsntVkmkFjy3QVGc=
X-Received: by 2002:ab0:77d7:: with SMTP id y23mr8638431uar.4.1580112276963;
 Mon, 27 Jan 2020 00:04:36 -0800 (PST)
MIME-Version: 1.0
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 27 Jan 2020 10:04:26 +0200
Message-ID: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
Subject: Possible issue with new inauthentic AEAD in extended crypto tests
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I've ran into some problems when enabling the extended crypto tests
after commit 49763fc6b1af ("crypto: testmgr - generate inauthentic
AEAD test vectors").
After looking into the matter, I've found something that seems like a
possible problem with the tests, but I am not sure and would
appreciate your consideration:

include/crypto/aead.h has this piece of wisdom to offer:

"* It is important to note that if multiple scatter gather list entries for=
m
 * the input data mentioned above, the first entry must not point to a NULL
 * buffer. If there is any potential where the AAD buffer can be NULL, the
 * calling code must contain a precaution to ensure that this does not resu=
lt
 * in the first scatter gather list entry pointing to a NULL buffer."

However, in generate_random_aead_testvec() we have:

        /* AAD, plaintext, and ciphertext lengths */
        total_len =3D generate_random_length(maxdatasize);
        if (prandom_u32() % 4 =3D=3D 0)
                vec->alen =3D 0;
        else
                vec->alen =3D generate_random_length(total_len);
        vec->plen =3D total_len - vec->alen;
        vec->clen =3D vec->plen + authsize;

Which later calls into generate_aead_message() that has:

                int i =3D 0;
                struct scatterlist src[2], dst;
                u8 iv[MAX_IVLEN];
                DECLARE_CRYPTO_WAIT(wait);

                /* Generate a random plaintext and encrypt it. */
                sg_init_table(src, 2);
                if (vec->alen)
                        sg_set_buf(&src[i++], vec->assoc, vec->alen);
                if (vec->plen) {
                        generate_random_bytes((u8 *)vec->ptext, vec->plen);
                        sg_set_buf(&src[i++], vec->ptext, vec->plen);
                }
                sg_init_one(&dst, vec->ctext, vec->alen + vec->clen);
                memcpy(iv, vec->iv, ivsize);
                aead_request_set_callback(req, 0, crypto_req_done, &wait);
                aead_request_set_crypt(req, src, &dst, vec->plen, iv);
                aead_request_set_ad(req, vec->alen);
                vec->crypt_error =3D crypto_wait_req(crypto_aead_encrypt(re=
q),
                                                   &wait);


When both vec->alen and vec->plen are 0, which can happen as
generate_random_bytes will happily generate  zero length from time to
time,
we seem to be getting a scatterlist with the first entry (as well as
the 2nd) being a NULL.

This seems to violate the words of wisdom from aead.h and much more
important to me crashes the ccree driver :-)

Is there anything I am missing or is this a valid concern?

Thanks!
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
