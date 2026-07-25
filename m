Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0531E32D6;
	Sat, 25 Jul 2026 07:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965080; cv=none; b=D1DnP+HMHGY9qqr0VW8C1orUJq8YpcPLUA1UYfx6GoOwMiCLDKPcE+UxLgV6uxm+hzCw/IWlDIFIB+c9E3S+OJtVGViNlWrS8edokHzu9qp5kMWD50v5iM/Mc6tzwWUuRQljtNSahieNqURXRvXcj0lI6+6TOpyPSHa4PjILdDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965080; c=relaxed/simple;
	bh=XjL/PCTTieyF1xuNrQwjb5zJt0BmcSy3+BD71z3Fnnk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=c9g33Tt5AE9/vOj2n48iMCBlrwaiOQDX9ioH9vIuMZmMZF3eWv/cM59szJNDVXQy3lUcLBQLgag7v99DGeB50Qdm6x12DxQVVK8pVdUEwLn7bCSBOt7v4/PQzQRYEmlxEFuiKO2VTn35zGF/hxiGUfelFD3Bz8vsNNhTGsPnGXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=AZe73xcu; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="AZe73xcu"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id D757B14C2DF;
	Sat, 25 Jul 2026 09:37:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1784965069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=tI0aeDER7Ie5hOnB/yxjs2BvnuC8dTCzHI34tLG10UM=;
	b=AZe73xcuIaxpzTg5ROjdccFdEV91hiVQLVe3GipGQhe7/Ih0uK2sSP6+AQf3RgMIjNnb2y
	w8xgtuLmRVBXO8R59hvckA9jgljBg+iUfJOKsRCAzv0M5tKHXfJTA1QoHE6svDnJKT8l+i
	sZnHPSqd+R9OwFdV/Ccax6+MGVmjt1iDkMijgEfGycE03/fHJE+fm8jjSrgjoXE+P8VJCH
	G2IIpS7ThrWXnoD4DolaIf3UAyDVtjxMI/i4ov02PmXt6SDlBnoJh8KvjmzYq7V6jLw9Fi
	si7XtoS5WqqY/+VOcENH1X65MxBnF3KK1x/0oRamQBiF2t8OBDpLYEmEixJdTw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 177d4002;
	Sat, 25 Jul 2026 07:37:39 +0000 (UTC)
Date: Sat, 25 Jul 2026 16:37:24 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
	adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
	ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net,
	davem@davemloft.net, edumazet@google.com,
	herbert@gondor.apana.org.au, horms@kernel.org,
	io-uring@vger.kernel.org, irogers@google.com,
	james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
	kuniyu@google.com, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
	willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Message-ID: <amRntEmCUK-8wXcw@codewreck.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0ccda05f-077c-4661-b852-e6bf9bf40be3@gmail.com>
 <20260724180951.GA1572592@google.com>

Thank you both for your time replying

Eric Biggers wrote on Fri, Jul 24, 2026 at 06:09:51PM +0000:
> On Sat, Jul 25, 2026 at 01:32:12AM +0900, Dominique Martinet wrote:
> > There's not much I can do about the vendor's kernel I'm stuck with, but
> > that doesn't make having encryption material not accessible to userspace
> > useless as a concept;
> > forgetting about the sysctl for now, what are the alternatives API this
> > kind of implementations could be based on?
> > 
> > I guess I should start looking at how tpm backed encryption works,
> > some other day, it's getting late here...
> 
> First, we should remember that implementing hardware-bound keys via a
> standalone crypto engine is a dated approach.  Inline crypto engines and
> CPUs, which work much better than and are much easier to use than legacy
> standalone crypto engines, can support hardware-bound keys as well.  The
> former is already supported, and is already being widely used, in the
> kernel via the hardware-wrapped inline crypto keys feature.  For the
> latter, see e.g. RISC-V High Assurance Cryptography.  In the CPU case no
> UAPI is even needed; userspace can just use it directly.

Thank you, this is exactly what I was asking about - my background isn't
crypto and ultimately whatever direction is implemented will depend on
$vendor and I'll just be following along, but I'll read up on this.

"Inline crypto engine" seems to be a qualcomm marketing term, but from
looking at their doc the API seems to be PKCS#11 smart card?
Having worked on these for some other hardware I can't say I find it
easier to use than af alg, but it's definitely something that can be
worked out.

"The CPU case" (looking at the RISC-V High Assurance Cryptography) would
be some CPU instructions (ISA) reserved for crypto ops?
That's interesting, I had never seen this but I can see this would
likely provide the best performance.. And if the ISA gain enough
traction having them supported out of the box by OpenSSL or whatsnot
might actually be possible, that'd be a great step forward.


> But with that being said, yes, there are a few in-tree drivers that
> register "paes" algorithms with the crypto_skcipher or crypto_aead APIs,
> or "phmac" with crypto_ahash.  That made them accessible via AF_ALG.
> 
> Of course, no use of these via AF_ALG has actually been confirmed yet.
> Note that any such use would be unrelated to any use via dm-crypt or
> dm-integrity, as those features call the kernel's crypto code directly.
> 
> But if any are confirmed and we end up needing to allowlist any of these
> specific hardware-bound key algorithms in AF_ALG for compatibility
> reasons, we can do that.  That does not mean we should allowlist
> out-of-tree algorithms, or asynchronous algorithms in general.

Right, sorry for asking about an out-of-tree driver, I hadn't realized
since caam itself has been upstream for a while.

I was just curious about the double-take approach taken with these two patches:
 crypto: af_alg - Drop support for off-CPU cryptography (this)
 crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1 ([4])
[4] https://lore.kernel.org/linux-crypto/20260622234803.6982-1-ebiggers@kernel.org/T/#u

I assume part of it was just that the whitelist wasn't ready yet when
this patch was merged, but as far as I understand if the whitelist
sysctl is implemented this is basically noop?
(Well, I guess it'll allow code simplification over time, but these
hopefully won't be backported to stable kernels too aggressively.. While
I fully expect to see this "Drop support for off-CPU crypto" patch to
show up in a couple of weeks in older stable trees; and for practical
purposes I don't see much way around just reverting it for now)

Thanks for putting up with me.

> We should also remember that AF_ALG has never actually supported
> creating hardware-bound keys.  Anyone using it actually needs to use a
> different UAPI to create the key.  This is driver-specific.  For CAAM it
> seems to involve keyctl() calls, whereas for s390 it's /dev/pkey.  Any
> userspace program that (theoretically) would be using either one has to
> know which type of hardware it's talking to anyway.

Right, the program I rely on actually uses a /dev/caam-keygen device
from another NXP non-upstreamed patch, but you are correct that there is
driver specific glue already.

> So with this being a dated approach and also driver-specific anyway, and
> with at least one driver using a char device already, I think the
> replacement here (if any is needed for the few standalone crypto engine
> drivers that implement this) would just be a driver-specific char device
> with the minimum functionality required.  We shouldn't overthink things.

So this is basically what Demi Marie suggested as well, and I'm sure we
can come up with driver specific APIs that are simpler than af alg,
but these are actually a pain to support for me (in my position of
"device integrator" building OS blocks for a variety of platforms)

I'm also "supporting" SE050 and ATECC608A out of chip "secure elements",
as well as looking at i.MX in-chip "edgelock secure enclave" as well as
the caam algorithm I was talking about here, and they all require some
sort of middleware that's far from trivial to configure and get to play
nice together
(if someone's curious, these three:
 https://github.com/NXP/plug-and-trust
 https://github.com/microchiptech/cryptoauthlib
 https://github.com/nxp-imx/imx-secure-enclave
)

So being selfish I'd very much appreciate some effort to have a standard
API everyone could use to simplify my userspace, but given vendors will
never spend this kind of time I guess it's a pipe dream and I'll be
stuck with custom drivers and/or framework for the forseeable future...
But it's not like complaining about this to either of you is any help,
I'm grateful you took the time to answer so far.


Thanks,
-- 
Dominique Martinet | Asmadeus
