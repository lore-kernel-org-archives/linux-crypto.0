Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD712F49EC
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 09:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763975347; cv=none; b=AzNYEl70T/S+GCLNrP8fTqwbYgo7xaKdcY2vObBPxUslPHrzwoR/n1OHxt1Au1wmduA0b+cxfHAPv3ak+Rzph3nDrPhOhcNJW6DrdZwaaumQTHlSXM9Uw3/DoG/BhfGtSXM3ISbz8VdaZNBsztze+3nyg/4xiq3N8Qg2wqS2zVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763975347; c=relaxed/simple;
	bh=lixkuGWHEExktJChSw5/KftuzOdUuejcJ1G1r1Q/1Ww=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cYY2n9y3uTzLQot3nG2uTtt0ZssKGt9kQIdE15ycsE+TMCabUmSabr4+dZe1o/+CQ+i7T+n0kSdRRal/1Rq+O+9mdRSJZTuh58jj5LMnhtdV0y6PKJ04nDFIkVjZMF82nbP7Qd2WEBmf7aynaR2U92/8dxcUZ8+s5Rw/TH55RsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=PhJAeAU3; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="PhJAeAU3"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vNSZ6-002ZRz-Pm; Mon, 24 Nov 2025 10:08:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=eGbnYzu/0fZhdMa02+0KV1H9vqvoF5RNx/fC04fnPQE=; b=PhJAeAU3Ll681gbQxK0nKaCKwx
	BpQ7qauOym5GIWcmY8zJKZ8UwHHBzDM1KURBRCKPXY59U75TZ23BzkoLBaLGEQ3VA2cDR9rEUDssH
	R2wgy5I6EwtDmsevIzQNLOqP6c7xzHx3pqUeYrY0orsmP97aGG0zbJWcWO1XsXQ0jHjbDQy3GRjig
	nnmXU+zB6l/kyM+y34oSElNR94qpigsrd6F1Bpf3FrWHE8Pb+MzfK+D8RnZOFvaPomB6j4/c0etTI
	+laAGzph25N+zKQq9xBOU0k63Gx0T98zh5OFjg3Thf7F/A5MfnyJCi94lRSQxBqGDeVTZsXecWlnw
	SyL0Iq8w==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vNSZ6-0001OW-4R; Mon, 24 Nov 2025 10:08:56 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vNSYy-008EoA-Iv; Mon, 24 Nov 2025 10:08:48 +0100
Date: Mon, 24 Nov 2025 09:08:46 +0000
From: david laight <david.laight@runbox.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC
 < 12.2 on i386
Message-ID: <20251124090846.18d02a78@pumpkin>
In-Reply-To: <20251123202629.GA49083@sol>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
	<20251123092840.44c92841@pumpkin>
	<0EA9C088-D1B1-4E6E-B42F-EFE9C69D1005@linux.dev>
	<20251123185818.23ad5d3f@pumpkin>
	<20251123202629.GA49083@sol>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 23 Nov 2025 12:26:29 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> On Sun, Nov 23, 2025 at 06:58:18PM +0000, david laight wrote:
> > On Sun, 23 Nov 2025 18:00:01 +0100
> > Thorsten Blum <thorsten.blum@linux.dev> wrote:
> >   
> > > On 23. Nov 2025, at 10:28, david laight wrote:  
> > > > On Sat, 22 Nov 2025 11:55:31 +0100
> > > > Thorsten Blum <thorsten.blum@linux.dev> wrote:
> > > >     
> > > >> The GCC bug only occurred on i386 and has been resolved since GCC 12.2.
> > > >> Limit the frame size workaround to GCC < 12.2 on i386.
> > > >> 
> > > >> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > > >> ---
> > > >> lib/crypto/Makefile | 4 ++++
> > > >> 1 file changed, 4 insertions(+)
> > > >> 
> > > >> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> > > >> index b5346cebbb55..5ee36a231484 100644
> > > >> --- a/lib/crypto/Makefile
> > > >> +++ b/lib/crypto/Makefile
> > > >> @@ -33,7 +33,11 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL) += gf128mul.o
> > > >> 
> > > >> obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
> > > >> libblake2b-y := blake2b.o
> > > >> +ifeq ($(CONFIG_X86_32),y)
> > > >> +ifeq ($(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),y_)
> > > >> CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
> > > >> +endif # CONFIG_CC_IS_GCC
> > > >> +endif # CONFIG_X86_32    
> > > > 
> > > > Isn't that just going to cause a run-time stack overflow?    
> > > 
> > > My change doesn't cause a runtime stack overflow, it's just a compiler
> > > warning. There's more information in commit 1d3551ced64e ("crypto:
> > > blake2b: effectively disable frame size warning").
> > > 
> > > Given the kernel test robot results with GCC 15.1.0 on m68k, we should
> > > probably make this conditional on GCC (any version). Clang produces much
> > > smaller stack frames and should be fine with the default warning
> > > threshold.  
> > 
> > But if anyone tries to run the kernel they'll need space for the '3k monster stack'.
> > So changing the limit is 'fine' for a test build, but not for a proper build.
> > (Yes this has been wrong since Linus did the original patch in 2022.)
> > 
> > Does allmodconfig set COMPILE_TEST ?
> > If so that could be included in the conditional.
> > 
> > A more interesting question is whether the change can just be removed.
> > I'd guess no one is actively using gcc 12.1 any more.  
> 
> How about we roll up the BLAKE2b rounds loop if !CONFIG_64BIT?

I do wonder about the real benefit of some of the massive loop unrolling
that happens in a lot of these algorithms (not just blake2b).
It might speed up (some) benchmarks, but the 'I-cache busting' effect
may well some down any real uses - especially on small/moderate sized buffers.
Loop unrolling is so 1980s...

And that is an entirely separate issue from any register spills.
If the compiler is going to spill to stack the benefits of unrolling are
likely to disappear - especially on a modern 'out of order' and 'multi issue'
cpu.
On x86 you normally get any 'loop control' for free, normal loop unrolling
is pretty pointless except for very short loops (you can't do a 1 clock loop).

Register pressure on a 32bit cpu doing 64bit operations is immense.
Worse for old architectures with very few registers - x86 can only hold
three 64bit values in registers.
So the compiler ends up spilling 'temporary' values from the middle of
expressions as well as all obvious named variables.

So yes, rolling it up (or not unrolling it) on 32bit is a good idea.

	David


> 
> - Eric

