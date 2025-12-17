Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F67253950;
	Wed, 17 Dec 2025 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985104; cv=none; b=Gan7SS8kzNYlEW7J4+4HKBD1qbxwysMs8JHd1uZOgZszxZ5TzZa0580KgA+ainkHa1BjaGUDAmBFMPgbS/6/xQkRiH76klxwYp4TsSnkUtIcCpkeLm1cHvxlQf/+RiWu2vv9NXntPkY2nEKZYH0yEH7jfhFddh2CujyjPVXw12s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985104; c=relaxed/simple;
	bh=FfaEgysqg0qjs127S7KzTs/5HTKPh0j40Z7k0iwiMVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SazaDBj/LzO+ndOuRAT/WBT/I4Mm3AohdNXOIrzc3DGotszFbxHR7QNW0gFVx68Y8s5lIRMGToxoMRGjQcTO4C1/cE5qPEVC2xM8lOOqmWfL+KKgkzYCQxeQEmUdOCWDK8dgIs9njH5TQFOjaTM82rA1xT14IG9MxQT4E7A7Kf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQnG5eh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQnG5eh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0C5C113D0;
	Wed, 17 Dec 2025 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765985103;
	bh=FfaEgysqg0qjs127S7KzTs/5HTKPh0j40Z7k0iwiMVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hQnG5eh3FYH/YNdlFXpjbWHyOwrcTO3z4HdEUryWKSLNdyNvNWwu/xpWtEDhxA4sA
	 +48X8RoPyptAzZFv9DdG4EyKq7ygRgQOOCFiIwzY9q1Zn2xCj6+Vxj31N+A3eylh8t
	 SFLrLiEctIXcDIbmALy/gONxKFm2uW43xufCeZD2SLCzE6ZN466xOgcleOrF9rIr4S
	 aKD3K12470ULP9XHwf8dcDE11M3CHEVCqROKIck34dnr3/2obXW0l5Q8EH9H9En9i7
	 w1YmX/X44DPfAAxBjgKhNYHVC6t7dyJZdrutM3mDC3IoxtvUE5ygbnp8ASZU3Un7MR
	 OzP7rC6alL0SQ==
Date: Wed, 17 Dec 2025 07:25:01 -0800
From: Namhyung Kim <namhyung@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Subject: Re: [PATCH v2 0/3] perf genelf: BLAKE2s build ID generation
Message-ID: <aULLTawpDh26XHDB@google.com>
References: <20251209015729.23253-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251209015729.23253-1-ebiggers@kernel.org>

Hello,

On Mon, Dec 08, 2025 at 05:57:26PM -0800, Eric Biggers wrote:
> This series upgrades perf's build ID generation to a more modern hash
> algorithm and switches to an incremental hashing API.
> 
> It also fixes an issue where different (code, symtab, strsym) tuples
> didn't necessarily result in different hashes.
> 
> Note that the size of the build ID field stays the same.
> 
> This applies to the perf-tools-next branch of
> https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git
> 
> Changed in v2:
>     - Split into three patches
>     - Improved a couple comments
> 
> Eric Biggers (3):
>   perf util: Add BLAKE2s support
>   perf genelf: Switch from SHA-1 to BLAKE2s for build ID generation
>   perf util: Remove SHA-1 code

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks a lot!
Namhyung

> 
>  tools/perf/tests/util.c   |  85 +++++++++++++--------
>  tools/perf/util/Build     |   2 +-
>  tools/perf/util/blake2s.c | 151 ++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/blake2s.h |  73 ++++++++++++++++++
>  tools/perf/util/genelf.c  |  58 +++++++--------
>  tools/perf/util/sha1.c    |  97 ------------------------
>  tools/perf/util/sha1.h    |   6 --
>  7 files changed, 309 insertions(+), 163 deletions(-)
>  create mode 100644 tools/perf/util/blake2s.c
>  create mode 100644 tools/perf/util/blake2s.h
>  delete mode 100644 tools/perf/util/sha1.c
>  delete mode 100644 tools/perf/util/sha1.h
> 
> 
> base-commit: 2eeb09fe1c5173b659929f92fee4461796ca8c14
> -- 
> 2.52.0
> 
