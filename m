Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E1B2FAC05
	for <linux-crypto@vger.kernel.org>; Tue, 30 Sep 2025 13:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759239146; cv=none; b=oOK1eSm0A5OvdWFg3IOiqDhbmxJg1hS3raLdxIlYZPRfSEOWOI9WpPl7v9jmtvQ5hlCRwI3ODF1nkAgmp1W9AcAZEJhZdo7RYWexhGsrOApiUCs9xMliomTp2tQLheQM+tom05RZPemzz214JI56Zd0lgeYBbba/2ZDb/vx7awM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759239146; c=relaxed/simple;
	bh=hjiUvhTEcdI+Yx6XNweoKsC0rD2vJbqkmRgwKnlMcNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hA4ynjoNVwEnBqkpDeguuEA1H4tVYtBiaMLElkx8vHzMmDKwRZHVeuBcTkr65ghOfmtfavRyYBGGMyVpFgx30sECnf5+gRC4a8DfxrkbjPc8jy9EdCwYNz6xzUCePhrnqO5PgQL6g1CU3tfabPD7yE9gwN3caeK7fhqskKjSmVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nuFUKD1C; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ACxfrnUx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nuFUKD1C; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ACxfrnUx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nuFUKD1C";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ACxfrnUx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nuFUKD1C";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ACxfrnUx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A1C101F83B;
	Tue, 30 Sep 2025 13:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759239141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Getj9FPGP+Bzf+xHlVzE0JepEsiLzYSmV09bhXiYYc=;
	b=nuFUKD1CYq3mTKKtqgyBgPKg0MVwK/5bUyIcBe57nupAzoexJH80GY286eDGMtYXtkzZLh
	Zrfm9m0yoEOwhBaIJHHY5Ci6bEXXuwxx/Q83UIFXFtIHb8TeFrCk3+HKsFQSLlUl+mmjfP
	BYAAT2/3dXr1IB05GIVdYatN3yexyMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759239141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Getj9FPGP+Bzf+xHlVzE0JepEsiLzYSmV09bhXiYYc=;
	b=ACxfrnUxl0GN76Oc7ofUgkni/+dUC7XTFaNWYMXz+O+5ULF5MNqfsxB8irEf4jE32o1Wv0
	xGs/b/4YTZgZnlCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759239141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Getj9FPGP+Bzf+xHlVzE0JepEsiLzYSmV09bhXiYYc=;
	b=nuFUKD1CYq3mTKKtqgyBgPKg0MVwK/5bUyIcBe57nupAzoexJH80GY286eDGMtYXtkzZLh
	Zrfm9m0yoEOwhBaIJHHY5Ci6bEXXuwxx/Q83UIFXFtIHb8TeFrCk3+HKsFQSLlUl+mmjfP
	BYAAT2/3dXr1IB05GIVdYatN3yexyMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759239141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Getj9FPGP+Bzf+xHlVzE0JepEsiLzYSmV09bhXiYYc=;
	b=ACxfrnUxl0GN76Oc7ofUgkni/+dUC7XTFaNWYMXz+O+5ULF5MNqfsxB8irEf4jE32o1Wv0
	xGs/b/4YTZgZnlCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 805961342D;
	Tue, 30 Sep 2025 13:32:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id me4xH+Xb22hRRQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Sep 2025 13:32:21 +0000
Date: Tue, 30 Sep 2025 15:32:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Han Xu <han.xu@nxp.com>,
	"suman.kumar.chakraborty@intel.com" <suman.kumar.chakraborty@intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"terrelln@fb.com" <terrelln@fb.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	Richard Weinberger <richard@nod.at>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:MEMORY TECHNOLOGY DEVICES (MTD)" <linux-mtd@lists.infradead.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [PATCH] crypto: zstd - Fix compression bug caused by truncation
Message-ID: <20250930133220.GB4052@suse.cz>
Reply-To: dsterba@suse.cz
References: <GV1PR04MB9071B5AC95DBD48B67FACF44971BA@GV1PR04MB9071.eurprd04.prod.outlook.com>
 <aNuQAr79Hdky3WII@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNuQAr79Hdky3WII@gondor.apana.org.au>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00

On Tue, Sep 30, 2025 at 04:08:34PM +0800, Herbert Xu wrote:
> On Mon, Sep 29, 2025 at 11:51:36PM +0000, Han Xu wrote:
> > Hi Suman,
> > 
> > The patch f5ad93ffb5411 "crypto: zstd - convert to acomp"
> > leads to the following kernel dump during UBIFS write back.
> 
> Thanks for the detailed report and instructions!
> 
> Please let me know if you still get the crash with this patch:
> 
> ---8<---
> Use size_t for the return value of zstd_compress_cctx as otherwise
> negative errors will be truncated to a positive value.
> 
> Reported-by: Han Xu <han.xu@nxp.com>
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: David Sterba <dsterba@suse.com>

> 
> diff --git a/crypto/zstd.c b/crypto/zstd.c
> index c2a19cb0879d..ac318d333b68 100644
> --- a/crypto/zstd.c
> +++ b/crypto/zstd.c
> @@ -83,7 +83,7 @@ static void zstd_exit(struct crypto_acomp *acomp_tfm)
>  static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
>  			     const void *src, void *dst, unsigned int *dlen)
>  {
> -	unsigned int out_len;
> +	size_t out_len;
>  
>  	ctx->cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
>  	if (!ctx->cctx)
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
