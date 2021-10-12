Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD702C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93BF560E78
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJLCV0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Oct 2021 22:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhJLCVM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Oct 2021 22:21:12 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BF1C061766;
        Mon, 11 Oct 2021 19:19:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k23so14612571pji.0;
        Mon, 11 Oct 2021 19:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RCbwDqaYyU7DEfK+5zBSBE8At7VsmINx/OhzQWtobRc=;
        b=BIU0wMEUlHaLVCSYCdZXVuZrQxTEB6LELQMfT9XhEOsuEFvGWi1l3oFc6E8yeULuj8
         48bKfZcjIp0RW6D3euyOdx53LSyHzYvPyPKcehoye55iQ9eKkZX+9GezBO4o56NaJlZ3
         /CzFB4OVpKaQGL8I7JIDsscFKGP4C1kIFK5n/7lyXqhMMeFmj1PwCn8RvIyKnzqD/Pkt
         IoJBusZ/KYZbNR9nwVU3KX9tt8ivtxmHXE28OzUX0Lj5z8dce13QyFsVR5rgw9G80NqY
         Hp/kK5u1q4eN92VwJoDicyEi9x5hdSLSU3ezi3XxzsJ2x2N2CscWeBkNxfwOVf3CiMy9
         6EIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RCbwDqaYyU7DEfK+5zBSBE8At7VsmINx/OhzQWtobRc=;
        b=jytSUP5XT3LqHLiPCcO6Sc2sdxJGEuTFL5mVpFeIgCn5eIVePy9JrWjWhNMi0U4ZWj
         Yv4TXH37IChlS/x/vlA4O5UoE8q1G5QwB5jyel4ObYdSNJ7rKhVjcGwxY/ioE5hw6qP7
         fzHz99u/ARH08fi4dRrIT2iKCGppQ0/q4IjHIFbufasNfhbkWrZerEyrKhiOj2Kmqz9z
         7sKR4yuSYPHs1bT+9CX7rDqv8lSJhjIW90TcDalI6igexkjXdmwlD7/dU2XyEdDSisQX
         7JJYMxwdOno4ae9ogRly8jBRu42l0ThpbCJKL7+2f6WcMN3YJR0uMNzu3LJ99b/xK+G3
         wAsQ==
X-Gm-Message-State: AOAM531Sq9MhK5ZJ4tZJP4aMVhpeoCzrbtldVBc8NBY5qFUXLjDYOMHe
        IJije4cch4gRx9lUFCM2NSu2pEWNzNw=
X-Google-Smtp-Source: ABdhPJy+OiKp8N2Qrs4ql0S67qxXpzBBzooL62cf1M7grRFHC/qhGeXCsIM6sEterZ33/FDAIZ7pxA==
X-Received: by 2002:a17:903:1103:b0:13e:ec6d:524a with SMTP id n3-20020a170903110300b0013eec6d524amr27349238plh.85.1634005139331;
        Mon, 11 Oct 2021 19:18:59 -0700 (PDT)
Received: from localhost.localdomain ([162.14.23.249])
        by smtp.gmail.com with ESMTPSA id l207sm8963835pfd.199.2021.10.11.19.18.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Oct 2021 19:18:58 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] crypto: add eddsa test vector
Date:   Tue, 12 Oct 2021 10:17:56 +0800
Message-Id: <1634005076-17534-6-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
References: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

This patch adds the test vector for ed25519.
The test vector is from RFC8032 section 7.1 [1]

[1]https://datatracker.ietf.org/doc/html/rfc8032#section-7.1

Signed-off-by: Hongbo Li <herberthbli@tencent.com>
---
 crypto/testmgr.c |  6 ++++++
 crypto/testmgr.h | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 58eee8e..e795b6a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4968,6 +4968,12 @@ static int alg_test_null(const struct alg_test_desc *desc,
 			.akcipher = __VECS(ecrdsa_tv_template)
 		}
 	}, {
+		.alg = "eddsa-25519",
+		.test = alg_test_akcipher,
+		.suite = {
+			.akcipher = __VECS(eddsa_25519_tv_template)
+		}
+	}, {
 		.alg = "essiv(authenc(hmac(sha256),cbc(aes)),sha256)",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e6fca34..b5f291c 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1145,6 +1145,38 @@ struct kpp_testvec {
 };
 
 /*
+ * EDDSA test vectors.
+ * From RFC8032 section 7.1
+ */
+static const struct akcipher_testvec eddsa_25519_tv_template[] = {
+	{
+	.key =
+	"\x3d\x40\x17\xc3\xe8\x43\x89\x5a\x92\xb7\x0a\xa7\x4d\x1b\x7e\xbc"
+	"\x9c\x98\x2c\xcf\x2e\xc4\x96\x8c\xc0\xcd\x55\xf1\x2a\xf4\x66\x0c",
+	.key_len = 32,
+	/*
+	 * RFC8032 section 5.1.7. m is SHA512(dom2(F, C) || R || A || PH(M))
+	 * M is 0x72
+	 */
+	.m =
+	"\xa2\x71\xdf\x0d\x2b\x0d\x03\xbd\x17\xb4\xed\x9a\x4b\x6a\xfd\xdf"
+	"\x2e\x73\x28\x7f\xd6\x30\xf1\xa1\x37\xd8\x7c\xe8\x73\xa5\x91\xcc"
+	"\x31\xb6\xdd\x85\x2a\x98\xb5\xdd\x12\x26\xfe\x99\x3d\x82\x28\x27"
+	"\x8c\xeb\xa2\x1f\x80\xb8\xfc\x95\x98\x6a\x70\xd7\x1e\xdf\x3f\xaf",
+	.m_size = 64,
+	.c =
+	"\x92\xa0\x09\xa9\xf0\xd4\xca\xb8\x72\x0e\x82\x0b\x5f\x64\x25\x40"
+	"\xa2\xb2\x7b\x54\x16\x50\x3f\x8f\xb3\x76\x22\x23\xeb\xdb\x69\xda"
+	"\x08\x5a\xc1\xe4\x3e\x15\x99\x6e\x45\x8f\x36\x13\xd0\xf1\x1d\x8c"
+	"\x38\x7b\x2e\xae\xb4\x30\x2a\xee\xb0\x0d\x29\x16\x12\xbb\x0c\x00",
+	.c_size = 64,
+	.algo = OID_ed25519,
+	.public_key_vec = true,
+	.siggen_sigver_test = true,
+	}
+};
+
+/*
  * PKCS#1 RSA test vectors. Obtained from CAVS testing.
  */
 static const struct akcipher_testvec pkcs1pad_rsa_tv_template[] = {
-- 
1.8.3.1

