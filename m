Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC918305968;
	Fri, 24 Oct 2025 08:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761295092; cv=none; b=htPaNIFWmUztPBUKRKg1gOY5/SRI9lg8RPzY+Ap8nddteMxF6kreK6DxnYpyCKMZxlvusD1eoEeCCEpS7kMFKumgjavcGlRATHRG7JmKcDb2qoz6HrLWXvIPuwDVDSTRwE84U/VpnofiAYFhz/15/3Jxru1uBPX9KRaXsa30EiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761295092; c=relaxed/simple;
	bh=X0AK2AeMhixfqv+IIy3w6nxQk/qRTqidLVVVTOEJCmI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bVGeStqnaMZT6dZxOexUYyVqSfHgSD1yVMOuY0d+ULy35Ts8W7NUjFCb0/33okLr3+7fk2cDnfdwU6XyuQwpXzQptoeD93yf7ALTR4c7iB3QGFNISchXldKvSbkxAYD1fNA07RbyLqEP0R44/fvxp1Ztv3uSka5k7QztAi7xXDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BGCyNZWh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BGCyNZWh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=L7lT/wMZ1LMdwxMJTrMezCGdtazbt1qIWepTcDamS+o=;
	t=1761295090; x=1762504690; b=BGCyNZWhzo8RUUdRzixBT2VzHiS8HQC8yet1u76Zj4WX1Ww
	JM/OvZsMO7zVdzLfKTcj9KUPdwN2xyVpXuccyHEv1FY8pPcIYeF0vbasrOocMoCunF10LpKeInIUT
	Lat7JguFy3FtUa/1BaUeod9QZ7Yda7/A9+pGBTzKjjBiUKoTcAXTvS3vZ9dC+jtQGREmFvpQXj2UA
	hqOVH2WCxhC3ZHfISHFaz1IyKzbBLITAHhFQSqyvxRfHumw10EKtThbt5pqXu/9/YtWF+v3WEE2I6
	m1QdEElfYLOL2WItoF7zZ6IdZwzViSJIDPQOEPFWxaWfQBKUAsh/vp9FNkPI7lXQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vCDJ9-00000002PD9-0Qfp;
	Fri, 24 Oct 2025 10:37:59 +0200
Message-ID: <438ff89e22a815c81406c3c8761a951b0c7e6916.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com,
 dvyukov@google.com, 	elver@google.com, herbert@gondor.apana.org.au,
 ignat@cloudflare.com, jack@suse.cz, 	jannh@google.com,
 kasan-dev@googlegroups.com, kees@kernel.org, 	kunit-dev@googlegroups.com,
 linux-crypto@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lukas@wunner.de, 	rmoar@google.com, shuah@kernel.org,
 sj@kernel.org, tarasmadan@google.com
Date: Fri, 24 Oct 2025 10:37:57 +0200
In-Reply-To: <CANgxf6xOJgP6254S8EgSdiivrfE-aJDEQbDdXzWi7K4BCTdrXg@mail.gmail.com> (sfid-20250925_103550_253525_F09A62BB)
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
	 <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
	 <CANgxf6xOJgP6254S8EgSdiivrfE-aJDEQbDdXzWi7K4BCTdrXg@mail.gmail.com>
	 (sfid-20250925_103550_253525_F09A62BB)
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

Hi Ethan, all,

Sorry, my=C2=A0current foray into fuzzing got preempted by other things ...

> > So ... I guess I understand the motivation to make this easy for
> > developers, but I'm not sure I'm happy to have all of this effectively
> > depend on syzkaller.
>=20
> I would argue that it only depends on syzkaller because it is currently
> the only fuzzer that implements support for KFuzzTest. The communication
> interface itself is agnostic.

Yeah I can see how you could argue that. However, syzkaller is also
effectively the only fuzzer now that supports what you later call "smart
input generation", and adding it to any other fuzzer is really not
straight-forward, at least to me. No other fuzzer seems to really have
felt a need to have this, and there are ... dozens?

> > the record, and everyone else who might be reading, here's my
> > understanding:
> >=20
> >  - the FUZZ_TEST() macro declares some magic in the Linux binary,
> >    including the name of the struct that describes the necessary input
> >=20
> >  - there's a parser in syzkaller (and not really usable standalone) tha=
t
> >    can parse the vmlinux binary (and doesn't handle modules) and
> >    generates descriptions for the input from it
> >=20
> >  - I _think_ that the bridge tool uses these descriptions, though the
> >    example you have in the documentation just says "use this command fo=
r
> >    this test" and makes no representation as to how the first argument
> >    to the bridge tool is created, it just appears out of thin air
>=20
> syzkaller doesn't use the bridge tool at all.=C2=A0

Right.

> Since a KFuzzTest target is
> invoked when you write encoded data into its debugfs input file, any
> fuzzer that is able to do this is able to fuzz it - this is what syzkalle=
r
> does. The bridge tool was added to provide an out-of-the-box tool
> for fuzzing KFuzzTest targets with arbitrary data that doesn't depend
> on syzkaller at all.

Yes, I understand, I guess it just feels a bit like a fig-leaf to me to
paper over "you need syzkaller" because there's no way to really
(efficiently) use it for fuzzing.

> In the provided examples, the kfuzztest-bridge descriptions were
> hand-written, but it's also feasible to generate them with the ELF
> metadata in vmlinux. It would be easy to implement support for
> this in syzkaller, but then we would depend on an external tool
> for autogenerating these descriptions which we wanted to avoid.

Oh, I get that you wouldn't necessarily want to have a dependency on
syzkaller in the kernel example code, but in a sense my argument is that
there's no such tool at all since syzkaller cannot output anything, and
then you need to write all the descriptions by hand. Which is fine for
an _example_ but really doesn't scale to actually running fuzzing.

So then we're mostly back to "you need syzkaller to run fuzzing against
this", which at least to me isn't a great situation.

> >  - the bridge tool will then parse the description and use some random
> >    data to create the serialised data that's deserialized in the kernel
> >    and then passed to the test
>=20
> This is exactly right. It's not used by syzkaller, but this is how it's
> intended to work when it's used as a standalone tool, or for bridging
> between KFuzzTest targets and an arbitrary fuzzer that doesn't
> implement the required encoding logic.

Yeah I guess, but that still requires hand-coding the descriptions (or
writing a separate parser), and notably doesn't work with a sort of in-
process fuzzing I was envisioning for ARCH=3Dum. Which ought to be much
faster, and even combinable with fork() as I alluded to in earlier
emails.

> > I was really hoping to integrate this with ARCH=3Dum and other fuzzers[=
1],
> > but ... I don't really think it's entirely feasible. I can basically
> > only require hard-coding the input description like the bridge tool
> > does, but that doesn't scale, or attempt to extract a few thousand line=
s
> > of code from syzkaller to extract the data...
>=20
> I would argue that integrating with other fuzzers is feasible, but it doe=
s
> require some if not a lot of work depending on the level of support. syzk=
aller
> already did most of the heavy lifting with smart input generation and mut=
ation
> for kernel functions, so the changes needed for KFuzzTest were mainly:
>=20
> - Dynamically discovering targets, but you could just as easily write a
>   syzkaller description for them.
> - Encoding logic for the input format.
>=20
> Assuming a fuzzer is able to generate C-struct inputs for a kernel functi=
on,
> the only further requirement is being able to encode the input and write
> it into the debugfs input file. The ELF data extraction is a nice-to-have
> for sure, but it's not a strict requirement.

I mean, yeah, I guess but ... Is there a fuzzer that is able generate
such input? I haven't seen one. And running the bridge tool separately
is going to be rather expensive (vs. in-process like I'm thinking
about), and some form of data extraction is needed to make this scale at
all.

Sure, I can do it all manually for a single test, but is it really a
good idea that syzkaller is the only thing that could possibly run this
at scale?

> > I guess the biggest question to me is ultimately why all that is
> > necessary? Right now, there's only the single example kfuzztest that
> > even uses this infrastructure beyond a single linear buffer [2]. Where
> > is all that complexity even worth it? It's expressly intended for
> > simpler pieces of code that parse something ("data parsers, format
> > converters").
>=20
> You're right that the provided examples don't leverage the feature of
> being able to pass more complex nested data into the kernel. Perhaps
> for a future iteration, it might be worth adding a target for a function
> that takes more complex input. What do you think?

Well, I guess my thought is that there isn't actually going to be a good
example that really _requires_ all this flexibility. We're going to want
to test (mostly?) functions that consume untrusted data, but untrusted
data tends to come in the form of a linear blob, via the network, from a
file, from userspace, etc. Pretty much only the syscall boundary has
highly structured untrusted data, but syzkaller already fuzzes that and
we're not likely to write special kfuzztests for syscalls?

> I'm not sure how much of the kernel complexity really could be reduced
> if we decided to support only simpler inputs (e.g., linear buffers).
> It would certainly simplify the fuzzer implementation, but the kernel
> code would likely be similar if not the same.

Well, you wouldn't need the whole custom serialization format and
deserialization code for a start, nor the linker changes around
KFUZZTEST_TABLE since run-time discovery would likely be sufficient,
though of course those are trivial. And the deserialization is almost
half of the overall infrastructure code?

Anyway, I don't really know what to do. Maybe this has even landed by
now ;-) I certainly would've preferred something that was easier to use
with other fuzzers and in-process fuzzing in ARCH=3Dum, but then that'd
now mean I need to plug it in at a completely different level, or write
a DWARF parser and serializer if I don't want to have to hand-code each
target.

I really do want to do fuzz testing on wifi, but with kfuzztest it
basically means I rely on syzbot to actually run it or have to run
syzkaller myself, rather than being able to integrate it with other
fuzzers say in ARCH=3Dum. Personally, I think it'd be worthwhile to have
that, but I don't see how to integrate it well with this infrastructure.

Also, more generally, it seems unlikely that _anyone_ would ever do
this, and then it's basically only syzbot that will ever run it.

johannes
