Received: from beeline2.cc.itu.edu.tr (beeline2.cc.itu.edu.tr [160.75.25.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5321F29CB4E
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=160.75.25.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741104507; cv=fail; b=ueMSauF7SMCs4XM7krU7O27adTtxYJQHErFALZciKdwuR7K4nK80guaTzPeVyP1Z5CiadfyEoE5ICMOynswDJDdXjA8EWLVeaMb3T5bGcApnjUNbfVkJCvWeQVxyymLovJ+5H5u4M0kxfM1B1v4fTPmnjgpVYWS/k6j4U1TV/pM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741104507; c=relaxed/simple;
	bh=7FLVy+mHazqBRLUwwxAKIUKPJl1FViNyB85b6akzRXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bm4r0xG5ji2qQoTVNNHLWgMaZyeYsjpc2+0Q+dUy1OI+PL0GqC5jPPAxt4geJ4oAuO6FSpJ46XRl9IeOFor59uJr26ksjppA078j6IECCeAjtZ3vcN06P0fgn8HRacjOB7QdLLtimAK1HKU0Tb49PCBtJ29IFFJ1MEFfP7N2pyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=cc.itu.edu.tr; dkim=fail (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gt1dw67V reason="signature verification failed"; arc=none smtp.client-ip=192.198.163.14; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; arc=fail smtp.client-ip=160.75.25.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gt1dw67V"
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline2.cc.itu.edu.tr (Postfix) with ESMTPS id CB5BE40F1CF3
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 19:08:24 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6gNB47yfzG1rC
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 18:59:06 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id B112541898; Tue,  4 Mar 2025 18:58:44 +0300 (+03)
Authentication-Results: lesva1.cc.itu.edu.tr;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gt1dw67V
X-Envelope-From: <linux-kernel+bounces-541185-bozkiru=itu.edu.tr@vger.kernel.org>
Authentication-Results: lesva2.cc.itu.edu.tr;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gt1dw67V
Received: from fgw1.itu.edu.tr (fgw1.itu.edu.tr [160.75.25.103])
	by le2 (Postfix) with ESMTP id A5FA341E61
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 11:49:06 +0300 (+03)
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by fgw1.itu.edu.tr (Postfix) with SMTP id 42F723064C07
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 11:49:06 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AF933A94CF
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 08:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6F51F12F4;
	Mon,  3 Mar 2025 08:47:37 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747231EE014;
	Mon,  3 Mar 2025 08:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740991653; cv=none; b=Mew+Bz+5CcBzzPfCcKuSKG22Vn4YTxmGZ15l7J52G5LgtBG50rJJeXqh4AoMaqi7MFi5nat6heR2DAdzEEI9kxkQdYb8EW0cO7oaJqApWRHraAcwSKfm2DvmnuxoA5V/xi5NURSBI+uENo8qavBzWUzPChDtlI/wsRabvNUsokc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740991653; c=relaxed/simple;
	bh=LJoG0hwzy11IwSS0GA7f2KkCoIWMhfdeKs7bZI/C2Jg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M5TnE/OvlApkDBfIpnZhDBQL6N/jVoJQW6cCDGnxZ/VGUznWIHLeYMDL8NdnN1F1C9Eu1IJqV5EAYfnzzmZGqbOAzCGtJsYjXSFVKQA/oJCkxo28K0M49rSHCmhN/nit+Gylur1DQpyCpygGJgkp7XctYQImVX2K6NqzrQWpWkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gt1dw67V; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740991652; x=1772527652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LJoG0hwzy11IwSS0GA7f2KkCoIWMhfdeKs7bZI/C2Jg=;
  b=Gt1dw67VHBl2jicCy4GNgKflZmGKwdh2AK22+0oGcmxWeAzBAUD+aoc9
   HFrVu1k8bXmTMvX5Jo//HZ3WPopJJTb1/U2TuvU1C14T84eUZOTusSoso
   4GNJVIJyyyZa+qOr7IyfXsaEQwi70zyHkcW7/iWsIBsuRNpM3v/P4OrF0
   9C2CH/E58A2Dn5Q0dXegFX0ePqS0O4Uas2GScumwxLW3IBEFAQ3gy8z5f
   g+XUYMXyfkoJ4EaEwOu+2EF73V9mCGgXWMMxpfCaEykZ4F98WxnNp5JHs
   B2QuhAqg+t63fi7KQvMvRsUXvuA2Go5wOhKyLifuBttJONVlvCmi42/jg
   A==;
X-CSE-ConnectionGUID: dMwp9FegRd2dXB1nZxp7pQ==
X-CSE-MsgGUID: nVk5gWsbRN+neeYt63zuaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="42111867"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="42111867"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 00:47:28 -0800
X-CSE-ConnectionGUID: BqnvijDaScOzKITX7vs36w==
X-CSE-MsgGUID: yCwbwk1qQtu2vMCztNB7sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="118426765"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 03 Mar 2025 00:47:26 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v8 02/14] crypto: acomp - New interfaces to facilitate batching support in acomp & drivers.
Date: Mon,  3 Mar 2025 00:47:12 -0800
Message-ID: <20250303084724.6490-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6gNB47yfzG1rC
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741708757.88452@pF3aoQ+MwgGmg/K3IoaCGw
X-ITU-MailScanner-SpamCheck: not spam
Message-ID: <20250303084712.KEW_jACUMRP6SvSWswXI1zr5mrcxAO0gV_66zRyIwZI@z>

This commit adds a get_batch_size() interface to:

  struct acomp_alg
  struct crypto_acomp

A crypto_acomp compression algorithm that supports batching of compressio=
ns
and decompressions must register and provide an implementation for this
API, so that higher level modules such as zswap and zram can allocate
resources for submitting multiple compress/decompress jobs that can be
batched. In addition, the compression algorithm must register itself
to use request chaining (cra_flags |=3D CRYPTO_ALG_REQ_CHAIN).

A new helper function acomp_has_async_batching() can be invoked to query =
if
a crypto_acomp has registered this API. Further, the newly added
crypto_acomp API "crypto_acomp_batch_size()" is provided for use by highe=
r
level modules like zswap and zram. crypto_acomp_batch_size() returns 1 if
the acomp has not provided an implementation for get_batch_size().

For instance, zswap can call crypto_acomp_batch_size() to get the maximum
batch-size supported by the compressor. Based on this, zswap can use the
minimum of any zswap-specific upper limits for batch-size and the
compressor's max batch-size, to allocate batching resources. Further,
the way that zswap can avail of the compressor's batching capability is b=
y
using request chaining to create a list requests chained to a head reques=
t.
zswap can call crypto_acomp_compress() or crypto_acomp_decompress() with
the head request in the chain for processing the chain as a batch. The ca=
ll
into crypto for compress/decompress will thus remain the same from zswap'=
s
perspective for both, batching and sequential compressions/decompressions=
