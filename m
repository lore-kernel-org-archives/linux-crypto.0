Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9598929B0
	for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 04:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750393200; cv=none; b=Xt6fbUhWtKPo3ntEydlXbCJyg0w7Qe7Iuu5+7kOLQFoGz2i5mC0Imh1YcvaXqXuNVJfpS3uuS3/pp9xtFd4NSSIsoeETMloYU0QcoA9y19TmJ/qRDZ3ttBAQ/ziS+Rr0YZYQy4VFCA1kRT3egpMluouHgf3U3qtxlRuJPSUFlbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750393200; c=relaxed/simple;
	bh=h/m9m58mpTd0MWOUS4VBULDQq6+2Fc10jOyeqhaXYrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxwTzsGFZRHrwmxumgTAjUtos99q4DRN1qu2tmVdke2vguW2k0kMYkH+TrPbbqHVmsrEo795ZkGxU3ccT1A0aV3gApunGNJ/VX+lzGyCqylYxdeJZP2hdbgZfgD9jVSldMfAlduKsVe0svSGSeZDDUr5r2pc18Qv2GHlS2eH1Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AM4jQgCK; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AM4jQgCK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v3LFEsQ2k8VQSVZhpBUWXIOQ/OcY/NtyTZJOIs+OeG4=; b=AM4jQgCKjpPHqgn0YNk6CaTZcw
	795fv3x04fBEnoH+vZCecTe/1TOIZ0rfLr7ys2hVqEIL4bKzLdFXwb8+Z4GbnBsKhv37CzlNRxiuO
	4mJjGDgeMkH/mZjQPsOQnCGmglCj29EU6zX8fSNVNcmO9aQzyaFEJ782XbOLGBr9pHn8F/2LNCXW8
	Eo7ebHxN8tvn5cHHAqGXJcY5regq3Z2XDl+2xLinT6kzmGlu56cA4FbXHWMsCDLBS+ox9X46FfMvp
	6C6zWXSQ0A3bPQwPySnHyXLMZdVJNdzukzHnXybWnNbqPcpJzo+relOU6FDOAS6G46SOjf1vxIdTH
	17cD82UA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uSSyz-000Tf9-2R;
	Fri, 20 Jun 2025 12:19:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jun 2025 12:19:53 +0800
Date: Fri, 20 Jun 2025 12:19:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <gmazyland@gmail.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Failure in HMAC with Whirlpool hash in 6.16-rc2
Message-ID: <aFThaUNAAhx_wPu6@gondor.apana.org.au>
References: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>

On Thu, Jun 19, 2025 at 11:18:13PM +0200, Milan Broz wrote:
> Hi Herbert,
> 
> another regression in kernel 6.16-rc2, this time in AF_ALF for Whirlpool hash.
> 
> Cryptsetup can use kernel userspace API instead of userspace crypto lib and we
> have some testvectors to detect breakage of crypto.
> 
> It now fails with PBKDF with Whirlpool hash (HMAC).

I grepped for hmac(wp512) and didn't find any hits so I assumed
that nobody used that.

I will convert wp512 to block-only so that it may be used with
hmac again.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
