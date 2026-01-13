Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D050355036;
	Tue, 13 Jan 2026 23:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768347848; cv=none; b=I64kvKsrAp3SjMvS/btVyyL4sPSmzO7i8rRvsbWhQrOciqxHJysGlEmlwJbZwZvrpHySmeCJMZMc8MLevm4ybSsZV5YvAv/5WtlvePkOgLeCrw85KHM3dipPgE/BM4Ug9Mj0G002a0Rt7L3S8hZDmPxsAToxhx6ur/WlIsE+oJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768347848; c=relaxed/simple;
	bh=lCdGaiMsVEaLNbsAaOxgLwGNktHeFZgQ86ipbE7bBAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hjk3kPDbzr2oWuJOy/dOMKsqHqziVxLyOLTgZGmKiC6dGYRhzA6Q2C42V6o0YeqCiOm6PY9XhGxN57UWUaJJiyTCDGCGU+ApJyuhLED6QEtr+eCStQl2rIqNat+R98Z7kz8F6g/QPrTDqUPk9MBSLKFD921nBpwAhjnTAt3nF2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hR9pXwFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hR9pXwFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBEDC116C6;
	Tue, 13 Jan 2026 23:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768347848;
	bh=lCdGaiMsVEaLNbsAaOxgLwGNktHeFZgQ86ipbE7bBAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hR9pXwFvd2D/HBkIidR/vnYVdcdP/Pb94j/j2N8ZuWzShpFZgz6rvLCSTzvLvL/fq
	 kf5nx7UIrmWbDGbb5Z7N0EPvyiZDsrUQfpUxcayXXZ012iXO/0KUqTs444iLAunWy7
	 ZHfsQfMdIt2e95oNgsLvkAnPjW3WZtIkVu5OuWhQLEiOmjkbjV+r5nn2vfxZW7nOk/
	 G93RX9FnyitOBOIomEqN7qBmsIteC2hyU87g81HvjberR55+vjzqkoJlfomjghkgIw
	 z0kH8DfENsWCze0UFhjOTnif4KA9jwIEpRXKkIRNHfE+woeMSm0DB0mju7B5V+gaAo
	 R5XfZsPmaVUSQ==
Date: Tue, 13 Jan 2026 15:44:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Fangrui Song <maskray@sourceware.org>,
	Pablo Galindo <pablogsal@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/3] perf util: Add BLAKE2s support
Message-ID: <20260113234405.GA2178@quark>
References: <20251209015729.23253-1-ebiggers@kernel.org>
 <20251209015729.23253-2-ebiggers@kernel.org>
 <aWakZaNtNDTv2hFM@x1>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWakZaNtNDTv2hFM@x1>

On Tue, Jan 13, 2026 at 05:00:37PM -0300, Arnaldo Carvalho de Melo wrote:
> On Mon, Dec 08, 2025 at 05:57:27PM -0800, Eric Biggers wrote:
> > Add BLAKE2s support to the perf utility library.  The code is borrowed
> > from the kernel.
> 
> We have tools/perf/check-headers.sh to check for drifts between things
> we borrow from the kernel, so that when the kernel fixes or improves
> things we borrowed, we notice and check if it makes sense for us to
> update the copy, see tools/include/uapi/README.
> 
> In this case the copy isn't verbatim, as not all is needed, perhaps it
> could be just to facilitate? I haven't checked, just mentioning it while
> processing this series, I'll check that later, maybe.
> 
> - Arnaldo

I think that would be more trouble than it's worth in this case.  Every
time I make a change to a UAPI header, even something trivial like
updating a comment, I start getting emails about how a header changed
and perf's copy of it is being updated too.  It's actually kind of
annoying.  I don't think we need to add that for the BLAKE2s code too.

We can always resynchronize manually later if there's an important
change.

But ultimately this code just implements BLAKE2s, which is a fixed
algorithm.  If it does so correctly, which I'm quite confident it does,
future changes will just be refactoring, optimization, etc.

Of course, the use of BLAKE2s in 'perf' doesn't seem to be
performance-critical, so any optimizations won't be that important for
it.  It will include just the generic C code anyway -- no assembly code.

- Eric
