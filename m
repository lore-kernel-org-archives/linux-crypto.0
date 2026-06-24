Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40A2305E28;
	Wed, 24 Jun 2026 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782330787; cv=none; b=KQavhEkRqcxxdbuB0chTc53sC1zriCKYEPKyLZU7R9KHo78QlOzkE9R09GrIIyzdi3fOk8bpsF9rwc2naMQl0o7Dl3bFnJQMZn/Q5Kh2mJFc+CgClN0rFFn8vIvPry0M899A1HoaQYC06Ylx61KjRsJdH5eifsQjq9kUfrVHkDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782330787; c=relaxed/simple;
	bh=uGManwo2POKMO9mUH2vgxLmsUYYgJxBMxApUaz/JoN4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yqmf48A9bHjTTmb9Rv3w6YfOA6Y6eWBtsdrZW0RHbUEy32XQfL9JdbvvaiWKrcqdY6GE8QZt5sCimvHGYd+PBTVFw11u3Cuf1yE4/hvkiQclTONRa7/xzqpDXi8Sdi5Kv1KxqjtbxyVldzbLTuBqggqS/JOKgcA/jsqkMkydHnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=nOICm2iu; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="nOICm2iu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782330786; x=1813866786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9kzduUnU0W5KLUH8xRjByArbNZrNdOxKMBIECVRVqgo=;
  b=nOICm2iuvF/7hBvOGRmdUEltZ79ODKCbDCM/qGUw+xaZGctieYbzpW+P
   t//aMECdcpQ7YwpTTGXZJooLjhmvPnbmZY+6sXkDQ8WT0JV4318moojUY
   Sh1ghJEaYS2z0raGJtgrnb6Br9JQejUAomOPJVrCEwd1O/y28gNkAgtNC
   NedB4OQkrOMzLoifsNYCS8SYPAo+57Fz07SWWeZeQrbAX5IPpjI0dZ7Lm
   rRRABkqKMK6cf8ndPdR3ovV4h8KmILmlNdc+6IQCPozw5XnVTfR7K2d7C
   gZfsx9z6N5L5YX3wucb4y6XL4Fv9hk6Y3MIg8V4c/SSV3LAeXBDIqr5ZZ
   g==;
X-CSE-ConnectionGUID: T4dFEcxWRLmb1DhwaTaxaQ==
X-CSE-MsgGUID: CrIjSsjgRWCy8HXfNV8Ngg==
X-IronPort-AV: E=Sophos;i="6.24,223,1774310400"; 
   d="scan'208";a="22234931"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 19:53:03 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:4369]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.61:2525] with esmtp (Farcaster)
 id 485ff261-6d1f-4c4d-9fd6-0a3f6bebcd59; Wed, 24 Jun 2026 19:53:03 +0000 (UTC)
X-Farcaster-Flow-ID: 485ff261-6d1f-4c4d-9fd6-0a3f6bebcd59
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 24 Jun 2026 19:53:02 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 24 Jun 2026 19:53:01 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Eric Biggers <ebiggers@kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Jens
 Axboe" <axboe@kernel.dk>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] crypto: skcipher - per-request multi-data-unit batching
Date: Wed, 24 Jun 2026 19:52:55 +0000
Message-ID: <20260624195255.1102-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622182328.GB1250822@google.com>
References: <20260622182328.GB1250822@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWA001.ant.amazon.com (10.13.139.124) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jun 22, 2026 at 06:23:28PM +0000, Eric Biggers wrote:
> I don't think there's a path forward without an in-tree user that's
> shown to be worthwhile over just using the acceleration built directly
> into the CPU.  As well as confirmation of no regression to existing
> users, including in cases where the inline sg list can't be used.

Agreed. Proposing a smaller v5 that meets the no-regression bar now and
leaves "beats the CPU" to a follow-up with a real in-tree user.

dm-crypt submits one request per contiguous bio segment (a single
bio_vec) with data_unit_size = sector_size, instead of one per sector.
E.g. default sector_size 512 with a 4 KiB bio_vec: one request of 8
data units, which the fallback splitter walks as 8 per-sector calls --
dm-crypt no longer open-codes the per-data-unit loop itself.

  - Uses only the existing inline sg_in[0]/sg_out[0] entry. No per-bio
    scatterlist, no kmalloc -- the "inline sg list can't be used" case
    doesn't exist here, so there's nothing to regress.
  - For a non-native algorithm the core auto-splits into the same
    per-sector calls dm-crypt makes today: identical output and cost.
    This is what Herbert predicted -- the per-unit indirect call just
    moves from the caller into the API; the fallback is no slower.

So it stands on no-regression alone, with no software throughput claim.
What it adds is the interface a native one-pass driver needs. I'd land
that now and bring a native offload user + numbers as the follow-up,
rather than block the interface on the driver.

Acceptable? If so I'll respin v5 as the minimal version.

Thanks,
Leonid
