Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ACC30E84D;
	Mon, 13 Jul 2026 23:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783984206; cv=none; b=RTNdfwUnPyjszuiPaQNt2afGiuguAwxB8O1DefhfqI69SX7DJCPLOzsxNG9JjgaxgBOHcvG3+F8Tj46Jh7XBnpb11CWaFefdcLt5LscVHPgcnwOUgL2wl6j3w1PSp1lEaBJ3Tu/5TuhbV5ipuvZrTgcHnTAs4Xp0Kf07EOz0iVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783984206; c=relaxed/simple;
	bh=x2b72g6FhZyGSmxu2MAF2s6YlyvXgJ0PCsGtjn5ZuQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLWS5EBVhhEjFVmQxsiWfGwz3eVbJAG4KBbPmmVtPdMolW4PCxFzutvSv+nkfNt3nyu57jPpFXklG2bP6FU/mY5vOVu1iTtknn+VExqDmNNjsEziUd03VppWQNwO5cv5x818RqEYxYzX4cHaaTZed4CWh+0Vuc1rUpSMocE6LLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eNqMWBl7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eNqMWBl7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ShCa86acHnx/y3hw++s5hGyjSELrd7WtbPi/RA2NDbQ=; 
	b=eNqMWBl7G7VmGaG9Ux/VXkZAMyZiNsljIDjx7meq5088yXmt06XpMhi0qdraWQ2g+lUsNIuNhAv
	JYlWEG0iWcp0Hh6S9nUBZ7Seh3wvoneZV+b2JgJkEeTJvPc2KETcHiU52drioH3siA8doA1ZPwn80
	r9hQMSnKpJDBBMYVurV2P+p3ZUvAbd7mdKJR42gcV9rAcT29j3TxaANAPg0UU7IOdV8NdLP9B6Azr
	nLgSBdDblFiT5mmzqU1yni8zm2xO8ir8FADKwKw7KaSx+8G1OPelYD8qlmmJ9g9P5WjAwJgvvKFEA
	d74JAC+fhcvxFfil486UbbwaxUSGTXgsjvKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wjPmb-0000000DFf2-1wD3;
	Tue, 14 Jul 2026 07:09:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Jul 2026 09:09:53 +1000
Date: Tue, 14 Jul 2026 09:09:53 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: cyper@tutanota.com
Cc: Davem <davem@davemloft.net>,
	Linux Crypto <linux-crypto@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: algif_aead - stop recvmsg looping after a
 completed request
Message-ID: <alVwQeMACt9rY2Q5@gondor.apana.org.au>
References: <OwDrEgL--F-9@tutanota.com>
 <alRE8Mqf-W0Qqpnq@gondor.apana.org.au>
 <OxRB4MX--J-9@tutanota.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OxRB4MX--J-9@tutanota.com>

On Mon, Jul 13, 2026 at 06:02:42PM +0200, cyper@tutanota.com wrote:
>
> A new sendmsg *does* get out of that particular wait: it sets
> ctx->init = true and af_alg_data_wakeup() wakes the sleeper, so
> af_alg_wait_for_data() returns and _aead_recvmsg() processes the new
> request. What it does *not* do is make the recvmsg() return: the
> "while (msg_data_left(msg))" loop only stops once the output buffer is
> full, so after processing the new request it just loops back and blocks
> again in af_alg_wait_for_data() for the *next* one.

That's the intended behaviour.  The recvmsg(2) call on af_alg
will not return until the buffer is filled in full.  This behaviour
goes back to day one (commit 8ff590903d5fc7f5a0a988c38267a3d08e6393a2)
and changing it now could break users.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
