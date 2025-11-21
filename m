Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A86F20C001;
	Fri, 21 Nov 2025 03:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763697387; cv=none; b=Jl7vBW/3DicvBH+HiGbxq2n8c4nQBXJ6HpgrnXXFD5YEGtqQU+KM+/m8Ho0WwA3MzBPDmhXjL3fIf7arb0x7OmPYfFaCYYfVNvwZypXpzwsl4cfpxgcQTLj7lbrwrg5fwDZrjRxUD/VOBs5GX7dgscrFO9e7wojo4uEY+BA84NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763697387; c=relaxed/simple;
	bh=8XL3dUOb38xw/nIl6rQxLx5t0YmPIYakLHvU2i+0dRU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uU4EjU3DuKGsMwyWvWGj1Zpb+8RnLlRzawb9ZqXP4dli6o22whYtCxK097uTpiPq6fx93Sim3j8zXfM9+Aac9Q/mki25x3XZrEywPID2oKLXpD5kFQEa1vyurF7VujOHitAX5NUD/vdzU74u+C1mcrGd/Nx1sBAOsP67Dx2m9+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfyR4E/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfyR4E/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6F2C4CEFB;
	Fri, 21 Nov 2025 03:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763697386;
	bh=8XL3dUOb38xw/nIl6rQxLx5t0YmPIYakLHvU2i+0dRU=;
	h=Date:From:To:Cc:Subject:From;
	b=LfyR4E/piLZ38ZS+5u2qzbL1kRAt4yCtoB2V3gGOQqJvMjoO9TSZZcpiJKaEFpfLf
	 TJB0+R18gCJjnndDYHLhJaHcBOljKEm/FP7pQDTXcGFOzzcElhHbC/nRbybehLWAAX
	 t0zCUQDGZ2to7efXRiH2c3shX1NQ3PY7GWbrCIhysikqZp+mcRROv2+GcDQMj0vzTX
	 t78TwU2GvL4qfwOPT6Y859JRnqKb3wApgCh6kJi5+cYg/yrztPwoonasY1WPKL/jz8
	 YGuRQhB3OMx8K5w+mSk5FERBSf+xgd0YJnfnTfilxEi8BlMPHEkJZuWDOCMiFmCpG4
	 FHBFmBIdO2Dmw==
Date: Fri, 21 Nov 2025 12:56:21 +0900
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] crypto: starfive - Avoid
 -Wflex-array-member-not-at-end warning
Message-ID: <aR_i5fbRzQztlaHz@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Move the conflicting declaration to the end of the corresponding
structure. Notice that `struct ahash_request` is a flexible structure,
this is a structure that contains a flexible-array member.

With these changes fix the following warning:

drivers/crypto/starfive/jh7110-cryp.h:219:49: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 5ed4ba5da7f9..f85d6fb81ca8 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -216,13 +216,15 @@ struct starfive_cryp_request_ctx {
 
 	struct scatterlist			*in_sg;
 	struct scatterlist			*out_sg;
-	struct ahash_request			ahash_fbk_req;
 	size_t					total;
 	unsigned int				blksize;
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
 	unsigned char				*adata;
 	u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ] __aligned(sizeof(u32));
+
+	/* Must be last as it ends in a flexible-array member. */
+	struct ahash_request			ahash_fbk_req;
 };
 
 struct starfive_cryp_dev *starfive_cryp_find_dev(struct starfive_cryp_ctx *ctx);
-- 
2.43.0

