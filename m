Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114142566E7;
	Tue, 20 May 2025 02:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747708915; cv=none; b=ReAQsodZGpfvBNftTpt/oWOcNcpFlWyNQzfVwYBqMuY8z8PSNv+69FXjJH8OcBXJ58SCiB9OFuBgnLbGrJ5WzF3Fd5eQIb074inErLUJIJ6C5TrFyFVeKhqgWnW/dAnoQX5jsAw8l3+I0SN/XulTaGfiR/50RtMUQbVKjx53atc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747708915; c=relaxed/simple;
	bh=YlZKYOntxtUGoS30gd/Q4GGAZ49JltnhECFOL1oxPUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+BNTeYdkdGpQNOQblO9qMb+bEqF2s5Ea/uWe0LwfCUiuSvHyissQHKjgiU0RLXw0mOqpN0qrdy5FjbmMU8y3HfPApTFpk6sHTZVXOwuz+XabK/m1+VZ+6MLxOb+wHIZsnjfI6yTSMmWweLO8yMkTFlRfwN7EkF0yOs1Tx5Ij3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=omqUSEff; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="omqUSEff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mbmHatBgibtORGz9noxsxSToIgfOSiUJWWrCAu+1y1g=; b=omqUSEffP5SSHEifldCkpDAuF0
	/U9n2kP+47uJLCJQDY9awYQsUUUGHR+6Ojb4w2XVYn1LqJKHGdwnmWa8cF5J/GA9ztkf4ZzXjPxxp
	BuB78/QBN6VCQgS97Iye9+Kaed6cm7GBzzWKE1ZvDMNc77zUUmy9LdNopr95s0SXSVxEzTIeoDueg
	+qDZeL3Zo8WlbMPFiqc7bTEefWlF4AmMra5HBu4p4dQvtaFRCDTbJfcx09Lx9AhMJDkT8EZ2wU2O7
	Fy7ku6CuyYzZ/W0q1S0yNHmCKO1hYwCA9qtFG8LtETboCNqhiVQPmZa3htpzTSSoSHs6afBNWWRXd
	+lX3oQBw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHCvB-007Ozg-1S;
	Tue, 20 May 2025 10:41:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 20 May 2025 10:41:37 +0800
Date: Tue, 20 May 2025 10:41:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>, Danny Tsen <dtsen@linux.ibm.com>,
	Segher Boessenkool <segher@kernel.crashing.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
Message-ID: <aCvr4UeJ1cK6jF0c@gondor.apana.org.au>
References: <20250514051847.193996-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514051847.193996-1-ebiggers@kernel.org>

On Wed, May 14, 2025 at 05:18:47AM +0000, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As discussed in the thread containing
> https://lore.kernel.org/linux-crypto/20250510053308.GB505731@sol/, the
> Power10-optimized Poly1305 code is currently not safe to call in softirq
> context.  Disable it for now.  It can be re-enabled once it is fixed.
> 
> Fixes: ba8f8624fde2 ("crypto: poly1305-p10 - Glue code for optmized Poly1305 implementation for ppc64le")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/powerpc/lib/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
