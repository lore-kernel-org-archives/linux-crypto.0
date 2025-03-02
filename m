Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2881F42065;
	Sun,  2 Mar 2025 08:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740903336; cv=none; b=L5/zfyrDDxyhhSd1vRNnrfBmw0YxJGezVy3tlwyT981eMq92Q4BsjnYturjCc1oSgyRbOWwzJAPy6XdfR8GCiG/TJCde0QGDRkDIX12FmRvIafkUbo6Na0xs1St5J4s95TexECiT3Dv6EmV9TlV+8uvRyx9/XJoQCWAzIl7XJ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740903336; c=relaxed/simple;
	bh=8Dmy4WcWmRBmtKikMqLJ1gtz+xmgnl3vdZ3Pt/8NNZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDbdq6xulyL84M5hzni/WI0iGgPDlJOe1TAfOgnnQ0JrzWTwzOXINY/E3FBYw1guz6GCuVXej1dbK7LZFwEd8POiii1RzrK8p/Mys5wf6UjLdEerSCxLT3alLteHuCa6jzWdsFCKfEd6JugXxFhfiuWMQw4HtXw2mqfCydAnBBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Q5HR9FW3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Q5HR9FW3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=veZi3CPGPWb5oo1eVnp6/yA1z5AZ3kH+/Cz4zb+Qr98=; b=Q5HR9FW30vySK+u7++XJKmBUnb
	chChRdlThgkQySuU07EQwpgNoyHJqoQHWURJJZP2fj7UdKSuODGdoHPD4bQXDmTzThwXiuFUfWRz1
	R+aL0Qs8GZZbLHGgJDIHkLCtwSB/RvNYaoj+E4peo9Hk8XcgPYbu78Otfph9rYteQ2YYE76u5fAOj
	3PyNPXT3R5Y5wa1AOkacOGAg2ynhEXywAna2AqrrKmwohXj1S2ApFfvn2Yf1WIEmpSw6W6qrxCZ35
	eczn2veDtB2IJmD6Ttb5D+ryfiM+/jSkPOOoseJsEmRCLZnlGiqEX9WjcrsEtqfURxOsaOPUho6rU
	7T38yTtA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toeTp-0030uR-1i;
	Sun, 02 Mar 2025 16:15:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 16:15:21 +0800
Date: Sun, 2 Mar 2025 16:15:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx - Remove unused function
 otx_cpt_eng_grp_has_eng_type
Message-ID: <Z8QTmasKpfhWx8y5@gondor.apana.org.au>
References: <20250223005646.86675-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250223005646.86675-1-linux@treblig.org>

On Sun, Feb 23, 2025 at 12:56:46AM +0000, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> otx_cpt_eng_grp_has_eng_type() was added in 2020 by
> commit d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT
> engine")
> but has remained unused.
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c | 11 -----------
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h |  2 --
>  2 files changed, 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
