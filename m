Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795118400;
	b=K+nP1OsBSLVI2f7RfN2K15Rk3UZVkbb1tg3P3f7UKrdVWunnw3cB2LKooTJK8+eoeb8H
	 FPnqKlYYw4Z65l+pRArpjMWlQF/1HTz+a1ASQLWcMH/M9y+83z8/WrSUADeI7spdXn+6P
	 N4ggeoBfyKh7Gfg8h9s2F/9wfLgWOpnc7pjhLi87TCF+B59KYwfA/+hwJ0T/8mOwKCBFF
	 Z85NVS9KKq8lLTbBt+bSUYqmtg8Mp97rTwPJyLuz3JwBypvvyUJ5BHs6aqx2lpYFgLZbx
	 T54vytFRdNSkJkgSpezCWzlxd/HDRlb/iirJV35CWcix1nXU35oDqjHi6RDdKPR+vwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118400;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=PEjNlh3YBVnW5VZbE2ITqmaSEF4yPZYBZERekvnfZsY=;
	b=x2Gd4cnKCYJsH4RcfX1AKLNQZ0FTuYHn7VePTXbdOs2aJa3zeulx4Vwckhnlm7bAN32p
	 pCYfaEXsXUE++jo063LmTLeHe+vd2b4CNS5y0oRRYzJa6kUIv5TbTHIPdow9tRWHYN7k7
	 6lR+t0oHk0yTWpSpSTSGtOADf02Ip6tm0wZxMErUV9YqmTvQMbg4OFzdXcd/7mPA7MjEX
	 Yjim8rt5dPuQFzvDw5pvOF1Ztv97r+o2i+AUThJtTjEhGBgrUu4BAiBuMN6ZBaW5M0TKB
	 yASc4mc3IKsXz3MmCCu8+Cs0EXUxJMF1T3MhkFHOCqrPE7k/F23YFk+CIHBJ5ovtVVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=BImxGXu3;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E25606A32C;
	Thu, 19 Nov 2026 19:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42E25606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=BImxGXu3
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.corp.microsoft.com (unknown [52.177.6.190])
	by linux.microsoft.com (Postfix) with ESMTPSA id AB63920B7166;
	Thu, 19 Nov 2026 11:59:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AB63920B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795118396;
	bh=PEjNlh3YBVnW5VZbE2ITqmaSEF4yPZYBZERekvnfZsY=;
	h=From:To:Cc:Subject:Date:From;
	b=BImxGXu3H2muuSjL8IMS+5ySW63nJMiCIFkiyYKlNlzJpTTk4DMOERMSImsAbfAfd
	 RIt/pw51HsW0b4kOWBaQf5FrMfygG8kxnOvDa/HHfeEA6EAixxovtKaMKqwzElc86P
	 OIGAvqpWKI5rg1+aGhu+mpYnVg0fUsSG6dLkMQ78=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	meenakshi.aggarwal@nxp.com,
	tudor-dan.ambarus@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] crypto: caam - fix in-place RSA DMA mapping
Date: Thu, 19 Nov 2026 14:59:46 -0500
Message-ID: <20261119195948.816661-1-jeffbarnes@linux.microsoft.com>
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

This series fixes DMA ownership for in-place RSA requests in rsa-caam.
Mapping the same scatterlist independently for source and destination
can overwrite DMA metadata and cause ARM-LPAE/IOMMU unmap warnings.

The series is based on Changwei Zou's v6 error-path and destination
bounce-buffer fixes:

https://lore.kernel.org/linux-crypto/20261114060032.872141-1-changwei.zou@canonical.com/

Patch 1 validates source and destination scatterlist extents before
walking or mapping them. It is separate so it can be backported
independently.

Patch 2 maps an aligned, exact source/destination alias once with
DMA_BIDIRECTIONAL when the mapping produces a single DMA segment.
Multi-segment aliases use Changwei's destination bounce-buffer
infrastructure instead of being rejected.

The original alias relationship is recorded before stripping leading
zeros. Requests whose effective source advances also use destination
bouncing, avoiding overlapping streaming mappings through different
scatterlist metadata.

Changes since the RFC:
- Split scatterlist extent validation into a separate patch.
- Build on Changwei's fixup_dst and bounce-buffer infrastructure.
- Replace multi-segment -EOPNOTSUPP rejection with destination bouncing.
- Handle aliases whose effective source advances during zero stripping.
- Add Fixes and stable CC tags.

Previous RFC:

https://lore.kernel.org/linux-crypto/20261020192511.3389133-1-jeffbarnes@linux.microsoft.com/

Testing:

A backport of the prerequisites and this series was tested on an
arm64 system with CAAM behind an SMMUv2, a translated IOMMU domain,
and DMA-API debugging enabled, running kernel 6.6.160.4.

All 12 RSA-2048 public-operation alias tests passed. These covered
single-entry shared mapping, two- and three-entry bounce fallback,
leading-zero stripping within and across entries, and unaligned
buffers, each with direct and backlog-enabled submission.

No DMA-API, ARM-LPAE/IOMMU, or scatterlist-iterator warnings were
observed. The test run also included an independent leading-zero
iterator boundary fix, which is not included in this series.

Backlog-enabled submission does not establish that requests actually
entered the backlog. Private RSA operations and noncoherent/dma-direct
hardware were not covered by this test run.

GitHub Copilot assisted with implementing the agreed DMA/bounce-buffer
design, developing regression tests, and drafting commit messages.

Link: https://lore.kernel.org/linux-crypto/20261119192007.786827-1-jeffbarnes@linux.microsoft.com/

Review follow-up:
The multi-segment rejection and zero-length-input concerns raised by
Sashiko are addressed by this series. The short-input SEC4/PDB padding
accounting issue exists in the unpatched baseline and remains unfixed
by this series. The detailed response to Herbert is here:

https://lore.kernel.org/linux-crypto/20261119195350.812246-1-jeffbarnes@linux.microsoft.com/

Jeff Barnes (2):
  crypto: caam - validate RSA scatterlist extents before mapping
  crypto: caam - fix in-place RSA payload DMA mapping

 drivers/crypto/caam/caampkc.c | 89 ++++++++++++++++++++++++++---------
 drivers/crypto/caam/caampkc.h |  3 ++
 2 files changed, 70 insertions(+), 22 deletions(-)


base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
prerequisite-patch-id: de99c6374460d838f0474066325d03bea7a4f979
prerequisite-patch-id: 33fe41f9cfd4a8ee1afa1fc6e915a9747acd2f37
-- 
2.43.0

