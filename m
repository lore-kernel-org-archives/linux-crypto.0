Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C9AC49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C74F2084D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhz8prZ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfIKLlU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:20 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42285 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfIKLlT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:19 -0400
Received: by mail-ed1-f66.google.com with SMTP id y91so20312652ede.9
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ukf+OSUzP8N1TVcFNeRCeAfhchGbzedXKuqObB/X8Kw=;
        b=hhz8prZ7YaEA6WAVCs+X7TzTYDXeqTqhRrZmZGMi9NTkfu9gG3aJgnoU9mTmd/VRcb
         UywBluP8ySqBmNOfXzCJI+Hqhrwgpuv1mBOFjAlWq65GjM29RkbA9DLcN0TFaq+CNnXc
         eYrUhFDgqSdi5kjiQn9+Y+dqzm3p7nA8wcw9GPpCN34ZWq+LrXq+NlX3dEu+Cp0XiIk1
         oGCxRbqbNI6Yi+zzrnOu99oCTRfsWRDU6th3Xhu7QAdFy9vbK9iQYbYGgXdA411X4V/f
         GUcWoBx/i9Wph1srLQaPj7aisUOe6LWm0s2ZrMM8ipqRjsCK8eC5UIR0IobOwMSeAWTg
         4WMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ukf+OSUzP8N1TVcFNeRCeAfhchGbzedXKuqObB/X8Kw=;
        b=f90QzwH4phEppddzy3axfdqdaHuOxDxgUUGjNMYYozEywEXV8qeCNSYOOpLtnm6YOC
         glxbGNuU4CzvrFDLbCwnF4rvnjj+hQkGypgDcoyxbJcCMZIuAFdaloxFjx/exTvqdZZV
         hdIJlMeYajDZ+NcZuneyN3fbXjEprTS24oZz0je9mXKfJ7bo7GGu05UzZ5hP695a2JkV
         YTRUUPPBy2m7dBpcluzkl5A6cwW2JVrNMC6P4cMSZSsNbIqfjbtf3FGETa9pqyYweFq5
         Mmr4zs2o7DfogP+c9pLpePmMughUiClJ2cKMJUT1wLAncLLtFXBfXzauxXopXixECyqW
         IlaA==
X-Gm-Message-State: APjAAAXQniU7gWxfWlm6nmmFJG6hk2VXzMM6RpGL7iV1pc7sq89m/SDy
        2R6LP6pXBTKsBXr9X5I9y4TH7N0r
X-Google-Smtp-Source: APXvYqy+KmVZrrTn0seH9nttE57d9P0bTG7+4lzE2NBYD0Ij+YzLvoiA15MrazOSD+F2DoB5zPcRaQ==
X-Received: by 2002:a17:906:1196:: with SMTP id n22mr1153052eja.60.1568202076326;
        Wed, 11 Sep 2019 04:41:16 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:15 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 7/7] crypto: testmgr - Added testvectors for the rfc3686(ctr(sm4)) skcipher
Date:   Wed, 11 Sep 2019 12:38:24 +0200
Message-Id: <1568198304-8101-8-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added testvectors for the rfc3686(ctr(sm4)) skcipher algorithm

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

