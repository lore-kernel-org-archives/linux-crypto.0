Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5A233C76E;
	Wed, 17 Sep 2025 13:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115588; cv=none; b=UWV9wN3PK2kr9aXEEwoewjg6AZnCK73Qlo6qaBvM8r/H8F5LBjNutvXbBgudlV6aYDeLSZD4Y3hb18AfjQzR/p24LRExZqrKUUl/afav3rgGWikGxfeP0DB01zWIeSHv+CbyRzT+QJVC/DlBOp9kmPTaipuXDE9tNog7U8UXOwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115588; c=relaxed/simple;
	bh=V7HgAwR8e8tHaVcJaPJfV58nE9V/qJQQN1kUxjKXpss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RsoIGqZqNLDIbr9DJOGt2t+BiE3F/PD1edOgu32LDaPj1w7MxxrKVTC5uVwRSvFgCALeEXzctVSKLvjszykjGdO6pmP9sogMChRHaCrrLpheap9XcSZWxdZzCH8BJJojBVcLSF0kb+tG/gW9/VKMT3Sj+542QgvujNrjCDrv1UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyzzqaq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyzzqaq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5EBC4CEF0;
	Wed, 17 Sep 2025 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758115587;
	bh=V7HgAwR8e8tHaVcJaPJfV58nE9V/qJQQN1kUxjKXpss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyzzqaq1wSWdrMvUjJY6Q8mC1TXbi8ZuTpl3Lz3wZq3GVXDFvew6jCkP8AXYWXvgB
	 v3f6qKVhT1BE1orrKlvZlrYFo3gehLDsv8q8s79Bg6852M9OSEVlSW87AROb1ApL0J
	 uil+MxoysSLaD1bs2lntCi/dzIhktmXgWQu0Q6V0loAgomgt07L2zjkmiQqP2q5AbR
	 rF9W6qdmUXXuBcQ/VKyeYFBnXwDStG9KONCUVf+F3lFragWgSGkWouCgFLIFAiH45C
	 ez/sh5E6l479QZ5yWfcqrNaCVn0BGq9ZWLdrK0bedHmT8UQ02l2pDwuN0bUl4AoYu6
	 LSiTwVKrAqqhQ==
From: SeongJae Park <sj@kernel.org>
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	ethangraham@google.com,
	glider@google.com,
	andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v1 04/10] tools: add kfuzztest-bridge utility
Date: Wed, 17 Sep 2025 06:26:25 -0700
Message-Id: <20250917132625.61081-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916090109.91132-5-ethan.w.s.graham@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Sep 2025 09:01:03 +0000 Ethan Graham <ethan.w.s.graham@gmail.com> wrote:

> From: Ethan Graham <ethangraham@google.com>
> 
> Introduce the kfuzztest-bridge tool, a userspace utility for sending
> structured inputs to KFuzzTest harnesses via debugfs.
> 
> The bridge takes a textual description of the expected input format, a
> file containing random bytes, and the name of the target fuzz test. It
> parses the description, encodes the random data into the binary format
> expected by the kernel, and writes the result to the corresponding
> debugfs entry.
> 
> This allows for both simple manual testing and integration with
> userspace fuzzing engines. For example, it can be used for smoke testing
> by providing data from /dev/urandom, or act as a bridge for blob-based
> fuzzers (e.g., AFL) to target KFuzzTest harnesses.

Thank you for doing this great work, Ethan!  I think this will be very helpful
for finding bugs of DAMON.

> 
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> 
> ---
> v3:
> - Add additional context in header comment of kfuzztest-bridge/parser.c.
> - Add some missing NULL checks.
> - Refactor skip_whitespace() function in input_lexer.c.
> - Use ctx->minalign to compute correct region alignment, which is read
>   from /sys/kernel/debug/kfuzztest/_config/minalign.
> ---
> ---
>  tools/Makefile                        |  15 +-
>  tools/kfuzztest-bridge/.gitignore     |   2 +
>  tools/kfuzztest-bridge/Build          |   6 +
>  tools/kfuzztest-bridge/Makefile       |  48 ++++
>  tools/kfuzztest-bridge/bridge.c       | 103 +++++++
>  tools/kfuzztest-bridge/byte_buffer.c  |  87 ++++++
>  tools/kfuzztest-bridge/byte_buffer.h  |  31 ++
>  tools/kfuzztest-bridge/encoder.c      | 391 +++++++++++++++++++++++++
>  tools/kfuzztest-bridge/encoder.h      |  16 ++
>  tools/kfuzztest-bridge/input_lexer.c  | 242 ++++++++++++++++
>  tools/kfuzztest-bridge/input_lexer.h  |  57 ++++
>  tools/kfuzztest-bridge/input_parser.c | 395 ++++++++++++++++++++++++++
>  tools/kfuzztest-bridge/input_parser.h |  81 ++++++
>  tools/kfuzztest-bridge/rand_stream.c  |  77 +++++
>  tools/kfuzztest-bridge/rand_stream.h  |  57 ++++
>  15 files changed, 1602 insertions(+), 6 deletions(-)
>  create mode 100644 tools/kfuzztest-bridge/.gitignore
>  create mode 100644 tools/kfuzztest-bridge/Build
>  create mode 100644 tools/kfuzztest-bridge/Makefile
>  create mode 100644 tools/kfuzztest-bridge/bridge.c
>  create mode 100644 tools/kfuzztest-bridge/byte_buffer.c
>  create mode 100644 tools/kfuzztest-bridge/byte_buffer.h
>  create mode 100644 tools/kfuzztest-bridge/encoder.c
>  create mode 100644 tools/kfuzztest-bridge/encoder.h
>  create mode 100644 tools/kfuzztest-bridge/input_lexer.c
>  create mode 100644 tools/kfuzztest-bridge/input_lexer.h
>  create mode 100644 tools/kfuzztest-bridge/input_parser.c
>  create mode 100644 tools/kfuzztest-bridge/input_parser.h
>  create mode 100644 tools/kfuzztest-bridge/rand_stream.c
>  create mode 100644 tools/kfuzztest-bridge/rand_stream.h

I'm wondering if it makes sense to put the files under tools/testing/ like
kselftest and kunit.


Thanks,
SJ

[...]
