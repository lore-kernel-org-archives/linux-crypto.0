Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311A2C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 047D42084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNnXfbKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfIMKNi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:38 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:46007 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbfIMKNi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:38 -0400
Received: by mail-ed1-f52.google.com with SMTP id f19so26519055eds.12
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BmzJ+L+eE6BH0kzk2/KtPKTPdKHuFbCorvSaWyKN6eE=;
        b=iNnXfbKuc7OMtjK3WZlC9iPKpae7SG27/JtO6Up7ad4bc2A4zr0oRwy2DMkXuu+HMi
         HXcKbOOLZZwUsb4kOws+Tifr4Xi6YgRbkuQgH3fCzJBHI1pE3qZl63gGjGWysvgw17In
         TlhSUReWtR4yQnabPxfNB3/NQNmAJ/EN3ckQJfs0QsVTL6RXsP+Fh6D4Z0NpAJcY7pZ7
         9Q1VKBIfZDBnIT8fjU+qx7IVHzKolqqGVIG+pfljv7tHgHv/XUD0q8lwXUBAt3FkiilD
         OXzMRVbGiTxmQJ2OStKm0RyZX6cD0WeYziweHm8sWRM1WXIvUaobuWffAyZS5rMagram
         QNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BmzJ+L+eE6BH0kzk2/KtPKTPdKHuFbCorvSaWyKN6eE=;
        b=sVHwS1VrsGTKxReOdKWGtrerdcVIVSnGdJW7NXTOECkfXiDLkg9NHDri9hPPH3S+km
         kmne8WEElWW9WX91xvQ5knwnzceENzcx8hV8K0Mf+/o0kkeuJSCvjuBACTs1yZ3M4tFY
         OaQKY6lVDigtI4K25fLu+iJOGPUH8+F2JXn90xXdFdxF3dtGKqR1jE8dDOQa2PheQjBe
         vorod1K5IUJ+NZpW6O6HY+tMnjydV+5uPPB4j/VRpnLzOpJcvXIW1hLbCr4p9migZZbw
         D0QsMA9TygoJkKTLxrMxI5TYfCl3eLRUaTPiEhIToNZE/6P/3Sd7p/NL0vORoDXOUNSZ
         zQKA==
X-Gm-Message-State: APjAAAW9M6+4tR7jH6dtHy66lng95Hk24ZJGtDHtY5DdtlL2wCbKp7sW
        QaqS7NF1Cz/4yiUrlgl6Rr67FMmc
X-Google-Smtp-Source: APXvYqyGJPEdhUflOgwOwi9W8siqDnY1dGO6KRCAVwFE0An5IyuOxn5eOuk23JEBM+KMXkZnpum9Yg==
X-Received: by 2002:a17:906:d797:: with SMTP id pj23mr604371ejb.70.1568369615448;
        Fri, 13 Sep 2019 03:13:35 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z65sm5314382ede.86.2019.09.13.03.13.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:13:34 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 7/7] crypto: testmgr - Added testvectors for the rfc3686(ctr(sm4)) skcipher
Date:   Fri, 13 Sep 2019 11:10:42 +0200
Message-Id: <1568365842-19905-8-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added testvectors for the rfc3686(ctr(sm4)) skcipher algorithm

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 crypto/testmgr.c |  6 ++++++
 crypto/testmgr.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fbc19bc..90a9f08 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5113,6 +5113,12 @@ static int alg_test_null(const struct alg_test_desc *desc,
 			.cipher = __VECS(aes_ctr_rfc3686_tv_template)
 		}
 	}, {
+		.alg = "rfc3686(ctr(sm4))",
+		.test = alg_test_skcipher,
+		.suite = {
+			.cipher = __VECS(sm4_ctr_rfc3686_tv_template)
+		}
+	}, {
 		.alg = "rfc4106(gcm(aes))",
 		.generic_driver = "rfc4106(gcm_base(ctr(aes-generic),ghash-generic))",
 		.test = alg_test_aead,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4e74f65..871d9db 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -12209,6 +12209,35 @@ struct len_range_sel {
 	}
 };
 
+static const struct cipher_testvec sm4_ctr_rfc3686_tv_template[] = {
+	{
+		.key	= "\xae\x68\x52\xf8\x12\x10\x67\xcc"
+			  "\x4b\xf7\xa5\x76\x55\x77\xf3\x9e"
+			  "\x00\x00\x00\x30",
+		.klen	= 20,
+		.iv	= "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "Single block msg",
+		.ctext	= "\x20\x9b\x77\x31\xd3\x65\xdb\xab"
+			  "\x9e\x48\x74\x7e\xbd\x13\x83\xeb",
+		.len	= 16,
+	}, {
+		.key	= "\x7e\x24\x06\x78\x17\xfa\xe0\xd7"
+			  "\x43\xd6\xce\x1f\x32\x53\x91\x63"
+			  "\x00\x6c\xb6\xdb",
+		.klen	= 20,
+		.iv	= "\xc0\x54\x3b\x59\xda\x48\xd9\x0b",
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ctext	= "\x33\xe0\x28\x01\x92\xed\xc9\x1e"
+			  "\x97\x35\xd9\x4a\xec\xd4\xbc\x23"
+			  "\x4f\x35\x9f\x1c\x55\x1f\xe0\x27"
+			  "\xe0\xdf\xc5\x43\xbc\xb0\x23\x94",
+		.len	= 32,
+	}
+};
+
 static const struct cipher_testvec sm4_ofb_tv_template[] = {
 	{ /* From: draft-ribose-cfrg-sm4-02, paragraph 12.2.3 */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
-- 
1.8.3.1

