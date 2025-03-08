Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0075013C8F3;
	Sat,  8 Mar 2025 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741422597; cv=none; b=dQGjWlw2kREnRlGbN8bIsRAgRHKG2UYak8Svcg1ZMA0vDCROOSOy726U9U/XN+uWcBmb+dlY/PBkLWCbz5ZSh34R61LJxl2MjsN1+7ps6Wya8nTlvOJwiHHyXcXs7obC9HtkP0fPipjORC33j700TABPBYoMwW0WZ5IqKTGvPrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741422597; c=relaxed/simple;
	bh=WSNA3BBLFKSfUikJj+CfS+8eXC42JmjW0MdCGY60QbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPPcRHioAjgcD6CJkVy6nOTRvpOhNUGOAhOCiq3zluRh6lAFauE/q0TTkcSy/8GEjrkHlejsV7Vjz2vORnGw/krQz5oaYD8bpMgaog0CTo37UH94vbfxpL8GwtGk4s8FlMRqFmZv8n6OqBnne/qLmMAgfiv6dS8WlFp+5BOvo80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hLgz5Zs3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hLgz5Zs3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tZ+2bGh/MnVSsospfWDJ6WhrM00mV4Pwz55VQ3nG+C0=; b=hLgz5Zs3jAvhCOCW/KPX3pxJh1
	LioTKil2EY2SdGkDsxZIpfbxED0HppEacOxF0IEmd8crY2Wzid/pk7KiXnJDBAVX3LwHVa1+Pv2nQ
	5Am3unn+mlBdmhka9t48fDTuihPRo83RpuPCeBBA9mXYYE+2LjRiQgzOHCZCtDkiNipN0cP6BUFpz
	OE/str7My4rTgFP+07z7hmITlD3YozZUGGQftgxPrKk2fCzNv6dIL+kZxuNYzn1+xJkAqiiefL04C
	Z/sr9+GU2O+tD6aw+cs3Je2CIojAcqYDHdQUpjU1kU+tm+xlToZGvTuECG+jvsFLO9YppY/UUASfC
	NE+10GIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqpZ2-004oeR-0m;
	Sat, 08 Mar 2025 16:29:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 16:29:44 +0800
Date: Sat, 8 Mar 2025 16:29:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: davem@davemloft.net, thierry.reding@gmail.com, jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Tegra Security Engine driver improvements
Message-ID: <Z8v_-B8ZTIY4scFm@gondor.apana.org.au>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224091610.49683-1-akhilrajeev@nvidia.com>

On Mon, Feb 24, 2025 at 02:46:00PM +0530, Akhil R wrote:
> With the CRYPTO_TEST now being run asynchronously unveiled some
> concurrency issues in the Security Engine driver. These were not
> caught during functional or fuzz testing as all the tests were run
> synchronously.
> 
> This patchset contains the fixes for the concurrency issues and few
> other improvements identified during the stress-ng and cryptsetup tests.
> 
> ---
> v2->v3:
>  * Fixed testbot warnings.
> v1->v2:
>  * Added patch to handle the scenario when keyslots are full
>  * Added patch to finalize crypto request which was not called in some
>    error cases.
> 
> v1: https://lore.kernel.org/lkml/20241217161207.72921-1-akhilrajeev@nvidia.com/
> 
> Akhil R (10):
>   crypto: tegra: Use separate buffer for setkey
>   crypto: tegra: Do not use fixed size buffers
>   crypto: tegra: finalize crypto req on error
>   crypto: tegra: check return value for hash do_one_req
>   crypto: tegra: Transfer HASH init function to crypto engine
>   crypto: tegra: Fix HASH intermediate result handling
>   crypto: tegra: Fix CMAC intermediate result handling
>   crypto: tegra: Set IV to NULL explicitly for AES ECB
>   crypto: tegra: Reserve keyslots to allocate dynamically
>   crypto: tegra: Use HMAC fallback when keyslots are full
> 
>  drivers/crypto/tegra/tegra-se-aes.c  | 401 ++++++++++++++++++---------
>  drivers/crypto/tegra/tegra-se-hash.c | 287 ++++++++++++-------
>  drivers/crypto/tegra/tegra-se-key.c  |  27 +-
>  drivers/crypto/tegra/tegra-se-main.c |  16 +-
>  drivers/crypto/tegra/tegra-se.h      |  39 ++-
>  5 files changed, 523 insertions(+), 247 deletions(-)
> 
> -- 
> 2.43.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
