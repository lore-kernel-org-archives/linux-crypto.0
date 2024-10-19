Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00CE18FC65
	for <linux-crypto@vger.kernel.org>; Sat, 19 Oct 2024 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729339028; cv=none; b=ethmUekEKFM4/dnZZIckyBxxv359uZA5QbiaPE2DqS330YYWnQz0hrfn9ZBF5zf96WOqLezteu1P5voMQBkAKpUDBusYgVlgfVonhX8QJxtJog47Mfyq5gNhDsToSBjIDXCafbz8X8QwbPH34wjiRojguUglNn5/MZesTn57/4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729339028; c=relaxed/simple;
	bh=6gC3dNzdjCfxPPSWvPNJE16oeV5l3Y7Is1nw1ftyipw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhNWmJ/vbTEJGJ/hAibHD3A+1PwpNGPSj7oP7OG9EFGHGapoGPSItsCeztMODBwjoUdRhptyw1i+9TY/gavLVkOh9lO54TojFZ1ugywn0l+VCSzhpspmoBT2vKiXCcH4WdAbbF4nJ9FMkaCMuFDcOx18GhpUUdlUUlVc7EZvr5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Stx9PQ5r; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Stx9PQ5r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gd4bKnGxxewATgSc97WW9IAsKDjzAdQqzXrIJ7aC7GQ=; b=Stx9PQ5rgTGHbktilVhwsTcUCu
	qDvxvP11gjmw7eJJPmFP09mj75FiKcztpeOMMjMjlLcR8TMWlzRV0FNlkYhfyeknjgu3PWPWSknjF
	1IHvfMfKB1iuDH7xqca5yI0a6rG4vp9VUNSMWEszh004pMPAuHCvoaVQTk8VTNaV6cv2XO1QklDL6
	S2+1dX9NZioYdCFXvwaQGmSIfgxbss8aT6QMkDZHUzxMLf6lQLYNZwjT0S5mb+RN/NLCasghjOFKp
	xC3voOawG3i5nBugw67UIKCjviTSDE6JpBvLZXsi6ZWEOJKHi+zsv6OjfbuSWHsRwwoJyTuswqp1T
	gk3JTQXQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t284l-00AaO3-01;
	Sat, 19 Oct 2024 19:56:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Oct 2024 19:56:55 +0800
Date: Sat, 19 Oct 2024 19:56:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - remove faulty arbiter config reset
Message-ID: <ZxOehv1-wZiGdkY-@gondor.apana.org.au>
References: <20241007134240.12278-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007134240.12278-1-ahsan.atta@intel.com>

On Mon, Oct 07, 2024 at 02:42:40PM +0100, Ahsan Atta wrote:
> Resetting the service arbiter config can cause potential issues
> related to response ordering and ring flow control check in the
> event of AER or device hang. This is because it results in changing
> the default response ring size from 32 bytes to 16 bytes. The service
> arbiter config reset also disables response ring flow control check.
> Thus, by removing this reset we can prevent the service arbiter from
> being configured inappropriately, which leads to undesired device
> behaviour in the event of errors.
> 
> Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c | 4 ----
>  1 file changed, 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
