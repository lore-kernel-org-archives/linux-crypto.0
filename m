Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A423F378
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 01:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740791569; cv=none; b=AHO/bapQBYgcAlaNpHidXkdrLS0Z9eXARZ59Tg05SneYHAWIrRHYImvHe5A/Uflwlc9/zJjvCZy/jNs0GX//vE26ZiuaiJhGT8A47rC1TpwigwVPLkql8/7WF1O0QMp70e+RrKENaJHceQ2jfCTxpt3QlZWgk0sCRRsoXX30WBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740791569; c=relaxed/simple;
	bh=nxf5uOZHu4D1fEmKFbKW+aC1mKBL7V0q5waCEd3lai4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n82W6W4xxd6D8wyADLo5fu6Uyp+iU09YqTynfWYsSMwgmwJLyV7f63lL+yIYZkle4sZ5iA4R2QTs3OBp4yyJgqgdmvWIKeHpgcyc021GAlYkBZ/VzK0GxPbG/Dz4E0v+g8IQrLxazImyPLUxBwXU6OyKIy7Ab9Zzzs6Ol2L+2Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tYwoWpEL; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tYwoWpEL"
Date: Sat, 1 Mar 2025 01:12:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740791563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9emaphPqtgVlUZs1vHa3DOC+UUviuIxuArQDUuwWXTo=;
	b=tYwoWpELCKiTn56c9jkg+U88rsHhU6tmFfQdFhePgLwATY+0y3h1xuwK9lV99YnXrmAWL8
	GUnVbyaprLgv/kHHyBR3MZAJErOYLvWJfLLEi0zCFfUTreqvNos02zhxc+Mx5z8fuEFS+q
	APxkkx0/eKVHSwnYMeSG2q+nlSICX7M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v7 00/15] zswap IAA compress batching
Message-ID: <Z8JfA5eJa-HUbYO3@google.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
 <SA3PR11MB8120AD2AD0A9208BDA861580C9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA3PR11MB8120AD2AD0A9208BDA861580C9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 01, 2025 at 01:09:22AM +0000, Sridhar, Kanchana P wrote:
> Hi All,
> 
> > Performance testing (Kernel compilation, allmodconfig):
> > =======================================================
> > 
> > The experiments with kernel compilation test, 32 threads, in tmpfs use the
> > "allmodconfig" that takes ~12 minutes, and has considerable swapout/swapin
> > activity. The cgroup's memory.max is set to 2G.
> > 
> > 
> >  64K folios: Kernel compilation/allmodconfig:
> >  ============================================
> > 
> >  -------------------------------------------------------------------------------
> >                      mm-unstable               v7   mm-unstable            v7
> >  -------------------------------------------------------------------------------
> >  zswap compressor    deflate-iaa      deflate-iaa          zstd          zstd
> >  -------------------------------------------------------------------------------
> >  real_sec                 775.83           765.90        769.39        772.63
> >  user_sec              15,659.10        15,659.14     15,666.28     15,665.98
> >  sys_sec                4,209.69         4,040.44      5,277.86      5,358.61
> >  -------------------------------------------------------------------------------
> >  Max_Res_Set_Size_KB   1,871,116        1,874,128     1,873,200     1,873,488
> >  -------------------------------------------------------------------------------
> >  memcg_high                    0                0             0             0
> >  memcg_swap_fail               0                0             0             0
> >  zswpout             107,305,181      106,985,511    86,621,912    89,355,274
> >  zswpin               32,418,991       32,184,517    25,337,514    26,522,042
> >  pswpout                     272               80            94            16
> >  pswpin                      274               69            54            16
> >  thp_swpout                    0                0             0             0
> >  thp_swpout_fallback           0                0             0             0
> >  64kB_swpout_fallback        494                0             0             0
> >  pgmajfault           34,577,545       34,333,290    26,892,991    28,132,682
> >  ZSWPOUT-64kB          3,498,796        3,460,751     2,737,544     2,823,211
> >  SWPOUT-64kB                  17                4             4             1
> >  -------------------------------------------------------------------------------
> > 
> > [...]
> >
> > Summary:
> > ========
> > The performance testing data with usemem 30 processes and kernel
> > compilation test show 61%-73% throughput gains and 27%-37% sys time
> > reduction (usemem30) and 4% sys time reduction (kernel compilation) with
> > zswap_store() large folios using IAA compress batching as compared to
> > IAA sequential. There is no performance regression for zstd/usemem30 and a
> > slight 1.5% sys time zstd regression with kernel compilation allmod
> > config.
> 
> I think I know why kernel_compilation with zstd shows a regression whereas
> usemem30 does not. It is because I lock/unlock the acomp_ctx mutex once
> per folio. This can cause decomp jobs to wait for the mutex, which can cause
> more compressions, and this repeats. kernel_compilation has 25M+ decomps
> with zstd, whereas usemem30 has practically no decomps, but is
> compression-intensive, because of which it benefits the once-per-folio lock
> acquire/release.
> 
> I am testing a fix where I return zswap_compress() to do the mutex lock/unlock,
> and expect to post v8 by end of the day. I would appreciate it if you can hold off
> on reviewing only the zswap patches [14, 15] in my v7 and instead review the v8
> versions of these two patches.

I was planning to take a look at v7 next week, so take your time, no
rush to post it on a Friday afternoon.

Anyway, thanks for the heads up, I appreciate you trying to save
everyone's time.
