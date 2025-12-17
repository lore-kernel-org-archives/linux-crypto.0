Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900163AD49F;
	Wed, 17 Dec 2025 10:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765967511; cv=none; b=LMU4KWNmQf2chgYBZSBD36zTV79YAKpCmzeHh/v90guUj10wHIayLFKcxUolZmkgEzKRiSgfxR0k5IzbKn2W15rOHLdIpxzFjJcSJpEGFCkO/KVxwILtu6asbsODiNxBo8Xqr1ydfM/KpPDu3nOV5cfjSfu9oXRUJejIeuk9sek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765967511; c=relaxed/simple;
	bh=b1d43wiHNx7VZeptPxlkNjgMo8OMak4wV1yoG3x6lk8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kOry/JXOQ/QMPcQJ0vh5da42H8gexG84gE4sXSPnEVbF7vZaGngrd/G6mcVne6+OBuxkB2tP1uDCyVUm03jXXNlLxWTsKerojkQt4auKZU8CxebBQpCMMzJ22OySqsdYUglckEWtbS7zvcWsqC8F/edUebJt9VQ5lL4rjJ9KPvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=mYC6kmlh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="mYC6kmlh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=b1d43wiHNx7VZeptPxlkNjgMo8OMak4wV1yoG3x6lk8=;
	t=1765967509; x=1767177109; b=mYC6kmlhAFItc8sqeH+9xJ5jAbn3bXEhk0HAZBMLSgZO1G2
	D8eVRevoU0Ubspt8+X8Qmt/fRWikuf+Do4D+6WQF4k9lcB7JuLI2/a2T4ObhIagP8wvs4fK9cIGXp
	IMMbaJAx6KDgck8joZ43TleGqmbzsC6AW4Z3KH/8Qa+sJtK0VmBgDUQ2/mOZEDUV0aQfRjAXFeGb7
	pAzNaAj5I3/H1xDq9yejWl/tHkv91b65xc7XuyvwnXrAtAZmAb05fU/faru64I2ke7Sm+3ChxGN87
	tvBM5VJhXt8jBf30tq+DSHgyQbr9GC4mcPGuIlKESCwy99jyCtGyNjqi/0xWgJyQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vVooa-0000000BlwN-2EFt;
	Wed, 17 Dec 2025 11:31:29 +0100
Message-ID: <9adc2c51cb0b176006c362c26f2b1804a37b48d6.camel@sipsolutions.net>
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Potapenko <glider@google.com>, David Gow <davidgow@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Ethan Graham	
 <ethan.w.s.graham@gmail.com>, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, dhowells@redhat.com, dvyukov@google.com,
 elver@google.com, 	herbert@gondor.apana.org.au, ignat@cloudflare.com,
 jack@suse.cz, jannh@google.com, 	kasan-dev@googlegroups.com,
 kees@kernel.org, kunit-dev@googlegroups.com, 	linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 	lukas@wunner.de,
 rmoar@google.com, shuah@kernel.org, sj@kernel.org, 	tarasmadan@google.com
Date: Wed, 17 Dec 2025 11:31:26 +0100
In-Reply-To: <CAG_fn=WvdKZgmkqa09kwLLH3P_j6GFYzopeD-PZ-Qt0-1KUaGw@mail.gmail.com> (sfid-20251217_111949_169881_DE704F52)
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
	 <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org>
	 <CABVgOSkbV0idRzeMmsUEtDo=U5Tzqc116mt_=jqW-xsToec_wQ@mail.gmail.com>
	 <CAG_fn=WvdKZgmkqa09kwLLH3P_j6GFYzopeD-PZ-Qt0-1KUaGw@mail.gmail.com>
	 (sfid-20251217_111949_169881_DE704F52)
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

On Wed, 2025-12-17 at 11:19 +0100, Alexander Potapenko wrote:
> > >=20
> > > As discussed at LPC, the tight tie between one single external user-s=
pace
> > > tool isn't something I am in favor of. The reason being, if the users=
pace
> > > app disappears all this kernel code stays with no way to trigger.
> > >=20
> > > Ethan and I discussed at LPC and I asked Ethan to come up with a gene=
ric way
> > > to trigger the fuzz code that doesn't solely depend on a single users=
-space
> > > application.
> > >=20
> >=20
> > FWIW, the included kfuzztest-bridge utility works fine as a separate,
> > in-tree way of triggering the fuzz code. It's definitely not totally
> > standalone, but can be useful with some ad-hoc descriptions and piping
> > through /dev/urandom or similar. (Personally, I think it'd be a really
> > nice way of distributing reproducers.)
> >=20
> > The only thing really missing would be having the kfuzztest-bridge
> > interface descriptions available (or, ideally, autogenerated somehow).
> > Maybe a simple wrapper to run it in a loop as a super-basic
> > (non-guided) fuzzer, if you wanted to be fancy.
> >=20
> > -- David
>=20
> An alternative Ethan and I discussed was implementing only
> FUZZ_TEST_SIMPLE for the initial commit.
> It wouldn't even need the bridge tool, because the inputs are
> unstructured, and triggering them would involve running `head -c N
> /dev/urandom > /sys/kernel/debug/kfuzztest/TEST_NAME/input_simple`
> This won't let us pass complex data structures from the userspace, but
> we can revisit that when there's an actual demand for it.

I feel like we had all this discussion before and I failed to be taken
seriously ;-)

For the record: I'm all for simplifying this. I had [1] looked into
integrating this framework with say afl++ or honggfuzz (the latter is
simpler due to the way coverage feedback is done) *inside* ARCH=3Dum, but
this whole structured approach and lack of discoverability at runtime
(need to parse the debug data out of the kernel binary) basically throws
a wrench into it for (currently) nothing.

[1] other projects have taken precedence for now, unfortunately

And I do think it creates an effective dependency on syzkaller, running
via the bridge tool isn't something you can even do in such a context
since it's "userspace in the kernel" vs. "fuzzer integrated with the
(UML) kernel", you'd have to put the bridge tool into the kernel binary
somehow or so.

So to me, the bridge tool might be great for manual work (initial
development and reproducers) on a test, but I don't really see how it'd
be suitable for fuzzing runs. I expect it'd also be quite a speedbump,
and makes integrating coverage feedback harder too.

johannes
