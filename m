Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B8D2DC77C;
	Thu, 11 Sep 2025 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757617464; cv=none; b=AdBXCQOW/c2E15y96ig2IAYCq4p5nM7n4FPuykFhH3IUAEagJDU3vIymCwTdQWoYqkjWLuZQG6PSlIMjVh3ebdrirw5QI4S00tY7o1S1UeoIIbPCA9yt9A30tvsJ6MJNWzdhWNLuqKoWkw4KVbcToMBRIMfnRf0dbZIXEWFd/zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757617464; c=relaxed/simple;
	bh=rAkxJv/3foIdEfVT/80z5+2GaTUuEqXXoELt3KTULG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDOynYbLI4BLoqKRGKVIc9fYxFu1dummK6/nRr79NVo7Q6PHyYQzKbiqkIBzi671HJWHRJnayqZAx8QgkG8B36k6g4YmDNroF8DonMMKzFBFXXq5rWGFtKvAebztW4vlxe/Pon+kABh/igTTQs2cR/Ooy201h4z87/e9QnBxkEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NgJmdhFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NgJmdhFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C146C4CEF0;
	Thu, 11 Sep 2025 19:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757617463;
	bh=rAkxJv/3foIdEfVT/80z5+2GaTUuEqXXoELt3KTULG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NgJmdhFvffaNkMSKeLoRpu+BnvJeOxJacaNKJSvtWNB1ifuG1HbrVSUULpPk+HQTF
	 okO7XR2T2wbnFk5b984nMc3a+aawQ7vgfYEdNW9JXoRJsq1CSz9U4Nu5zaLWmLy1RA
	 YwQldVWYU9cZZpA9+abgE4xT0KNL/Tuvr4RMb/CQoN8XNEl3mBRPj6/z3lNeH+lJqR
	 GO5W3DaTKfRg0oXV4gSl8J4aZN/GKze3RboCNWE+38ZCoQE16qhsbxhCVYZqfBuub5
	 GlVDqhyoovt7YtbvdcWqnkTAFI9ruXz7XSXrymPM0p/SIwPWNBRdcPJjKqUuGvJzt8
	 OxbFMrs3ZEXwA==
Date: Thu, 11 Sep 2025 12:03:02 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com,
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Message-ID: <20250911190302.GF1376@sol>
References: <20250829164500.324329-1-ebiggers@kernel.org>
 <20250910194921.GA3153735@google.com>
 <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>
 <20250911175145.GA1376@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250911175145.GA1376@sol>

On Thu, Sep 11, 2025 at 10:51:45AM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 11:09:17AM +0200, Alexander Potapenko wrote:
> > On Wed, Sep 10, 2025 at 9:49 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> > > > Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> > > > kmsan_internal_set_shadow_origin():
> > > >
> > > >     BUG: unable to handle page fault for address: ffffbc3840291000
> > > >     #PF: supervisor read access in kernel mode
> > > >     #PF: error_code(0x0000) - not-present page
> > > >     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
> > > >     Oops: 0000 [#1] SMP NOPTI
> > > >     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
> > > >     Tainted: [N]=TEST
> > > >     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > > >     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
> > > >     [...]
> > > >     Call Trace:
> > > >     <TASK>
> > > >     __msan_memset+0xee/0x1a0
> > > >     sha224_final+0x9e/0x350
> > > >     test_hash_buffer_overruns+0x46f/0x5f0
> > > >     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
> > > >     ? __pfx_test_hash_buffer_overruns+0x10/0x10
> > > >     kunit_try_run_case+0x198/0xa00
> > >
> > > Any thoughts on this patch from the KMSAN folks?  I'd love to add
> > > CONFIG_KMSAN=y to my crypto subsystem testing, but unfortunately the
> > > kernel crashes due to this bug :-(
> > >
> > > - Eric
> > 
> > Sorry, I was out in August and missed this email when digging through my inbox.
> > 
> > Curiously, I couldn't find any relevant crashes on the KMSAN syzbot
> > instance, but the issue is legit.
> > Thank you so much for fixing this!
> > 
> > Any chance you can add a test case for it to mm/kmsan/kmsan_test.c?
> 
> Unfortunately most of the KMSAN test cases already fail on upstream,
> which makes it difficult to develop new ones:

The KMSAN test failures bisect to the following commit:

    commit f90b474a35744b5d43009e4fab232e74a3024cae
    Author: Vlastimil Babka <vbabka@suse.cz>
    Date:   Mon Mar 10 13:40:17 2025 +0100

        mm: Fix the flipped condition in gfpflags_allow_spinning()

I'm not sure why.  Apparently something related to lib/stackdepot.c.

Reverting that commit on top of upstream fixes the KMSAN tests.

- Eric
