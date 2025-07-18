Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095852EAE3
	for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836256; cv=none; b=SeDsmV8oEc01U/KkKcvuPIL5gRDLNezRb02nNEes3s8lMvNOm4w/iiiq9Mn9WiRXx2fixfd/WDczPwM1pOgwbiyVSChR1AmxuZb2c7SSr1Eu/pQkIn0yhxbpPGHmXkFE0EtJDGepEhGIYVa7KVuClm3FS5PksZh7+IF7TbU4iLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836256; c=relaxed/simple;
	bh=I1miLKdNwf1cAcYFIBiuFwzOz3pwQSoo9SSdT6zNJAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hidIo/Ag4fnWkNdRDmDaizFa8AS8W8PbD/IguTrLUg4wH1T1Q5SXxBqIQk67eaWtgAw/38xkasj87oZJz+5F0tt/sG+W3Rai4UcSUCK8IDplxH/I4SaXswaKZr8If+AR+s3Q0nVkqn7B/IZ4TPgLDjZFwXGzq9SQW9KkzfCTID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AqR0QR5B; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AqR0QR5B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sNwKRVXH1AGrV7HiIbbRf3MkVTLiNlI+snEMDlnC7G0=; b=AqR0QR5B5IlzCDOiHcqzjOZqfR
	2NfHo3e8GnT2JxUKa35iZE3JnO4t6+FS8Dtg8ngZN47V3cyRPAQMNcWopwBugFpz2w7Z+IYwwuU8J
	fW3ZQtuaBbQg+jOQ0cJ4ZJpg8Oazieh/iqx/g7kcPR5/SGJcUAhuyPjt3GkxOPxcDmdfmoTqQK5Uo
	7Ze84l2JmUdIi6KAeGMcBmcPBUKPNQJ/AbRvFgcKOey3n0+JjKXbYZT5yZYyBXclCupClI+cGZEk1
	p63eDBGXiZswF5RKbLeDvGaHnxctwlrdLYSfLt0FueyBj3DwLyWZe9iv/J65Fjq8LBrI8sxRfTopf
	iQHxzTGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciX0-007yZ9-2m;
	Fri, 18 Jul 2025 18:57:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:57:31 +1000
Date: Fri, 18 Jul 2025 20:57:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/5] crypto: qat - refactor and add live migration
 enablers for GEN6 devices
Message-ID: <aHoom10NZu82JaiL@gondor.apana.org.au>
References: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>

On Tue, Jul 01, 2025 at 10:47:25AM +0100, Suman Kumar Chakraborty wrote:
> This patch series focuses on adding enablers required for live migration
> for QAT GEN6 devices and improving code reuse and maintainability across
> different QAT generations. The changes include refactoring shared logic,
> relocating reusable functionality, and improving code clarity and debugging
> support.
> 
> In detail:
> Patch #1 improves logging consistency.
> Patch #2 improves state checking logic.
> Patch #3 relocates bank state helper functions to a new file.
> Patch #4 relocates and renames the bank state structure
> Patch #5 add enablers for live migration for QAT GEN6 devices.
> 
> Małgorzata Mielnik (2):
>   crypto: qat - relocate bank state helper functions
>   crypto: qat - add live migration enablers for GEN6 devices
> 
> Suman Kumar Chakraborty (3):
>   crypto: qat - use pr_fmt() in adf_gen4_hw_data.c
>   crypto: qat - replace CHECK_STAT macro with static inline function
>   crypto: qat - relocate and rename bank state structure definition
> 
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   5 +-
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |   4 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |  38 +--
>  .../intel/qat/qat_common/adf_bank_state.c     | 238 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_bank_state.h     |  49 ++++
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   | 199 +--------------
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |   7 -
>  .../intel/qat/qat_common/adf_gen4_vf_mig.c    |   7 +-
>  .../intel/qat/qat_common/adf_gen6_shared.c    |   7 +
>  .../intel/qat/qat_common/adf_gen6_shared.h    |   2 +
>  11 files changed, 314 insertions(+), 243 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_bank_state.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_bank_state.h
> 
> 
> base-commit: 65433cdeb0bdd0ebd8d59edd3c2e6d5cbef787c3
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
