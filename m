Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE13B9929
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781564263; cv=none; b=o81vlfmMgK4PSD8NMf8Em8CbZUMXfz2nlERl/jxCYKF7CD1EoJldT0t6RDR7vqAXshAsb9HNIQ38uPDdPyAoM5CTnAL9Tv10Cq30FybfpjrhK2jBuxIvg37NfFVGmXP4aHs0a6D3wSiascdmkIn3cY7u19fGKzQbeZUaCXg46+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781564263; c=relaxed/simple;
	bh=xlDI29oAJ/RkZP2O27U2v7nIGJegpCQFhPSOGe1YZRo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxNC5H1dAT43wcz6ncpFLnVLbVHwAdkGoCqBy2Qj5dH/RWcQD3qu+7ktmCnP0WAwQ101LpNMqYr4uWebhCs9APH32H9140397N61/pXYFs0ZaDCp2fm8EURYI1XkEmfCgDYzYsgTVMQbRlk7Lxar4B3uRjmC4LCNYEIPqFx6Qkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z/ZqeNlp; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z/ZqeNlp"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4602e2a0372so2986012f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781564260; x=1782169060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nvgJd06ouiRA1Bt6a4YifRiNbd6eY+jmmfs208b9fGI=;
        b=Z/ZqeNlpdgF3Cx08OWWCbBfyTn2r/l04h8344mIIqTlvx7mK1woE0Vq3tomZPyDW5Z
         YUUxfx0jhso0H+Bc+p2OBiYhWlMOwYKWAWXNKqsqywwDrQNQw0btowaP7br39ncgTmmy
         QgP3A6Ki98/dqGoAeGMB4wtwcrz1xPs5+FDDnZ013KQn/vWOCvHIeuiXRGEOCXZQ2qUp
         77mheMc2lLukVK95yPu0FcF2qpZNBT79sl2DMr1K6L7Ge4xSppBvyVmuWs9kHuJ8DLNv
         JQAcBAkHij+5/LIjYWUpkHkmIFG1CZunT/LHqYbfQBHuSWhAJ53fD+03lA+BjPQ4F9v6
         R1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781564260; x=1782169060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nvgJd06ouiRA1Bt6a4YifRiNbd6eY+jmmfs208b9fGI=;
        b=LAtPZqo/S6Z6I2DyR2iwTKBs0hvznfcOPjyDExfuoBRguosMcESmoZq0J69CdlfEnd
         57S5lBxFVzDKWU0mIN+2JA1+M+ZXzhsDlYL2hRdC6mqG5FlIO1SDIVghczbYymeGDymv
         PADuL617+LjqLIR2svG0nriidf1bpqTciDEus5qRvldVNU8nMzMooeB2Lk1922Hyfxig
         bhmcp5RSDfA+DOiEQJKoxGSOBSRNez7e8D6fOn3XkCi+Y8GmyRQpV0bPSILppVbsLhUP
         tfKMjtzcBC0GyrHIUEus6A15rOXL5yGc0GWIrKLEYUECsCYE6dKIjchXHvF9mEvqisbh
         lgbQ==
X-Forwarded-Encrypted: i=1; AFNElJ/w/HaxuhB+kXCCDBoUI4Z1bpwffZ0LP8+UzRijWYfxmw7cHMQC5OdAQOv7X25NR3Tt3E/gbaT518MmDZU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdZ3BmDdEGee0G4amQ4jYqxrkereX8zCu7A3UhP6Ue+MxnWbm0
	U02t80UiyNqxBPkhsH9GaAqzP0DYK1N3tV+efLQimyg7un0jX2umq/1WRudLBxtu
X-Gm-Gg: Acq92OGPeyGLUsUQvH5ontov0VvCmO2U4tCBIO1EsxY2GM1cHyaKxHnXCCtJe0TpzVF
	8NjYaZAqcm5JeYBQMqcZ4u8B1IRU+qlL4Yh39DhDMNzdLkeoc8SEKt9/6r88ZbNZBJ1fpENgwqX
	arNAK/UEzCJPni+AF/SqvGOWVkzvVny6EsCJkIQzet4CtfZZfZRDOUSsrask6OtoC05qO50Nn03
	jJW78gNdn0v2dRUat2Em/RcXgYX4sBrIp0IIaOvG1CzEOXxFjB4D4rRTNd304+gmJpIBifTyv1W
	ZZPQ7itn38ypWwyZ9sy4wIkNqlGCalXP2pLC6QAdBGGnpDqgSMT74QtXiNdQjq/WK79F0QvJoWs
	QPLXpgF+QFZBNVLeC7YgPleKQp6hBFluj7Zpad2Kw1ufraljG5tU8eifX8bqKdvl4UWDvllhZHZ
	Nn55rX9R1SabAYUgSgdlwoB7sw9Dv7CcbAvLDrw2quGdVHjW1KtUVzysHemGs9
X-Received: by 2002:a05:6000:25f1:b0:43f:ea25:20ff with SMTP id ffacd0b85a97d-4606dbefc51mr24706743f8f.29.1781564260379;
        Mon, 15 Jun 2026 15:57:40 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0d70sm38633487f8f.19.2026.06.15.15.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 15:57:40 -0700 (PDT)
Date: Mon, 15 Jun 2026 23:57:38 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
 x86@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260615235738.48a04644@pumpkin>
In-Reply-To: <20260615184435.GA17731@quark>
References: <20260614010357.69416-1-ebiggers@kernel.org>
	<20260614111628.00af46b9@pumpkin>
	<20260615184435.GA17731@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jun 2026 11:44:35 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Sun, Jun 14, 2026 at 11:16:28AM +0100, David Laight wrote:
> > On Sat, 13 Jun 2026 18:03:57 -0700
> > Eric Biggers <ebiggers@kernel.org> wrote:
...
> > Some 'not very important' comments:
> > 
> > I did wonder whether moving the loop into the asm() would help.
> > gcc has a nasty habit of pessimising loops when you try to be clever.
> > It is certainly safer for tight loops like these.  
> 
> I originally tried leaving the loops to the compiler, but gcc unrolled
> the 1x ones by 2x, despite it having no visibility into the asm block.
> That broke the intent with the indexed addressing, since to achieve the
> unrolling it generated code that incremented the pointers.

I did suspect that might happen.

> So I just ended up moving the loop to the asm, which reliably gives us
> the code we want.

Yep...

...
> > The code should be limited by the memory reads, so the 3-argument xor and
> > the interleave of the unroll may make no difference.  
> 
> The unroll by 2x in the 2 and 3-buffer cases helped a little bit on
> Sapphire Rapids.  I don't know exactly why, but it makes sense that
> those cases are where the loop overhead is most likely to matter.

Each iteration does 2 (or 3) reads and a write.
The cpu can do two reads and a write every clock.
However Intel cpu can only execute a branch every other clock,
so the shortest loop is two clocks.
That means you need need to unroll once to keep the memory logic busy.

The zen5 seems to be able to execute 1-clock loops, so wouldn't need
the unroll.

> > Some cpu do have constraints on the cache alignment in order to do two
> > reads per clock, but I've forgotten them and they got better before AVX-512.
> > If that were affecting this code (on the tested cpu) then I'd expect the
> > interleaved unroll would improve the _4 and -5 functions.
> > So it probably doesn't affect this code.  
> 
> The buffers are always 64-byte aligned here, as documented.

It is all more complex that that.
Whether you can do two reads/clock depends on whether the reads manage to
avoid needing the same buffers (etc) in the cache logic.
For instance it might not work if the addresses differ by the size of the
cache (one of Agner's books might have the answer).
(It was pretty hard to get two reads/clock on Sandy Bridge.)

Then there are some really strange effects.
On zen5 (at least on the one I've got) 'rep movsb' is very slow (setup and copy)
if (IIRC) (%di - %si) mod 4k is between 1 and 127.
The only other alignment that makes much difference is 64byte aligning %di (which
doubles throughput).

-- David


