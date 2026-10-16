Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AF942AD9F;
	Fri, 16 Oct 2026 22:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792188867; cv=none; b=otewwmj3C92bgR6rJFJJjGVRoXVAfBHLw3qKJwdIi2ZW/+BrRNB03ntOLzVUlV5zapyIrv2rusq3MjwENAW38tkxnc1cyEKucfCWQFb2ScnrExki/q6ns8eEWJcQ3hJdyflSQRTv8AmQFA34agc5/EONzPvPlk+JPNEp5Dfl99Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792188867; c=relaxed/simple;
	bh=Ct0rfElsXuXbVu5RGEkOwbi0cqFOfgPzwLRlM6cKa1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXDSlX/9QpdtT5/NkmPGUIE4xc/mV2EmMdr8WSwya4VqcB3TJ3dx/wHcE5ta+gsuQEaBoq31I6AEQ57ceduYHVfRBhnNFg157XnvRc8aMTs+zisio2I3vp/Rf3tmopqSR/fktuYSNd+QsbE0rLZZkKFdnjzZQne2SMa7dUsdBik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=r6K4A0Hl; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="r6K4A0Hl"
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.lan (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id 83BCA20B7168;
	Fri, 16 Oct 2026 15:14:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 83BCA20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792188860;
	bh=CvrkmxGTYn+g48GnaUrhS3mqY4MzePPX6sNKOzeS5H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6K4A0Hl1qMulqDce5bA2d33KMcsCQARgHppwxcojSSG8Y6cWDOGRoxLLX+i9eaIb
	 MA2+I8VbKbkpMmsjnpwNCHnnIAUK5AvnOvK/kV1F38aD9jDONpNifUyB1MPzu33XKO
	 hOdP5gVGI1mhrhH0DtyPtby76qZOPaIu6aYM2+jI=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: stephane.debusne@cynove.com
Cc: herbert@gondor.apana.org.au,
	lukas@wunner.de,
	changwei.zou@canonical.com,
	ignat@cloudflare.com,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: fix RSA results corrupted by non-coherent DMA
Date: Fri, 16 Oct 2026 18:14:14 -0400
Message-ID: <20261016221414.4139377-1-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016090333.2247764-1-stephane.debusne@cynove.com>
References: <20261016090333.2247764-1-stephane.debusne@cynove.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Stephane,

Thanks for posting this. While investigating CAAM RSA on another arm64
non-coherent system, I found a separate DMA issue affecting the same
in-place request shape.

Your patches move the synchronous-helper and RSASSA-PKCS1 buffers into
separate allocations, while intentionally retaining src == dst. That
addresses cache-line sharing between the payload and mutable request
context. The issue I observed is in rsa-caam's ownership of that
exact-alias SG.

On an NXP LX2160A with CAAM Era 10 behind an ARM SMMUv2 translated DMA
domain, rsa-caam mapped the same effective SG twice:

- first with DMA_TO_DEVICE, producing mapping A;
- then with DMA_FROM_DEVICE, producing a different mapping B.

Because dma_map_sg() writes DMA metadata into the SG, the second map
replaced the metadata describing A. Completion subsequently unmapped B
as the destination and then consumed the same overwritten metadata when
unmapping the source. The second teardown attempted to remove B again,
while the SG no longer retained the metadata needed to release A.

The public completion warning included:

    __arm_lpae_unmap
    arm_lpae_unmap_pages
    arm_smmu_unmap_pages
    __iommu_unmap
    iommu_unmap_fast
    __iommu_dma_unmap
    iommu_dma_unmap_sg
    dma_unmap_sg_attrs
    rsa_io_unmap
    rsa_pub_done
    caam_jr_dequeue

A corresponding private RSA case reached rsa_io_unmap() through
rsa_priv_f_done(). Certificate verification reproduced the public path
with a 512-byte operand.

I tested a narrow downstream prototype that, after source normalization,
maps an exact effective-head alias once with DMA_BIDIRECTIONAL over the
larger of the source and destination extents. The observed public 256/256
and certificate-verification 512/512 requests each had one original SG
entry and returned one DMA segment. They then used one BIDIRECTIONAL map
and one matching unmap with the original entry count.

With that prototype, the system booted successfully and the tested logs
contained no matches for __arm_lpae_unmap, __arm_lpae_map,
__iommu_dma_unmap, RSA algorithm failures, invalid output, RSA self-test
failures, or rsa-caam failures. These are downstream results for the
observed one-entry mappings, not validation of arbitrary multi-entry
exact aliases or a current upstream patch.

Changwei's pending unaligned-destination bounce-buffer patch appears
complementary:

https://lore.kernel.org/linux-crypto/20261004210200.290119-3-changwei.zou@canonical.com/

For an unaligned destination, bounce substitution would make the
effective source and destination distinct, allowing separate TO/FROM
ownership. For an aligned exact alias, the original SG would remain
shared and would still need one BIDIRECTIONAL mapping. If combined,
destination substitution appears to need to happen before effective-head
alias classification.

The unresolved case is a shared mapping that returns more than one DMA
segment. Using the union mapping's returned count for both logical
hardware views can change existing SEC4 source-table selection,
particularly for a shorter source. I do not yet have hardware evidence
for that case.

Would the preferred direction be:

1. an initial narrowly bounded CAAM RFC demonstrating the one-owner
   BIDIRECTIONAL correction and explicitly rejecting unresolved
   multi-segment aliases;
2. coordination with the pending destination-bounce work for problematic
   aliases; or
3. constructing separately bounded source and destination SEC4 views
   over one shared mapping?

I wanted to raise this here before posting a separate RFC because your
series confirms that exact-alias requests remain intentional, and the two
DMA issues are independent but affect the same callers.

Thanks,
Jeff
