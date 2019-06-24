Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E2FC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7C762089F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ks4afDpG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfFXHie (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:38:34 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:56262 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFXHie (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:38:34 -0400
Received: by mail-wm1-f46.google.com with SMTP id a15so11714810wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 00:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGyMTMnEnmfpuuNXf+kr/+c5q+YqlmYZacjCBN2vQcA=;
        b=ks4afDpGmz7AEkmqzocmxBMmnx4ccAywUGq3s5K8VRlJjzKlkaewMwT33lNFF1f3p0
         2znOrZoDv3oJ0Ct1oGVhVYE3CGSvuDS/S1jCF9Gj246Ijw3cXplRi35OX/N7KFxz1Ids
         N6ED6uwdR4RRSupXQJ8gcJXZi7l4KMdKfkyciMwyhiES+aIR0AubgDtqzPu0e7tal/4k
         w6MesfjMAqohVWqugFBMLNYv1IYAg9kJ8ui9UNprwcn124bSqcObf9Wwx4jpJnySOUGo
         3peHcr3FrPnhhwFIZbbHeegFLFzqcups0pdW0OBkyi/qdzRAr/l8FId77u+HuVsfd7yC
         PQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGyMTMnEnmfpuuNXf+kr/+c5q+YqlmYZacjCBN2vQcA=;
        b=qHt+UVv9sATRKrhZ4UVl0mvzQ7OB6nW4bNCKpMliYzonLKVO9JI6X21OVCLe81AtZV
         9Ol0et9CZ4pzMPqXERoNNYALFawmonWGkV1lXKdOVbiLa/ir1sJFUl1xXrGkdn53DDLc
         wu0grT67lCbD+yatc8l8QysXCmtkYR6TIePwSR2ObeiMC3wMYvOJZYoNOH9hNDhC/Pzm
         fvjt+BuA49GEhB4raLs8qbYzFHu/0LZPdPx+n79IIOcwtsmH5u91cOH9j/bqO1d74uJc
         F6LF3T9iC9dCH8grBEQMgKurC8QVa+UeWQ8YpBsevM6Txnoz9cBmmoQWaPUmv0LVi1RO
         GNBw==
X-Gm-Message-State: APjAAAU4DaHjcA8ScJDduShCtaKGJuPF+NCWz6u5b+Tx9cx3noWW0jQG
        jRqmApCBWtLEnf2OGJCxK4afXJNj13BiaQ==
X-Google-Smtp-Source: APXvYqyQemsHDH1snkHDlRmvBVHNkTuLaGqWRu7VAdW1Q7D82Zp29FgrPEIWR+QsWb5D+pgdvJ9Etw==
X-Received: by 2002:a1c:7d02:: with SMTP id y2mr14631078wmc.15.1561361911279;
        Mon, 24 Jun 2019 00:38:31 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4866:7cdc:a930:8455])
        by smtp.gmail.com with ESMTPSA id 203sm7419280wmc.30.2019.06.24.00.38.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:38:30 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Subject: [PATCH 2/6] crypto: aegis - drop empty TFM init/exit routines
Date:   Mon, 24 Jun 2019 09:38:14 +0200
Message-Id: <20190624073818.29296-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

TFM init/exit routines are optional, so no need to provide empty ones.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128.c  | 11 -----------
 crypto/aegis128l.c | 11 -----------
 crypto/aegis256.c  | 11 -----------
 3 files changed, 33 deletions(-)

diff --git a/crypto/aegis128.c b/crypto/aegis128.c
index 125e11246990..4f8f1cdef129 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -403,22 +403,11 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
 
-static int crypto_aegis128_init_tfm(struct crypto_aead *tfm)
-{
-	return 0;
-}
-
-static void crypto_aegis128_exit_tfm(struct crypto_aead *tfm)
-{
-}
-
 static struct aead_alg crypto_aegis128_alg = {
 	.setkey = crypto_aegis128_setkey,
 	.setauthsize = crypto_aegis128_setauthsize,
 	.encrypt = crypto_aegis128_encrypt,
 	.decrypt = crypto_aegis128_decrypt,
-	.init = crypto_aegis128_init_tfm,
-	.exit = crypto_aegis128_exit_tfm,
 
 	.ivsize = AEGIS128_NONCE_SIZE,
 	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
diff --git a/crypto/aegis128l.c b/crypto/aegis128l.c
index 9bca3d619a22..ef5bc2297a2c 100644
--- a/crypto/aegis128l.c
+++ b/crypto/aegis128l.c
@@ -467,22 +467,11 @@ static int crypto_aegis128l_decrypt(struct aead_request *req)
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
 
-static int crypto_aegis128l_init_tfm(struct crypto_aead *tfm)
-{
-	return 0;
-}
-
-static void crypto_aegis128l_exit_tfm(struct crypto_aead *tfm)
-{
-}
-
 static struct aead_alg crypto_aegis128l_alg = {
 	.setkey = crypto_aegis128l_setkey,
 	.setauthsize = crypto_aegis128l_setauthsize,
 	.encrypt = crypto_aegis128l_encrypt,
 	.decrypt = crypto_aegis128l_decrypt,
-	.init = crypto_aegis128l_init_tfm,
-	.exit = crypto_aegis128l_exit_tfm,
 
 	.ivsize = AEGIS128L_NONCE_SIZE,
 	.maxauthsize = AEGIS128L_MAX_AUTH_SIZE,
diff --git a/crypto/aegis256.c b/crypto/aegis256.c
index b47fd39595ad..b824ef4d1248 100644
--- a/crypto/aegis256.c
+++ b/crypto/aegis256.c
@@ -418,22 +418,11 @@ static int crypto_aegis256_decrypt(struct aead_request *req)
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
 
-static int crypto_aegis256_init_tfm(struct crypto_aead *tfm)
-{
-	return 0;
-}
-
-static void crypto_aegis256_exit_tfm(struct crypto_aead *tfm)
-{
-}
-
 static struct aead_alg crypto_aegis256_alg = {
 	.setkey = crypto_aegis256_setkey,
 	.setauthsize = crypto_aegis256_setauthsize,
 	.encrypt = crypto_aegis256_encrypt,
 	.decrypt = crypto_aegis256_decrypt,
-	.init = crypto_aegis256_init_tfm,
-	.exit = crypto_aegis256_exit_tfm,
 
 	.ivsize = AEGIS256_NONCE_SIZE,
 	.maxauthsize = AEGIS256_MAX_AUTH_SIZE,
-- 
2.20.1

