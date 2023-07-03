Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C711DC001B1
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jul 2023 14:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjGCOSR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jul 2023 10:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjGCOSQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2023 10:18:16 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA3BE5F
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jul 2023 07:18:14 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-307d20548adso5005471f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jul 2023 07:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688393893; x=1690985893;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k7CiJPEXfB/mPmolwvUH6t7dx6TKSOIIJmAn9VAkdqw=;
        b=BT3omfXSB3tnc4/9PQPsSKSw7cx/qjf/1NXY1wt3Q4TvbbFW5ekgxa0mQcUZPMjfeV
         nM8RiwzvvoyJ8YKGKT5FlbFzg6VWUe1ppRtzVXStYS92HDR9bLci298+IUiKjgbWycmj
         357oGZdMtDCWBYAB3AC5EYdouPZuszAUAOjyrrzu4g4lQyE137pUUFAat5oP7luo0Ffd
         jeAu+K0XLk+mez5brGbWDwfh7yPI0sxUcG5bCkgcHR9FchvUxSe8xNCRVHoDfY3ZvY60
         eDIevhPL5HNFOTVeUEmDvudJGjbpjklwSJ4RYoBNeujQKVpYijBpMHecavNIWLClwfUB
         qzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688393893; x=1690985893;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7CiJPEXfB/mPmolwvUH6t7dx6TKSOIIJmAn9VAkdqw=;
        b=QmclNN+x2x9tUm7vcv1vXL5i7LHb/Q+0KBF9HNc0iP1jo2i2Hgt8c3lwqkC/BsPYy7
         7x1vwEMh0oKB3M9ucpPGIfcI0rQtTXwz10eo9L6SN7/m5GWsCzQsqR7rt4Bgb/XCtGng
         NoDGlO1Ikny4n8C+aROXiDrLpXj7Wr7meZEJa2B6qi4H/ZyFIkMOOAeeJvtsYWJhbjmW
         8oZmgQaM4gstZlFShK5ma61iHlpiG7vA4YzAYObjFkEOBLUv9ixd9CbfWhxBCDz1hc5M
         zjRh3BLD1dR2vYTs+RV6ZXtGMCX/bmJmelBOrtMC22JMcaSLfzSEb8yOsAzyPZeudTpu
         10xw==
X-Gm-Message-State: ABy/qLa7g0zBON5Vyj278whr9pXhzeg0MCV4a8I2Amu6DQ+hO8ZEiTtr
        Aig6//kfNrBUWf+evP+GfEpxDQ==
X-Google-Smtp-Source: APBJJlEfnqKOoSS2ucE8MaIOcLJR/x7mdTN0VM771Waqqjt25CgAaEUgofxqr6Xluv6cSjS6uVAUEA==
X-Received: by 2002:a5d:4f86:0:b0:30f:c42e:3299 with SMTP id d6-20020a5d4f86000000b0030fc42e3299mr7758185wru.60.1688393892860;
        Mon, 03 Jul 2023 07:18:12 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q10-20020adfdfca000000b003141e629cb6sm9813243wrn.101.2023.07.03.07.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 07:18:11 -0700 (PDT)
Date:   Mon, 3 Jul 2023 17:18:08 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] KEYS: asymmetric: Fix error codes
Message-ID: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These error paths should return the appropriate error codes instead of
returning success.

Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 crypto/asymmetric_keys/public_key.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index e787598cb3f7..773e159dbbcb 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -185,8 +185,10 @@ static int software_key_query(const struct kernel_pkey_params *params,
 
 	if (issig) {
 		sig = crypto_alloc_sig(alg_name, 0, 0);
-		if (IS_ERR(sig))
+		if (IS_ERR(sig)) {
+			ret = PTR_ERR(sig);
 			goto error_free_key;
+		}
 
 		if (pkey->key_is_private)
 			ret = crypto_sig_set_privkey(sig, key, pkey->keylen);
@@ -208,8 +210,10 @@ static int software_key_query(const struct kernel_pkey_params *params,
 		}
 	} else {
 		tfm = crypto_alloc_akcipher(alg_name, 0, 0);
-		if (IS_ERR(tfm))
+		if (IS_ERR(tfm)) {
+			ret = PTR_ERR(tfm);
 			goto error_free_key;
+		}
 
 		if (pkey->key_is_private)
 			ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
@@ -300,8 +304,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 
 	if (issig) {
 		sig = crypto_alloc_sig(alg_name, 0, 0);
-		if (IS_ERR(sig))
+		if (IS_ERR(sig)) {
+			ret = PTR_ERR(sig);
 			goto error_free_key;
+		}
 
 		if (pkey->key_is_private)
 			ret = crypto_sig_set_privkey(sig, key, pkey->keylen);
@@ -313,8 +319,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 		ksz = crypto_sig_maxsize(sig);
 	} else {
 		tfm = crypto_alloc_akcipher(alg_name, 0, 0);
-		if (IS_ERR(tfm))
+		if (IS_ERR(tfm)) {
+			ret = PTR_ERR(tfm);
 			goto error_free_key;
+		}
 
 		if (pkey->key_is_private)
 			ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
@@ -411,8 +419,10 @@ int public_key_verify_signature(const struct public_key *pkey,
 
 	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
 		      GFP_KERNEL);
-	if (!key)
+	if (!key) {
+		ret = -ENOMEM;
 		goto error_free_tfm;
+	}
 
 	memcpy(key, pkey->key, pkey->keylen);
 	ptr = key + pkey->keylen;
-- 
2.39.2

