Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FB11B5EB5;
	Sun, 24 Aug 2025 01:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755999615; cv=none; b=BbiFxp24A3ewSidhMXg1X1O0fqcRQBv53PdfW2HnqdxZ3VUSfPGfyIzt0kgpwa8lQU4HR0xn/Y8lo6tDpX9EgLil41ubzmKAYaCHtJDxY9CRx9wvj0skFsJRfCwT65rBZtIyWrc8Tbz9C3I0XZvwuT9l5KSrsxaCfxi9P44TG6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755999615; c=relaxed/simple;
	bh=74MZ/QYcgMDKh0OnnQwQGc2Vtko7e/AchpyLxUwJLCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaNQbI2MOio+cykyNlmn0GyzDFF6i0gch58QnF+TNUBW3M4cIG723j7O9qvR6VI4WGmR/oDduFv6TJnxRwjdEpTnevTtDms6rKbFtiOs2U+ve56XxH0Ew/adc8FMh1ExoePelfX3qbpGaZHnT8OZ9pciGp7/aT4a/i1vfl0NFu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9BM5ZG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9BM5ZG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE247C113CF;
	Sun, 24 Aug 2025 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755999614;
	bh=74MZ/QYcgMDKh0OnnQwQGc2Vtko7e/AchpyLxUwJLCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9BM5ZG5XEnY8H7sOOSQ3uHhdI181HQEC9tjpDvqx1P/Vtn7iVKVNcFoIP9B1Bbgv
	 1kcf2TugjXc/+WKoRibUT0hOP5t8Vki8/h8u03Y6uc0mpC0vAu3lOTRr8X9jZVt+1P
	 QI42znJV4KIZ9UQ9nTZzk5XHeuije23mapkR2XpabNFeRJrse2exkD3/NJ70HSwavH
	 dtaFbcxhsFSZ2k8vphwPVzTD3Ruuggyoi38ZcEqO10BOwALHGTKhzbyZpL8KPvXTdY
	 EQ/eLB+DIA81yK26hxPcoIjpeWpWfCWqWwZSygje+bWy3vaGvyE1kziPCZTNJHyTlH
	 eUl4Uxu5+lpIw==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	Andrea Mayer <andrea.mayer@uniroma2.it>
Cc: David Lebrun <dlebrun@google.com>,
	Minhong He <heminhong@kylinos.cn>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next v2 2/2] ipv6: sr: Prepare HMAC key ahead of time
Date: Sat, 23 Aug 2025 21:36:44 -0400
Message-ID: <20250824013644.71928-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250824013644.71928-1-ebiggers@kernel.org>
References: <20250824013644.71928-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare the HMAC key when it is added to the kernel, instead of
preparing it implicitly for every packet.  This significantly improves
the performance of seg6_hmac_compute().  A microbenchmark on x86_64
shows seg6_hmac_compute() (with HMAC-SHA256) dropping from ~1978 cycles
to ~1419 cycles, a 28% improvement.

The size of 'struct seg6_hmac_info' increases by 128 bytes, but that
should be fine, since there should not be a massive number of keys.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/net/seg6_hmac.h |  8 ++++++++
 net/ipv6/seg6_hmac.c    | 14 +++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/seg6_hmac.h b/include/net/seg6_hmac.h
index 3fe4123dbbf0a..e9f41725933e4 100644
--- a/include/net/seg6_hmac.h
+++ b/include/net/seg6_hmac.h
@@ -7,10 +7,12 @@
  */
 
 #ifndef _NET_SEG6_HMAC_H
 #define _NET_SEG6_HMAC_H
 
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
 #include <net/flow.h>
 #include <net/ip6_fib.h>
 #include <net/sock.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -24,13 +26,19 @@
 struct seg6_hmac_info {
 	struct rhash_head node;
 	struct rcu_head rcu;
 
 	u32 hmackeyid;
+	/* The raw key, kept only so it can be returned back to userspace */
 	char secret[SEG6_HMAC_SECRET_LEN];
 	u8 slen;
 	u8 alg_id;
+	/* The prepared key, which the calculations actually use */
+	union {
+		struct hmac_sha1_key sha1;
+		struct hmac_sha256_key sha256;
+	} key;
 };
 
 extern int seg6_hmac_compute(struct seg6_hmac_info *hinfo,
 			     struct ipv6_sr_hdr *hdr, struct in6_addr *saddr,
 			     u8 *output);
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 61f6019df55b6..ee6bac0160ace 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -146,23 +146,22 @@ int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 		off += 16;
 	}
 
 	switch (hinfo->alg_id) {
 	case SEG6_HMAC_ALGO_SHA1:
-		hmac_sha1_usingrawkey(hinfo->secret, hinfo->slen, ring, plen,
-				      output);
+		hmac_sha1(&hinfo->key.sha1, ring, plen, output);
 		static_assert(SEG6_HMAC_FIELD_LEN > SHA1_DIGEST_SIZE);
 		memset(&output[SHA1_DIGEST_SIZE], 0,
 		       SEG6_HMAC_FIELD_LEN - SHA1_DIGEST_SIZE);
 		break;
 	case SEG6_HMAC_ALGO_SHA256:
-		hmac_sha256_usingrawkey(hinfo->secret, hinfo->slen, ring, plen,
-					output);
+		hmac_sha256(&hinfo->key.sha256, ring, plen, output);
 		static_assert(SEG6_HMAC_FIELD_LEN == SHA256_DIGEST_SIZE);
 		break;
 	default:
-		ret = -ENOENT;
+		WARN_ON_ONCE(1);
+		ret = -EINVAL;
 		break;
 	}
 	local_unlock_nested_bh(&hmac_storage.bh_lock);
 	local_bh_enable();
 	return ret;
@@ -236,11 +235,16 @@ int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	int err;
 
 	switch (hinfo->alg_id) {
 	case SEG6_HMAC_ALGO_SHA1:
+		hmac_sha1_preparekey(&hinfo->key.sha1,
+				     hinfo->secret, hinfo->slen);
+		break;
 	case SEG6_HMAC_ALGO_SHA256:
+		hmac_sha256_preparekey(&hinfo->key.sha256,
+				       hinfo->secret, hinfo->slen);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-- 
2.50.1

