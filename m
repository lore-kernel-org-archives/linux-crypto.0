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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F59C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53C642084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmfsMcok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388089AbfIMKNf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:35 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:33268 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729400AbfIMKNf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:35 -0400
Received: by mail-ed1-f41.google.com with SMTP id o9so26609297edq.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/ZQzikusrvut9Tft7+Ud9j6ojpilkMk2RA3YvhktNL8=;
        b=XmfsMcok9b71/yaCZ/RcKzqXud0OodrdWu0PUGVj/f77eIHSwx1iJm9E+MB/Q60tXM
         nJwCxPHbb5/SEusi98Oq1h4qA9dupWkkaHlZZLRc/rrK38fk1rcSFtJ5Wv4OUEq3N8tG
         F5Tj8r7nwli20E4oJqbvb56o3Fza4WKu2F3r29pkHJAiUmpOZnO8W+RvRfBd/BF4Qup7
         XEgchi5JeuvbPH+IYBtaNxIE1yOrMfHPZS6DEAffKke3HhnlAcsSh8Qa3mZJxLqaeuyN
         AYU4iqBEP6XM0J51Ru7rYEp9DH4PF/dYu+/+nMDHrrn5P0ZmXmE3kDvhTF8oqFJ6uXZD
         D6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/ZQzikusrvut9Tft7+Ud9j6ojpilkMk2RA3YvhktNL8=;
        b=rjdyM2NyRDnnmV7l3Ac75T6DhOtDjC4Rr9FNilUgvdTeVZ2ZdXBjtSN8TrCoMRQxNV
         RvCh2Sgg5mKaXQVm15DNrF9dMCutwlCmc+iyFAsZ5GgcnqE86pJWriVpRtRBLQyA5Ax9
         jCyVTzT03dfl/CbtpE8TipczCzeHFagDjJlEuEZktlI75yFWULz/h2QZyaj4DVSvKxlb
         jywcZlIa6viFa4pzj5eXPTcGciJ1b8cKpsfQmhYVkOEiV6aVF9Alk4lZeMvxLqHVHeq/
         ZguSDwlmF/k1iLLlwWsxFsh74OZ+9KWE305CM4GiGwoTFzo8AB4QtGsbgp5Qy/Z+OsTT
         XIAA==
X-Gm-Message-State: APjAAAUVscmLhDolpAvsUGvFy9G13JfaR2V4F40FxQ3jtpgmV8ow0p8e
        /33plFy92y2HJhclFIRQPLXerUY1
X-Google-Smtp-Source: APXvYqz6gUs+xAERJxJugxst0n+50ooMP8ZNVgu6McRfbOaUvMgtkLgf/t7mBGL1tQuqqBHTW5PzaQ==
X-Received: by 2002:a17:906:5215:: with SMTP id g21mr34892978ejm.105.1568369613140;
        Fri, 13 Sep 2019 03:13:33 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z65sm5314382ede.86.2019.09.13.03.13.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:13:32 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 4/7] crypto: testmgr - Added testvectors for the ofb(sm4) & cfb(sm4) skciphers
Date:   Fri, 13 Sep 2019 11:10:39 +0200
Message-Id: <1568365842-19905-5-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added testvectors for the ofb(sm4) and cfb(sm4) skcipher algorithms

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 crypto/testmgr.c | 12 +++++++
 crypto/testmgr.h | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3604c9d..fbc19bc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4406,6 +4406,12 @@ static int alg_test_null(const struct alg_test_desc *desc,
 			.cipher = __VECS(aes_cfb_tv_template)
 		},
 	}, {
+		.alg = "cfb(sm4)",
+		.test = alg_test_skcipher,
+		.suite = {
+			.cipher = __VECS(sm4_cfb_tv_template)
+		}
+	}, {
 		.alg = "chacha20",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -5063,6 +5069,12 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "ofb(sm4)",
+		.test = alg_test_skcipher,
+		.suite = {
+			.cipher = __VECS(sm4_ofb_tv_template)
+		}
+	}, {
 		.alg = "pcbc(fcrypt)",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 1f56293..4e74f65 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -12209,6 +12209,104 @@ struct len_range_sel {
 	}
 };
 
+static const struct cipher_testvec sm4_ofb_tv_template[] = {
+	{ /* From: draft-ribose-cfrg-sm4-02, paragraph 12.2.3 */
+		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.klen	= 16,
+		.iv	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.ptext	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10"
+			  "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.ctext	= "\x69\x3d\x9a\x53\x5b\xad\x5b\xb1"
+			  "\x78\x6f\x53\xd7\x25\x3a\x70\x56"
+			  "\xf2\x07\x5d\x28\xb5\x23\x5f\x58"
+			  "\xd5\x00\x27\xe4\x17\x7d\x2b\xce",
+		.len	= 32,
+	}, { /* From: draft-ribose-cfrg-sm4-09, appendix A.2.3, Example 1 */
+		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb"
+			  "\xcc\xcc\xcc\xcc\xdd\xdd\xdd\xdd"
+			  "\xee\xee\xee\xee\xff\xff\xff\xff"
+			  "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb",
+		.ctext	= "\xac\x32\x36\xcb\x86\x1d\xd3\x16"
+			  "\xe6\x41\x3b\x4e\x3c\x75\x24\xb7"
+			  "\x1d\x01\xac\xa2\x48\x7c\xa5\x82"
+			  "\xcb\xf5\x46\x3e\x66\x98\x53\x9b",
+		.len	= 32,
+	}, { /* From: draft-ribose-cfrg-sm4-09, appendix A.2.3, Example 2 */
+		.key	= "\xfe\xdc\xba\x98\x76\x54\x32\x10"
+			  "\x01\x23\x45\x67\x89\xab\xcd\xef",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb"
+			  "\xcc\xcc\xcc\xcc\xdd\xdd\xdd\xdd"
+			  "\xee\xee\xee\xee\xff\xff\xff\xff"
+			  "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb",
+		.ctext	= "\x5d\xcc\xcd\x25\xa8\x4b\xa1\x65"
+			  "\x60\xd7\xf2\x65\x88\x70\x68\x49"
+			  "\x33\xfa\x16\xbd\x5c\xd9\xc8\x56"
+			  "\xca\xca\xa1\xe1\x01\x89\x7a\x97",
+		.len	= 32,
+	}
+};
+
+static const struct cipher_testvec sm4_cfb_tv_template[] = {
+	{ /* From: draft-ribose-cfrg-sm4-02, paragraph 12.2.4 */
+		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.klen	= 16,
+		.iv	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.ptext	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10"
+			  "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.ctext	= "\x69\x3d\x9a\x53\x5b\xad\x5b\xb1"
+			  "\x78\x6f\x53\xd7\x25\x3a\x70\x56"
+			  "\x9e\xd2\x58\xa8\x5a\x04\x67\xcc"
+			  "\x92\xaa\xb3\x93\xdd\x97\x89\x95",
+		.len	= 32,
+	}, { /* From: draft-ribose-cfrg-sm4-09, appendix A.2.4, Example 1 */
+		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
+			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb"
+			  "\xcc\xcc\xcc\xcc\xdd\xdd\xdd\xdd"
+			  "\xee\xee\xee\xee\xff\xff\xff\xff"
+			  "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb",
+		.ctext	= "\xac\x32\x36\xcb\x86\x1d\xd3\x16"
+			  "\xe6\x41\x3b\x4e\x3c\x75\x24\xb7"
+			  "\x69\xd4\xc5\x4e\xd4\x33\xb9\xa0"
+			  "\x34\x60\x09\xbe\xb3\x7b\x2b\x3f",
+		.len	= 32,
+	}, { /* From: draft-ribose-cfrg-sm4-09, appendix A.2.4, Example 2 */
+		.key	= "\xfe\xdc\xba\x98\x76\x54\x32\x10"
+			  "\x01\x23\x45\x67\x89\xab\xcd\xef",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb"
+			  "\xcc\xcc\xcc\xcc\xdd\xdd\xdd\xdd"
+			  "\xee\xee\xee\xee\xff\xff\xff\xff"
+			  "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb",
+		.ctext	= "\x5d\xcc\xcd\x25\xa8\x4b\xa1\x65"
+			  "\x60\xd7\xf2\x65\x88\x70\x68\x49"
+			  "\x0d\x9b\x86\xff\x20\xc3\xbf\xe1"
+			  "\x15\xff\xa0\x2c\xa6\x19\x2c\xc5",
+		.len	= 32,
+	}
+};
+
 /* Cast6 test vectors from RFC 2612 */
 static const struct cipher_testvec cast6_tv_template[] = {
 	{
-- 
1.8.3.1

