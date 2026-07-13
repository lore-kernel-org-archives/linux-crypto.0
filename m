Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23C9356749;
	Mon, 13 Jul 2026 05:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783922150; cv=none; b=jfEd7ngOsCJV1q6Sogr81gBFWgAhKGzzGD3UO498WwEJkNKKltXIx9IcmE0ViZH/jmEM5/Vr1jmnKGHY/Bu2zGpcThI/0kDUxWIo1Tmkct3oiq14xZDxmYXblZshkHPDDEAQ+W9pZIyzSyNRzl7Uf0YRQzjmEFIbNj2Y1kb/nqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783922150; c=relaxed/simple;
	bh=36UhtQalnl8BwFQNRbkiF9JwZobnAMcZdfiIpXdAW/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dL6PNQmLb3rYQu8XWONRGjlpK75ThnFQSfDXkT4j7Nw3reU04vYmiS45he5PxNhLbZzmIrxsaXcSeFrgPKlFJUTSQLg7uUGeSYiGoBOU8ubcCkjO329sAyLFP3KhBUEebTGwChw6eRyPhH6SvDDP/65cpIPzc0Crg7A1L0znjoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gvjhwWj5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gvjhwWj5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ix6xUCOnIlrH0TaX+g8TmDtdJVZba6LW7ZChQKCurmk=; 
	b=gvjhwWj5VkOr3gnM8SF06mktpVhc2PLgoLT5rusGrbjljKgWzgCBXZ8MKFMoKVL1K2gZ4IHSY5t
	SFU0vRcGN0SLjl4j9+TijjrNPOk20VAbKSWgMl4mhx6g03Oc4POD9RChuXG1okAOdEcdlsWo3Gch4
	tMDEwM8n6nVBzO13WltB6A1tyNPw2pCMNRE+pNRsAasvS5cs3HyD7dEn/vlL2/GaSUjAREyiC4dpn
	AJW6ht7jUNEDVfORrvXadQOVotJYBz1/z+BbCa/LocHKJ2JNrZDBnAzaTLIZGIBUgId8DGkM5dsxI
	vLhGgVAYaQX0oikoKzvPQOoJHqR8SuFWicoQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj9db-0000000CzOV-21uX;
	Mon, 13 Jul 2026 13:55:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 15:55:31 +1000
Date: Mon, 13 Jul 2026 15:55:31 +1000
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
Message-ID: <alR90y8Zk9YHq5kI@gondor.apana.org.au>
References: <20260703173803.3589003-2-ukleinek@kernel.org>
 <alRfWpuiEiRC72u3@gondor.apana.org.au>
 <alR7WaRFM25AcvJh@monoceros>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alR7WaRFM25AcvJh@monoceros>

On Mon, Jul 13, 2026 at 07:46:26AM +0200, Uwe Kleine-König wrote:
> 
> Note that Boris already took this patch. It's already in next for a
> while as 97dfcb871ba776ba0e1ded1cdcbe94a357c2817e.

Thanks, I've dropped this patch.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
