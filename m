Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267DA22FF22
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 01:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178567; cv=none; b=GBIRQm6aLpLobs955rCBYSSCgFe3LV9YbCbTB7eqbr9rlfxlvVM0xcOnvY7Oo3nxKPNYzkoI5eA0J3Epn+QajRW+wYSNAFUry6lMOShsbiHFyueH/Hm1/e61U2a0821xfyLXgFCFSvCWLJZwC3xFsA8vCkVkGnSpyOOaZFa/tEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178567; c=relaxed/simple;
	bh=C4ZtVz7w7/Fji41NnxUarALqmLqEjFFOXiMi07EyQdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXccHjSa9g4Yjn1IPuecgbGJ6qVn32+xtcXXIPSI40MgQb45ZHzezSNLwg7t3AO6vmynh19bk7TOP2XDiMfoSt6C6wbgZjSSjbBvzbm79eivpPN0is5V7157oP31NJewYbmc4Bjr3rVCaQn7LHyQH4VRNIqNhRhkaxW1WLEuNIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nDqMh/4e; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nDqMh/4e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=NFos/JjJ5VlYsVaNfAA0c7qPQ9BmdjhKxXylBM4IxHU=; 
	b=nDqMh/4eddKLVovIZJtylAG9cOelKTWq2YA6gKCbuw+rT7pv/WsmoJYSX1S4jUYAQ3gdHbT37RN
	XpYVxasogB0BAEVCGM7+0FtFe0gaidFMw3usm730AmIVoVSGjwW+JHXTMKMaENmQUOOYJ7Oi8T9q5
	yj4eZrQabAja/6n//ZWO/PUCZ82BMjhoBqOiN4fRGZHNaRmKXFsEfnEETP1OlCJbKwgcW5pe9ce4D
	9qkIJdNMBCHYOyUZjsdwgFL2UrEERG0Fdkxlxp3oe95uO6xPsTyfO8CHYJBhlXzEDj34aLP6EvgIe
	xNBQ/kaOeOr3QlLUqOevaMmiAVYi4vhyrDPg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8Scp-003R4X-2P;
	Fri, 03 Apr 2026 09:09:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:09:22 +0800
Date: Fri, 3 Apr 2026 09:09:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2 0/2] crypto: qat - add support for zstd
Message-ID: <ac8TQpRt5TU7GX0J@gondor.apana.org.au>
References: <20260328223445.39445-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328223445.39445-1-giovanni.cabiddu@intel.com>

On Sat, Mar 28, 2026 at 10:29:45PM +0000, Giovanni Cabiddu wrote:
> The Intel QuickAssist Technology (QAT) driver currently supports deflate
> compression via the acomp API, but lacks support for the ZSTD algorithm.
> 
> This series adds ZSTD compression support for QAT GEN4, QAT GEN5 and QAT
> GEN6 devices.
> 
> On GEN4 and GEN5, hardware compresses data using LZ4s (a QAT-specific
> variant of LZ4). The LZ4s output is then parsed and passed to the kernel
> zstd library via zstd_compress_sequences_and_literals() to produce a
> standard ZSTD stream. The post-processing step uses per-CPU scratch
> buffers managed via the acomp stream infrastructure.
> 
> On GEN6, both compression and decompression are natively offloaded to
> the accelerator. Decompression of frames with a history window exceeding
> the 64 KB hardware limit falls back to software.
> 
> A filtering mechanism is also introduced to prevent GEN2 plug-in cards,
> which do not support ZSTD or LZ4s, from being selected for these
> algorithms when a GEN4, GEN5 or GEN6 embedded device is also present on
> the system.
> 
> In summary:
> - Patch #1 fixes a build error on architectures without a native
>   byte-swap instruction
> - Patch #2 exposes the ZSTD algorithm through the acomp API for QAT
>   GEN4, GEN5 and GEN6 accelerators
> 
> Changes since v1:
> - Add a patch to fix a build error on architectures without a native
>   byte-swap instruction
> 
> Giovanni Cabiddu (2):
>   crypto: qat - use swab32 macro
>   crypto: qat - add support for zstd
> 
>  drivers/crypto/intel/qat/Kconfig              |   1 +
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   1 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   1 +
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  17 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   6 +
>  .../intel/qat/qat_common/adf_common_drv.h     |   6 +-
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   |  18 +-
>  .../crypto/intel/qat/qat_common/adf_init.c    |   6 +-
>  .../crypto/intel/qat/qat_common/icp_qat_fw.h  |   7 +
>  .../intel/qat/qat_common/icp_qat_fw_comp.h    |   2 +
>  .../crypto/intel/qat/qat_common/icp_qat_hw.h  |   3 +-
>  .../intel/qat/qat_common/icp_qat_hw_20_comp.h |  10 +-
>  .../intel/qat/qat_common/qat_comp_algs.c      | 524 +++++++++++++++++-
>  .../intel/qat/qat_common/qat_comp_req.h       |   9 +
>  .../qat/qat_common/qat_comp_zstd_utils.c      | 165 ++++++
>  .../qat/qat_common/qat_comp_zstd_utils.h      |  13 +
>  .../intel/qat/qat_common/qat_compression.c    |  23 +-
>  18 files changed, 779 insertions(+), 34 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.h
> 
> 
> base-commit: 93e03a16c015b8e55e2ec97865f67d9bf1ec1921
> -- 
> 2.53.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
