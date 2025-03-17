Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16286218E97
	for <linux-crypto@vger.kernel.org>; Mon, 17 Mar 2025 08:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200443; cv=none; b=uvWXl4qLKv4ipASWmr0iRP+64SKpo6C1ST7mVPUAuN6ahtzNRjWwL51rN/nreOOCkHvn6fI7ZsjrLQ76rTglpcDu+neJiDwBj8P7x/7CMPJJfliHdK0Zg8cNcLGojS8XraNffOyCkjevm52ANI352HJeu8I+DXAK5IBNhZJ630E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200443; c=relaxed/simple;
	bh=g/QrcrseuFJzplfbtCrKtwQbgaq9n94FOi3oU1oK6nI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=ruIoBJkK9cI9pCDZd0V09Ku8w18FnPekBnuTRvuJhfDk52jbaHr0yTa7Q4WYD98Bfd54GigDgu48SkRzDTCfzF7O14a5Ln5JgTWE4Fk98+p+dmpXLnuGnovLIdk18d7Ce/bVTpt8D2DoPaj8cqZgQrCn+7KJnbsrpZkXQmbCF9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gkLTXlJw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gkLTXlJw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gAAWRQSR5MmdcU7FrfTHk4P9nefdcJJ4e5xzE60NWig=; b=gkLTXlJwEPWl52JMFSocx6u/Ym
	G+FmWhXXqZ+db19+UlhImtxpFt1MSgQY+hNMDM3qxWu6IsMTKDxQPUKra+xX25qYb8jQW+WaSkzmK
	AR0/tOPX3dhBUcWpY6kiAd6dHpUxAB58IegRRnBKveDG7usUNTuBe950KJUjLuCXaI0xdt9SQlDHy
	OIKeFn3dfCQlNRxZJtIo6k7K2cTVS+fx7gF+PRCm9LtXIDA5+vjri8sWmXwM+71q6m3hkhY2OXNAw
	h4dL7SWfdBxBfFaTKWDCCRX26ZRFSF6cDbs/+VvM/+mMKaX3AO0heY04iPngNYsbnYi235x0VmBaY
	wuqrbgFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tu5v0-007UWH-2j;
	Mon, 17 Mar 2025 16:33:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Mar 2025 16:33:54 +0800
Date: Mon, 17 Mar 2025 16:33:54 +0800
Message-Id: <5ef9f00197b486e9c7cc4602318736b639ee143c.1742200161.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742200161.git.herbert@gondor.apana.org.au>
References: <cover.1742200161.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: api - Move alg destroy work from instance to
 template
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Commit 9ae4577bc077 ("crypto: api - Use work queue in
crypto_destroy_instance") introduced a work struct to free an
instance after the last user goes away.

Move the delayed work from the instance into its template so that
when the template is unregistered it can ensure that all its
instances have been freed before returning.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c         | 35 +++++++++++++++++++++++++++--------
 include/crypto/algapi.h |  5 +++--
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index ea9ed9580aa8..22bf80aad82b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -71,12 +71,23 @@ static void crypto_free_instance(struct crypto_instance *inst)
 
 static void crypto_destroy_instance_workfn(struct work_struct *w)
 {
-	struct crypto_instance *inst = container_of(w, struct crypto_instance,
+	struct crypto_template *tmpl = container_of(w, struct crypto_template,
 						    free_work);
-	struct crypto_template *tmpl = inst->tmpl;
+	struct crypto_instance *inst;
+	struct hlist_node *n;
+	HLIST_HEAD(list);
 
-	crypto_free_instance(inst);
-	crypto_tmpl_put(tmpl);
+	down_write(&crypto_alg_sem);
+	hlist_for_each_entry_safe(inst, n, &tmpl->dead, list) {
+		if (refcount_read(&inst->alg.cra_refcnt) != -1)
+			continue;
+		hlist_del(&inst->list);
+		hlist_add_head(&inst->list, &list);
+	}
+	up_write(&crypto_alg_sem);
+
+	hlist_for_each_entry_safe(inst, n, &list, list)
+		crypto_free_instance(inst);
 }
 
 static void crypto_destroy_instance(struct crypto_alg *alg)
@@ -84,9 +95,10 @@ static void crypto_destroy_instance(struct crypto_alg *alg)
 	struct crypto_instance *inst = container_of(alg,
 						    struct crypto_instance,
 						    alg);
+	struct crypto_template *tmpl = inst->tmpl;
 
-	INIT_WORK(&inst->free_work, crypto_destroy_instance_workfn);
-	schedule_work(&inst->free_work);
+	refcount_set(&alg->cra_refcnt, -1);
+	schedule_work(&tmpl->free_work);
 }
 
 /*
@@ -132,14 +144,17 @@ static void crypto_remove_instance(struct crypto_instance *inst,
 
 	inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
 
-	if (!tmpl || !crypto_tmpl_get(tmpl))
+	if (!tmpl)
 		return;
 
-	list_move(&inst->alg.cra_list, list);
+	list_del_init(&inst->alg.cra_list);
 	hlist_del(&inst->list);
+	hlist_add_head(&inst->list, &tmpl->dead);
 	inst->alg.cra_destroy = crypto_destroy_instance;
 
 	BUG_ON(!list_empty(&inst->alg.cra_users));
+
+	crypto_alg_put(&inst->alg);
 }
 
 /*
@@ -504,6 +519,8 @@ int crypto_register_template(struct crypto_template *tmpl)
 	struct crypto_template *q;
 	int err = -EEXIST;
 
+	INIT_WORK(&tmpl->free_work, crypto_destroy_instance_workfn);
+
 	down_write(&crypto_alg_sem);
 
 	crypto_check_module_sig(tmpl->module);
@@ -565,6 +582,8 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 		crypto_free_instance(inst);
 	}
 	crypto_remove_final(&users);
+
+	flush_work(&tmpl->free_work);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_template);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 6e07bbc04089..03b7eca8af9a 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -68,16 +68,17 @@ struct crypto_instance {
 		struct crypto_spawn *spawns;
 	};
 
-	struct work_struct free_work;
-
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
 struct crypto_template {
 	struct list_head list;
 	struct hlist_head instances;
+	struct hlist_head dead;
 	struct module *module;
 
+	struct work_struct free_work;
+
 	int (*create)(struct crypto_template *tmpl, struct rtattr **tb);
 
 	char name[CRYPTO_MAX_ALG_NAME];
-- 
2.39.5

