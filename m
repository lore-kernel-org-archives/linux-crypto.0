Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAED140E5F;
	Sat, 15 Aug 2026 01:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757515; cv=none; b=NKS5IqwcL9Ga1rsZn928y0q5HDfyq7OGa8akc54OkkFwotuv4nWkMH70rTUOT8IxSln5g6Mta/HLGZJDPLGnzot4c1NENmXK8new1Vxa/ev2iQirqwRiUG5pIisRAXtE7WUrRloLfgui+OWHQdFzsDC2SMDCCzD9Mg4EoLRkEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757515; c=relaxed/simple;
	bh=rWf2JcgzQxgxPC8/PIeP+qoCE3T4PVicbV1PU2TPsLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhD0Ezp2fPTGeoBewznBIDjLhFfyzIrIE3agVcqjJqooGKsojIiM8SOk/170PUDwvktvCskW0afsGlLvtCMfEzCfj5/y0SctOPv1Zs2/Fa4qwVff1QSAS6eI+qF3ZBioF71TTz23hrloOmmgOkccFybw1r3q8maBegUc/DymcTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WC4x6PIk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WC4x6PIk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=k/1xitpABmOUG0yNmjBrvWdP4rZoVE/lqBI2yeEFc78=; 
	b=WC4x6PIkN1neVcCjuhrVwCKB2fNJgEPADnBvnSK0eg4kR6McmUlvEXIIar4AxlkzYQxmuzFK9ZX
	WE/bLLFvoz9Ou9ZeD9ywAjle6gCg5zzIvcXk+LJQiQD1/vWcdwL4X9ZDECVy/nUjbTkytMpr175gm
	yD4LDMqwTwy/rJ23BoBiEmy543XHrRhYxO0E5tV6+GRecEzaSsAJgRiuNOVhg8NrXL4UnjZHLxD9f
	FOUL0HTzpl2JDKCRg3nJ4rLq+tXnQ4YRtCxOR9nQQVMpCLSAnGEFk6kgMJhpNAzmfQyKP5uU/LO62
	9rmgunp4fskSK6NsdqkGIDOWFhEHQspz4XhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3FW-0000000554v-2ZM7;
	Sat, 15 Aug 2026 09:31:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:31:50 +1000
Date: Sat, 15 Aug 2026 11:31:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] crypto: keembay - use crypto_memneq() to compare GCM
 AEAD tags
Message-ID: <an_Bhs3-JE-J2kre@gondor.apana.org.au>
References: <anYEQOzunX0Lm3N1@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYEQOzunX0Lm3N1@david.gall>

On Fri, Aug 07, 2026 at 06:13:52PM +0200, David C.C.M. Gall wrote:
> Use crypto_memneq() for constant-time comparison.
> 
> The GCM path in keembay-ocs-aes-core.c verifes the received
> authentication tag with memcmp(), which returns early on the first
> mismatched byte. This leaks valid-prefix length and allows for valid
> tag forgery which violates the INT-CTXT guarantee of AEAD.
> 
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
