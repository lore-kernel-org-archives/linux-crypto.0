Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81F720B819;
	Thu, 23 Jan 2025 07:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737618380; cv=none; b=qC6S/ihFUtMpRBvvdPPiO1+CZACAmQCROuMoz9mm5Z/Ip8xEDm8LGaBRcBkYIjOxq6lvH1aPX831A95/XZmhHnTLYyZXKf8VLRySadDYv3PkW+mHFRA09q/9YXsFKJb1qyCIupvqJ5T2OaPcUWW3DdwrbfgFSyyz3HfXzEI5/M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737618380; c=relaxed/simple;
	bh=NVwWyrINrNflFepBmNs675zKTcGbAfvbrmwGEdWyx7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQ1PkPxxoMH0JJqtZS2fzOhxX6y5NFFzWHi72cqaWwJT1Sxgeaw9ee3iqeVqUpeKEe/7t5dHBQKtYzyaBzEMPYk6fAcThOfjZGHO4Ik2ssz6Oq9uQsww9lLpqkWPSsoP+ihtdVUsrATdkeSbP3b3c911r9EvyiH78KY6Pz3enZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nf+BsObD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nf+BsObD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3122EC4CED3;
	Thu, 23 Jan 2025 07:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737618380;
	bh=NVwWyrINrNflFepBmNs675zKTcGbAfvbrmwGEdWyx7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nf+BsObDeAu/5SYcH7svMqMYORvsvw5T8U1WSVwDVIBRLJcfAN5KP8rnjwGDK5wab
	 J4/LUm0bsf48vCU1YvUWRyhNVKH2DhCHLJtZo437KOnL6kIsPS7sg/Pmm+ayD8S3Nk
	 MQUAd54bdyTHw5pxluhtkijpi7Qqjf3EIxpKb4quQ6J1s35o2PMhzQdeyXyManTzg8
	 oExvgaTqMLYjllci5tXOlwsOMAGTwnxC00b8IL37Rb5dhDkvjp/dB7lIzEPHQ8rzvy
	 5UlDTUXg5IdwxJTRmaHGeQjUPG40ygcuFA+sGgKMQc6+Ur3316Jk+AqiYTE4jgtu/N
	 lZIsm3mHxyXrA==
Date: Wed, 22 Jan 2025 23:46:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123074618.GB183612@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123051633.GA183612@sol.localdomain>

On Wed, Jan 22, 2025 at 09:16:33PM -0800, Eric Biggers wrote:
> As you probably noticed, the other problem is that CRC32 has 4 generic
> implementations: bit-by-bit, and slice by 1, 4, or 8 bytes.
> 
> Bit-by-bit is useless.  Slice by 4 and slice by 8 are too similar to have both.
> 
> It's not straightforward to choose between slice by 1 and slice by 4/8, though.
> When benchmarking slice-by-n, a higher n will always be faster in
> microbenchmarks (up to about n=16), but the required table size also increases
> accordingly.  E.g., a slice-by-1 CRC32 uses a 1024-byte table, while slice-by-8
> uses a 8192-byte table.  This table is accessed randomly, which is really bad on
> the dcache, and can be really bad for performance in real world scenarios where
> the system is bottlenecked on memory.
> 
> I'm tentatively planning to just say that slice-by-4 is a good enough compromise
> and have that be the only generic CRC32 implementation.
> 
> But I need to try an interleaved implementation too, since it's possible that
> could give the best of both worlds.

Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
only generic CRC32 implementation.  The generic code has become increasingly
irrelevant due to the arch-optimized code existing.  The arch-optimized code
tends to be 10 to 100 times faster on long messages.

The generic CRC32 code is still needed when the CPU features needed by the arch
code are unavailable.  But that's rare these days.  It's also still needed when
the CPU has no scalar instructions to accelerate the CRC (e.g. on x86_64, the
"regular" CRC32 as opposed to the Castagnoli CRC32) *and* the message is too
short for the overhead of saving and restoring the vector registers to be worth
it -- typically < 64 bytes or so.  And it's still needed when the CRC is done in
a context where vector registers can't be used at all.

But those don't feel like very strong motivations for the huge tables anymore.
I think the huge tables were really intended for optimizing CRCs of long
messages back when CPUs didn't have any better way to do it.

- Eric
