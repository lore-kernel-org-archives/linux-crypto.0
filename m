Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57921362;
	Tue, 11 Jun 2024 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718119313; cv=none; b=dLtjPenr6u/ND/jPYvLQmMaOeQQb/Hr0RPSN2GcD1kmcXE0a6kcvBXhQAVTxAeRbj6i1hvyBsNLkEGHcka8rV5+TLivHyt6GRupBy9t+KRNQiI2SDN0PZDiqB2+GfudviO3GU9HGVlKkuhDjK3vufocKPPwhm6kyY4nyi/rPfbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718119313; c=relaxed/simple;
	bh=5DKOcXmZYAZ1uVTmuHf4X6uRfLslHbl3wKvHFmdLPgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TilSPJxmTOEFubBaEKJI8apaMsUaSM3mWRy9y01aq35mSYB90uCFPw8xb1qp+AIdyv0EnL9MydngSs8c30ZcBq3vKbBxVR48y+/nYPD6qlX2c3scvvtKMI4gXh4gUxNjV5QYiCmMdabYctlWzpZOYp/qjiunq98GOZ72ZNR3x/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sH3Jc-0087mx-1b;
	Tue, 11 Jun 2024 23:21:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jun 2024 23:21:43 +0800
Date: Tue, 11 Jun 2024 23:21:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>
References: <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>
 <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
 <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au>
 <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
 <ZmF-JHxCfMRuR05G@gondor.apana.org.au>
 <20240610164258.GA3269@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610164258.GA3269@sol.localdomain>

On Mon, Jun 10, 2024 at 09:42:58AM -0700, Eric Biggers wrote:
>
> I understand that you think the ahash based API would make it easier to add
> multibuffer support to "authenc(hmac(sha256),cbc(aes))" for IPsec, which seems
> to be a very important use case for you (though it isn't relevant to nearly as
> many systems as dm-verity and fsverity are).  Regardless, the reality is that it
> would be much more difficult to take advantage of multibuffer crypto in the
> IPsec authenc use case than in dm-verity and fsverity.  authenc uses multiple
> underlying algorithms, AES-CBC and HMAC-SHA256, that would both have to use
> multibuffer crypto in order to see a significant benefit, seeing as even if the
> SHA-256 support could be wired up through HMAC-SHA256, encryption would be
> bottlenecked on AES-CBC, especially on Intel CPUs.  It also looks like the IPsec
> code would need a lot of updates to support multibuffer crypto.

The linked-request thing feeds nicely into networking.  In fact
that's where I got the idea of linking them from.  In networking
a large GSO (currently limited to 64K but theoretically we could
make it unlimited) packet is automatically split up into a linked
list of MTU-sized skb's.

Therefore if we switched to a linked-list API networking could
give us the buffers with minimal changes.

BTW, I found an old Intel paper that claims through their multi-
buffer strategy they were able to make AES-CBC-XCBC beat AES-GCM.
I wonder if we could still replicate this today:

https://github.com/intel/intel-ipsec-mb/wiki/doc/fast-multi-buffer-ipsec-implementations-ia-processors-paper.pdf
 
> Ultimately, I need to have dm-verity and fsverity be properly optimized in the
> downstreams that are most relevant to me.  If you're not going to allow the
> upstream crypto API to provide the needed functionality in a reasonable way,
> then I'll need to shift my focus to getting this patchset into downstream
> kernels such as Android and Chrome OS instead.

I totally understand that this is your priority.  But please give
me some time to see if we can devise something that works for both
scenarios.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
