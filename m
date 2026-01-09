Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58E627465C;
	Fri,  9 Jan 2026 02:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767925511; cv=none; b=cJtCoJxhqJ8MTPaPq6V9a7IxO4wEx+jlp6cB/ZOLqHR/GiCrbLYsFda+TzNUXNS3r/KBn3cKNts74ROYfCrLIFmsU12mJUVGDni6aSSw5+zn6mjkewJz8q6bdZvnKDnk33yEZXqh7StPbROl8id/pprzK/tMihJVgLWE4Vzr+XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767925511; c=relaxed/simple;
	bh=A2krHkn8X4+Jv8UItV5AxUM4bYo9yx+73yu9Ai7PPw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsTZrBbhFR1nn8eHQGUUmikcXAGy7js2E6VW0omE5EsEsKswSCBGucVhN/o92V2knsLSckIp5UlVNIhbVXq6fjTKwaWw4HVpDwm2YDgR6sRMm826KPPSHJGsD+4j3Mhca0PAqb9/GPiWo0vaXLJiiHtNcFIFYLenJYb4b6ja8Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GR2cSOsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GR2cSOsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E96C116C6;
	Fri,  9 Jan 2026 02:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767925511;
	bh=A2krHkn8X4+Jv8UItV5AxUM4bYo9yx+73yu9Ai7PPw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GR2cSOsKGwmd7srtQ/lds2ntI5U2AKLp1yKaICvylFnBKI+JWNA/KbJl73C/cLTfQ
	 boQfcGhiU7YvDkyAHfoNY9AfawEzkb3m5nVTJaGhp7/D+uuYDzShxupRW7UNOuwOmp
	 GgWAS8/e3dFSt3iGv3ZHx2CrD17JypVU7/tT8/qfSpk8vX9jnQbxWor9+9uZ+FVzKc
	 6Txdu8L5sLpoCesdX470Kxzsp1jjIJkMU324z1ZfOAmFAWFFv7jbZAfCEzT1EUFJfW
	 YMNuITUKE6Bf//AIsD5RoCH6pcU5iG/SpXtXPQEP2L5ZG27fLF5m72dzmTxdnbCMmW
	 036dA+yUD5i8A==
Date: Thu, 8 Jan 2026 18:24:48 -0800
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
Subject: Re: [PATCH v2 0/3] perf genelf: BLAKE2s build ID generation
Message-ID: <20260109022448.GA2790@sol>
References: <20251209015729.23253-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209015729.23253-1-ebiggers@kernel.org>

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

Any plan to apply this series to perf-tools-next?

- Eric
