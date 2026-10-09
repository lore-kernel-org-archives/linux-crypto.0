Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD85D4A43FF;
	Fri,  9 Oct 2026 10:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540899; cv=none; b=TPVD56arLeEUiGlmwFbekbolb0CLamHHMHNi19TfsypUp5JlavNUmmstFoIPL2Hl6sOp5RfRcIboh1YdlHWPnwKDAZtxuFa9oOLvJuQE3JjLjnc8wD+sSxbMfjTziMVL2g+kGunnNGijgmS74Kk/LVV4VfDc3Ad/X7zaQhIwjIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540899; c=relaxed/simple;
	bh=txo0MhhqlXZryMALzi+8buimHfdZDgxBoGGNVKlljhg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LscoJvHqlsMgDH4P2iu5koCDV453xMkNcpROVcf4np5YbhdGFgFisHVQr+P4gEq726csp0T3eKfRI62IBpvKlrrl7hqQnHO0pWhMPVqWO/yrsvg5510oh32TXduUBv+xLLc5SjW2CX2s3aEwvAkfgZ3Zyv6ETaWvJNbGkUSSfg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9KVCjOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9KVCjOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D111F00893;
	Fri,  9 Oct 2026 10:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791540898;
	bh=wwydGlUgCBhHrV4cZrAB5kkF1ZlL1ivU9o7LLHNWa8k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=W9KVCjOwRqU2gV2AihKD3AdOxcHe31iNmDGQl0R4Tkddm8io7WKzlw0h6kz9fhfDq
	 BjcXhLzD0STibuPn4w4+Tmz/+RA1AvvNe7qJcdjfJNHjqkx+4TpiA//JH9qigobb/e
	 KMUp2eCzn0lN4KeCuPXRXh09QUDm579GWPB1SAB8N8wQGWcCO3MtF0tZFE0MJ6I4SE
	 ZHhHdaCklXnaF3EPgcTViWawCUdYtSm8DKnpJ2/Wn/33A08IRIVN4PORLw5NzGDxuS
	 +EI7WG+DQDNnNM6RHDwqQM36MbaDGVPYjoVkemouFajoX+MCdJIGQzHgJXpf/y4miF
	 EAChBiZlqWI0g==
From: Vinod Koul <vkoul@kernel.org>
To: Frank Li <Frank.Li@kernel.org>, Dan Williams <djbw@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jon Mason <jdmason@kudzu.us>, 
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>, 
 Frank.Li@oss.nxp.com
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, ntb@lists.linux.dev
In-Reply-To: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
References: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
Subject: Re: [PATCH v2 00/12] dmaengine: Add dmaengine API to avoid call
 DMA Engine callback directly
Message-Id: <179154089532.553139.9001225981900528263.b4-ty@kernel.org>
Date: Fri, 09 Oct 2026 12:14:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 23 Sep 2026 12:19:29 -0400, Frank.Li@oss.nxp.com wrote:
> Add dmaengine APIs to avoid call DMA Engine callback directly. Prepare to
> make dmaengine provider private.
> 
> Fix all under crypto/async_tx
> 
> Build pass under crypto/async_tx after change dma_device *device to _device.
> to make sure all code use dmaengine APIs.
> 
> [...]

Applied, thanks!

[01/12] async_tx: replace direct ->device_prep*() calls with standard DMA engine API
        (no commit info)
[02/12] async_tx: use dmaengine_get_dma_device() instead of chan->device->dev
        (no commit info)
[03/12] dmaengine: add dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() API
        commit: 4bdb88eb5496cb09902b9778ca7f4628c43b0d77
[04/12] dmaengine: add dmaengine_is_*_aligned() helpers for DMA consumers
        commit: 11e801ccaca78c9d92b1f3a9733772bf9d2c079c
[05/12] dmaengine: add dmaengine_get_copy_align() and related alignment getter helpers
        commit: 072975a8a578a62ea68ec1ceb8d2d7dcfb5dfefa
[06/12] dmaengine: add dmaengine_get_cap_mask() and dmaengine_has_cap() helpers
        commit: bbc109e0e686266d784483df108af206bc52e120
[07/12] dmaengine: add dmaengine_get_max_xor() helper
        commit: bff69558d64a98bc8d03f373d1331223c3428a2c
[08/12] dmaengine: change dmaengine_get_unmap_data() first arg to dma_chan
        (no commit info)
[09/12] dmaengine: replace dma_maxqp() with dmaengine_maxpq() taking struct dma_chan *
        (no commit info)
[10/12] async_tx: use dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
        (no commit info)
[11/12] async_tx: convert to dmaengine_is_*_aligned() helpers
        (no commit info)
[12/12] async_tx: replace open-coded cap_mask accesses with dmaengine_has_cap()
        (no commit info)

Best regards,
-- 
~Vinod


