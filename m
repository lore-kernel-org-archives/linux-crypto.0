Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD1F3CEBBB;
	Fri, 15 May 2026 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840520; cv=none; b=gfw/IrQ+l59tHXp1f3IH7D+rjEQ7nQqRl4IOw+/1Z+m34x93WMH34Zrdps/ewY5+nsL+Hda9M17q0yLd7LDJU5MqJ3KWT/blWREoBzEF0G7diWua1IPjHO/cGxGD+TxVI4yohGZaRHxBMlzydADIraUFTgv6Pv5NoEaRR+C5KTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840520; c=relaxed/simple;
	bh=FNQbCszXn1lXrF0MIgFLqTzmslxdk7McF9XPjXK3dk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArezWE2rJhdQUabxMXLtDNpn4tMeWPRfI1WhyFv7Q3M2TyOOLRBzTOG1Ve9zs5j3HNStlScGpyhivsENE4iDicUxNaeQJq6M0RKDbTfKgk5GxxPjyArvaI+gkI3aBjXrb8Cc1qRNAgO5A95i+ItFU52hgomVLhC605xZHolIfQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=muqpa87E; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="muqpa87E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=We9RzyvGl3MkSSgy4vLa484VBOEq02HNY/PHtIwwF64=; 
	b=muqpa87E1Vc5P4BduXKoiYJtnx3tQToigwvB8aKjLQvD2904PnXVH0Y2zMud+HKhez3loV3vOmy
	V8BOh1q6ZpqxBJD57LISi1OpMzk47gyUBXR5ty2LaRNCJAz4lW7BJOU2/VsRHwTDYgw71ARqWFwrI
	3LoFA5OdTRjmHpAe20QgugNygnEeB2DSMheaQZj7tykK3yNm+RBaJiEEZ7OqbdtMq+5G0BMOWtQQ2
	LyAIrPM91AGvjQPoeffExU3ITMsSV3RHsTSD04YV4uodukkb34DMggyOXlXZbomE/LVohia0VXhvc
	l9g/UBRERgY8Ts4HIMBsf4TTWNWXS02Q877g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpfc-00EOVV-0A;
	Fri, 15 May 2026 18:21:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:21:28 +0800
Date: Fri, 15 May 2026 18:21:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <agbzqJUnMynmxSy3@gondor.apana.org.au>
References: <7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de>

On Wed, May 06, 2026 at 03:27:49PM +0200, Lukas Wunner wrote:
> Andrew reports build breakage of arm allmodconfig, reproducible with gcc
> 14.2.0 and 15.2.0:
> 
>   crypto/ecc.c: In function 'ecc_point_mult':
>   crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> 
> gcc aggressively inlines functions called by ecc_point_mult() (without
> there being any explicit inline declarations), which pushes stack usage
> close to the limit imposed by CONFIG_FRAME_WARN.  allmodconfig implies
> CONFIG_KASAN_STACK=y, which increases the stack above that limit.
> 
> In the bugzilla entry linked below, gcc maintainers explain that gcc
> estimates extra stack usage caused by inlining, but ASAN instrumentation
> is added in post-IPA passes and thus the inlining heuristics cannot
> account for it.
> 
> It could be argued that -Werror=frame-larger-than=1280 instructs the
> compiler to avoid inlining beyond that limit lest the build breaks,
> which would imply gcc behaves incorrectly.  But gcc maintainers reject
> this notion and believe that a warning switch should never affect code
> generation, even if it is promoted to an error.
> 
> One way to unbreak the build is to limit inlining via -finline-limit=100
> or by explicitly declaring some functions noinline.  However while it
> does keep stack usage of individual functions below the limit, *total*
> stack usage increases.
> 
> A longterm solution is to refactor ecc.c for reduced stack usage.  It
> currently performs ECC point multiplication with a Montgomery ladder
> which uses co-Z (conjugate) addition to trade off memory for speed.
> The algorithm is susceptible to timing attacks and needs to be replaced
> with a constant time Montgomery ladder, which should consume less memory
> and thus resolve the stack usage issue as a side effect.
> 
> In the interim, raise the limit for ecc.c, as is already done for
> several other files in the source tree.
> 
> Constrain to gcc because clang 19.1.7 does not exhibit the issue.  It
> makes do with a 724 bytes stack frame even though it inlines almost the
> same functions as gcc.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
> Reported-by: Andrew Morton <akpm@linux-foundation.org> # off-list
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Changes v1 -> v2:
> * s/ARCH/CONFIG_ARM/, s/LLVM/CONFIG_CC_IS_GCC/ (Nathan)
> * Add link to gcc bugzilla entry
> * Rewrite commit message to include feedback provided by gcc maintainers
>   and explain high stack usage with algorithm choice
> 
> Link to v1:
> https://lore.kernel.org/r/abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de/
> 
>  crypto/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
