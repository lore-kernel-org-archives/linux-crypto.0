Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894FEECDE20
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FA1920830
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGo10uve"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfILKNG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 06:13:06 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41859 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfILKNF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 06:13:05 -0400
Received: by mail-ed1-f66.google.com with SMTP id z9so23411586edq.8
        for <linux-crypto@vger.kernel.org>; Thu, 12 Sep 2019 03:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8RK8ctadvpPxabPbDiGr6iVefXFeHDtLg1PlSuCBDmY=;
        b=BGo10uvevXt/mqWvTi9oKcm0v3Xs9NBYTEjoYL4//+/w1FSAX5z4Z1tAw/n0Z0Jqli
         omjyE02fhABmQVvZ5MPeFc414sNHXBV18OnDtPEIieBPaoG/DdQEUY4mUs1pG0+7vKhB
         aouc4w1aRIDkWzkNa5ihqZqRIAcsKonQ0zRVaA/9iyamu7Ch5jeCfdB1TLtQ6TeBDF/K
         Un5Tk1P0PxvKZxxU/4YSpay9NK16zZWnAAyInmaYR75fZpi+9fSkNy30Oh5uYsfMCeUY
         BGiJD7h1kl0wghyOCZpCPcf5Brot6p0A4jhI5gJ6vhx4xZwYHpUbbvY/jh1o59e5vKx7
         e06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8RK8ctadvpPxabPbDiGr6iVefXFeHDtLg1PlSuCBDmY=;
        b=gbDdFBMgYvH51yZWOhyQ1WNEN7BFxhthebsqov2cilEsdj7kXDM1g8qNKtzc0soceV
         SbouarLyky0yIcqAH1/sQCtECJJw5NLg0e1n+4Tj2XUBDCjjoaCJeEEBDitAjjafiDJj
         j2S3j0KoWExyvWpjQZ3FsZ+u0/m8HVWQOe7e+BjpQ105WhFtqPs0qCgBBkFZwFlnI16U
         L7dD6Y+p2vEgPIiXF7pDsXJNOUUFS8cTK6lJxjPIouWQKXv0Uqvj6HHmtxRt1nPUQw9u
         H5JQOdS5ku3dpbnI/VZOMW9l4lZ8tP4JeB+daYRX8OMyvqGJtAhxNbp6rjMscdtaLV/h
         SiDw==
X-Gm-Message-State: APjAAAW0KEGRhESlPvkWdOWhkvM+0hx1QWSNF45kjmRROvDmngzs6A7S
        0rU6ygzB10EtekubOFP5WAasr3O+
X-Google-Smtp-Source: APXvYqx3Hnxfg3tF3KcB4l9w2y2+TsG0hr8E1bZQRqPSls5xUMfsgJ82CkYu+ZHEvNttTFB0UlGyEw==
X-Received: by 2002:a50:9250:: with SMTP id j16mr41145344eda.160.1568283183722;
        Thu, 12 Sep 2019 03:13:03 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id k11sm2561499ejr.3.2019.09.12.03.13.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 03:13:03 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 3/3] crypto: testmgr - Added testvectors for the hmac(sm3) ahash
Date:   Thu, 12 Sep 2019 11:10:14 +0200
Message-Id: <1568279414-16773-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568279414-16773-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568279414-16773-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added testvectors for the hmac(sm3) ahash authentication algorithm

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 crypto/testmgr.c |  6 ++++++
 crypto/testmgr.h | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 001e62f..3604c9d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4921,6 +4921,12 @@ static int alg_test_null(const struct alg_test_desc *desc,
 			.hash = __VECS(hmac_sha512_tv_template)
 		}
 	}, {
+		.alg = "hmac(sm3)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(hmac_sm3_tv_template)
+		}
+	}, {
 		.alg = "hmac(streebog256)",
 		.test = alg_test_hash,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 25572c3..1f56293 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2935,6 +2935,62 @@ struct len_range_sel {
 	}
 };
 
+/* Example vectors below taken from
+ * GM/T 0042-2015 Appendix D.3
+ */
+static const struct hash_testvec hmac_sm3_tv_template[] = {
+	{
+		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
+			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
+			  "\x11\x12\x13\x14\x15\x16\x17\x18"
+			  "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20",
+		.ksize	= 32,
+		.plaintext = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
+			     "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
+		.psize	= 112,
+		.digest	= "\xca\x05\xe1\x44\xed\x05\xd1\x85"
+			  "\x78\x40\xd1\xf3\x18\xa4\xa8\x66"
+			  "\x9e\x55\x9f\xc8\x39\x1f\x41\x44"
+			  "\x85\xbf\xdf\x7b\xb4\x08\x96\x3a",
+	}, {
+		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
+			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
+			  "\x11\x12\x13\x14\x15\x16\x17\x18"
+			  "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
+			  "\x21\x22\x23\x24\x25",
+		.ksize	= 37,
+		.plaintext = "\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd",
+		.psize	= 50,
+		.digest	= "\x22\x0b\xf5\x79\xde\xd5\x55\x39"
+			  "\x3f\x01\x59\xf6\x6c\x99\x87\x78"
+			  "\x22\xa3\xec\xf6\x10\xd1\x55\x21"
+			  "\x54\xb4\x1d\x44\xb9\x4d\xb3\xae",
+	}, {
+		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			 "\x0b\x0b\x0b\x0b\x0b\x0b",
+		.ksize	= 32,
+		.plaintext = "Hi There",
+		.psize	= 8,
+		.digest	= "\xc0\xba\x18\xc6\x8b\x90\xc8\x8b"
+			  "\xc0\x7d\xe7\x94\xbf\xc7\xd2\xc8"
+			  "\xd1\x9e\xc3\x1e\xd8\x77\x3b\xc2"
+			  "\xb3\x90\xc9\x60\x4e\x0b\xe1\x1e",
+	}, {
+		.key	= "Jefe",
+		.ksize	= 4,
+		.plaintext = "what do ya want for nothing?",
+		.psize	= 28,
+		.digest	= "\x2e\x87\xf1\xd1\x68\x62\xe6\xd9"
+			  "\x64\xb5\x0a\x52\x00\xbf\x2b\x10"
+			  "\xb7\x64\xfa\xa9\x68\x0a\x29\x6a"
+			  "\x24\x05\xf2\x4b\xec\x39\xf8\x82",
+	},
+};
+
 /*
  * SHA1 test vectors  from from FIPS PUB 180-1
  * Long vector from CAVS 5.0
-- 
1.8.3.1

