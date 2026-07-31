Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4652E37AA87
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 20:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785530410; cv=none; b=O4YmPwv1Ejkp3ZBrClZR7a3fA8BisS+5X/mzst0uKSD9qQRBHjb3Yopsvt8R+/Gga0ZYNow/R/J8jSGMpB7Fe1Ruhd2aatBNhsxypjD+TNjm7NSekDa8YustM4QosMUcwrSeyXCoqAMZL3gAuavm3K/pWixfFc5YFkDy/S3YzyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785530410; c=relaxed/simple;
	bh=6mYe3jqOi0M6Xn+VyM0LLp7zc54Z8kTjN1Y1zm6tmqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTqPt8+fuGH/FF183mbOj3Hq9ZE8oP4C4rug7hXUNYEVkkI6o+FNgwAgKAHGO1FRgLz0JWlAOJT/52ZG1U51uyLtXD6OE/6tvAfUgjdg/rRM5zYJm/VbCPdkkfF5a/pZMuvu6UkvGxaTHw/OVJB6VzODaDrI/8DluA8lzuaI9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UQmHsYnn; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UQmHsYnn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785530409; x=1817066409;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6mYe3jqOi0M6Xn+VyM0LLp7zc54Z8kTjN1Y1zm6tmqY=;
  b=UQmHsYnnykz/f9bwbqs+k/DNLKTh1lBKbPHq4K8I8BsKIBPE1VoY4wyU
   kVH69yfHQjG+1AzGMUjNh03jOwCfymyEh0CGifwC27h1PlnyafdKw1mM7
   OCGD4CWZ7V5OJqLnsMAFyBAlgRamiQCccA71YTUJVNzuX0qFsyHW+3aA+
   2q08YPdWH8543LHbJf84wccSmVlEXpe2NOgB/BYULQazBFDFM9bN73Slg
   imGYnmvqT0stzqSgCZYiH/E0du0w+X6g2pg1JfYinbzvHtvC5BesCVxt1
   aa+IeNoGjT9Uy7RjM7croE0YdBrBpRy7J8KjrbUJe9yFdOuEpMhAckHMR
   Q==;
X-CSE-ConnectionGUID: /qsfK83WSUWyn/yh796wfQ==
X-CSE-MsgGUID: YiW3pRf8QEWhg3Y7tdNwhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="86021089"
X-IronPort-AV: E=Sophos;i="6.25,197,1779174000"; 
   d="scan'208";a="86021089"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 13:40:08 -0700
X-CSE-ConnectionGUID: 3hRSjK/ZRY2zB84NvBbGtQ==
X-CSE-MsgGUID: 1f9ct3fhRjOVP8SBkynCVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,197,1779174000"; 
   d="scan'208";a="264483800"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 31 Jul 2026 13:40:07 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpu1T-000000002Cv-43W5;
	Fri, 31 Jul 2026 20:40:03 +0000
Date: Sat, 1 Aug 2026 04:39:54 +0800
From: kernel test robot <lkp@intel.com>
To: Arbab Haider <arbabhaider649@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: oe-kbuild-all@lists.linux.dev, Arbab Haider <arbabhaider649@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	John Garry <john.g.garry@oracle.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/sec - Fix element drop and UAF in
 sec_send_request()
Message-ID: <202608010642.kGjbBrg7-lkp@intel.com>
References: <20260730215449.299311-1-arbabhaider649@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730215449.299311-1-arbabhaider649@gmail.com>

Hi Arbab,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v7.2-rc5 next-20260731]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Arbab-Haider/crypto-hisilicon-sec-Fix-element-drop-and-UAF-in-sec_send_request/20260731-234619
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20260730215449.299311-1-arbabhaider649%40gmail.com
patch subject: [PATCH] crypto: hisilicon/sec - Fix element drop and UAF in sec_send_request()
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20260801/202608010642.kGjbBrg7-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260801/202608010642.kGjbBrg7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608010642.kGjbBrg7-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/hisilicon/sec/sec_algs.c: In function 'sec_send_request':
>> drivers/crypto/hisilicon/sec/sec_algs.c:406:33: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
     406 |                                 ;
         |                                 ^
   drivers/crypto/hisilicon/sec/sec_algs.c:410:33: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
     410 |                                 ;
         |                                 ^


vim +/if +406 drivers/crypto/hisilicon/sec/sec_algs.c

   382	
   383	/* queuelock must be held */
   384	static void sec_send_request(struct sec_request *sec_req, struct sec_queue *queue)
   385	{
   386		struct sec_request_el *el, *temp;
   387	
   388		mutex_lock(&sec_req->lock);
   389		list_for_each_entry_safe(el, temp, &sec_req->elements, head) {
   390			/*
   391			 * Add to hardware queue only under following circumstances
   392			 * 1) Software and hardware queue empty so no chain dependencies
   393			 * 2) No dependencies as new IV - (check software queue empty
   394			 *    to maintain order)
   395			 * 3) No dependencies because the mode does no chaining.
   396			 *
   397			 * In other cases first insert onto the software queue which
   398			 * is then emptied as requests complete
   399			 */
   400			if (!queue->havesoftqueue ||
   401			    (kfifo_is_empty(&queue->softqueue) &&
   402			     sec_queue_empty(queue))) {
   403				if (WARN_ON_ONCE(sec_queue_send(queue, &el->req,
   404								sec_req)))
   405					/* Should not happen with proper capacity check */
 > 406					;
   407			} else {
   408				if (WARN_ON_ONCE(!kfifo_put(&queue->softqueue, el)))
   409					/* Should not happen with proper capacity check */
   410					;
   411			}
   412		}
   413		mutex_unlock(&sec_req->lock);
   414	}
   415	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
