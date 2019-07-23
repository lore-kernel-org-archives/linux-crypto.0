Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E659C7618E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 11:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CFFE20840
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 11:48:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="wqrcayfx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfGWLsI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 07:48:08 -0400
Received: from condef-08.nifty.com ([202.248.20.73]:58410 "EHLO
        condef-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfGWLsH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 07:48:07 -0400
Received: from conuserg-12.nifty.com ([10.126.8.75])by condef-08.nifty.com with ESMTP id x6NBiS1V002556
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2019 20:44:28 +0900
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x6NBhmf0024789;
        Tue, 23 Jul 2019 20:43:50 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x6NBhmf0024789
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1563882231;
        bh=u6S/fgiuE+3dTn82HkRiRqcnW+Gorb07kShUnm4uj7Y=;
        h=From:To:Cc:Subject:Date:From;
        b=wqrcayfxFNlDjAC9RpZEL2PesO7h9y4nrwAe2czjUnSuiZ2zeu6Q8D1HrMinDwoUB
         lGDwc0fiZicMX83K79xv4/L+NM+S3ZVjiRxnqJtddqqv00941jhO0h7uggos3hdX04
         wBYl2LC+JytfzxmJoSfK8lfkK10l9UYTV5lz86DAP24AgS3X7LwvibFqpwAhzmjVxm
         n0fwzRviw/a7RSkHTlCJj098Y9sy5WL4+93PEHwER86qeGULD+rQNYQfBjIuhibU1T
         qDKk4fMTDp2fQa0cteHMDEUIyqJdcytDMgWj/rnY3PsEgn25IGLUOCB0X22hukOrWv
         4kv6O/EJm61bA==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: add header include guards
Date:   Tue, 23 Jul 2019 20:43:43 +0900
Message-Id: <20190723114344.18622-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add header include guards in case they are included multiple times.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

Changes in v2: None

 include/crypto/sha1_base.h      | 5 +++++
 include/crypto/sha256_base.h    | 5 +++++
 include/crypto/sha512_base.h    | 5 +++++
 include/crypto/sm3_base.h       | 5 +++++
 include/uapi/linux/cryptouser.h | 5 +++++
 5 files changed, 25 insertions(+)

diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
index 63c14f2dc7bd..20fd1f7468af 100644
--- a/include/crypto/sha1_base.h
+++ b/include/crypto/sha1_base.h
@@ -5,6 +5,9 @@
  * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#ifndef _CRYPTO_SHA1_BASE_H
+#define _CRYPTO_SHA1_BASE_H
+
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <linux/crypto.h>
@@ -101,3 +104,5 @@ static inline int sha1_base_finish(struct shash_desc *desc, u8 *out)
 	*sctx = (struct sha1_state){};
 	return 0;
 }
+
+#endif /* _CRYPTO_SHA1_BASE_H */
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index 59159bc944f5..b50a035a2bc7 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -5,6 +5,9 @@
  * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#ifndef _CRYPTO_SHA256_BASE_H
+#define _CRYPTO_SHA256_BASE_H
+
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <linux/crypto.h>
@@ -123,3 +126,5 @@ static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
 	*sctx = (struct sha256_state){};
 	return 0;
 }
+
+#endif /* _CRYPTO_SHA256_BASE_H */
diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
index 099be8027f3f..fb19c77494dc 100644
--- a/include/crypto/sha512_base.h
+++ b/include/crypto/sha512_base.h
@@ -5,6 +5,9 @@
  * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#ifndef _CRYPTO_SHA512_BASE_H
+#define _CRYPTO_SHA512_BASE_H
+
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <linux/crypto.h>
@@ -126,3 +129,5 @@ static inline int sha512_base_finish(struct shash_desc *desc, u8 *out)
 	*sctx = (struct sha512_state){};
 	return 0;
 }
+
+#endif /* _CRYPTO_SHA512_BASE_H */
diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
index 31891b0dc7e3..1cbf9aa1fe52 100644
--- a/include/crypto/sm3_base.h
+++ b/include/crypto/sm3_base.h
@@ -6,6 +6,9 @@
  * Written by Gilad Ben-Yossef <gilad@benyossef.com>
  */
 
+#ifndef _CRYPTO_SM3_BASE_H
+#define _CRYPTO_SM3_BASE_H
+
 #include <crypto/internal/hash.h>
 #include <crypto/sm3.h>
 #include <linux/crypto.h>
@@ -104,3 +107,5 @@ static inline int sm3_base_finish(struct shash_desc *desc, u8 *out)
 	*sctx = (struct sm3_state){};
 	return 0;
 }
+
+#endif /* _CRYPTO_SM3_BASE_H */
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 4dc1603919ce..5730c67f0617 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -19,6 +19,9 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#ifndef _UAPI_LINUX_CRYPTOUSER_H
+#define _UAPI_LINUX_CRYPTOUSER_H
+
 #include <linux/types.h>
 
 /* Netlink configuration messages.  */
@@ -198,3 +201,5 @@ struct crypto_report_acomp {
 
 #define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
 			       sizeof(struct crypto_report_blkcipher))
+
+#endif /* _UAPI_LINUX_CRYPTOUSER_H */
-- 
2.17.1

