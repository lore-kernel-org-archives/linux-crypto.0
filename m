Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD8BC47254
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0062084D
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588444102;
	bh=RK8WSLvwLE/+KQXv3uzmAZJ21l9CkoopTGz625NL01I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cFf/QoDAR0yzFn+/QhzhxZgQHhvyybNUt7+tpww7vZnGfrt74/PPuBVyLJrRn54sk
	 bSmNceIXbhw2H8kNTFRzf1ISAfkAd1YzHIfLsYJL52l90IuswGbATFapNZLL+SETMb
	 KAhYb7rkjAIxLydvjm+pwOJoPWz2InKd+ppm2bCs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgEBS2O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 14:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728454AbgEBS2J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 14:28:09 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F4F2078E;
        Sat,  2 May 2020 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588444089;
        bh=RK8WSLvwLE/+KQXv3uzmAZJ21l9CkoopTGz625NL01I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlLEXs2ze59RmCShsIDrcsLA18LHPKKDT9wIPx8qLa8/OAI9erh5ztSmoToapDeSH
         6STNYcBV29ppsBeOD6EgKO79U2QABo6qzDYKIBsktmFyBNK8vj2c1hX3DGJYr1uRzg
         sZrJ77Q5s+C5JNvyvvzaF8OLLPhTIMtrEHQYYOLg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/7] crypto: lib/sha1 - rename "sha" to "sha1"
Date:   Sat,  2 May 2020 11:24:25 -0700
Message-Id: <20200502182427.104383-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502182427.104383-1-ebiggers@kernel.org>
References: <20200502182427.104383-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The library implementation of the SHA-1 compression function is
confusingly called just "sha_transform()".  Alongside it are some "SHA_"
constants and "sha_init()".  Presumably these are left over from a time
when SHA just meant SHA-1.  But now there are also SHA-2 and SHA-3, and
moreover SHA-1 is now considered insecure and thus shouldn't be used.

Therefore, rename these functions and constants to make it very clear
that they are for SHA-1.  Also add a comment to make it clear that these
shouldn't be used.

For the extra-misleadingly named "SHA_MESSAGE_BYTES", rename it to
SHA1_BLOCK_SIZE and define it to just '64' rather than '(512/8)' so that
it matches the same definition in <crypto/sha.h>.  This prepares for
merging <linux/cryptohash.h> into <crypto/sha.h>.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/security/siphash.rst |  2 +-
 crypto/sha1_generic.c              |  4 ++--
 drivers/char/random.c              |  6 +++---
 include/linux/cryptohash.h         | 16 ++++++++++------
 include/linux/filter.h             |  2 +-
 kernel/bpf/core.c                  | 18 +++++++++---------
 lib/sha1.c                         | 22 ++++++++++++----------
 net/ipv6/addrconf.c                | 10 +++++-----
 8 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/Documentation/security/siphash.rst b/Documentation/security/siphash.rst
index 4eba68cdf0a120..bd9363025fcbc1 100644
--- a/Documentation/security/siphash.rst
+++ b/Documentation/security/siphash.rst
@@ -7,7 +7,7 @@ SipHash - a short input PRF
 SipHash is a cryptographically secure PRF -- a keyed hash function -- that
 performs very well for short inputs, hence the name. It was designed by
 cryptographers Daniel J. Bernstein and Jean-Philippe Aumasson. It is intended
-as a replacement for some uses of: `jhash`, `md5_transform`, `sha_transform`,
+as a replacement for some uses of: `jhash`, `md5_transform`, `sha1_transform`,
 and so forth.
 
 SipHash takes a secret key filled with randomly generated numbers and either
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 7c57b844c38275..a16d9787dcd2c1 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -31,10 +31,10 @@ EXPORT_SYMBOL_GPL(sha1_zero_message_hash);
 static void sha1_generic_block_fn(struct sha1_state *sst, u8 const *src,
 				  int blocks)
 {
-	u32 temp[SHA_WORKSPACE_WORDS];
+	u32 temp[SHA1_WORKSPACE_WORDS];
 
 	while (blocks--) {
-		sha_transform(sst->state, src, temp);
+		sha1_transform(sst->state, src, temp);
 		src += SHA1_BLOCK_SIZE;
 	}
 	memzero_explicit(temp, sizeof(temp));
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0d10e31fd342f5..a19a8984741b60 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1397,14 +1397,14 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 		__u32 w[5];
 		unsigned long l[LONGS(20)];
 	} hash;
-	__u32 workspace[SHA_WORKSPACE_WORDS];
+	__u32 workspace[SHA1_WORKSPACE_WORDS];
 	unsigned long flags;
 
 	/*
 	 * If we have an architectural hardware random number
 	 * generator, use it for SHA's initial vector
 	 */
-	sha_init(hash.w);
+	sha1_init(hash.w);
 	for (i = 0; i < LONGS(20); i++) {
 		unsigned long v;
 		if (!arch_get_random_long(&v))
@@ -1415,7 +1415,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	spin_lock_irqsave(&r->lock, flags);
 	for (i = 0; i < r->poolinfo->poolwords; i += 16)
-		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
+		sha1_transform(hash.w, (__u8 *)(r->pool + i), workspace);
 
 	/*
 	 * We mix the hash back into the pool to prevent backtracking
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index f6ba4c3e60d793..c324ffca96e0d5 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -4,11 +4,15 @@
 
 #include <uapi/linux/types.h>
 
-#define SHA_DIGEST_WORDS 5
-#define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
-#define SHA_WORKSPACE_WORDS 16
-
-void sha_init(__u32 *buf);
-void sha_transform(__u32 *digest, const char *data, __u32 *W);
+/*
+ * An implementation of SHA-1's compression function.  Don't use in new code!
+ * You shouldn't be using SHA-1, and even if you *have* to use SHA-1, this isn't
+ * the correct way to hash something with SHA-1 (use crypto_shash instead).
+ */
+#define SHA1_DIGEST_WORDS 5
+#define SHA1_BLOCK_SIZE 64
+#define SHA1_WORKSPACE_WORDS 16
+void sha1_init(__u32 *buf);
+void sha1_transform(__u32 *digest, const char *data, __u32 *W);
 
 #endif
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9b5aa5c483ccb5..f42662adffe47f 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -746,7 +746,7 @@ static inline u32 bpf_prog_insn_size(const struct bpf_prog *prog)
 static inline u32 bpf_prog_tag_scratch_size(const struct bpf_prog *prog)
 {
 	return round_up(bpf_prog_insn_size(prog) +
-			sizeof(__be64) + 1, SHA_MESSAGE_BYTES);
+			sizeof(__be64) + 1, SHA1_BLOCK_SIZE);
 }
 
 static inline unsigned int bpf_prog_size(unsigned int proglen)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 916f5132a9848d..14aa1f74dd10dc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -262,10 +262,10 @@ void __bpf_prog_free(struct bpf_prog *fp)
 
 int bpf_prog_calc_tag(struct bpf_prog *fp)
 {
-	const u32 bits_offset = SHA_MESSAGE_BYTES - sizeof(__be64);
+	const u32 bits_offset = SHA1_BLOCK_SIZE - sizeof(__be64);
 	u32 raw_size = bpf_prog_tag_scratch_size(fp);
-	u32 digest[SHA_DIGEST_WORDS];
-	u32 ws[SHA_WORKSPACE_WORDS];
+	u32 digest[SHA1_DIGEST_WORDS];
+	u32 ws[SHA1_WORKSPACE_WORDS];
 	u32 i, bsize, psize, blocks;
 	struct bpf_insn *dst;
 	bool was_ld_map;
@@ -277,7 +277,7 @@ int bpf_prog_calc_tag(struct bpf_prog *fp)
 	if (!raw)
 		return -ENOMEM;
 
-	sha_init(digest);
+	sha1_init(digest);
 	memset(ws, 0, sizeof(ws));
 
 	/* We need to take out the map fd for the digest calculation
@@ -308,8 +308,8 @@ int bpf_prog_calc_tag(struct bpf_prog *fp)
 	memset(&raw[psize], 0, raw_size - psize);
 	raw[psize++] = 0x80;
 
-	bsize  = round_up(psize, SHA_MESSAGE_BYTES);
-	blocks = bsize / SHA_MESSAGE_BYTES;
+	bsize  = round_up(psize, SHA1_BLOCK_SIZE);
+	blocks = bsize / SHA1_BLOCK_SIZE;
 	todo   = raw;
 	if (bsize - psize >= sizeof(__be64)) {
 		bits = (__be64 *)(todo + bsize - sizeof(__be64));
@@ -320,12 +320,12 @@ int bpf_prog_calc_tag(struct bpf_prog *fp)
 	*bits = cpu_to_be64((psize - 1) << 3);
 
 	while (blocks--) {
-		sha_transform(digest, todo, ws);
-		todo += SHA_MESSAGE_BYTES;
+		sha1_transform(digest, todo, ws);
+		todo += SHA1_BLOCK_SIZE;
 	}
 
 	result = (__force __be32 *)digest;
-	for (i = 0; i < SHA_DIGEST_WORDS; i++)
+	for (i = 0; i < SHA1_DIGEST_WORDS; i++)
 		result[i] = cpu_to_be32(digest[i]);
 	memcpy(fp->tag, result, sizeof(fp->tag));
 
diff --git a/lib/sha1.c b/lib/sha1.c
index 1d96d2c02b8269..b381e8cd4fe447 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -64,22 +64,24 @@
 #define T_60_79(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) ,  0xca62c1d6, A, B, C, D, E )
 
 /**
- * sha_transform - single block SHA1 transform
+ * sha1_transform - single block SHA1 transform (deprecated)
  *
  * @digest: 160 bit digest to update
  * @data:   512 bits of data to hash
  * @array:  16 words of workspace (see note)
  *
- * This function generates a SHA1 digest for a single 512-bit block.
- * Be warned, it does not handle padding and message digest, do not
- * confuse it with the full FIPS 180-1 digest algorithm for variable
- * length messages.
+ * This function executes SHA-1's internal compression function.  It updates the
+ * 160-bit internal state (@digest) with a single 512-bit data block (@data).
+ *
+ * Don't use this function.  SHA-1 is no longer considered secure.  And even if
+ * you do have to use SHA-1, this isn't the correct way to hash something with
+ * SHA-1 as this doesn't handle padding and finalization.
  *
  * Note: If the hash is security sensitive, the caller should be sure
  * to clear the workspace. This is left to the caller to avoid
  * unnecessary clears between chained hashing operations.
  */
-void sha_transform(__u32 *digest, const char *data, __u32 *array)
+void sha1_transform(__u32 *digest, const char *data, __u32 *array)
 {
 	__u32 A, B, C, D, E;
 
@@ -185,13 +187,13 @@ void sha_transform(__u32 *digest, const char *data, __u32 *array)
 	digest[3] += D;
 	digest[4] += E;
 }
-EXPORT_SYMBOL(sha_transform);
+EXPORT_SYMBOL(sha1_transform);
 
 /**
- * sha_init - initialize the vectors for a SHA1 digest
+ * sha1_init - initialize the vectors for a SHA1 digest
  * @buf: vector to initialize
  */
-void sha_init(__u32 *buf)
+void sha1_init(__u32 *buf)
 {
 	buf[0] = 0x67452301;
 	buf[1] = 0xefcdab89;
@@ -199,4 +201,4 @@ void sha_init(__u32 *buf)
 	buf[3] = 0x10325476;
 	buf[4] = 0xc3d2e1f0;
 }
-EXPORT_SYMBOL(sha_init);
+EXPORT_SYMBOL(sha1_init);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 24e319dfb5103d..f131cedf5ba677 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3222,11 +3222,11 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
 					const struct inet6_dev *idev)
 {
 	static DEFINE_SPINLOCK(lock);
-	static __u32 digest[SHA_DIGEST_WORDS];
-	static __u32 workspace[SHA_WORKSPACE_WORDS];
+	static __u32 digest[SHA1_DIGEST_WORDS];
+	static __u32 workspace[SHA1_WORKSPACE_WORDS];
 
 	static union {
-		char __data[SHA_MESSAGE_BYTES];
+		char __data[SHA1_BLOCK_SIZE];
 		struct {
 			struct in6_addr secret;
 			__be32 prefix[2];
@@ -3251,7 +3251,7 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
 retry:
 	spin_lock_bh(&lock);
 
-	sha_init(digest);
+	sha1_init(digest);
 	memset(&data, 0, sizeof(data));
 	memset(workspace, 0, sizeof(workspace));
 	memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
@@ -3260,7 +3260,7 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
 	data.secret = secret;
 	data.dad_count = dad_count;
 
-	sha_transform(digest, data.__data, workspace);
+	sha1_transform(digest, data.__data, workspace);
 
 	temp = *address;
 	temp.s6_addr32[2] = (__force __be32)digest[0];
-- 
2.26.2

