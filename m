Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E1AC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7945C206A5
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="2EFhTRsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfLLPdk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 10:33:40 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:42571 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbfLLPdk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 10:33:40 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 55b4bcd0
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :from:date:message-id:subject:to:cc:content-type; s=mail; bh=E2V
        cdkD3abkaVwURvKw+X676+JI=; b=2EFhTRslyiQBfMM5cjL8GcmCLAc06sStZMl
        yseH970Ara10AB3fJ9uIWSvk1kJrX0Pib6PBBLGatjGLz1+YpbD/MAgzC1IbpwPW
        1WpcwGYRqPGJRfSI8ebWLwGTR9wSgxAer1Xt9t1s/ZphM60ZtrE4ExTC0yo37AJ/
        u5G6QsPjPzGFkIQ0H+gZdfSlRKVooFMN3cw8ocmKpP7/SJ/cSs8qQtiKoq3gk04S
        jzAg6AF7qVUzRLy5JaZR74NSthLgn8xm31uiGLV/QLqmJ/Y/m6N3whbInx3nxdUq
        MbHdNZQ4FD8Aewu777KSCr+Ea+PVgFeK0weh6wN6xFMbi6hakIw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bd3b1413 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 14:37:49 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id x195so722737oix.4
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 07:33:37 -0800 (PST)
X-Gm-Message-State: APjAAAXCXAJAz1W3TUKoCnb2WurEZnuKWGrp0nAdkmdOo8hMkmmgfaAL
        6u/HLjNAX7xL4YoTBwHv5YnotRqdS7FCIFAqLJg=
X-Google-Smtp-Source: APXvYqykSF34W1hv3PJNhk51zmEuRlVQOe+lb62bOGraTECvcI9S2VrE99qYCsHQjLmbh1IRAvM8u06IdSZ/6QDBPcc=
X-Received: by 2002:aca:5cc1:: with SMTP id q184mr4473597oib.122.1576164816891;
 Thu, 12 Dec 2019 07:33:36 -0800 (PST)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 16:33:25 +0100
X-Gmail-Original-Message-ID: <CAHmME9o4s3B_KUKYAzJr6xNaKdiLSGMJz-EyzP7RUptya1FqMg@mail.gmail.com>
Message-ID: <CAHmME9o4s3B_KUKYAzJr6xNaKdiLSGMJz-EyzP7RUptya1FqMg@mail.gmail.com>
Subject: adiantum testmgr tests not running?
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Eric,

I had to do this ugly hack to get the adiantum testmgr tests running.
Did you wind up doing the same when developing it, or was there some
other mechanism that invoked this naturally? I see all the other
primitives running, but not adiantum.

Jason

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index 8beea79ab117..f446b19429e9 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -117,7 +117,9 @@ static struct skcipher_alg algs[] = {

 static int __init chacha_generic_mod_init(void)
 {
- return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+ int ret = crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+ BUG_ON(alg_test("adiantum(xchacha20,aes)", "adiantum", 0, 0));
+ return ret;
 }

 static void __exit chacha_generic_mod_fini(void)
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82513b6b0abd..7de24e431c5e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5328,7 +5328,7 @@ int alg_test(const char *driver, const char
*alg, u32 type, u32 mask)
        driver, alg, fips_enabled ? "fips" : "panic_on_fail");
  }

- if (fips_enabled && !rc)
+ if (!rc)
  pr_info("alg: self-tests for %s (%s) passed\n", driver, alg);

  return rc;
