Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBBE53362
	for <linux-crypto@vger.kernel.org>; Mon, 20 May 2024 11:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716203096; cv=none; b=ZoXaSQzNWiEASrH0co2dCdq5AdQOM2To1Ng9uFBOIG3f9+VKbuLY5OuM+jk/Ya1YKUUxoyLTwpmq7rqOzbstmF/byFv8JXBJ0X7FA2AShhpAL2Z6eONcctZJ9YtFb3tTRYVSrDfKi135q8km0Xi1lXqvQvkZaJm5ylcbHQ1c7Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716203096; c=relaxed/simple;
	bh=Teko/VtjcykJaDFEH9utJtGyz5xWYNqVYFF0S00mKHc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=p6IFcDjqilrr0sGbYJ80VMtCZwJidwb0NHy6aMcLVNVxY+9ln7v0npbDhlPajNkUSajr9IIsVXkjNtRBhtJcy6nkviHI5g7a5APzsU7mrPdZt3wxdxIPVywtjTi+z9iIn81zr/ZXMeAw8lepbybrddhI9bNc18nzbigGyIBVh44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s90oz-0000w0-13;
	Mon, 20 May 2024 19:04:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 May 2024 19:04:50 +0800
Date: Mon, 20 May 2024 19:04:50 +0800
Message-Id: <7b5e647f760c4deacf81d3b782f1beee54de3bbc.1716202860.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1716202860.git.herbert@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: acomp - Add comp_params helpers
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add helpers to get compression parameters, including the level
and an optional dictionary.

Note that algorithms do not have to use these helpers and could
come up with its own set of parameters.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c                  | 49 +++++++++++++++++++++++++++++
 include/crypto/acompress.h          |  9 ++++++
 include/crypto/internal/scompress.h | 10 ++++++
 3 files changed, 68 insertions(+)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 9117d7c85f31..1c35569df06c 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
 #include <linux/scatterlist.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -377,5 +378,53 @@ void crypto_unregister_scomps(struct scomp_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_scomps);
 
+int crypto_comp_getparams(struct crypto_comp_params *params, const u8 *raw,
+			  unsigned int len)
+{
+	struct rtattr *rta = (struct rtattr *)raw;
+	void *dict;
+
+	crypto_comp_putparams(params);
+	params->level = CRYPTO_COMP_NO_LEVEL;
+
+	for (;; rta = RTA_NEXT(rta, len)) {
+		if (!RTA_OK(rta, len))
+			return -EINVAL;
+
+		if (rta->rta_type == CRYPTO_COMP_PARAM_LAST)
+			break;
+
+		switch (rta->rta_type) {
+		case CRYPTO_COMP_PARAM_LEVEL:
+			if (RTA_PAYLOAD(rta) != 4)
+				return -EINVAL;
+			memcpy(&params->level, RTA_DATA(rta), 4);
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	dict = RTA_NEXT(rta, len);
+	if (!len)
+		return 0;
+
+	params->dict = kvmemdup(dict, len, GFP_KERNEL);
+	if (!params->dict)
+		return -ENOMEM;
+	params->dict_sz = len;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_comp_getparams);
+
+void crypto_comp_putparams(struct crypto_comp_params *params)
+{
+	kfree(params->dict);
+	params->dict = NULL;
+	params->dict_sz = 0;
+}
+EXPORT_SYMBOL_GPL(crypto_comp_putparams);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous compression type");
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 241d1dc5c883..383a7f16b309 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -12,10 +12,19 @@
 #include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
+#include <linux/limits.h>
 
 #define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
 #define CRYPTO_ACOMP_DST_MAX		131072
 
+#define CRYPTO_COMP_NO_LEVEL		INT_MIN
+
+enum {
+	CRYPTO_COMP_PARAM_UNSPEC,
+	CRYPTO_COMP_PARAM_LEVEL,
+	CRYPTO_COMP_PARAM_LAST,
+};
+
 /**
  * struct acomp_req - asynchronous (de)compression request
  *
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 4a9cf2174c7a..995989a0c1ff 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -49,6 +49,12 @@ struct scomp_alg {
 	};
 };
 
+struct crypto_comp_params {
+	int level;
+	unsigned dict_sz;
+	void *dict;
+};
+
 static inline struct scomp_alg *__crypto_scomp_alg(struct crypto_alg *alg)
 {
 	return container_of(alg, struct scomp_alg, base);
@@ -150,4 +156,8 @@ void crypto_unregister_scomp(struct scomp_alg *alg);
 int crypto_register_scomps(struct scomp_alg *algs, int count);
 void crypto_unregister_scomps(struct scomp_alg *algs, int count);
 
+int crypto_comp_getparams(struct crypto_comp_params *params, const u8 *raw,
+			  unsigned int len);
+void crypto_comp_putparams(struct crypto_comp_params *params);
+
 #endif
-- 
2.39.2

