Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BD0353A6F;
	Sun, 27 Sep 2026 07:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790493274; cv=none; b=gD5AFSpWEPPHVWsg4WUB/AtWlBcIiic5BIkHMwXsvvH21Hurx0HODV/XXoLAO96yaeUhMDovD2FkBVkUPxmEgVGTqrQoD1fDETws9iNzq0US5HCD2P2gInPhln3jI2T85SUiNWSGbYR1fKvrUKQtKPnNqYQ0xhNEZHnSCWUu214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790493274; c=relaxed/simple;
	bh=z47sgdTt5Rm4c6HV1ia4nSXFg0gUlUXEcznkll0hE1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tpzf9uL27sPXtvQOApkvlxSNXsJIFZui1c1lbaGLFm6aJybWRfakYSEqM5Y2nBqytJWcM0VkXU3/kJN5Don5nuX2beo8HgnIt1uvgYRCU4Ry0mKwHs84cj8n+8yFYelus8sjl6PSSn5tGlAs9ll79POtqzbFVt0/vYOAQaEMgrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Oz9T66fd; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Oz9T66fd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790493273; x=1822029273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7NMfIvtSlpQ1JWoomArH41D9xfcx2X7ulkXMwX9356U=;
  b=Oz9T66fdezkYAGpVh61AC+OnX6IWdpPr34oup7+moXr2xjCMpUSg3d0z
   pC2sAXzIVgTiODwL/oFsWNmSwCwqmxoHPoU0/h/TokIVGVEyky4lJ4COF
   T3/s3muv+A7zHCBo7GuPfQpwRQSC5ifdDv04ZL+GDde5+Z4qhL4JW/y91
   9gRASfg2+jAzLRWtoJci3AE2GVC4pJ5fYeiqsKO4/fTCuJJj8CQZeV5vI
   Q06fK0QQiGQYKSdxpu3BfVM2SMc8l8SML40OWgD9F2sQ/Nndk5Eo5b7Mw
   zvkgjepA4NBsirTHwa9gon3tYv7pGBubEnT+jeK6tkA0SNsD8xETL49LN
   w==;
X-CSE-ConnectionGUID: 8Vc8U/C7SvCkbE8HLn3E9A==
X-CSE-MsgGUID: PPX/BI8tRTSejTCQ14RsZA==
X-IronPort-AV: E=Sophos;i="6.27,125,1787011200"; 
   d="scan'208";a="29649944"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 07:14:30 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:26131]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.13.104:2525] with esmtp (Farcaster)
 id eca6073f-5c51-494b-92df-c2cacb58eaa3; Sun, 27 Sep 2026 07:14:30 +0000 (UTC)
X-Farcaster-Flow-ID: eca6073f-5c51-494b-92df-c2cacb58eaa3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Sun, 27 Sep 2026 07:14:30 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Sun, 27 Sep 2026 07:14:28 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>, <ebiggers@kernel.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <bmarzins@redhat.com>
Subject: Re: [PATCH v6 0/6] crypto: skcipher - multi-data-unit request splitting
Date: Sun, 27 Sep 2026 07:14:14 +0000
Message-ID: <20260927071422.12143-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <arY6lzQtvVzUGngU@infradead.org>
References: <20260924075846.28203-1-lravich@amazon.com> <arY6lzQtvVzUGngU@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWA003.ant.amazon.com (10.13.139.86) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Fri, Sep 25, 2026 at 02:10:47AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 24, 2026 at 07:58:40AM +0000, Leonid Ravich wrote:
> > * No throughput *win* is claimed for software AES.  The win is for
> >   accelerators that amortise setup across units; the software split
> >   exists so the interface works on every existing skcipher today and
> >   goes quiet as algorithms gain CRYPTO_ALG_REQ_SEG.
>
> So what is the use case?  So far all crypto driver we've seen have
> shown to be slower than cpu.  Which one are you using that isn't?

The engine we use is out of tree, but it is not a special case.  It
is an SoC-integrated, DMA-driven, asynchronous xts(aes) engine of the
same class as caam, ccree, qce, hisilicon sec2, inside-secure and the
Marvell CPT drivers already in the tree.  Like those, it pays a fixed
cost per request (descriptor setup, doorbell, completion) that
dm-crypt's one-request-per-sector pattern multiplies by the number of
sectors.  So the problem is common to the whole class, not specific to
our hardware.

You are right that such engines are generally not faster than the CPU
in raw throughput, and I am not claiming ours is.  What they give is
offload: when dm-crypt batches a bio into a single request, the engine
does the work that the CPU would otherwise do.  In our measurements
that cuts CPU utilisation by roughly 20-40% for the same I/O.  On
systems with few or small cores, those cycles are worth more than
peak throughput.  Without batching the per-sector request overhead
eats that gain, which is why the series targets the request pattern
rather than the cipher.

> And if you have a genuinely useful one, should we have a proper
> interface to it that doesn't pay the scatterlist overhead to start
> with?

For a DMA engine the scatterlist is not overhead: it is what the
hardware consumes.  The per-sector cost it pays is the per-request
cost, and unit_size is what removes it.

For the software path, v6 follows what Herbert suggested in the v4
thread [1]: the per-unit loop moves from the caller into the Crypto
API, and it can then move further down into each algorithm, so the
per-unit calls become direct calls and only the single call into the
API stays indirect.  That can improve on the status quo rather than
just match it.  v6 is the first step (the mid-layer split);
per-algorithm native splitting via CRYPTO_ALG_REQ_SEG is the next.

The interface is also deliberately the one being introduced for acomp
in the batching series [2]: the same unit_size field and setter
semantics, and the same CRYPTO_ALG_REQ_SEG bit (patch 2 here is Herbert's
patch from that series).  skcipher and acomp would share one model for
multi-unit requests, with a native path for hardware and a mid-layer
fallback for everything else, rather than skcipher growing a separate
interface.

If you had a different shape in mind for the hardware path, I would
rather build that than guess.

[1] https://lore.kernel.org/linux-block/ajDNT5jVGgRtiNH6@gondor.apana.org.au/
[2] https://lore.kernel.org/all/20260125033537.334628-15-kanchana.p.sridhar@intel.com/

Thanks,
Leonid
