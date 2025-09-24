Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12872E7F1C;
	Wed, 24 Sep 2025 12:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758718365; cv=none; b=hRqX08i3/6JyY3d0pJfSyIi4OO1eKI19enNys1NNFJoPRnxe9KMeTscLStk6GzRTSXjido6TtRuUE4OZW6Vs5kU01ww5QKeV67qZmsVnIXaGr6PqdB9eomtIRplZ9Mn1v8rL4GpzcOaY49CnXenGrATfVu/Qq9MpuwXHf+WKk5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758718365; c=relaxed/simple;
	bh=ZrrdwjCMOS1FPrSq5mXZIAim8xhhUBBzz8m/K9cmZtQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gxaoaiZuMG3aV3EVs+YC4pWxmxcZBQ6jIZb5y5Vfg3sMBdB+83HYYVyn1LOfG0F/9DgpMl/zuI+iYW9XfM7D627yXHJEZdpkrSOOben14MRhn4/zM3HrsMFGOdoHc/527fcZZsdTGuytyoks+K+MT1sfaTud461zsu9RZ8dofys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AmaFo1FI; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AmaFo1FI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=h5K+P/riDmU7tvn3fIuQxPNsf4KltKjt2Yr02gW3kT0=;
	t=1758718363; x=1759927963; b=AmaFo1FIYGhDn8ysOJWdXbu4JDq0k3l44jZB7KYHhx/0gRQ
	JnZohNcZSnKzZxp647Uog7uL7ZRedaJ5CgvWhSrsAza12nQTb52sEgrZdXg+OJVF2GYKMYGwNkmkT
	pku4CmqWF/VFvBo8ZSoUSJsSHBdqn0YEB7ltDz0+Tjsi49G5EYMFwg7irHJOgAVtUkKJH1PlexCbi
	X3HXUb5O7VJBa7vI13jeBH2ETVxCGePLLhKQ6aaSg9CMSuIrNwBaatrPGJxCMvEH3j+bvgWL6IFwu
	PvL/Y/xhTRYBw63QylnrampQP9X4ufE8JaWqSUVK4yf2Mx0cfzZt36+NqaXuTNGQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1v1Oz3-00000008sim-1o1i;
	Wed, 24 Sep 2025 14:52:33 +0200
Message-ID: <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	glider@google.com
Cc: andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org, 
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
 jannh@google.com, 	kasan-dev@googlegroups.com, kees@kernel.org,
 kunit-dev@googlegroups.com, 	linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 	lukas@wunner.de,
 rmoar@google.com, shuah@kernel.org, sj@kernel.org, 	tarasmadan@google.com
Date: Wed, 24 Sep 2025 14:52:32 +0200
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> (sfid-20250919_165801_647339_D5FEA55B)
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
	 (sfid-20250919_165801_647339_D5FEA55B)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2025-09-19 at 14:57 +0000, Ethan Graham wrote:
>=20
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>=20
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.

So ... I guess I understand the motivation to make this easy for
developers, but I'm not sure I'm happy to have all of this effectively
depend on syzkaller.

You spelled out the process to actually declare a fuzz test, but you
never spelled out the process to actually run fuzzing against it. For
the record, and everyone else who might be reading, here's my
understanding:

 - the FUZZ_TEST() macro declares some magic in the Linux binary,
   including the name of the struct that describes the necessary input

 - there's a parser in syzkaller (and not really usable standalone) that
   can parse the vmlinux binary (and doesn't handle modules) and
   generates descriptions for the input from it

 - I _think_ that the bridge tool uses these descriptions, though the
   example you have in the documentation just says "use this command for
   this test" and makes no representation as to how the first argument
   to the bridge tool is created, it just appears out of thin air

 - the bridge tool will then parse the description and use some random
   data to create the serialised data that's deserialized in the kernel
   and then passed to the test

   - side note: did that really have to be a custom serialization
     format? I don't see any discussion on that, there are different
     formats that exist already, I'd think?

 - the test runs now, and may or may not crash, as you'd expect


I was really hoping to integrate this with ARCH=3Dum and other fuzzers[1],
but ... I don't really think it's entirely feasible. I can basically
only require hard-coding the input description like the bridge tool
does, but that doesn't scale, or attempt to extract a few thousand lines
of code from syzkaller to extract the data...

[1] in particular honggfuzz as I wrote earlier, due to the coverage
    feedback format issues with afl++, but if I were able to use clang
    right now I could probably also make afl++ work in a similar way
    by adding support for --fsanitize-coverage=3Dtrace-pc-guard first.


I'm not even saying that you had many choices here, but it's definitely
annoying, at least to me, that all this infrastructure is effectively
dependent on syzkaller due to all of this. At the same time, yes, I get
that parsing dwarf and getting a description out is not an easy feat,
and without the infrastructure already in syzkaller it'd take more than
the ~1.1kLOC (and even that is not small) it has now.


I guess the biggest question to me is ultimately why all that is
necessary? Right now, there's only the single example kfuzztest that
even uses this infrastructure beyond a single linear buffer [2]. Where
is all that complexity even worth it? It's expressly intended for
simpler pieces of code that parse something ("data parsers, format
converters").

[2] admittedly the auxdisplay one is slightly different and uses a
    string, but that's pretty much equivalent

johannes
