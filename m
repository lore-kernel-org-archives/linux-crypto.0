Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8AAC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A079D2054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dAejN+5s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbfHERCW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33725 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so85263784wru.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uex6NH3fEHD2Fb4AO2tkVhWWyS7SvDedMCikId0x2XQ=;
        b=dAejN+5sZrwEBwnrbyPfSWqjSePeLrWDFqTl+erYCwebfqu7XJcPIvc2K0oyjsG/wO
         HL4XfoXuwIKhGuV1snWU57SPMHU4uBeGuyzzDSFDVr/pm1oFx0dEAf0z6z1Cgv8vPBUh
         n0OY821IrmDfBp6Hy78sXmgeEtzah90DSuMBJG4CT1Cfi6AhIMx23YFQ/OyPAUaUudDO
         5XR5HEv7uJGHeuWmR3MYN8bvlVEJPkcWABNCbj/FRjU4O8rDrNxfN14ApvuTq86M20IV
         rcPiBM93eo2kfJcpAyYpSxNh93oFUTJT6zWLRoXFwrfhxdtD4YsymK+GccKsm4L2jO96
         p0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uex6NH3fEHD2Fb4AO2tkVhWWyS7SvDedMCikId0x2XQ=;
        b=iO2Q1k9Qn+4wjIRtm/FlewCguUiwZZwCERmq+/eeB9c/nh/iKonMtpwp8zGdyFU9p5
         +vIa/6p5dhHzXtAIn5jqcaR4wBkZZW9vRyBRX/QvcIrsAz/C/HlpsFH18woLh7beBGUi
         IQCpyD0Qm9KV7Rly0BsKlMhKYYFHZvkfXBjWSSyj+ZicKvfSSF9tOsIzsQfYaHV5tK9t
         kw1uJzR/ieEnIGz4TMjH+zvCj5iE47fVhwx9ZPXFqa+MybID0KI0mfjl5j8qLuiBIYtE
         tAbiWUtKLnxikfXB87ovbzc68Uok+dn3SpG0IP82IHOC+mCJgHyi39C58C/m+GI5ef7v
         ghJA==
X-Gm-Message-State: APjAAAUiPDTH55bSzYfF4XgkCWWZz+lpm2rdVtgFLBAMPcm6uRuFmXFQ
        o/0TloXYq8KVCecmeT+MgXLQ9J1ZkEUSFg==
X-Google-Smtp-Source: APXvYqzIXq7vAlx7yJ1I86e7IBkoUrkQlauSJIY3yP+RxBB+bEnzShEGlAw5Xt5hf/CBfCN0zET+Lw==
X-Received: by 2002:adf:8364:: with SMTP id 91mr161962985wrd.13.1565024539552;
        Mon, 05 Aug 2019 10:02:19 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 25/30] crypto: 3des - move verification out of exported routine
Date:   Mon,  5 Aug 2019 20:00:32 +0300
Message-Id: <20190805170037.31330-26-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of moving the shared key expansion routine into the
DES library, move the verification done by __des3_ede_setkey() into
its callers.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/des3_ede_glue.c |  4 ++++
 crypto/des_generic.c            | 10 +++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index 968386c21ef4..ec608babc22b 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -348,6 +348,10 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 i, j, tmp;
 	int err;
 
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
+		return err;
+
 	/* Generate encryption context using generic implementation. */
 	err = __des3_ede_setkey(ctx->enc_expkey, &tfm->crt_flags, key, keylen);
 	if (err < 0)
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index c4d8ecda4ddf..2a4484c8803c 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -846,10 +846,6 @@ int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 {
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
-		return err;
-
 	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	des_ekey(expkey, key);
@@ -862,8 +858,12 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u32 *expkey = dctx->expkey;
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);
+	if (err)
+		return err;
 
 	return __des3_ede_setkey(expkey, flags, key, keylen);
 }
-- 
2.17.1

