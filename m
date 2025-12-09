Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2FF14F9D6;
	Tue,  9 Dec 2025 01:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245489; cv=none; b=LHFOo2lHjhbG1B1bi9/3ejwRzWYTyKhe8fEyzCEY95FBqgb9h+D8DTAitz8mr8icMQ3gU7zXh6rzOfTLY8JdWy6G5iWuSDu24OB1blDQaPWytWT6ZuTW9AGxphTrLRC9Ik4xYjwH+KoHEnQYK7n7mNimdD8rCfGzk48exk2HP8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245489; c=relaxed/simple;
	bh=1S/OF9hlR9D0UbGAnVdKzS5F54i0KHnyBIIzzqsXJ74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bLrr0qsn20t5CtPXNHVopbwaU69yiWvxgOKckXB7JwFKCeN4vdFHlykTPKgTH/TyNCDVSns52nFCZLnlrqpHH0qZHunWzkVQJE06CBWWVW53yd7TYfdp5XGnvxLLs9GQwmOicnOEtFiWL9fdt2Q4S/bbek3vfNMve47uLPIAszQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PamMe17n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PamMe17n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3040CC4CEF1;
	Tue,  9 Dec 2025 01:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765245488;
	bh=1S/OF9hlR9D0UbGAnVdKzS5F54i0KHnyBIIzzqsXJ74=;
	h=From:To:Cc:Subject:Date:From;
	b=PamMe17nHWBToKuDlHUah790iPJwaLVTLapWX21kF1Tvf+9bU2yhhR9k1B8akVXp5
	 q2R8qBCN0VKjAnE+ZFcSBxSo1o2k0twEqyr1SCTgYXglghwSNZYTH5W9zBLVrjxayC
	 1g2kLE1GZa2YpPePx5ku+MZaTd2tUutDod9WKPO4jE7uC1lzaFdKMn349/q8KPtlmf
	 gNURnmUgLpFMaXvb6ZUHRVEEm9DyzhsZzrlcMzKi/1fn6oIHZui5U40AMypjQP8CIn
	 rIqnJVNb7syEUWJAzFqZHw/uggocP7CdKgXQ+s6uDievlD7MOqn1KwO4Snfay1+F3V
	 RObNoATEF3sSQ==
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Fangrui Song <maskray@sourceware.org>,
	Pablo Galindo <pablogsal@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/3] perf genelf: BLAKE2s build ID generation
Date: Mon,  8 Dec 2025 17:57:26 -0800
Message-ID: <20251209015729.23253-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series upgrades perf's build ID generation to a more modern hash
algorithm and switches to an incremental hashing API.

It also fixes an issue where different (code, symtab, strsym) tuples
didn't necessarily result in different hashes.

Note that the size of the build ID field stays the same.

This applies to the perf-tools-next branch of
https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git

Changed in v2:
    - Split into three patches
    - Improved a couple comments

Eric Biggers (3):
  perf util: Add BLAKE2s support
  perf genelf: Switch from SHA-1 to BLAKE2s for build ID generation
  perf util: Remove SHA-1 code

 tools/perf/tests/util.c   |  85 +++++++++++++--------
 tools/perf/util/Build     |   2 +-
 tools/perf/util/blake2s.c | 151 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/blake2s.h |  73 ++++++++++++++++++
 tools/perf/util/genelf.c  |  58 +++++++--------
 tools/perf/util/sha1.c    |  97 ------------------------
 tools/perf/util/sha1.h    |   6 --
 7 files changed, 309 insertions(+), 163 deletions(-)
 create mode 100644 tools/perf/util/blake2s.c
 create mode 100644 tools/perf/util/blake2s.h
 delete mode 100644 tools/perf/util/sha1.c
 delete mode 100644 tools/perf/util/sha1.h


base-commit: 2eeb09fe1c5173b659929f92fee4461796ca8c14
-- 
2.52.0

