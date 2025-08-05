Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DDC2749DF;
	Tue,  5 Aug 2025 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399409; cv=none; b=rTKLtWX2of9IjN6j/+yEul4wCa2lTNX38XcOBOqIfs5zrxoECp5qcuqdyzz/VpkdZEOYxI3Fw1NaxCe9zG80VrB6T8PyyzBTi7FfRwu++mx8MSBdADhX2wkHmWgB+gLAZB27s3wyYzKypmzpSLhknMCYz5VrWPfVwvoA2zqhCJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399409; c=relaxed/simple;
	bh=bP8A5HC3XzwMZvbd9AW/OCXUgb7BGmbP61vbl4smCKI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DOP5LAa6pkSgbKa0uqLvGhvglrqQwUTvBi285tfXnPhy0N9WZbQWzVrIVqxnfURRVgfEt3e58+4rLGtY2Of0gQQ/uQf3Vtm0B9AKF9M5PGYKpOX0NUjGCxs5IKPRbYHH6bTt+auRwmZsxsHCuupkTT/197w17zjhKQRMq3CMXPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuU6Ttpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuU6Ttpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1893C4CEF4;
	Tue,  5 Aug 2025 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399409;
	bh=bP8A5HC3XzwMZvbd9AW/OCXUgb7BGmbP61vbl4smCKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuU6TtpuMqScl+idpC+L99AxRHnlt0cYVSdPw9CV8BMwyThdZ9URw6fZmSQYJLbqE
	 1EB0ogcYE46TToaapVhxCrM/9UkSTEF0TQWcBH6bi7ZX9kyeOM576GTsjWKkFR4UP+
	 1UgTAYU3kim9/GzeL7T/q50YMudEsn11waq17fQS18AO9iLY3P/KstzgSkc1aDbTjk
	 9IecUxH5tHgVHmIcbf3ZenrVPAaDj2KANAR/Fqk83T7fq9xr8rnOpLiT0Bsj+cdWQT
	 XJTJQSiUJ55b31UeZRS1DPPdehuTLiI7wVA6eGWdQiSPE/1KFda2ooMqVMFGTycv4s
	 8ROAABjTJjubw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhiqi Song <songzhiqi1@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	liulongfang@huawei.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.15] crypto: hisilicon/hpre - fix dma unmap sequence
Date: Tue,  5 Aug 2025 09:08:45 -0400
Message-Id: <20250805130945.471732-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Zhiqi Song <songzhiqi1@huawei.com>

[ Upstream commit 982fd1a74de63c388c060e4fa6f7fbd088d6d02e ]

Perform DMA unmapping operations before processing data.
Otherwise, there may be unsynchronized data accessed by
the CPU when the SWIOTLB is enabled.

Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Critical Bug Fix Nature

This commit fixes a critical **data coherency bug** that occurs when
SWIOTLB (Software I/O Translation Lookaside Buffer) is enabled. The bug
involves accessing DMA-mapped memory after processing data but before
unmapping it, which violates DMA API usage rules and can lead to:

1. **Data corruption** - CPU may access stale/unsynchronized data
2. **Security implications** - Potential exposure of sensitive
   cryptographic material
3. **System instability** - Especially on systems with IOMMU or SWIOTLB
   enabled

## Specific Code Analysis

### In `hpre_ecdh_cb()` (lines 1476-1502):

**Before the fix:**
```c
p = sg_virt(areq->dst);  // Line 1494 - Accessing DMA-mapped memory
memmove(p, p + ctx->key_sz - curve_sz, curve_sz);  // Line 1495 -
Processing data
memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);  // Line
1496

hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);  // Line 1498
- DMA unmap happens here
```

**After the fix:**
```c
/* Do unmap before data processing */
hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);  // DMA unmap
first

p = sg_virt(areq->dst);  // Now safe to access memory
memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
```

### In `hpre_curve25519_cb()` (lines 1795-1820):

Similar issue where `hpre_key_to_big_end(sg_virt(areq->dst),
CURVE25519_KEY_SIZE)` was called before DMA unmapping.

## Why This Qualifies for Stable

1. **Clear Bug Fix**: This fixes a definitive bug in DMA API usage that
   violates kernel DMA coherency rules
2. **Small and Contained**: The fix is minimal - just reordering
   function calls in two callback functions
3. **No New Features**: Pure bug fix with no feature additions
4. **Low Risk**: Simple reordering of operations with no algorithmic
   changes
5. **Affects Real Users**: Systems with SWIOTLB enabled (common in
   virtualized environments and systems with >4GB RAM on 32-bit
   architectures)
6. **Subsystem Impact**: Confined to HiSilicon HPRE crypto driver
   callbacks

## Technical Severity

The bug is particularly severe because:
- SWIOTLB bounce buffers may contain stale data when accessed before DMA
  unmapping
- This affects cryptographic operations (ECDH and Curve25519), where
  data integrity is critical
- The issue manifests silently as data corruption rather than crashes,
  making it hard to detect

The fix follows proper DMA API usage patterns by ensuring DMA unmapping
(which includes cache synchronization) occurs before CPU accesses the
memory, preventing any coherency issues.

 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 61b5e1c5d019..1550c3818383 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1491,11 +1491,13 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
 	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
 		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
 
+	/* Do unmap before data processing */
+	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+
 	p = sg_virt(areq->dst);
 	memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
 	memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
 
-	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
 	kpp_request_complete(areq, ret);
 
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
@@ -1808,9 +1810,11 @@ static void hpre_curve25519_cb(struct hpre_ctx *ctx, void *resp)
 	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
 		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
 
+	/* Do unmap before data processing */
+	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+
 	hpre_key_to_big_end(sg_virt(areq->dst), CURVE25519_KEY_SIZE);
 
-	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
 	kpp_request_complete(areq, ret);
 
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
-- 
2.39.5

