Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156363A2561;
	Mon, 20 Apr 2026 17:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776705814; cv=none; b=kfPl92tpB1yWs90IFPe74z6o6ptRJM2rbiw6HhPjZnolriKum9MlSD/KVKNAElySTFA7r8T+Z4U4/fa+frFQv0fXOldOxWhaKub8nXS68ypNA8b2FD25BcD+3HQabg52aEeXLeDbdulLWE6XsAUbajAPSudN5pB89M4uwU2fhM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776705814; c=relaxed/simple;
	bh=rBE/AEervawb8RdmDWSRWgLIOT5De76UJOpmVhQNgc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQSqCwJ9GPrQB2YLVBIOJpMkRdbD9f1nKthxatIbfpZSpFHVVVZfp4aNP0uE8hwgF6q9s3Brlo/MfWH5oj2ncTP88e58xEJvcYDKSLt3gxai2IuUtLWH3T20kb4JtWGGprLFLgI10STmDEDLogs4SWGXtgTjZCTHS8D4SqZ6msg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ECDDwu7E; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ECDDwu7E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776705812; x=1808241812;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rBE/AEervawb8RdmDWSRWgLIOT5De76UJOpmVhQNgc4=;
  b=ECDDwu7EXhgEoWlKDHOG50Ut6tkuyAQg2WgaTzOOCnCTOTVLQsBMzmQF
   B9Xiu0D14RQvqVlxn0ePMnM7YZdonhdm9nDUedLVnR0q2BjNGqPbMBIoT
   /Q5P6MDakbsPAJD+RO/TFrGbpjPLbpdM4XruPtC2eWYP/H6xn7Mds/Yhp
   1m6t5B6j8ux+7Vd6eQAViPzSQ40+xy7Y6bNHaA3Et5cbAMxmqrJKdOWtd
   YWeff++3EoGZcK7Rg9NSB/RDcbuVaTQGwZ9zToS1/9pt+k7fFUlJB3IHm
   4GcZZFdpMOy4ZmJAaBnRUHHbcA0pBUKnUfMy26JKuJ8rSNMLrbx+/q2Ww
   g==;
X-CSE-ConnectionGUID: bjmRNRDDRkSCtX/rxe064g==
X-CSE-MsgGUID: BE5raz5jRa6rWJL4VuDeDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="89097990"
X-IronPort-AV: E=Sophos;i="6.23,190,1770624000"; 
   d="scan'208";a="89097990"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 10:23:32 -0700
X-CSE-ConnectionGUID: ErK47NMFRKevGid/FVva5A==
X-CSE-MsgGUID: YYr8FaJxT8OabMGTyJSi9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,190,1770624000"; 
   d="scan'208";a="255039477"
Received: from lkp-server01.sh.intel.com (HELO 7e48d0ff8e22) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 20 Apr 2026 10:23:28 -0700
Received: from kbuild by 7e48d0ff8e22 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wEsLE-000000002hQ-49Ob;
	Mon, 20 Apr 2026 17:23:24 +0000
Date: Tue, 21 Apr 2026 01:22:36 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Tejun Heo <tj@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org, NeilBrown <neil@brown.name>
Subject: Re: [PATCH] rhashtable: Restore insecure_elasticity toggle
Message-ID: <202604210112.4dByOk9v-lkp@intel.com>
References: <aeLgjAeJuidWNy3N@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeLgjAeJuidWNy3N@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on net/main net-next/main linus/master v7.0]
[cannot apply to next-20260420]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/rhashtable-Restore-insecure_elasticity-toggle/20260418-233732
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/aeLgjAeJuidWNy3N%40gondor.apana.org.au
patch subject: [PATCH] rhashtable: Restore insecure_elasticity toggle
config: sparc64-allmodconfig (https://download.01.org/0day-ci/archive/20260421/202604210112.4dByOk9v-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260421/202604210112.4dByOk9v-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604210112.4dByOk9v-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from net/mac80211/s1g.c:9:
   In file included from net/mac80211/ieee80211_i.h:27:
   include/linux/rhashtable.h:831:32: error: member reference type 'struct rhashtable_params' is not a pointer; did you mean to use '.'?
     831 |         if (elasticity <= 0 && !params->insecure_elasticity)
         |                                 ~~~~~~^~
         |                                       .
   include/linux/rhashtable.h:839:13: error: member reference type 'struct rhashtable_params' is not a pointer; did you mean to use '.'?
     839 |             !params->insecure_elasticity)
         |              ~~~~~~^~
         |                    .
>> net/mac80211/s1g.c:104:36: warning: implicit conversion from 'unsigned long' to '__u16' (aka 'unsigned short') changes value from 18446744073709551614 to 65534 [-Wconstant-conversion]
     104 |         twt_agrt->req_type &= cpu_to_le16(~IEEE80211_TWT_REQTYPE_REQUEST);
         |                               ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/byteorder/generic.h:90:21: note: expanded from macro 'cpu_to_le16'
      90 | #define cpu_to_le16 __cpu_to_le16
         |                     ^
   include/uapi/linux/byteorder/big_endian.h:36:53: note: expanded from macro '__cpu_to_le16'
      36 | #define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
         |                                           ~~~~~~~~~~^~~
   include/uapi/linux/swab.h:107:12: note: expanded from macro '__swab16'
     107 |         __fswab16(x))
         |         ~~~~~~~~~ ^
   1 warning and 2 errors generated.


vim +104 net/mac80211/s1g.c

f5a4c24e689f54e Lorenzo Bianconi 2021-08-23   95  
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23   96  static void
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23   97  ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23   98  			   struct sta_info *sta, struct sk_buff *skb)
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23   99  {
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  100  	struct ieee80211_mgmt *mgmt = (void *)skb->data;
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  101  	struct ieee80211_twt_setup *twt = (void *)mgmt->u.action.u.s1g.variable;
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  102  	struct ieee80211_twt_params *twt_agrt = (void *)twt->params;
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  103  
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23 @104  	twt_agrt->req_type &= cpu_to_le16(~IEEE80211_TWT_REQTYPE_REQUEST);
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  105  
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  106  	/* broadcast TWT not supported yet */
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  107  	if (twt->control & IEEE80211_TWT_CONTROL_NEG_TYPE_BROADCAST) {
7ff379ba2d4b7b2 Johannes Berg    2021-09-27  108  		twt_agrt->req_type &=
7ff379ba2d4b7b2 Johannes Berg    2021-09-27  109  			~cpu_to_le16(IEEE80211_TWT_REQTYPE_SETUP_CMD);
7ff379ba2d4b7b2 Johannes Berg    2021-09-27  110  		twt_agrt->req_type |=
7ff379ba2d4b7b2 Johannes Berg    2021-09-27  111  			le16_encode_bits(TWT_SETUP_CMD_REJECT,
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  112  					 IEEE80211_TWT_REQTYPE_SETUP_CMD);
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  113  		goto out;
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  114  	}
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  115  
30ac96f7cc973bb Howard Hsu       2022-10-27  116  	/* TWT Information not supported yet */
30ac96f7cc973bb Howard Hsu       2022-10-27  117  	twt->control |= IEEE80211_TWT_CONTROL_RX_DISABLED;
30ac96f7cc973bb Howard Hsu       2022-10-27  118  
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  119  	drv_add_twt_setup(sdata->local, sdata, &sta->sta, twt);
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  120  out:
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  121  	ieee80211_s1g_send_twt_setup(sdata, mgmt->sa, sdata->vif.addr, twt);
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  122  }
f5a4c24e689f54e Lorenzo Bianconi 2021-08-23  123  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
