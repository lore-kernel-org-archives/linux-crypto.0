Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F96282F1B;
	Tue, 14 Apr 2026 04:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776142639; cv=none; b=BbbUze9nNcxec80vK59YuxAdmzq4ZYTgR7PG5Dv3LuI3eA7wC1rznNXhFiLKan2hC+23FX75b9SdvIgguCM6NkdjO4Tel3eoLAocR1ChJ3dsXxI5GcW0Wuxdy1VWT3g/fUMGq+DGIosbYOVgFzDBHHsTnrUbB2OiwrtCSbaszWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776142639; c=relaxed/simple;
	bh=YcFE1zTR0VoQmKhg4DX9tQnbK7qDKMKvLXxtRbRWo2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OzBQEGwR5G19FEkIafcvRGXsnSVGvD85l9GSsclLyj9hMHygeNXJIR2fsK/2sPZzkQ/4T5Xsr/IK80As8LnXhe4YSYil/syxiySX8PcUvsvBhgj8ZvEwVrSFFA3RT4TI2Huo1aZuMWs22LkEJgznxWZQNjchZcRVl4NQCE37czQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 2A7D01062F;
	Tue, 14 Apr 2026 06:57:12 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 0A0BB6032450; Tue, 14 Apr 2026 06:57:12 +0200 (CEST)
Date: Tue, 14 Apr 2026 06:57:12 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <ad3JKOrZcvJoerSP@wunner.de>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <adY8iUPrnoXDp_-g@ashevche-desk.local>
 <adZZ70lNnhoDnwok@wunner.de>
 <05d3e296-1b61-4ab4-9bec-6c11407e6f89@app.fastmail.com>
 <ad1IHo1rkVxqeMkc@wunner.de>
 <d82181fe-a70d-4c64-a411-4bf80c51f58f@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82181fe-a70d-4c64-a411-4bf80c51f58f@app.fastmail.com>

On Mon, Apr 13, 2026 at 10:32:24PM +0200, Arnd Bergmann wrote:
> On Mon, Apr 13, 2026, at 21:46, Lukas Wunner wrote:
> > On Mon, Apr 13, 2026 at 05:42:39PM +0200, Arnd Bergmann wrote:
> > > On Wed, Apr 8, 2026, at 15:36, Lukas Wunner wrote:
> > Attached please find the Assembler output created by gcc -save-temps,
> > both the original version and the one with limited inlining.
> >
> > The former requires a 1360 bytes stack frame, the latter 1232 bytes.
> > E.g. xycz_initial_double() is not inlined into ecc_point_mult(),
> > together with all its recursive baggage, so the latter version
> > contains two branch instructions to that function which the former
> > (original) version does not contain.
> 
> So it indeed appears that the problem does not go away but only
> stays below the arbitrary threshold of 1280 bytes (which was
> recently raised). I would not trust that to actually be the
> case across all architectures then, as there are some targets
> like mips or parisc tend to use even more stack space than
> arm. With your current patch, that means there is a good chance
> the problem will come back later.

The only 32-bit architectures with HAVE_ARCH_KASAN are:
arm powerpc xtensa

I've cross-compiled ecc.o successfully in an allmodconfig build for
powerpc and xtensa, so arm seems to be the only architecture affected
by the large stack frame issue.

Maybe mips and parisc will see the issue as well but they'd have to
support KASAN first.

The problem is that gcc *knows* that it should warn when the stack
goes above CONFIG_FRAME_WARN and that warning is even promoted to
an error, but gcc happily keeps inlining stuff and goes beyond that
limit.  My expectation is it should stop inlining before that happens.
clang doesn't have the same problem.

Completely disabling KASAN for this file doesn't seem like a good option
as this is security-relevant code.  On the other hand disabling inlining
for this file isn't great either because I recall Google is dogfooding
KASAN on internally used phones, I imagine it would ruin performance
for such use cases (granted those are likely arm64 devices).

*Limiting* inlining strikes a middle ground between those two extremes.

And I don't want to annotate individual functions as noinline only
because gcc does stupid things on a single architecture.

Thanks,

Lukas
