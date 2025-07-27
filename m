Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEE626ADD
	for <linux-crypto@vger.kernel.org>; Sun, 27 Jul 2025 12:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620368; cv=none; b=Wxphfk2wRHuDrhmuryBeIt0x2TFl5pchQhqXZlxd7TN4JrRqDPjD5CuzVTOdyHVpVWrudvB8lI3BBCxurRwxxRbfGfY3ujTcyCqfiXzejsJoz3SV/1l2Uaa0iwuhv9jZ+JNdL8iJsOGem0rvk10uaMZeaBXKrxytL5LiYmj8Bgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620368; c=relaxed/simple;
	bh=g50vnrtc7x4iW3IHluhBG4k9gRY/ZSHOyfbbNaKGB8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NfGkrs7euOIu3TclRJYGa1OB/pnFMWJkn+HjoQ710mJfRKgP+QHfbHxJ7EPOASkgc3omia/xRCnktve8VT3RkV0lhLDy8opRxurV5Z59TshxK+aOsECcdfRvZBpTk7iy90tpkyAxvrMJqSoep4QhYlzBEcAzCclLTy4BiLX08Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=a1j+wU6F; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="a1j+wU6F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=larrk02g0AbVHpqqaB2Li357t+qz8asdbwMIR56MbpI=; b=a1j+wU6FNsTAfFf84EDCYx61R9
	7w9Ui7sW8XFaEk+wM84JUp17UQM/6vZHuPTc2MxVp2OiSn5hQqdXpk0k8EQJIqrhJzEjn6kixIZXS
	tI5CRLqBbPQjV+xbEpkeuDa7D8uCUQ5SZVjIyV9aaHDhzT5WuNgkLADxy41EZuFOQqe8TAwTxYV2g
	aGVubXObZhfzCTkcW9M5TbesTD+FXFisUjUsHV//YQBmgOwa9aRkXph3+OEHgBPfAYWZe/qNkPwbW
	/miydpZ/4as19gC/FVb0BPoB5sieoYbyUKhWgz0uhFbiWEjrKwqJCx+9DQjxVMHkqC65dx+I+s9E2
	cJ+sbL2g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0Vv-00A4uh-39;
	Sun, 27 Jul 2025 20:46:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 20:46:00 +0800
Date: Sun, 27 Jul 2025 20:46:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - make adf_dev_autoreset() static
Message-ID: <aIYfiHqBYDiIkHnt@gondor.apana.org.au>
References: <20250717100647.6680-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717100647.6680-1-giovanni.cabiddu@intel.com>

On Thu, Jul 17, 2025 at 11:05:43AM +0100, Giovanni Cabiddu wrote:
> The function adf_dev_autoreset() is only used within adf_aer.c and does
> not need to be exposed outside the compilation unit.  Make it static and
> remove it from the header adf_common_drv.h.
> 
> This does not introduce any functional change.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c        | 2 +-
>  drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
