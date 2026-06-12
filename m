Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87A8305684
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 09:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781255079; cv=none; b=nXHa+vJh+7IjOYIkST7UrGuMb9YWpT1fZfLISeLx3uy5ejJoQLr+qip117jFQdno6nr5GS0hZhrBPTNRsdfQ8iT02+i6FsyBTzw3u62ABdTIiE5FxIaSPNTEfdX8PN3YVERrqScqqWFtx3kbUf8EAbAGSegz6z24RHrl+gbSuno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781255079; c=relaxed/simple;
	bh=gnSrC76reHdx9wPAQQwWVrC27UWP4gCcm3C5Jcgp/p4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDQGrHid8HFhxInLzAEXlwv5tV+h1D/y9OwKElcsaieGshKCLRKxUcQxPCKVAHYmWR8XFo4ssCax1B8UHjflqsX9zQMhQ34NY6opRXBnZpnFqK2hvpWfcN8I99YBeMv6sEOODj0R3pk2VoMupRhlv9vjdmAvathJ8Zby6kpfrXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cAQvS0qY; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cAQvS0qY"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490afc47455so2847845e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 02:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781255075; x=1781859875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UiSf3+ko2j/Sn9SLSqeV80DYxQjjJ0/3Hsz4WRxgm14=;
        b=cAQvS0qY0jCaca9z4pJfajlLrd3/+YTn0fDwgcgS77khTncKXqYBxoBJF76OMCDS2y
         00aiHqpyEz41I/hOe4CfqyddpEkRf9Vhq4Rx8llIoll/913rmhf/dW7lYS2Rub50dguc
         3N3Rpcfnc86yhlpGZ1tr5RHRRwPye2M+cY5dK+h9fPckfam7Q2fRidImUnOLuQt7X2cB
         2zj/qrFces/dMLEk2JbLX6TSQKHS8cu65T15lV0DeDDJYYkhNFVvUSmYuM2UN1Egqzlk
         Rs8uMXonLrexjG1wi/rkscpsXOhy1hsPCmP+1GQl1mnz/B+i3q5Q7E6E6khIREydEaBo
         ZTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781255075; x=1781859875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UiSf3+ko2j/Sn9SLSqeV80DYxQjjJ0/3Hsz4WRxgm14=;
        b=Aq9FjNJNvo8w9ksS812wTZj7fImFsXDd2yxf8ZbDPmC8M2WmCdRcRtIGtKL4lK4ddY
         hpkoWEyWjnNo4rA9vYYA7u+tbhtXpeUyrfh8p5qu7BLjMa/BWUmVR1rvJb10tXtKrPM7
         GsCkwQGWYRX4u3cZ64MUsNMntYrjUwz+vnLC30hnFPGoTzzGMuck2/YuctTrfBKKk93G
         r3uLB8FBpQCV7SWlyyNSsQ0qVBbVWBLFcwvWStquNBAcPo9V5O3lsRMbjInD/EFaYnOy
         2/r5LKFsuWanm3huIrGkZt2RigqORpdycLQSeRZ+uLwGSOFBJHIKHy5tBNFQOQ5JI6NF
         Wu1Q==
X-Forwarded-Encrypted: i=1; AFNElJ+zOmzFdy2EBRHviXNSVrhU1/Vw5PCrTA+idmL3FRyoOZ2UibJ70vScKUJ2x3i7P4I3dQKdIqVsfy7mI0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCo+oMHXHZb/WtlKKoOm+7XI6wk0Sad7HQCtk0PDwhHHYfAF+U
	soaIet2wuHM2KVQLN44oCW1TPX5scZx6CMmo1bX1F3/+/tgxmAJY8Dpg
X-Gm-Gg: Acq92OHFJN4/LKhQ0r5fUjkVR5tlAOoYn7Fk1kxdx1qFdgaoZqCEsdHYn3Yi92pkBK+
	ot6rfM6YM0dGjft7YLREeUrjcYQl+hlWo03pE9RQq/tEjtcyW7pXmv893OVbZWpEAXv5f08A2iv
	j1Sf7aFPpIQip1mYo6GohbvPsTNocb+IuEDEDL8oGNuY3h7R2a849GleRGXtwzDYMFcZ5UYNBuQ
	Ta4fDlkstBIjc4TmiJvvzMrwDpA9TJ4reUstiU/4uliW/Y2o0JwxYBcG05EcD+EcGEx+wnDCsh2
	Fe3aDM4X2vOYsx5GC+M1iNqpQO1NsABMjMyr+Ag6rBQwM/2RUehYztFd2X2uBNbZ9+PesgIqKsi
	SXvGIl5dwHEAj37bXRDPm0Dj1sPzPb22NWn4f/RQ0j69ZErNVpKpREP3KakkLNlrliITSm12M2F
	0qMFqNed9yEdMOtbv3pexAZaNb+YI5h0azm4bdh9pWtEQvruYU+oZI8QZZwHfi
X-Received: by 2002:a05:600c:820c:b0:48e:5d91:cfe3 with SMTP id 5b1f17b1804b1-490ec4cd08fmr24926575e9.1.1781255075157;
        Fri, 12 Jun 2026 02:04:35 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c90668sm120657375e9.4.2026.06.12.02.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 02:04:34 -0700 (PDT)
Date: Fri, 12 Jun 2026 10:04:32 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, Andrea Mazzoleni
 <amadvance@gmail.com>
Subject: Re: [PATCH] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260612100432.1f1c8c7a@pumpkin>
In-Reply-To: <20260612052247.GA8848@lst.de>
References: <20260612044034.117442-1-ebiggers@kernel.org>
	<20260612052247.GA8848@lst.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jun 2026 07:22:47 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jun 11, 2026 at 09:40:34PM -0700, Eric Biggers wrote:
> > Add an implementation of xor_gen() using AVX-512. =20
>=20
> > Benchmark on AMD Ryzen 9 9950X (Zen 5): =20
>=20
> Can you share the benchmark?
>=20
> In my local tree I have ports of the AVX2 and AVX512 implementations
> from snapraid (https://github.com/amadvance/snapraid), which in userspace
> give really good performance.  On my Laptop with a AMD Ryzen AI 7 PRO 350
> (which is a Zen5 with the slower double pumped AVX512 unit), both of
> them get over 1GB/s throughput on the snapraid benchmarks.  I've been
> holding them back as I don't have a good kernel benchmarking harness,
> and it's missing the quirks for old AVX512 or the newer AMD special
> cases.

=46rom my experiments on Intel cpu (and I don't remember the zen-5 being
that different - but I've done less testing on it) you don't need to
unroll loops very much at all.

A reasonable model seems to be that the uops generated by the instruction
decoder get executed when all the prerequisite registers and the required
execution unit are available.
So for a memory copy (and the xor is basically a copy) the control loop
can run way ahead of the read/write instructions.
This means you can get the control loop 'for free' and unrolling further
makes no/little difference.

Each xor is two memory reads and one memory write.
The cpu I was using could only do one write/clock - so you can only do one
xor each clock. I think some of the newer ones can to two writes/clock but
I'm not sure how many reads/clock they can do - might still be 2, don't
think it s 4.
So you should be able to get one xor per clock, but I doubt you'll get two
(and possibly not even 1.3 - which would require 4 memory accesses per cloc=
k).

The best loop construct is the one that uses negative offsets from the
end of the buffers, basically:
	buf +=3D len;
	offset =3D -len;
	do
		f(buf[offset]);
	while (offset +=3D size);
that reduces the loop control to just an 'add' and 'jnz' (which can
get merged into a single u-op).

The cpu have enough execution units to execute two memory reads,
a memory write, an xor the add and jnz every clock.
So even the 'rolled up' loop might run at one xor per clock.
While I think I got a 'one clock loop' on my zen-5 (testing
word-at-a-time strlen) I only managed a two clock loop on the newest
Intel cpu I've got (which isn't that new).
So put two xor in the loop and it shouldn't be limited by the loop
control, but will be limited by the memory accesses instead.

Further unrolling shouldn't help and may make things worse.
The Intel cpu have logic to directly forward the result of an
ALU instruction into the next few instructions, but after that you can
get a stall because of the 'round trip' via the register file.
So part way down an unrolled nn(%reg) sequence you can get a stall.
An extra 'add $0,%reg' in the middle of the unrolled loop will
'refresh' the register and speed things up.
(I hit that with a loop that needed a rather more complicated control
structure.)

You definitely need to use the pmc clock counter and data dependencies
against the rdpmc instruction to get sensible performance figures.
The can reasonably reliably measure down to less than 20 clocks.

	David
=20
