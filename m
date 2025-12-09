Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607C525B30E;
	Tue,  9 Dec 2025 01:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765243161; cv=none; b=B3FY3rAM0+1ggfULHMkNiSG91AOnSHEA9RZLkeY4zWS2PFE3ElDFRr9x3ClnysYfBuUduxDP950oA+ZGLN0TFGAdI8IQ+qsLZfCZcBZwDqbykJYRr6ayk/kwlh9LzUbL1BNx+CO29yHWgbagxrSbzfg3VaZVK3aEsd5YvnaNDXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765243161; c=relaxed/simple;
	bh=KYg2QA+oyodpwXCa4em7zzLH4OP/ozCcEO4d/3szxRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vcsk04TQXV1acqAPTZQqmMbjjLWvIT5JnYlAf2p2FCzWsYfLQSGCxASoWzlqJBfyf5RhRLFy34GYnV7Fll16yZB+UMn9GjUUwXU+HDwl5L6nK7aMZKUnMYlmiNx7zC0TIp2gy3PqotCm9AY+crGxLqNPXKmfn1cx34dQvXSvqtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l91t8Ehj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l91t8Ehj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65437C4CEF1;
	Tue,  9 Dec 2025 01:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765243160;
	bh=KYg2QA+oyodpwXCa4em7zzLH4OP/ozCcEO4d/3szxRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l91t8EhjG6fs3S5dnp5dsxIypYVNRr2xADj8qGqqQs6CpskyQo0MHTuKmMnVmuGON
	 40Enzvh6XKa7cWgzKw6q4RxUhhCTS2AVYYn33IhogSWwiqT3u1FKaqeWFffcujaytp
	 xvoDzNRmfxg5L5Pnn6BU2AvL4+x87jNaU9RF4Lgxb1MHV2tUmc3nir3zk1KD42MRqL
	 WcZeC81edaixV9vNaWsXKC1GtWxqCHE/hVh0cxhU5qfksH1TgOOL8/Okp4J5y/NADi
	 n+dBvB5J9nhC6TvN+Rybgorf6gcHvL9vve3hKGgS7wQRB3Uj+wZyXN/qZ5HtmRQlQ2
	 SomM+nCO+klLA==
Date: Mon, 8 Dec 2025 17:19:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ian Rogers <irogers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Fangrui Song <maskray@sourceware.org>,
	Pablo Galindo <pablogsal@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] perf genelf: Switch from SHA-1 to BLAKE2s for build ID
 generation
Message-ID: <20251209011916.GA1619@sol>
References: <20251205043121.62356-1-ebiggers@kernel.org>
 <CAP-5=fWaOTh6h-xP5y2SBG7Xe03jG0zTawkrT2kbc-GyhBG_oA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fWaOTh6h-xP5y2SBG7Xe03jG0zTawkrT2kbc-GyhBG_oA@mail.gmail.com>

On Fri, Dec 05, 2025 at 10:53:38AM -0800, Ian Rogers wrote:
> >  static struct buildid_note {
> >         Elf_Note desc;          /* descsz: size of build-id, must be multiple of 4 */
> >         char     name[4];       /* GNU\0 */
> > -       u8       build_id[SHA1_DIGEST_SIZE];
> > +       u8       build_id[20];
> 
> nit: Could we add a comment on where the value of 20 is coming from?
> We could use something like: sizeof(((struct
> perf_record_header_build_id*)0)->data). But a comment is enough imo.
> 
> Tested-by: Ian Rogers <irogers@google.com>
> 
> Thanks,
> Ian

It was already a literal 20 before "perf genelf: Remove libcrypto
dependency and use built-in sha1()".  So this change just restores the
previous literal 20.

This entire struct, not just the build ID field, appears to be an
external data format.  If you'd like to add a comment that describes
where this external data format is defined, presumably either the ELF
specification or binutils, that would be helpful.  But it seems outside
the scope of this change.

(I did put the literal 20 in the BLAKE2s test as well.  I'll put a
comment there that mentions that it matches the length used in the
non-test code.)

- Eric
