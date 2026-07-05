Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AFB36EA98;
	Sun,  5 Jul 2026 08:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240832; cv=none; b=Ykvhn3DJzPPR1EnO6ZDMc6keVuO2FpOoyMMh53XJjNZw931EkPwSanQNNfeYTMAkWa9daV8jriE8rFunjQB1c+U4H0DHKhunB1jrUDUE/hdSdwmSUelxFhwoOVHXna1qFSklTFoF5I6iUA9beZMCbu00oFZ3dbmhSf1lBNqfuEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240832; c=relaxed/simple;
	bh=+0H6tbo4d7N8hoT1zeEGoSGryRBE5z5dDMzgG8chFnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K40ohrxLVTx9yTsEtb1BrlUnehg/nqz4gkN3hXCR3IRcNPxTZNnNyi1u3GX1qNq/xGD8Vu9SlpGVLyVQmy8pvZJdUJNxxbLiU8JL7WUZoZq94gbGQMAJr9ENJ7LbovMPfUTkM4W1Gnf/UsytCB9kHqZZmS5xsMml8YUsgSTV0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VyyA/38P; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VyyA/38P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YnPYEc03Tz+zse3KRMllPpy0RP6DybVNk6ZiWdg+K6w=; 
	b=VyyA/38PN55sJUDfL+uvdXOF+YDTt87iMxQm/rrxmgqtgbrbegvXdOL0WMl01hnwToPE/7d5Sxx
	O2gICet78BJ5AJIokHiN+Hj9rwP7kovlSHPjG6TzIdLT43f3YdYEaobtk5W29SA1V5nqExZuHIiPR
	9thBc/UGQRmsXUNwtm4lE4JDLIwCXzDMeMTJTJrtB2B1/l82IsdxsS4StTm5wY6cX8e2RkjQ6cUk+
	+6IqqKnxLDj9ASJa3XWyIrXjZlN0NhipbXinw7jpyrnxewcFJ0PciuhOBedm8+eK4H5lGmHLKR3NJ
	wi4i57X9Q5hwQ95gPFXe4ozUhd2BstgM1nhg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIOk-0000000Al7Q-394k;
	Sun, 05 Jul 2026 16:40:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:40:22 +0800
Date: Sun, 5 Jul 2026 16:40:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Mounika Botcha <mounika.botcha@amd.com>, Harsh Jain <h.jain@amd.com>,
	Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: xilinx-trng: propagate timeout before any data is
 read
Message-ID: <akoYdmsMsfeZcpR9@gondor.apana.org.au>
References: <20260623060728.18906-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623060728.18906-1-pengpeng@iscas.ac.cn>

On Tue, Jun 23, 2026 at 02:07:27PM +0800, Pengpeng Hou wrote:
> xtrng_readblock32() polls for 16-byte chunks but returns the number of
> bytes read even when the first poll times out. Its caller then treats a
> zero return as a short successful read, and partial reads for full
> 32-byte blocks can make the tail copy use a fixed block offset rather
> than the amount already produced.
> 
> Return the poll error when no data has been read, preserve partial
> positive returns after some data is available, stop the generator on all
> collection exits, and append tail bytes at the current output count.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/char/hw_random/xilinx-trng.c | 32 +++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
