Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DE81E104E
	for <linux-crypto@vger.kernel.org>; Mon, 26 May 2025 08:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748247246; cv=none; b=CknxXjow8a8mQMKyUR71QEGU5emP8HMEFG8ioz2P8dgW4YEsYckGTXCBwtUal57bStP2WXwVTOSnK3x6N1IcYqOlOmwTCQbMg5Aas+gY/3qNQtl3kAwgaT5JO48yZtr3h6M/8R9gLtkuwI8AL7hoo4ms0JjjTX5X834zI3xWwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748247246; c=relaxed/simple;
	bh=js4Sy9zq4tRU11FrAQDnBu5awGBaBlqeONKbYFEyreM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYz0hjy6DqGN5wx8bemmS8H20HQC89mymDxfpbVbOp7/eWWFfydl5G+d9d8mAXp9GMUEkLdjcIEJHmobG88SLJNgtjcLWewD0p5aLvU+5DM8cIR4Oe+cgYoUJ0D7x+aWSmzWLGlQL/OtEl/0fgh0ojK7SAkI9dH0cALkkp1KO5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iT5i3Pz6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iT5i3Pz6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bVwTpKiwOBZfDh/RQHfIm8YPV0DhFfGzhD2o/EXWF+U=; b=iT5i3Pz6xaPNRBiwRUKUV0a9gm
	m2a+/rYfDGR3SQT2vf2R1b0baPLFqkfQkmHkgAe7xfpknSRmZfLNKR6427V2VrCCNtq2erh2fisiW
	/xERNQdkFEeyuaPeiYtlKdyZJg6ROWIw3x0M+SAKUM+mR4/v4n61tXYwRHPepO2vG2nEZ8Ha9xlRS
	55p6sap56WTtrf/rOV8wxdWXIa5yI1Td4Q+XZbNWrlTRGZg0AzfX1icIHz7F82CCvBQdwZYAmjrtP
	QWqSP6VpxGzYnvx5J5m3YoYUPblebTa1I4R/ECuwRIaoJ3T1CfmVoX1sTWOc/97rudgp6pmrmNw+h
	8DcE+h4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uJSy3-008zWS-0K;
	Mon, 26 May 2025 16:13:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 May 2025 16:13:55 +0800
Date: Mon, 26 May 2025 16:13:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: api - Redo lookup on EEXIST
Message-ID: <aDQiw-UFrHnDZvTr@gondor.apana.org.au>
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
 <aCsIEqVwrhj4UnTq@gondor.apana.org.au>
 <d862f12f-8777-445e-a2d2-36484bd0e199@linux.ibm.com>
 <9d81a919-6122-4d82-b2c4-bd6d6559ed1e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d81a919-6122-4d82-b2c4-bd6d6559ed1e@linux.ibm.com>

On Mon, May 26, 2025 at 08:44:33AM +0200, Ingo Franzki wrote:
>
> It has now run several days in our CI with this patch on top of Next without showing the error again, so I would claim that your patch fixes the problem.
> Can you please include it into the next kernel? 

Great! The patch is already in my pull request for 6.16.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
