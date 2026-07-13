Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D1A22ACFA;
	Mon, 13 Jul 2026 03:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914343; cv=none; b=hfv2NjQTlQYra8MSu5In2ipeIBkaIVfxnLPLGalfxaS5XFwwH7k0caIr2Ij1KCWGesMYL3XHQrgzJL3snGqJI1RFFytU+wQ6FdfnubBJ8zsZJ8Drhu1v8eCjhlp5pAAGPGlUsyuNA6siGhqlnaBMVhhtRu+dXCkU3Limm5bDjJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914343; c=relaxed/simple;
	bh=k6JJMv9ZdblAAOzYVjv7o58ONlat5Dcwod+X52UeHgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzN0/rO/XYja2ZJJz9G7ZUxFSo0DarbohymmR7RLn8vwtzKSwJ22m2sGzsA8mfZ3TEku6OVvzyUUsF+Wo6oEhudiDO15VgBeuB+7dvA9nbT3NUuR/VftY3on/W4G/Eo/x0+jqRaxmp9YmbS6z6d9sFCCuJhfsQ3AXql+0BZp8fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NxHs58vN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NxHs58vN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=93GTo6Gum5smd+5liiS3l4OWy5HTAvTAnR4D+xSApcc=; 
	b=NxHs58vNyH1N2Q97Pl7x797VT6EDS4xhpMl9sEOpxX2h1ookNuTk1uTfRCtCkoHPWIc5vXoGd25
	sZRzntp99r+w2MiNr+6OCrb/Sy07ZNyEeHisGvaGObhM38bRQ8v59zmjMp8jo0WbohX7+btyZ2C9q
	Qreesg8/6pyi8uVABd71yHeDEKULriSIZtYGUv5YsB1lWshPG+9H8sF/SJhMt0nPPl70CRKsUqfqj
	0we0oQkdltUePOCw+z2qV2JLNjobDkcAkueR7vtxhIPjNB8LeRJFQqXMp9arsRRkI4a9j0xPQtyEk
	KoAwLL+89J8POeZZiZAruNfCqh0JekrJjrJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj7bm-0000000CyHG-44fC;
	Mon, 13 Jul 2026 11:45:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 13:45:30 +1000
Date: Mon, 13 Jul 2026 13:45:30 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mark Gross <markgross@kernel.org>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	linux-edac@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3] MAINTAINERS: Drop Mark Gross
Message-ID: <alRfWpuiEiRC72u3@gondor.apana.org.au>
References: <20260703173803.3589003-2-ukleinek@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260703173803.3589003-2-ukleinek@kernel.org>

On Fri, Jul 03, 2026 at 07:38:03PM +0200, Uwe Kleine-König wrote:
> Sending mail to Mark's Intel address results in the intel mail
> server rejecting the mail. Dave Hansen confirmed he left Intel.
> The kernel.org address seems to work, but there was no reply from Mark
> on the discussion about broken email settings and his maintainer
> entries.
> 
> So drop him from all maintainer entries.
> 
> Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
> ---
> Hello,
> 
> this patch was already send end of May (v1 @
> https://lore.kernel.org/all/20260526173806.3227828-2-ukleinek@kernel.org).
> Konstantin then suggested to change the maintainer contacts to the
> kernel.org address as at least one of the forward-addresses for the
> kernel.org account didn't bounce. This v2
> (https://lore.kernel.org/all/20260526193238.3622176-2-ukleinek@kernel.org)
> wasn't picked up yet, but given the continued silence I think removing
> Mark completely is the saner choice now.
> 
> If someone has a better contact, please make him react. If he returns
> later, the entries can easily get restored.
> 
> Best regards
> Uwe
> 
>  MAINTAINERS | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
