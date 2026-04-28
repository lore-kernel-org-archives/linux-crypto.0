Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E53E4C99;
	Tue, 28 Apr 2026 10:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777371165; cv=none; b=B78CZ9YD21LxrLt1VsU9LEJyvm6U2UEdb+RAYoXTqtK8ibLIdlmjVzk0vg/bAyY/krEBjklGhl2oKZ59WeommXXr1Y39uNVZjdD8prvipxid6vK15eVKLVA6QD9AW7mHwQ9uBvBP3kKrGDmEudbndqd8/JhoTs3U/hfyOvPuFe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777371165; c=relaxed/simple;
	bh=x8MHJR14NUMf+Dk7BTmTdPYF2T9jgA2ZrdmxNB3DhBs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=McWsk1MydTgn8MiUu39dypYvnqvHDRi9srl8JX/L6itnRD/r0A9TIFrgV7B1O14yFWMNRmxsoobnjeR7g2ueFiKSKHl4tC37bse3aVkpXJWxmb1IwF2mTgUmxo60Bs1ifxGQRr4i00n0M7sGUW6vjsZGqOKFlCWf9Dh8KZflE1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Opvm2aJk; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Opvm2aJk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1777371163; x=1808907163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XCQ9jRP1C08+hVdQUx1MjkUXFwnpA7R3hPnssiEViMo=;
  b=Opvm2aJkRcdXwU+aAZ7Ha8F3JwbCcl910gZMS/heDihz+0B7LIjb9YJA
   O8VcD1/F+vV9nWZPSm+aDL1l9F2i1/VmlvHbdiwv+WIwZs669bhuv1bCt
   GIkcAdIZshwS4QoH6E/0E08VkKjD7ncrEJV/zRJMKXQEEk5D+T5CAWq21
   zL+2NnukZcAEoHA+vSoQLJXEpJ/eiqOo0qlP6iFhyNfyoDcSzGM/gocJx
   DWqPRKwt/x6AkUk2o3K6yO/ZPZcXPeWHBuYe4tjZoT4FoMz8tKRBUrmZb
   6LINJrVUFz9jMniV6yW/UeNiR+prGGskQ7e505NCxwB5YhgpVC/6gf/Op
   A==;
X-CSE-ConnectionGUID: uMbKKZm5T32und9FXDDHmQ==
X-CSE-MsgGUID: 203AID9vSdCGsrLKN5QOJw==
X-IronPort-AV: E=Sophos;i="6.23,203,1770595200"; 
   d="scan'208";a="18359833"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2026 10:12:39 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:13431]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.51:2525] with esmtp (Farcaster)
 id 336985de-8f78-4393-9f8b-4ae7c9de3770; Tue, 28 Apr 2026 10:12:39 +0000 (UTC)
X-Farcaster-Flow-ID: 336985de-8f78-4393-9f8b-4ae7c9de3770
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 28 Apr 2026 10:12:38 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 28 Apr 2026 10:12:36 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon
	<agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: Re: [RFC] crypto: skcipher multi-data-unit requests for dm-crypt
Date: Tue, 28 Apr 2026 10:12:25 +0000
Message-ID: <20260428101225.24316-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ae9IUN0lOMkijDyw@gondor.apana.org.au>
References: <ae9IUN0lOMkijDyw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D037UWB002.ant.amazon.com (10.13.138.121) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Apr 27, 2026, Herbert Xu wrote:
> Yes I'm happy with this since it could also work for IPsec.
>
> But before you invest too much energy in it it would be helpful
> if you can get some proof-of-concept performance numbers so that
> your effort is not wasted down the track.

I ran a proof-of-concept benchmark on an XTS-AES-256 dm-crypt
volume backed by a hardware crypto accelerator, comparing
per-sector submission against multi-data-unit submission.

Setup: single-core ARM64, fio 4K sequential writes, buffered IO
with end_fsync (representative of filesystem-over-dm-crypt
workloads). Two rounds per configuration, results were consistent
(< 2% variance between rounds).

Throughput (averaged):

  per-sector:       286 MB/s, 73K IOPS
  multi-data-unit:  340 MB/s, 87K IOPS  (+19%)

CPU cycles (perf, 30s sample):

  per-sector:       59.8 billion cycles
  multi-data-unit:  36.0 billion cycles  (-40%)

The baseline is partially CPU-bound. The perf profile shows
dm-crypt and crypto API per-request overhead consuming roughly
25% of CPU cycles in the per-sector case:

  4.3%  crypto dispatch
  4.1%  async completion callback
  3.5%  completion collection
  3.3%  kfree
  2.9%  per-bio context lookup
  2.8%  crypt_convert loop
  1.6%  slab allocation
  1.3%  mempool free

With multi-data-unit, these functions drop out of the top
profile. The bottleneck shifts to DMA mapping and page cache
operations. CPU0 kernel time drops from 78% to 40%, with the
freed cycles appearing as iowait.

The 19% throughput gain (vs 40% CPU reduction) reflects that
the system was partially IO-bound even in the baseline. The
optimization removes the CPU bottleneck, allowing the system
to fully saturate the IO path.

I will prepare the patch series against mainline.

Thanks,
Leonid Ravich
