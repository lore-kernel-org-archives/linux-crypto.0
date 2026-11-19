Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795118075;
	b=ub+cPrMQs4LXMZjSLH3XnjE8O8dGuM6JUg0A/KzZmiJEV44FnQqtkvqCRyp6akiz5fD/
	 rGQTkCnVN1q/gs5yzQyaRX4uSEkFn3h5ygBwNqqfBRKZ04ArZwTNMY27qotHakHvkyHxc
	 fqwwIXUjK6NOLzfebqO+vmtn9H24FLvB+MY+oppzMidFRR7Y90/SGTmEjUxPcV9Cv9HJm
	 XC1CwMU2p9fXuxVleKHgSpf1kLfqWYNO/r21EoatrjCecyS5KpzO6tenZH1IKBAM1ekQ8
	 KW4lx/eApcyKeHxS5P47B+lxu3rzMLfrCDt5yhXQSqHSxoE1XL9WyLUFpZ68Hwv5jAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118075;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Ru1e4Dsl9fl+y7pyjbXE8FmfV8fA53Dqg3REoaqq96c=;
	b=Of+PzFnZjHaP0CY+Ql3SQZ9l3R2Uz23nUmtIO/VvEhm1KcutgaRPbvxi2X1QePCSePGr
	 ArBU2kE5BnQLdU/cn0HT1dkNFLD1uFDxQQYdH9RbK06Nre1yLzatL7PIEMnU7c2CVuVE7
	 KW/63qE/Ye0Jzi5CUHQn2yTpgckb3CqcpOlwoqldAZvbwALPtynJjyygj6obniaME6icH
	 VUWRgQuWguZkvj+m6rrSV0D/soPyIi4+7XWMpeKEY652Zc2TkPovqBuKmBsd8fsgNRjYI
	 wja60+2GjwLi7OZb9w88naLSnxCnTk/KC/pKqXjc8PD9imxpphmW/gQ2v71EbCUT7Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=C2bFQ6Ti;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392F3606A320;
	Thu, 19 Nov 2026 19:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 392F3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=C2bFQ6Ti
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.corp.microsoft.com (unknown [52.179.129.152])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8445920B7166;
	Thu, 19 Nov 2026 11:54:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8445920B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795118073;
	bh=Ru1e4Dsl9fl+y7pyjbXE8FmfV8fA53Dqg3REoaqq96c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2bFQ6Tim8TiwuK+dwri9qk9tnRZFNLVTvyRPcP/ZglzAc2H+6gnYFtvhYokJgg0V
	 9ecOdngXXTDEWTRQUkVetktbRW1VW25g5UknhamBnnpZxbj3cBYigee3ucM4ISpIFt
	 GcuCSui0XEZq0NCJQvvd+QBBgfQ2HY3VMs9tEz+k=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: herbert@gondor.apana.org.au
Cc: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	gaurav.jain@nxp.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] crypto: caam - fix in-place RSA payload DMA mapping
Date: Thu, 19 Nov 2026 14:53:50 -0500
Message-ID: <20261119195350.812246-1-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avRJW9494fF7Pyf4@gondor.apana.org.au>
References: <20261020192511.3389133-2-jeffbarnes@linux.microsoft.com> <avRJW9494fF7Pyf4@gondor.apana.org.au>
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

Hi Herbert,

> Sashiko has some comments on this patch:

Thanks for pointing me to the review, and sorry for the delayed response.
The prepared v2 addresses two concerns, but the short-input SEC4/PDB
accounting concern remains. Here is the disposition of each finding:

1. PVF1: rejection of multi-segment in-place requests

   Agreed. The RFC's -EOPNOTSUPP containment is not suitable as the final
   fix. V2 removes it. An aligned exact alias retains one bidirectional
   mapping only when dma_map_sg() returns a single DMA segment.

   If it returns multiple segments, v2 releases that mapping using the
   original entry count, then maps the source DMA_TO_DEVICE and a separate
   destination bounce buffer DMA_FROM_DEVICE. This follows Sahil's
   recommendation and reuses Changwei's destination-bounce infrastructure.

   The padding/layout observations also included in PVF1 overlap PVF2
   below; I am not claiming those are fixed by destination bouncing.

2. PVF2: short-input padding and PDB source/table selection

   The source shows the accounting mismatch described in the review.
   The allocator reserves an extra SEC4 entry when diff_size is nonzero,
   but edesc->mapped_src_nents does not include that entry. The private
   PDB setters select a source S/G table only when that stored count is
   greater than one. Their destination-table offset also uses that count.

   I checked the unpatched baseline used by Sashiko,
   178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4. It already contains these
   allocation/count/selection rules, before applying this RFC. The issue
   is therefore not introduced by the shared-mapping change, but it
   remains present in the prepared v2 and needs separate treatment.

   In particular, fixing the private padded-input view and auditing the
   public input-length/table handling must not be conflated with simply
   changing payload DMA ownership. I have not hardware-reproduced or
   fixed this finding, and do not claim the public-operation tests below
   validate private signing or decryption.

3. PVF3: zero-length source passing the RFC's negative-only check

   Agreed. V2 patch 1 rejects src_nents <= 0 before payload mapping or
   SEC4 construction, returning -EINVAL for zero and propagating negative
   extent errors. It applies the same checks to the destination extent.
   A zero-length source therefore cannot reach the shared-mapping path
   merely because the destination extent is nonempty.

> Please also explain how your patch interacts with the other
> patches on caam:

The prepared v2 is based on both patches of Changwei's v6:

https://lore.kernel.org/linux-crypto/20261114060032.872141-1-changwei.zou@canonical.com/

His error-path fix provides the operation-appropriate unmap dispatch.
His alignment fix provides fixup_dst, destination allocation, and
copy-back/free handling. V2 reuses that infrastructure rather than
adding another destination-buffer implementation or modifying req->dst.
The payload is unmapped before destination copy-back.

The ordering is Changwei's two patches, then the separate SG-extent
validation patch, then the in-place DMA ownership patch. The latter also
records req->src == req->dst before leading-zero stripping and forces a
destination bounce if the effective source advances.

A backport of that combination was tested on an arm64 system with CAAM
behind an SMMUv2, a translated IOMMU domain, and DMA-API debugging
enabled, running kernel 6.6.160.4. All 12 RSA-2048 public-operation alias
tests passed, with no DMA-API, ARM-LPAE/IOMMU, or scatterlist-iterator
warnings observed.

Those tests used direct and backlog-enabled submission; they did not
establish that requests entered the backlog, test private operations, or
cover noncoherent/dma-direct hardware.

The test run also included the independent iterator-boundary correction
now submitted separately:

https://lore.kernel.org/linux-crypto/20261119192007.786827-1-jeffbarnes@linux.microsoft.com/

On the maintenance concern, Sahil has provided substantive review and
offered noncoherent/dma-direct testing. I have copied the CAAM maintainers,
but cannot speak for them regarding ongoing maintenance.

GitHub Copilot assisted with the implementation, regression tests,
source comparison, and drafting this response.

Thanks,
Jeff
