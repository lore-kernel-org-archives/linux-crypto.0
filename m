Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0913F2BD03B
	for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 10:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836389; cv=none; b=dItq5rNbfb/XQJEOlCILLGQVyGVZELtnGvHsAHBEmpM6RdBrgUa2R62E5lrwqid9DVHHfSp0p2l2w2dGkvk+7ohDvg0HpKT4I/bmtrVbLceCkujb5+oJ8ZkrHSzDesSXTxTMMilk4UuGs109e/Zw/+z2xJS4BX9sZly5v5t5VpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836389; c=relaxed/simple;
	bh=WXlZWUVbKPribTeh+DshSoD8nsa23NaL9hYAboQua6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K41eO74fO/jqQTty8I9NAb2RLG/8fstJWRV9axrE2qKFatCSLReV65rKgFFxEOSm7SQoLb+d59swiHnIiPsuhXYmffXvCad1gfOZi2zElZr1kwLxC/DErcVX5DOVoCkkGhgrr34O6nv64r6vIzmCCsa+/vwvwlWXdAgoc4b301I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rWwusrUm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rWwusrUm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yHv0gSSJqQQPb2sZ8wO3vLjRwvq1B+Svfv1sLej00Uw=; b=rWwusrUml/1RL+gL3Z4AR5oI16
	1fWDVk8lr9TB4WWBODBmp5SVr3VeRNZQja1sYNZiJX7ERp4cBv5lTvp4bGYKEv7ZO1sAR/KJy6png
	OnePfAtgxZh56+2C5rPyQCerdJaMcviQblvKs84cmfTsK6Dld8c77Uvk56IHor0nMkIV8iS0KsnSF
	4vSJ5znxCdbRh2Rtdah7Q06ROT72tycvhr5y9iqOpE26CFQ3RJZlMbcycT8Ctiq54VBYyjLGYYbCn
	wL5yYP23ZU5UF9D57lbyRtPF6xlBtl8FHMHvciJ/7TyoPNxBd7oKqKzS/buJ7hxMXVbMHI1FJC81Z
	bYaUoYMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciZ9-007ydX-3B;
	Fri, 18 Jul 2025 18:59:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:59:44 +1000
Date: Fri, 18 Jul 2025 20:59:44 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - add support for PM debugfs logging for
 GEN6 devices
Message-ID: <aHopICrLDK1kUcs5@gondor.apana.org.au>
References: <20250707122846.1308115-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250707122846.1308115-1-suman.kumar.chakraborty@intel.com>

On Mon, Jul 07, 2025 at 01:28:44PM +0100, Suman Kumar Chakraborty wrote:
> This set relocates the power management debugfs helpers to a common
> location to enable code reuse across generations and adds support for
> reporting power management (PM) information via debugfs for QAT GEN6
> devices.
> 
> George Abraham P (2):
>   crypto: qat - relocate power management debugfs helper APIs
>   crypto: qat - enable power management debugfs for GEN6 devices
> 
>  Documentation/ABI/testing/debugfs-driver-qat  |   2 +-
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  11 +-
>  drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
>  .../qat/qat_common/adf_gen4_pm_debugfs.c      | 105 +++------------
>  .../crypto/intel/qat/qat_common/adf_gen6_pm.h |  24 ++++
>  .../intel/qat/qat_common/adf_gen6_pm_dbgfs.c  | 124 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_pm_dbgfs_utils.c |  52 ++++++++
>  .../intel/qat/qat_common/adf_pm_dbgfs_utils.h |  36 +++++
>  8 files changed, 268 insertions(+), 88 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_pm_dbgfs.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.h
> 
> 
> base-commit: ecc44172b0776fab44be35922982b0156ce43807
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
