Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4595A1ADC94;
	Thu, 23 Jan 2025 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737666800; cv=none; b=mYcRlag71JERfjkFgmFbhoLL7wlt/Fkm71INrZmCo2K8oIrkgfYUMX5dyYpWBXCRwLDQ+LEPjOJUsk8GRjOPhXfDXdS+hvuWKbvlqpq0GcTB/X2MNcH4uDJDwxpwx7VDr03cpynFvNhxbRwY2urob5vk0GR6mB7QT38lFkr3Vjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737666800; c=relaxed/simple;
	bh=i3lPbt0fcoLvkz+WFDp+xCQj6SBZ4HSG9Ilrach0yOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8fa4QTv2w35067ygjHhbiE+3ktXBSb5rTQcUOXa5MiTBAxlDLJKQxAXiY/ztmjuI23SsQmZp2CBfiqiZtXZpqLc4dqdTpM5OhWPzCIIg0MruyVZwxlHe7kdIBo413A3k6s/DxRs4mNfw6F9Gc4BetH68NSQ7d01RIiWrNy8Ni8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2zelItM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2zelItM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C67BC4CED3;
	Thu, 23 Jan 2025 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737666799;
	bh=i3lPbt0fcoLvkz+WFDp+xCQj6SBZ4HSG9Ilrach0yOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h2zelItM9TDXVoI+oegO9sx1N5aSvXK6RAJzIpU744ykx0Sy5pnmg4v0tGbKc/TEm
	 leH5FWHZV9HbD5oc1wm8FLvzG9w0tzjegBDkT3zATgP87NeCViO+B7Hi8yMJEpMUBO
	 1VM4kygzkRo26Pw3HPRWBbmbmX0Hou8HFnotpegzBvQ0ZEoW1A7ilWLUC2VghIwhqC
	 TkDyT6M6fj3ijhzTBXTb+dqrvH3JnLIC9F1D1oSVDbnClKQPtmR+as0pNP1UKrp7br
	 GdBfunH7I7d2HPlfIOh+U92OuI8ORRFE5p/ZKlokgM8T00D3gKOKYMauhanayoLa70
	 y31w4NF0aJWpA==
Date: Thu, 23 Jan 2025 13:13:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123211317.GA88607@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
 <20250123140744.GB3875121@mit.edu>
 <20250123181818.GA2117666@google.com>
 <CAHk-=wiVRnaD5zrJHR=022H0g9CXb15OobYSjOwku3m54Vyb4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiVRnaD5zrJHR=022H0g9CXb15OobYSjOwku3m54Vyb4A@mail.gmail.com>

On Thu, Jan 23, 2025 at 12:52:30PM -0800, Linus Torvalds wrote:
> On Thu, 23 Jan 2025 at 10:18, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > FWIW, benchmarking the CRC library functions is easy now; just enable
> > CONFIG_CRC_KUNIT_TEST=y and CONFIG_CRC_BENCHMARK=y.
> >
> > But, it's just a traditional benchmark that calls the functions in a loop, and
> > doesn't account for dcache thrashing.
> 
> Yeah. I suspect the x86 vector version in particular is just not even
> worth it. If you have the crc instruction, the basic arch-optimized
> case is presumably already pretty good (and *that* code is tiny).

x86 unfortunately only has an instruction for crc32c, i.e. the variant of CRC32
that uses the Castagnoli polynomial.  So it works great for crc32c().  But any
other variant of CRC such as the regular crc32() or crc_t10dif_update() need
carryless multiplication (PCLMULQDQ) which uses the vector registers.  It is
super fast on sufficiently long messages, but it does use the vector registers.

FWIW, arm64 has an instruction for both crc32c and crc32.  And RISC-V has
carryless multiplication using scalar registers.  So things are a bit easier
there.

> Honestly, I took a quick look at the "by-4" and "by-8" cases, and
> considering that you still have to do per-byte lookups of the words
> _anyway_, I would expect that the regular by-1 is presumably not that
> much worse.

The difference I'm seeing on x86_64 (Ryzen 9 9950X) is 690 MB/s for slice-by-1
vs. 3091 MB/s for slice-by-8.  It's significant since the latter gives much more
instruction-level parallelism.  But of course, CPUs on which it matters tend to
have *much* faster arch-optimized implementations anyway.  Currently the
x86_64-optimized crc32c_le() is up to 43607 MB/s on the same CPU, and crc32_le()
is up to 22664 MB/s.  (By adding VPCLMULQDQ support we could actually achieve
over 80000 MB/s.)  The caveat is that in the [V]PCLMULQDQ case the data length
has to be long enough for it to be worthwhile, but then again having a 8 KiB
randomly-accessed data table just to micro-optimize short messages seems not too
worthwhile.

> IOW, maybe we could try to just do the simple by-1 for the generic
> case, and cut the x86 version down to the simple "use crc32b" case.
> And see if anybody even notices...
> 
>               Linus

- Eric
