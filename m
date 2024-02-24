Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC690EDF
	for <linux-crypto@vger.kernel.org>; Sat, 24 Feb 2024 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708735880; cv=none; b=TRn00olhdEwQRs+Zw7cc4Fb4ivPmavT7s0cchQrsNuiyqQDxbxPagj4zWRD+7u8FRkr+mvUWhr7dhHpQG4OFl4KbA6K1iwclvpJ7w/F8l9N6jQvowRP/HkoHjwS34+YORiYHMF1tY2P6Jyo1mWNz8+EPws0z22QFoK6PuGebsio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708735880; c=relaxed/simple;
	bh=JcFy1tp3VdbO/Ai9iOxMeIOlnz2VEvO28N6rS8X4fng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbHIYfjjKcId1BeSl4fvtM9vaZzAv6JQGyh4ymFW9xMrX0UUYhLOyBo/hAUeqhhE2aB378yy9VLdbMuY1dOSH3DRZ4DsufVi0G1sBswnBG2hmllaPSj2CDVGnGYdacSW08JiXlFJGx8xiwdsBDJqF858X0udJwAzQxm6uCaSwv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rdgG3-00HDyE-0E; Sat, 24 Feb 2024 08:51:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Feb 2024 08:51:29 +0800
Date: Sat, 24 Feb 2024 08:51:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/3] crypto: qat - fix and make common ring to service
 map in QAT GEN4
Message-ID: <Zdk9kWJ93r06QK53@gondor.apana.org.au>
References: <20240216172545.177303-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216172545.177303-1-damian.muszynski@intel.com>

On Fri, Feb 16, 2024 at 06:21:53PM +0100, Damian Muszynski wrote:
> This set is revamping the method that generates the ring-to-service maps
> in QAT. The initial two patches rectify the existing algorithm version
> for use cases when the dcc service was enabled. The final patch
> eliminates the function's duplication in device-specific code and
> relocates it to a shared file.
> 
> Damian Muszynski (3):
>   crypto: qat - fix ring to service map for dcc in 4xxx
>   crypto: qat - fix ring to service map for dcc in 420xx
>   crypto: qat - make ring to service map common for QAT GEN4
> 
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 64 +++++--------------
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 64 +++++--------------
>  .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   | 56 ++++++++++++++++
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |  1 +
>  5 files changed, 90 insertions(+), 96 deletions(-)
> 
> 
> base-commit: 48f0668106f3664f4101c9f24fdb3b8c13f5880d
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
