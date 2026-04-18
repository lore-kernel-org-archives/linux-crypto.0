Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A3528466C;
	Sat, 18 Apr 2026 01:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776476319; cv=none; b=RkCs9ZXSquFfPdFgEbfJw/BdXEvZj9NmTLKatcqPq1EMQSN5ib7tO9WIVN83b40v6VB6mAQJKZtgrHLpVpiKSl/rKP9ueii8Gg4S6ILKGbI6MgCbuld/5WChJwcjPSdOTHAMO0gIbwAvgonChP5tE/6jYVsfhe/AMvSz5YEJgz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776476319; c=relaxed/simple;
	bh=/aNmjqf6EvkJP4ECg2FcVs4BvEpojMzJKwfiqkfzVuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnFV3P5PZHpQ0/YkorwzYo9ls8fBQ+NEzvq+zqTs/x4PEtJ+XEoHhh3FRv+nu9XmCmAQ7mhejg+1ouU5xjGpQxt1JJD6UYK147/kgonCNtLUJJVe3kby3eeurntMY4x0ov3nvL5R77J0Oohk1RXlber2QDEhZK92H5ppWjRL7oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ltFk2qqu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ltFk2qqu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1kOeSpjI0RlgPhVeNdHhHtVDLezjB3cfliHkX3ITdPU=; 
	b=ltFk2qqu9dBx4OWYOUscoecqlZVrGByV314KSR/ecadt44h6TVLgEDlSLjV3MJbymfj2yFUGY0z
	ywWwjonn2mHwGzpjyrMR3wgk8N482YtX1NSfDs4hnHSAirFPWtGWR3WmejtfdARIAx5y2C2Jss2hf
	vrYXX7VPecZCfzvWdWzniDS88dZXEUYyRtAtcXTNY0H7kYOYONXNpDemB/KzBMeRD9oHzlUTJrhKt
	OirQNOMsMZAP3s6WZVoF2vMAkOMFeOGmK1PNtchSjl2Bk+p0lRuB1783tfqc1VJz4WCR0wwgXjfSc
	oIB+d0IMRPKmFbbas8jUtZ9TUVxQIwuCDH2w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDudY-006wAf-28;
	Sat, 18 Apr 2026 09:38:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 18 Apr 2026 09:38:20 +0800
Date: Sat, 18 Apr 2026 09:38:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org, NeilBrown <neil@brown.name>
Subject: [PATCH] rhashtable: Restore insecure_elasticity toggle
Message-ID: <aeLgjAeJuidWNy3N@gondor.apana.org.au>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
 <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
 <aeJe8oIyYUi-NtCQ@slm.duckdns.org>
 <aeLT8eB_xfzLxqbI@gondor.apana.org.au>
 <aeLV6aDhM0-S4oQ1@slm.duckdns.org>
 <aeLWH_HgSHF4buiJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeLWH_HgSHF4buiJ@gondor.apana.org.au>

Some users of rhashtable cannot handle insertion failures, and
are happy to accept the consequences of a hash table that having
very long chains.

Restore the insecure_elasticity toggle for these users.  In
addition to disabling the chain length checks, this also removes
the emergency resize that would otherwise occur when the hash
table occupancy hits 100% (an async resize is still scheduled
at 75%).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 015c8298bebc..72082428d6c6 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -49,6 +49,7 @@ typedef int (*rht_obj_cmpfn_t)(struct rhashtable_compare_arg *arg,
  * @head_offset: Offset of rhash_head in struct to be hashed
  * @max_size: Maximum size while expanding
  * @min_size: Minimum size while shrinking
+ * @insecure_elasticity: Set to true to disable chain length checks
  * @automatic_shrinking: Enable automatic shrinking of tables
  * @hashfn: Hash function (default: jhash2 if !(key_len % 4), or jhash)
  * @obj_hashfn: Function to hash object
@@ -61,6 +62,7 @@ struct rhashtable_params {
 	u16			head_offset;
 	unsigned int		max_size;
 	u16			min_size;
+	bool			insecure_elasticity;
 	bool			automatic_shrinking;
 	rht_hashfn_t		hashfn;
 	rht_obj_hashfn_t	obj_hashfn;
diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 0480509a6339..c793849d3f61 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -821,14 +821,15 @@ static __always_inline void *__rhashtable_insert_fast(
 		goto out;
 	}
 
-	if (elasticity <= 0)
+	if (elasticity <= 0 && !params->insecure_elasticity)
 		goto slow_path;
 
 	data = ERR_PTR(-E2BIG);
 	if (unlikely(rht_grow_above_max(ht, tbl)))
 		goto out_unlock;
 
-	if (unlikely(rht_grow_above_100(ht, tbl)))
+	if (unlikely(rht_grow_above_100(ht, tbl)) &&
+	    !params->insecure_elasticity)
 		goto slow_path;
 
 	/* Inserting at head of list makes unlocking free. */
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6074ed5f66f3..b60d55e5b19b 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -538,7 +538,7 @@ static void *rhashtable_lookup_one(struct rhashtable *ht,
 		return NULL;
 	}
 
-	if (elasticity <= 0)
+	if (elasticity <= 0 && !ht->p->insecure_elasticity)
 		return ERR_PTR(-EAGAIN);
 
 	return ERR_PTR(-ENOENT);
@@ -568,7 +568,8 @@ static struct bucket_table *rhashtable_insert_one(
 	if (unlikely(rht_grow_above_max(ht, tbl)))
 		return ERR_PTR(-E2BIG);
 
-	if (unlikely(rht_grow_above_100(ht, tbl)))
+	if (unlikely(rht_grow_above_100(ht, tbl)) &&
+	    !ht->p->insecure_elasticity)
 		return ERR_PTR(-EAGAIN);
 
 	head = rht_ptr(bkt, tbl, hash);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
