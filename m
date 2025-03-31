Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF3B86338
	for <linux-crypto@vger.kernel.org>; Mon, 31 Mar 2025 10:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743415344; cv=none; b=BDq3rqmHpjHRdLU4EOWBk1HD8O5A0uhah6s9KTjl2SJJEjbKdF1z/tKvQ9EDZR1lxwkKCFnhfiUWkFwBEQuWRxwEjBXncCTRlKmZwbuvUGCtYAUaFGuLRhF+XmRhcA9R7DWZDnwYC8Ot34aFQV1+QqIWtHcdggjnkSh9o6wFnsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743415344; c=relaxed/simple;
	bh=DBuOXv5lnH0/JT1OzyoZmwKYGWScqSBPV4CQbsmVxDM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+zeGM7VnrE1bF0mKConetVpZgbiXZN37AUUABj9JX49xC7YI9F9jhUA3SCMsF2aiGgbXSqgM7ulSKkcbCAPqLFqJ/qHWXkajrxZv+48+qhMJ/e5wsdKPK8ZaxAdeMD97b4lKtwFkHD2U2Oj7f+vDJcJsS7b/HYUW8LvcC76ovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=JQtPHEkA; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="JQtPHEkA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1743415340;
	bh=DBuOXv5lnH0/JT1OzyoZmwKYGWScqSBPV4CQbsmVxDM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JQtPHEkAVq8HHcH3AhLIEJ2wHYd6dssTVwegDGUMiq9U+nLe/2gG23voxHWPPXPfn
	 O5MCj1ilevsj7ZeSlEHitzoGaoeE4dhMQ1LwmNx12HZpKlBOcOtCztfrgZbRanw5nd
	 o/AU+iQXbDfl0c/QZE02vSjVXi1P5Q+89x5kb6Tko3zllsfmqERSTgRKbpla3dC2ei
	 S/wu3miJDkVSd6bRV8JYqyXnz1vZaAYsjarhftEla68hsMFYyTXD2Ey8HDmRJxTWrI
	 uIN3FrrppqgdaAyUdCdYYjkL5JBZ+MnrPN9iMDo64kmA94rCy467HIpTc+iMKFjSfH
	 L0V3nQu3fl6Hg==
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B95A017E0808;
	Mon, 31 Mar 2025 12:02:19 +0200 (CEST)
Date: Mon, 31 Mar 2025 12:02:14 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>, Linux Crypto Mailing List
 <linux-crypto@vger.kernel.org>, Boris Brezillon <bbrezillon@kernel.org>,
 Srujana Challa <schalla@marvell.com>
Subject: Re: [v2 PATCH] MAINTAINERS: Update maintainers for crypto/marvell
Message-ID: <20250331120214.0fc41ed6@collabora.com>
In-Reply-To: <Z-ie8LWRsoGb4qIP@gondor.apana.org.au>
References: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
	<20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr>
	<Z-JnegwRrihCos3z@gondor.apana.org.au>
	<20250325094829.586fb525@collabora.com>
	<Z-ie8LWRsoGb4qIP@gondor.apana.org.au>
Organization: Collabora
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 30 Mar 2025 09:31:28 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, Mar 25, 2025 at 09:48:29AM +0100, Boris Brezillon wrote:
> >
> > I haven't reviewed contributions or contributed myself to this driver
> > for while. Could you remove me as well?  
> 
> Thanks for your contributions Boris.  I'll add you to the patch
> as well:
> 
> ---8<---
> Remove the entries for Arnaud Ebalard and Boris Brezillon as
> requested.
> 
> Link: https://lore.kernel.org/linux-crypto/20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Boris Brezillon <boris.brezillon@collabora.com>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f8fb396e6b37..8eda257ffdc9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14009,8 +14009,6 @@ F:	drivers/gpu/drm/armada/
>  F:	include/uapi/drm/armada_drm.h
>  
>  MARVELL CRYPTO DRIVER
> -M:	Boris Brezillon <bbrezillon@kernel.org>
> -M:	Arnaud Ebalard <arno@natisbad.org>
>  M:	Srujana Challa <schalla@marvell.com>
>  L:	linux-crypto@vger.kernel.org
>  S:	Maintained

