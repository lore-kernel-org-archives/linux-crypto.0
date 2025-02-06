Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF66150997;
	Thu,  6 Feb 2025 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826467; cv=none; b=ODA7Op3cZ29951J9BVHR451xuB8kPin5m23yyBGb83OM+N/iMy2+Cs515PPgKcGZ0h69dmrBzdhRj2qMfxpwvkzQNJ/56YZsrEoVR939r/W7VeRnJlw+0rCxMQCOvDwL5qrVwBs4TrMG73I15sfQImFNuBIwsMcbV1tE7VhpYc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826467; c=relaxed/simple;
	bh=Dg6cX4FN0ukGigef7HcQnBK2IX626trFMZTmcHymvI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eA0L2Bxb1RptTtz7i59A6B8VI80SWHmAaC0XppLYt1kG/RYM2kN6DMoYwoMzWxaF04H/XNqGBGZhCnXJR+gJ/7QUl/D0fSoZJlC1LZTXo8/a0fZSL4uPtAPIYASweQY/DHg7g7rESYRQuj1DjCtHQ9dJH6EptkAqrsGQK/sv9ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AwPycfki; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AwPycfki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826465; x=1770362465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dg6cX4FN0ukGigef7HcQnBK2IX626trFMZTmcHymvI0=;
  b=AwPycfki3eoQ102Cp1qNzxHubJig977zc2mb+2KO7aMtvkNzlmEu2oCZ
   AT4lvOt8/gN8IgCREh87reiX2oVaZXGsIS4MfZrVAE7E7SqkDcouf2CjT
   opJT/TRKdk3j5IsuJw3ofRCAeYqK0w71LrecXFx8nsdR01qCSejrL7C60
   i4p7uWsHb3eNAQVIpfFHbBzb4f1R1YwSwdXOKNTzciw6ycY1LoIQO1pLJ
   pj7J8qk+ZdCXW81tV+rTBGxKxeVBx1kdNSoHaYM+Ad9qyypaZuSVS/osx
   86mB0zrNIhS7eehnOaSQR+972IYoMgrpMYVVV/fRM+XicNKoTo9ZedfJm
   Q==;
X-CSE-ConnectionGUID: S9TWm/0rQf64bzOLaBfNRw==
X-CSE-MsgGUID: NPPPfRpUTXO4KIO1TIHHMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962595"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962595"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:04 -0800
X-CSE-ConnectionGUID: 2/lOqTRoShKTaM2C9vEFFg==
X-CSE-MsgGUID: o312Qv5QS82zTbitC+ehBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022592"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:03 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v6 01/16] crypto: acomp - Add synchronous/asynchronous acomp request chaining.
Date: Wed,  5 Feb 2025 23:20:47 -0800
Message-Id: <20250206072102.29045-2-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is based on Herbert Xu's request chaining for ahash
("[PATCH 2/6] crypto: hash - Add request chaining API") [1]. The generic
framework for request chaining that's provided in the ahash implementation
has been used as reference to develop a similar synchronous request
chaining framework for crypto_acomp.

Furthermore, this commit develops an asynchronous request chaining
framework and API that iaa_crypto can use for request chaining with
parallelism, in order to fully benefit from Intel IAA's multiple
compress/decompress engines in hardware. This allows us to gain significant
latency improvements with IAA batching as compared to synchronous request
chaining.

 Usage of acomp request chaining API:
 ====================================

 Any crypto_acomp compressor can avail of request chaining as follows:

 Step 1: Create request chain:

  Request 0 (the first req in the chain):

  void acomp_reqchain_init(struct acomp_req *req,
                           u32 flags, crypto_completion_t compl,
                           void *data);

  Subsequent requests:

  void acomp_request_chain(struct acomp_req *req,
                           struct acomp_req *head);

 Step 2: Process the request chain using the specified compress/decompress
         "op":

  2.a) Synchronous: the chain of requests is processed in series:

       int acomp_do_req_chain(struct acomp_req *req,
                              int (*op)(struct acomp_req *req));

  2.b) Asynchronous: the chain of requests is processed in parallel using a
       submit-poll paradigm:

       int acomp_do_async_req_chain(struct acomp_req *req,
                                    int (*op_submit)(struct acomp_req *req),
                                    int (*op_poll)(struct acomp_req *req));

Request chaining will be used in subsequent patches to implement
compress/decompress batching in the iaa_crypto driver for the two supported
IAA driver sync_modes:

  sync_mode = 'sync' will use (2.a),
  sync_mode = 'async' will use (2.b).

These files are directly re-used from [1] which is not yet merged:

include/crypto/algapi.h
include/linux/crypto.h

Hence, I am adding Herbert as the co-developer of this acomp request
chaining patch.

[1]: https://lore.kernel.org/linux-crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herbert@gondor.apana.org.au/

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by:
---
 crypto/acompress.c                  | 284 ++++++++++++++++++++++++++++
 include/crypto/acompress.h          |  41 ++++
 include/crypto/algapi.h             |  10 +
 include/crypto/internal/acompress.h |  10 +
 include/linux/crypto.h              |  31 +++
 5 files changed, 376 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 6fdf0ff9f3c0..cb6444d09dd7 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -23,6 +23,19 @@ struct crypto_scomp;
 
 static const struct crypto_type crypto_acomp_type;
 
+struct acomp_save_req_state {
+	struct list_head head;
+	struct acomp_req *req0;
+	struct acomp_req *cur;
+	int (*op)(struct acomp_req *req);
+	crypto_completion_t compl;
+	void *data;
+};
+
+static void acomp_reqchain_done(void *data, int err);
+static int acomp_save_req(struct acomp_req *req, crypto_completion_t cplt);
+static void acomp_restore_req(struct acomp_req *req);
+
 static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *alg)
 {
 	return container_of(alg, struct acomp_alg, calg.base);
@@ -123,6 +136,277 @@ struct crypto_acomp *crypto_alloc_acomp_node(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_acomp_node);
 
+static int acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_save_req_state *state;
+	gfp_t gfp;
+	u32 flags;
+
+	if (!acomp_is_async(tfm))
+		return 0;
+
+	flags = acomp_request_flags(req);
+	gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?  GFP_KERNEL : GFP_ATOMIC;
+	state = kmalloc(sizeof(*state), gfp);
+	if (!state)
+		return -ENOMEM;
+
+	state->compl = req->base.complete;
+	state->data = req->base.data;
+	state->req0 = req;
+
+	req->base.complete = cplt;
+	req->base.data = state;
+
+	return 0;
+}
+
+static void acomp_restore_req(struct acomp_req *req)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_save_req_state *state;
+
+	if (!acomp_is_async(tfm))
+		return;
+
+	state = req->base.data;
+
+	req->base.complete = state->compl;
+	req->base.data = state->data;
+	kfree(state);
+}
+
+static int acomp_reqchain_finish(struct acomp_save_req_state *state,
+				 int err, u32 mask)
+{
+	struct acomp_req *req0 = state->req0;
+	struct acomp_req *req = state->cur;
+	struct acomp_req *n;
+
+	req->base.err = err;
+
+	if (req == req0)
+		INIT_LIST_HEAD(&req->base.list);
+	else
+		list_add_tail(&req->base.list, &req0->base.list);
+
+	list_for_each_entry_safe(req, n, &state->head, base.list) {
+		list_del_init(&req->base.list);
+
+		req->base.flags &= mask;
+		req->base.complete = acomp_reqchain_done;
+		req->base.data = state;
+		state->cur = req;
+		err = state->op(req);
+
+		if (err == -EINPROGRESS) {
+			if (!list_empty(&state->head))
+				err = -EBUSY;
+			goto out;
+		}
+
+		if (err == -EBUSY)
+			goto out;
+
+		req->base.err = err;
+		list_add_tail(&req->base.list, &req0->base.list);
+	}
+
+	acomp_restore_req(req0);
+
+out:
+	return err;
+}
+
+static void acomp_reqchain_done(void *data, int err)
+{
+	struct acomp_save_req_state *state = data;
+	crypto_completion_t compl = state->compl;
+
+	data = state->data;
+
+	if (err == -EINPROGRESS) {
+		if (!list_empty(&state->head))
+			return;
+		goto notify;
+	}
+
+	err = acomp_reqchain_finish(state, err, CRYPTO_TFM_REQ_MAY_BACKLOG);
+	if (err == -EBUSY)
+		return;
+
+notify:
+	compl(data, err);
+}
+
+int acomp_do_req_chain(struct acomp_req *req,
+		       int (*op)(struct acomp_req *req))
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_save_req_state *state;
+	struct acomp_save_req_state state0;
+	int err = 0;
+
+	if (!acomp_request_chained(req) || list_empty(&req->base.list) ||
+	    !crypto_acomp_req_chain(tfm))
+		return op(req);
+
+	state = &state0;
+
+	if (acomp_is_async(tfm)) {
+		err = acomp_save_req(req, acomp_reqchain_done);
+		if (err) {
+			struct acomp_req *r2;
+
+			req->base.err = err;
+			list_for_each_entry(r2, &req->base.list, base.list)
+				r2->base.err = err;
+
+			return err;
+		}
+
+		state = req->base.data;
+	}
+
+	state->op = op;
+	state->cur = req;
+	INIT_LIST_HEAD(&state->head);
+	list_splice(&req->base.list, &state->head);
+
+	err = op(req);
+	if (err == -EBUSY || err == -EINPROGRESS)
+		return -EBUSY;
+
+	return acomp_reqchain_finish(state, err, ~0);
+}
+EXPORT_SYMBOL_GPL(acomp_do_req_chain);
+
+static void acomp_async_reqchain_done(struct acomp_req *req0,
+				      struct list_head *state,
+				      int (*op_poll)(struct acomp_req *req))
+{
+	struct acomp_req *req, *n;
+	bool req0_done = false;
+	int err;
+
+	while (!list_empty(state)) {
+
+		if (!req0_done) {
+			err = op_poll(req0);
+			if (!(err == -EAGAIN || err == -EINPROGRESS || err == -EBUSY)) {
+				req0->base.err = err;
+				req0_done = true;
+			}
+		}
+
+		list_for_each_entry_safe(req, n, state, base.list) {
+			err = op_poll(req);
+
+			if (err == -EAGAIN || err == -EINPROGRESS || err == -EBUSY)
+				continue;
+
+			req->base.err = err;
+			list_del_init(&req->base.list);
+			list_add_tail(&req->base.list, &req0->base.list);
+		}
+	}
+
+	while (!req0_done) {
+		err = op_poll(req0);
+		if (!(err == -EAGAIN || err == -EINPROGRESS || err == -EBUSY)) {
+			req0->base.err = err;
+			break;
+		}
+	}
+}
+
+static int acomp_async_reqchain_finish(struct acomp_req *req0,
+				       struct list_head *state,
+				       int (*op_submit)(struct acomp_req *req),
+				       int (*op_poll)(struct acomp_req *req))
+{
+	struct acomp_req *req, *n;
+	int err = 0;
+
+	INIT_LIST_HEAD(&req0->base.list);
+
+	list_for_each_entry_safe(req, n, state, base.list) {
+		BUG_ON(req == req0);
+
+		err = op_submit(req);
+
+		if (!(err == -EINPROGRESS || err == -EBUSY)) {
+			req->base.err = err;
+			list_del_init(&req->base.list);
+			list_add_tail(&req->base.list, &req0->base.list);
+		}
+	}
+
+	acomp_async_reqchain_done(req0, state, op_poll);
+
+	return req0->base.err;
+}
+
+int acomp_do_async_req_chain(struct acomp_req *req,
+			     int (*op_submit)(struct acomp_req *req),
+			     int (*op_poll)(struct acomp_req *req))
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct list_head state;
+	struct acomp_req *r2;
+	int err = 0;
+	void *req0_data = req->base.data;
+
+	if (!acomp_request_chained(req) || list_empty(&req->base.list) ||
+		!acomp_is_async(tfm) || !crypto_acomp_req_chain(tfm)) {
+
+		err = op_submit(req);
+
+		if (err == -EINPROGRESS || err == -EBUSY) {
+			bool req0_done = false;
+
+			while (!req0_done) {
+				err = op_poll(req);
+				if (!(err == -EAGAIN || err == -EINPROGRESS || err == -EBUSY)) {
+					req->base.err = err;
+					break;
+				}
+			}
+		} else {
+			req->base.err = err;
+		}
+
+		req->base.data = req0_data;
+		if (acomp_is_async(tfm))
+			req->base.complete(req->base.data, req->base.err);
+
+		return err;
+	}
+
+	err = op_submit(req);
+	req->base.err = err;
+
+	if (err && !(err == -EINPROGRESS || err == -EBUSY))
+		goto err_prop;
+
+	INIT_LIST_HEAD(&state);
+	list_splice(&req->base.list, &state);
+
+	err = acomp_async_reqchain_finish(req, &state, op_submit, op_poll);
+	req->base.data = req0_data;
+	req->base.complete(req->base.data, req->base.err);
+
+	return err;
+
+err_prop:
+	list_for_each_entry(r2, &req->base.list, base.list)
+		r2->base.err = err;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(acomp_do_async_req_chain);
+
 struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 54937b615239..eadc24514056 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -206,6 +206,7 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 	req->base.data = data;
 	req->base.flags &= CRYPTO_ACOMP_ALLOC_OUTPUT;
 	req->base.flags |= flgs & ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags &= ~CRYPTO_TFM_REQ_CHAIN;
 }
 
 /**
@@ -237,6 +238,46 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 		req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
+static inline u32 acomp_request_flags(struct acomp_req *req)
+{
+	return req->base.flags;
+}
+
+static inline void acomp_reqchain_init(struct acomp_req *req,
+				       u32 flags, crypto_completion_t compl,
+				       void *data)
+{
+	acomp_request_set_callback(req, flags, compl, data);
+	crypto_reqchain_init(&req->base);
+}
+
+static inline void acomp_reqchain_clear(struct acomp_req *req, void *data)
+{
+	struct crypto_wait *wait = (struct crypto_wait *)data;
+	reinit_completion(&wait->completion);
+	crypto_reqchain_clear(&req->base);
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, data);
+}
+
+static inline void acomp_request_chain(struct acomp_req *req,
+				       struct acomp_req *head)
+{
+	crypto_request_chain(&req->base, &head->base);
+}
+
+int acomp_do_req_chain(struct acomp_req *req,
+		       int (*op)(struct acomp_req *req));
+
+int acomp_do_async_req_chain(struct acomp_req *req,
+			     int (*op_submit)(struct acomp_req *req),
+			     int (*op_poll)(struct acomp_req *req));
+
+static inline int acomp_request_err(struct acomp_req *req)
+{
+	return req->base.err;
+}
+
 /**
  * crypto_acomp_compress() -- Invoke asynchronous compress operation
  *
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 156de41ca760..c5df380c7d08 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -271,4 +271,14 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
+static inline bool crypto_request_chained(struct crypto_async_request *req)
+{
+	return req->flags & CRYPTO_TFM_REQ_CHAIN;
+}
+
+static inline bool crypto_tfm_req_chain(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_CHAIN;
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 8831edaafc05..53b4ef59b48c 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -84,6 +84,16 @@ static inline void __acomp_request_free(struct acomp_req *req)
 	kfree_sensitive(req);
 }
 
+static inline bool acomp_request_chained(struct acomp_req *req)
+{
+	return crypto_request_chained(&req->base);
+}
+
+static inline bool crypto_acomp_req_chain(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_chain(&tfm->base);
+}
+
 /**
  * crypto_register_acomp() -- Register asynchronous compression algorithm
  *
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b164da5e129e..7c27d557586c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -13,6 +13,8 @@
 #define _LINUX_CRYPTO_H
 
 #include <linux/completion.h>
+#include <linux/errno.h>
+#include <linux/list.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -124,6 +126,9 @@
  */
 #define CRYPTO_ALG_FIPS_INTERNAL	0x00020000
 
+/* Set if the algorithm supports request chains. */
+#define CRYPTO_ALG_REQ_CHAIN		0x00040000
+
 /*
  * Transform masks and values (for crt_flags).
  */
@@ -133,6 +138,7 @@
 #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
+#define CRYPTO_TFM_REQ_CHAIN		0x00000800
 
 /*
  * Miscellaneous stuff.
@@ -174,6 +180,7 @@ struct crypto_async_request {
 	struct crypto_tfm *tfm;
 
 	u32 flags;
+	int err;
 };
 
 /**
@@ -540,5 +547,29 @@ int crypto_comp_decompress(struct crypto_comp *tfm,
 			   const u8 *src, unsigned int slen,
 			   u8 *dst, unsigned int *dlen);
 
+static inline void crypto_reqchain_init(struct crypto_async_request *req)
+{
+	req->err = -EINPROGRESS;
+	req->flags |= CRYPTO_TFM_REQ_CHAIN;
+	INIT_LIST_HEAD(&req->list);
+}
+
+static inline void crypto_reqchain_clear(struct crypto_async_request *req)
+{
+	req->flags &= ~CRYPTO_TFM_REQ_CHAIN;
+}
+
+static inline void crypto_request_chain(struct crypto_async_request *req,
+					struct crypto_async_request *head)
+{
+	req->err = -EINPROGRESS;
+	list_add_tail(&req->list, &head->list);
+}
+
+static inline bool crypto_tfm_is_async(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.27.0

