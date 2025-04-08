Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9BF263C7D;
	Tue,  8 Apr 2025 08:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744099895; cv=none; b=E9gdUMdZC+pWv7vHVvSteIW56rYYA/EXFDO6zEFVIJcKyHCK5sjOIrxxKDKTJUCwaBVopkezFfgZvK2mC4hh33wpnsD7hp8yAXf5BaRWpj7IV1BIviM9TtL83LvziRcFGJg76d4+2FGZRFNEorMBckasExxYW/sWBiHkpE1GbHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744099895; c=relaxed/simple;
	bh=Eai45pg+sFAqPWgfVpeDnsOdZDsijq3rROuqaPIFgK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fm3+NHLmQo+grxItC2UgfsaoJyHEAi3DvTDcgcPeZw+JzwyjQIQmzPQLpp8LUoD1uI3ALcar//eH1dsedPjmGzuuduu7wN1lXFGdWYixCa620+qJso/DabOBYqglgBINXuSFxc2sOMjnEjxyXwv0/sCejD+oCKkdj/Z0MUyqSZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LQjnvWYu; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LQjnvWYu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nj/7fcsf30Nl8qf2AjASDTaU9/a5G4x2NM42ScBp3WU=; b=LQjnvWYu3WOigFeuvNGsLhVyeA
	LSBftwv1jH5BbNLCieyXiqFYEX3BE8h4ymP8FdQ1TXE8KEoTgCBKOBsMdINAIf7mZ9sFBGSyVHx97
	bj8nOzMPWgRRGd/CEPxvEqyub6YJeRhc866hMUlCIlha1QDfz1R5r0hK9gTNH0tpb7QC8DvPhYgcs
	GxG81Vp9C61eONYw7rE6F937r9GgLov71RcD4mQZJ9k86q/hlquMkMBDlY6Msh5dS3ld/zSKDr5IZ
	zlnZizKi8GCOrR4jWnVOPPQV7OftOMeUJ+Zvd4iEoRHbnCFZu00+lNexG2ZP7p4Tk/PomzZcIgu+i
	dEl7TZwA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u243C-00Donk-01;
	Tue, 08 Apr 2025 16:11:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Apr 2025 16:11:18 +0800
Date: Tue, 8 Apr 2025 16:11:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] crypto: sun8i-ce-hash - fix error handling in
 sun8i_ce_hash_run()
Message-ID: <Z_TaJWOFdAGNAOyh@gondor.apana.org.au>
References: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>

On Tue, Apr 01, 2025 at 10:23:16PM +0300, Ovidiu Panait wrote:
> Rework error handling in sun8i_ce_hash_run() to unmap the dma buffers in
> case of failure. Currently, the dma unmap functions are not called if the
> function errors out at various points.
> 
> Fixes: 56f6d5aee88d1 ("crypto: sun8i-ce - support hash algorithms")
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 34 ++++++++++++-------
>  1 file changed, 21 insertions(+), 13 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
