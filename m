Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7BC130E57
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725639937; cv=none; b=PjzYDlrFfZsBsnUt+iHYpV4xM2dntW8ADIE/v57fZJTKCeNSW0uFgoIEiz9/qrgomqgHEmrQHFWNM3lEuUzs002IOWBDZTojX70Kd2Jmya+sYiDcv9ynBlaEfLPuZpGLDgwY2vHOmZpcVZ2OFn+K+T/25MYdNCuX+jhyYchSvRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725639937; c=relaxed/simple;
	bh=xuXWBhgK6H/H4B+ip1bB9lKTQkBWETmCIDXvAjTdk88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6QCu/i9ZdA7b+SHGmyLf3AmeX0XO3d7H7f56+37JscqbFA8TSv8qqzCDqmj24+yw3V8//wWPTloFV3Ac60vnpPq9oT6J5qYY/wmJUIg5QDsIaXXLdEDON+ZEsTb8OwgLuIzir0CdUEGpLpNhAVK60ymLdn/Dqx1mA651cGsBV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQ3HhggX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQ3HhggX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725639936; x=1757175936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xuXWBhgK6H/H4B+ip1bB9lKTQkBWETmCIDXvAjTdk88=;
  b=IQ3HhggXkkUgeaSa8G0HBKTlp0jBUU8Zwdj1h7yAKey5+k4l0FnqNVTs
   dAjYH9m7AsvpDv2Mo7eEHZL8ywjAzRzECW6GEF8I+CSbujBkdYT3oJflf
   tZ0pMU9oh9o1BuSbfjywUS3A7at9AT5QiAvhd7B+gJwsX5ysZPdZA3nrl
   6xmilVVufae1de3rVQt5qbtYiJf8IhZ2vBKaoQQjkqd5Ka84s+2yMtCbq
   /I9hP3Kol8QeetXBcwK95PPdwdBL0FydSIT8A2jf0b4Xgv7zbbPeFvsEy
   aEgk3/HylZutP76wN4HZcoPeSW9huWC9moeLQE9x6KoURULI70hKU8kEk
   Q==;
X-CSE-ConnectionGUID: 9ebIxlp2TTeF1Bpk8Mgs0g==
X-CSE-MsgGUID: iOOCdP4ORUWUyztMcFlhPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="35549952"
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="35549952"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 09:25:35 -0700
X-CSE-ConnectionGUID: 6GNBy+cBSY2B6VaehpauUQ==
X-CSE-MsgGUID: 1htuGuWiTUGOZTT4jWlUUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="66746111"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 06 Sep 2024 09:25:33 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1smbm7-000BUj-00;
	Fri, 06 Sep 2024 16:25:31 +0000
Date: Sat, 7 Sep 2024 00:25:06 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v8 6/6] Add SPAcc compilation in crypto
Message-ID: <202409062336.4TasntvL-lkp@intel.com>
References: <20240905113050.237789-7-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905113050.237789-7-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build errors:

[auto build test ERROR on b8fc70ab7b5f3afbc4fb0587782633d7fcf1e069]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-Skcipher-support/20240905-193246
base:   b8fc70ab7b5f3afbc4fb0587782633d7fcf1e069
patch link:    https://lore.kernel.org/r/20240905113050.237789-7-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v8 6/6] Add SPAcc compilation in crypto
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20240906/202409062336.4TasntvL-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240906/202409062336.4TasntvL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409062336.4TasntvL-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/crypto/dwc-spacc/spacc_device.h:10,
                    from drivers/crypto/dwc-spacc/spacc_skcipher.c:10:
>> drivers/crypto/dwc-spacc/spacc_core.h:736:31: error: field 'pop_jobs' has incomplete type
     736 |         struct tasklet_struct pop_jobs;
         |                               ^~~~~~~~


vim +/pop_jobs +736 drivers/crypto/dwc-spacc/spacc_core.h

450b68890aff16 Pavitrakumar M 2024-09-05  732  
450b68890aff16 Pavitrakumar M 2024-09-05  733  struct spacc_priv {
450b68890aff16 Pavitrakumar M 2024-09-05  734  	struct spacc_device spacc;
450b68890aff16 Pavitrakumar M 2024-09-05  735  	struct semaphore core_running;
450b68890aff16 Pavitrakumar M 2024-09-05 @736  	struct tasklet_struct pop_jobs;
450b68890aff16 Pavitrakumar M 2024-09-05  737  	spinlock_t hw_lock;
450b68890aff16 Pavitrakumar M 2024-09-05  738  	unsigned long max_msg_len;
450b68890aff16 Pavitrakumar M 2024-09-05  739  };
450b68890aff16 Pavitrakumar M 2024-09-05  740  
450b68890aff16 Pavitrakumar M 2024-09-05  741  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
