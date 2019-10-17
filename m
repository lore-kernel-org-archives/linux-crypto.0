Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF6CECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D64BE21835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LRMO86YY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503407AbfJQTKp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37798 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503396AbfJQTKp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id f22so3684473wmc.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yKl79+kaP0xH/w2JKqyPRO+ZyNZ4Omsm0yfmDUcEZAU=;
        b=LRMO86YY9JebVhHKaWJXLxasJczUY89pzRMJMlNFjEPds20yUbU8gNDzuHGSH1qKYr
         epTcLg5UF3k1RlkgQn9iBxLZ040s9Cr7wey0gPRcbC2rHofoHzBzIQWOcv0kn6EvGBXK
         aX/2phyKWlAv6g6sN0ZJZAGZ2p0hmPT/udRbgNSFRKDLMb+MNf355Dj64MT+Q4Z5Xb6T
         YbFSI0J8vo40tTG9B7ir7XjBj3eC030CU+IOoaFMror1RqkOC/D9Ps9/aGEWHWTCLBvp
         Z9P0Mqu0mSn3FgK1xvtqokYcpTDQOElQHQwaCQieRHpxdmJevt64zXRpipze9r6PvX/W
         ib0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKl79+kaP0xH/w2JKqyPRO+ZyNZ4Omsm0yfmDUcEZAU=;
        b=dwEMOvtXPaWx2oZaFP7ZMRLta8Tre/rMoXtljy+RA6rpGzUk7Gvwq77G+HOKs/EPXI
         HHpTACxadubHts2wn1oLeAJHLEo8wHsml5UDnWXh5SbV6jGRc7jIawuUgS5tQUdkebHb
         y7BPJIr8xTEp9QShPT43dUMeZWQ9l8X0Oy5gFzxVGHII67XlJ4OJqq8z4tdXdWcyjbq2
         ilwXiq7ZK9fCUz+2aaL2R9IjyGEDM4PSP6C82TvkLxecfrma9OxUcA6abVh0YQxrVTFC
         jQPf6AvGMfZtA/uZ3dBveWoqilz2FElqOJFFt5iB6sOnD2/lfCHr2xUBI+WRTe2jSpmf
         4H6Q==
X-Gm-Message-State: APjAAAX5llv8TjvIytqQXFXXy+qvpS0XVQGRIrNfd0069ldLmJHDwjUf
        er5YlL1Smbh62lPrxmfp6XA7u6Bmzr/YNKc+
X-Google-Smtp-Source: APXvYqxnXXNy3jEfnj+1Y2d/TbhrPOBGXrGFG/u0kJX0vgXYDjANNK6sxj0NVF2f5ilknrlLYRShhw==
X-Received: by 2002:a1c:2d54:: with SMTP id t81mr4344803wmt.167.1571339442186;
        Thu, 17 Oct 2019 12:10:42 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 29/35] crypto: curve25519 - implement generic KPP driver
Date:   Thu, 17 Oct 2019 21:09:26 +0200
Message-Id: <20191017190932.1947-30-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the generic Curve25519 library via the crypto API KPP interface.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig              |  5 ++
 crypto/Makefile             |  1 +
 crypto/curve25519-generic.c | 93 ++++++++++++++++++++
 3 files changed, 99 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ff077dd3a7b7..b83088e6a8e6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -264,6 +264,11 @@ config CRYPTO_ECRDSA
 	  standard algorithms (called GOST algorithms). Only signature verification
 	  is implemented.
 
+config CRYPTO_CURVE25519
+	tristate "Curve25519 algorithm"
+	select CRYPTO_KPP
+	select CRYPTO_LIB_CURVE25519_GENERIC
+
 comment "Authenticated Encryption with Associated Data"
 
 config CRYPTO_CCM
diff --git a/crypto/Makefile b/crypto/Makefile
index ecc69a726460..1e6cea469a4a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -167,6 +167,7 @@ obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_OFB) += ofb.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
+obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
 
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
diff --git a/crypto/curve25519-generic.c b/crypto/curve25519-generic.c
new file mode 100644
index 000000000000..0f4cd6347e3b
--- /dev/null
+++ b/crypto/curve25519-generic.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <crypto/curve25519.h>
+#include <crypto/internal/kpp.h>
+#include <crypto/kpp.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+
+static int curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
+				 unsigned int len)
+{
+	u8 *secret = kpp_tfm_ctx(tfm);
+
+	if (!len)
+		curve25519_generate_secret(secret);
+	else if (len == CURVE25519_KEY_SIZE &&
+		 crypto_memneq(buf, curve25519_null_point, CURVE25519_KEY_SIZE))
+		memcpy(secret, buf, CURVE25519_KEY_SIZE);
+	else
+		return -EINVAL;
+	return 0;
+}
+
+static int curve25519_compute_value(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	const u8 *secret = kpp_tfm_ctx(tfm);
+	u8 public_key[CURVE25519_KEY_SIZE];
+	u8 buf[CURVE25519_KEY_SIZE];
+	int copied, nbytes;
+	u8 const *bp;
+
+	if (req->src) {
+		copied = sg_copy_to_buffer(req->src,
+					   sg_nents_for_len(req->src,
+							    CURVE25519_KEY_SIZE),
+					   public_key, CURVE25519_KEY_SIZE);
+		if (copied != CURVE25519_KEY_SIZE)
+			return -EINVAL;
+		bp = public_key;
+	} else {
+		bp = curve25519_base_point;
+	}
+
+	curve25519_generic(buf, secret, bp);
+
+	if (!crypto_memneq(buf, curve25519_null_point, CURVE25519_KEY_SIZE))
+		return -EKEYREJECTED;
+
+	/* might want less than we've got */
+	nbytes = min_t(size_t, CURVE25519_KEY_SIZE, req->dst_len);
+	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst,
+								nbytes),
+				     buf, nbytes);
+	if (copied != nbytes)
+		return -EINVAL;
+	return 0;
+}
+
+static unsigned int curve25519_max_size(struct crypto_kpp *tfm)
+{
+	return CURVE25519_KEY_SIZE;
+}
+
+static struct kpp_alg curve25519_alg = {
+	.base.cra_name		= "curve25519",
+	.base.cra_driver_name	= "curve25519-generic",
+	.base.cra_priority	= 100,
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_ctxsize	= CURVE25519_KEY_SIZE,
+
+	.set_secret		= curve25519_set_secret,
+	.generate_public_key	= curve25519_compute_value,
+	.compute_shared_secret	= curve25519_compute_value,
+	.max_size		= curve25519_max_size,
+};
+
+static int curve25519_init(void)
+{
+	return crypto_register_kpp(&curve25519_alg);
+}
+
+static void curve25519_exit(void)
+{
+	crypto_unregister_kpp(&curve25519_alg);
+}
+
+subsys_initcall(curve25519_init);
+module_exit(curve25519_exit);
+
+MODULE_ALIAS_CRYPTO("curve25519");
+MODULE_ALIAS_CRYPTO("curve25519-generic");
+MODULE_LICENSE("GPL");
-- 
2.20.1

