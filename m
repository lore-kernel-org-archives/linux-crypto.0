Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC2EFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C4F206DF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215864;
	bh=yvH1MiQRnHAAeEdBpMxVzsIkVHhQhbFnbnmyzhoF60o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xuo5AHZN1x4w57OCRmVSO6DigHkzY/O9qV2wVklMewvlJ26rVy/9FkcbbucWnEw36
	 l+l9FTP3XJMBKK1S77UETZpQsD5CMmanZQcoK3Ur5p33nQVUhy62PvhQtvYxg28SCS
	 oXHzuTfG6/NMWZKvLOnCWRHKGwwv8RWZO4fNXRnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbfKHMYX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732457AbfKHMYX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:24:23 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF386224A0;
        Fri,  8 Nov 2019 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215862;
        bh=yvH1MiQRnHAAeEdBpMxVzsIkVHhQhbFnbnmyzhoF60o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3KwtJvnA30YF7PW/eq/OKzUljuH8AZCzaIAKxw/mdGTJtnq/8I1F53BeTuGur5ov
         U1wooA9SSE8m0K0AFw99EQYPEbTl+tzCIGm1tK9qsAwhrnQ74dpFFvzkuypmV+ApZU
         R4wSe/bkRzkM7JGHfTXusz9ENn8r02gnoKuyLomc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 28/34] crypto: curve25519 - implement generic KPP driver
Date:   Fri,  8 Nov 2019 13:22:34 +0100
Message-Id: <20191108122240.28479-29-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the generic Curve25519 library via the crypto API KPP interface.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig              |  5 ++
 crypto/Makefile             |  1 +
 crypto/curve25519-generic.c | 90 ++++++++++++++++++++
 3 files changed, 96 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 64cc4a93b51c..fab259d9d056 100644
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
index e30d6271e0f3..7c4e7e5608a6 100644
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
index 000000000000..bd88fd571393
--- /dev/null
+++ b/crypto/curve25519-generic.c
@@ -0,0 +1,90 @@
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

