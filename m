Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7421F153C;
	Mon, 19 May 2025 07:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747640138; cv=none; b=KbQhTEcX5lPoxiIhnmWPVm4r2W0nMwMPmKKiJ8DjiksjDMoS8DDhd+ERuop+V3d416CBGX5z/bt7+8z7BNd8aK8xCjl4ayT/PZTZ2Zer9ZMzzA6TGQW3zjeoGJCf5TFHBSe4Mq2bqgrdpiaG0bWm4Amnw4A2vkTSIh8YeFB88JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747640138; c=relaxed/simple;
	bh=6If4HKadik14y4FMOvM7Hz4Sd1sJW57+mGPWth8yfZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IrYFPvhc87ymbYRDDQrHhcFurPYt3FUmKpz26EsVPwiMNXLX8xVoEW0Xq2Af4L+xspk0FnQKrCQ6SMJkcs96Wz9eUvkOOSw3uTgW5GLAmxZ3RTbwEMGIBVef8FtTds9WD8kMwJjZA/9ML+7h6tsaLri//GmlhYkg++05GIp//xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=p3JOZ6y/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="p3JOZ6y/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZqonEbPyZPcZMnIEL863NwhNXSfWup+dRCeEeDxM6b4=; b=p3JOZ6y/iDvNqgR+tvd+onIZ9t
	pmGzo5DhX+mfQoqfGSfQanyJ/b0CGGr+ryLdCRWvwrQwejTSvkiVSAV5bZ9Q4GfrlDrKN9i0DkK83
	28olGHlrDiZGtsyh2rCEv/6fYCnJ2vQt212eJcia5vAWdhc1+6iVZJtmxjaU4uk4gziTgZRz2+1m9
	tQm8ePSaPEGmub/vKYbBz059SO3If7OHSjjwdI4Gh7AfxgZ7oD0/BMhHC2PjCIVdqZtDikKfaQZGI
	Nxf8PIQrr9d1i0QZq+yKiaWfE4GMjS36mlUrJKkgmagJenN/vhSEj4MQgjvGYat/1sFu1cXyN/JWh
	LsK8mEVQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGv1p-0079QQ-0F;
	Mon, 19 May 2025 15:35:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 15:35:17 +0800
Date: Mon, 19 May 2025 15:35:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bharatb.linux@gmail.com>
Cc: Bharat Bhushan <bbhushan2@marvell.com>, bbrezillon@kernel.org,
	arno@natisbad.org, schalla@marvell.com, davem@davemloft.net,
	giovanni.cabiddu@intel.com, linux@treblig.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/4 RESEND] crypto: octeontx2: Fix address alignment on
 CN10K A0/A1 and OcteonTX2
Message-ID: <aCrfNdnRzlQSr6sy@gondor.apana.org.au>
References: <20250514051043.3178659-1-bbhushan2@marvell.com>
 <20250514051043.3178659-4-bbhushan2@marvell.com>
 <aCqzAQH06FAoYpYO@gondor.apana.org.au>
 <CAAeCc_=QShbySa8x9zU+QnDqn1SLK3JLXMD8RYNoax+gh3NVEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeCc_=QShbySa8x9zU+QnDqn1SLK3JLXMD8RYNoax+gh3NVEQ@mail.gmail.com>

On Mon, May 19, 2025 at 11:47:18AM +0530, Bharat Bhushan wrote:
>
> > > +     /* Allocate extra memory for SG and response address alignment */
> > > +     total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) + dlen;
> 
> This add extra memory for 8-byte (OTX2_CPT_DPTR_RPTR_ALIGN) alignment
> 
> > > +     total_mem_len = ALIGN(total_mem_len, OTX2_CPT_RES_ADDR_ALIGN) +
> > > +                      sizeof(union otx2_cpt_res_s);
> 
> This add extra memory for 32-byte (OTX2_CPT_RES_ADDR_ALIGN))
> In case not observed,  OTX2_CPT_RES_ADDR_ALIGN is not the same as
> OTX2_CPT_DPTR_RPTR_ALIGN.

But it doesn't do that.  Look, assume that total_mem_len is 64,
then ALIGN(64, 32) will still be 64.  You're not adding any extra
space for the alignment padding.

OTOH, kmalloc can return something that has a page offset of 8,
and you will need 24 extra bytes in your structure to make it
align at 32.

Now of course if you're very lucky, and total_mem_len starts out
at 8, then it would work but that's purely by chance.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
