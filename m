Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942F1334385;
	Thu, 11 Sep 2025 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757599208; cv=none; b=rSAVAAUq9HTN1tXTb97CQomm6YFwxUXYF/Tclvkj0N04Q+ubCDdfSJM9WU1sA1e0xuSmGgynLqZzzPyv2+lXuui6F0nr+70jfcLuMEWNk6dWspzqU9zs2ThBzn6BjHsl9cvUA39D6G+zZsX/pONhaqTLsI74/AUdN3WEv7Oxatc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757599208; c=relaxed/simple;
	bh=1ZpIIGiAzp9dlmnlhXDwO9rr0Iyle3/GOpYyQPgYY/c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nnNtQ+R+lqo7Axllup3bRxEUCLykKlH03FlXcgyEeLZvwtq+8Uu6j98I7TUnebCXSsJvvyE7v6lyLHhErFIQ8BnWLm/Y214j2k/ScDTWzkZYcrohyFa3RXcfJcX1Fciv76tClTlVwfybpX9hGj1a4VAYTuRMVesQgtI6v8iGyrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=c+pZUSm5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="c+pZUSm5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1ZpIIGiAzp9dlmnlhXDwO9rr0Iyle3/GOpYyQPgYY/c=;
	t=1757599206; x=1758808806; b=c+pZUSm5LbqVBJ6KT8JD/3Ay0wzIiFiO38ppszYCZencX0+
	ozBBP72BYDJO7LFpEFEOQbkwejkhYdpjw/xZCyfBVUw9TRvqb6mNPnxVeGAz3FRp63AP5tjvTL6Na
	bU3oV5htnojFLFIrSOwhwYzSBWsFD6O58zkrFrltAJFE13j+vo2ya3vC8X9aU+hYReGhReXlNu9+M
	Z/IUbCW5MgG+kXiDrT/0iZ4Py1DD1jHWUCk4aRxVZdgGiATF9SJ/BBekwLau2K+vvyUXq2/v8737t
	jSObblBK1U1wnLnWcakw9hKB293UKLM5EXkvX/j5i3aXHSTVnguG5SO/txRNdfCw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uwhq3-0000000FP2l-2ojG;
	Thu, 11 Sep 2025 15:59:51 +0200
Message-ID: <cf3eef898266e5a8064c6cc5d2c12a9b0971f75c.camel@sipsolutions.net>
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
Date: Thu, 11 Sep 2025 15:59:50 +0200
In-Reply-To: <6eda1208c08130e00cb54e557bc4858ce10a4a94.camel@sipsolutions.net>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
		 <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
		 <CAG_fn=Vco04b9mUPgA1Du28+P4q4wgKNk6huCzU34XWitCL8iQ@mail.gmail.com>
		 (sfid-20250910_124126_320471_24812999) <6eda1208c08130e00cb54e557bc4858ce10a4a94.camel@sipsolutions.net>
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

Hi again :-)

So I've been spending another day on this, looking at kafl/nyx as
promised, and thinking about afl++ integration.

> I've been looking also at broader fuzzing tools such as nyx-fuzz and
> related kafl [1] which are cool in theory (and are intended to address
> your "cannot fork VMs quickly enough" issue), but ... while running a
> modified host kernel etc. is sufficient for research, it's practically
> impossible for deploying things since you have to stay on top of
> security etc.
>=20
> [1] https://intellabs.github.io/kAFL/tutorials/linux/fuzzing_linux_kernel=
.html
>=20
> That said, it seems to me that upstream kvm code actually has Intel-PT
> support and also dirty page logging (presumably for VM migration), so
> I'm not entirely sure what the nyx/kafl host kernel actually really
> adds. But I have yet to research this in detail, I've now asked some
> folks at Intel who work(ed) on it.

It's actually a bit more nuanced - it can work without Intel-PT using
instrumentation for feedback and using the upstream kvm PML APIs, but
then it requires the "vmware backdoor" enabled.

Also, the qemu they have is based on version 4.2, according to the bug
tracker there were two failed attempts at forward-porting it.


> Which I'm not arguing is bad, quite the opposite, but I'm also close to
> just giving up on the whole UML thing precisely _because_ of it, since
> there's no way anyone can compete with Google's deployment, and adding
> somewhat competing infrastructure to the kernel will just complicate
> matters. Which is maybe unfortunate, because a fork/fuzz model often
> seems more usable in practice, and in particular can also be used more
> easily for regression tests.

Or maybe not given the state of the kafl/nyx world... :)

I also just spent a bunch of time looking at integrating afl++ with kcov
and it seems ... tricky? There seem to be assumptions on the data format
in afl++, but the kcov data format is entirely different, both for block
and compare tracking. I think it could be made to work most easily by
first supporting -fsanitize-coverage=3Dtrace-pc-guard in kcov (which is
clang only at this point), and adding a new KCOV_TRACE_ mode for it, one
that indexes by guard pointer and assigns incrementing numbers to those
like afl does, or so?

I'd think it'd be useful to also be able to run afl++ on the kfuzztests
proposed here by forwarding the kcov data. For this though, it seems it
might also be useful to actually wait for remote kcov to finish? Yeah
there's still the whole state issue, but at least (remote) kcov will
only trace code that's actually relevant to the injected data. This
would be with afl running as a normal userspace process against the
kfuzztest of the kernel it's running in, but with some additional setup
it'd also be possible to apply it to UML with forking to avoid state
issues.

(And yes, kcov seems to work fine on UML.)

I guess I'll go play with this some unless someone sees total show-
stoppers.

johannes
