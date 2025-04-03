Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB13A933;
	Thu,  3 Apr 2025 02:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743649003; cv=none; b=Dsh58bCzP7qyFyz3qC/k667IS9zQrZGdRahKXKLdFpdf+yOWHLs8b9kl1QZ0XBtlcw+F0m12aLSpyjzciNKKXtP1dnajyIPZ4W6aKko6co6BKfyjTeWPTzwWuaEqnBJU2g9q10BUb4mMRMR+6L64HEjoxJh4c3SEccyeh2MxckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743649003; c=relaxed/simple;
	bh=1wio7SDBTdb5Y+OU8+MhhhL+yLidhARkjGmQq/UwxcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSHMRiPhQJQ4VE2znx2jSWwkS8nnck/XEVa7x3Oru/BZQrFVAHGkbIm6ACajMjylYCPdDNnytrnpNQRM94nGbkhCkQO5KBGoeMEyQhsXDA/bSzRKx8dNGhkao81W1F4xWU8pDaEQMKCR+7vZBl7Tozj0XrR8JrMhQ+UjJcxYgLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=U21mTtoA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="U21mTtoA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KIapc8bhcCKu451gi2VbwgisbJ1KR+RSc7w1Nghs12s=; b=U21mTtoALabE09AP2zk9KYSkTd
	FuONEwc4N+1pNgZwVqHb6rxeU4SN//FjscfqoVvRJUY6SurYQikz3vMm+gzFDL9IK/0XWTPhFA45T
	sIWsfMN7Eufrufz0619VWVTJqx78ZuoL4gtHX6iyjcZuAq0eYEI3GBApuQyLv2n+Saipa2QBMHA1t
	7PbXREEXKrZokgMfs9ih92IqXiKnKtUr7mJ+hz2B8/IW1TDYMGUU6u2R/LbW0knlbwCOc6MQNpUC3
	R5VQPNQgDf+CdXmdKBtMIHQ1JVt5D02NIcehtUvbWpGZWQOsLONc/5U/5bPwkQ1DTkbI7FB+5VgPV
	yy1cHtnQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0Akt-00CLG3-2V;
	Thu, 03 Apr 2025 10:56:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Apr 2025 10:56:35 +0800
Date: Thu, 3 Apr 2025 10:56:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <Z-344xAsx1uTE9OK@gondor.apana.org.au>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403021453.GA2872965@google.com>

On Thu, Apr 03, 2025 at 02:14:53AM +0000, Eric Biggers wrote:
>
> It's not the 90s anymore.  Crypto is fast now, and used ubiquitously.

I have to say that you've done a great job in improving crypto
performance on x86 and I'm very pleased with being able to
encrypt 256 bytes in just over 100 CPU cycles and doing a
whole page takes less than 1000 cycles.

But this is only possible with SIMD instructions which we do not
support in hard IRQ context.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
