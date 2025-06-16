Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DC428EA65;
	Mon, 16 Jun 2025 02:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750042039; cv=none; b=s289j30/nJ07ZnDJLLuzeyxJtzFtUqrTR2OwNO+tBAee2ZaH7te/zWIEvmoCjwsadZjQhNA5CXmAiFKBRY9TJIDHhXAnoo/zyWe3gEXGp6MHD9KqC9JVCIBpBmHIeMQRsqcwh2nfGgaXOLXro3sET7nNkqLmlSepdo4KBapS/7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750042039; c=relaxed/simple;
	bh=FlwQxJuGAOcmvn4PXXGQ+USfVSwSjgXAPWXer3igmeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8sGBpVdfTq5TuyOH1wLPzCOpVh6I2e5OqgbtdhYLYpmcmx8K6FY5vttg8UYmHOriX6Do0E73/8a1ccO6YMi7DZJ2aQqmKZhwGktEMfOBKJg/AncmDnO4UxtpUA/7rjcPSYhPVFe4dtaspdKkVKQVeFdOO8k6o0yVrJ8tKmMSyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gVuxHSAd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gVuxHSAd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YEtckLm6ZfdKefMAFsRJm10nDoOLNy7qpOL8icEW1ns=; b=gVuxHSAdhpWrGQVNeZ3UWOg1L3
	E6usWBR3XW9Atf19k3GlkHqJCsReefNrZJvvmYJiVOKjHP2kWGd7C58qkMX/6CDt9YRgz5diTev9K
	Oor10CZwvwF69EvtcICFu87zfWMb8c13ajgN+8Tku2C8UTkYtga6vWwuS1GQuf/27gDw147Iqps22
	KkZytWHXgyQTgM17vIrrEEKkRuU0qD+ytC9hoErN6ATooaEN6eC9VagI4+a/QU9lUUJNwD7gURXHM
	4yoWJrGkqqL8iXtxrtROus//vU7gc4BzDMx/Uxcxq7iZQCAk57TVRFKype1jElwGM795BSAeuLkdm
	aGFGE1xw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQzd0-000IXB-2T;
	Mon, 16 Jun 2025 10:46:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jun 2025 10:46:58 +0800
Date: Mon, 16 Jun 2025 10:46:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	dan.carpenter@linaro.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Fix dereferencing uninitialized error
 pointer
Message-ID: <aE-ForLUfyrXeOhg@gondor.apana.org.au>
References: <20250528202018.78192-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250528202018.78192-1-Ashish.Kalra@amd.com>

On Wed, May 28, 2025 at 08:20:18PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Fix below smatch warnings:
> drivers/crypto/ccp/sev-dev.c:1312 __sev_platform_init_locked()
> error: we previously assumed 'error' could be null
> 
> Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202505071746.eWOx5QgC-lkp@intel.com/
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
