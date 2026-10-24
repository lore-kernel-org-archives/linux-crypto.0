Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792866478;
	b=X4zG2VWhkH1j5+K8yO5OkOBB8yPsORDV0nHK7OzqaR2+mqUUZBKXYB0Be4c7n8/Zx7eB
	 ByIs/Jp6WnMYgdr6/lA+DVOhq9AMYvsLnaW6JcZztQ2lIPQVWebfueBJ6dZO7hXTAYIbd
	 /vJubxFB6nbjhJPdb+j5397EFcKFeJV5od8NMD9KgddJKKf5OTFWUKkp3BaA2w/+vd9f3
	 BhPW1vaa1OeK13sZjFEsZ904KiyUeCt8W8w7PT3NMnRkCrNgqimPTMhBtDa7SA+Oix93y
	 wymD9D8RN8fsj3cuNJ338lxkj5Mj7KnDXq7C6HQFgQAZ4mJCvSXA5zJO3x95BA++O+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792866478;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=3u4ifH4xqM5IBmUpPGcW8mKUPiRQuRIt9YjES9uvtvk=;
	b=c1aJHMyN64KTKi31rL1R2X1j6y2jtiUTGnitwJPv53ItyckL3C9degNKMHvuH/TMLc++
	 sPI5+EssTt0XPW2WYzRgbDBWJxMjRLAkiC+qGUy6TVzvGn8dQkN/JSiV93Z1smcOGPgXW
	 UCmYu6xMDsPd4mv+fYG5HSPiQxuDA8f11ylJAXujPyuyBj/KmmIzRu7MjGR8QSKRBbllZ
	 X6vCIOO//igNLxEEFaJDtIdb2gJ9pDBvEbkY10oHDUn5gQU0FlhzEKAt/i9bhjW6aL0pS
	 iP+0JE6wO1BK/VipZGCTd/+k1CducngrpnKlDIe54gsfufWyW+kRk3ewEuXMtmcKwlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2FWWJs8s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A06606A31A;
	Sat, 24 Oct 2026 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2FWWJs8s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E8A1F01825;
	Sat, 24 Oct 2026 18:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792866477;
	bh=3u4ifH4xqM5IBmUpPGcW8mKUPiRQuRIt9YjES9uvtvk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2FWWJs8sb3ulTNwcVjYMquEeHKhDG5vf+ZwM+OQK9VoJlq3HGtRudSCqx6+V+Q0q1
	 Yb3joaPgVGapV32KSy6xW7B3t9YgCJjLltketE9Om110a73ESoEN5gFIfYQ4p1KaT5
	 Dpc/JpAU2gLFAdsA5yOOQR3diPAWb3nsgeeGtwGk=
Date: Sat, 24 Oct 2026 11:27:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Tzu-Ching Yang <shingekinocore@gmail.com>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Alexander Lobakin
 <aleksander.lobakin@intel.com>, "Jose E. Marchesi"
 <jose.marchesi@oracle.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman
 <horms@kernel.org>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 David Laight <david.laight.linux@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] unroll: Drop the unused unrolled and unrolled_none
 macros
Message-Id: <20261024112757.b3c214bb14baecf8bda3d79d@linux-foundation.org>
In-Reply-To: <20261024181520.GC2553@quark>
References: <20261023163108.2042675-1-shingekinocore@gmail.com>
	<20261024181520.GC2553@quark>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 24 Oct 2026 11:15:20 -0700 Eric Biggers <ebiggers@kernel.org> wrote:

> On Sat, Oct 24, 2026 at 12:31:08AM +0800, Tzu-Ching Yang wrote:
> > unrolled and unrolled_none are object-like macros with lower-case
> > names, and neither has had a user since commit c6594d642717 ("unroll:
> > add generic loop unroll helpers") added them in February 2025.
> > 
> > The name unrolled also breaks code that uses it for something else. On
> > GCC the macro expands to an empty _Pragma(), so a function parameter
> > named unrolled compiles with only -Wunknown-pragmas warnings (errors
> > only with CONFIG_WERROR) and silently loses its name:
> > 
> > 	int add(int unrolled, int x) { return unrolled + x; }
> > 
> > builds as "return x;" with GCC 11 to 16 (GCC 8 to 10 and Clang reject
> > it).
> > 
> > Drop both macros, and retitle the kernel-doc comment from unrolled to
> > unrolled_count(), the macro its usage example shows. unrolled_full and
> > unrolled_count() stay; any clash with their names fails to build
> > instead of compiling silently.
> > 
> > Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> > Link: https://lore.kernel.org/all/3c25921c-7bdf-4edd-ba06-838dd1765db6@intel.com/
> > Signed-off-by: Tzu-Ching Yang <shingekinocore@gmail.com>
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> 
> > v2: drop the two unused macros instead of making all three
> > function-like (Alexander Lobakin).
> > v1: https://lore.kernel.org/all/20261016025613.2690485-1-shingekinocore@gmail.com/
> > 
> > Eric, this version no longer touches lib/crypto/. Would you still
> > take it through libcrypto-next, or should it go through Andrew's -mm
> > tree (unroll.h has no MAINTAINERS entry)?
> 
> Either way is fine with me.  It's one of the unowned files, which are
> always problematic.  If Andrew hasn't taken it by the time -rc1 rolls
> around, I'll apply it to libcrypto-next: it's at least somewhat related,
> given that lib/crypto/ is one of the few users of this file.

That sounds good.

I'm only looking at bugfixes at present.  Non-fixes get parked for
consideration after -rc1.
