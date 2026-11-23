Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446682;
	b=QTRw46qL0HWNv7iDH6gyBDEBeaKtzUivl3o0zfpzT6O/0pWACBFOEKnI9E2kW7FxpW4t
	 OiZ0hchRKXu+KjH5KwTyFxeF0khH3EHpkJ6hePuoAVJl3/OcKzUapmHmqmUA8F1p8ahkk
	 FpSkEuHNSBkplk1jxWtDayzKbbY3Py6CyX5yD75OPqgiNAIUD79egIuhpxvFLnz+qD1+W
	 zTl5drlo6s+dfjI8u4LIH7FxRRyDldyUvE4dqLT8qedlAzL1o+OLD5U5zFcuYz8TnDcDw
	 BRjB9ngYSJBjYerTg2tSVk2N9I+1/+2icTuXzXGY22BK4Xsog0V2Kj2i5M36Q1nJgRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hPXU2bp2qVBky501pym5ITbQERgal8i7JlWJJLX9Ua4=;
	b=KAP0UkIy2mRd/cjPNYIDkRj8+7YCECYiOU8KkPRGK71UJUiOYUKlfYwlRxFr6EqXiNoD
	 gWlX6EYxyWV1TX8/NF8aMEvByEgLf7TsK8x0ZifHa19VpbyabDj57yxoL6bZY/uQ0PeQT
	 FWeSaI8OC6tlU3kd9SnBgyEaSLksLshadvRy8a/ZpKN2ZGSkFcK6l099NJkKQBdBoJsxS
	 bRsEQ+EAFoG4YvB96kYE7PrfgN1C4tF5MAhbQTURFSlhaoTWZDtOO/Ge94ajgxY/N6G+V
	 uwnSBLiia6tA/1QRJHQ3DuJI1GnB8Y+s/jR2+e9HirOKFeGjBXClW8zhtxwLZZkGMMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DRvXtDMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA8606A31A;
	Mon, 23 Nov 2026 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DRvXtDMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40101F000EC;
	Mon, 23 Nov 2026 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446682;
	bh=hPXU2bp2qVBky501pym5ITbQERgal8i7JlWJJLX9Ua4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRvXtDMV8Xq3IB/fqMU8ftZglRfo6AkjwDFvnYXM+iVZErHW7s5UrOv+UrztMAV7I
	 dJAgJ3xZGXN89SkOgjZSEbwLz+ToRM3X5aZgVxFTz9aDPHR7HRMNHiq5UzPCfIwbZc
	 kusVfRrMJR4cEHPDote8g02LQAbF4xqW3LUg4TVtpZ3xkogCyll31ONTir52OkEmv5
	 Sx8qN+VjQlc2WLi5qof6Pxa0UTe53rvlplKmod8SUFGbMLBAlEpsdAnbLS6JdZsorY
	 HDYE4tKBxkj220k9j5oMp+jLQencM3bgkcR3ZvLxpAd+/LUSEaUYgX8VgJpiaVxb8B
	 xdufvS8teT2cg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 02/10] crypto: marvell - Fix AEAD key buffer overflow for SHA-384/512 HMAC
Date: Mon, 23 Nov 2026 15:09:53 +0000
Message-ID: <20261123151055.2533735-3-lee@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123151055.2533735-1-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 311eea7e37c4 ("crypto: octeontx - Fix authenc setkey") and commit
7ccb750dcac8 ("crypto: octeontx2 - Fix authenc setkey") updated
aead_hmac_init() in the OcteonTX and OcteonTX2 CPT VF drivers to hash
authentication keys only when authkeylen exceeds the hash block size
(128 bytes for SHA-384 and SHA-512), copying shorter keys directly into
ctx->key followed by the encryption key.

However, OTX_CPT_MAX_HASH_KEY_SIZE and OTX2_CPT_MAX_HASH_KEY_SIZE are
defined as 64 rather than 128, sizing ctx->key at only 96 bytes.  An
HMAC-SHA384 or HMAC-SHA512 AEAD key with an authentication key between
65 and 128 bytes writes up to 160 bytes into ctx->key, clobbering the
adjacent hashalg, sdesc, ipad, and opad pointers in struct
otx_cpt_aead_ctx and struct otx2_cpt_aead_ctx before writing through
ctx->ipad.

Increase OTX_CPT_MAX_HASH_KEY_SIZE and OTX2_CPT_MAX_HASH_KEY_SIZE to
128 to accommodate a full SHA-384/512 block-sized HMAC key.

Fixes: 311eea7e37c4 ("crypto: octeontx - Fix authenc setkey")
Fixes: 7ccb750dcac8 ("crypto: octeontx2 - Fix authenc setkey")
Closes: https://sashiko.dev/#/bug/linux-bf3e3416-972b-4a32-bb3c-9fe7d3f28c9d
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h   | 2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
index a50b5e2f8d00..29976126d5cf 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
@@ -15,7 +15,7 @@
 #include "otx_cpt_common.h"
 
 #define OTX_CPT_MAX_ENC_KEY_SIZE    32
-#define OTX_CPT_MAX_HASH_KEY_SIZE   64
+#define OTX_CPT_MAX_HASH_KEY_SIZE   128
 #define OTX_CPT_MAX_KEY_SIZE (OTX_CPT_MAX_ENC_KEY_SIZE + \
 			      OTX_CPT_MAX_HASH_KEY_SIZE)
 enum otx_cpt_request_type {
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
index d29f84f01cee..cbc590e9e020 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
@@ -12,7 +12,7 @@
 #include "cn10k_cpt.h"
 
 #define OTX2_CPT_MAX_ENC_KEY_SIZE    32
-#define OTX2_CPT_MAX_HASH_KEY_SIZE   64
+#define OTX2_CPT_MAX_HASH_KEY_SIZE   128
 #define OTX2_CPT_MAX_KEY_SIZE (OTX2_CPT_MAX_ENC_KEY_SIZE + \
 			       OTX2_CPT_MAX_HASH_KEY_SIZE)
 enum otx2_cpt_request_type {
-- 
2.56.1.750.gf70dc682cf-goog

