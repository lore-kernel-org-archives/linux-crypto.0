Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5743D1D5CE8
	for <linux-crypto@vger.kernel.org>; Sun, 20 Jul 2025 17:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753032227; cv=none; b=AGgB9xfNmCfKh9lOd3lGZl1essG/etTYkT5jJQu9MzD1c6fLh59JXq8DJ9JtiEOCKnpA+SjPSN4omhZWcCQeYkcIVoN0S6TY4rseEkkrYjMD5jQs0b+ctBxn8PQ6eR2E+br4mW9O5IyOqILM8w6mKjgbQBDEL1XZRzfkzoSEnGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753032227; c=relaxed/simple;
	bh=HT4WmKf+QHuCDZDfV4PGhZwxfkZllnL0EUBT8sTCuBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sd2YGwlf1klqT9IyEBglcVG2ezhtnuxyzwaSskONQl4ixHILdtUkaMoJyvGY4sQLsqwv58oKqpsUqnIWyG1gYm/SZ/SYg+iZyoJP0aacpSI3smLnfCTcYkZCZMKe1ecWJNQNJiGrko2j0sn9Qb8xwlNLgOnYtFZJBNOKKHXc28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tdn9Yia5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tdn9Yia5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E08C4CEE7;
	Sun, 20 Jul 2025 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753032225;
	bh=HT4WmKf+QHuCDZDfV4PGhZwxfkZllnL0EUBT8sTCuBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tdn9Yia5To+0orCkYu027oSmk9jkyKFNnMupkl/fwdhNOFEU/VjAM8dNfFWEVBG2E
	 GegANPwfTMIaqjfA+PRihibGlyUhMm8VISY79gu/4vmizkd5hC71Z1QzNukSNW1ddy
	 LZlo/U89hrtfhRaK4AIhQFXGEkb4rP6/3CkuWLwewnK0+Bwa2iN+L5JwniWEMk3Knh
	 b4QJMYSd/5iXZ1Wgjr/i2TQjEkJp62gqF0wVbk8Cnj3/RwfO9SJpBsusT02BCsHj81
	 8UGa/f0Al1FhcUe9TbVHQWv1dDrQ2Fumb/lZOqnc28KrpCfe8YvFE3YgNstwmgcAg/
	 G5NTS285jIC0A==
Date: Sun, 20 Jul 2025 10:22:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: alex@ghiti.fr, appro@cryptogams.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	paul.walmsley@sifive.com, zhang.lyra@gmail.com
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <20250720172258.GA1153@sol>
References: <CACGDn=Rn079JhB7dwqbC-3GNiydJs=dGEXtcw+cC8z2Yjp2Qbg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGDn=Rn079JhB7dwqbC-3GNiydJs=dGEXtcw+cC8z2Yjp2Qbg@mail.gmail.com>

On Sun, Jul 20, 2025 at 05:10:13PM +0800, Zhihang Shao wrote:
> Hi Eric,
> 
> I recently ran a test using the Kunit module you wrote for testing
> poly1305, which I executed on QEMU RISC-V 64, . The results show a
> significant performance improvement of the optimized implementation
> compared to the generic one. The test data are as follows:
> 
> --- base.log    2025-07-19 17:41:06.443392989 +0800
> +++ optimized.log       2025-07-19 17:40:45.650048601 +0800
> @@ -1,31 +1,31 @@
> -[    0.668631]     # Subtest: poly1305
> -[    0.668774]     # module: poly1305_kunit
> -[    0.668857]     1..12
> -[    0.670267]     ok 1 test_hash_test_vectors
> -[    0.679479]     ok 2 test_hash_all_lens_up_to_4096
> -[    0.696048]     ok 3 test_hash_incremental_updates
> -[    0.697645]     ok 4 test_hash_buffer_overruns
> -[    0.701060]     ok 5 test_hash_overlaps
> -[    0.702858]     ok 6 test_hash_alignment_consistency
> -[    0.703108]     ok 7 test_hash_ctx_zeroization
> -[    0.846150]     ok 8 test_hash_interrupt_context_1
> -[    1.235247]     ok 9 test_hash_interrupt_context_2
> -[    1.250813]     ok 10 test_poly1305_allones_keys_and_message
> -[    1.251138]     ok 11 test_poly1305_reduction_edge_cases
> -[    1.287196]     # benchmark_hash: len=1: 2 MB/s
> -[    1.305363]     # benchmark_hash: len=16: 61 MB/s
> -[    1.321102]     # benchmark_hash: len=64: 212 MB/s
> -[    1.340105]     # benchmark_hash: len=127: 263 MB/s
> -[    1.353880]     # benchmark_hash: len=128: 364 MB/s
> -[    1.370118]     # benchmark_hash: len=200: 377 MB/s
> -[    1.381879]     # benchmark_hash: len=256: 570 MB/s
> -[    1.394125]     # benchmark_hash: len=511: 657 MB/s
> -[    1.404265]     # benchmark_hash: len=512: 794 MB/s
> -[    1.413356]     # benchmark_hash: len=1024: 985 MB/s
> -[    1.421925]     # benchmark_hash: len=3173: 1131 MB/s
> -[    1.429956]     # benchmark_hash: len=4096: 1218 MB/s
> -[    1.438184]     # benchmark_hash: len=16384: 1216 MB/s
> -[    1.438462]     ok 12 benchmark_hash
> -[    1.438686] # poly1305: pass:12 fail:0 skip:0 total:12
> -[    1.438763] # Totals: pass:12 fail:0 skip:0 total:12
> -[    1.438904] ok 1 poly1305
> +[    0.666280]     # Subtest: poly1305
> +[    0.666413]     # module: poly1305_kunit
> +[    0.666490]     1..12
> +[    0.667702]     ok 1 test_hash_test_vectors
> +[    0.672896]     ok 2 test_hash_all_lens_up_to_4096
> +[    0.686244]     ok 3 test_hash_incremental_updates
> +[    0.687263]     ok 4 test_hash_buffer_overruns
> +[    0.689957]     ok 5 test_hash_overlaps
> +[    0.691393]     ok 6 test_hash_alignment_consistency
> +[    0.691622]     ok 7 test_hash_ctx_zeroization
> +[    0.769741]     ok 8 test_hash_interrupt_context_1
> +[    0.930832]     ok 9 test_hash_interrupt_context_2
> +[    0.940068]     ok 10 test_poly1305_allones_keys_and_message
> +[    0.940478]     ok 11 test_poly1305_reduction_edge_cases
> +[    0.964546]     # benchmark_hash: len=1: 3 MB/s
> +[    0.978836]     # benchmark_hash: len=16: 78 MB/s
> +[    0.990414]     # benchmark_hash: len=64: 289 MB/s
> +[    1.003012]     # benchmark_hash: len=127: 397 MB/s
> +[    1.012755]     # benchmark_hash: len=128: 517 MB/s
> +[    1.022928]     # benchmark_hash: len=200: 603 MB/s
> +[    1.030981]     # benchmark_hash: len=256: 835 MB/s
> +[    1.038706]     # benchmark_hash: len=511: 1046 MB/s
> +[    1.045233]     # benchmark_hash: len=512: 1240 MB/s
> +[    1.050733]     # benchmark_hash: len=1024: 1638 MB/s
> +[    1.055620]     # benchmark_hash: len=3173: 1998 MB/s
> +[    1.060247]     # benchmark_hash: len=4096: 2132 MB/s
> +[    1.064695]     # benchmark_hash: len=16384: 2267 MB/s
> +[    1.065179]     ok 12 benchmark_hash
> +[    1.065425] # poly1305: pass:12 fail:0 skip:0 total:12
> +[    1.065498] # Totals: pass:12 fail:0 skip:0 total:12
> +[    1.065612] ok 1 poly1305
> 
> Next, I plan to validate this performance gain on actual RISC-V
> hardware. I will also submit a v5 patch to the mailing list.
> Look forward to your feedback and suggestions.
> 

Sounds good, thank you!

- Eric
