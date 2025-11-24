Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EC62F49EC;
	Mon, 24 Nov 2025 09:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763975495; cv=none; b=AWeS5x8gPs+8w5Mz2PrlvK655EwImYNL1dEyMDiNXGfABACQmPZyW/9fLCA2FAgMUHe+10K+CEvVwKCdhPcK8E7Zh2nMeTl25iMed3mivHCpTijDOusdtLn2/0oscFLMb/EL9a1Ja1BNMMf4pvdh1VSlaDs/rVZdoXqvB4y2mtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763975495; c=relaxed/simple;
	bh=kxGpo/egBIFq7+bW7hMJPBwGl+t/HkgquWHWxMcBps0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Vg8ppLvA4mBv8PPyKYR2rSBp83bZh1QvIqiLBKdg3ShSUwVhtEuYFSTgsyamW1Tv68m7N0MMI2hV5v/k+5DMZine/VKTnROZu6xeKCgfN69q2R5yU+IpDSlPuhfBQnqITjVX4wclxeUMX4y4+eUkTNFCXTAuKiFwLXvjXYkatU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebjjOIGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebjjOIGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218ABC4CEF1;
	Mon, 24 Nov 2025 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763975495;
	bh=kxGpo/egBIFq7+bW7hMJPBwGl+t/HkgquWHWxMcBps0=;
	h=Date:From:To:Cc:Subject:From;
	b=ebjjOIGGtmKWVy+EtYu4XZgPXZkbHhaEuF+1cCF7OYJPT3McEyBJRISrruMP4sO+r
	 9YFgH4eIaDou+bCg2gfG+vBYtPu6GRSvYL/OfIT0+rGM5PZLsqPr8EwIBxzTt7wQLB
	 PcFE+GkTDeyd4l/X5g968l00EL8JnJZfohYR+fguqP25XxZVa+5MhdeLzw+Hex8xJo
	 y3U0TrC1lAyGNQB56PHSOfRcmT9qg8PMiRTu5k/nELgEiL+6ofbzJ53DKQWXEKUbP0
	 LB7ziiPu2Eve/3UydhUfsC6vIGpfFB7AGhviGHSGN9m+CewCec0iNwtCclwr45V2/J
	 Qm+HhPs6H5yOQ==
Date: Mon, 24 Nov 2025 18:11:30 +0900
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] crypto: sun8i-ss - Avoid
 -Wflex-array-member-not-at-end warning
Message-ID: <aSQhQh1xyp-zauPM@kspp>
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

drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h:251:30: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index ae66eb45fb24..3fc86225edaf 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -248,9 +248,11 @@ struct sun8i_ss_hash_tfm_ctx {
 struct sun8i_ss_hash_reqctx {
 	struct sginfo t_src[MAX_SG];
 	struct sginfo t_dst[MAX_SG];
-	struct ahash_request fallback_req;
 	u32 method;
 	int flow;
+
+	/* Must be last as it ends in a flexible-array member. */
+	struct ahash_request fallback_req;
 };
 
 /*
-- 
2.43.0

