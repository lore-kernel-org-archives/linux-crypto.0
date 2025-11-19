Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11A1290D81;
	Wed, 19 Nov 2025 23:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763593340; cv=none; b=P0VwCA8qFAo9rjGxoTFLQxRoyzSZnchhm+joOnMBKpxss4JcObvkqHBqqW4BoP+ArIihpaW9srlNWekAUwJgFa5MMVez2XzNB0MAzQwLpBjOBrFHOC7A+fI99/x0IMLvU1N4UubL/MUjhr9uIJNiPpKPokr0OBMvkOBF0z7mYng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763593340; c=relaxed/simple;
	bh=88ujur/zx2sS97Eo0R22GV6fR1pB4vFJWHNNkHMm5eE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fRYCaPfJxFR7BImW8lNEb2CEuDZaayy0Bx0ErVGnQrD8R7dpho0FroZCdV3RX9sxAOSB4f5kh8GYkC1XBqOisY/gL0kmkE16eYDKJjsvGdnYcy+l4WQyvt0MgTnw/0DSpV8jmCmYR6aM8xCDHfj5VClkrU33mzpwqpsofx4oaqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=GcPzQE3l; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="GcPzQE3l"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vLrBm-006ncP-TQ; Thu, 20 Nov 2025 00:02:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=DcR8ifpAjTY4p77mfshCTMj2URt2zXnkTzn9wnKCz8c=; b=GcPzQE3lvG5IXh1Th0OtyYB7f7
	GHHFtLJy9GF/Jp3E93kWKdwlZIjtpSUOuEnVQmIlroKLBsf6cF4XpkQ4GZmNDDSjJhsyMeK1zzA1q
	YlstTuTLKWpCVy2r9yMYx/UUsBwpd8AHyikAh7y215IiC2g114U+rea8XGdyUTERuI90/rNS5q5Rd
	YKdw7GYuCJ0QA12vr7BXuBSceh8sHjEuy+V5qcto3+I3dZNgZf8uwC0p3FQ+kGKvSwErUxpiEmnNY
	gz1wWkoJjgHok2XnP73gebv/Doqy7uyCdQC3Ig06lzBWxdOxnHj/SnHCrHRXPb/KcJh0SFn4EOXMY
	BeDwN48Q==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vLrBm-00010l-62; Thu, 20 Nov 2025 00:02:14 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLrBi-00Fqde-53; Thu, 20 Nov 2025 00:02:10 +0100
Date: Wed, 19 Nov 2025 23:02:05 +0000
From: david laight <david.laight@runbox.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Ard Biesheuvel <ardb@kernel.org>, Kees
 Cook <kees@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto 1/2] array_size: introduce min_array_size()
 function decoration
Message-ID: <20251119230205.2551d7eb@pumpkin>
In-Reply-To: <aR4UvNzdLLofbRpW@zx2c4.com>
References: <20251118170240.689299-1-Jason@zx2c4.com>
	<20251118232435.GA6346@quark>
	<aR0Bv-MJShwCZBYL@zx2c4.com>
	<aR4UvNzdLLofbRpW@zx2c4.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Nov 2025 20:04:28 +0100
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> On Wed, Nov 19, 2025 at 12:31:11AM +0100, Jason A. Donenfeld wrote:
> > There's also this other approach from 2001 that the C committee I guess
> > shot down: https://www.open-std.org/jtc1/sc22/wg14/www/docs/dr_205.htm
> > It is basically:
> > 
> >     #define __at_least static
> > 
> > We could attempt to do the same with `at_least`...
> > 
> > It kind of feels like we're just inventing a language at that point
> > though.  
> 
> Actually, you know, the more this apparently terrible idea sits in my
> head, the more I like it.
> 
> Which of these is most readable to you?
> 
> bool __must_check xchacha20poly1305_decrypt(
>         u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
>         const size_t ad_len, const u8 nonce[min_array_size(XCHACHA20POLY1305_NONCE_SIZE)],
>         const u8 key[min_array_size(CHACHA20POLY1305_KEY_SIZE)]);
> 
> bool __must_check xchacha20poly1305_decrypt(
>         u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
>         const size_t ad_len, const u8 nonce[static XCHACHA20POLY1305_NONCE_SIZE],
>         const u8 key[static CHACHA20POLY1305_KEY_SIZE]);
> 
> bool __must_check xchacha20poly1305_decrypt(
>         u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
>         const size_t ad_len, const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
>         const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);

While bikeshedding...
I'd drop the pointless 'const' and always try to put a ptr/len pair on the same line.
So end up with:
bool __must_check xchacha20poly1305_decrypt(u8 *dst, const u8 *src, size_t src_len,
	const u8 *ad, size_t ad_len,
	const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
	const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
or perhaps:
bool __must_check xchacha20poly1305_decrypt(u8 *dst,
	const u8 *src, size_t src_len, const u8 *ad, size_t ad_len,
	const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
	const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
but I don't know what defines the length of '*ad'.

	David

> 
> The macro function syntax of the first one means nested bracket brain
> parsing. The second one means more `static` usage that might be
> unfamiliar. The third one actually makes it kind of clear what's up.
> It's got that weird-but-nice Objective-C-style sentence programming
> thing.
> 
> Would somebody jump in here to tell me to stop sniffing glue? I feel
> silly actually considering this, but here I am. Maybe this is actually
> an okay idea?
> 
> Jason
> 

