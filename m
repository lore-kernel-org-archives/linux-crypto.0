Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A216C25D1E6;
	Wed, 10 Sep 2025 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757519984; cv=none; b=OP7+wVYPzUtfE9agTwJ0XlvQ4FmCs3Npoo/51jWljBvpm8e+iaGcIvNdNOzuHQlKrT8yH/f1F0z5OuISBcTiNWZjp8Q2jwqQ8UWe8ZTN8RzFO52LLTR/wBfEv1nU5iZQLYGJVzh08O+cBgOzMCXtP4Iv97HTw4kwDYYYECSb9xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757519984; c=relaxed/simple;
	bh=rLlleifu0thdpPhsg3VNchjcqxHN/buCBymoJpUNlHE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OTA1RN4a8hWksY5hzeXE2ucCmqyDUwzFsiHYYNcrWg/mWP87sW4xYI99OquXZBJv6aAqjuy+xg/V7yvX8JJAwR4lYfZva+Wc4UPEw4iTQw3NlZ+VwS42XyCeHcOOXAFje/2o4D8oKvzDcnndVk8Pwld4BUjnW5cIyb5vyIpjs1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bxABF7UM; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bxABF7UM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=rLlleifu0thdpPhsg3VNchjcqxHN/buCBymoJpUNlHE=;
	t=1757519982; x=1758729582; b=bxABF7UM3qBOcYAQlhvMprbixD3kx6XVleeX/To9IbjPUJD
	sbAdGfO2SbmPQ0Qr8NiEcp7Q0JszNYTcx+QHZBugf2bXbxONB2fVHdPqm8yoxsazCvbevLUT0zBhg
	KrgG9o5UT2RCyAi7jURSk8piNOqR5qqOBJb/GMHCiW1+XDhmtk5mApFOLT38D05rzXxsm8HJuteyN
	8YnkC1ApgeYGGK95hU9x/oUzaZMFCdFnYe075wjPJiyqjaZK23eSx+l+cIPkJFyAcnUBC3bj9oKs/
	BKvTpg1YBzMCLizV/UEZZSQ3ApFT0bZe9vu2343AT5W/9OwtnxEVanvHZDEf1jOQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uwNEF-0000000D9a5-0csR;
	Wed, 10 Sep 2025 17:59:27 +0200
Message-ID: <6eda1208c08130e00cb54e557bc4858ce10a4a94.camel@sipsolutions.net>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Potapenko <glider@google.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	andreyknvl@gmail.com, brendan.higgins@linux.dev, davidgow@google.com, 
	dvyukov@google.com, jannh@google.com, elver@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	dhowells@redhat.com, lukas@wunner.de,
 ignat@cloudflare.com, 	herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org
Date: Wed, 10 Sep 2025 17:59:26 +0200
In-Reply-To: <CAG_fn=Vco04b9mUPgA1Du28+P4q4wgKNk6huCzU34XWitCL8iQ@mail.gmail.com> (sfid-20250910_124126_320471_24812999)
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
	 <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
	 <CAG_fn=Vco04b9mUPgA1Du28+P4q4wgKNk6huCzU34XWitCL8iQ@mail.gmail.com>
	 (sfid-20250910_124126_320471_24812999)
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

Hi,

Thanks for your response!

> > > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > > low-level, relatively stateless functions (e.g., data parsers, format
> > > converters)
> >=20
> > Could you clarify what you mean by "relatively" here? It seems to me
> > that if you let this fuzz say something like
> > cfg80211_inform_bss_frame_data(), which parses a frame and registers it
> > in the global scan list, you might quickly run into the 1000 limit of
> > the list, etc. since these functions are not stateless. OTOH, it's
> > obviously possible to just receive a lot of such frames over the air
> > even, or over simulated air like in syzbot today already.
>=20
> While it would be very useful to be able to test every single function
> in the kernel, there are limitations imposed by our approach.
> To work around these limitations, some code may need to be refactored
> for better testability, so that global state can be mocked out or
> easily reset between runs.

Sure, I that'd be possible. Perhaps I'm more wondering if it's actually
desirable, but sounds like at least that's how it was intended to be
used then.

> I am not very familiar with the code in
> cfg80211_inform_bss_frame_data(), but I can imagine that the code
> doing the actual frame parsing could be untangled from the code that
> registers it in the global list.

It could, but I'm actually less worried about the parsing code (it's
relatively simple to review) than about the data model in this code, and
trying to fuzz the data model generally requires the state. See e.g.
https://syzkaller.appspot.com/bug?extid=3Ddc6f4dce0d707900cdea (which I
finally reproduced in a kunit test a few years after this was originally
reported.)

I mean ... I guess now I'm arguing against myself - having the state
there is required to find certain classes of bugs, but not having the
state makes it easier to figure out what's going on :-) A middle ground
would be to have some isolated state for fuzzing any particular "thing",
but not necessarily reset between rounds.

> The upside of doing so would be the ability to test that parsing logic
> in modes that real-world syscall invocations may never exercise.

Sure.

> > > We would like to thank David Gow for his detailed feedback regarding =
the
> > > potential integration with KUnit. The v1 discussion highlighted three
> > > potential paths: making KFuzzTests a special case of KUnit tests, sha=
ring
> > > implementation details in a common library, or keeping the frameworks
> > > separate while ensuring API familiarity.
> > >=20
> > > Following a productive conversation with David, we are moving forward
> > > with the third option for now. While tighter integration is an
> > > attractive long-term goal, we believe the most practical first step i=
s
> > > to establish KFuzzTest as a valuable, standalone framework.
> >=20
> > I have been wondering about this from another perspective - with kunit
> > often running in ARCH=3Dum, and there the kernel being "just" a userspa=
ce
> > process, we should be able to do a "classic" afl-style fork approach to
> > fuzzing.
>=20
> This approach is quite popular among security researchers, but if I'm
> understanding correctly, we are yet to see continuous integration of
> UML-based fuzzers with the kernel development process.

Well, chicken and egg type situation? There are no such fuzzers that are
actually easy to use and/or integrate, as far as I can tell.

I've been looking also at broader fuzzing tools such as nyx-fuzz and
related kafl [1] which are cool in theory (and are intended to address
your "cannot fork VMs quickly enough" issue), but ... while running a
modified host kernel etc. is sufficient for research, it's practically
impossible for deploying things since you have to stay on top of
security etc.

[1] https://intellabs.github.io/kAFL/tutorials/linux/fuzzing_linux_kernel.h=
tml

That said, it seems to me that upstream kvm code actually has Intel-PT
support and also dirty page logging (presumably for VM migration), so
I'm not entirely sure what the nyx/kafl host kernel actually really
adds. But I have yet to research this in detail, I've now asked some
folks at Intel who work(ed) on it.

> > That way, state doesn't really (have to) matter at all. This is
> > of course both an advantage (reproducing any issue found is just the
> > right test with a single input) and disadvantage (the fuzzer won't
> > modify state first and then find an issue on a later round.)
>=20
> From our experience, accumulated state is more of a disadvantage that
> we'd rather eliminate altogether.

Interesting. I mean, I do somewhat see it that way too from the
perspective of someone faced with inscrutable bug reports, but it also
seems that given enough resources/time, accumulated state lets a fuzzer
find more potential issues.

> syzkaller can chain syscalls and could in theory generate a single
> program that is elaborate enough to prepare the state and then find an
> issue.

Right, mostly, the whole "I found a reproducer now" thing, I guess.

> However, because resetting the kernel (rebooting machines or restoring
> VM snapshots) is costly, we have to run multiple programs on the same
> kernel instance, which interfere with each other.

(see above for the nyx/kafl reference)

> As a result, some bugs that are tricky to trigger become even trickier
> to reproduce, because one can't possibly replay all the interleavings
> of those programs.

Right.

> So, yes, assuming we can build the kernel with ARCH=3Dum and run the
> function under test in a fork-per-run model, that would speed things
> up significantly.

Is it really a speed-up vs. resulting in more readable reports? Possibly
even at the expense of coverage?

But anyway, making that possible was indeed what I was thinking about.
It requires some special configuration and "magic" in UML, but it seems
eminently doable. Mapping KCOV to a given fuzzer's feedback might not be
trivial, but it should be possible too. In theory you could even compile
the whole UML kernel with say afl-clang, I suppose.

> > I was just looking at what external state (such as the physical memory
> > mapped) UML has and that would need to be disentangled, and it's not
> > _that_ much if we can have specific configurations, and maybe mostly
> > shut down the userspace that's running inside UML (and/or have kunit
> > execute before init/pid 1 when builtin.)
>=20
> I looked at UML myself around 2023, and back then my impression was
> that it didn't quite work with KASAN and KCOV, and adding an AFL
> dependency on top of that made every fuzzer a one-of-a-kind setup.

I'm not entirely sure about KCOV right now, but KASAN definitely works
today (not in 2023.) I agree that adding a fuzzer on top makes it a one-
of-a-kind setup, but I guess from my perspective adding syzbot/syzkaller
(inside) is really mostly the same, since we don't run that ourselves
right now.

> > Did you consider such a model at all, and have specific reasons for not
> > going in this direction, or simply didn't consider because you're comin=
g
> > from the syzkaller side anyway?
>=20
> We did consider such a model, but decided against it, with the
> maintainability of the fuzzers being the main reason.
> We want to be sure that every fuzz target written for the kernel is
> still buildable when the code author turns back on it.
> We also want every target to be tested continuously and for the bugs
> to be reported automatically.
> Coming from the syzkaller side, it was natural to use the existing
> infrastructure for that instead of reinventing the wheel :)

Fair points, though I'd like to point out that really the only reason
this is true is the syzkaller availability: that ensures fuzz tests
would run continuously/automatically, thus ensuring it's buildable
(since you try that) and thus ensuring it'd be maintained. So it all
goes back to syzkaller existing already :-)

Which I'm not arguing is bad, quite the opposite, but I'm also close to
just giving up on the whole UML thing precisely _because_ of it, since
there's no way anyone can compete with Google's deployment, and adding
somewhat competing infrastructure to the kernel will just complicate
matters. Which is maybe unfortunate, because a fork/fuzz model often
seems more usable in practice, and in particular can also be used more
easily for regression tests.

Regression, btw, is perhaps something to consider here in this patch
set? Maybe some side files could be provided with each KFuzzTest that
something (kunit?) would run to ensure that the code didn't regress when
asked to parse those files?

> That being said, our current approach doesn't rule out UML.
> In the future, we could adapt the FUZZ_TEST macro to generate stubs
> that link against AFL, libFuzzer, or Centipede in UML builds.

That's also true, I guess, in some way this infrastructure would be
available for any fuzzer to link to, especially if we do something with
UML as I was thinking about.

Which is also in part why I was asking about the state though, since a
"reset the whole state" approach is maybe a bit more amenable to
actually letting the fuzzer modify state than the current approach.

Then again, given that syzbot always modifies state, maybe I'm changing
my opinion on this and will say that I'm not so sure any more your
intention of fuzzing "low-level, relatively stateless functions" holds
that much water? If in practice syzbot is the thing that runs this, then
that doesn't matter very much apart from having to ensure that it
doesn't modify state in a way that is completely invalid - but to some
extent that'd be a bug anyway, and e.g. memory allocations of a function
can be freed by the fuzztest wrapper code.


I guess I'll research the whole nyx thing a bit more, and maybe
reconsider giving up on the UML-based fork/fuzz model, if I can figure
out a way to integrate it with KFuzzTest and run those tests, rather
than my initial intent of integrating it with kunit. Some infrastructure
could be shared, although I had hoped things like kunit asserts, memory
allocations, etc. would be available to fuzz test code just to be able
to share setup/teardown infrastructure - I guess we'll have to see how
that plays out. :)

Thanks!

johannes
