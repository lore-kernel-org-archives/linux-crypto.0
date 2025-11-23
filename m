Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D01115ECD7;
	Sun, 23 Nov 2025 18:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763924323; cv=none; b=aIgcZgpekTbU4TspvUaHrNdWg5RTIfXpCBthcAaqhtLZVKaVJ9oOMktzOmvxp6i4+DkjC0F47jcHmulIQhnUEx2Nauv+nNECRC5kflU78R/RMENFIKdb8HhwRYY8lwA+5LCg9oZXHUxmhtX78PWjes4578K4qyLyePyhv+uhn6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763924323; c=relaxed/simple;
	bh=igwEGIP9sI/tScnsxLM7CnQ5F4m6o3cnUe+A88ktJ80=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwC1tqr3S4DKKcT9cu+cofr2vClYB+tz2FzgozGS4cHtUko76o8mqmfcwML8vEQpp24/ib+1mqPgu2fTiBZwpcw+miCilxV8UYST1DWuywFmLrJ/U9qNrJb1CDW0zHLyjcMTZAIMHiNzeYAdchmbOVgtMdOpLqbdnYVfZBqUzz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=y1USfPpv; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="y1USfPpv"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vNFI1-0013Jo-2S; Sun, 23 Nov 2025 19:58:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=eyKgno22sjhimDL9lCY9EBgELW5CDvjUmKzw7NqWuqI=; b=y1USfPpvhv2YMPa5v0sQ9yzzJl
	E7HsvEUtkn5TyrNgWxvTVyoGrzfCV7Brj9ZtmnNpPfaZ0kMYJk44rLmRyO2yMwiq5CBvhXsPWYb/U
	SSu1NO+be9t75Vz2L4zZGumUGK5c5b3Bk4+jHBRIJ3PGl2jO1chwoHW/kctQgkXq8uKuaQ++pRVym
	Of7Hf0tZ6OHajCdnZIl9VuI7vJBTttHH5XRC1VrSqFiwFqN8ZsogToIajQV3YcK8r/joI6TUeZvas
	qGzxYgBoWI7DWO6EYpTXQ6qdGE9QRpIt4ydBM1tQDINQkQ+/t+wpt1RpxixWm+YeJSCkGtS1bUOeF
	fxhxQ/kw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vNFI0-0002yQ-GL; Sun, 23 Nov 2025 19:58:24 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vNFHw-007q4l-2M; Sun, 23 Nov 2025 19:58:20 +0100
Date: Sun, 23 Nov 2025 18:58:18 +0000
From: david laight <david.laight@runbox.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC
 < 12.2 on i386
Message-ID: <20251123185818.23ad5d3f@pumpkin>
In-Reply-To: <0EA9C088-D1B1-4E6E-B42F-EFE9C69D1005@linux.dev>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
	<20251123092840.44c92841@pumpkin>
	<0EA9C088-D1B1-4E6E-B42F-EFE9C69D1005@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 23 Nov 2025 18:00:01 +0100
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> On 23. Nov 2025, at 10:28, david laight wrote:
> > On Sat, 22 Nov 2025 11:55:31 +0100
> > Thorsten Blum <thorsten.blum@linux.dev> wrote:
> >   
> >> The GCC bug only occurred on i386 and has been resolved since GCC 12.2.
> >> Limit the frame size workaround to GCC < 12.2 on i386.
> >> 
> >> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> >> ---
> >> lib/crypto/Makefile | 4 ++++
> >> 1 file changed, 4 insertions(+)
> >> 
> >> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> >> index b5346cebbb55..5ee36a231484 100644
> >> --- a/lib/crypto/Makefile
> >> +++ b/lib/crypto/Makefile
> >> @@ -33,7 +33,11 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL) += gf128mul.o
> >> 
> >> obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
> >> libblake2b-y := blake2b.o
> >> +ifeq ($(CONFIG_X86_32),y)
> >> +ifeq ($(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),y_)
> >> CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
> >> +endif # CONFIG_CC_IS_GCC
> >> +endif # CONFIG_X86_32  
> > 
> > Isn't that just going to cause a run-time stack overflow?  
> 
> My change doesn't cause a runtime stack overflow, it's just a compiler
> warning. There's more information in commit 1d3551ced64e ("crypto:
> blake2b: effectively disable frame size warning").
> 
> Given the kernel test robot results with GCC 15.1.0 on m68k, we should
> probably make this conditional on GCC (any version). Clang produces much
> smaller stack frames and should be fine with the default warning
> threshold.

But if anyone tries to run the kernel they'll need space for the '3k monster stack'.
So changing the limit is 'fine' for a test build, but not for a proper build.
(Yes this has been wrong since Linus did the original patch in 2022.)

Does allmodconfig set COMPILE_TEST ?
If so that could be included in the conditional.

A more interesting question is whether the change can just be removed.
I'd guess no one is actively using gcc 12.1 any more.

	David

> 
> I'll send a v2.
> 
> Thanks,
> Thorsten
> 
> 

