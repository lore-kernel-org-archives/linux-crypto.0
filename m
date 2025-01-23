Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F9238F83
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737641322; cv=none; b=k3aTupPpogCLjIuf1ZLlWC3ycj1Q2z1ssejxXUoC8d22Nh+LOpc+K09cfaQZ9wbPo5tHxHJUU16nEFnX/yC5eb83zCq+NFQBqyAzmnlkqBqDE3RHanRRJgl8yVtc20RNSAp4tVA1s7nfUfue/EXdauyklyrKyFG9GeyAtjLmzgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737641322; c=relaxed/simple;
	bh=RRSX/2VuxB+p15V1Cj+BR7xaxlPBqtQECX4IbVEuq40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqkrOU5wH8TA0c3OLTA8v3k40rrNp/IgGAEw2Iq2dPfezhi2D6Lycsoy6n+lL/qP465TpHd0SYBFeva5cUQk1zNgEwPPOILR/lhMBHhoy7AJ8cOYLl4FBs6RcXhxkNkQ9s/GAXznihwnXXR8SH95QzX0xNDhUqdLORaGRUuHpN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=eBOiJ1Pz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="eBOiJ1Pz"
Received: from cwcc.thunk.org (pool-173-48-111-161.bstnma.fios.verizon.net [173.48.111.161])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 50NE7jtb017326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 09:07:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1737641269; bh=Dh+ZSB/+Wd7fcqlzx6d9N8S1fYKaHE5gUskndM4ynrA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=eBOiJ1Pz3RqhtSl/EFhzppWcucsOJWeLdhfB1LkHzt7ioW39cPM1rGdVmop+DquY2
	 Vj4btv8C28gL0wV8e+62hysv2YgByARRUWRKhR8SIxoWa8H+ZKr0WLQuZBIqxQYI+H
	 /KBjpVsy6D5Pap1kOKqYrqIfLpXf8UMjGI9E/INF6k4/Fz+ajS1G/Ry4MgTq840Xhy
	 oQ+OGr1cutL9UGH/gO23XULzw1Ul2EQsovVoOGTOItjn8KzD5YMfHnmMjNcbxqKFcs
	 6BrKogs3kOw9sNuONUo5XNgftpwoqR5Vu/GRC2djPF7fL73qjaNg5Zy181zM0sm4TC
	 MSMCd8FRNJvaA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id E791915C011B; Thu, 23 Jan 2025 09:07:44 -0500 (EST)
Date: Thu, 23 Jan 2025 09:07:44 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Vinicius Peixoto <vpeixoto@lkcamp.dev>,
        WangYuli <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123140744.GB3875121@mit.edu>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123074618.GB183612@sol.localdomain>

On Wed, Jan 22, 2025 at 11:46:18PM -0800, Eric Biggers wrote:
> 
> Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
> only generic CRC32 implementation.  The generic code has become increasingly
> irrelevant due to the arch-optimized code existing.  The arch-optimized code
> tends to be 10 to 100 times faster on long messages.

Yeah, that's my intuition as well; I would think the CPU's that
don't have a CRC32 optimization instruction(s) would probably be the
most sensitive to dcache thrashing.

But given that Geert ran into this on m68k (I assume), maybe we could
have him benchmark the various crc32 generic implementation to see if
we is the best for him?  That is, assuming that he cares (which he
might not. :-).

						- Ted
