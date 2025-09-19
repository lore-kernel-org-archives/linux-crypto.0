Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C85226E711;
	Fri, 19 Sep 2025 19:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758309583; cv=none; b=jkcakOP1XQPKZEnKc8yWoLUGH8RaaRqiVtk14LIEx5d3OgPXY9SXMcUFSHTP0365LZbf/hTpCwOQuAP/EzI6ubaLir5dNc8aLkJfPN6DPWf94JAsSOU2/uUkjUzrlWUd7dS5xikXCYAm3vinF7W4c1EwKDVT9pQfFvQ5I9vdFmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758309583; c=relaxed/simple;
	bh=RIu4F7qAgYmGH6tNvm+4CzefUV0zH2vjCBJ8h0ToUAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cxaxpf4BTVTvDBtSHqZKmOaQQHxJDlVto4F3Bt42GeZkI+jNe5oFf4+b6/rujJjhXnlD5Iwsl/oh+996qtzVnheaW2Wr2TsZWTNiaZdYbXEz1rle/7oGPYaqiwJBVX0XopzYR/KAF3/U3PuqYjQHzFRrOdR/ljMksblg8ZsEB3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2GtAhd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2GtAhd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083E6C4CEF0;
	Fri, 19 Sep 2025 19:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758309583;
	bh=RIu4F7qAgYmGH6tNvm+4CzefUV0zH2vjCBJ8h0ToUAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2GtAhd8bUf2jG0nPz6QS+Fnc1JDbjL0PYpNDaajz77TqZvhRvhLX375Esu4LPoIX
	 Zic8Xef1180RGF6uIFCGGIBllcoVDHNazkwmTXJj4H+EJY6pce8JBGtyF16UFy4p1p
	 dLJVg5VGwtDQyOaMXxRLBLjj4cPHxQfG6v42OKABqtovOAYnhm1nSGR2G6YmQm/w60
	 on+yLOj2bqnr/s4CLiAKCfaPDP9nLLXlJfhAD51wCvIGpC8GhNNQlYm4uT7Q0F/7An
	 VT+NF2S7AL9sj63auOqbZ1DET9Bq3OB+Hf2NyaclfqbTydCsXoTef/O7uHV5+bwSRO
	 F6oKvMERskMBw==
Date: Fri, 19 Sep 2025 12:19:42 -0700
From: Kees Cook <kees@kernel.org>
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com,
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev,
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com,
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au,
	ignat@cloudflare.com, jack@suse.cz, jannh@google.com,
	johannes@sipsolutions.net, kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v2 09/10] fs/binfmt_script: add KFuzzTest target for
 load_script
Message-ID: <202509191208.D2BCFD366F@keescook>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>

On Fri, Sep 19, 2025 at 02:57:49PM +0000, Ethan Graham wrote:
> From: Ethan Graham <ethangraham@google.com>
> 
> Add a KFuzzTest target for the load_script function to serve as a
> real-world example of the framework's usage.
> 
> The load_script function is responsible for parsing the shebang line
> (`#!`) of script files. This makes it an excellent candidate for
> KFuzzTest, as it involves parsing user-controlled data within the
> binary loading path, which is not directly exposed as a system call.
> 
> The provided fuzz target in fs/tests/binfmt_script_kfuzz.c illustrates
> how to fuzz a function that requires more involved setup - here, we only
> let the fuzzer generate input for the `buf` field of struct linux_bprm,
> and manually set the other fields with sensible values inside of the
> FUZZ_TEST body.
> 
> To demonstrate the effectiveness of the fuzz target, a buffer overflow
> bug was injected in the load_script function like so:
> 
> - buf_end = bprm->buf + sizeof(bprm->buf) - 1;
> + buf_end = bprm->buf + sizeof(bprm->buf) + 1;
> 
> Which was caught in around 40 seconds by syzkaller simultaneously
> fuzzing four other targets, a realistic use case where targets are
> continuously fuzzed. It also requires that the fuzzer be smart enough to
> generate an input starting with `#!`.
> 
> While this bug is shallow, the fact that the bug is caught quickly and
> with minimal additional code can potentially be a source of confidence
> when modifying existing implementations or writing new functions.
> 
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> 
> ---
> PR v2:
> - Introduce cleanup logic in the load_script fuzz target.
> ---
> ---
>  fs/binfmt_script.c             |  8 +++++
>  fs/tests/binfmt_script_kfuzz.c | 58 ++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
>  create mode 100644 fs/tests/binfmt_script_kfuzz.c
> 
> diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
> index 637daf6e4d45..c09f224d6d7e 100644
> --- a/fs/binfmt_script.c
> +++ b/fs/binfmt_script.c
> @@ -157,3 +157,11 @@ core_initcall(init_script_binfmt);
>  module_exit(exit_script_binfmt);
>  MODULE_DESCRIPTION("Kernel support for scripts starting with #!");
>  MODULE_LICENSE("GPL");
> +
> +/*
> + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
> + * that KFuzzTest targets are built.
> + */
> +#ifdef CONFIG_KFUZZTEST
> +#include "tests/binfmt_script_kfuzz.c"
> +#endif /* CONFIG_KFUZZTEST */
> diff --git a/fs/tests/binfmt_script_kfuzz.c b/fs/tests/binfmt_script_kfuzz.c
> new file mode 100644
> index 000000000000..26397a465270
> --- /dev/null
> +++ b/fs/tests/binfmt_script_kfuzz.c
> @@ -0,0 +1,58 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * binfmt_script loader KFuzzTest target
> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <linux/binfmts.h>
> +#include <linux/kfuzztest.h>
> +#include <linux/slab.h>
> +#include <linux/sched/mm.h>
> +
> +struct load_script_arg {
> +	char buf[BINPRM_BUF_SIZE];
> +};
> +
> +FUZZ_TEST(test_load_script, struct load_script_arg)
> +{
> +	struct linux_binprm bprm = {};
> +	char *arg_page;
> +
> +	arg_page = (char *)get_zeroed_page(GFP_KERNEL);
> +	if (!arg_page)
> +		return;
> +
> +	memcpy(bprm.buf, arg->buf, sizeof(bprm.buf));
> +	/*
> +	 * `load_script` calls remove_arg_zero, which expects argc != 0. A
> +	 * static value of 1 is sufficient for fuzzing.
> +	 */
> +	bprm.argc = 1;
> +	bprm.p = (unsigned long)arg_page + PAGE_SIZE;
> +	bprm.filename = kstrdup("fuzz_script", GFP_KERNEL);
> +	if (!bprm.filename)
> +		goto cleanup;
> +	bprm.interp = kstrdup(bprm.filename, GFP_KERNEL);
> +	if (!bprm.interp)
> +		goto cleanup;
> +
> +	bprm.mm = mm_alloc();
> +	if (!bprm.mm)
> +		goto cleanup;
> +
> +	/*
> +	 * Call the target function. We expect it to fail and return an error
> +	 * (e.g., at open_exec), which is fine. The goal is to survive the
> +	 * initial parsing logic without crashing.
> +	 */
> +	load_script(&bprm);
> +
> +cleanup:
> +	if (bprm.mm)
> +		mmput(bprm.mm);
> +	if (bprm.interp)
> +		kfree(bprm.interp);
> +	if (bprm.filename)
> +		kfree(bprm.filename);
> +	free_page((unsigned long)arg_page);
> +}

Yay fuzzing hooks! I'm excited about this series overall, but I'm not
a fan of this "manual" init/clean up of bprm.

If you're going to set up a bprm that passes through load_script(), it
needs to be both prepared correctly (alloc_bprm) and cleaned up correctly
(free_bprm). Otherwise, you may be fuzzing impossible states created by
the fuzztest setup. And having a second init/cleanup path in here makes
future refactoring work more of a burden/fragile.

But this is also kind of not a great example of fuzztest utility because
load_script _is_ actually directly accessible from syscalls: it is trivial
to externally fuzz load_script by just writing the buffer to a file and
execve'ing it. :)

-Kees

-- 
Kees Cook
