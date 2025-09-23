Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F322230EF83;
	Tue, 23 Sep 2025 06:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758609409; cv=none; b=Avenh46BCCXj+RacF2FUc5HaBH5rzARI5sOCmjMLtZb/mngaWVCcHNxGIc5Xr/NwSUctEVhJHA1NhctDooFL4b6gFJ1HHLLTJZZ0Sx+TVChAKt5fqRRGmcoEo3ydzEp8wuoDrL6O/8RKohsmueB4w9z6zVIRuRech6gb2lciq5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758609409; c=relaxed/simple;
	bh=3jA5Zs/7apFO5Q1K4vGTDb8JMKMzzy+zZtbGlJChXkI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=GMzVT1fZW7SlIumHqpacRw8MHgI0Q64fpS2T0ENENxcWIvbvS1Qd0IE5VdKAQwHoiWSJDZEbmO4T2vfTVlEzL2yP8sYc4Wln3FjArIUUFa5JDMmsa1BGrU37/D3KKoTYGewTifvLfr7KVFk1yM1MbjsBSXL44jIijY1HezBU8O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VhfZvBig; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VhfZvBig"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:Message-ID:Subject:Cc:To:From:Date:cc:
	to:subject:message-id:date:from:references:reply-to;
	bh=7r2xygGEFfVK/pgwi5KBbGBfBHvLKcS9Klzr8jHg2BQ=; b=VhfZvBigqwwTsqol/1/n5ecJau
	KSJse89wPjBsntZvo7P7hNQrD2z7fWpf28Np2/cRgHMqsNZaLuLs3kvfAmLASWdpfUAe8GozXzGif
	MBPIoYJFqfl6NYEz2ghRoh+9u36J0VecBHhMt2gTtTo3GFtBDM+oGKIH20CUUdzI/nAa366GvVZbN
	Z1wDKG1js06rh4DGd/6X6umdSz0hElqM86vA+ti5pjtLx4/OR20wrcfJmpPtAqWq2AsXJ5Jjf44TR
	4m1aKQK73IIo8vGuS8gXK69tbQBNv+zzXPzEwyjbvG/Avj/FkyEHbktTKPz0jmwWgij36PsweT6XF
	0XRASuxQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v0wdl-007bFS-0N;
	Tue, 23 Sep 2025 14:36:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 23 Sep 2025 14:36:41 +0800
Date: Tue, 23 Sep 2025 14:36:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: tgraf@suug.ch, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Neil Brown <neil@brown.name>
Subject: Re: [PATCH] rhashtable: add likely() to __rht_ptr()
Message-ID: <aNI_-QHAzwrED-iX@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923060614.539789-1-dongml2@chinatelecom.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Menglong Dong <menglong8.dong@gmail.com> wrote:
> In the fast path, the value of "p" in __rht_ptr() should be valid.
> Therefore, wrap it with a "likely". The performance increasing is tiny,
> but it's still worth to do it.
> 
> Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> ---
> include/linux/rhashtable.h | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)

It's not obvious that rht_ptr would be non-NULL.  It depends on the
work load.  For example, if you're doing a lookup where most keys
are non-existent then it would most likely be NULL.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
