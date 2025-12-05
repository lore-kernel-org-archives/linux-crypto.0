Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FBC275861;
	Fri,  5 Dec 2025 04:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909679; cv=none; b=lBmi5jnaL8o5VJhqFKChpYYqSMKiA2WwjfwCo0sY5nRtu1zVmiPw2OnpaxXB/JFOApFYlDDxSC62J7kxxOc2DRfCKib3G8BGSxJWB4tPuOjzHdfhLwOolKm/lsP15qxyaeLo+IJAujP1PBK7p2fKkskKbgRDvb7AQPD+eppMrPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909679; c=relaxed/simple;
	bh=GdEhun3cR/92HV9I3xif4vkj50h42eNKF9Jmt5SKwaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIw0tBC+NQQGKL8ejfHQhpH4wugMVnSRwJSUs26bvVlzRCpd/X7+p0YBfRR3EnTU9Gk7YMEvWh2Xtc7twtyC6zPDjwKg7OohfFtCFB7PilGGb8AGBv5nojWntxEXaXtFB95AT8hKv3hzHM0G208ktxmtXiQBeSdPsqo+WuRVQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jaZN2bLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaZN2bLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7529CC4CEF1;
	Fri,  5 Dec 2025 04:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764909678;
	bh=GdEhun3cR/92HV9I3xif4vkj50h42eNKF9Jmt5SKwaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jaZN2bLLhUud8G1DgWgzUjUfmjiP1OM0+DAGo1kjyTO9Xmj2eHjbBPc/0FsISYlFV
	 NdxdC9+FXaH9hU1b3Pl9aMDjSLxRbgM0b45/AHxepqSU2bEQp59JFyYKYUDb/qsUXL
	 bwpN9DRnuBwxZ0W0w5rMpWpr8y+prn4m/l+jSoSEOqz4alwI02h216p5uagmET5zxp
	 gwGe+R9jpZ+boVmJYe/yOAkFzUi6fDHwSVC9zyIs694hHH0SxlPc+EFfsykJc4RdVL
	 1Ml/DW+Zni7a49xx5Pb2GlxE7GZDELVxmmPChUDvKvc/lYpgBBEAoyWFcyv58UxWkE
	 5UNIsU8JTtoaw==
Date: Thu, 4 Dec 2025 20:39:24 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Fangrui Song <maskray@sourceware.org>,
	Pablo Galindo <pablogsal@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] perf genelf: Switch from SHA-1 to BLAKE2s for build ID
 generation
Message-ID: <20251205043924.GA6421@sol>
References: <20251205043121.62356-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205043121.62356-1-ebiggers@kernel.org>

On Thu, Dec 04, 2025 at 08:31:21PM -0800, Eric Biggers wrote:
> ---
>  tools/perf/tests/util.c   |  78 ++++++++++++--------
>  tools/perf/util/Build     |   2 +-
>  tools/perf/util/blake2s.c | 151 ++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/blake2s.h |  73 ++++++++++++++++++
>  tools/perf/util/genelf.c  |  58 +++++++--------
>  tools/perf/util/sha1.c    |  97 ------------------------
>  tools/perf/util/sha1.h    |   6 --
>  7 files changed, 302 insertions(+), 163 deletions(-)
>  create mode 100644 tools/perf/util/blake2s.c
>  create mode 100644 tools/perf/util/blake2s.h
>  delete mode 100644 tools/perf/util/sha1.c
>  delete mode 100644 tools/perf/util/sha1.h

Forgot to mention: this applies to next-20251204, or alternatively to
the latest perf-tools-next (d509d14fff783969904954eaf5d94f092c6fce19)

- Eric
