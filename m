Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABB813FF9
	for <linux-crypto@vger.kernel.org>; Tue, 21 May 2024 02:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716257639; cv=none; b=GBySs2UXJVLdyOr8mjcnFaF3k6wnZ7Sl3vbgGGvjYF+eIzEDqqSXVXKY732K7REQHNmrcFhOi9qvTki3wQoG3essnJCJ4eilQDNC1tlqAALXK3MV2tjuUtiIcpVM5vKYtGK/XhjuIdOS9DRHvjIs6hQRMKPVnsvuDC0CSdicG28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716257639; c=relaxed/simple;
	bh=MN6l5UhCIu1v828U1OmVWUmGotJMFYDmXHtEyhGUXmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hs3Z7QE40hAYJk+byjkEulw/XdlUE73Tbfg1XXW1CGJWjS9AAhpIXj99luo1xil8muD82bOHtFCTXuBuxhfBfnx2rNzyGvxXpwCdaQLVOYjd7/QvRi9D1SpmDhV6dZc73Clib9F9ZqEPvf4FLWM6pvoPQfI38k5WGI3Cd20+fko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s9F0a-000IIc-0I;
	Tue, 21 May 2024 10:13:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 May 2024 10:13:45 +0800
Date: Tue, 21 May 2024 10:13:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v3 3/7] Add SPAcc ahash support
Message-ID: <ZkwDWdlcaDoycRmH@gondor.apana.org.au>
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
 <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com>
 <ZjS8fQE5No1rDygF@gondor.apana.org.au>
 <CALxtO0m2wC3=yP5zE3_2nboVBVRVuhwuHx9Pdfj25wynky3E-A@mail.gmail.com>
 <Zj3Ut7ToXihFEDip@gondor.apana.org.au>
 <CALxtO0myn63AwPh4vck7fpuJcttPJYLBM3TpsyBAexCMSa4GcQ@mail.gmail.com>
 <ZkV6ZmONMHEX7BQy@gondor.apana.org.au>
 <CALxtO0=n+k9NDfH87JWkFHQfA=T2x+T-ekGh=SBmA6Ozk48qsw@mail.gmail.com>
 <CALxtO0mz6ehEowBr94MZqG3+P9tV1ZaomP5K3n1F2VSuRzn=1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALxtO0mz6ehEowBr94MZqG3+P9tV1ZaomP5K3n1F2VSuRzn=1A@mail.gmail.com>

On Tue, May 21, 2024 at 07:38:06AM +0530, Pavitrakumar Managutte wrote:
. 
> 1. Are the export/import functions mandatory? Documentation doesn’t

Yes.

> 2. What do you think of having import/export as optional functions, instead?

You still can't support partial hashing even without import and
export.

There is no limit to the number of partial hashes that may be in
place.  At some point your hardware is going to run out of memory
for the partial states.

> 3. Besides no access to the partial hash inside the hardware, how should
> 
>     partial data chunks to "update" be handled, that are smaller than the
> algo
> 
>     block size? Are implementations supposed to include data not

You keep them in the partial hash state as is.  Look at how the
software sha1 code handles it for example.

> 4. Also, how keys are handled for keyed hashes? The key may not be part
> 
>     of the state (e.g. for security reasons the key could be write-only).
> It is not
> 
>     clear if the key should be set again before calling ‘import’.

Keys are stored in the tfm, possibly as a partial hash state.

> 5. In the kernel we don’t see use of export/import besides the test manager
> 
>     case. Is this feature used/expected in general? How about allowing the
> 
>     function to return an error like n2 driver does, and still allow the
> 
>     test-manager to pass?

It's used by algif.  But in general partial hashing is required by
all users that do not use digest.  As I said, you cannot limit the
number of ongoing partial hashes based on the amount of memory in
your device.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
