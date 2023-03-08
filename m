Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B738C64EC4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Mar 2023 17:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCHRFI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Mar 2023 12:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjCHREz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2023 12:04:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B075D8A6
        for <linux-crypto@vger.kernel.org>; Wed,  8 Mar 2023 09:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678295015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+bV6MJeZtqLU80fZFFPU6YZTkzQK1mAwlHMg0ipvOFY=;
        b=ancj2w4WNa3SfYrPLoRJYXTjm0NaNjg+2xskgRBs834bMpj2Les7J3x26ZAgEEkSxwOm7g
        Js6ZzCsi22gZHAAx4A00FI4k1z8Ckoz3doxqqvJfOWYoj2aG9QUeW7jE7Z2obtmZvzueR3
        DVTLoFKMEE/f0TPE/PZVDAtyZg10R/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-7xreSsEqMGCNlXMwQinL-g-1; Wed, 08 Mar 2023 12:03:31 -0500
X-MC-Unique: 7xreSsEqMGCNlXMwQinL-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6294E85CCE7;
        Wed,  8 Mar 2023 17:03:30 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.45.242.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D86818EC7;
        Wed,  8 Mar 2023 17:03:28 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>
Cc:     Nicolai Stange <nstange@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] crypto: jitter - panic on runtime health test failures in FIPS mode
Date:   Wed,  8 Mar 2023 18:02:33 +0100
Message-Id: <20230308170233.19475-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A FIPS certification lab has noted that the kernel doesn't go to error
state upon failure of the RCT and APT health tests. Add a panic() call
in FIPS mode to jent_kcapi_random().

Revert b454fb702515 ("crypto: jitter - don't limit ->health_failure
check to FIPS mode") for this partially.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 crypto/jitterentropy-kcapi.c | 8 ++++++++
 crypto/jitterentropy.h       | 1 +
 2 files changed, 9 insertions(+)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 2d115bec15ae..9c692119d926 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -37,6 +37,7 @@
  * DAMAGE.
  */
 
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -59,6 +60,11 @@ void jent_zfree(void *ptr)
 	kfree_sensitive(ptr);
 }
 
+int jent_fips_enabled(void)
+{
+	return fips_enabled;
+}
+
 void jent_panic(char *s)
 {
 	panic("%s", s);
@@ -140,6 +146,8 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 
 	/* Return a permanent error in case we had too many resets in a row. */
 	if (rng->reset_cnt > (1<<10)) {
+		if (jent_fips_enabled())
+			jent_panic("jitterentropy: Too many RCT/APT health test failures\n");
 		ret = -EFAULT;
 		goto out;
 	}
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index b7397b617ef0..c83fff32d130 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -2,6 +2,7 @@
 
 extern void *jent_zalloc(unsigned int len);
 extern void jent_zfree(void *ptr);
+extern int jent_fips_enabled(void);
 extern void jent_panic(char *s);
 extern void jent_memcpy(void *dest, const void *src, unsigned int n);
 extern void jent_get_nstime(__u64 *out);
-- 
2.39.2

