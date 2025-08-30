Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8D722069E;
	Sat, 30 Aug 2025 08:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543965; cv=none; b=IcCIDgcJdLHKw9HIDEvxbO2xBTVmn86UMKJAquxZQLa6ksEwSCXjXfJIKiGVoxyWPrmjk0/nEOa+0RALJEUatp273pdNccJh526z33tlyiEG43TuGhX/6yajukDEotqcLyRfV+U2eLm+zsY7hZuN6CyyaGwcEtVkEtX55kR/l30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543965; c=relaxed/simple;
	bh=rd/o4/OyD/ySAPFW4eUGtHJTW2JgGPNByUsxuSjjnz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enIEWJeoCZij73x5UC1KlY+yEAAcFTSCFVFMntHabJA7m7LaGe1SlQGExzN7ejKoFJ3yGyot44qv9gzA3/HdzaxFkWCxTxcfNKX6CUarPf/EOt29QMo5eZWezsKs2CVXRcZb9dITBCHvY6i8NO+vxUpSiJgWGMLSiq3qqNBs6BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=otM6fVJu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="otM6fVJu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ajAWVKs9NbJNbqqlIPXVheqqrPUbKsxDEiFluZnyDN4=; b=otM6fVJuOv6s4MJp41SSFkdwYN
	hvC6ndW56AYqEq3avp52tWvPvomL0rbXpvQAcRMV+LP8El8pFFRyjp2oQoDzJIAnzN2AyUXILCWsb
	N4/A4GOUwM5+3r3vQzkpTlCJoQcsM1tXLtZuA+CfH36D/hO6ZXLa14jF+/Q0owM8kmJLlJUZtY4UF
	4feFQNeOp4DNVJwX/jEuwi5cW8GmEitN5wXIOO2pYTAGZaSA25v9YvJOs5qcyD64xOxxxuwlAJ06a
	4FATW5IWAtXKX289hCbDzO3lEV95zG1Ocn3Pt7xAVpuMFEzLoTNaHZIZox2Yz1w5qadSL9cdCbSUf
	05hiIzgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH4g-0017Cu-29;
	Sat, 30 Aug 2025 16:52:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:52:35 +0800
Date: Sat, 30 Aug 2025 16:52:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	"open list:TEGRA ARCHITECTURE SUPPORT" <linux-tegra@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: tegra - Remove the use of dev_err_probe()
Message-ID: <aLK708AFrXsYtOSP@gondor.apana.org.au>
References: <20250820123752.473172-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820123752.473172-1-liaoyuanhong@vivo.com>

On Wed, Aug 20, 2025 at 08:37:52PM +0800, Liao Yuanhong wrote:
> Logging messages that show some type of "out of memory" error are generally
> unnecessary as there is a generic message and a stack dump done by the
> memory subsystem. These messages generally increase kernel size without
> much added value[1].
> 
> The dev_err_probe() doesn't do anything when error is '-ENOMEM'. Therefore,
> remove the useless call to dev_err_probe(), and just return the value
> instead.
> 
> [1]: https://lore.kernel.org/lkml/1402419340.30479.18.camel@joe-AO725/
> 
> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
> ---
>  drivers/crypto/tegra/tegra-se-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
