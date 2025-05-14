Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A79025D532;
	Wed, 14 May 2025 09:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747216222; cv=none; b=awx8ZqvDkut5NRXP5eKMaHwrUETsUdzc1jEqwVd4YEfQ3OCMQsyke5J0938dnghCGf77vxii8mWZFGBj8vIjyOTpCq2rf6zfryGQblSL0/8He43XGdUYd6+xS4UcKmRekWPFbebNPfJYJd3SyZ01MLDzfpMxu3ETPRUOp85Pgvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747216222; c=relaxed/simple;
	bh=QwqOklaBfFJutW99xC+wN/w4YccIgFRU3Dw+1/TYFP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUN0ReRMCHV78gT/MciLn8HBPkmvfrFdmyvnMgbVLNrIxW4S4vWtlGbyCI3rg6j7+8kTr2me2Vzqoqz38C9yTsDPiYq3UPWK9uIWR5WgMNP/f/m8QlKs9iGXHJgYCAxIkA8hMNDc9LmL3dUarhwafc0/f1naSfg/UfhEmHxxZY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sqs1Fuy5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sqs1Fuy5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jtcA7X16BmiR/IJddjcp1JXHzW6I5BCr86J0rmb29Lc=; b=sqs1Fuy5mdu/oDqsqtz2rwDpXI
	IsrNysRXdc2SmzCIKtwhSdIDbGA11SE6acVI6nuDmsCWUmRh6dl0GRjbrLXSshsg4Kf4Or5bb7Azu
	uqL4+QeFQM8FH1tGGt/jyw/cHBukd02pae4/Ticyj2iZnAYXKLOyN0f6NOjkuzMSavMm4jmOvl6Rr
	oX8fF3AaQzhBYOEfNObwGCT+tbXg9uW0DiGIM4shYDLp8Ul9agCS457vuRzcsXo9us53uTA+UyBaa
	vXwYBKyccdAvYNi9vMsSy7q0srIDKvpZdGZUzQgvcAnO8EjCTFB8+rFpTHsUbW1f6QbXBw06cuXam
	K9ysFj5A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8kb-0060nU-1e;
	Wed, 14 May 2025 17:50:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:50:09 +0800
Date: Wed, 14 May 2025 17:50:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	George Abraham P <george.abraham.p@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] crypto: qat/qat_6xxx - Fix NULL vs IS_ERR() check
 in adf_probe()
Message-ID: <aCRnUY1XfQPCpf_6@gondor.apana.org.au>
References: <aBxOkY99jQF7q-7M@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBxOkY99jQF7q-7M@stanley.mountain>

On Thu, May 08, 2025 at 09:26:25AM +0300, Dan Carpenter wrote:
> The pcim_iomap_region() returns error pointers.  It doesn't return NULL
> pointers.  Update the check to match.
> 
> Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/crypto/intel/qat/qat_6xxx/adf_drv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
