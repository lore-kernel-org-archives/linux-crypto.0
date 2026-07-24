Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C72360ECE;
	Fri, 24 Jul 2026 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784907396; cv=none; b=mo2lkRj76sSu2biDnsO7gsaV3Vgd92NOJ8WN0NlhJ6LRIHPYsr+WFDq6FtQO1pxbOnKI9rtu7L1DfftGthFW5dCBWiH+cS8L9mrjf4CPSQyttH9diny4XOM4ogJzkKiSlasJEYu854AZdOd1SbOGkJPDLljUSIG6Q3WttIeQADo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784907396; c=relaxed/simple;
	bh=v2uizrb49ng4W8H09GOxCH7086EukcsXISjNHh4+VZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smXHfNPNvDTZqAjftW74qyA8b5gS/5MGgfUfLO6GNdyqWG9nVK2rW1dLPW5OoouSkq0gati1o8xSyIrVb0wpMxEUefoSqJnpOzgICo4/Utfnu4XneblLMRh0QykfoVUIEmO18tLgyxFvVqSlrw9W7Uzu7WdTOfSfXCPwh4dgEMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=tKaX3VIm; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="tKaX3VIm"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 7DF9314C2D6;
	Fri, 24 Jul 2026 17:36:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1784907381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3DJPFRwghjW/OGMxJodaEoxseBzxbt0JIBUsvIGFSX8=;
	b=tKaX3VImhXPyYMLecEORXCFrxXRlcs9KVLCxJzwZrEJJyOG0v75vBiU1+8bluw7OW5eLO5
	LXqBJVCNJ3S5pMXQFUU+BfmtHW8K3ausocnEs0GwovayqN/NMujrH2urrrdpOOsKJUem4f
	FQPcMhUpwUvKSH2LvW6MLJWlsqEq+6NZCI8eYCyE+QhhNvElIqdVM6iDQ9MK64rH5y/Qhi
	Bviag3Q5TnwKdi6zaV/H3WAp753geUvJHgvS+cK7lgKRJlH6QM0GSTBpyVco45B2WqHZpw
	30iVpTVD0eCERjoYw8OEho18Y8H+lflch8QzA4OPmyv/IMVf5BnzXJrLgsGHVw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 50527fce;
	Fri, 24 Jul 2026 15:36:10 +0000 (UTC)
Date: Sat, 25 Jul 2026 00:35:55 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: demiobenour@gmail.com
Cc: Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
	adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
	ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net,
	davem@davemloft.net, ebiggers@google.com, edumazet@google.com,
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
Message-ID: <amOGWwdjnJqyxH5L@codewreck.org>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260603133312.12848-1-freude@linux.ibm.com>

Harald Freudenberger wrote on Wed, Jun 03, 2026 at 03:33:12PM +0200:
> > AF_ALG is deprecated and exposed to unprivileged userspace.  Only
> > use the least buggy algorithm implementations: the pure software ones.
> >
> 
> I thought AF_ALG is marked as deprecated but still usable. This patch
> now actively disables groups of crypto implementations. Also it just
> assumes that all algorithms which are asynchronously implemented or
> do not have a fallback are to be disabled via AF_ALG.
> 
> There are may reasons for not having a synchronous implementation. For
> example if you need to fetch (asynch) some information from a HSM before
> doing the job of the algorithm. Also all secure key operations can't
> by definition run directly on the CPU but need to be fed into some
> hardware. Same is true with just acceleration - and acceleration via
> special hardware (crypto hw, or AI hardware for example) is very common
> on platforms priced by CPU cycles.
> 
> I also can't find any arguments for the statement 'Hardware accelerator
> drivers are frequently buggy.' Does this mean that the linux kernel
> from now on will not accept any hardware accelerator drivers any more?
> Statements about code quality should be addressed to the driver
> maintainer but not lead to tagging of groups of drivers.
> 
> I can understand that the AF_ALG shall be deprecated and fade away.
> But this patch out of the sudden disables the long standing AF_ALG
> interface at least for testing purpose and causes some failures in
> the s390 crypto test area without any chance to react at all.

I've also stumbled upon this for our embedded use case: we use CAAM
"blob" keys on NXP socs (specifically i.MX8MP and i.MX8ULP at least),
which pretty much requires af_alg, because the key material is just not
available: it's not a matter of performance (we actually only
encrypt/decrypt a few KB that will be used for LUKS key or similar), the
hardware is required to perform the operation, and the only API
available is through the kernel afaik.

The tool source is available here:
https://github.com/nxp-imx/crypto_af_alg
(which now fails with:
bind(3, {sa_family=AF_ALG, salg_type="skcipher", salg_feat=0, salg_mask=0, salg_name="tk(cbc(aes))"}, 88) = -1 ENOENT (No such file or directory)
)


I don't particularily care for the API used as long as we can keep using
the hardware key, but as far as I can see there's no alternative API --
what's the path forward?

Short term would it make sense to re-enable and make it a sysctl knob
like af_alg_restrict[1]?
[1] https://lore.kernel.org/linux-crypto/20260622234803.6982-1-ebiggers@kernel.org/T/#u

Longer term we don't need many algorithm (the tool only supports
AES-256-CBC), so a much simpler API would do, but some replacement would
be greatly appreciated.. Embedded being embedded we can always kludge
something in, but I'd rather not fall back to that.


(I also second this felt sudden, I only noticed because the sysctl knob
made noise on fedora lists and I wanted to try, and it didn't
cherry-pick cleanly without this patch so that made me try, but I
probably wouldn't have noticed until much later otherwise...)


Thanks,
-- 
Dominique Martinet | Asmadeus
