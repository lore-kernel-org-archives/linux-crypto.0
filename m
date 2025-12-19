Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9801252904;
	Fri, 19 Dec 2025 06:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127598; cv=none; b=Dfa0FGkfCL9nXTO5/bSeeASb0kWtY6Dubhm1Z85p5/MIHgyNKf1dKHQQ3HsXu6Y8Vh19GZ2JRduIInl4Ip0/qMZBdln9syts4/sjaI/vqfaNP+jTaPrNEwcUCWIQ79PB/Va3tVyvr8Hp1afO4TrRSnoWQL5stklFsspNPR59hDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127598; c=relaxed/simple;
	bh=/5lHR/rhLPxvPmtmxnN0lK1NYSM95blJVek/gIAhDkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDzxSeBd5ZA2P683wiwOQJVhESJXVHdAVXEnE8ebKVqZWbmHitzSbE/4A6MmK7QHZeY0x+RAFlutxl9KzhWwWOM6/9wOJ6wm9jdpsTp6En7lfMb3EUnFOm24CA60yUUuRwjNGFV7k9Vb1enEguqd04TNUG0jEarQzao1FHOS8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P5knXgzj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P5knXgzj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hGlut+8e+AulJaY6L2XSob85vSygI1Kd39DqiQjPriI=; 
	b=P5knXgzjNcMoeb+sOGSN2yauxv8CS7Z5Cllgq0N5qM66NXgSaoHHjQSuTggoHZCh+zgfWOB/y0I
	QVqvOeliyjuqR0WYa1aP/4BYC2YG3M9NyE7yuREK6g2leQI991ktVvXh5AnJvCjGCPWpoSptQrDNx
	fyhobuGxpTi/PL80lnH/1UJmMl8TvyCadoTdK6fKxPVtImubRsGK3g3+qeh597KJbGq6x3Mmna+1j
	P5asy42L3omvzsWQmJhMIv73P4g0rTAYQYfOPjdqojJUVJDCZVlSTzHAy4w73HCFNs7iTWrdHdtb+
	NkIWz22vQNpR32G0+WDOrbKfEw66SOA02oHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUSa-00BEd0-1e;
	Fri, 19 Dec 2025 14:59:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:59:32 +0800
Date: Fri, 19 Dec 2025 14:59:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Lukasz Bartosik <lbartosik@marvell.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx: Fix length check to avoid truncation
 in ucode_load_store
Message-ID: <aUT31MqDVBQXYr18@gondor.apana.org.au>
References: <20251126094616.40932-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126094616.40932-2-thorsten.blum@linux.dev>

On Wed, Nov 26, 2025 at 10:46:13AM +0100, Thorsten Blum wrote:
> OTX_CPT_UCODE_NAME_LENGTH limits the microcode name to 64 bytes. If a
> user writes a string of exactly 64 characters, the original code used
> 'strlen(buf) > 64' to check the length, but then strscpy() copies only
> 63 characters before adding a NUL terminator, silently truncating the
> copied string.
> 
> Fix this off-by-one error by using 'count' directly for the length check
> to ensure long names are rejected early and copied without truncation.
> 
> Cc: stable@vger.kernel.org
> Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
