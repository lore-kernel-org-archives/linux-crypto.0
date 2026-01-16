Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D67533C538
	for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 18:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588670; cv=none; b=eQPPJnccbdMzhDQkc3LVJgTxLkyAMGIGfrhzVrLtYPnpx8DpBy0XBgwsBfRLIUgbcNCqVDh99hP69WCgFCRg9rkR3NQA3A6oH8Tr1vHKvxmwMsciFEtY0DRyGbAtXcqP+UuU3D4XX0qj3c6/pLHP9WB2byHz8lWBhCDnfv8eEQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588670; c=relaxed/simple;
	bh=e8O0uP+bSuxQZFcEHJAVNiI9qtjq1dxa+N0HruY2qKA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SN0OijmUQLmQ2JwKsMsSCbE6usC0+Ejn0CFLqbRzy+f/D/ryJWRWODSf8Rh1/pJ2CUBS4D9+anao5pWCL94v0fKT+tk8npQDGxc+XgoYs0mluWMkwF/jwhv04iPsTc/Dskpabfgu8NlWuXGMPzCH4QJNPZaLGZBX4MZSGPaIqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6xpsHVw; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6xpsHVw"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-480142406b3so11593595e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 10:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768588667; x=1769193467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GD6pvvj/iogQeA3gj9lrZ7wkPbItb9cU4hB1qrUHMUw=;
        b=W6xpsHVw+jMoCx3ZDMP92tFwlDAX5nP0XITiTRL+A9HSwkdZEDcMuFAnWktLWiqnpN
         hlyrtcniZISGaZT6smKt0YSOnlN5uaKR4kQmWwsKO36rY7TcXwHFm6gGVJzIpEtbACP5
         Qn4VvCdPpVW1LMb/8bzzZsJpXQpV5N0NvizRFJ5ST8Hi5hpFwvTEgkmyeKWt0nacWBCL
         SzNE1S/+vUcGEujTsEkwNfpOORZkzEDjxAGtmiOlALuusLtSDpbW9YedlK+HwdC1bUvZ
         YMhwkhonSvx1nnzTDdF11LJsFJg4Xm8RvVtXZTWAcdDrXO3wcNh4iKcAB1Uq/U8F8rjt
         edKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768588667; x=1769193467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GD6pvvj/iogQeA3gj9lrZ7wkPbItb9cU4hB1qrUHMUw=;
        b=qlwVvlt0ozzxxSWnJF3o+cQUKpxY8IzVEn3uX6XvfNmRvKaFFhNOWNm6yeDijjNzgI
         Sjto+eyYF77bMrOMSHjKiW70EM5KJD4gWmuW9Rc9eGkaIfmtOZp3jFr7rOxA+Gn1tAqA
         RC4avXxGTs7S6ALk1qvrPLpL0X9NTYO6+BkTkP8GTlXC08bxBh7MUCqTXHDc0L0q76b6
         W48009+5edfbUIXiWoJpK8XTJepRZBwT1SV6sIG1VnaXkEyI6Js51EBA3mQuXJZtAA8P
         tQOfJSwStau+z/+f1rLSy62CXenfGU4mw0KcLO4cPxw/P8qWUexrEf3YFq9YKg2aVDlp
         VS0A==
X-Forwarded-Encrypted: i=1; AJvYcCVGBfxczooufHdgZYV+a1jmbYYmBxlsgOefJWHDxC2qlwHRJbju+qeAM5AZxBn3FlomwT/LUQW/Wuh7vZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK66vVtjCpAmNxXok2uCMlypm0YBhQgrU19dMgjUPOPK6PZUQw
	JwyWClpDKq8jpDnUPOld5g2FNl+kKx1NI6ZMA33xh4NFe+SMgzJG5tcKb0iIAg==
X-Gm-Gg: AY/fxX56RJDHq+mg5lvfU9gNcAwMpSsd+aHS5CidICWA3nVF8X6krC5KkfprkYUTYQX
	PyPi9ET7WfHJo7ZUHDFnhga7IoUzgkpZMpUjsD0JT1KhsKjP5r8GHauapKIuKekUM452NESeCtx
	FW6D0ESq5rhQiBSipUzH54bympKMvegvUusIyTYjqpQq6PUGCyF/QmRQ9+8x03XZH/2uro7bmEk
	eISwdNyCDPBRCCB4uFNDjqp8KjEacImcJyYzw117wYZ/xbkvVuiiqxey+c6ieXQqoWL1TCdhvVc
	D5lH3IiVeOJmz53Kz1K7twcxzqFDu1zRHYS/dTqHiKzW18jOKkQSQn3QiPsaEeRsq0h7f86TwBI
	9Omn23dzrW/YCUW2pvZw64tq93hp51HL7OvHOl1fwfOO4boE0Ef2R5OAKD+btlBOhrgC6jsx2fB
	3yDV3oIliS5qcL/60H+iL668NX3yOtpkz9v1TgaDNrnXhpsHm3453b
X-Received: by 2002:a05:6000:2584:b0:431:b1e:7ff9 with SMTP id ffacd0b85a97d-43569bd2ab0mr4014733f8f.59.1768588666492;
        Fri, 16 Jan 2026 10:37:46 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356992201csm6906850f8f.2.2026.01.16.10.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 10:37:46 -0800 (PST)
Date: Fri, 16 Jan 2026 18:37:44 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Harald Freudenberger <freude@linux.ibm.com>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260116183744.04781509@pumpkin>
In-Reply-To: <389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
	<20260115183831.72010-2-dengler@linux.ibm.com>
	<20260115204332.GA3138@quark>
	<20260115220558.25390c0e@pumpkin>
	<389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jan 2026 18:31:58 +0100
Holger Dengler <dengler@linux.ibm.com> wrote:

> Hi David,
> 
> On 15/01/2026 23:05, David Laight wrote:
> > On Thu, 15 Jan 2026 12:43:32 -0800
> > Eric Biggers <ebiggers@kernel.org> wrote:  
> >>> +static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
> >>> +{
> >>> +	const size_t num_iters = 10000000;    
> >>
> >> 10000000 iterations is too many.  That's 160 MB of data in each
> >> direction per AES key length.  Some CPUs without AES instructions can do
> >> only ~20 MB AES per second.  In that case, this benchmark would take 16
> >> seconds to run per AES key length, for 48 seconds total.  
> > 
> > Probably best to first do a test that would take a 'reasonable' time
> > on a cpu without AES. If that is 'very fast' then do a longer test
> > to get more accuracy on a faster implementation.
> >   
> >>
> >> hash-test-template.h and crc_kunit.c use 10000000 / (len + 128)
> >> iterations.  That would be 69444 in this case (considering len=16),
> >> which is less than 1% of the iterations you've used.  Choosing a number
> >> similar to that would seem more appropriate.
> >>
> >> Ultimately these are just made-up numbers.  But I think we should aim
> >> for the benchmark test in each KUnit test suite to take less than a
> >> second or so.  The existing tests roughly achieve that, whereas it seems
> >> this one can go over it by quite a bit due to the 10000000 iterations.  
> > 
> > Even 1 second is a long time, you end up getting multiple interrupts included.
> > I think a lot of these benchmarks are far too long.
> > Timing differences less that 1% can be created by scheduling noise.
> > Running a test that takes 200 'quanta' of the timer used has an
> > error margin of under 1% (100 quanta might be enough).
> > While the kernel timestamps have a resolution of 1ns the accuracy is worse.
> > If you run a test for even just 10us you ought to get reasonable accuracy
> > with a reasonable hope of not getting an interrupt.
> > Run the test 10 times and report the fastest value.
> > 
> > You'll then find the results are entirely unstable because the cpu clock
> > frequency keeps changing.
> > And long enough buffers can get limited by the d-cache loads.
> > 
> > For something as slow as AES you can count the number of cpu cycles for
> > a single call and get a reasonably consistent figure.
> > That will tell you whether the loop is running at the speed you might
> > expect it to run at.
> > (You need to use data dependencies between the start/end 'times' and
> > start/end of the code being timed, x86 lfence/mfence are too slow and
> > can hide the 'setup' cost of some instructions.)  
> 
> Thanks a lot for your feedback. I tried a few of your ideas and it turns out,
> that they work quite well. First of all, with a single-block aes
> encrypt/decrypt in our hardware (CPACF), we're very close to the resolution of
> our CPU clock.
> 
> Disclaimer: The encryption/decryption of one block takes ~32ns (~500MB/s).
> These numbers should be taken with some care, as on s390 the operating system
> always runs virtualized. In my test environment, I also only have access to a
> machine with shared CPUs, so there might be some negative impact from other
> workload.

The impact of other workloads is much less likely for a short test,
and if it does happen you are likely to see a value that is abnormally large.

> The benchmark loops for 100 iterations now without any warm-up. In each
> iteration, I measure a single aes_encrypt()/aes_decrypt() call. The lowest
> value of these measurements is takes as the value for the bandwidth
> calculations. Although it is not necessary in my environment, I'm doing all
> iterations with preemption disabled. I think, that this might help on other
> platforms to reduce the jitter of the measurement values.
> 
> The removal of the warm-up does not have any impact on the numbers.

I'm not sure what the 'warm-up' was for.
The first test will be slow(er) due to I-cache misses.
(That will be more noticeable for big software loops - like blake2.)
Change to test parameters can affect branch prediction but that also only
usually affects the first test with each set of parameters.
(Unlikely to affect AES, but I could see that effect when testing
mul_u64_u64_div_u64().)
The only other reason for a 'warm-up' is to get the cpu frequency fast
and fixed - and there ought to be a better way of doing that.

> 
> Just for information: I also tried to measure the cycles with the same
> results. The minimal measurement value of a few iterations is much more stable
> that the average over a larger number of iterations.

My userspace test code runs each test 10 times and prints all 10 values.
I then look at them to see how consistent they are.

> I also did some tests with IRQs disabled (instead of only preemption), but the
> numbers stay the same. So I think, it is save enough to stay with disables
> preemption.

I'd actually go for disabling interrupts.
What you are seeing is the effect of interrupts not happening
(which is likely for a short test, but not for a long one).

> 
> I also tried you idea, first to do a few measurements and if they are fast
> enough, increase the number of iterations. But it turns out, that this it not
> really necessary (at least in my env). But I can add this, it it makes sense
> on other platforms.

The main reason for doing that is reducing the time the tests take on a
system that is massively slower (and doing software AES).
Maybe someone want to run the test cases on an m68k :-)

	David


