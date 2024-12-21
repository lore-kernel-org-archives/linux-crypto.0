Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C931F2369
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772294; cv=none; b=OneiNwUKSo+tn7D60vNywp+vVSoPmmsdhrcptr9HxC7GjNYczhiH2A9eGfscOhGHJVS7Pndny+Q/Z+Pnpy4GJIyskQvk7e0pnQaWsEr0bkYn6oTi2T9sTcR6B2CMCFQ+UGPbxyLCAprhVEtxS5IYbk56mgDB3OO4e+1npqP84AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772294; c=relaxed/simple;
	bh=ouuUySUoLhMrrlBcXOe8B+9HrJzjwC7w9DOOQhZHjCM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxHxw61zpB/Z9ncY+95TEKqT7FhX4MgqrXjecKyxBaUppb5LOtiwSS0ACLQh7vxKyWe4DrNrOFeP+b3JlfygnfJ1YZdhQGBNsNKAiXwEs5rm32JhApZiwhuT9k3emqOgKsehGeDavVVbPChiUDYoYxC/ZNnVt734fKbfV8DwffQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qV/4wEpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qV/4wEpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3816C4CED4
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772294;
	bh=ouuUySUoLhMrrlBcXOe8B+9HrJzjwC7w9DOOQhZHjCM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qV/4wEpA+ibhPg11jbI9o4q2nunPZbAcT+wP9GN67Jq1/0x61BjIij5c95CNCjI7w
	 5rXZ+oycnkyiR4OFUaNAl7OlBOuoSZREQnMIpAQxJ5YgeLGQ41/pLu2+CEiH4ONZ7I
	 ZNdYCHD8o4vIGi6zxUA4fYUxuaI0InDPptpqkv7SsVBtL8VEYwsoGQNSaIDXdCSLRc
	 DcZkUl9so4ugjbrtdP1K30tpkUpC4VYHK1KIAgBl3nfMCMB+5GvuNH0iTyVFYEZfrQ
	 gsjg4ch3NnYHzVy2ac5TJyDDhtuebmOpYLFWvFOMuK8xc4jTJPWhAXQhdEj6RTlV/B
	 zpRfxB8wNatxg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 16/29] crypto: aegis - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:43 -0800
Message-ID: <20241221091056.282098-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Use scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map(), and use scatterwalk_done_src() which consolidates
scatterwalk_unmap(), scatterwalk_advance(), and scatterwalk_done().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aegis128-core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 6cbff298722b..15d64d836356 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -282,14 +282,14 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 	union aegis_block buf;
 	unsigned int pos = 0;
 
 	scatterwalk_start(&walk, sg_src);
 	while (assoclen != 0) {
-		unsigned int size = scatterwalk_clamp(&walk, assoclen);
+		unsigned int size;
+		const u8 *mapped = scatterwalk_next(&walk, assoclen, &size);
 		unsigned int left = size;
-		void *mapped = scatterwalk_map(&walk);
-		const u8 *src = (const u8 *)mapped;
+		const u8 *src = mapped;
 
 		if (pos + size >= AEGIS_BLOCK_SIZE) {
 			if (pos > 0) {
 				unsigned int fill = AEGIS_BLOCK_SIZE - pos;
 				memcpy(buf.bytes + pos, src, fill);
@@ -306,13 +306,11 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 
 		memcpy(buf.bytes + pos, src, left);
 
 		pos += left;
 		assoclen -= size;
-		scatterwalk_unmap(mapped);
-		scatterwalk_advance(&walk, size);
-		scatterwalk_done(&walk, 0, assoclen);
+		scatterwalk_done_src(&walk, mapped, size);
 	}
 
 	if (pos > 0) {
 		memset(buf.bytes + pos, 0, AEGIS_BLOCK_SIZE - pos);
 		crypto_aegis128_update_a(state, &buf, do_simd);
-- 
2.47.1

