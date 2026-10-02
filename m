Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD35F47C0F2;
	Fri,  2 Oct 2026 10:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936000; cv=none; b=CUm5+AnAqkm3T1tvxsFV8+274Ny42VEDT+3RrWdIFSAhb2aovWkcdual1n7e0yFg6nOuYcaeZgI5GVJ99omqv0iPFcUurumimHUv62dY/JLQWFQ3hTbWzxuEoNMtegA8zWVgdeE0zlYVTHD8GNNBhbyb6atO6Aa078VLLWo1sDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936000; c=relaxed/simple;
	bh=1K1pSu9xqd/QnEsydj1SEWL1rT4GROdwGnFU9QKa0DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KyXwjBPoANX9NbC+EopU+T9ca/JkEP22G3VWvDJ7snPGHF5pW1e0FDkKLRwL/pddN8jmwFegXMYMOCSGUnhCCdWkygIsC+5qiKMrKSsbxF/9pk9zvuT2Pz4CI0fjX9aMMrv2j7A6XJa/8Q0MxxwSVmjYrXU9LSEXYSGp2N6QGHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sg2LVVh2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sg2LVVh2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=scpWT3qLm4oe8br1I0C/RtwU+L9zN4X8RYPTjpix0os=; 
	b=sg2LVVh2tTbTrV9FU/THA4LSi2WrnA0DfNzGBYaok+5ogNhNmbRUDma3AHAvTvGRpxZjudsRSWW
	21gZ2WzTOD9VOPcbBBn9+1u0lcJS9TrEfH+umdyNmD3Wpupg/wFhpbbai0ADBouZvB6ezfTcX9Zuc
	Wks9GVcmErchDOqDn16aH9DGJlW2QqPvpIfQ8Uqxkvmi5VUwvv0yflyOcadOB+l0opZH9MIPri+IY
	7l2ldOFzDAKZ9aIxe18mR664w6WHYRhPfMl6NV29MA1KUJUw/+TjM/IhDt2TGFbbWTeugXrUzumnG
	/cDmz9UnfEuDbs72+ZBERZl0WPx8T1IqiqfQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaGI-000000001hp-1cbu;
	Fri, 02 Oct 2026 18:13:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:13:06 +1000
Date: Fri, 2 Oct 2026 20:13:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, justinstitt@google.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, morbo@google.com, nathan@kernel.org,
	ndesaulniers@google.com, Thomas Graf <tgraf@suug.ch>,
	nickolay.lysenko@gmail.com, peterz@infradead.org,
	rostedt@goodmis.org, sched-ext@lists.linux.dev, tj@kernel.org
Subject: Re: [PATCH] rhashtable: specialize default comparison for constant
 parameters
Message-ID: <ar-Dsnb6CRRe9Q98@gondor.apana.org.au>
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
> ---
>  include/linux/rhashtable.h | 20 +++++++++++++++-----
>  lib/rhashtable.c           |  5 +++--
>  2 files changed, 18 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
