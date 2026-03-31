Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0514240DFC6;
	Tue, 31 Mar 2026 01:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774918908; cv=none; b=Qac6zubNj/kkiN1Tlo2SQbtnN2a37GP5QDB7oGq6mkdb6xkIaLhej5FrzYpRg6kiJJInhpWI/V/NIxtV6SiFjf9/QmMyT8VuXr3yBwJ66K9NFeA8ZhgVhvCSmE9vCpPv0PvWfQtm5oKSICg82p74ICZkDc4oJsY/2LCaGhl1GiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774918908; c=relaxed/simple;
	bh=lr82PEA3e4soq1JzFgqyOWI1Revv4CceLPPiCuTZ7YU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZUsHc70Sw64gK9DcfjeKU5fKmI0f58xt2iy5SIymv8991QHhXNw7V45YBNYEtSb+1DCg+2/f7yjWLFLng58Ihdqzf9EnNUqpou60oKCgV+PwAB7tsUOre9gn4zkYN3F22z0NR4qt0JzY8abCiq01O0X1uXtM+ttnHY3AT6XQi3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 9298692009C; Tue, 31 Mar 2026 03:01:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 8E00C92009B;
	Tue, 31 Mar 2026 02:01:44 +0100 (BST)
Date: Tue, 31 Mar 2026 02:01:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Eric Biggers <ebiggers@kernel.org>
cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Sohil Mehta <sohil.mehta@intel.com>, linux-crypto@vger.kernel.org, 
    linux-mips@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: lib/crypto/mips/poly1305-core.S:95: Error: opcode not supported
 on this processor: mips64r6 (mips64r6) `lwl $8,0+3($5)'
In-Reply-To: <20260330203731.GG4303@sol>
Message-ID: <alpine.DEB.2.21.2603310147220.60268@angie.orcam.me.uk>
References: <202603210105.sdD4rsTq-lkp@intel.com> <20260330203731.GG4303@sol>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 30 Mar 2026, Eric Biggers wrote:

> > All errors (new ones prefixed by >>):
> > 
> >    lib/crypto/mips/poly1305-core.S: Assembler messages:
> > >> lib/crypto/mips/poly1305-core.S:95: Error: opcode not supported on this processor: mips64r6 (mips64r6) `lwl $8,0+3($5)'
> >    lib/crypto/mips/poly1305-core.S:96: Error: opcode not supported on this processor: mips64r6 (mips64r6) `lwl $9,4+3($5)'
> >    lib/crypto/mips/poly1305-core.S:97: Error: opcode not supported on this processor: mips64r6 (mips64r6) `lwl $10,8+3($5)'
> >    lib/crypto/mips/poly1305-core.S:98: Error: opcode not supported on this processor: mips64r6 (mips64r6) `lwl $11,12+3($5)'
> 
> This isn't new.  It was first reported in 2021:
> https://lore.kernel.org/all/202108040636.P6t1LvPP-lkp@intel.com/
> 
> It's caused by:
> 
> CONFIG_64BIT=n causes the 32-bit Poly1305 assembly code to be generated.
> That code checks the _MIPS_ARCH_MIPS32R6 macro.  But, the code is
> actually built with -march=mips64r6, due to CONFIG_CPU_MIPS64_R6=y.
> Thus _MIPS_ARCH_MIPS32R6 is not defined; _MIPS_ARCH_MIPS64R6 is defined
> instead.  So the wrong code gets built.
> 
> Maybe someone from linux-mips@vger.kernel.org can confirm whether
> CONFIG_64BIT=n && CONFIG_CPU_MIPS64_R6=y actually makes sense?

 Absolutely, you can build a 32-bit kernel for and run on 64-bit hardware 
and we have supported it since forever across all the MIPS architecture 
revisions.

 You probably want to check for CONFIG_CPU_MIPSR6 instead (and similarly 
for CONFIG_CPU_MIPSR2, etc.).

  Maciej
