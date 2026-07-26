Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DBF3BC69C;
	Sun, 26 Jul 2026 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785081139; cv=none; b=ENI4mOf2Ly0llgKteOIcqzknNGnZhvOAHVT/H/BbseWjZJB7SjdmcnkLi2nntZu3PovVLSeHXy3gUMIa0BYLNz8sVCXoH3n1RLfyZa+E3WvuWYtxP+XHBEBzB5PkLXFgrsSNMzT5dq3ClQa3vSn2fUUSYAycgHBIaEeJQTegJlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785081139; c=relaxed/simple;
	bh=CntcIonM9I0QlK+PLIkdPKTiyF1MW70gGi74k+GC07Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fx+Z6+MDtqI0WpZL73WEDUZKNP21LIpmjRl7C9ZHc2FRNCFkh/M2TZIY4TSdGDoF3L7proQLlof8+r91pM3TH2nNJK90c1rFzf/9OWm7080slCDwOwoWhXPBwpoQWcPIKhOxCG1y8vSdnWncaC3IkX1Dv0bEgPcLt8Aaf2iHwag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ro1iKTqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ro1iKTqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091A41F000E9;
	Sun, 26 Jul 2026 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785081138;
	bh=uqkCckTZP/oUm6TGK+F/qrjFgcat1+M2w/YXj+9Q7CY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ro1iKTqbVdCghKAp3LD2qNRnM8OFPuPVcJVrOVpsRp4enPKNhAQd1VGnEPAwu21X9
	 vQJyolh2oLHkTFP9Uta7KZTRwYDZKsM2LxNCz1aLhrOSfo0B2cfbYRj/L+3mfZIi6s
	 sArefMy/nJEJG24qthmObCx7dIw2ot/2OqAR0egYfwK1b2CI4rAchuNyx2nCqmTii3
	 goc1hAaej7Gsf0+/9By6FQd6qrQRjgiZQYFw2F5mqpmJ/tbzNyVFoiJKbqNE/54CTo
	 u3cJWjH9LceRJ6uMQ4+NLjMhGI3QbclggsiJz5U3tfG4nJsvnodXgTMyfjtatq2yRL
	 BpmSxESC4VmqQ==
Date: Sun, 26 Jul 2026 08:50:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>, demiobenour@gmail.com,
	Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
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
Message-ID: <20260726155024.GB1673@sol>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol>
 <amOTjPW__CNZui3_@codewreck.org>
 <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>
 <20260725220443.GA41199@quark>
 <CAFLxGvyBGzfwh61F5YkYqctNPCQJCpFOwTtKfDs4L+iK8WJZpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLxGvyBGzfwh61F5YkYqctNPCQJCpFOwTtKfDs4L+iK8WJZpQ@mail.gmail.com>

On Sun, Jul 26, 2026 at 09:28:14AM +0200, Richard Weinberger wrote:
> On Sun, Jul 26, 2026 at 12:04 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > You can create a CAAM BLOB (a generated and sealed key) using the
> > > trusted keys subsystem and use this BLOB
> > > later in AF_ALG to perform AES with a key invisible to userspace.
> > >
> > > e.g.
> > > kid=$(keyctl add trusted mykey "new 32 pk" @s)
> > > keyctl print $kid | xxd -r -p > blob.bin
> > > Then just create a caam_pkey_info in userspace and feed it into AF_ALG
> > > and perform AES with it.
> >
> > Well, specifically AES-CBC.  That's the only one that is in the driver.
> 
> Yes.
> 
> > > So, pretty please,  if you kill AF_ALG and all this, offer some way to
> > > achieve the same in userspace.
> >
> > If needed, "cbc(paes)" and/or "cbc-paes-caam" (whichever name it is
> > being accessed as) can be allowed as a special case, as a stop-gap.
> 
> Would be great.
> 
> > This would need confirmed use of that specific algorithm with upstream,
> > which we don't quite have yet.  Dominique had a confirmed use of
> > "tk(cbc(aes))", but that has never existed upstream in the first place,
> > so it's not something that could be allowlisted upstream.
> 
> It's "cbc(paes)".
> 
> From one of my demo applications:
> 
> struct sockaddr_alg sa = {
>        .salg_family = AF_ALG,
>        .salg_type = "skcipher",
>        .salg_name = "cbc(paes)",
> };
> 
> > You've only mentioned that it "can" be used in this way in upstream.
> > Can you confirm that it *is* used, and with an actual upstream algorithm
> > name, and if so which one(s)?  And if so, would you also be able to
> > share whether this is for dm-crypt or not?  We should remember that
> > dm-crypt accepts keys directly and AF_ALG is not needed to use it.
> 
> Well, if you require me to point to some open source application, sorry I can't.
> 
> But no, the use cases I know about are not dm-crypt.
> It's more allowing to encrypt/decrypt data in userspace without being able to
> extract the key from the device. Since the key is hardware bound too,
> it is device
> specific and you cannot decrypt on device B what you have encrypted on A, even
> if you share the BLOB.
> So, it's more like a building block for a poor man's secure element.
> 
> At $dayjob we've been recommending AF_ALG because it's a standard interface.
> Not like other ad-hoc horrors via sysfs or worse we've seen on some BSPs.

Then I would suggest that skcipher_bind() should check if the name is
"cbc(paes)", and if so use 0 instead of AF_ALG_CRYPTOAPI_MASK.  Please
go ahead and send a patch against mainline (for v7.2-rc6) if you're
interested.

On cryptodev/master (future 7.3) it should get an entry in the new
skcipher_allowlist as well: { "cbc(paes)", true }.  That would be a
separate patch.

With those it will keep working as root.  (And you mentioned in your
other email it's used only as root anyway.)

- Eric
