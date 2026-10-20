Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792524329;
	b=rbHMXOt7WEzVEcUq0prq1icwCS+GzWPWImyl/xuqyquU5drcK3CQeW2Fb8Lf07OKa6ln
	 WQplbunvCMCeIK0sL1mLjQQaNCC3ymWsfNOafOFaSBAPit613VtOsat96hSF8oq6n87Qs
	 +TTERRvGuL4G1ZNbhAf5NZBJnluvJ00e+dPrsYyWc+6IG9qLTe2KkNKg+bvIlhNCl1v3K
	 rLDSe7Sl7ReOR/jYQtYByuJIWq5aP/fJ4KdR4DnQloShzrgNG1I59tOs0fadlu7Z9ndKP
	 ckJiSdy2iLvUIxC16MiWnnrl55bhsXixPiIk1p5ZsmrtEmtAqh0sjFxrlqiCQB3c3eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792524329;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=wMnlkFybsSYZisbKMqEXfYf08l8WhyMyTNYDad69ys0=;
	b=Ln5OXchTesEgzOWS6x2oTF5BhJF1atSWGoLADSUufn5sgSVSkEitaWiapRGCgdak8H7B
	 EqCoFcyOWIFykNYpKOoVK9PQeCugpODUNZ9LKHmUqQCba8udbvQ4LBHX41KckFsKSU9V5
	 w2I0d/VEsCvTv71PpMb4YcowZKagUwNpoJQweT8C4BVbm+vJTIjOAMBH23fWuTSsWac2v
	 KWNXjJkSHx0gMxLQqege2C4iDDGpVfhe41c4XhaoyIhOEPfcO2D3ibXbTbbsT2UN593kd
	 ncFvhY/c4WcJciBUEqXDN5lYF6SyBwgQBw9YKSFr6QqGm6diEfvSZWOygDAlyYreiOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=BMUwYfdm;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5CA606A31E;
	Tue, 20 Oct 2026 19:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F5CA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=BMUwYfdm
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.lan (unknown [52.177.6.131])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5939A20B7166;
	Tue, 20 Oct 2026 12:25:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5939A20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792524316;
	bh=wMnlkFybsSYZisbKMqEXfYf08l8WhyMyTNYDad69ys0=;
	h=From:To:Cc:Subject:Date:From;
	b=BMUwYfdmgyINJJ/c3dP+e93eQ/hERMIM9q4hmv2CBTuDueagRgi5omkTHkAFBKozZ
	 pHKyWAWXAkTWXRJPCh1QmMfj51NbOs92jMreGOvw3Y7ZXRZLh8tkOrCZF22/aoabGL
	 4fqpy+Nx4GubSfRydDCGovW91ISZrAd7bmhzNrSQ=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/1] crypto: caam - fix in-place RSA payload DMA mapping
Date: Tue, 20 Oct 2026 15:25:10 -0400
Message-ID: <20261020192511.3389133-1-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This RFC fixes a DMA ownership problem in the CAAM RSA driver when the
effective source and destination are the same scatterlist.

rsa_edesc_alloc() currently maps the effective source with DMA_TO_DEVICE
and the destination with DMA_FROM_DEVICE. For an in-place request, this
maps the same scatterlist twice concurrently with different DMA directions.

dma_map_sg() is allowed to modify the scatterlist DMA metadata. On the
arm64/IOMMU system where I reproduced this, the two mappings returned
different DMA addresses. The second mapping replaced the metadata needed
to tear down the first one.

Completion subsequently unmapped the destination and then attempted to
unmap the source using the overwritten scatterlist metadata. This resulted
in ARM-LPAE/IOMMU unmap warnings from the CAAM RSA completion paths.

The user-visible crypto self-test failure included:

  alg: sig: sign test failed: invalid output
  alg: sig: test 1 failed for pkcs1(rsa-caam,sha256): err -22

The warnings were observed through the CAAM RSA public and private
completion paths, rsa_pub_done() and rsa_priv_f_done().

The patch gives an exact effective-head alias a single DMA owner.
CAAM reads and writes the shared payload, so the scatterlist is mapped
once with DMA_BIDIRECTIONAL and unmapped once with the original SG count.
Requests with distinct effective source and destination heads retain the
existing DMA_TO_DEVICE / DMA_FROM_DEVICE mappings.

There is one intentional limitation in this RFC.

For the existing direct hardware representation, a shared mapping
returning one DMA segment is straightforward. A shared mapping returning
multiple DMA segments is not. The logical source and destination may
cover different extents of the shared scatterlist, while the existing
SEC4/PDB bookkeeping uses the mapped source/destination counts to select
and locate those hardware views.

Source analysis found request shapes for which assigning the shared
returned count to both views causes the destination SEC4 table position
to differ from the offset reconstructed by PDB setup. Short-source
public RSA also raises a separate source-view selection issue.

Rather than send a representation known to be incorrect to CAAM, this
RFC unmaps a shared mapping that returns more than one DMA segment and
returns -EOPNOTSUPP before SEC4/PDB construction or job submission.

I would particularly appreciate feedback on two questions:

1. Is a single DMA_BIDIRECTIONAL mapping the preferred ownership model
   for an exact effective source/destination alias?

2. For a shared mapping returning multiple DMA segments, should CAAM
   grow separately bounded source and destination SEC4 views, or should
   such requests instead use a distinct destination, for example through
   a bounce-buffer path?

I tested the patch on an LX2160A arm64 system with CAAM Era 10 behind an
ARM SMMU.

The rsa-caam and pkcs1(rsa-caam,sha256) self-tests passed, and the
certificate-verification RSA selftest completed successfully, with no
recurrence of the original ARM-LPAE/IOMMU unmap warnings.

I also exercised the RFC containment path with a targeted full-width
2048-bit RSA request. The same two-entry scatterlist was supplied as
source and destination, using two separately allocated 128-byte entries.
This reached the multi-segment shared-mapping containment path.

The operation returned -EOPNOTSUPP synchronously, no completion callback
ran, and no CAAM descriptor/job-ring, DMA/IOMMU, WARN, Oops, panic, or
invalid-output error occurred during the test interval. The test module
unloaded cleanly.

There are related RSA DMA fixes under discussion. CAAM work for unaligned
RSA destinations uses a bounce-buffer approach, which may provide one
possible direction for the general multi-segment alias case. Separately,
work on RSA buffers on non-coherent DMA systems identified a cacheline
sharing problem and also demonstrates legitimate in-place RSA requests.

Neither is required by this RFC. This patch is based on current Linus
master and addresses the independent problem of acquiring two streaming
DMA mappings over the same live scatterlist.

Thanks,
Jeff

Jeff Barnes (1):
  crypto: caam - fix in-place RSA payload DMA mapping

 drivers/crypto/caam/caampkc.c | 79 ++++++++++++++++++++++++++++++------
 drivers/crypto/caam/caampkc.h |  3 ++
 2 files changed, 69 insertions(+), 13 deletions(-)

-- 
2.43.0
