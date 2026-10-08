Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55BB30EF9A;
	Thu,  8 Oct 2026 07:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791446007; cv=none; b=uq+6tEWjsa8PEBm6uKGpOEas9nd2ZTo2ky3dvU9ztiVuaMnzGobN9AA0Hsh6ByB+WcEEEMYzv67Q4nW50JkiVQnYJaQQByQAr/cVBAVihbqRVe7II9sm1x9pYti+RuXrFwoI/nXww2xjJ3Hi6J2qfR6f/u+QJlcr4LLqNlJ8+y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791446007; c=relaxed/simple;
	bh=ZIQMtCvVM28lDrBK3J3/H4b2BkrP/rffRw9INRNRptI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+tHPF+0aFaOKyzjFo8JWzhqSbA4AH+JxSSdMUGnM0iBRTpV7qThmusnSqA4uTmVFkaFPSWwe7/7c6VAzxLHrg1ZjUdnLH4EZ12CQKrOstbdaOFxzj4+GaygBUqbQ6Zzp7cXhoaNo8SY0r5vgZupnaNchxh8EMwKcUnPH5rh4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RqoLpu9U; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RqoLpu9U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lY3lfUu2K44So8+ddc597OEyulYwCRiStfCs+mDt5ZE=; 
	b=RqoLpu9UoH8jZae/bEccfzz/uDJ3B6OwP9a4m7dsbUe/yaAPFvuKqRDSsKZr7RERH4nlSu9flJ/
	YhyEZMxccR4XP8vp1TnhMqEwFi0S8aMrHS7MBsBaODUaxUehJ0RoiolZsolAJq03/Eo2L6443Ydkh
	qBR9ng5B61J4ZGc9AEk37jHbrkGKNx0SEkL99BRZZzNIon1FR3XdMqxqBqypUkz2k+/pFnpQf8pz8
	/GaNshUQ6xlkgEKvSBKhjgi7rUATM3V+u9N3ZSV97js0AgeF2HRr7bacIsKpAAa0VuyqO020huR6/
	LshqoeCF1IkmhHZrE+wKiCLz6mEDpQ8Ptx1Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEiwI-00000001nHR-3r4w;
	Thu, 08 Oct 2026 15:53:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 18:53:18 +1100
Date: Thu, 8 Oct 2026 18:53:18 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ralf Lici <ralf@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with
 accurate DMA directions
Message-ID: <asdL7rQTM5nSTIH5@gondor.apana.org.au>
References: <arn3UFsriRlGMXwB@gondor.apana.org.au>
 <20260928102502.266108-1-ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928102502.266108-1-ralf@mandelbit.com>

On Mon, Sep 28, 2026 at 12:25:00PM +0200, Ralf Lici wrote:
>
> For an out-of-place request, the caller may have already populated the
> reserved destination AAD area. The AEAD API says that this area will not
> be written by the cipher operation:

That's what I was asking.  Which caller is doing this and thus
would be broken without your patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
