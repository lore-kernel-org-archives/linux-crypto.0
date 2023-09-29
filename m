Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F70E71D5C
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Sep 2023 21:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjI2VRt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Sep 2023 17:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjI2VRt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2023 17:17:49 -0400
X-Greylist: delayed 527 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Sep 2023 14:17:46 PDT
Received: from mail.cyberchaos.dev (mail.cyberchaos.dev [IPv6:2a01:4f8:c012:7295::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258A51A7
        for <linux-crypto@vger.kernel.org>; Fri, 29 Sep 2023 14:17:46 -0700 (PDT)
Message-ID: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yuka.dev; s=mail;
        t=1696021736; bh=XV5Y16Sh8E+QCHNMyp4Lgqfg/vvxKHsouALRr9hLWMI=;
        h=Date:Cc:From:To:Subject;
        b=aKyw//Ump1xtGivSUOOIkvVtpybcwhTDIYGEhyyxyN3CpfDUFrx3s4ZC65EEMdq7f
         7ZUBhQhP4uRNvdcYfGr/sORZE0iNrh1Gw9RpzYa+WBwUgjq91Qm+TYv5NDVo9izWF5
         iiiMXdINxZSYX8LoB8lwRYdrzAjmT+WM5tLz8jD8=
Date:   Fri, 29 Sep 2023 23:08:55 +0200
MIME-Version: 1.0
Content-Language: en-US
Cc:     ebiggers@google.com, ebiggers@kernel.org,
        regressions@lists.linux.dev
From:   Yureka <yuka@yuka.dev>
To:     linux-crypto@vger.kernel.org
Subject: [REGRESSION] dm_crypt essiv ciphers do not use async driver
 mv-aes-cbc anymore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

#regzbot introduced: 7bcb2c99f8ed

I am running the NixOS distribution cross-compiled from x86_64 to a Marvell Armada 388 armv7 SoC.

I am not getting expected speeds when reading/writing on my encrypted hard drive with 6.5.5, while it is fast on 5.4.257. Volume is formatted like this: `cryptsetup luksFormat -c aes-cbc-essiv:sha256 /dev/sda`.

Specifically, I tracked this down to the changes to crypto/essiv.c from 7bcb2c99f8ed mentioned above. Reverting those changes on top of a 6.5.5 kernel provides working (see applicable diff further below).

I'm *guessing* that this is related to the mv-aes-cbc crypto driver (from the marvell-cesa module) being registered as async (according to /proc/crypto), and I *suspect* that async drivers are not being used anymore by essiv or dm_crypt. Going by the commit description, which sounds more like a refactor, this does not seem intentional.

Would appreciate a lot if someone more experienced with the crypto subsystem can have a look at this.


Greetings,

Yureka


---
Some more detailed information


Excerpt from /proc/crypto in 5.4.257:

name         : essiv(cbc(aes),sha256)
driver       : essiv(mv-cbc-aes,sha256-generic)
async        : yes

speeds of 130MB/s can be observed

In 5.10.197 (the first branch that has this issue and is still receiving updates):

name         : essiv(cbc(aes),sha256)
driver       : essiv(cbc(aes-arm),sha256-generic)
async        : no

speeds are less than half, 55MB/s
the other listings in /proc/crypto seem to be unchanged. mv-cbc-aes is still the highest priority driver providing cbc(aes)


diff that restores the working state on recent kernels (tested with 6.5.5):


diff --git a/crypto/essiv.c b/crypto/essiv.c
index 85bb624e32b9..8d57245add54 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -471,7 +471,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
                return PTR_ERR(shash_name);
 
        type = algt->type & algt->mask;
-       mask = crypto_algt_inherited_mask(algt);
+       mask = (algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask & CRYPTO_ALG_ASYNC;
 
        switch (type) {
        case CRYPTO_ALG_TYPE_SKCIPHER:
@@ -530,7 +530,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
        /* Synchronous hash, e.g., "sha256" */
        _hash_alg = crypto_alg_mod_lookup(shash_name,
                                          CRYPTO_ALG_TYPE_SHASH,
-                                         CRYPTO_ALG_TYPE_MASK | mask);
+                                         CRYPTO_ALG_TYPE_MASK);
        if (IS_ERR(_hash_alg)) {
                err = PTR_ERR(_hash_alg);
                goto out_drop_skcipher;
@@ -562,12 +562,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
                     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
                goto out_free_hash;
 
-       /*
-        * hash_alg wasn't gotten via crypto_grab*(), so we need to inherit its
-        * flags manually.
-        */
-       base->cra_flags        |= (hash_alg->base.cra_flags &
-                                  CRYPTO_ALG_INHERITED_FLAGS);
+       base->cra_flags         = block_base->cra_flags & CRYPTO_ALG_ASYNC;
        base->cra_blocksize     = block_base->cra_blocksize;
        base->cra_ctxsize       = sizeof(struct essiv_tfm_ctx);
        base->cra_alignmask     = block_base->cra_alignmask;


