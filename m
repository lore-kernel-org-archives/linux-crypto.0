Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1650E1EEE6
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741437928; cv=none; b=qI92V3gAdg5cc1eugM4lv4WH/JTWdBq2zQb+unjulgwzdXxvgUuAY9ZAUdJikrjgk6AXp0HS6PmD8LhIRgh0viNEc99KUqj/dboveYpjA4loQ50G2f5QhtYNhZP3PWQbIcOFFbKEmQH19f4MGA9gKo4bpi3ge/aDU5bQZhVEqZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741437928; c=relaxed/simple;
	bh=rgsdWGUPTcJxcrN/p3ITJycaaEdcQeIo/DObyF5qGEI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=fk5GZpaIVRLvEq4tcTjvEqmBO3czPZZR8pyeeGnGM0lV6c5QtyiN6NxRcFXuRzVDPI5kSXZ3N/TFGoz/Vle72urcTA1s/xI88B18z42lDt8XTWdEhk6FBwINrMXVu9JlpcGM+XSEDwMvHVv6PCkUfgcOSbHycJJgvzPkFNzZpB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Qr3BpYV8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Qr3BpYV8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HgvZBLyGm5dHy+YTz+tq0DqKa58+TnDvZiohXu1FcpM=; b=Qr3BpYV8t8H3imV/EiEz67sFw8
	kIDEhAH0B/fFqwIeIYp0i7Z0IA7r4U8kz3iMa5pmlk+BIzXlF68rPiJR/1nVIDuW0I2o6u4k9fo/g
	8d3fvGvAcjOYrvQLIz4M6LzHkptqundu/3wKKe5+FweYjk+L174oSrY7MbIGAYjWEQMMvPLXHiixO
	pYWPsSCIF7jWk6fQYj5gthOY6h2IutCLsgeFemznZSCy8h8dErBNv5PrJwtY16xzptqzFrwMZz/cG
	ZURAStHFS/0q2K/wU9OdVRsWmyBrFol2JRJA66l1FyGFw8IsiL9f2P9+Bh5hXLjafWEwsS3sxcyUm
	fG8pDROA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqtYP-004r95-0r;
	Sat, 08 Mar 2025 20:45:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 20:45:21 +0800
Date: Sat, 08 Mar 2025 20:45:21 +0800
Message-Id: <e527c3db37bd8bd9c5da8d59bc4bce59e1311d1d.1741437826.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741437826.git.herbert@gondor.apana.org.au>
References: <cover.1741437826.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 1/3] crypto: scatterwalk - Change scatterwalk_next calling
 convention
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than returning the address and storing the length into an
argument pointer, add an address field to the walk struct and use
that to store the address.  The length is returned directly.

Change the done functions to use this stored address instead of
getting them from the caller.

Split the address into two using a union.  The user should only
access the const version so that it is never changed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/ghash-ce-glue.c       |  7 +++---
 arch/arm64/crypto/aes-ce-ccm-glue.c   |  9 +++----
 arch/arm64/crypto/ghash-ce-glue.c     |  7 +++---
 arch/arm64/crypto/sm4-ce-ccm-glue.c   |  8 +++---
 arch/arm64/crypto/sm4-ce-gcm-glue.c   |  8 +++---
 arch/s390/crypto/aes_s390.c           | 21 +++++++---------
 arch/x86/crypto/aegis128-aesni-glue.c |  7 +++---
 arch/x86/crypto/aesni-intel_glue.c    |  9 +++----
 crypto/aegis128-core.c                |  7 +++---
 crypto/scatterwalk.c                  | 14 +++++------
 crypto/skcipher.c                     | 10 +++++---
 drivers/crypto/nx/nx.c                |  7 +++---
 include/crypto/algapi.h               |  7 ++++++
 include/crypto/scatterwalk.h          | 35 ++++++++++++++-------------
 14 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 9613ffed84f9..dab66b520b6e 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -460,11 +460,10 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 
 	do {
 		unsigned int n;
-		const u8 *p;
 
-		p = scatterwalk_next(&walk, len, &n);
-		gcm_update_mac(dg, p, n, buf, &buf_count, ctx);
-		scatterwalk_done_src(&walk, p, n);
+		n = scatterwalk_next(&walk, len);
+		gcm_update_mac(dg, walk.addr, n, buf, &buf_count, ctx);
+		scatterwalk_done_src(&walk,  n);
 
 		if (unlikely(len / SZ_4K > (len - n) / SZ_4K)) {
 			kernel_neon_end();
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 1c29546983bf..2d791d51891b 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -157,12 +157,11 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 
 	do {
 		unsigned int n;
-		const u8 *p;
 
-		p = scatterwalk_next(&walk, len, &n);
-		macp = ce_aes_ccm_auth_data(mac, p, n, macp, ctx->key_enc,
-					    num_rounds(ctx));
-		scatterwalk_done_src(&walk, p, n);
+		n = scatterwalk_next(&walk, len);
+		macp = ce_aes_ccm_auth_data(mac, walk.addr, n, macp,
+					    ctx->key_enc, num_rounds(ctx));
+		scatterwalk_done_src(&walk, n);
 		len -= n;
 	} while (len);
 }
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 69d4fb78c30d..071e122f9c37 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -309,11 +309,10 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 
 	do {
 		unsigned int n;
-		const u8 *p;
 
-		p = scatterwalk_next(&walk, len, &n);
-		gcm_update_mac(dg, p, n, buf, &buf_count, ctx);
-		scatterwalk_done_src(&walk, p, n);
+		n = scatterwalk_next(&walk, len);
+		gcm_update_mac(dg, walk.addr, n, buf, &buf_count, ctx);
+		scatterwalk_done_src(&walk, n);
 		len -= n;
 	} while (len);
 
diff --git a/arch/arm64/crypto/sm4-ce-ccm-glue.c b/arch/arm64/crypto/sm4-ce-ccm-glue.c
index 119f86eb7cc9..e9cc1c1364ec 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-ccm-glue.c
@@ -113,10 +113,10 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 
 	do {
 		unsigned int n, orig_n;
-		const u8 *p, *orig_p;
+		const u8 *p;
 
-		orig_p = scatterwalk_next(&walk, assoclen, &orig_n);
-		p = orig_p;
+		orig_n = scatterwalk_next(&walk, assoclen);
+		p = walk.addr;
 		n = orig_n;
 
 		while (n > 0) {
@@ -149,7 +149,7 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 			}
 		}
 
-		scatterwalk_done_src(&walk, orig_p, orig_n);
+		scatterwalk_done_src(&walk, orig_n);
 		assoclen -= orig_n;
 	} while (assoclen);
 }
diff --git a/arch/arm64/crypto/sm4-ce-gcm-glue.c b/arch/arm64/crypto/sm4-ce-gcm-glue.c
index 2e27d7752d4f..c2ea3d5f690b 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-gcm-glue.c
@@ -83,10 +83,10 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u8 ghash[])
 
 	do {
 		unsigned int n, orig_n;
-		const u8 *p, *orig_p;
+		const u8 *p;
 
-		orig_p = scatterwalk_next(&walk, assoclen, &orig_n);
-		p = orig_p;
+		orig_n = scatterwalk_next(&walk, assoclen);
+		p = walk.addr;
 		n = orig_n;
 
 		if (n + buflen < GHASH_BLOCK_SIZE) {
@@ -118,7 +118,7 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u8 ghash[])
 				memcpy(&buffer[0], p, buflen);
 		}
 
-		scatterwalk_done_src(&walk, orig_p, orig_n);
+		scatterwalk_done_src(&walk, orig_n);
 		assoclen -= orig_n;
 	} while (assoclen);
 
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 7fd303df05ab..ed85bd6e298f 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -66,7 +66,6 @@ struct s390_xts_ctx {
 struct gcm_sg_walk {
 	struct scatter_walk walk;
 	unsigned int walk_bytes;
-	u8 *walk_ptr;
 	unsigned int walk_bytes_remain;
 	u8 buf[AES_BLOCK_SIZE];
 	unsigned int buf_bytes;
@@ -789,8 +788,7 @@ static inline unsigned int _gcm_sg_clamp_and_map(struct gcm_sg_walk *gw)
 {
 	if (gw->walk_bytes_remain == 0)
 		return 0;
-	gw->walk_ptr = scatterwalk_next(&gw->walk, gw->walk_bytes_remain,
-					&gw->walk_bytes);
+	gw->walk_bytes = scatterwalk_next(&gw->walk, gw->walk_bytes_remain);
 	return gw->walk_bytes;
 }
 
@@ -799,10 +797,9 @@ static inline void _gcm_sg_unmap_and_advance(struct gcm_sg_walk *gw,
 {
 	gw->walk_bytes_remain -= nbytes;
 	if (out)
-		scatterwalk_done_dst(&gw->walk, gw->walk_ptr, nbytes);
+		scatterwalk_done_dst(&gw->walk, nbytes);
 	else
-		scatterwalk_done_src(&gw->walk, gw->walk_ptr, nbytes);
-	gw->walk_ptr = NULL;
+		scatterwalk_done_src(&gw->walk, nbytes);
 }
 
 static int gcm_in_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
@@ -828,14 +825,14 @@ static int gcm_in_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 	}
 
 	if (!gw->buf_bytes && gw->walk_bytes >= minbytesneeded) {
-		gw->ptr = gw->walk_ptr;
+		gw->ptr = gw->walk.addr;
 		gw->nbytes = gw->walk_bytes;
 		goto out;
 	}
 
 	while (1) {
 		n = min(gw->walk_bytes, AES_BLOCK_SIZE - gw->buf_bytes);
-		memcpy(gw->buf + gw->buf_bytes, gw->walk_ptr, n);
+		memcpy(gw->buf + gw->buf_bytes, gw->walk.addr, n);
 		gw->buf_bytes += n;
 		_gcm_sg_unmap_and_advance(gw, n, false);
 		if (gw->buf_bytes >= minbytesneeded) {
@@ -869,13 +866,13 @@ static int gcm_out_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 	}
 
 	if (gw->walk_bytes >= minbytesneeded) {
-		gw->ptr = gw->walk_ptr;
+		gw->ptr = gw->walk.addr;
 		gw->nbytes = gw->walk_bytes;
 		goto out;
 	}
 
-	scatterwalk_unmap(gw->walk_ptr);
-	gw->walk_ptr = NULL;
+	/* XXX */
+	scatterwalk_unmap(gw->walk.addr);
 
 	gw->ptr = gw->buf;
 	gw->nbytes = sizeof(gw->buf);
@@ -914,7 +911,7 @@ static int gcm_out_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
 			if (!_gcm_sg_clamp_and_map(gw))
 				return i;
 			n = min(gw->walk_bytes, bytesdone - i);
-			memcpy(gw->walk_ptr, gw->buf + i, n);
+			memcpy(gw->walk.addr, gw->buf + i, n);
 			_gcm_sg_unmap_and_advance(gw, n, true);
 		}
 	} else
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 1bd093d073ed..26786e15abac 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -71,10 +71,9 @@ static void crypto_aegis128_aesni_process_ad(
 
 	scatterwalk_start(&walk, sg_src);
 	while (assoclen != 0) {
-		unsigned int size;
-		const u8 *mapped = scatterwalk_next(&walk, assoclen, &size);
+		unsigned int size = scatterwalk_next(&walk, assoclen);
+		const u8 *src = walk.addr;
 		unsigned int left = size;
-		const u8 *src = mapped;
 
 		if (pos + size >= AEGIS128_BLOCK_SIZE) {
 			if (pos > 0) {
@@ -97,7 +96,7 @@ static void crypto_aegis128_aesni_process_ad(
 		pos += left;
 		assoclen -= size;
 
-		scatterwalk_done_src(&walk, mapped, size);
+		scatterwalk_done_src(&walk, size);
 	}
 
 	if (pos > 0) {
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index c4bd05688b55..e141b7995304 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1306,12 +1306,11 @@ static void gcm_process_assoc(const struct aes_gcm_key *key, u8 ghash_acc[16],
 	scatterwalk_start(&walk, sg_src);
 
 	while (assoclen) {
-		unsigned int orig_len_this_step;
-		const u8 *orig_src = scatterwalk_next(&walk, assoclen,
-						      &orig_len_this_step);
+		unsigned int orig_len_this_step = scatterwalk_next(
+			&walk, assoclen);
 		unsigned int len_this_step = orig_len_this_step;
 		unsigned int len;
-		const u8 *src = orig_src;
+		const u8 *src = walk.addr;
 
 		if (unlikely(pos)) {
 			len = min(len_this_step, 16 - pos);
@@ -1335,7 +1334,7 @@ static void gcm_process_assoc(const struct aes_gcm_key *key, u8 ghash_acc[16],
 			pos = len_this_step;
 		}
 next:
-		scatterwalk_done_src(&walk, orig_src, orig_len_this_step);
+		scatterwalk_done_src(&walk, orig_len_this_step);
 		if (need_resched()) {
 			kernel_fpu_end();
 			kernel_fpu_begin();
diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 15d64d836356..72f6ee1345ef 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -284,10 +284,9 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 
 	scatterwalk_start(&walk, sg_src);
 	while (assoclen != 0) {
-		unsigned int size;
-		const u8 *mapped = scatterwalk_next(&walk, assoclen, &size);
+		unsigned int size = scatterwalk_next(&walk, assoclen);
+		const u8 *src = walk.addr;
 		unsigned int left = size;
-		const u8 *src = mapped;
 
 		if (pos + size >= AEGIS_BLOCK_SIZE) {
 			if (pos > 0) {
@@ -308,7 +307,7 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 
 		pos += left;
 		assoclen -= size;
-		scatterwalk_done_src(&walk, mapped, size);
+		scatterwalk_done_src(&walk, size);
 	}
 
 	if (pos > 0) {
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 87c080f565d4..20a28c6d94da 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -34,12 +34,11 @@ inline void memcpy_from_scatterwalk(void *buf, struct scatter_walk *walk,
 				    unsigned int nbytes)
 {
 	do {
-		const void *src_addr;
 		unsigned int to_copy;
 
-		src_addr = scatterwalk_next(walk, nbytes, &to_copy);
-		memcpy(buf, src_addr, to_copy);
-		scatterwalk_done_src(walk, src_addr, to_copy);
+		to_copy = scatterwalk_next(walk, nbytes);
+		memcpy(buf, walk->addr, to_copy);
+		scatterwalk_done_src(walk, to_copy);
 		buf += to_copy;
 		nbytes -= to_copy;
 	} while (nbytes);
@@ -50,12 +49,11 @@ inline void memcpy_to_scatterwalk(struct scatter_walk *walk, const void *buf,
 				  unsigned int nbytes)
 {
 	do {
-		void *dst_addr;
 		unsigned int to_copy;
 
-		dst_addr = scatterwalk_next(walk, nbytes, &to_copy);
-		memcpy(dst_addr, buf, to_copy);
-		scatterwalk_done_dst(walk, dst_addr, to_copy);
+		to_copy = scatterwalk_next(walk, nbytes);
+		memcpy(walk->addr, buf, to_copy);
+		scatterwalk_done_dst(walk, to_copy);
 		buf += to_copy;
 		nbytes -= to_copy;
 	} while (nbytes);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 66d19c360dd8..0c6911154241 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -41,12 +41,16 @@ static int skcipher_walk_next(struct skcipher_walk *walk);
 
 static inline void skcipher_map_src(struct skcipher_walk *walk)
 {
-	walk->src.virt.addr = scatterwalk_map(&walk->in);
+	/* XXX */
+	walk->in.__addr = scatterwalk_map(&walk->in);
+	walk->src.virt.addr = walk->in.addr;
 }
 
 static inline void skcipher_map_dst(struct skcipher_walk *walk)
 {
-	walk->dst.virt.addr = scatterwalk_map(&walk->out);
+	/* XXX */
+	walk->out.__addr = scatterwalk_map(&walk->out);
+	walk->dst.virt.addr = walk->out.addr;
 }
 
 static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
@@ -120,7 +124,7 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 		goto dst_done;
 	}
 
-	scatterwalk_done_dst(&walk->out, walk->dst.virt.addr, n);
+	scatterwalk_done_dst(&walk->out, n);
 dst_done:
 
 	if (res > 0)
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index dd95e5361d88..a3b979193d9b 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -154,17 +154,16 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
 	struct scatter_walk walk;
 	struct nx_sg *nx_sg = nx_dst;
 	unsigned int n, len = *src_len;
-	char *dst;
 
 	/* we need to fast forward through @start bytes first */
 	scatterwalk_start_at_pos(&walk, sg_src, start);
 
 	while (len && (nx_sg - nx_dst) < sglen) {
-		dst = scatterwalk_next(&walk, len, &n);
+		n = scatterwalk_next(&walk, len);
 
-		nx_sg = nx_build_sg_list(nx_sg, dst, &n, sglen - (nx_sg - nx_dst));
+		nx_sg = nx_build_sg_list(nx_sg, walk.addr, &n, sglen - (nx_sg - nx_dst));
 
-		scatterwalk_done_src(&walk, dst, n);
+		scatterwalk_done_src(&walk, n);
 		len -= n;
 	}
 	/* update to_process */
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 94989b2e1350..f92e22686a68 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -54,6 +54,7 @@ struct rtattr;
 struct scatterlist;
 struct seq_file;
 struct sk_buff;
+union crypto_no_such_thing;
 
 struct crypto_instance {
 	struct crypto_alg alg;
@@ -108,6 +109,12 @@ struct crypto_queue {
 struct scatter_walk {
 	struct scatterlist *sg;
 	unsigned int offset;
+	union {
+		void *const addr;
+
+		/* Private API field, do not touch. */
+		union crypto_no_such_thing *__addr;
+	};
 };
 
 struct crypto_attr_alg {
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 3024adbdd443..8523c7591d95 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -120,18 +120,20 @@ static inline void *scatterwalk_map(struct scatter_walk *walk)
  * scatterwalk_next() - Get the next data buffer in a scatterlist walk
  * @walk: the scatter_walk
  * @total: the total number of bytes remaining, > 0
- * @nbytes_ret: (out) the next number of bytes available, <= @total
  *
- * Return: A virtual address for the next segment of data from the scatterlist.
- *	   The caller must call scatterwalk_done_src() or scatterwalk_done_dst()
- *	   when it is done using this virtual address.
+ * A virtual address for the next segment of data from the scatterlist will
+ * be placed into @walk->addr.  The caller must call scatterwalk_done_src()
+ * or scatterwalk_done_dst() when it is done using this virtual address.
+ *
+ * Returns: the next number of bytes available, <= @total
  */
-static inline void *scatterwalk_next(struct scatter_walk *walk,
-				     unsigned int total,
-				     unsigned int *nbytes_ret)
+static inline unsigned int scatterwalk_next(struct scatter_walk *walk,
+					    unsigned int total)
 {
-	*nbytes_ret = scatterwalk_clamp(walk, total);
-	return scatterwalk_map(walk);
+	unsigned int nbytes = scatterwalk_clamp(walk, total);
+
+	walk->__addr = scatterwalk_map(walk);
+	return nbytes;
 }
 
 static inline void scatterwalk_unmap(const void *vaddr)
@@ -149,32 +151,31 @@ static inline void scatterwalk_advance(struct scatter_walk *walk,
 /**
  * scatterwalk_done_src() - Finish one step of a walk of source scatterlist
  * @walk: the scatter_walk
- * @vaddr: the address returned by scatterwalk_next()
  * @nbytes: the number of bytes processed this step, less than or equal to the
  *	    number of bytes that scatterwalk_next() returned.
  *
- * Use this if the @vaddr was not written to, i.e. it is source data.
+ * Use this if the mapped address was not written to, i.e. it is source data.
  */
 static inline void scatterwalk_done_src(struct scatter_walk *walk,
-					const void *vaddr, unsigned int nbytes)
+					unsigned int nbytes)
 {
-	scatterwalk_unmap(vaddr);
+	scatterwalk_unmap(walk->addr);
 	scatterwalk_advance(walk, nbytes);
 }
 
 /**
  * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
  * @walk: the scatter_walk
- * @vaddr: the address returned by scatterwalk_next()
  * @nbytes: the number of bytes processed this step, less than or equal to the
  *	    number of bytes that scatterwalk_next() returned.
  *
- * Use this if the @vaddr may have been written to, i.e. it is destination data.
+ * Use this if the mapped address may have been written to, i.e. it is
+ * destination data.
  */
 static inline void scatterwalk_done_dst(struct scatter_walk *walk,
-					void *vaddr, unsigned int nbytes)
+					unsigned int nbytes)
 {
-	scatterwalk_unmap(vaddr);
+	scatterwalk_unmap(walk->addr);
 	/*
 	 * Explicitly check ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE instead of just
 	 * relying on flush_dcache_page() being a no-op when not implemented,
-- 
2.39.5

