Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04D2371D06;
	Tue, 17 Mar 2026 23:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773790872; cv=none; b=nDnWQYfXz+N4XtLp/a2PJzqJSSZx+PqXh76uuhxJODsbegTRidGbITjtKz+g4xugOfxUW41gEogiNceEHJEL4NGP3ndtIX/flPeM6d7rR/xFgTiAWzKFCqi9U3sH782ypOrL+pV9KYHjKfkGhdoD3N3F8Mn0RXE/q/QHydu8HzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773790872; c=relaxed/simple;
	bh=CxvuzhT7yn1bxb43FXgVqaOVcDutqMVbXzRdDRs1+yE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UNevcRsmHuAce57kEH200RPapoyZLbHemKFAflgQ1vj8CbxuG/MRrJTvvmYwfMk7X01RXXPaeGzGWP9dg10Z9A9PbGFQXHzRRgT1Ek6i+MZE2g3xTLbuaBGde9T7E/A9qdNpMoIXNdvNbNlIlwhFm+TPk7Q0gc+4rU5reqLIt1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIo25Pjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIo25Pjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2B0C4CEF7;
	Tue, 17 Mar 2026 23:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773790871;
	bh=CxvuzhT7yn1bxb43FXgVqaOVcDutqMVbXzRdDRs1+yE=;
	h=Date:From:To:Cc:Subject:From;
	b=QIo25PjlVhaTmhb36pwX1wX2Km+DffM55wYycacRAohJFZCYGrNhfiQfnjOJsbSKt
	 4texU/iWZwdc1Du8sscHMydOh+5PxvlkOyPr2hpsrW+fWwFcw2Q7hZe3bKMcxypqb4
	 1+x/jrtkZ/c8N1vkWqdtbykWDMVM5EmOnvcCfy5gYrZmSmcff5kSv/fufq2sgoqlQ+
	 7fEGBrxW2YdSJ07XhzCsyk4TGxOiprkbrK0BGbJ/5XM1FpwbtzC4PhuOD6g6sIwsZd
	 2a02DddgX7mQynN6C+72Nayvxs8PaPpGxMHc6IdVY55ebdONnszvbCeW7UpT/DPQoz
	 FEE9jcZanG5jQ==
Date: Tue, 17 Mar 2026 17:40:02 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: nx - Fix packed layout in struct nx842_crypto_header
Message-ID: <abnmUvHzhgS9xA-m@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

struct nx842_crypto_header is declared with the __packed attribute,
however	the fields grouped with struct_group_tagged() were not packed.
This caused the grouped header portion of the structure to lose the
packed layout guarantees of the containing structure.

Fix this by replacing struct_group_tagged() with __struct_group(...,
..., __packed, ...) so the grouped fields are packed, and the original
layout is preserved, restoring the intended packed layout of the
structure.

Before changes:
struct nx842_crypto_header {
	union {
		struct {
			__be16     magic;                /*     0     2 */
			__be16     ignore;               /*     2     2 */
			u8         groups;               /*     4     1 */
		};                                       /*     0     6 */
		struct nx842_crypto_header_hdr hdr;      /*     0     6 */
	};                                               /*     0     6 */
	struct nx842_crypto_header_group group[];        /*     6     0 */

	/* size: 6, cachelines: 1, members: 2 */
	/* last cacheline: 6 bytes */
} __attribute__((__packed__));

After changes:
struct nx842_crypto_header {
	union {
		struct {
			__be16     magic;                /*     0     2 */
			__be16     ignore;               /*     2     2 */
			u8         groups;               /*     4     1 */
		} __attribute__((__packed__));           /*     0     5 */
		struct nx842_crypto_header_hdr hdr;      /*     0     5 */
	};                                               /*     0     5 */
	struct nx842_crypto_header_group group[];        /*     5     0 */

	/* size: 5, cachelines: 1, members: 2 */
	/* last cacheline: 5 bytes */
} __attribute__((__packed__));

Fixes: 1e6b251ce175 ("crypto: nx - Avoid -Wflex-array-member-not-at-end warning")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/crypto/nx/nx-842.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index f5e2c82ba876..cd3c1a433e8c 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -159,7 +159,7 @@ struct nx842_crypto_header_group {
 
 struct nx842_crypto_header {
 	/* New members MUST be added within the struct_group() macro below. */
-	struct_group_tagged(nx842_crypto_header_hdr, hdr,
+	__struct_group(nx842_crypto_header_hdr, hdr, __packed,
 		__be16 magic;		/* NX842_CRYPTO_MAGIC */
 		__be16 ignore;		/* decompressed end bytes to ignore */
 		u8 groups;		/* total groups in this header */
@@ -167,7 +167,7 @@ struct nx842_crypto_header {
 	struct nx842_crypto_header_group group[];
 } __packed;
 static_assert(offsetof(struct nx842_crypto_header, group) == sizeof(struct nx842_crypto_header_hdr),
-	      "struct member likely outside of struct_group_tagged()");
+	      "struct member likely outside of __struct_group()");
 
 #define NX842_CRYPTO_GROUP_MAX	(0x20)
 
-- 
2.43.0

