Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4728C2EF66E;
	Fri, 22 Aug 2025 09:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755855313; cv=none; b=svepd0RpP1CHl1Gf1R3Mdintmq5Ml9FoUZE707dSnzH0TmfKKti1528Wrs3K4rVJS47PPoaS/ECMdqA5RDi3+L7yj2PJehPF3E9N5Di7l9WLJkfxOl9nOuaytb6PkZC08m4C/I15iIunaUu3LFiSfR7E5D1u41pVrz090ZAcFEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755855313; c=relaxed/simple;
	bh=RetHWpHzdyJrbH0VaqJ7g4KCeXmhBmODzzfNQoEPsq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFR8HcJntU7uOwzqwu2r1rTpmH6o2PPsHmZBN0UT5k8Rzqw7mgRPx2JQdkymgTHSDWdhpKWQiT2UJr0UBRp0M8grOlWEUc70iXWVH3i3wS1FcqqP6Y7W7izAAXIyNtYSCdRgwPMa6lUTDkXeehzHiA+o2bYk7v3oNRg4IWvpRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=B6Y1lL7B; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="B6Y1lL7B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dRAKVgV0aD3WIHPD7DNqvOHJihK3blNmqaNd+LQj1T0=; b=B6Y1lL7BCafTap5K80QTZxiU+I
	eFcEbVHJHwe0aIATiuIfyDwPavNCO2skKYmTthOLXfL1IOpJkLlQF4BN9B1plDzOSr3X4cat5l3sI
	cRitdBDTQk6SdNT3YVA1U20jLNU+c6s12DTFzTVojesOtFCELvqsI3Vj+iJv/JRbS+iDo1uQs8kj1
	FO7gTioska1QCbBDhjnsriEZs4HMkirVkSPk4tTrY/KibwACiGXARds7fnffchpyUiHGORjtg5s40
	18kDinsf/OCxtlLtkfAQTovJsSfWijfTQGFJsyfmeVOpwimNtGi2+4Ra98+eIVgFBPC2YX2nrsNiX
	oBWv5a2g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1upNvM-00GN7g-2x;
	Fri, 22 Aug 2025 17:35:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Aug 2025 17:35:01 +0800
Date: Fri, 22 Aug 2025 17:35:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xiao Liang <shaw.leon@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] padata: Reset next CPU when reorder sequence wraps
 around
Message-ID: <aKg5xX_TTh0d2pXq@gondor.apana.org.au>
References: <20250816163017.75098-1-shaw.leon@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816163017.75098-1-shaw.leon@gmail.com>

On Sun, Aug 17, 2025 at 12:30:15AM +0800, Xiao Liang wrote:
> When seq_nr wraps around, the next reorder job with seq 0 is hashed to
> the first CPU in padata_do_serial(). Correspondingly, need reset pd->cpu
> to the first one when pd->processed wraps around. Otherwise, if the
> number of used CPUs is not a power of 2, padata_find_next() will be
> checking a wrong list, hence deadlock.
> 
> Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> ---
>  kernel/padata.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
