Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73136190664
	for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2025 08:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742892524; cv=none; b=WaJUQHEqC/bXsk+Unn1NDyDXiMWMU7gZ88miTVskz5ab8KYhd9RXEoWOM36rcEtzzMqOfJEFYstmW0VCteKb0bMX/qBj5uk+MOrmijiJ7tlQMqCfkLERFtdFHs5BQbu5HHxoFcoUv+uDpQccps/8M70SuJPTES/ry4fi3VOTdQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742892524; c=relaxed/simple;
	bh=B3IgS0rkl+IyP5xjPhEr9S22j3KvT4XKLS6zxNv1iYI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dpHWyflftz80L0twEC6BjGV3EiggBTtxR07cni/XJU1OHsZq03Etsud+IOngbCLmExAz5NweyncKRNaDS4iJkmjDzp1mdXorIMSAG9nnIR7YJh5yDsWc4OjlE6AB8otWzUvoUABAR4/HsIhqZPeePv+nFydc2lKcyjE4YjaKVGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=PjP2X1yc; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="PjP2X1yc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1742892514;
	bh=B3IgS0rkl+IyP5xjPhEr9S22j3KvT4XKLS6zxNv1iYI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PjP2X1yccEPcdkohCAvdaZ3dE6/zzhS2gsPaorWktmWRV053AlthPK4n+gENBufhy
	 /0XrAn6QCJpGg/wFGOhBBJ/jU5rfX6IifYiQU/7HOm2M3kad187XDJqhBc+5HnGGiI
	 HeEMKzh4ubHcxdH123GAP43jylmWXQKu95vztkkwfTTVtwuoy+73NbPedd7NDaMTya
	 /Sx5d0y2UCK+HdxMFFrN/YB9F6qWVsxsUVEKqqPEAmVKOoR2LDj3XVdHi8v95n2urX
	 gpt7PF0FicZuBb/t4WOm+0KBqalwn7iYpUlCD30tkvY5kU+tXjUIG9lFCqid01j1jJ
	 aA3j93zGUi+UA==
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6E37417E0860;
	Tue, 25 Mar 2025 09:48:34 +0100 (CET)
Date: Tue, 25 Mar 2025 09:48:29 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>, Linux Crypto Mailing List
 <linux-crypto@vger.kernel.org>, Boris Brezillon <bbrezillon@kernel.org>,
 Srujana Challa <schalla@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: Remove Arnaud Ebalard as the address is
 bouncing
Message-ID: <20250325094829.586fb525@collabora.com>
In-Reply-To: <Z-JnegwRrihCos3z@gondor.apana.org.au>
References: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
	<20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr>
	<Z-JnegwRrihCos3z@gondor.apana.org.au>
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

Hi Herbert,

On Tue, 25 Mar 2025 16:21:14 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Mar 21, 2025 at 12:18:32PM +0000, EBALARD Arnaud wrote:
> > Hi Herbert,
> > 
> > Natisbad.org mail server is indeed in extended holidays. Your change is fine w/ me but I do not have much spare time to spend on the topic anymore so I guess the best approach would be to remove me from MAINTAINERS file entirely and let the slot to someone else.  
> 
> Hi Arnaud:
> 
> Thanks for your contributions.  I'll apply the following patch instead.

I haven't reviewed contributions or contributed myself to this driver
for while. Could you remove me as well?

Thanks,

Boris

> 
> ---8<---
> Remove the entry for Arnaud Ebalard as requested.
> 
> Link: https://lore.kernel.org/linux-crypto/20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f8fb396e6b37..faffa211ed0d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14010,7 +14010,6 @@ F:	include/uapi/drm/armada_drm.h
>  
>  MARVELL CRYPTO DRIVER
>  M:	Boris Brezillon <bbrezillon@kernel.org>
> -M:	Arnaud Ebalard <arno@natisbad.org>
>  M:	Srujana Challa <schalla@marvell.com>
>  L:	linux-crypto@vger.kernel.org
>  S:	Maintained

