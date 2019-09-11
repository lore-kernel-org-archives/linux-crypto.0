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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D01C5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03BC22081B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="veYtyhD+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfIKLlQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:16 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44326 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfIKLlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:16 -0400
Received: by mail-ed1-f65.google.com with SMTP id p2so19130013edx.11
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZJeyWJm87FGLCmW8I2F0yiDBqsBddN799oLnwAT+yzM=;
        b=veYtyhD+KwJva6PEvoFrHz5QMaHqNnsHkpy3buJMzdxdGKqNmumFGP31Ex0pCt+ely
         eo9gVW05kepCOQMOloR4tu97s4POY+tutl+pHXrjYzDd7OURegwbrvhDYHLSEn0NZsQS
         4rfRqpvJTmEi/+8CLL6Hm8GC93sw6IauW39+p/5l9rS5jfQAhaQxE1Jn5R1GqGCLC9Hv
         JxfEcl2NSyzAGQDLjfGhEASoK2NjpwbCtO87ikqqboYyodnjcz9Bux/N4un5e8gcLGdI
         hfpjZbi+FJftRCsmCrg0+fiNlmWMfx33Jw6L/nDAbhmBQEy45RKSnCqC6fS4s75ZtFYi
         1K1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZJeyWJm87FGLCmW8I2F0yiDBqsBddN799oLnwAT+yzM=;
        b=KPmdhq54N614MatReptMSBfKY6LnyTnHBqcSJqGdbps1twiiT2cssJOCSV/rgdI5Qq
         csU5l6VGBL1We9WDFyZwJaPy3svGdLJDrBFmtgeO0piZPjWNXThBfB/nEPbS+6wUmVmE
         2kW/RUOT9aVaCDEk0kDT7IYVcAUY7zdMukJZlLgzfufd4JvOEamkRTlEJlIy/G8Cou9D
         r3WmlrkALghc5W4etPhrEuwsexEEvSdTL6OwWFOZqa8CPgsIw9y9xZh1OPo84W9zqqH6
         1oeh4+NuKStWUQOAZ/pdYOjZk1hiDpATrGaeLjTFitpw/EJZCtlPQgxfJMAxd1CHTgcP
         ThEA==
X-Gm-Message-State: APjAAAWrGEpPQscVPrya7zBZ32eqKjJKh0PuwAffRiTZ4z/0ma1F2GA+
        Fp+PgFLXgRtWcqugdHdmJ3sctSmJ
X-Google-Smtp-Source: APXvYqwiwV5wjwn6jhvP3FCqhK6xoJLGUDBEB7U/o6N2QOfo3Y9Fw9gQDIhQ5HAYnNd8ZrUDbYQ7tg==
X-Received: by 2002:a17:907:2065:: with SMTP id qp5mr28767115ejb.151.1568202074300;
        Wed, 11 Sep 2019 04:41:14 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:13 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4) & cfb(sm4) skciphers
Date:   Wed, 11 Sep 2019 12:38:21 +0200
Message-Id: <1568198304-8101-5-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added testvectors for the ofb(sm4) and cfb(sm4) skcipher algorithms

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

