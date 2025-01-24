Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8051CEAD8
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jan 2025 00:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737678787; cv=none; b=dOgamb1Gd9Ub+OMjaSVEjLmwuBw/YttK5Ul7b1VurUrYZsnMi6sDif/9YS8l8FwLZGHg+CTpjzQfVzofhveqzxXg7v31UyuaQaX272JR1wbRwiyuLLl5EZKnWNZfs9CfkExjbzLS/zgQHXgZ0i3XLAfr6Gvl6LaBlAMfAXpiXho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737678787; c=relaxed/simple;
	bh=u2rP1KdiIUraqfsqT+LRvUdyCNl/5O8KPNOtBMUohnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgjWXziTUxcMSYzJeZ9RGh/P1mgFOEtz21nmW0PoaoLPiaQ6XInJHgYdDA2/9AnqUVtb3GDo0/6ST/GKT9wXm7ONtSmSHd8aGrOYFhnM7K8T3erNxHDJEvYGaBnOijGLCa6yZ6tP/AJPnZL5PLHcae2VfMkC+mxv4vXQb8QrzjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GWabVW1z; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GWabVW1z"
Date: Thu, 23 Jan 2025 19:32:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737678783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jvOjD4LumX/0vsXnNNxDA4RM7MKVkyz2ZkN81acom9k=;
	b=GWabVW1zxjxvh/C3dv9USjxpk4dsztW+SlgOO1EM9DkfgEMAI89yxeB5t0AGaoCYgEHGP2
	UbVbbqKjwX5REOdkoJcSVrbQM8BT/ZLoR31DcWhh+/a22GAMuCga559NZDy/lifUCcO10I
	YXftTg29Nj/xctWGiYomxvAVmsrt/Xk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Theodore Ts'o <tytso@mit.edu>, 
	Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli <wangyuli@uniontech.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <v36sousjd5ukqlkpdxslvpu7l37zbu7d7slgc2trjjqwty2bny@qgzew34feo2r>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
 <osjlhhph7hadq4ovynqeegr3rxliamluo7lvq7gje45hnem4dq@53pwc56v4fah>
 <20250123234209.GD88607@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123234209.GD88607@sol.localdomain>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 23, 2025 at 03:42:09PM -0800, Eric Biggers wrote:
> On Thu, Jan 23, 2025 at 05:36:40PM -0500, Kent Overstreet wrote:
> > On Wed, Jan 22, 2025 at 11:46:18PM -0800, Eric Biggers wrote:
> > > On Wed, Jan 22, 2025 at 09:16:33PM -0800, Eric Biggers wrote:
> > > > As you probably noticed, the other problem is that CRC32 has 4 generic
> > > > implementations: bit-by-bit, and slice by 1, 4, or 8 bytes.
> > > > 
> > > > Bit-by-bit is useless.  Slice by 4 and slice by 8 are too similar to have both.
> > > > 
> > > > It's not straightforward to choose between slice by 1 and slice by 4/8, though.
> > > > When benchmarking slice-by-n, a higher n will always be faster in
> > > > microbenchmarks (up to about n=16), but the required table size also increases
> > > > accordingly.  E.g., a slice-by-1 CRC32 uses a 1024-byte table, while slice-by-8
> > > > uses a 8192-byte table.  This table is accessed randomly, which is really bad on
> > > > the dcache, and can be really bad for performance in real world scenarios where
> > > > the system is bottlenecked on memory.
> > > > 
> > > > I'm tentatively planning to just say that slice-by-4 is a good enough compromise
> > > > and have that be the only generic CRC32 implementation.
> > > > 
> > > > But I need to try an interleaved implementation too, since it's possible that
> > > > could give the best of both worlds.
> > > 
> > > Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
> > > only generic CRC32 implementation.  The generic code has become increasingly
> > > irrelevant due to the arch-optimized code existing.  The arch-optimized code
> > > tends to be 10 to 100 times faster on long messages.
> > > 
> > > The generic CRC32 code is still needed when the CPU features needed by the arch
> > > code are unavailable.  But that's rare these days.  It's also still needed when
> > > the CPU has no scalar instructions to accelerate the CRC (e.g. on x86_64, the
> > > "regular" CRC32 as opposed to the Castagnoli CRC32) *and* the message is too
> > > short for the overhead of saving and restoring the vector registers to be worth
> > > it -- typically < 64 bytes or so.  And it's still needed when the CRC is done in
> > > a context where vector registers can't be used at all.
> > > 
> > > But those don't feel like very strong motivations for the huge tables anymore.
> > > I think the huge tables were really intended for optimizing CRCs of long
> > > messages back when CPUs didn't have any better way to do it.
> > 
> > Have you by chance been looking at performance of 64 bit crc algorithms,
> > or have any recommendations there?
> > 
> > I've been starting to consider switching to a 64 bit crc for the
> > default for bcachefs - and we do want it to be a regular crc so we can
> > combine/add them together, not one of the newer fancier add/xor based
> > hashes.
> > 
> > I thought we'd gotten a faster PCLMULQDQ based implementation of a
> > crc64, but looking again it appears not, hrm.
> 
> Yep!  I've written an assembly template that expands into a PCLMULQDQ or
> VPCLMULQDQ implementation of any variant of CRC-8, CRC-16, CRC-32, or CRC-64.
> The latest work-in-progress version can be found at
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-x86.
> We just need to decide which CRC variants to wire it up for.  My tentative plan,
> which is implemented in that git branch, is crc32_le, crc_t10dif, crc64_be, and
> crc64_nvme.  (crc64_nvme is currently called crc64_rocksoft, but that name makes
> no sense.)  For crc32_le and crc_t10dif these would replace the existing
> PCLMULQDQ implementations.  crc64* on the other hand would gain acceleration for
> the first time, improving performance for those by as much as 100x.  I'm also
> fixing the CRC64 lib to be organized the way I did CRC32 and CRC-T10DIF.
> 
> That work is targeting 6.15, since there was already enough for 6.14.
> 
> Though this approach makes it easy to wire up arbitrary CRC variants for x86, we
> do need to make sure that anyone we wire up is actually useful.  The users of
> the optimized crc64_be would be drivers/md/bcache/ and fs/bcachefs/.  So if you
> could confirm that that would indeed be useful for you (and in particular you
> haven't deprecated the CRC64 support in favor of xxHash), that would be helpful.

That's fantastic!

CRC64 isn't deprecated, and I suspect that will be our preferred option
at some point in the future. xxHash was added only because there is a
real desire for 64 bit checksums and crc64 wasn't a good option at the
time.

(It was also designed as a hash function, not for data protection, and
I'd want to see some actual literature evaluating it as such before I'd
consider making it the default. And like I mentioned, CRCs have other
properties we want).
