Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F84B477E42;
	Thu,  2 Jul 2026 08:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782981951; cv=none; b=NrbcXedeqeQpvoCR4+HKeoJgzXJ8t/p7h0REKTvF1XGNh6SQ8GBuMxPvqXmperEHOJGQAcgmBJyg27+jW4H6qcTt6pP5gUtJ8mPR+dpNQwXYATe5GTJSz2S4ZM80KfGnQE/XsH4wK/iBTVdv+UU870VA68S/gIS77vPbAoHQR9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782981951; c=relaxed/simple;
	bh=XaGq2N4hzaoOvlmXPKXPnNiTArw77/3qb7KXDPOvlBg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6zqo1gJU4yqepzCUvnfLvKYLuBB09/Mmav+uf8CMlSt6bpZaOXuq6APw2oRf8RIz9C78R816wL6ocGWsLzI259loGHGl8HTB4SeUfFuthDlyWCxO0zos3MYl6u5/gyBiVQaCshAmaPDW3SADcJrpd4PXWNJz8Y7Pd+cfuX6XRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=VU9kcwBi; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="VU9kcwBi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782981950; x=1814517950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=15z0y8ySKUMx+uWQiHzk+lZ8m7PQlTRsdM1TkQfCHy4=;
  b=VU9kcwBi1tcRI9lRfA9WbNaDd3i4W7K5P7qk85H4ftjCNvWVa/exvNV7
   GNdSRRMlXZMlw4LehBHvQE+lwN9mBcmRiVeruqxdo1PtSNl8c0JkPuJyF
   dKseMgzSsBMws6qOCqriwVuFgbQOD2ZZU90JstdgdbW1kTBP7TtTp+4ou
   +OSi9f1oeOHXod54Wc5+dW1qI/jskDQL7HLUi9fq2ZbF6KrfRt7BloYUp
   N8gAuNyFQDYf78r+nE8IlzCHXCk9hVG1i1wz1b0VpO4Qzs5Niusql31Tn
   ysGIzYt+AlkKejPCRO0UqXWjHBZI5XsnDTtq9bxp40MhFurkCUc9b/d73
   w==;
X-CSE-ConnectionGUID: F6rlKnB4QtuwS33tLCr6XA==
X-CSE-MsgGUID: YZcntuZGTW+LPVfAeb3RaQ==
X-IronPort-AV: E=Sophos;i="6.25,143,1779148800"; 
   d="scan'208";a="22896411"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 08:45:46 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:29711]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.225:2525] with esmtp (Farcaster)
 id e874728e-4e92-47f4-8242-dec1fa8f4564; Thu, 2 Jul 2026 08:45:46 +0000 (UTC)
X-Farcaster-Flow-ID: e874728e-4e92-47f4-8242-dec1fa8f4564
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 08:45:46 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 08:45:44 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: Eric Biggers <ebiggers@kernel.org>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<axboe@kernel.dk>
Subject: Re: [PATCH v5 0/5] crypto: skcipher - multi-data-unit dispatch as a template
Date: Thu, 2 Jul 2026 08:45:34 +0000
Message-ID: <20260702084534.22846-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701071919.GA111652@sol>
References: <20260630083431.2772-1-lravich@amazon.com>
 <20260701071919.GA111652@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWC002.ant.amazon.com (10.13.139.222) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Wed, Jul 01, 2026 at 12:19:19AM -0700, Eric Biggers wrote:=0D
> No, this didn't address my feedback.  It moved things around but still=0D
> adds additional overhead for everyone to support an out-of-tree driver,=0D
> which also hasn't been shown to be any better than just using the CPU.=0D
=0D
Eric, thanks for the fast reply.=0D
=0D
Overhead: for a non-user the only cost is the data_unit_size field plus=0D
one zeroing store in set_tfm()/ON_STACK; the en/decrypt paths are=0D
untouched.  A dun() user pays one indirect dispatch into the template per=0D
request plus a scatterwalk step and IV copy per unit -- the same per-DU=0D
bookkeeping the consumer already open-codes today.=0D
=0D
On the driver: I agree pushing code optimized for an out-of-tree driver=0D
is wrong, but I don't think that's the case here -- this helps any async=0D
crypto engine, and there are in-tree async xts(aes) ones dm-crypt is=0D
eligible to use today: HiSilicon SEC2, TI DTHEv2, Atmel (I don't have any=0D
to test on).  To bound the win, I used cryptd as a pure async carrier and=0D
moved the per-DU split inside it, then ran dm-crypt + fio: batching cut=0D
CPU ~30% on 128k I/O (large batch) and had zero impact on 4k -- so the=0D
saving is dispatch, not crypto.  A real engine that submits a whole=0D
multi-DU request in one descriptor avoids that per-DU dispatch entirely,=0D
so it saves at least that.=0D
=0D
So the question for me is what the bar is: does landing the API and dun()=0D
template now (with the in-tree consolidation it already buys dm-crypt and=0D
blk-crypto-fallback), with a throughput demonstration deferred to a real=0D
async provider, work for you ?=0D
=0D
Thanks,=0D
Leonid=0D
