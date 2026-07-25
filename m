Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2EB2D23BC;
	Sat, 25 Jul 2026 23:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785020967; cv=none; b=rmtOsRHPvJVgX0BCP7mNas72b8oTchAYOsdvV5UrX9VfkJoQxeW4nFvRUEQhR06WqxRHXDmSbq5VSFSoxQx8OSe3d0I6GgjBkpKivNgonS4EjlPS73ixEzlON56p/zMEJng+AKNlRjzbgLnnyAk4U5rQJaRJplFSGUda/2iBc8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785020967; c=relaxed/simple;
	bh=RwQMAfhKNwgAo9MbnInWBus6Iltd0UewoV2ojaJ321o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cgupUwAIvvZSFPKCWdENnWwAtuTkhBGrUwHwzUMBM8nPCQUO6/otRsp7ByioVukLTQPRPRQY1uTxjY18zQ/p726PIOV+huGqwxbGwhp7C701AJQpd1nangxMRrfsKbNoJZUhQTD+CsDq7y4TIXk67MruHqO1s2DsPlXR0uPTnYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahz92pZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahz92pZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952E21F000E9;
	Sat, 25 Jul 2026 23:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785020965;
	bh=d0ATcTOoIS9vcu5+PZnxo8woG8OIu/ppqkM6rmR5w50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ahz92pZjHp9nDIjldrNDRNpm+gfhyeVyLKKWQvLAEuA+QeXHud4mvvhS8GqN1e6Hw
	 avTDmp+kmKWcEyCgwVlULgONzw250svj5WbJnjv0BRQlP+Pcmnat4QJbFAhRkECl/d
	 H/BELVRDDPjs7As205qbTvUtxAYT243hnhCEPov9hj6/q//5Hn12ePmw9bzCbO1nDP
	 Re/BukIWRT/7H/1C1O547AoaE6HpqsFu7Mgow+1Y0U3h6zSNZe8VOunucV165bLG6p
	 93W1Rbj0KiAw/Of+iRemWhrZ781RuaKBoMrZhuo3keLQ11s5YqURumcvByiJB6CUKZ
	 J7DlvAHkneTxA==
Date: Sat, 25 Jul 2026 16:09:22 -0700
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
Message-ID: <20260725230922.GB41199@quark>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol>
 <amOTjPW__CNZui3_@codewreck.org>
 <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>
 <20260725220443.GA41199@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725220443.GA41199@quark>

On Sat, Jul 25, 2026 at 03:04:43PM -0700, Eric Biggers wrote:
> If needed, "cbc(paes)" and/or "cbc-paes-caam" (whichever name it is
> being accessed as) can be allowed as a special case, as a stop-gap.
> 
> This would need confirmed use of that specific algorithm with upstream,
> which we don't quite have yet.  Dominique had a confirmed use of
> "tk(cbc(aes))", but that has never existed upstream in the first place,
> so it's not something that could be allowlisted upstream.
> 
> You've only mentioned that it "can" be used in this way in upstream.
> Can you confirm that it *is* used, and with an actual upstream algorithm
> name, and if so which one(s)?  And if so, would you also be able to
> share whether this is for dm-crypt or not?  We should remember that
> dm-crypt accepts keys directly and AF_ALG is not needed to use it.

We'd also need to know whether the user (if there is one) requires
unprivileged use.

Hopefully not: these sorts of hardware crypto drivers have lots of bugs.
Indeed, the CAAM "cbc(paes)" doesn't validate the key length correctly,
leaks DMA mappings, concurrent requests race with each other, etc...

- Eric
