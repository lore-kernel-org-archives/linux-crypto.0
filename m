Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39702D9ECB
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 22:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768514764; cv=none; b=OtUGipDvkhZvyvIotT2GoqXtWcc5+79DXL1i5j+U9HFqnjwwQh3e1zUb9PhRKjiaRI5EDTiVrwoHl6Mx+AKu6NNeAYhG1Itq7QdtUj8UR0LZtBQl9bb/cDOCFq9jtVq1GMVuu3K1m05u1PnGnSioeAwN7skR/063akw+RaZEBcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768514764; c=relaxed/simple;
	bh=ZWIuM04AmcIscBwNxVrUJXX4VtiVhK1Gk/k+k9ASlng=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nccqKxQhUipkWLNEWRUXOsw2SQ6u+hG6D5M86S5c3I90bppvTMb4Y70Ds0qsHzEqe+Z4DozLFIl0MxMLB/b//CNuoBWoaqfVDAit1fi3E+ckLp5rocbkh1MmqhGZjRP8GHzH4euZyx2pFRwnkpq5OfW3tf4P1DmlG1LU1C0NBlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U78eq0FO; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U78eq0FO"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so11936265e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 14:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768514760; x=1769119560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Id+pE7SbpHLdYwZjxBlIpVr8x+vyB+vrOBYbXnFm1xc=;
        b=U78eq0FONl2pOXKyRd/mAel6z6cO1NxmbweeWP1sQYlrSTaj0R509RJ3qqYGEhBir4
         lDztJOVu1sl415NDldKLfH3l6kbR1Wly5qibFKwBzmersbDIBOcICiMBBCM7sZRSkF4q
         4XlouAm5fHA1nnLncJTWO5zGFzrBYrhJN++0+OkVe8N2+lC0xj2qIWkUZ7EdyFk2cbEp
         +zKaXvJuNFuFJKilxldlq5XmEO6l/u+VKmnw9SRVzeGdC1M/6CX4x+RsMde8pl2mAlsd
         DRvQVIT3aOe11jBPJ3LD95NhSIJFkSFSUoiX2L3UfrAhyBvE7IipAkMQNfTSh+6UHWu6
         zyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768514760; x=1769119560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Id+pE7SbpHLdYwZjxBlIpVr8x+vyB+vrOBYbXnFm1xc=;
        b=BTuLdIBzabXoOxaVI14Uazh0ATthZghIoILDMP1nZOZUQIvbuH+uBBbgV3f7a9L9aC
         We41SPKCS6NAJIGQy4x6gUcpZvZE33Kshvqm2KDD8BosjR0X6kw8JaP7K+6WFMYA56Kf
         fmr8kc0WulNkxzDX9sKDhNrY1cAbuUd02lbxDyiCFr763en9/4Joiy7mX/EVx/fYV+I/
         xh2Q9j5hB+bNNuIJPQ6BuIMYBvLQpOSvYrA2hW384oiVMN6uGCLy8vBd/P7Mq1c9IydD
         7BfE/XAS9v9rGcBvLmaTpDY9N/LUoaHOs4Gx5bekGly3rEH35IEkitAwnEd35ym+3ux3
         sM4g==
X-Forwarded-Encrypted: i=1; AJvYcCWjpWJg6iM5GZ/uA1Nz5o05Yon5mMzS/ygLTTg5lg6qjjIt/9UjB2oZ2oao7OQmMZvW2ovrAg7N/2t40oY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU8WW/4u2A3D1GbuW6LK42M9qOuCHQzpV4BG1R0heweDJEW8hk
	u4IE6u56Kr0W+gIc9wF1EzGsJ8V5mUqLJ2kjC9pYsHV7hCyQyKZ4mRat
X-Gm-Gg: AY/fxX5Wx6lPbIgQns6e99MxFJzsIWuEjsVHhOoFUGyoVtICWg1hSHy3avOhRlr5waM
	cRzp4RJcWSMK0sSaPFShQPHyisxDPm23fK3nunyBiae1V3KZDicnkh7yx7X2mmSg0AToW32CbWj
	KjCgy0+DR0XCq91XoHiG+fokrfM5+W8j0TLb0t4KX3AJdXJxMUsUQ+TiKi0KryKAGYsEVtb7B1E
	xl+ofRm4O6ypCSZd2OzDs7Of+OOU16GZrHrEpHY3G0UtfTKNQQtjMH+dhnqs1vdL8ZDY66jbqSS
	i2cFs1/Y/eT3IXYrFRDr9SBmFUO8oZULFgnpCCpT4dCar6gPeRBO0qxW+rca2cKPXgdFfq0okr7
	6XHD1ld8OqDLa6qvIcFH8d3xtftlPedYa+nIjqt5izSqx2HBclqF3PAodGEel8MNhw1OXaN5Pb1
	6FcWutHRQq9OHWCNuTXWCpFg09eD5kvYEqbv1M4hxW6cdgn3W6JQ+6
X-Received: by 2002:a05:600c:1e2a:b0:47d:4047:f377 with SMTP id 5b1f17b1804b1-4801e34b48emr15181725e9.36.1768514760098;
        Thu, 15 Jan 2026 14:06:00 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48020312253sm1407125e9.14.2026.01.15.14.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 14:05:59 -0800 (PST)
Date: Thu, 15 Jan 2026 22:05:58 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Holger Dengler <dengler@linux.ibm.com>, Ard Biesheuvel
 <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Harald Freudenberger <freude@linux.ibm.com>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260115220558.25390c0e@pumpkin>
In-Reply-To: <20260115204332.GA3138@quark>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
	<20260115183831.72010-2-dengler@linux.ibm.com>
	<20260115204332.GA3138@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jan 2026 12:43:32 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> On Thu, Jan 15, 2026 at 07:38:31PM +0100, Holger Dengler wrote:
> > Add a KUnit test suite for AES library functions, including KAT and
> > benchmarks.
> > 
> > Signed-off-by: Holger Dengler <dengler@linux.ibm.com>  
> 
> The cover letter had some more information.  Could you put it in the
> commit message directly?  Normally cover letters aren't used for a
> single patch: the explanation should just be in the patch itself.
> 
> > diff --git a/lib/crypto/tests/aes-testvecs.h b/lib/crypto/tests/aes-testvecs.h
> > new file mode 100644
> > index 000000000000..dfa528db7f02
> > --- /dev/null
> > +++ b/lib/crypto/tests/aes-testvecs.h
> > @@ -0,0 +1,78 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _AES_TESTVECS_H
> > +#define _AES_TESTVECS_H
> > +
> > +#include <crypto/aes.h>
> > +
> > +struct buf {
> > +	size_t blen;
> > +	u8 b[];
> > +};  
> 
> 'struct buf' is never used.
> 
> > +static const struct aes_testvector aes128_kat = {  
> 
> Where do these test vectors come from?  All test vectors should have a
> documented source.
> 
> > +static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
> > +{
> > +	const size_t num_iters = 10000000;  
> 
> 10000000 iterations is too many.  That's 160 MB of data in each
> direction per AES key length.  Some CPUs without AES instructions can do
> only ~20 MB AES per second.  In that case, this benchmark would take 16
> seconds to run per AES key length, for 48 seconds total.

Probably best to first do a test that would take a 'reasonable' time
on a cpu without AES. If that is 'very fast' then do a longer test
to get more accuracy on a faster implementation.

> 
> hash-test-template.h and crc_kunit.c use 10000000 / (len + 128)
> iterations.  That would be 69444 in this case (considering len=16),
> which is less than 1% of the iterations you've used.  Choosing a number
> similar to that would seem more appropriate.
> 
> Ultimately these are just made-up numbers.  But I think we should aim
> for the benchmark test in each KUnit test suite to take less than a
> second or so.  The existing tests roughly achieve that, whereas it seems
> this one can go over it by quite a bit due to the 10000000 iterations.

Even 1 second is a long time, you end up getting multiple interrupts included.
I think a lot of these benchmarks are far too long.
Timing differences less that 1% can be created by scheduling noise.
Running a test that takes 200 'quanta' of the timer used has an
error margin of under 1% (100 quanta might be enough).
While the kernel timestamps have a resolution of 1ns the accuracy is worse.
If you run a test for even just 10us you ought to get reasonable accuracy
with a reasonable hope of not getting an interrupt.
Run the test 10 times and report the fastest value.

You'll then find the results are entirely unstable because the cpu clock
frequency keeps changing.
And long enough buffers can get limited by the d-cache loads.

For something as slow as AES you can count the number of cpu cycles for
a single call and get a reasonably consistent figure.
That will tell you whether the loop is running at the speed you might
expect it to run at.
(You need to use data dependencies between the start/end 'times' and
start/end of the code being timed, x86 lfence/mfence are too slow and
can hide the 'setup' cost of some instructions.)

	David


> 
> > +	kunit_info(test, "enc (iter. %zu, duration %lluns)",
> > +		   num_iters, t_enc);
> > +	kunit_info(test, "enc (len=%zu): %llu MB/s",
> > +		   (size_t)AES_BLOCK_SIZE,
> > +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
> > +			     (t_enc ?: 1) * SZ_1M));
> > +
> > +	kunit_info(test, "dec (iter. %zu, duration %lluns)",
> > +		   num_iters, t_dec);
> > +	kunit_info(test, "dec (len=%zu): %llu MB/s",
> > +		   (size_t)AES_BLOCK_SIZE,
> > +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
> > +			     (t_dec ?: 1) * SZ_1M));  
> 
> Maybe delete the first line of each pair, and switch from power-of-2
> megabytes to power-of-10?  That would be consistent with how the other
> crypto and CRC benchmarks print their output.
> 
> > +MODULE_DESCRIPTION("KUnit tests and benchmark aes library");  
> 
> "aes library" => "for the AES library"
> 
> - Eric
> 

