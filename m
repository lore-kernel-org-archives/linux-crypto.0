Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF75072610;
	Tue, 13 Jan 2026 20:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768334651; cv=none; b=f4pfMBXLAnaIV/9nrQwn1QN6HZrI5w2uCaQ9XYOX8+Sx5zGrVCfQV/7lAhfFLqfWq8KeKmDobdRw8rBCMJexigo4BsA6OrRaKhed2Visi4SAeP3dimi2kRVWEsP2vhDmLGxrQnnrIzFTubU0PC9AJNTXLrmkvFiJpRGllRLRIng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768334651; c=relaxed/simple;
	bh=GDTsYConNW1LnbNiQYviEv4v71T63nAaJsHVY4ClrKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CBPzp+/o2u3ntJLMt/oI67ys9sNN3zra1es8+v2TSrIJGUGKHwNqYgyx4oUmL1UIcXLhWzjT+fhHTX//SeTyBsr28KwL+X7ftTaI/M0jAWH2P3iQBWnL1uaOAM0ZierjwlrKMocU3+1BAx6dXjv4tJ1rgOTQD1s12p/ZOVmLIfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgeXt2+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgeXt2+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173AEC116C6;
	Tue, 13 Jan 2026 20:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768334651;
	bh=GDTsYConNW1LnbNiQYviEv4v71T63nAaJsHVY4ClrKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LgeXt2+XnKwriWhvWhw57hwcBmkKNmoZIoUwqutAn82elJ6RBcUW7cgVW1OSSTRcA
	 I2oGPH/bU2SedW0TrPWoqoLD5BZ/rrrV0OE4xMiHL2xxrmBQibpflL846L1LPvnBPD
	 loeC2PdEpccUQ3wPvkV/Oyxuf8NfQhTfHO9NQT/UfatKOBGKkg6UrRKzP0u/15k7E+
	 pMpExNzmue8aQd3Lhj382O/CoXCAxgShq7kWOJ1MIBvwn2ihyQLK26/r3vX18yKxd0
	 3b0bCmbR8qzSEbVrI1GcFNKEh164bRcNIxMTWhxrMExPYoexShgwCg9IfpqwddXk9U
	 y/FggViE8SNrA==
Date: Tue, 13 Jan 2026 17:04:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
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
Subject: Re: [PATCH v2 0/3] perf genelf: BLAKE2s build ID generation
Message-ID: <aWalONS2eJX6F-xs@x1>
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

Thanks, applied to perf-tools-next,

- Arnaldo
