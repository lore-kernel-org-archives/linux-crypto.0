Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D4D23352A;
	Tue, 14 Jan 2025 03:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736826328; cv=none; b=nD/wSCQSdbapZvMecEuZPM0Ug9zVRWty/lgfumAZPHWBo4Way/A+f3uugXsdw64b60HE48FFPGx9iFsSLss6Pya9/9XNRm3LqGsrdYvIZvnGlyiS7n5TCdZ+qTMGhj0iRoWglUwr8FPoIRx0OIci9AW0TZCjg8lM142S5JdJCA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736826328; c=relaxed/simple;
	bh=RGzfeBWfbO8YFHbpabJy9zLzRwKmQ44eHYXGlfeX2T0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nt+HMreHj1cWhYx6pc2u4iILFb6WWMWMg0Q+gP1iR1WFLynFnauBIQpkfxeY8ErPW4cKJWnOoz1VRDWULXx6Vi7BU9UBKDaUEctG0m4QkiUI6cKls2yaYFZbAPR/X0fqndWDjdzFP3CeNGE0saUU1G3SFFGOWfuH+tvcbDBmPYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hpcAtm+v; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hpcAtm+v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vYXF8gPKaRazl9u6upM2yplGR/0+xplOip+EwntyzDY=; b=hpcAtm+vnISuhzghUAFOYq44Qw
	ZYuH0Mg9JcMge2MDwliTMo2OejDFlhTxGpibMjVn6pdu4pQk/cVg4d4z6sicRppvCG9LFQo3/tjlv
	owqfxaFtfivBRz7rXkxeOlSK591CRFtZue2scb7JN3UOAAsT4S0/qS6EcEiZfoAXy6PyeFtyL4avs
	BlY4x6rgFWUrKfvigCw555qTK+6FooB6rd7klaTKP5niXPPL4jxV3sXAtn5ROmquTRyTjlNzyo8n/
	mbVihoHFlDJ4W4kalvZuWl8cw0XRCOzk3XmjpKp8mvmxP2cmCjiCeasH38Yu0fj1Hra902QW8edWL
	I8QsqMew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tXXej-008xcH-38;
	Tue, 14 Jan 2025 11:45:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Jan 2025 11:45:14 +0800
Date: Tue, 14 Jan 2025 11:45:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] crypto: bcm - Drop unused setting of local 'ptr' variable
Message-ID: <Z4Xdypd1OQSrOYrl@gondor.apana.org.au>
References: <20250104205502.184869-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250104205502.184869-1-krzysztof.kozlowski@linaro.org>

On Sat, Jan 04, 2025 at 09:55:02PM +0100, Krzysztof Kozlowski wrote:
> spum_cipher_req_init() assigns 'spu_hdr' to local 'ptr' variable and
> later increments 'ptr' over specific fields like it was meant to point
> to pieces of message for some purpose.  However the code does not read
> 'ptr' at all thus this entire iteration over 'spu_hdr' seams pointless.
> 
> Reported by clang W=1 build:
> 
>   drivers/crypto/bcm/spu.c:839:6: error: variable 'ptr' set but not used [-Werror,-Wunused-but-set-variable]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/crypto/bcm/spu.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
