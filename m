Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59793299A94;
	Tue,  4 Nov 2025 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762280959; cv=none; b=TbN+x+5WKdpn1X/+TvGRlZYn1Mn3w2nMkdahUkAqNzWUQaX/0wZewPtoK8JtVlHHK9GgHLEVc2SZwK4cKHgaiI/hEJUW+NPVa/HeVLZGHourAnS1F2G/iqN3buoxYjDHpFwMEsWmHD+XXxVQGqCUBWAGinw+WsrurxTvowF8+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762280959; c=relaxed/simple;
	bh=QOLIJdJXicTZA+aezH0oyKsN6n90p2SzQohPafNgStI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ek4MTvRAWLJnT3GFwd0QxDwuaKEUua+jgMMm1/WMOwm5BCyxNrVF3vMeSUoXRjnqOyZmCR8knUFcEmeFOjYDLWQGXJrxdz5OjUiFWIxFbnXfybYFQjyxtBY20PcenVovNF7RuTESolQoGHaPaV17lqctqcl6Kne4MECpf+8Owzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5bFng8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5bFng8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A13DC4CEF7;
	Tue,  4 Nov 2025 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762280958;
	bh=QOLIJdJXicTZA+aezH0oyKsN6n90p2SzQohPafNgStI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b5bFng8Yxj1VH7quw6uNytqi/j7acNnD+AEHsw7XG3zCksx2e3osO/X/VBkDTXgOu
	 SMNwgYGok9yVCmFvAJRI87wPx3WHQ8Sbwdt+mCRCYcj/h4Ym0qxxkGkY1NXneYBova
	 F5cuH+sCeJxkiLhY0DoLOrcslJSZDe7vC/SeRmtyB3ZPyjJYqRch2XExq7wJhD4Wt3
	 K6QB89nopkLNxH9goli+RMVXvanjgG51ll4XQBSBJfSRTJZjt96cGBhhV1zEP7Q2cZ
	 Hf3yw3u7avczSKLEFi9GZGNmkwrgs83dTe+4auuj91udrleB2uyvFTjSLL9Y0qR/DD
	 VFsu2uJXQnNdA==
Date: Tue, 4 Nov 2025 10:27:38 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Message-ID: <20251104182738.GA2419@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com>
 <20251029163216.GA1603@sol>
 <fa8bc10f36b1aeb9ffe1abf6350adbc1@linux.ibm.com>
 <20251030171453.GA1624@sol>
 <c39f6b6c110def0095e5da5becc12085@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c39f6b6c110def0095e5da5becc12085@linux.ibm.com>

On Tue, Nov 04, 2025 at 12:07:40PM +0100, Harald Freudenberger wrote:
> > Thanks!  Is this with the whole series applied?  Those numbers are
> > pretty fast, so probably at least the Keccak acceleration part is
> > worthwhile.  But just to reiterate what I asked for:
> > 
> >     Also, it would be helpful to provide the benchmark output from just
> >     before "lib/crypto: s390/sha3: Add optimized Keccak function", just
> >     after it, and after "lib/crypto: s390/sha3: Add optimized one-shot
> >     SHA-3 digest functions".
> > 
> > So I'd like to see how much each change helped, which isn't clear if you
> > show only the result at the end.
> > 
> > If there's still no evidence that "lib/crypto: s390/sha3: Add optimized
> > one-shot SHA-3 digest functions" actually helps significantly vs. simply
> > doing the Keccak acceleration, then we should drop it for simplicity.
[...]
> commit b2e169dd8ca5 lib/crypto: s390/sha3: Add optimized one-shot SHA-3
> digest functions:
> 
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # module: sha3_kunit
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     1..21
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 1 test_hash_test_vectors
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 2
> test_hash_all_lens_up_to_4096
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 3
> test_hash_incremental_updates
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 4
> test_hash_buffer_overruns
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 5 test_hash_overlaps
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 6
> test_hash_alignment_consistency
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 7
> test_hash_ctx_zeroization
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 8
> test_hash_interrupt_context_1
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 9
> test_hash_interrupt_context_2
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 10 test_sha3_224_basic
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 11 test_sha3_256_basic
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 12 test_sha3_384_basic
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 13 test_sha3_512_basic
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 14 test_shake128_basic
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 15 test_shake256_basic
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 16 test_shake128_nist
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 17 test_shake256_nist
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 18
> test_shake_all_lens_up_to_4096
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 19
> test_shake_multiple_squeezes
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 20
> test_shake_with_guarded_bufs
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=1: 12
> MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=16: 80
> MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=64: 785
> MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=127:
> 812 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=128:
> 1619 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=200:
> 2319 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=256:
> 2176 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=511:
> 4881 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=512:
> 4968 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=1024:
> 7565 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=3173:
> 11909 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=4096:
> 10378 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: len=16384:
> 12273 MB/s
> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 21 benchmark_hash
> Nov 04 10:50:50 b3545008.lnxne.boe kernel: # sha3: pass:21 fail:0 skip:0
> total:21
> 
> commit 02266b8a383e lib/crypto: s390/sha3: Add optimized Keccak functions:
> 
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     # module: sha3_kunit
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     1..21
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 1 test_hash_test_vectors
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 2
> test_hash_all_lens_up_to_4096
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 3
> test_hash_incremental_updates
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 4
> test_hash_buffer_overruns
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 5 test_hash_overlaps
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 6
> test_hash_alignment_consistency
> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 7
> test_hash_ctx_zeroization
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 8
> test_hash_interrupt_context_1
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 9
> test_hash_interrupt_context_2
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 10 test_sha3_224_basic
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 11 test_sha3_256_basic
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 12 test_sha3_384_basic
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 13 test_sha3_512_basic
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 14 test_shake128_basic
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 15 test_shake256_basic
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 16 test_shake128_nist
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 17 test_shake256_nist
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 18
> test_shake_all_lens_up_to_4096
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 19
> test_shake_multiple_squeezes
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 20
> test_shake_with_guarded_bufs
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=1: 12
> MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=16: 211
> MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=64: 835
> MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=127:
> 1557 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=128:
> 1617 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=200:
> 1457 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=256:
> 1830 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=511:
> 3035 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=512:
> 3245 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=1024:
> 5319 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=3173:
> 9969 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=4096:
> 11123 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: len=16384:
> 12767 MB/s
> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 21 benchmark_hash
> Nov 04 10:55:38 b3545008.lnxne.boe kernel: # sha3: pass:21 fail:0 skip:0
> total:21

Thanks.  So the results before and after "lib/crypto: s390/sha3: Add
optimized one-shot SHA-3 digest functions" are:

    Length (bytes)      Before            After
    ==============    ==========        ==========
         1               12 MB/s           12 MB/s
        16              211 MB/s           80 MB/s
        64              835 MB/s          785 MB/s
       127             1557 MB/s          812 MB/s
       128             1617 MB/s         1619 MB/s
       200             1457 MB/s         2319 MB/s
       256             1830 MB/s         2176 MB/s
       511             3035 MB/s         4881 MB/s
       512             3245 MB/s         4968 MB/s
      1024             5319 MB/s         7565 MB/s
      3173             9969 MB/s        11909 MB/s
      4096            11123 MB/s        10378 MB/s
     16384            12767 MB/s        12273 MB/s

Unfortunately that seems inconclusive.  len=200, 256, 511, 512, 1024,
3173 improved.  But len=16, 64, 127, 4096, 16384 regressed.

I expected the most improvement on short lengths.  The fact that some of
the short lengths actually regressed is concerning.

It's also clear the the Keccak acceleration itself matters far more than
this additional one-shot optimization, as expected.  The generic code
maxed out at only 259 MB/s for you.

I suggest we hold off on "lib/crypto: s390/sha3: Add optimized one-shot
SHA-3 digest functions" for now, to avoid the extra maintainence cost
and opportunity for bugs.

If you can provide more accurate numbers that show it's worthwhile, we
can reconsider.  Maybe set the CPU to a fixed frequency, and run
sha3_kunit multiple times (triggered via KUnit's debugfs interface)?

- Eric
