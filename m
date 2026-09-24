Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B7A414A29;
	Thu, 24 Sep 2026 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790277677; cv=none; b=FsLVzbsMSI8AOQugksPwZBTcK0QleqOkORSX5GVNJketEiAWJMuoxe3PUYMd/zjQ5Z82v8COmeP5C29GZvor41HS14tMbh5+B6UWSJ6ExPhZXGm53Q9wE+spcuspME4HDT8ies6FA48v+liGIlpNwjuruV/JogRz24PMCtFnNqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790277677; c=relaxed/simple;
	bh=inHw8URSKZ6Wd7AFUPjQECeWlY1eqrbsds88Zf0+aNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bADgaMdpvROlRwvNKPIN0ambCowuYNHPAEpa4+tfxrMAMMaaPUZWD9NyT0rgVgCsvUr7Xm/gw+7gd/xPD6R6/NTRAiB0+/kSuNRti7k5LiiuoBF8NJCv6B4xh5yYcltlTE2Zadu2Z78B3j9VIGlt4ulAjIK6g3mUVi5s1iVS7FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cevn/Fnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cevn/Fnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721D71F000FF;
	Thu, 24 Sep 2026 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790277675;
	bh=0wXxdYVsshJ0gSDG9cijtd0bHOwuhFUDxehlQ54Z74g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cevn/Fnx8MbOZMRWQScMicSp8Hjn1R31SomUQPYWmJx+IlKoLZmFGmOo5x7a7zpMA
	 H3olMn6TwXqmSYA0vZmEgtFn+r67Ffvf/7ZmLJ32Rnt1Xu1F+A9YONJfOsw4kpQVOV
	 xFeQL1ZfYNmhPgomfm8p9xntyeoyxo9jQl+UDHXd5olRZTxczhnCGBeWEahHVEMtBX
	 iAZQMLwd0jtZYqOs7MivmcoYkvoGsnkVg3ziRwRYBo+4caW1yig3ZiZ3SYd/5yO1hA
	 TZNUxiqg5qyIYMVNP16pDjGFOGjmb/rtCBNdQLVhheQQrP/+bGHjyFH16t7fi5LAuF
	 BJinYAYXx9/ng==
Date: Thu, 24 Sep 2026 09:21:14 -1000
From: Tejun Heo <tj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, justinstitt@google.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, morbo@google.com, nathan@kernel.org,
	ndesaulniers@google.com, Thomas Graf <tgraf@suug.ch>,
	nickolay.lysenko@gmail.com, peterz@infradead.org,
	rostedt@goodmis.org, sched-ext@lists.linux.dev
Subject: Re: [PATCH] rhashtable: specialize default comparison for constant
 parameters
Message-ID: <arV4Ksry0nZF38SL@slm.duckdns.org>
References: <20260924184733.2317353-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924184733.2317353-1-usama.arif@linux.dev>

On Thu, Sep 24, 2026 at 11:47:33AM -0700, Usama Arif wrote:
> The inline lookup and insert helpers receive the rhashtable parameters by
> value. With a static const parameter block, key_offset and key_len are
> compile-time constants at the call site.
> 
> The default comparison throws that information away by reading both fields
> back from ht->p. Fixed-size keys consequently load the parameters and call
> bcmp() for every object in the bucket, even when the compiler could use
> scalar comparisons instead.
> 
> The commit "sched_ext: Specialize the DSQ hashtable compare" [1] resulted
> in a 2.9x faster DSQ lookup after replacing this path for its u64 key
> with a scalar comparison. Doing that through obj_cmpfn requires every
> fixed-key user to provide its own callback.
> 
> Pass the call-site parameters to rhashtable_compare(), as
> rht_key_get_hash() already does. Use them when key_len is a compile-time
> constant. Retain the ht->p path for dynamic parameter blocks. A constant
> zero key_len continues to take the runtime length from ht->p.key_len.
> 
> This specializes the default comparison for all fixed-size users. With
> Clang 22 on x86-64, bcmp() disappears from sched_ext, mac80211, NFSd,
> TIPC, NFQUEUE, VFS superblock, pidfs, SysV IPC and hardware-breakpoint
> table paths. The affected build_policy.o, sta_info.o and nfsd filecache.o
> text shrinks by 512, 400 and 352 bytes respectively. Four- and eight-byte
> keys become direct scalar comparisons; six-byte MAC addresses become a
> four-byte and a two-byte comparison.
> 
> Measure the VFS case with ustat() on a mounted ramfs. This exercises
> user_get_super() and its super_dev lookup. Across ten interleaved baseline
> and patched VM boot pairs, with five 3 million call samples per boot, the
> average per-boot median latency drops from 477.2 to 462.6 ns per call, or
> 3.0%. All ten pairs improved.
> 
> No functional change intended.
> 
> [1] https://lore.kernel.org/all/20260921171928.1639407-1-usama.arif@linux.dev/
> 
> Suggested-by: Mykola Lysenko <nickolay.lysenko@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

This is great.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
