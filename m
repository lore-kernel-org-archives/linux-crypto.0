Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC361AD2D;
	Tue,  1 Apr 2025 03:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743478246; cv=none; b=RrEd6aReZE0aDCf/LT5eqUu2XVeATM3/Dz5e5p1Q+fpxUra10KTKZNi3UJJFxNQSIzPafenMYU/2LM6CwySBTrHAlPiztOtYs4hq/tfzZUTMTM9E60m5ZpULXsjaAWElnDejFY93YJ5Y0KjXUO9ct8WvEdCaAp7fGMINJIGiu/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743478246; c=relaxed/simple;
	bh=cXohRKmoOkA/naACPd/8hTTkF+nwwgll0O0pjHlNh+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJAygVPQYvUFRz4kZ1DdiPqG5ZjrYe2Q4OgduwC5jVXPp9lRj8H1IzQtVl6fVnOOzVMH+rlhvj2MRhgy1iduGcHSRGB14u+c7OJMUUp69D4xRmO0IvsLWShHT3hhBslkBLoA27Jpy8lLIFYZKbbggzguxbyQ4H0XTOFK2GlZTSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kii6tUlP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kii6tUlP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=B6kTthkGbQ/GGDstyXYKBMZWNZ+9FrGdHSlTQCCqXKY=; b=kii6tUlPtrHfoI+IPMSvem+JXt
	hhQZ4ckdvVYqkn1kCiFB4TQ50ULDjfEIfVy/9b+0eixCsGMBKnqqlqQZuXT7ISh4dXniWa/cuzuun
	wjbZJNoSmyV/R1pAjbgKPwzGkf0x6WuDv4SLXn7ZQXyLQEZsqAiEHvqsOlzHZk6FXH87KvpfDzXVd
	vYf2MJn2aeBU2w8L9hwl15AEOew2LNfph4k283VjwRFmHAjW5j2UIW6WxNbB1JUs27vDz3AayFLyG
	389WmlQiu12ub2PQgXc4qfX+MMq+hdM+ecrnKrNYe1nxi0nU3crsMaSLKidnX7cyhfGrg0PvFOqmj
	BKRLfARw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzSKf-00Bji6-0o;
	Tue, 01 Apr 2025 11:30:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 11:30:33 +0800
Date: Tue, 1 Apr 2025 11:30:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <Z-td2eIxPp-gRq7n@gondor.apana.org.au>
References: <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331165630.GA3893920@google.com>

On Mon, Mar 31, 2025 at 04:56:30PM +0000, Eric Biggers wrote:
>
> For hashing, users would need to allocate an array to hold the digest for every
> block in the bio or folio.  That would add an additional memory allocation to
> every I/O.  You said you'd like to fall back to a smaller buffer if the memory
> allocation fails.  But that's silly; if we have to support that anyway, we might
> as well do it that way only.  In which case the bio interface is pointless.

BTW, the existing verity code is hilarious.  In my test, for each
256KB bio, it was dividing them up into 4KB pages, and then for each
one of them, it's looking up the correct hash in the Merkle tree.

Surely there is some locality here so if you zoom out from 4KB (or
even 8KB with your multibuffer patch-set) to 256KB you could get all
the correct hashes in one go, rather than 64 times.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
