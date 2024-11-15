Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FAD1BB6BC;
	Fri, 15 Nov 2024 11:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731671953; cv=none; b=kfnJWlJYfyONhQf8suvLyyT1eNZkXJSJHs3sINDMJOZ3V3b7hrNihWlBhiV+nV8KlzhB79FNQAIXxhqhXd1wqqxlkNItRh377qw9vLUuyTysyfkbkFPocVVRWrrg2HZQec24LR63cCzz9OtFJT9UhDwsDNSNwds1uOhBWXuef0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731671953; c=relaxed/simple;
	bh=V8DI4U7YeV4Q2KxF6hbncGbwRaQlMVOwiVtIOnIwcbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ky7AUSaVV/CFYI+ZU0l1ufI3/Tbujj7fqILGNqEvWhRXh1ggZCuTnwjbj6QnSsts2HI2s+dYk/e9FkJW/ZHH2lmjPrjBKiDsMFOTI+IdBhDGiSaWmnd3ZrSwmFBU2xjGtnkLapPUgEn23kKb2BersHaBLO5fBhNH9b8sGL+qdq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Ktpojc2+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Ktpojc2+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NGU5s3opX+e5iKfvFr/JVesdrrLYW5WBHbO4M/nZ16w=; b=Ktpojc2+xjy4ljKZXiA5mDlNFW
	9hWzg4YYeIMwDtAKVIS96sJHDFrDQGr6SzD6yUeTOkm6EoiKBoC8pGBcIH5Oc5uIFhXJfZklo9BPf
	d1HAANJFsKJ7Aen0CdqxM17EFwBixCD7kiEPxRcVXJr8KRyjyzmDTlVNDt14nmgIedPEbOXsfXooJ
	KL0ReMjRVDMj/E6E4xYmej5KOuliGhb8ARksPlUDbtYoHNTEu8XoRXa1X8x1zreX7Bf1la9DE5/OS
	K+I8y96S6aw8HmXZgVEhdX7umTO6Ouut+yc0IcVN0I3OEYRTC/ifbGAIk9fBysDjhf/B/08QHWD86
	VNwhss8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBuyT-00H20Q-1u;
	Fri, 15 Nov 2024 19:58:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 19:58:53 +0800
Date: Fri, 15 Nov 2024 19:58:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michal Suchanek <msuchanek@suse.de>
Cc: linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.com>
Subject: Re: [PATCH] aes-gcm-p10: Use the correct bit to test for P10
Message-ID: <Zzc3fcx3AZd6ZF-c@gondor.apana.org.au>
References: <20240923133040.4630-3-dtsen@linux.ibm.com>
 <20241106121019.25629-1-msuchanek@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106121019.25629-1-msuchanek@suse.de>

On Wed, Nov 06, 2024 at 01:09:33PM +0100, Michal Suchanek wrote:
> A hwcap feature bit is passed to cpu_has_feature, resulting in testing
> for CPU_FTR_MMCRA instead of the 3.1 platform revision.
> 
> Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")
> Reported-by: Nicolai Stange <nstange@suse.com>
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
