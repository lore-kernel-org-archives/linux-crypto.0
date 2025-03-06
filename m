Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F65207DEB
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741296067; cv=none; b=pacB8ETMXf++H9RZmOG6bBj0/3HOpadSk/Od49ZOA12RlgLJbCkPQ9Xe4FzRpJdsKrCFEkM28nOOvMMB2GAEbeBzV6b1GV4PGyMeftQWMOIivTYIv9NAsjO/BvaZVJqPmlI7texk24FLfmDLukteR1/tKN9ZYub4gigSJ91qeeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741296067; c=relaxed/simple;
	bh=QwtTDEYAnNwj0jO5A7hwwJCo0R5apTOt+3h+jokZPyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1dEUXV+mbRiCiMy1W+OfowGdiLCF24RnVUAtyDLB7e5XjUpCrq1BPLea0OAe2dqrf7T6gLMTnphpP7Y1HHZtXv1n9gmko98N9LC+WDRzVn6iWqyAlRpnj2YkSDWoAczIC+0M2aLx7Snc1CS19uRMybCC/nePd9U2XJPrgumiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IdcUPmwH; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IdcUPmwH"
Date: Thu, 6 Mar 2025 21:20:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741296062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lJvaHPzJT7/lU+BeSLL68xR7OTi5kIy1KlaEzXrMnR8=;
	b=IdcUPmwHqIZR9E0XtWbE4Ood0ckZDEBhIMJN9pQ1RPRvqJ9vkaikVt6R4REfmrV5CKak3Z
	d6K9DcBzTHIfov1zamF+8M0YK4qS6HctAZ7eV4dt9vJbrQub1DkU1npt7k/s9zLvRLp/zW
	tIRMiRO+jYZ+ozeKFPuHCcBlsPs/Tzg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, lkp <lkp@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
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
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v8 14/14] mm: zswap: Compress batching with request
 chaining in zswap_store() of large folios.
Message-ID: <Z8oRsGHmt2E4diKK@google.com>
References: <20250303084724.6490-15-kanchana.p.sridhar@intel.com>
 <202503031847.j1iReOtf-lkp@intel.com>
 <CAKEwX=MgV22UBNi-2dNBDgNM2DRfrngk_4gO7z9t-O0KrpdPUw@mail.gmail.com>
 <SA3PR11MB8120445C8DBDBB9945231B66C9C92@SA3PR11MB8120.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA3PR11MB8120445C8DBDBB9945231B66C9C92@SA3PR11MB8120.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 03, 2025 at 09:34:04PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Nhat Pham <nphamcs@gmail.com>
> > Sent: Monday, March 3, 2025 10:22 AM
> > To: lkp <lkp@intel.com>
> > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; linux-
> > kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> > yosry.ahmed@linux.dev; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; llvm@lists.linux.dev; oe-kbuild-
> > all@lists.linux.dev; Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal,
> > Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v8 14/14] mm: zswap: Compress batching with request
> > chaining in zswap_store() of large folios.
> > 
> > On Mon, Mar 3, 2025 at 3:07 AM kernel test robot <lkp@intel.com> wrote:
> > >
> > > Hi Kanchana,
> > >
> > > kernel test robot noticed the following build errors:
> > >
> > > > 1166                          prefetchw(entries[j]);
> > > --
> > 
> > Why are we doing this anyway? Does it have a notable performance
> > difference? At the very least, leave a comment explaining why we're
> > prefetching this (although the build error suggests that we have to
> > remove it anyway).
> 
> Hi Nhat,
> 
> Yes, it does. The use of prefetchw reduces sys time by ~1.5% because
> it minimizes cache-miss latency by moving the zswap entry to the cache
> before it is written to. 
> 
> This is data with kernel compilation test, v8 without prefetchw and v8 as-is:
> 
> --------------------------------------------------------------------------------
>  Kernel compile       v8 without               v8      v8 without              v8
>  allmodconfig          prefetchw                        prefetchw
>  2M folios
>  --------------------------------------------------------------------------------
>  zswap compressor    deflate-iaa      deflate-iaa            zstd            zstd   
>  --------------------------------------------------------------------------------
>  real_sec                 732.89           735.63          768.53          758.21
>  user_sec              15,708.37        15,699.84       15,702.64       15,678.73
>  sys_sec                4,632.58         4,563.70        5,735.06        5,635.69
>  --------------------------------------------------------------------------------
>  Max_Res_Set_Size_KB   1,874,672        1,867,516       1,874,684       1,872,888
>  --------------------------------------------------------------------------------
>  memcg_high                    0                0               0               0
>  memcg_swap_fail               0                0               0               0
>  zswpout             114,742,930      112,836,725      92,904,961      89,596,085
>  zswpin               41,184,897       39,983,793      31,018,149      29,163,932
>  pswpout                     625            1,069             558           1,059
>  pswpin                      599            1,056             540           1,051
>  thp_swpout                    1                2               1               2
>  thp_swpout_fallback      10,967           10,195           6,918           6,141
>  pgmajfault           42,588,331       41,349,069      31,931,882      30,006,422
>  ZSWPOUT-2048kB            7,661            8,710           6,799           7,480
>  SWPOUT-2048kB                 1                2               1               2
>  --------------------------------------------------------------------------------
> 
> 
> Sure, I will add a comment, and also "#include <linux/prefetch.h>" in zswap.c
> that will resolve the build error. This is similar to how these files handle prefetchw:
> mm/vmscan.c, kernel/locking/qspinlock.c, include/asm-generic/xor.h, etc.

Please also explicitly mention that the prefetch and likely/unlikely
annotations prevent regressions with software compression like zstd, and
generally improve the performance with the batching code by ~1.5%.

> 
> Thanks,
> Kanchana
> 
