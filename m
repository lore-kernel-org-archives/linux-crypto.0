Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFF83FD4;
	Sun,  9 Feb 2025 09:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739092534; cv=none; b=N556f+Z0dphOX6daq/ze6cjeC7AKPGKUSx1TctJ8hxLU0IVP5pe5mH/JnSiShC620/GB61k5QnLTA61yN4g7HFkSaXReFRG7YRoF3E3koyc0CFkzFEnCxkpyeL9QBRXJqY9AajaA3uVrHcJxO4yQlenSjgsdQdujTWArjP4YIhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739092534; c=relaxed/simple;
	bh=pdNmNdB4q9tSI3XCvQZF07ktkkgO2HLXwVfSrPn6U3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aH/k7RKCikat0ddLCI8r6l5xKv3m13y3e1OouAyeQX7/vhIK5IEhwAzAECjHR2tz5ekfuapyH7Z7Ol32BurrE+Wo79wFM2s347LDqYsZ1SsxeG5RmX/BDTHYzYni/gm0apOPspv/dtAYDe6j0dDT3ymIv9jtCPxYS8ZmV1LfXd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WjyQYCyK; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WjyQYCyK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c40SNNDrCukYaDzZcrO7o78IDcQK+pnm5tlYNyilnX8=; b=WjyQYCyKsJnpQiNF96keXAsdIA
	S+GZjoGTGik8ENshKhXeoxxTXTPJsvFbxU6nPhRk8NgXuwE3QeF5wY+kD/7IYddciiBSpf9+Bnm3t
	AA5R94F1+PcVtU/lxQRnOIvITWc+XUouZsZRyevOAaWxgC3pHHPmQXYWcp9qEG/HhXLOI8n7vg4sr
	fDm920VI/jQMUP8/8zHoB6Il1Hz3BMn4Q1nGYmykUPGmrQ7KK3iCQR14bQntk9eCKjDadsZeyKwxo
	3JGEHe+QDEvegIYBii4tDEaZntBAJ+w+rmRL4Lge6o08XrM6YXsV9Lfu1qPIyKTwoWkW4NDWsiMxY
	CG0RS/TA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th3CU-00GI9i-1Z;
	Sun, 09 Feb 2025 17:15:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 17:15:23 +0800
Date: Sun, 9 Feb 2025 17:15:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dragan Simic <dsimic@manjaro.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	olivia@selenic.com, didi.debian@cknow.org, heiko@sntech.de
Subject: Re: [PATCH 3/3] hwrng: Don't default to HW_RANDOM when UML_RANDOM is
 the trigger
Message-ID: <Z6hyK-nU_mLxw-TN@gondor.apana.org.au>
References: <cover.1736946020.git.dsimic@manjaro.org>
 <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>

On Wed, Jan 15, 2025 at 02:07:02PM +0100, Dragan Simic wrote:
> Since the commit 72d3e093afae (um: random: Register random as hwrng-core
> device), selecting the UML_RANDOM option may result in various HW_RANDOM_*
> options becoming selected as well, which doesn't make much sense for UML
> that obviously cannot use any of those HWRNG devices.
> 
> Let's have the HW_RANDOM_* options selected by default only when UML_RANDOM
> actually isn't already selected.  With that in place, selecting UML_RANDOM
> no longer "triggers" the selection of various HW_RANDOM_* options.
> 
> Fixes: 72d3e093afae (um: random: Register random as hwrng-core device)
> Reported-by: Diederik de Haas <didi.debian@cknow.org>
> Signed-off-by: Dragan Simic <dsimic@manjaro.org>
> ---
>  drivers/char/hw_random/Kconfig | 76 +++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index e84c7f431840..283aba711af5 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -38,47 +38,47 @@ config HW_RANDOM_TIMERIOMEM
>  config HW_RANDOM_INTEL
>  	tristate "Intel HW Random Number Generator support"
>  	depends on (X86 || COMPILE_TEST) && PCI
> -	default HW_RANDOM
> +	default HW_RANDOM if !UML_RANDOM

This is disgusting.  Just remove all the defaults, and we can
add back the ones actually needed.  Just remember to set the
default to something sane like HW_RANDOM && dependencies.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
