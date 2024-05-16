Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2853814B95D;
	Thu, 16 May 2024 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715889156; cv=none; b=J+CFAdFlxshNt4HPm79qUKfxfjAIyNKB8XdFsv5Tn7pe9xbBUBEWAJjlLmxD36hCz3aGwIFUbku/ViODLliQaS/Dzy6IWKGA1ZblriAJjZtlvY23kKRRB/wrJGs+iCuF+VnRocwU3W5pKQCCTolhNKJcGCSVKa90fS91IdGjKRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715889156; c=relaxed/simple;
	bh=mia+mIXfeByfPzOjI+pmzibnMHWgK7mRmUIiOyT+wdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/2yMTp00DQrIdMtKpW+uvayAM4wYDykKjiHtHctLcnUBeYSiHhHJDhCgSX7kDUFIUt701OwBp41piw95IrSab/ayKVpvubj15uP67LewJczxncQ03BtU29716v0f/Id7G9F3/wAEV6uj2JPLmsA7gZkE5odNFU60yKOjdjnqIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 44GJmEdc016902;
	Thu, 16 May 2024 14:48:14 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 44GJmCLk016900;
	Thu, 16 May 2024 14:48:12 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 16 May 2024 14:48:12 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andy Polyakov <appro@cryptogams.org>, Danny Tsen <dtsen@linux.ibm.com>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        dtsen@us.ibm.com, nayna@linux.ibm.com, linux-kernel@vger.kernel.org,
        ltcgcw@linux.vnet.ibm.com, leitao@debian.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/3] crypto: X25519 low-level primitives for ppc64le.
Message-ID: <20240516194812.GN19790@gate.crashing.org>
References: <20240514173835.4814-1-dtsen@linux.ibm.com> <20240514173835.4814-2-dtsen@linux.ibm.com> <87a5kqwe59.fsf@mail.lhotse> <89e7b4b0-9804-41be-b9b1-aeba57cd3cc6@cryptogams.org> <875xvevu3h.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xvevu3h.fsf@mail.lhotse>
User-Agent: Mutt/1.4.2.3i

Hi!

On Thu, May 16, 2024 at 10:06:58PM +1000, Michael Ellerman wrote:
> Andy Polyakov <appro@cryptogams.org> writes:
> >>> +.abiversion	2
> >>
> >> I'd prefer that was left to the compiler flags.
> >
> > Problem is that it's the compiler that is responsible for providing this
> > directive in the intermediate .s prior invoking the assembler. And there
> > is no assembler flag to pass through -Wa.
> 
> Hmm, right. But none of our existing .S files include .abiversion
> directives.
> 
> We build .S files with gcc, passing -mabi=elfv2, but it seems to have no
> effect.

Yup.  You coulds include some header file, maybe?  Since you run the
assembler code through the C preprocessor anyway, for some weird reason :-)

> But the actual code follows ELFv2, because we wrote it that way, and I
> guess the linker doesn't look at the actual ABI version of the .o ?

It isn't a version.  It is an actual different ABI.

GNU LD allows linking together whatever, yes.

> Is .abiversion documented anywhere? I can't see it in the manual.

Yeah me neither.  https://sourceware.org/bugzilla/enter_bug.cgi ?
A commandline flag (to GAS) would seem best?


Segher
