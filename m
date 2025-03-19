Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C823524EF78
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 06:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364307; cv=none; b=eYM+3iNOk7jukhbDf/Nkiy1da7xmwRu9C6WUkrjykFQ8pagbwQljzM1gFW3f2D7Nv1vaatFvJlR3CEAAypckGnzqYGG4BSbHyxPm3vKWYWusHTPzFc/EkkWnARZtXhQm51k6nP2xcyGxHnNQA6lV/ju6UJbskSLF9IOH8vwg0ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364307; c=relaxed/simple;
	bh=7PwdZfmKHDY9ba3T8XyTwWd9YUi5fbL3WWR3I/dnYB0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=m3FEYj/eoDeKDn3VK+Ab7jFPpRbwhACZ3MgoZJGswikagyu9JoKrKydWCtRbcIWF5eYLaVJkQ3pQoyG5Fj7yY7CeRoocxi+TDoCU44fWDuvyiIlk9uC2Txr9SDMbgh+ekdW+G0WO7l5vYNzU6iiMbYZL9nSqAivasfe1mOee0FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aAfcmpep; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aAfcmpep"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kvsVrWxVSj+3ZBlPHtaF14VwcGbwVOXLcGhBOP45lpM=; b=aAfcmpepaKv4/KH2W7MoV16b36
	zsiyTa4kx1psiwy6KT+aPXJSffTGLVan+bC79yS2RtmmaFaZR1mcF3/TeuRpC8a+OqPaCHxl0wjzM
	1pnEko2XtK8VLD+cfZNP/ug1BL2ur9mQ6yoklvjUFz9zYdPrOO/mqMOtY0S2preEFIepXc6CYrgPC
	paZnotioQc+hOTOuoW8Jti9SNyxhJQjWFdpFDV061+BuPthsOL4O0nXbMVVbbtG5VSKkZtTIiAHxi
	/ta01yEZ4Ph0wE22phl/ZvPMRDZ71hhypUdUJxdbij1APwoy+Tsx5tu1XhiogY0fRNH5nD4JFrUil
	eX471dMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tumXu-008IUm-1r;
	Wed, 19 Mar 2025 14:04:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 14:04:54 +0800
Date: Wed, 19 Mar 2025 14:04:54 +0800
Message-Id: <c01290e8b3bf399bbf76c64f8620e8ec9995dec4.1742364215.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742364215.git.herbert@gondor.apana.org.au>
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] crypto: acomp - Add acomp_walk
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add acomp_walk which is similar to skcipher_walk but tailored for
acomp.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 116 ++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  44 +++++++++++
 2 files changed, 160 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 75fa9be1aa41..ac64e78f3b08 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -8,6 +8,7 @@
  */
 
 #include <crypto/internal/acompress.h>
+#include <crypto/scatterwalk.h>
 #include <linux/cryptouser.h>
 #include <linux/cpumask.h>
 #include <linux/errno.h>
@@ -15,6 +16,8 @@
 #include <linux/module.h>
 #include <linux/page-flags.h>
 #include <linux/percpu.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
@@ -27,6 +30,14 @@
 
 struct crypto_scomp;
 
+enum {
+	ACOMP_WALK_SLEEP = 1 << 0,
+	ACOMP_WALK_SRC_LINEAR = 1 << 1,
+	ACOMP_WALK_SRC_FOLIO = 1 << 2,
+	ACOMP_WALK_DST_LINEAR = 1 << 3,
+	ACOMP_WALK_DST_FOLIO = 1 << 4,
+};
+
 static const struct crypto_type crypto_acomp_type;
 
 static void acomp_reqchain_done(void *data, int err);
@@ -557,5 +568,110 @@ struct crypto_acomp_stream *crypto_acomp_lock_stream_bh(
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_lock_stream_bh);
 
+void acomp_walk_done_src(struct acomp_walk *walk, int used)
+{
+	walk->slen -= used;
+	if ((walk->flags & ACOMP_WALK_SRC_LINEAR))
+		scatterwalk_advance(&walk->in, used);
+	else
+		scatterwalk_done_src(&walk->in, used);
+
+	if ((walk->flags & ACOMP_WALK_SLEEP))
+		cond_resched();
+}
+EXPORT_SYMBOL_GPL(acomp_walk_done_src);
+
+void acomp_walk_done_dst(struct acomp_walk *walk, int used)
+{
+	walk->dlen -= used;
+	if ((walk->flags & ACOMP_WALK_DST_LINEAR))
+		scatterwalk_advance(&walk->out, used);
+	else
+		scatterwalk_done_dst(&walk->out, used);
+
+	if ((walk->flags & ACOMP_WALK_SLEEP))
+		cond_resched();
+}
+EXPORT_SYMBOL_GPL(acomp_walk_done_dst);
+
+int acomp_walk_next_src(struct acomp_walk *walk)
+{
+	unsigned int slen = walk->slen;
+	unsigned int max = UINT_MAX;
+
+	if (!preempt_model_preemptible() && (walk->flags & ACOMP_WALK_SLEEP))
+		max = PAGE_SIZE;
+	if ((walk->flags & ACOMP_WALK_SRC_LINEAR)) {
+		walk->in.__addr = (void *)(((u8 *)walk->in.sg) +
+					   walk->in.offset);
+		return min(slen, max);
+	}
+
+	return slen ? scatterwalk_next(&walk->in, slen) : 0;
+}
+EXPORT_SYMBOL_GPL(acomp_walk_next_src);
+
+int acomp_walk_next_dst(struct acomp_walk *walk)
+{
+	unsigned int dlen = walk->dlen;
+	unsigned int max = UINT_MAX;
+
+	if (!preempt_model_preemptible() && (walk->flags & ACOMP_WALK_SLEEP))
+		max = PAGE_SIZE;
+	if ((walk->flags & ACOMP_WALK_DST_LINEAR)) {
+		walk->out.__addr = (void *)(((u8 *)walk->out.sg) +
+					    walk->out.offset);
+		return min(dlen, max);
+	}
+
+	return dlen ? scatterwalk_next(&walk->out, dlen) : 0;
+}
+EXPORT_SYMBOL_GPL(acomp_walk_next_dst);
+
+int acomp_walk_virt(struct acomp_walk *__restrict walk,
+		    struct acomp_req *__restrict req)
+{
+	struct scatterlist *src = req->src;
+	struct scatterlist *dst = req->dst;
+
+	walk->slen = req->slen;
+	walk->dlen = req->dlen;
+
+	if (!walk->slen || !walk->dlen)
+		return -EINVAL;
+
+	walk->flags = 0;
+	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP))
+		walk->flags |= ACOMP_WALK_SLEEP;
+	if ((req->base.flags & CRYPTO_ACOMP_REQ_SRC_VIRT))
+		walk->flags |= ACOMP_WALK_SRC_LINEAR;
+	else if ((req->base.flags & CRYPTO_ACOMP_REQ_SRC_FOLIO)) {
+		src = &req->chain.ssg;
+		sg_init_table(src, 1);
+		sg_set_folio(src, req->sfolio, walk->slen, req->soff);
+	}
+	if ((req->base.flags & CRYPTO_ACOMP_REQ_DST_VIRT))
+		walk->flags |= ACOMP_WALK_DST_LINEAR;
+	else if ((req->base.flags & CRYPTO_ACOMP_REQ_DST_FOLIO)) {
+		dst = &req->chain.dsg;
+		sg_init_table(dst, 1);
+		sg_set_folio(dst, req->dfolio, walk->dlen, req->doff);
+	}
+
+	if ((walk->flags & ACOMP_WALK_SRC_LINEAR)) {
+		walk->in.sg = (void *)req->svirt;
+		walk->in.offset = 0;
+	} else
+		scatterwalk_start(&walk->in, src);
+	if ((walk->flags & ACOMP_WALK_DST_LINEAR)) {
+		walk->out.sg = (void *)req->dvirt;
+		walk->out.offset = 0;
+	} else
+		scatterwalk_start(&walk->out, dst);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acomp_walk_virt);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index ee5eff19eaf4..fbbff9a8a2d9 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -11,6 +11,7 @@
 
 #include <crypto/acompress.h>
 #include <crypto/algapi.h>
+#include <crypto/scatterwalk.h>
 #include <linux/compiler_types.h>
 #include <linux/cpumask_types.h>
 #include <linux/spinlock.h>
@@ -75,6 +76,37 @@ struct crypto_acomp_streams {
 	cpumask_t stream_want;
 };
 
+struct acomp_walk {
+	union {
+		/* Virtual address of the source. */
+		struct {
+			struct {
+				const void *const addr;
+			} virt;
+		} src;
+
+		/* Private field for the API, do not use. */
+		struct scatter_walk in;
+	};
+
+	union {
+		/* Virtual address of the destination. */
+		struct {
+			struct {
+				void *const addr;
+			} virt;
+		} dst;
+
+		/* Private field for the API, do not use. */
+		struct scatter_walk out;
+	};
+
+	unsigned int slen;
+	unsigned int dlen;
+
+	int flags;
+};
+
 /*
  * Transform internal helpers.
  */
@@ -190,4 +222,16 @@ static inline void crypto_acomp_unlock_stream_bh(
 {
 	spin_unlock_bh(&stream->lock);
 }
+
+void acomp_walk_done_src(struct acomp_walk *walk, int used);
+void acomp_walk_done_dst(struct acomp_walk *walk, int used);
+int acomp_walk_next_src(struct acomp_walk *walk);
+int acomp_walk_next_dst(struct acomp_walk *walk);
+int acomp_walk_virt(struct acomp_walk *__restrict walk,
+		    struct acomp_req *__restrict req);
+
+static inline bool acomp_walk_more_src(const struct acomp_walk *walk, int cur)
+{
+	return walk->slen != cur;
+}
 #endif
-- 
2.39.5

