Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05100C3DA79
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Dec 2022 21:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiL2VS2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiL2VSQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2022 16:18:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEC4B1FB
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2022 13:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672348650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwfJcVBxWNMAZYpPSPCoOdNBGIp3nX0+9louWAKvFDk=;
        b=f1NV6GOqRiqIdq++hALy60SCsJUPg1zt3YgCIMj4uFYdecF2q1FgVm5gfYyVgt0T5K5MTz
        LgkppS6sBP0rh2t5Rf2FM8qEbx6nNB5ajlfpDeOXC+VLcEk2dbTUYvaM72sW2Ahy2M1Gb6
        MoT9ippB9jhgnd4ozNx5cTwoRnUOWIM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-JWXU0-KVNMuepvPYIMb6zQ-1; Thu, 29 Dec 2022 16:17:28 -0500
X-MC-Unique: JWXU0-KVNMuepvPYIMb6zQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D113B8F6E83;
        Thu, 29 Dec 2022 21:17:27 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-2.brq.redhat.com [10.40.208.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E13B492B00;
        Thu, 29 Dec 2022 21:17:25 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Nicolai Stange <nstange@suse.de>, Elliott Robert <elliott@hpe.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH v3 3/6] crypto: xts - drop redundant xts key check
Date:   Thu, 29 Dec 2022 22:17:07 +0100
Message-Id: <20221229211710.14912-4-vdronov@redhat.com>
In-Reply-To: <20221229211710.14912-1-vdronov@redhat.com>
References: <20221229211710.14912-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

