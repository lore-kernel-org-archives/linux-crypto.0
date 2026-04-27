Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB843B5311;
	Mon, 27 Apr 2026 09:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777283879; cv=none; b=oJx8uJi3TnBJgxvd14gwft7108CxcVR02E/tcH6itZvfoaWBRjhmh0HljpthjI/ozpIL9D/N6Nxi055AbXWB52nT9Mzuy671vLMIz6YgYmcnWmr+lVp/74jtKA3bWJAkTc0mNIQfXbe3OD2dSW8mfM7caXriGu78FIqwpsyXSyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777283879; c=relaxed/simple;
	bh=6Fzm4Z7ePtvuhSJ3YmcULPtAlpBYxD0oO+72M4j5EVw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S4xFhFrYg33nUVog9Gf2bcyKnvGFUwlmbmC64BCFL34q0yitXa76eo4vFgltC0ZJ0yfQOO7mv7Ih7sfvJ2oXyPnDDfvs/3xq/0egVYEwVqeD6b6A3H3BRgWQVTBeDR3Sloc8taVDEv3m+hhYc9ZQ9+INOsb4p4+CVRNN0uLXQkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=I9p1oCO2; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="I9p1oCO2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1777283878; x=1808819878;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pKP53lUbhqASN9sJa59dZ9Vsten/OH+TCXzAJP3FFyk=;
  b=I9p1oCO2XAoViKwLrLRWFnNCEXVYknw2nZO7BrOsQ/x9ZTyYgdRH996z
   iyT6NFIUkV38ji7QofSh+Z7acraVr9sXqK/vYQ/+OQDFbirDRV9+O0wYH
   FdXK1tqxNjZ2isDWgz+BwU+oEc1X0iZhKtfl8nhBxe0JBtG2K5Rw3O/Ro
   S16sODK/fbDypAsuo2o39XFgQApkdCCTns1+Ls+g5NhRg6I5Z8gjziFrM
   JD4KSQL5/44lcLUxV02CHPUVsUZBNTu/Gt8TTBw1Ot23xxyz3tvFDBWfr
   /mwZBDCEmlAGPi9o/5RzQAoF+g8GI/at77FijPVYl6x4+Hge9AREr5r+J
   A==;
X-CSE-ConnectionGUID: Y/or1Z2tRrSKBECdJGvAEA==
X-CSE-MsgGUID: ioUg1lUqSqO+D9qcTsa/Jg==
X-IronPort-AV: E=Sophos;i="6.23,201,1770595200"; 
   d="scan'208";a="18285493"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 09:57:55 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:25961]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.92:2525] with esmtp (Farcaster)
 id 97807202-09fe-4e38-a80f-bee4ce9068d6; Mon, 27 Apr 2026 09:57:55 +0000 (UTC)
X-Farcaster-Flow-ID: 97807202-09fe-4e38-a80f-bee4ce9068d6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 27 Apr 2026 09:57:54 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 27 Apr 2026 09:57:52 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Eric
 Biggers" <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [RFC] crypto: skcipher multi-data-unit requests for dm-crypt
Date: Mon, 27 Apr 2026 09:56:22 +0000
Message-ID: <20260427095622.27799-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

dm-crypt submits one skcipher request per sector. For XTS mode with
512-byte sectors, a large bio can contain hundreds of sectors, each
requiring a separate crypto_skcipher_encrypt() call with its own
request allocation, IV generation, and async callback.

On systems with asynchronous hardware crypto accelerators, the
actual encryption is fast and this per-request setup overhead
becomes the bottleneck. Reducing the number of crypto API calls
per bio significantly improves throughput for these configurations.

This problem was discussed in December 2016 by Binoy Jayan, Milan
Broz, and Herbert Xu:

  https://lkml.indiana.edu/hypermail/linux/kernel/1612.2/01912.html

Herbert suggested moving IV generation into the crypto API so that
dm-crypt could submit larger blocks. The essiv template (by Ard
Biesheuvel, merged in 5.4) was the first step. The multi-data-unit
request concept was never implemented.

Existing hardware support
=========================

Several upstream crypto drivers already have hardware support for
per-data-unit tweak management in XTS mode but cannot use it
because the crypto API has no way to communicate the data unit
size:

NXP CAAM (drivers/crypto/caam/) has a hardware sector_size
register in its XTS shared descriptor. The driver currently
hardcodes it to 32768 bytes with this comment:

  "Set sector size to a big value, practically disabling
   sector size segmentation in xts implementation. We cannot
   take full advantage of this HW feature with existing
   crypto API / dm-crypt SW architecture."

Arm CryptoCell (drivers/crypto/ccree/) programs the hardware
data unit size via set_xex_data_unit_size() in its HW descriptor.
The driver template structure already has a data_unit field,
currently unused.

HiSilicon SEC2 (drivers/crypto/hisilicon/sec2/) submits the full
cryptlen to hardware with internal tweak management and SG DMA
via hardware scatter-gather lists.

Intel QAT (drivers/crypto/intel/qat/) submits full cryptlen to
hardware XTS mode in one operation with SG buffer lists.

Proposal
========

Add a data_unit_size field to struct skcipher_request:

  struct skcipher_request {
      unsigned int cryptlen;
      u8 *iv;
      struct scatterlist *src;
      struct scatterlist *dst;
+     unsigned int data_unit_size;
      struct crypto_async_request base;
      void *__ctx[] CRYPTO_MINALIGN_ATTR;
  };

When data_unit_size is 0, behavior is unchanged (cryptlen is one
data unit). When data_unit_size is nonzero, cryptlen must be a
multiple of data_unit_size. The IV applies to the first data unit.
The crypto driver is responsible for incrementing the tweak per
data unit according to the mode.

This mirrors the data_unit_size concept already present in struct
blk_crypto_config for inline encryption. In blk-crypto the size
is a property of the key configuration. Here it is per-request
because dm-crypt may use different sector sizes across different
device-mapper tables sharing the same tfm.

Required changes
=================

1. crypto: skcipher - add data_unit_size to skcipher_request
   as described above. The skcipher layer validates that
   cryptlen is a multiple of data_unit_size before dispatching
   to the driver.

2. crypto: xts - handle data_unit_size > 0 in the generic
   software XTS template by looping internally per data unit.
   This provides a universal fallback so every xts(...)
   instantiation supports multi-data-unit. The tweak increment
   (gf128mul_x_ble) is already implemented in the template.
   Hardware drivers override this with native support.

3. crypto: testmgr - add multi-data-unit XTS test vectors
   that cross-validate against individual per-unit encryption.

4. crypto: drivers - CAAM, CryptoCell, and other drivers with
   hardware data-unit support can read req->data_unit_size and
   program their hardware registers accordingly. For CAAM this
   means setting the sector_size register to the actual value
   instead of the current 32768 workaround.

5. dm-crypt - build a multi-entry scatterlist from the bio's
   bio_vecs, generate the IV for the first sector, set
   data_unit_size to the sector size, and submit one request.
   The existing per-sector path remains for IV modes that
   require post-processing (lmk, tcw, elephant) and for AEAD
   integrity modes.

Thanks,

Leonid Ravich
