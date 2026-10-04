Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E385E3F9F5B;
	Sun,  4 Oct 2026 09:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791107515; cv=none; b=bqViCsA6SkvIgVH9XqJnJ5Yqsm7NQppe4zvmrSQAL3oZnhZLBm9dXvNkCPyTuKXd24sZIhYQSiXgQ3B4PLgWD4Pbef/zhViw8tMvtvmtulra0cDMA0KN2TJScLlYn/h22ZAxE/cW9M7NbIF5qtzfi5Afmb18JhAmmvEfrIMa3Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791107515; c=relaxed/simple;
	bh=sFxhWSCP0mcaK4JLEjpA5w635bnyYYjPC1eVVHJLC3k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLFFXhAKn8n7V7Pd30pTZLFVkgAHsuh4Kvb+Mj5SsXLPwieN4eKUCg2HArDTn+adDS0RrX05/lNdyJPXax8em4yVpebglnopLhzwzMZbTGP/E/05ixZgQ/yZkBRaWWhK6zoijF2DeUXIqZD1RJpX1VQ2gweShwkUf2D/R+XA6j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=eWjZL/pT; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="eWjZL/pT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1791107511; x=1822643511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qOHcbtb/VRWrwcQuRj1W7KizObd5F5syz26snzqQx+g=;
  b=eWjZL/pTFXRXAmJJkjN3akCJN+Uf4qdJfI6tHIp7yb/++PRqoB+1caW5
   XF+/zxmyfMwwaQw/YTDtLsD1IPjfvbwZ4mGkP+hYyJwFeYSvFl2cvUYCj
   kyEivbTZ8s+BgxgmfUD9OrOEap2H+e7GZJJOO7UUeXSkkYb/7+5r1HzhP
   dL37LJ9oH79xClm5mUtZ4pFYbG5cKiGn1Xpjd1pVD5ELJckIRi+W1sEO3
   l+Vs4l51FFLjC8IT48PyGXnGZDdPl2TIn/W8f1YoY2/HRJItXRtRSPo3w
   ERiTT+Mmg3MnzV/ZHUgbVUhK9EZRMGnz0CNMkqjnBpklsa6T+Mp5OIPb5
   A==;
X-CSE-ConnectionGUID: D2xFCtpiS1WBE4zn8XfXIA==
X-CSE-MsgGUID: yLnNzBhMTxqwMUEUZ2yIhQ==
X-IronPort-AV: E=Sophos;i="6.27,139,1787011200"; 
   d="scan'208";a="30371884"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 09:51:47 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:22268]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.137:2525] with esmtp (Farcaster)
 id 19c6d27f-d39f-48d3-a63a-e9224414ef55; Sun, 4 Oct 2026 09:51:47 +0000 (UTC)
X-Farcaster-Flow-ID: 19c6d27f-d39f-48d3-a63a-e9224414ef55
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Sun, 4 Oct 2026 09:51:47 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Sun, 4 Oct 2026 09:51:45 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Christoph Hellwig <hch@infradead.org>, <linux-crypto@vger.kernel.org>,
	<dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>, <ebiggers@kernel.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <bmarzins@redhat.com>
Subject: Re: [PATCH v6 0/6] crypto: skcipher - multi-data-unit request splitting
Date: Sun, 4 Oct 2026 09:51:39 +0000
Message-ID: <20261004095140.24161-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ar9hjvFGLUKv3lEM@gondor.apana.org.au>
References: <20260924075846.28203-1-lravich@amazon.com> <ar9hjvFGLUKv3lEM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA002.ant.amazon.com (10.13.139.10) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Fri, Oct 02, 2026 at 05:47:26PM +1000, Herbert Xu wrote:
> I think the issue is that we're generating the IV twice.  Once
> in the Crypto API and once again in the DM layer.  Not only is
> this slow, but it is actually wrong for decryption.  You're ignoring
> the IVs on the disk.

I don't think either happens in v6, so let me check we are reading
the same code before I change the design.

The IV is generated once per request, not per unit.  In
crypt_convert_block_skcipher() dm-crypt calls iv_gen_ops->generator()
for the first sector of the segment only.  The Crypto API then derives
the IV of each following unit by incrementing the 64-bit little-endian
sector number in the low 8 bytes.  That is the same value the
generator would have produced for that sector, so no generator runs
twice.  Only plain64 and essiv are batched, because those are the
modes where IV(sector + i) is exactly that increment.

On-disk IVs are never ignored, because batching is never enabled when
they exist.  The only case where dm-crypt reads an IV from disk is
the integrity-metadata branch in the same function:

	/* For READs use IV stored in integrity metadata */
	if (cc->integrity_iv_size && bio_data_dir(ctx->bio_in) != WRITE)
		memcpy(org_iv, tag_iv, cc->integrity_iv_size);

CRYPT_MULTI_DATA_UNIT is only set when integrity_iv_size is 0 (and
the target is not AEAD; see crypt_can_batch_units() and its caller
in crypt_ctr_cipher()).  So a device with stored IVs keeps the
one-sector-per-request path, and its reads use the stored IV exactly
as today.

On the cost: the IV part of the ~50 ns is a 16-byte copy and an
increment per unit.  The rest is re-pointing the scatterlist at each
unit and the extra call into the algorithm per unit.  An IV array
would replace the copy and increment with a load from the array, but
the per-unit scatterlist and call overhead would stay.  I have not
measured the components separately; I can if that would help.

> My suggestion is to allocate memory for the IVs.  Of course
> memory allocation can fail, but we have an easy fallback, which
> is to use the existing single-unit path.
>
> IOW if you succeed in allocating memory for storing the IVs,
> then invoke the multi-unit code path, otherwise fall back to
> the single-unit code path which iterates over the sectors one-
> by-one.
>
> To pass the IVs to the Crypto API (or back), just use the existing
> IV pointer and extend it by the number of units.

That said, I can see what an IV array would buy beyond the current
modes.  The Crypto API would no longer need to know how IVs relate
to each other, so every dm-crypt IV mode could batch (lmk, tcw,
eboiv, benbi, and plain64be without a template), and so could
devices that store their IVs in integrity metadata, since dm-crypt
would fill the array from the tags on read.

So the question for you is about scope rather than correctness: do
you want the interface to be "one IV per unit, ivsize * nunits bytes
at req->iv" so that it covers those modes too?  If so, v7 will do it
that way, with the single-unit fallback when the allocation fails.
If plain64 and essiv are enough for now, I would keep the counter
form from v6.

Thanks,
Leonid
