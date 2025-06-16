Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3724928DEFF
	for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 02:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750042629; cv=none; b=lgQcBvzAt0nohPh6EDUK88Cw5F30q21azwBvtU6z5k2pOKsPY/g+YJFTozbPBUJ09N9mBBM5T3rpmlwgplKAI21Nrd10CPjvBHBW4gGF/wIWWQqdldXhmqPVRyDU2vEpedaPMeVC1Wecwh3HMzD+BEhOppFWeUuWcX1NaCs7Zw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750042629; c=relaxed/simple;
	bh=IlileO4qK2gVr8FrZUaG4vyYdn26DjI8Qw79oT1sbSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g8TRvQeh4x4UgOAnAkvekX7msnnPoioAWLNXY48TzoMkD+lTBkffM6VTNDZu85yqesl+6K+PNFIOrDBBq66pe6VIj5TuJ7M0EZ1/FS63rfvgzWaII24vQcVrsJewwyxd8wKPWepu1v26F7q5VxtxCbTp/kOqzrePGQaHydaT+HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fFTSQZ3I; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fFTSQZ3I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wY3hEnVyj4t8yRO5mwj8+4+HrwUruaWQT+ZV1XqCcJ4=; b=fFTSQZ3IZXQbsV3u1GDeZJzs2o
	zg7f5YApynt+Ct8wBrpj9NThGGIFn6I90o5uYqbB95LEYz3RNnyMlIWQ2qylw0Hr+YOJXPb8A7eu9
	+P16OEg52bPVhVHImme0SUtxffUIh6L4mg7D0Ode2cRNjP++4zz21PXxsG8sAJKEmykjbuJ3wrdMn
	A9Y+pABSitZwRVgN4hoXHMG84Kt8QRsU99rWMoIzCepJOhItsVsRRRp+hIwA/0MV+dSlZzUljuGwC
	6id4hcan60BaziflIummLNBi7NMI8yrBbF50sSL3Onv9nNNHgh5lSrdnUHHVG5L3ilvuQwTKNL26Z
	UxIEjFAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQzmk-000Ibi-2f;
	Mon, 16 Jun 2025 10:57:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jun 2025 10:57:02 +0800
Date: Mon, 16 Jun 2025 10:57:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Subject: Re: [PATCH] crypto: qat - fix state restore for banks with exceptions
Message-ID: <aE-H_ueJQ9QMJyg6@gondor.apana.org.au>
References: <20250604160006.56369-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604160006.56369-1-giovanni.cabiddu@intel.com>

On Wed, Jun 04, 2025 at 04:59:56PM +0100, Giovanni Cabiddu wrote:
> From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> 
> Change the logic in the restore function to properly handle bank
> exceptions.
> 
> The check for exceptions in the saved state should be performed before
> conducting any other ringstat register checks.
> If a bank was saved with an exception, the ringstat will have the
> appropriate rp_halt/rp_exception bits set, causing the driver to exit
> the restore process with an error. Instead, the restore routine should
> first check the ringexpstat register, and if any exception was raised,
> it should stop further checks and return without any error. In other
> words, if a ring pair is in an exception state at the source, it should
> be restored the same way at the destination but without raising an error.
> 
> Even though this approach might lead to losing the exception state
> during migration, the driver will log the exception from the saved state
> during the restore process.
> 
> Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> Fixes: bbfdde7d195f ("crypto: qat - add bank save and restore flows")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   | 29 ++++++++++++++-----
>  1 file changed, 22 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
