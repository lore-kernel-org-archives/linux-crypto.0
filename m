Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6699F343214
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757947860; cv=none; b=W+jlwCMegGX71Pm0OtQu1vrO+O7CHQZ4OdKhRB2xs3QgvUNnW6fluV02iuYFfVRgiiFCW9Kch8FaAyrvRqU+n/8WffLpkLtQ/afDkK2Ynq3nap0gC/kcwFEr2mQZzhQvZqOoJCUhoo+fOZyHnm8ZSobwajkvZp3xeM9he01zyPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757947860; c=relaxed/simple;
	bh=xlPh5ScPk3rHPZr6jVAbc/0PIC6KekblefsGVSJo6n8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YgvAhqmIg9oyVMWeYaHPVPx636IX16Z/+a0/25ZBSOmHYeQjjWUBvcj5Bsv0IZHjiR3qGCzMtbNWQNlW/KojNr41Yjfhhx/1rLyoZbD7UylwxO2tlJ4D6cSKazJIvMO9hsYTfBoxTDxL/MN+Cds2qJEx8Tf0no8khjVffhGC8Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j3QQBRfA; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3QQBRfA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757947858; x=1789483858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xlPh5ScPk3rHPZr6jVAbc/0PIC6KekblefsGVSJo6n8=;
  b=j3QQBRfA2z4n50zhG4NI3DdRRnbQFt3MF+cqOaPbMyfDtyfcKo6MTgbY
   8Wjw1eF5DXov1cb3aWETtJlN03PP2V5e3nYVUackqkarN/cb+ljNNlyGa
   3hLke6K2wwN/lcrT4eBbbbmTFZUHg7vVEQeYo/9JZLB3rTdjx8v5YyOBv
   3A1SpkwsoDbSLdxyumtv6hVAnGqtd83jb4d6Ykn7hiojPICOoNlTI+tvK
   GYNsmsb9bGKHzNSuGTxE9dXzOv+JR33p2rXjxRI1ZmvaXb/KsbpRxQ+W1
   fKtmZKhC0Ha199jWSfSiZdpu5SgAAep7OEyd+GkFCbg2iLcEoUkkyY7bd
   g==;
X-CSE-ConnectionGUID: tSxBluyHSWKyU6ftSbhuQA==
X-CSE-MsgGUID: rXsbpfZ4S/GPEJpOfsJ4+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="60277362"
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="60277362"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 07:46:41 -0700
X-CSE-ConnectionGUID: BGaYFhZbR0WRYIdXTIxvDA==
X-CSE-MsgGUID: ekJc5znuTTuWRr3ASiBEYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="174581810"
Received: from lkp-server01.sh.intel.com (HELO 5b01dd97f97c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 15 Sep 2025 07:46:40 -0700
Received: from kbuild by 5b01dd97f97c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyATV-0000KJ-2m;
	Mon, 15 Sep 2025 14:46:37 +0000
Date: Mon, 15 Sep 2025 22:46:16 +0800
From: kernel test robot <lkp@intel.com>
To: Rodolfo Giometti <giometti@enneenne.com>, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [V1 3/4] crypto ecdh.c: define the ECDH set_secret_raw method
Message-ID: <202509152238.lU1NZ63u-lkp@intel.com>
References: <20250915084039.2848952-4-giometti@enneenne.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915084039.2848952-4-giometti@enneenne.com>

Hi Rodolfo,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250912]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rodolfo-Giometti/crypto-ecdh-h-set-key-memory-region-as-const/20250915-164558
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250915084039.2848952-4-giometti%40enneenne.com
patch subject: [V1 3/4] crypto ecdh.c: define the ECDH set_secret_raw method
config: i386-buildonly-randconfig-002-20250915 (https://download.01.org/0day-ci/archive/20250915/202509152238.lU1NZ63u-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250915/202509152238.lU1NZ63u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509152238.lU1NZ63u-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/compiler_types.h:89,
                    from <command-line>:
   crypto/ecdh.c: In function 'ecdh_set_secret_raw':
>> include/linux/compiler_attributes.h:214:41: error: invalid use of attribute 'fallthrough'
     214 | # define fallthrough                    __attribute__((__fallthrough__))
         |                                         ^~~~~~~~~~~~~
   crypto/ecdh.c:76:9: note: in expansion of macro 'fallthrough'
      76 |         fallthrough;
         |         ^~~~~~~~~~~
--
   In file included from include/linux/compiler_types.h:89,
                    from <command-line>:
   ecdh.c: In function 'ecdh_set_secret_raw':
>> include/linux/compiler_attributes.h:214:41: error: invalid use of attribute 'fallthrough'
     214 | # define fallthrough                    __attribute__((__fallthrough__))
         |                                         ^~~~~~~~~~~~~
   ecdh.c:76:9: note: in expansion of macro 'fallthrough'
      76 |         fallthrough;
         |         ^~~~~~~~~~~


vim +/fallthrough +214 include/linux/compiler_attributes.h

294f69e662d1570 Joe Perches   2019-10-05  201  
294f69e662d1570 Joe Perches   2019-10-05  202  /*
294f69e662d1570 Joe Perches   2019-10-05  203   * Add the pseudo keyword 'fallthrough' so case statement blocks
294f69e662d1570 Joe Perches   2019-10-05  204   * must end with any of these keywords:
294f69e662d1570 Joe Perches   2019-10-05  205   *   break;
294f69e662d1570 Joe Perches   2019-10-05  206   *   fallthrough;
ca0760e7d79e2bb Wei Ming Chen 2021-05-06  207   *   continue;
294f69e662d1570 Joe Perches   2019-10-05  208   *   goto <label>;
294f69e662d1570 Joe Perches   2019-10-05  209   *   return [expression];
294f69e662d1570 Joe Perches   2019-10-05  210   *
294f69e662d1570 Joe Perches   2019-10-05  211   *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
294f69e662d1570 Joe Perches   2019-10-05  212   */
294f69e662d1570 Joe Perches   2019-10-05  213  #if __has_attribute(__fallthrough__)
294f69e662d1570 Joe Perches   2019-10-05 @214  # define fallthrough                    __attribute__((__fallthrough__))
294f69e662d1570 Joe Perches   2019-10-05  215  #else
294f69e662d1570 Joe Perches   2019-10-05  216  # define fallthrough                    do {} while (0)  /* fallthrough */
a3f8a30f3f0079c Miguel Ojeda  2018-08-30  217  #endif
a3f8a30f3f0079c Miguel Ojeda  2018-08-30  218  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
