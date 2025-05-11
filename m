Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B0E1A08A6
	for <linux-crypto@vger.kernel.org>; Sun, 11 May 2025 09:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746954586; cv=none; b=N9qI2X8cqX486qRkTLTE7+fY03KqApEo+1BNcftq5tND+AqoyvW8f4utpzRnTC1UsfT62k9FLnRiBRpd6RdItKEFrLq6GDQrrUHUKOM01kUYt+bFcrS0rkfOHdC32jgzHklNi87uI/obsYO/8tj2okxR1pZu1P9u+llyAWUwg04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746954586; c=relaxed/simple;
	bh=dC9IZVhGIPrZUX3sx7L9kmp7fZq2idmNJr433uxe9lk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=czkPYRV7XreeDyM9Oyl17zW09hdEqb4AX0PZaxEKmQQisNAHumgp9J1LmJknXXnYpACpE5ijzCs3q5p5pPgUdUZHUAt1ayhyjiYRpLzaE22Tgnk+A7zAUUAp/1nu7jGowPwhriZQD3c71t4W+Lumi6dbJEV1oDCHX46bQhv11/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jBHymj+6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jBHymj+6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mvkY0/Lfin6TIhvkDvphO0AqL80wFPnpJPCYIdgi/cg=; b=jBHymj+6VYqd5xthA64K47DUCS
	zeMwWB4LOZC/LCcU29esB73UJMurQBfuscI/GzACFnXNqu6a6VInTUK/AhPYsiL4pdihZmH2/roV2
	kaZ2cKBWJl0fAa1RrEoQ7k5CCu0xh8D8K05L9cVG7JJgv18V0Poh8pu9CYoRqsH7fHILsdKELHodi
	xT13rrJzTLdX5jEVBlCGMAdCq0+UPZeWdK8LHctOBb1a2AJ6D4Fmdf63m9fPZBuILZIiu4vOVL9vp
	GOhO1bveSa3zfmKdqBdHzKuT9PtBQ5mj0TgrVexCd/9BvnXxF5tEqVLXFbGntC6T9tZRR/iLFJyK1
	yymMpL4g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uE2gm-005CPj-2L;
	Sun, 11 May 2025 17:09:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 May 2025 17:09:40 +0800
Date: Sun, 11 May 2025 17:09:40 +0800
Message-Id: <eadbab383cb3b8228a5422368302dcaab9849bf4.1746954402.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746954402.git.herbert@gondor.apana.org.au>
References: <cover.1746954402.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 5/6] crypto: algapi - Add driver template support to
 crypto_inst_setname
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add support to crypto_inst_setname for having a driver template
name that differs from the algorithm template name.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c         |  8 ++++----
 include/crypto/algapi.h | 12 ++++++++++--
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 532d3efc3c7d..6618cab2a8f7 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -924,20 +924,20 @@ const char *crypto_attr_alg_name(struct rtattr *rta)
 }
 EXPORT_SYMBOL_GPL(crypto_attr_alg_name);
 
-int crypto_inst_setname(struct crypto_instance *inst, const char *name,
-			struct crypto_alg *alg)
+int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
+			  const char *driver, struct crypto_alg *alg)
 {
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)", name,
 		     alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
-		     name, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		     driver, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_inst_setname);
+EXPORT_SYMBOL_GPL(__crypto_inst_setname);
 
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 423e57eca351..188eface0a11 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -146,8 +146,16 @@ void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret);
 const char *crypto_attr_alg_name(struct rtattr *rta);
-int crypto_inst_setname(struct crypto_instance *inst, const char *name,
-			struct crypto_alg *alg);
+int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
+			  const char *driver, struct crypto_alg *alg);
+
+#define crypto_inst_setname(inst, name, ...) \
+	CONCATENATE(crypto_inst_setname_, COUNT_ARGS(__VA_ARGS__))( \
+		inst, name, ##__VA_ARGS__)
+#define crypto_inst_setname_1(inst, name, alg) \
+	__crypto_inst_setname(inst, name, name, alg)
+#define crypto_inst_setname_2(inst, name, driver, alg) \
+	__crypto_inst_setname(inst, name, driver, alg)
 
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
 int crypto_enqueue_request(struct crypto_queue *queue,
-- 
2.39.5

