Received: from abb.hmeau.com (unknown [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7463629D05
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 02:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745549281; cv=none; b=YOitDjZN4wQC4YPgVi1/TM6AMFeMGWxxCbvZC4GYd9Y9A2h5eqFzM+dVXnU01z9/nRpECf+GDLw24b+kamuWUlUX9HdB/bGdVfuIRbkposYbv6zNnwhmJWRLU+UakAK+xHxsPNK2VHjWX7d/W6Xzn3+AxwZHylodVc7s8AqQzYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745549281; c=relaxed/simple;
	bh=8sgm7b2DI/nEL3vDB1eO3XYNNqd/Os/Yuq8tN2+f8Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyWsC/1RO2DtU7FdGfgRkfKtKRQxj+QJRuLGBG68rG41WYNsXmAqSINVYXDTfWb7grNroZJxBn6HXrUUpzjc+Pe0vk+US6V0algyw0p2qhGl6HBWQCugQBSuK9QZhoPaE3imvKu9/vVmAidn8mPVqhuL4U41C50fCv8PT1wUEmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cSMwvf75; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cSMwvf75"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2uMXlPNzswaW6bZmF7iSGCilKP+pH26yYpW+Gh09iB8=; b=cSMwvf75/qft9tQhauEp5WlNsH
	MSaUVtF1fFNdQoLkF0XTbO3dyKl+XdVzjBoNjusn8aPxP75qr7AdMeBnCk+2DwMCl85lklR5+6r7X
	PDQGl3Bzv4GncIM/HwaxW7HUwBCrVFaJP0uqbXjqtDc6up0o4H4ORGxdrq1OMmaH4uUJGDX1Qm6VD
	lGSn7fyobMGQGhq5t5jsAH4mgu++eghbSxFPLRuPI0nutjTVL9FfrdCp3ZTfgOdwYcJxvNA79rIuI
	NCb4Jg8yjwPGLdkpn12dzrfhAAMwYHoLjLT09/ShTc549CWdasWrxgx0c7sEzXPeEqT8aXyri2wN+
	6nZPR7HA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u896P-000raM-03;
	Fri, 25 Apr 2025 10:47:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 10:47:45 +0800
Date: Fri, 25 Apr 2025 10:47:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: scompress - increment scomp_scratch_users when
 already allocated
Message-ID: <aAr30VG-taNT0eeV@gondor.apana.org.au>
References: <71f7715ffb4a29837335779c92ba842a4b862dda.1745507687.git.sd@queasysnail.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71f7715ffb4a29837335779c92ba842a4b862dda.1745507687.git.sd@queasysnail.net>

On Thu, Apr 24, 2025 at 10:15:50PM +0200, Sabrina Dubroca wrote:
> Commit ddd0a42671c0 only increments scomp_scratch_users when it was 0,
> causing a panic when using ipcomp:
> 
>     Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
>     KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>     CPU: 1 UID: 0 PID: 619 Comm: ping Tainted: G                 N  6.15.0-rc3-net-00032-ga79be02bba5c #41 PREEMPT(full)
>     Tainted: [N]=TEST
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
>     RIP: 0010:inflate_fast+0x5a2/0x1b90
>     [...]
>     Call Trace:
>      <IRQ>
>      zlib_inflate+0x2d60/0x6620
>      deflate_sdecompress+0x166/0x350
>      scomp_acomp_comp_decomp+0x45f/0xa10
>      scomp_acomp_decompress+0x21/0x120
>      acomp_do_req_chain+0x3e5/0x4e0
>      ipcomp_input+0x212/0x550
>      xfrm_input+0x2de2/0x72f0
>     [...]
>     Kernel panic - not syncing: Fatal exception in interrupt
>     Kernel Offset: disabled
>     ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
> 
> Instead, let's keep the old increment, and decrement back to 0 if the
> scratch allocation fails.
> 
> Fixes: ddd0a42671c0 ("crypto: scompress - Fix scratch allocation failure handling")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  crypto/scompress.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
