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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CB0ECDE20
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3CCC20863
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arYIlxEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfIKIoD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 04:44:03 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38954 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKIoD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 04:44:03 -0400
Received: by mail-ed1-f65.google.com with SMTP id u6so19868494edq.6
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/EfhpaultkDrd7IBT0y0Pc89vlj4ZVcFAAL9jivLVfM=;
        b=arYIlxEUeCEkPp4lXYTRN3dkvp1iBgJ6PNxm66xCRzjf1NTWGZv9urX2EygfEYKqft
         kn4W41Ab4mwxoOzWGDCGhhtMoEVXXwIeNabnoDBR/SkPOUmX0vKeoKEOap0VBKu27V0n
         DTHma6S3nwiE1Ag8YoLWiZ+P2EPVGI/KjIlL6YxyyKInD6QwklWxiWcUPMBeLv8Kq0Ce
         o+OAC7ZOYL/oHOtjYNhJx6vbpioIbmJzkcvRNmBujaWia7DKv5ETYGpEYjT+qp+Cctvz
         biaeqoJkLnhWWSExuUvzYvN3hHjrWq/w3h5np1EcD5JrvTlWFvfwnieWSNqSS2nnk8+I
         9Frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/EfhpaultkDrd7IBT0y0Pc89vlj4ZVcFAAL9jivLVfM=;
        b=P1GqUp7fYgHJp11rCDuL1EQluL2W+ioZnJnehXrYuHO0SjIIxz7GgnSjeFaPPN8Pdn
         iYKgB44FE75yjxFkQ1wD0Z52yfJJjeFJFBoUYRfGvpOPGjha6PlApxVKZONUezLY1yNj
         ULJCv9IpZ58/XRimxdYEpgTSZDt6kE5BbtGs68ktYOazg2E6/2HVBDyX7JXe+YHQ+iDl
         se9o8VD1GlC5HDF7BXv5H1smyLPqkFF0a7ZPcuj+DoOB4egu0xNxby4M/oY2A6FFnSnJ
         hE1oD18Aha5WXUW3pdsjIs/uxSbu0t9s1rHY5r1U2P7RB7mDVDYU38Pp4E1iDOh0ge2E
         OwQA==
X-Gm-Message-State: APjAAAXYmwgoT5W6veqT8yGTu8lQxOnwqZXXzaDFiJ59MgN3YzEqN/NW
        3oohFsyvVLV5ipNdgGIzw/f1f92y
X-Google-Smtp-Source: APXvYqyZfOPIatU2CEA7yjAQ7Dsi2JseDWRvAI6BcLRz+7rF+oJE/woVshYpEFp9SpEdgwYuPBuNQQ==
X-Received: by 2002:aa7:d0d1:: with SMTP id u17mr30142895edo.99.1568191440955;
        Wed, 11 Sep 2019 01:44:00 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id h38sm207138edh.13.2019.09.11.01.44.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 01:44:00 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/3] crypto: testmgr - Added testvectors for the hmac(sm3) ahash
Date:   Wed, 11 Sep 2019 09:41:11 +0200
Message-Id: <1568187671-8540-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added testvectors for the hmac(sm3) ahash authentication algorithm

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

