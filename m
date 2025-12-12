Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B608C224AE0
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 01:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765501592; cv=none; b=cmK5jBZohY5UwnbpUCyP/uo2kmEGgIZ1lqEXe+YhF7pTnyC85C24y7m8SjqK2GhRliW9ne18LzhFiBypIhzIcSY3QZTjarVIzTxKWR+EUhz7zObyasarYin24xOpHfm137QGXRbZEPQR0+O9l6hIU5LWa8UtNbEiyEnHp1AnvYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765501592; c=relaxed/simple;
	bh=a2EA0R6KpGO8mza301rDhPc5mxuwSY+kkLg1D907tp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lb5nQETqhzkoqWQJ5wr8ZWXofp5+Bk5BB7dndPakjoOQNkbRebzy/w1H9bUNxqSfNS/y5zwUW3y03jQM+aiPkxsMhWVQPubR2OLSv/lEP+rko9Im11Ze/C0E9aO2TSWlNaEO4id5We7Z+6MnLdGzPoY74/vqs1WpfYi3dzrwAIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NBASkG/d; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NBASkG/d"
Date: Fri, 12 Dec 2025 01:06:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765501587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4mnFhMQvoL3Tbh3eu4uaMeknBOuqdt/beNT596uP9Bc=;
	b=NBASkG/db0xbw3HwkCD4mtCX9qFpvMjvZtpuhF3TvGpepKHCtV4jFXKxWCwSBz7BA1YY+z
	uwEx6J/9ZAFWHsje5Fzsx1uO9E155c5qru/vXJXkfuRQIHB/TYOxmAMXd03EhaiJE8eKiZ
	bldt41pukUOPPRr9yjVJXhmV/BTWAKM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 12, 2025 at 12:55:10AM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, November 13, 2025 12:24 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources
> > exist from pool creation to deletion.
> > 
> > On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:
> > 
> > The subject can be shortened to:
> > 
> > "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"
> > 
> > > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> > > pool creation to pool deletion. These resources will persist through CPU
> > > hotplug operations instead of being destroyed/recreated. The
> > > zswap_cpu_comp_dead() teardown callback has been deleted from the call
> > > to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a
> > result, CPU
> > > offline hotplug operations will be no-ops as far as the acomp_ctx
> > > resources are concerned.
> > 
> > Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> > complicates the lifetime management to save memory while a CPU is
> > offlined, which is not very common.
> > 
> > Simplify lifetime management by allocating per-CPU acomp_ctx once on
> > pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> > allocated until the pool is destroyed.
> > 
> > >
> > > This commit refactors the code from zswap_cpu_comp_dead() into a
> > > new function acomp_ctx_dealloc() that is called to clean up acomp_ctx
> > > resources from:
> > >
> > > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > > 2) zswap_pool_create() when an error is encountered, and
> > > 3) from zswap_pool_destroy().
> > 
> > 
> > Refactor cleanup code from zswap_cpu_comp_dead() into
> > acomp_ctx_dealloc() to be used elsewhere.
> > 
> > >
> > > The main benefit of using the CPU hotplug multi state instance startup
> > > callback to allocate the acomp_ctx resources is that it prevents the
> > > cores from being offlined until the multi state instance addition call
> > > returns.
> > >
> > >   From Documentation/core-api/cpu_hotplug.rst:
> > >
> > >     "The node list add/remove operations and the callback invocations are
> > >      serialized against CPU hotplug operations."
> > >
> > > Furthermore, zswap_[de]compress() cannot contend with
> > > zswap_cpu_comp_prepare() because:
> > >
> > >   - During pool creation/deletion, the pool is not in the zswap_pools
> > >     list.
> > >
> > >   - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
> > >     out. zswap_cpu_comp_prepare() will be run on a control CPU,
> > >     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of
> > "enum
> > >     cpuhp_state". Thanks Yosry for sharing this observation!
> > >
> > >   In both these cases, any recursions into zswap reclaim from
> > >   zswap_cpu_comp_prepare() will be handled by the old pool.
> > >
> > > The above two observations enable the following simplifications:
> > >
> > >  1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim cannot
> > use
> > >     the pool. Considerations for mutex init/locking and handling
> > >     subsequent CPU hotplug online-offline-online:
> > >
> > >     Should we lock the mutex of current CPU's acomp_ctx from start to
> > >     end? It doesn't seem like this is required. The CPU hotplug
> > >     operations acquire a "cpuhp_state_mutex" before proceeding, hence
> > >     they are serialized against CPU hotplug operations.
> > >
> > >     If the process gets migrated while zswap_cpu_comp_prepare() is
> > >     running, it will complete on the new CPU. In case of failures, we
> > >     pass the acomp_ctx pointer obtained at the start of
> > >     zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
> > >     only undergo migration. There appear to be no contention scenarios
> > >     that might cause inconsistent values of acomp_ctx's members. Hence,
> > >     it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
> > >     zswap_cpu_comp_prepare().
> > >
> > >     Since the pool is not yet on zswap_pools list, we don't need to
> > >     initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). This
> > >     has been restored to occur in zswap_cpu_comp_prepare().
> > >
> > >     zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
> > >     valid. If so, it returns success. This should handle any CPU
> > >     hotplug online-offline transitions after pool creation is done.
> > >
> > >  2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
> > >     migrated to another CPU before the current CPU is dysfunctional. If
> > >     zswap_[de]compress() holds the acomp_ctx->mutex lock of the offlined
> > >     CPU, that mutex will be released once it completes on the new
> > >     CPU. Since there is no teardown callback, there is no possibility of
> > >     UAF.
> > >
> > >  3) Pool creation/deletion and process migration to another CPU:
> > >
> > >     - During pool creation/deletion, the pool is not in the zswap_pools
> > >       list. Hence it cannot contend with zswap ops on that CPU. However,
> > >       the process can get migrated.
> > >
> > >       Pool creation --> zswap_cpu_comp_prepare()
> > >                                 --> process migrated:
> > >                                     * CPU offline: no-op.
> > >                                     * zswap_cpu_comp_prepare() continues
> > >                                       to run on the new CPU to finish
> > >                                       allocating acomp_ctx resources for
> > >                                       the offlined CPU.
> > >
> > >       Pool deletion --> acomp_ctx_dealloc()
> > >                                 --> process migrated:
> > >                                     * CPU offline: no-op.
> > >                                     * acomp_ctx_dealloc() continues
> > >                                       to run on the new CPU to finish
> > >                                       de-allocating acomp_ctx resources
> > >                                       for the offlined CPU.
> > >
> > >  4) Pool deletion vis-a-vis CPU onlining:
> > >     The call to cpuhp_state_remove_instance() cannot race with
> > >     zswap_cpu_comp_prepare() because of hotplug synchronization.
> > >
> > > This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
> > > Instead, zswap_[de]compress() directly call
> > > mutex_[un]lock(&acomp_ctx->mutex).
> > 
> > I am not sure why all of this is needed. We should just describe why
> > it's safe to drop holding the mutex while initializing per-CPU
> > acomp_ctx:
> > 
> > It is no longer possible for CPU hotplug to race against allocation or
> > usage of per-CPU acomp_ctx, as they are only allocated once before the
> > pool can be used, and remain allocated as long as the pool is used.
> > Hence, stop holding the lock during acomp_ctx initialization, and drop
> > acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().
> 
> Hi Yosry,
> 
> Thanks for these comments. IIRC, there was quite a bit of technical
> discussion analyzing various what-ifs, that we were able to answer
> adequately. The above is a nice summary of the outcome, however,
> I think it would help the next time this topic is re-visited to have a log
> of the "why" and how races/UAF scenarios are being considered and
> addressed by the solution. Does this sound Ok?

How about using the summarized version in the commit log and linking to
the thread with the discussion?
