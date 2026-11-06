Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964440;
	b=QNvCcFmQAFCgRgqubCuVtqqlJz6uI7NIrmQn7kvt6u9PzjD8zNDBj3YcZvJKLfUvp5pC
	 joRQGEQiW9YNpLfduqQC5nNzcQSb5XjAosegUYzUKt8E9X+pIbR/TsWdkhsQ/JINiWyZm
	 2LTw0TNlnmP+Z9If8AOb9dmVBHwGcCIGbVbdWOOK28/JcNLcpJGU1IoU+AR4An7+i7QaJ
	 m6yDkQJC1pQ3LOmd5BCFFrEZT0QGYtqXmf2s8to5kWlrMs1SP/eowkY3S6uRoQ4TfvrLU
	 OtcZJRzDZ3ehjGMRkIMu/Q7+bq593Fsf9fByr8L0/+KhygrMkXHBu50Mo+VpALbX4SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964440;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=dMkNie5jgxNx3G5eTbxj6pYOJmObSXEtjaZ2+ZMR9Vg=;
	b=Ol70R3L0/f6OVABh9ECcJEV6B5HXm0qHU3wu1WSFuzyD8FitodrT185CEsQGkr2eBZtl
	 tZAtL5zvsoAsiV6cBAYKTLAPv7/DpGvZ4wFFLiauhaP+BlrFU20RmuLDZCdpizw7y5slu
	 GvKqo9XLmRZnxptvkD3KTzRqev+o8N10rmqCHs6F1FhA8HmQNW4fwKX6hqbdSf5zhrRZ5
	 uj9EGX2yRrpfIDEU5guBzVZZFs2vfeg4eilPTX9P0HT0jvxENQsIsBYfNabJ4OTD/PDMr
	 cmXZ64w96+pfuOs4f9K8mW1Cxnr1H5lCrhcjAoghZCtUlqcmhbqd0V6pf+3ngOiVGeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=rqgmO3jP;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47852606D808;
	Fri,  6 Nov 2026 11:27:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47852606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=rqgmO3jP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dMkNie5jgxNx3G5eTbxj6pYOJmObSXEtjaZ2+ZMR9Vg=; 
	b=rqgmO3jPmin9pHdVJ4zE2o9W4BOcMg7B9hoOiF6gDqhwSEILw7ca9oXdjkYoMHWOp+i8EUs1nvt
	mE8alVOvr/wjDzVATMlRgDo5GcI+WQMb9/5ilqM8RwxD3pC3lv7OW9q/jElmYAXFaKdLk7Re9eT3m
	YeLePMswocDe6jEUon3nGFr9EJnHVEKc6zOuQf5jNdxdN6UaNb2QE8NhvoFhAEs4tLFNFDI8Q1LoV
	6ByIiJ0qhzRMcMSfbtr8mDlmT5Wj/xr+rlewD2yrfr09JBCy5yuyf90rpS6Lkaf5zvVsLuPpwtwAq
	atRQ80VLfXm4DDZc/6UMMGR8lyACC5Yrjxvg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI6G-0000000Br29-197x;
	Fri, 06 Nov 2026 19:27:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:27:16 +0800
Date: Fri, 6 Nov 2026 19:27:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ZhaoJinming <zhaojinming@uniontech.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Lokesh Vutla <lokeshvutla@ti.com>, Tero Kristo <t-kristo@ti.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-aes - fix NULL pointer dereference in
 omap_aes_remove()
Message-ID: <au25lCTnY1FmsPuT@gondor.apana.org.au>
References: <20261016-omap-aes-remove-null-deref-v1-1-195d36295ed4@uniontech.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-omap-aes-remove-null-deref-v1-1-195d36295ed4@uniontech.com>

On Fri, Oct 16, 2026 at 04:30:04PM +0800, ZhaoJinming wrote:
> omap_aes_remove() unconditionally dereferences dd->pdata->aead_algs_info,
> but only omap_aes_pdata_omap4 initializes that field:
> 
> 	static const struct omap_aes_pdata omap_aes_pdata_omap2 = {
> 		.algs_info	= omap_aes_algs_info_ecb_cbc,
> 		...
> 	};
> 
> 	static const struct omap_aes_pdata omap_aes_pdata_omap3 = {
> 		.algs_info	= omap_aes_algs_info_ecb_cbc_ctr,
> 		...
> 	};
> 
> 	static const struct omap_aes_pdata omap_aes_pdata_omap4 = {
> 		...
> 		.aead_algs_info	= &omap_aes_aead_info,
> 		...
> 	};
> 
> For omap2 and omap3 the field stays NULL, so on those SoCs unbinding
> the bound device (e.g. via sysfs unbind) or unloading the module (rmmod)
> dereferences a NULL pointer:
> 
> 	crypto_engine_unregister_aeads(dd->pdata->aead_algs_info->algs_list,
> 				       dd->pdata->aead_algs_info->registered);
> 	dd->pdata->aead_algs_info->registered = 0;
> 
> This is a hard crash, reachable from the teardown path only; probe
> errors do not get here.  The asymmetry dates back to the commit that
> introduced GCM support, which guarded the registration of the AEAD
> algorithms but not their unregistration.  The registration path in
> omap_aes_probe() already guards the same access with
> "if (dd->pdata->aead_algs_info && ...)", so add the matching check to
> the remove path.
> 
> Fixes: ad18cc9d0f91 ("crypto: omap-aes - Add support for GCM mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
> ---
>  drivers/crypto/omap-aes.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
