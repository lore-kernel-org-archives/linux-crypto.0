Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0AF225788;
	Fri,  3 Apr 2026 01:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178204; cv=none; b=jEWGRgMCQGP5/6irgp8t7xyohXLBROMy5PBDZGFlKKMKnjrM/4X0Px++toqC8ocoNmWTzoGwa+JAUGa+tckOg6bfnq18gk4kye2Ut3gTIUWbV9Yg/vPM/mq0e4hrPoZ39s8Qt1O88FNAsuTVI0azL4WsJPgK7k0+MS4NG7qUHx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178204; c=relaxed/simple;
	bh=NfwTVSpbumr5ncGwU3SCdxm2fQb0+GayhCGGoZ00aM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzKq3c+FHjI3dLEm3OVHKkRp+2L2kOGFS4ivN47D7MMnKyfXEmUAIo4cdwZ+WVdTkikj6piQ31i3gzfBJTOqOMHcMa+KqfhfcLBbzCiWhZaKPgEhP5BJSgFuwpm9oSvkgXMFuvWkXD+a0GggTzujbqYyNnff0hU3uroyUmIAyW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Pcy7ukdf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Pcy7ukdf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7YoSEJ++U+bhsZHS7opTnIXvFxUfS1Ektt6/OuIFNhc=; 
	b=Pcy7ukdfzC+ko0Rih10LxJA/9qlFtoganjfS6zaAZ35WkeQrRSOlmAvvaXUwmNwR7B37BTMhg7k
	/ew7Tnlw/GUdOMSIDiMQPqRdnmeTsGRdARmFHP4IPEy0xsgKgXmzo+pZVXXD8KXDv+zabAez2r5w/
	ZcbVGDNKtTC0zAHqKY34A+hn29cQzJiWBiDLC3u+BsxRqlfAbqHbMW9SA+7DmANiyje9TF3GVV0aZ
	lJLzf0h9wabmwP4bLXE3fpetHCOsCoNaH2sao3DxGZiJ/nxFAcWQGnA9hOGvkxpdpW/oj7GEpy75m
	iggZIsDgon/bj2jdGfOKUmUC4oYRfkwQH0Lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SWg-003Qwj-0L;
	Fri, 03 Apr 2026 09:03:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:03:00 +0800
Date: Fri, 3 Apr 2026 09:03:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(aes))
Message-ID: <ac8RxOP3h7SEqBN5@gondor.apana.org.au>
References: <20260303184916.69132-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303184916.69132-1-olek2@wp.pl>

On Tue, Mar 03, 2026 at 07:48:44PM +0100, Aleksander Jan Bajkowski wrote:
> Test vectors were generated starting from existing CBC(AES) test vectors
> (RFC3602, NIST SP800-38A) and adding HMAC(MD5) computed with Python
> script. Then, the results were double-checked on Mediatek MT7981 (safexcel)
> and NXP P2020 (talitos). Both platforms pass self-tests.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
> v4:
> - rename aes-generic -> aes-lib
> v3:
> - correct sha384 -> md5 in description
> v2:
> - rebase and resolve conflicts
> ---
>  crypto/testmgr.c |   7 ++
>  crypto/testmgr.h | 255 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 262 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
