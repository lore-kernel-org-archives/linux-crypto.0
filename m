Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C2399008;
	Fri, 23 Jan 2026 05:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769145461; cv=none; b=aI4fouKVOgD3G01DSlVgF0R5g7FrINFzOTL+S4yilVWWdWyclhlZVQG4UZAIDlXx0fs+2/wLgf8ecCvWdrU3w0RD4ArvY3luO/p0U9tHFvzolkcBGIEwg88vYqLe3oSaQSK0jtpT+8PAoo+C41/sWuzzYy2jssXM+5MNCSU3Gho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769145461; c=relaxed/simple;
	bh=TA7l4c73Foq847JNmtkHCGtXzkUUf0pvqlfQIrvopXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z69YzrB3GJr/yXNSD65WjtNAPRMfpmtVECjZH+a4+yJabI5r/VKHHRWiN5KgJm0bPDDxI1/6Wjf3HQiHOdhgIGnafznOHxrpqSPE9EGc9+rMvLbSh48QIFKLM1ULBVKQWwtVXs8F8T5l2EWEIEqiYgFrAdZ0yWktq7fRL42aDE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhlv2abz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhlv2abz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435FBC19424;
	Fri, 23 Jan 2026 05:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769145460;
	bh=TA7l4c73Foq847JNmtkHCGtXzkUUf0pvqlfQIrvopXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhlv2abzTsMJ9Mfn7/wkLUmu+Xka6vASGtzPiPUk1YjbveHDQvk0I0LbZqDnDxkiG
	 1Dl2zsxqvXSmrQcSwJLOqy+XgKTJc5hsJeGJGJHqqM3rg5RdxR003pRQi6HpLYqSYj
	 fvBPtNWRM3vHMKB/RFDjmRU8S2oQejdi91yPpxS0VPPf5KUCHjU6Hi4yerzR84EBSr
	 EYb749Qw2qf3fAjOjl1eRjSyeW/Pcjow7Vv9zQIvO+ztb+5nQhhdT3FMwIEylxGVSA
	 EZhbBzumUebz5Pq/xpVvUkh+Cm6rS93Jf6/c/Y3eFwYsAUvSj5pGHadxV94jsh4r3Y
	 bk8mY0kV5FrHg==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next 1/2] ipv6: Switch to higher-level SHA-1 functions
Date: Thu, 22 Jan 2026 21:16:55 -0800
Message-ID: <20260123051656.396371-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260123051656.396371-1-ebiggers@kernel.org>
References: <20260123051656.396371-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's now a proper SHA-1 API that follows the usual conventions for
hash function APIs: sha1_init(), sha1_update(), sha1_final(), sha1().
The only remaining user of the older low-level SHA-1 API,
sha1_init_raw() and sha1_transform(), is ipv6_generate_stable_address().
I'd like to remove this older API, which is too low-level.

Unfortunately, ipv6_generate_stable_address() does in fact skip the
SHA-1 finalization for some reason.  So the values it computes are not
standard SHA-1 values, and it sort of does want the low-level API.

Still, it's still possible to use the higher-level functions sha1_init()
and sha1_update() to get the same result, provided that the resulting
state is used directly, skipping sha1_final().

So, let's do that instead.  This will allow removing the low-level API.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/ipv6/addrconf.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 7138e0e67991..6db9cf9e2a50 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3337,15 +3337,14 @@ static bool ipv6_reserved_interfaceid(struct in6_addr address)
 static int ipv6_generate_stable_address(struct in6_addr *address,
 					u8 dad_count,
 					const struct inet6_dev *idev)
 {
 	static DEFINE_SPINLOCK(lock);
-	static __u32 digest[SHA1_DIGEST_WORDS];
-	static __u32 workspace[SHA1_WORKSPACE_WORDS];
+	static struct sha1_ctx sha_ctx;
 
 	static union {
-		char __data[SHA1_BLOCK_SIZE];
+		u8 __data[SHA1_BLOCK_SIZE];
 		struct {
 			struct in6_addr secret;
 			__be32 prefix[2];
 			unsigned char hwaddr[MAX_ADDR_LEN];
 			u8 dad_count;
@@ -3366,24 +3365,30 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
 		return -1;
 
 retry:
 	spin_lock_bh(&lock);
 
-	sha1_init_raw(digest);
+	sha1_init(&sha_ctx);
+
 	memset(&data, 0, sizeof(data));
-	memset(workspace, 0, sizeof(workspace));
 	memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
 	data.prefix[0] = address->s6_addr32[0];
 	data.prefix[1] = address->s6_addr32[1];
 	data.secret = secret;
 	data.dad_count = dad_count;
 
-	sha1_transform(digest, data.__data, workspace);
+	sha1_update(&sha_ctx, data.__data, sizeof(data));
 
+	/*
+	 * Note that the SHA-1 finalization is omitted here, and the digest is
+	 * pulled directly from the internal SHA-1 state (making it incompatible
+	 * with standard SHA-1).  Unusual, but technically okay since the data
+	 * length is fixed and is a multiple of the SHA-1 block size.
+	 */
 	temp = *address;
-	temp.s6_addr32[2] = (__force __be32)digest[0];
-	temp.s6_addr32[3] = (__force __be32)digest[1];
+	temp.s6_addr32[2] = (__force __be32)sha_ctx.state.h[0];
+	temp.s6_addr32[3] = (__force __be32)sha_ctx.state.h[1];
 
 	spin_unlock_bh(&lock);
 
 	if (ipv6_reserved_interfaceid(temp)) {
 		dad_count++;
-- 
2.52.0

