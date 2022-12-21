Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2005C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 22:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiLUWnH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiLUWmx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 17:42:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801391A3A7
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 14:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671662527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwfJcVBxWNMAZYpPSPCoOdNBGIp3nX0+9louWAKvFDk=;
        b=hVF82NH0j00tHKU2ij82hcpa0HAcwKcYnZdt7JfvglQQAcu2eCIcN+83acx/9MuXqliF8k
        VeyPYu1rtuMES4YEr1igpx+plp2gUYUQNoEdnq+r3sf3+Iw2VydMUdk653BQ4wi65Hub4j
        dVRYiAvVFLtZZP/oo/vp5O5rWc13/V8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-2MYamv_BNpCM3A4WlGyW7A-1; Wed, 21 Dec 2022 17:42:06 -0500
X-MC-Unique: 2MYamv_BNpCM3A4WlGyW7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF71229AA39D;
        Wed, 21 Dec 2022 22:42:05 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-11.brq.redhat.com [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD71240C2064;
        Wed, 21 Dec 2022 22:42:03 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     nstange@suse.de, elliott@hpe.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, smueller@chronox.de,
        vdronov@redhat.com
Subject: [PATCH 3/6] crypto: xts - drop redundant xts key check
Date:   Wed, 21 Dec 2022 23:41:08 +0100
Message-Id: <20221221224111.19254-4-vdronov@redhat.com>
In-Reply-To: <20221221224111.19254-1-vdronov@redhat.com>
References: <20221221224111.19254-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

xts_fallback_setkey() in xts_aes_set_key() will now enforce key size
rule in FIPS mode when setting up the fallback algorithm keys, which
makes the check in xts_aes_set_key() redundant or unreachable. So just
drop this check.

xts_fallback_setkey() now makes a key size check in xts_verify_key():

xts_fallback_setkey()
  crypto_skcipher_setkey() [ skcipher_setkey_unaligned() ]
    cipher->setkey() { .setkey = xts_setkey }
      xts_setkey()
        xts_verify_key()

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 arch/s390/crypto/aes_s390.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 526c3f40f6a2..c773820e4af9 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -398,10 +398,6 @@ static int xts_aes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	if (err)
 		return err;
 
-	/* In fips mode only 128 bit or 256 bit keys are valid */
-	if (fips_enabled && key_len != 32 && key_len != 64)
-		return -EINVAL;
-
 	/* Pick the correct function code based on the key length */
 	fc = (key_len == 32) ? CPACF_KM_XTS_128 :
 	     (key_len == 64) ? CPACF_KM_XTS_256 : 0;
-- 
2.38.1

