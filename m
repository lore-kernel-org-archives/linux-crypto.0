Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCA4395AD8;
	Mon, 31 Aug 2026 22:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216192; cv=none; b=XQRB8bmE38u/BNGPsyWmfb7eH5pbZR2jE2Yy+1pC5dMXKKaW2Y/gGzP09kmt3UVRg2TfaQftMAFigVeDuFUA5P94kqLYL17P6eDTaWS4lhDvS5I7aw+CtWEmUACNwkcs0U1Zb0GcvQOTG53QVuVjgKt8HO13FTfHaPm/zBU2PaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216192; c=relaxed/simple;
	bh=5L8VT3J+9iT9uLbzpgrd7jvf0rkLMBXOWhuzeT9aopE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfB31fAj3aEuv6VWPoHDXfaNGbqH8qgXkDTeFmMyu0+dH/EK/MnFAzcTwj8OuNi8+Cc7JrxAYEhjPwXrTBs+o48Z+NiFYWVeoVWa1HoaWss7dqzeQRXsD/t64bjGcDC8haqifdjGzDwhX8uMbvjZ7pO4+MUP4CqLFXWvk9Ap0aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToVcSuEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToVcSuEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284521F000E9;
	Mon, 31 Aug 2026 22:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788216190;
	bh=DQ9xMynieA/dYYeIOeQvK4F87GunPdW1W/6hOBtPP5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ToVcSuEgeqLV8BlxayWCHyw35aq/17Opxf0aA2pmuWA5SmTazMYIjoFCJLSFUJCG1
	 aWUq8sPpoGYcqOxccxVurClwNkYe+orvLEu7OtY5KntF8JOwqqnQHc+s686aFK6mh6
	 ljcdU+/eHoLYUzW6uJSb+Nx8z5GUx/BbLnqDRh7/lmxOn5Zdns5qb5KCa9gzMHbpoR
	 HJnkSEW794+MTZJoue9D4RRk0bNRAaNW5QMv8Ox0mmXl13NIGvtDC1wnyVsShE1j2U
	 IPe8LGC5u/inJr7PvnKv+VStcqPTjIn5yHHJ3rVgAewTEfEmHUknbbZMbL8fVcB0hW
	 8J5r5MbsPjTsQ==
Date: Mon, 31 Aug 2026 15:43:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, vadim.fedorenko@linux.dev, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, martin.lau@linux.dev, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
	ihor.solodrai@linux.dev, john.fastabend@gmail.com,
	kmehltretter@gmail.com, martin.lau@kernel.org, mason@kernel.org
Subject: Re: [PATCH bpf-next] bpf: crypto: Use AES-CBC and AES-ECB libraries
Message-ID: <20260831224308.GJ86114@quark>
References: <20260831192139.94895-1-ebiggers@kernel.org>
 <f829962635d9d46dc01bea9d7777a8099af30f79068d978e8e8bb5cd85f014f1@mail.kernel.org>
 <20260831215937.GG86114@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831215937.GG86114@quark>

On Mon, Aug 31, 2026 at 02:59:39PM -0700, Eric Biggers wrote:
> Almost every kernel has CRYPTO and CRYPTO_SKCIPHER2 enabled anyway, and
> CRYPTO_SKCIPHER2 also enables ECB support.  So the change isn't actually
> as drastic as the bot implies, but I'd be glad to give BPF_CRYPTO a
> prompt if the BPF folks are okay with that.

I don't see other examples of kfuncs with visible kconfig options.  The
convention is to automatically enable them when the parent subsystem is
enabled.

It feels like bpf crypto is a de facto standalone feature, so I'm not
sure how well that applies here.  Regardless, for now I'll use "depends
on CRYPTO_LIB_AES_CBC" and "depends on CRYPTO_LIB_AES_ECB".

- Eric
