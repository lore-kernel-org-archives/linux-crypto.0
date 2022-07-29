Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D94C00144
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jul 2022 17:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiG2RAT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jul 2022 13:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbiG2RAS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jul 2022 13:00:18 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B2C13CD7
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jul 2022 10:00:17 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q30so2311957wra.11
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jul 2022 10:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ain078t749gdNu9nYbJSAWNxQTVHVUSBU8lepBm9yIY=;
        b=XnYO4rmU1sCUc5ayVxa36eaejR8cAIu7AuvegZfcqkJH/5MwRBqw55iw5ExAjA1Xh9
         KVQdAJzGnL+ns9p+tNofB35IyIqThrB3eOg8IqTIn3IN+0r1XgHAXSWG7gcaGmeMxJzI
         KiOGxCrNg9kFj+By/WZ+1178otk6HvDKV2Ihw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ain078t749gdNu9nYbJSAWNxQTVHVUSBU8lepBm9yIY=;
        b=oBzwYcveqwH8tbXOVANAruFYa0F7p9uEgqTyROEipkj8fB8AIpHzXMcqeypkU2GR+j
         mykvjSNCHN3FDYTIZy9ziVvynBhMgSUWzMe5Pp+dh66ZOLlO9AosuejQ4ygpZYtu8Gc4
         dDS9O8mX9ukez4Mj6pFK54HSlQ0JhyBbQ/cREx4ZAAdqddOpxTk0up64rNeCtuic1oFC
         AgWRxilY8dxybXDcvzBw0Gpl903U1YEhsSbXFiqRH1zP8ia7IHIiY1viZcmSWYHLJ5MC
         oNsCDwPJqkjgjtXTjqFAMbZNLKwXC15CFP2SdVFirpfLWdm81zFSDmzaY3q6pp5Qjqwr
         8sQw==
X-Gm-Message-State: ACgBeo0f74K0ICTKemOKYx2rnzRWOWW22oPkRasObLVyC2RAPLqbasWT
        M/lv5gaKJyamnKTVXIM3fp5LhA==
X-Google-Smtp-Source: AA6agR7Dzbt0v6ECxJsZk1ERO0U/YUA7fGBQLdfjjUFmrFpHyzP0yiYRQraEkft+yP8MDX46/m5rag==
X-Received: by 2002:adf:dfca:0:b0:21f:c93:5c36 with SMTP id q10-20020adfdfca000000b0021f0c935c36mr2935680wrn.41.1659114016070;
        Fri, 29 Jul 2022 10:00:16 -0700 (PDT)
Received: from localhost.localdomain (05464304.skybroadband.com. [5.70.67.4])
        by smtp.gmail.com with ESMTPSA id s1-20020adfea81000000b0021e74ef5ae8sm4120601wrm.21.2022.07.29.10.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 10:00:15 -0700 (PDT)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH] crypto: akcipher - default implementations for setting private/public keys
Date:   Fri, 29 Jul 2022 17:59:54 +0100
Message-Id: <20220729165954.991-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Many akcipher implementations (like ECDSA) support only signature
verifications only, so they don't have all callbacks defined.

Commit 78a0324f4a53 ("crypto: akcipher - default implementations for
request callbacks") introduced default callbacks for sign/verify
operations, which just return an error code.

However, these are not enough, because before calling sign/verify the
caller would likely call set_priv_key/set_pub_key first on the
instantiated transform (as the in-kernel testmgr does). These functions do
not have default stubs, so the kernel crashes, when trying to set a
private key on an akcipher, which doesn't support signature generation.

I've noticed this, when trying to add a KAT vector for ECDSA signature to
the testmgr.

With this patch the testmgr returns an error in dmesg (as it should)
instead of crashing the kernel NULL ptr dereference.

Fixes: 78a0324f4a53 ("crypto: akcipher - default implementations for request callbacks")
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 crypto/akcipher.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index f866085c8a4a..fc4db0c6ca33 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -120,6 +120,12 @@ static int akcipher_default_op(struct akcipher_request *req)
 	return -ENOSYS;
 }

+static int akcipher_default_set_key(struct crypto_akcipher *tfm,
+				     const void *key, unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
 int crypto_register_akcipher(struct akcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
@@ -132,6 +138,10 @@ int crypto_register_akcipher(struct akcipher_alg *alg)
 		alg->encrypt = akcipher_default_op;
 	if (!alg->decrypt)
 		alg->decrypt = akcipher_default_op;
+	if (!alg->set_priv_key)
+		alg->set_priv_key = akcipher_default_set_key;
+	if (!alg->set_pub_key)
+		alg->set_pub_key = akcipher_default_set_key;

 	akcipher_prepare_alg(alg);
 	return crypto_register_alg(base);
--
2.36.1

