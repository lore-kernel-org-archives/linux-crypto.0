Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795293993;
	b=xGvapiserlmcHxMaOoX8DCkVjbgcHdrl5RyCcf2hAU36gq8B/DyQQ85XRPTPA2vJrMGW
	 2ai86wjTi/NVBJhhmlzIVvZJsFeYhdmzg6VGbF2JiXv7qVo1J7yze/hyc6GAUFXFWBlfG
	 iQ8+0rPrZXOF6GOgCjMn8fQQgRmn0yRz2Ni1qIsEqr89paLUSmwXaY1xHHt2hItTDfBpc
	 QrqVaMKEw3IDBJDinB+qlZk3rgAZu6QbqH1QBzx97O9Ijm4AIctJimxYOA+qlxBhhBrd7
	 s6NsIqvr7CI55ycjjcUxMsZ5zjxcDErvXqgn99imgRD8+ASG349Xxu4G5INT8G7B82g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795293993;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6Jfb322MsnyWlRjIrySArcoIrZprjk9tczeK62Y9wJY=;
	b=KrOtunXHXqFsAoGfS11XTX0rpM71qb5wyOD3IbhmRj9W9hGIq9ZG1QCytvyvEIQPgN80
	 mols+/gIqUqajt7imk3gTEMnQsWX2lP7Th3llZWc5GgMyZDJtjN/w3aRRMZ3ZEqDDgyC1
	 bwgpb5ydCm71xuRPk3CytY8J0f0R8qqGUCtiBrrZhLtWNvaMkyixC16ei/zcCP0X596x2
	 /McGU4kroICZxoFA5vYad+vcQsrwngqFSeDld4w6OqSpx79s5LDqFHLFP+L8cQk1q1j12
	 Dd7i4eumV1F7dWSytVeSyG4c6pJbKVqO+mRSIsnXO4QfV32Xsbb6+PD0Q34Aq9vUcQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mt9ZiHBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0D9606A335;
	Sat, 21 Nov 2026 20:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mt9ZiHBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EFC1F000C0;
	Sat, 21 Nov 2026 20:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795293993;
	bh=6Jfb322MsnyWlRjIrySArcoIrZprjk9tczeK62Y9wJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mt9ZiHBFWFnZvQA64GWTZkD8T1COnUgmO3508knhB96x3snQw0+d5tA1gDv8XgtzS
	 hUVevxapt9vUsxJ4wYC62lJudww0P5/KTLixfoQws6E6VSD8Nun2b5VVCqzuhKA3lw
	 PuuyVJ+yl9exalACX4h3H6NGuzj+bf0LYIiT2+APhZDJhlMvefy7OZhuYOrgQMntGm
	 sXNKXD7tz1QVE1XVz8L1qz17vCSucDvmKldAXVoDssuY3KM5TiEc+IVbRFow2IuJp4
	 Vun/XAblm8RBujaH2FzediaQ8crVc0n5kIOtGkoBeJiS2T010zsqRQwMAsjmIPcEAN
	 w8sEXPZKlAOUQ==
Date: Sat, 21 Nov 2026 12:46:31 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: Add 4-way folding in NEON crc64_nvme
 implementation
Message-ID: <20261121204631.GA16190@quark>
References: <20261118160110.1662470-1-16567adigashreesh@gmail.com>
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
In-Reply-To: <20261118160110.1662470-1-16567adigashreesh@gmail.com>

On Wed, Nov 18, 2026 at 09:31:00PM +0530, Shreesh Adiga wrote:
> The partial block stage is enabled only for AArch64 as it needs the
> 128-bit TBL instruction not available in AArch32.
> Modified the loop dispatch on AArch64 to allow any len >= 128 rather
> than just multiple of 16 bytes.

Note that an AArch32 implementation of fold_partial_block() is possible,
e.g. vqtbl1q_u8() could be replaced with two vtbl2_u8().  Normally I'd
consider an AArch32 specific optimization not worth including, but it
might be worthwhile here since it would avoid divergence in the code due
to the following arch-specific precondition:

    /* Assumes len >= 64. AArch32 also assumes len is multiple of 16. */

>  lib/crc/arm64/crc64-neon.h | 15 +++---
>  lib/crc/arm64/crc64.h      | 18 ++++---
>  lib/crc/crc64-neon.c       | 96 +++++++++++++++++++++++++++++++++++---
>  3 files changed, 110 insertions(+), 19 deletions(-)

Anyway, I've applied this patch to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

In general I'd prefer better comments in the code though, especially
documenting nonobvious decisions like why pmull and pmull2 are accessed
using inline asm instead of intrinsics.

So if you'd like to do a follow-up patch, it could be worthwhile to
address the above two issues.

Thanks,

- Eric
