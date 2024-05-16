Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA21282E1;
	Thu, 16 May 2024 20:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715890238; cv=none; b=qnFHZ/QMrkfnc+StqIHCUxMqrFa4z6Y/UXtice0ZiwpAwEO9EHBL8wPQMU2F0Bz3KYIV6w2m40CdqbhchP43M4mLGqC30fdy3iHUxVzagvEgp+Y2adrq7rv5b7IboeqRpG4RtmCxslK5kDpQr+F/vLdQ3Vr0DWpUa3YdUCWptX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715890238; c=relaxed/simple;
	bh=oq0QbdhJXYFWnQf/TURGQJ3Y2B7qCQ/gvzuj7VK1szQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTATXJoyJze1rnXcbbEbsBCmllyV+isqVkkAGz9/o2A3qylIeNMKL6ZbaUvXqSpWmJwJjLHhNNNBuhslqOALKqYDtlj2XvY8lG1p83rOXvRs9OsvMfMIpRBFlmvLUlN7ur/C51U31Y1jq7MWSzOGtpnDwccutKjHIx7QvqN+JWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 44GJS9sG015776;
	Thu, 16 May 2024 14:28:10 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 44GJS6lh015769;
	Thu, 16 May 2024 14:28:06 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 16 May 2024 14:28:06 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Andy Polyakov <appro@cryptogams.org>
Cc: Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, dtsen@us.ibm.com, nayna@linux.ibm.com,
        linux-kernel@vger.kernel.org, ltcgcw@linux.vnet.ibm.com,
        leitao@debian.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/3] crypto: X25519 core functions for ppc64le
Message-ID: <20240516192806.GM19790@gate.crashing.org>
References: <20240514173835.4814-1-dtsen@linux.ibm.com> <20240514173835.4814-3-dtsen@linux.ibm.com> <847f2e4f-ace1-415d-b129-ed2751429eec@cryptogams.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <847f2e4f-ace1-415d-b129-ed2751429eec@cryptogams.org>
User-Agent: Mutt/1.4.2.3i

On Wed, May 15, 2024 at 10:29:56AM +0200, Andy Polyakov wrote:
> >+static void cswap(fe51 p, fe51 q, unsigned int bit)
> 
> The "c" in cswap stands for "constant-time," and the problem is that 
> contemporary compilers have exhibited the ability to produce 
> non-constant-time machine code as result of compilation of the above 
> kind of technique.

This can happen with *any* comnpiler, on *any* platform.  In general,
you have to write machine code if you want to be sure what machine code
will eventually be executed.

>  The outcome is platform-specific and ironically some 
> of PPC code generators were observed to generate "most" 
> non-constant-time code. "Most" in sense that execution time variations 
> would be most easy to catch. One way to work around the problem, at 
> least for the time being, is to add 'asm volatile("" : "+r"(c))' after 
> you calculate 'c'. But there is no guarantee that the next compiler 
> version won't see through it, hence the permanent solution is to do it 
> in assembly. I can put together something...

Such tricks can help ameliorate the problem, sure.  But it is not a
solution ever.


Segher
