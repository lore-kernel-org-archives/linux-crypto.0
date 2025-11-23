Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210E25BEE7;
	Sun, 23 Nov 2025 09:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763890147; cv=none; b=gmX5n4oSsRLLQ8u5xsozxtEVpVR7sIquj0xSh8uQXcVrEYwzSlXLtgA+M5TvyChj9/hT52IKIC+GBXMAB3CIa3nMS9KtiE//2xlPEzT+9an8DAESu07wF7jmFg24+6hS7XtWklwiHoPuWypeZ/5yXghKaALWl7uApW+1jxWzt9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763890147; c=relaxed/simple;
	bh=PnwaACKZjjfa29Eyj+ttTsRhghqB7BJlARSIwhCTDTM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzBKXUySe6IsSmVkIkfzxx/l73XO2dSBm/Gxy6WQKEL9rqYuIlAPiGwqEkgXcxy9G3sc+K7LZvLnviljfwTEDbsufhqs54KZQapYNktt6ezx4Bq4wcLzr/QdWw5W69GgoJr7w/4OEvi/MhdxTYpq46TXlzYpvH32U9rF6bSAZ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=igviN+66; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="igviN+66"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vN6Oy-00HINb-LM; Sun, 23 Nov 2025 10:29:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=FgUfPvc6rY6EXgpu2UxSBdI4N8PzOlsN/a51kE6vAho=; b=igviN+66Ekn2Vd1KlO6JAKDrsb
	xJiGmnYCovd0L1XQyGOMiNBQSxv2gVBF7w6TPUakemEXnl5/fhUEa9R6EFJZBSHUZO/jr/BQota79
	WULm3fG8xW/3tKMr+FA1+/1Q54SBaqWq/JyFpSzMeh0EAZN8jXWkSj2Lexgjq+NnzoelI8l7cFaAw
	9Vs4xgmE4uT8KHV9zBRWNt02Pd16dAEAd5OqyBOolkXl+YNnbsdnteL3J8ijAhtZxSzxtCUBU10wa
	KMSIX5fFcuEnQcBjGLBVWOsOXo3baTutOX25br8pR5VjS3yR4E9ENzOiLJ9nowex+j6WXggEkcJMv
	Q9OOYTYg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vN6Ox-0006wi-OV; Sun, 23 Nov 2025 10:28:59 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vN6Og-005oqp-LH; Sun, 23 Nov 2025 10:28:42 +0100
Date: Sun, 23 Nov 2025 09:28:40 +0000
From: david laight <david.laight@runbox.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC
 < 12.2 on i386
Message-ID: <20251123092840.44c92841@pumpkin>
In-Reply-To: <20251122105530.441350-2-thorsten.blum@linux.dev>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 22 Nov 2025 11:55:31 +0100
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> The GCC bug only occurred on i386 and has been resolved since GCC 12.2.
> Limit the frame size workaround to GCC < 12.2 on i386.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  lib/crypto/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index b5346cebbb55..5ee36a231484 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -33,7 +33,11 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
>  
>  obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
>  libblake2b-y := blake2b.o
> +ifeq ($(CONFIG_X86_32),y)
> +ifeq ($(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),y_)
>  CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
> +endif # CONFIG_CC_IS_GCC
> +endif # CONFIG_X86_32

Isn't that just going to cause a run-time stack overflow?
The compile-time check is a vague attempt to stop run-type overflow by limiting
the largest single stack frames.

I can't remember the kernel stack size for x86-32, might only be 8k.

The only real solution is to either fix the source so it doesn't blow
the stack (I suspect the code is 'unrolled' and the spills everything
to stack - making it slow), or just disable the code from the build.

	David


>  ifeq ($(CONFIG_CRYPTO_LIB_BLAKE2B_ARCH),y)
>  CFLAGS_blake2b.o += -I$(src)/$(SRCARCH)
>  libblake2b-$(CONFIG_ARM) += arm/blake2b-neon-core.o

