From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4 4/6] crypto: drbg - add async seeding operation
Date: Sun, 03 May 2015 17:34:45 +0200
Message-ID: <2473718.578F5zZVyD@tachyon.chronox.de>
References: <1626703.0h1HzJAx4d@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Paul Bolle <pebolle@tiscali.it>,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	tytso@mit.edu, Sandy Harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34671 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbbECPhy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 May 2015 11:37:54 -0400
In-Reply-To: <1626703.0h1HzJAx4d@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The async seeding operation is triggered during initalization right
after the first non-blocking seeding is completed. As required by the
asynchronous operation of random.c, a callback function is provided that
is triggered by random.c once entropy is available. That callback
function performs the actual seeding of the DRBG.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 41 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/drbg.h |  1 +
 2 files changed, 42 insertions(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 36dfece..693dac4 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1056,6 +1056,40 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	return ret;
 }
 
+/* DRBG callback for obtaining data from the async Linux RNG */
+static void drbg_async_seed_cb(void *buf, ssize_t buflen, void *private)
+{
+	struct drbg_string data;
+	LIST_HEAD(seedlist);
+	struct drbg_state *drbg = (struct drbg_state *)private;
+	int ret = 0;
+
+	if (buflen <= 0 || !buf)
+		return;
+
+	drbg_string_fill(&data, buf, buflen);
+	list_add_tail(&data.list, &seedlist);
+	/* sanity check to verify that there is still a DRBG instance */
+	if (!drbg)
+		return;
+	mutex_lock(&drbg->drbg_mutex);
+	/* sanity check to verify that the DRBG instance is valid */
+	if (!drbg->V) {
+		mutex_unlock(&drbg->drbg_mutex);
+		return;
+	}
+	ret = __drbg_seed(drbg, &seedlist, true);
+	memzero_explicit(buf, buflen);
+	mutex_unlock(&drbg->drbg_mutex);
+}
+
+/* Cancel any outstanding async operation and wait for their completion */
+static inline void drbg_async_work_cancel(struct random_work *work)
+{
+	get_blocking_random_bytes_cancel(work);
+	cancel_work_sync(&work->rw_work);
+}
+
 /*
  * Seeding or reseeding of the DRBG
  *
@@ -1125,6 +1159,12 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	if (!reseed)
 		drbg->seed_buf_len = drbg->seed_buf_len / 3 * 2;
 
+	/* Invoke asynchronous seeding unless DRBG is in test mode. */
+	if (!list_empty(&drbg->test_data.list))
+		get_blocking_random_bytes_cb(NULL, &drbg->seed_work,
+					     drbg->seed_buf, drbg->seed_buf_len,
+					     drbg, drbg_async_seed_cb);
+
 out:
 	return ret;
 }
@@ -1487,6 +1527,7 @@ unlock:
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
+	drbg_async_work_cancel(&drbg->seed_work);
 	if (drbg->d_ops)
 		drbg->d_ops->crypto_fini(drbg);
 	drbg_dealloc_state(drbg);
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index b052698..e4980a1 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -119,6 +119,7 @@ struct drbg_state {
 	bool fips_primed;	/* Continuous test primed? */
 	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 #endif
+	struct random_work seed_work;	/* asynchronous seeding support */
 	u8 *seed_buf;			/* buffer holding the seed */
 	size_t seed_buf_len;
 	const struct drbg_state_ops *d_ops;
-- 
2.1.0
