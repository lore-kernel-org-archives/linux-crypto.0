Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794601809;
	b=qAB3M0BG8mao7GZe4H3BwdahTYos5ZFiKKOpEMO75J83ubKbsWzmDz+vnfs2Xw2xFp1a
	 iLw35CJzuWSl9erbXgVMzVBiUYEZZq05IPl20z3ZSbO6ZhSd48XjgjTWSWr/66l2c+q6L
	 LfHjP17FPrdps6enY/7aQ7js+ybJWHWO1Z5TnbWOaEZUTNOvwRSohyFok+61bgvkc35pM
	 /kAizTgMLXDwKksqc+/Av0im/NiZ1fWzmblJ/VpoVxGPfR8KLIOH30Xp25oujlW+zIXtY
	 shQp5ymlaYayMYAi1yKyIBXwbf9gtGD8MtkCuujC7OsSWEsclP+OziRbfrzuWjUdJ4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794601809;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=S62Apjunl/OYf6dm8P9jYppCwO2i0AlqtAXpPuIIy9U=;
	b=Sp6CuDliUgJjSqzRwbL+8O4azLlvVDzN76ITqQ8FnQKVKDE4msi7PStTGxDxBEjloPlT
	 kwgBiPWIp8KwqQX9rqsB23XQf1uegsNzF+PdEW8QyyLx9x52LXNBnrCiktL7fUn7I+iWz
	 dxE9bfx66l3/S7FepuakXvSCnHSjbU6Y2IAIArNqexxpdgpj2yEzzvjzGoW/rnLIHKAHz
	 GMov/crWrkYiBW//XyqZ+L2m/DMLCGzAdQlsMirjLiLujCiTT/apB8PP3fgsGhMbTas1W
	 gJXwoK9NoX3jXQ06eOwI9ghPH8GHQTz/mAHjTrKAyk4YfFpxAuIWPQv6RPDva9wbuOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BeNe79yK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A759606A331;
	Fri, 13 Nov 2026 20:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BeNe79yK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4861F000C4;
	Fri, 13 Nov 2026 20:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794601809;
	bh=S62Apjunl/OYf6dm8P9jYppCwO2i0AlqtAXpPuIIy9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BeNe79yKfO6VaeGdZVaILyXJXkxXK6N+jGXDa52kSZYaVeBsB4+hF8tfBAwWaFFkj
	 IJMQAQcuXAWgQnga4ifLDbBhPfw/DSAU0VvYysoCPZd8nBQXc//IyKKo0Twx6lH1JI
	 SUM6AK1lCqCh/dgIaA2ESjvDzrRug8fgi5HN1wnG4ougE8Gq9+r/IjETQ9ZeHrVUVD
	 NDz4r5m6D/MwygzvI8v1cMOMbSPAj0S1+s+fu3hBeWHNQRX1fThTL9umlJJXHT28jj
	 PWDKfeouNOa58I1CUd6TTE5AmqyVJYLDzlpi8LXEdF5u7UuOQVDbTxU8DJ3akZOYcw
	 LH7eQI39LCr6A==
Date: Fri, 13 Nov 2026 12:30:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Message-ID: <20261113203007.GB29151@quark>
References: <20261029135020.272082-6-ardb+git@google.com>
 <20261112222720.GA188816@ax162>
 <bc58b973-3d54-4480-aaaa-f5d5269418ea@app.fastmail.com>
 <20261113190150.GA2857474@ax162>
 <b7f72b97-6e8e-4b07-a2a1-6ac8c6e596e4@app.fastmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f72b97-6e8e-4b07-a2a1-6ac8c6e596e4@app.fastmail.com>

On Fri, Nov 13, 2026 at 09:05:32PM +0100, Ard Biesheuvel wrote:
> (cc Catalin)
> 
> Full thread:
> https://lore.kernel.org/all/20261029135020.272082-6-ardb+git@google.com/
> 
> On Fri, 13 Nov 2026, at 20:01, Nathan Chancellor wrote:
> > On Fri, Nov 13, 2026 at 09:23:03AM +0100, Ard Biesheuvel wrote:
> >> On Thu, 12 Nov 2026, at 23:27, Nathan Chancellor wrote:
> >> > Who do you think should take this series? It would be nice if it could
> >> > start making its way to mainline sooner rather than later since tip of
> >> > tree clang builds have been broken for over a month at this point.
> >> >
> >> 
> >> Are the first two patches sufficient for that? Perhaps Eric can take them
> >> through the CRC or libcrypto trees, and I can send the remaining ones
> >> through the respective arch trees the following cycle.
> >
> > Unfortunately not :/ we need the third patch to resolve the error since
> > that is where the conflict is originating.
> >
> 
> OK in that case, maybe Catalin can take the whole thing via the arm64 tree? 
> 
> 
> 
> Diffstat:
> 
> Ard Biesheuvel (4):
>   lib/crc: Don't include <linux/types.h> in NEON intrinsics code
>   xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
>   arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
>   ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h
> 
>  Documentation/arch/arm/kernel_mode_neon.rst | 10 +++--
>  arch/arm/include/asm/neon-intrinsics.h      | 43 +++-----------------
>  arch/arm64/include/asm/neon-intrinsics.h    | 24 +++--------
>  lib/crc/crc64-neon.c                        | 10 ++---
>  lib/raid/xor/arm/xor-neon-glue.c            |  3 ++
>  lib/raid/xor/arm/xor-neon.h                 | 16 +++++++-
>  lib/raid/xor/arm64/xor-eor3.c               | 15 ++-----
>  lib/raid/xor/arm64/xor-neon-glue.c          |  5 +++
>  lib/raid/xor/arm64/xor-neon.h               | 31 ++++++++++++--
>  lib/raid/xor/xor-neon.c                     | 16 ++------
>  10 files changed, 78 insertions(+), 95 deletions(-)

I agree the arm64 tree makes the most sense for cross-subsystem arm and
arm64 infrastructure changes like this.

- Eric
