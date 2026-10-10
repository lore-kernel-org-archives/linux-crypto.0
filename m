Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB87D28E0
	for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 00:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791591163; cv=none; b=sL3bMd+ViFIReqcVvGliNewj3NDpct4qXZM9Cua0+csYDaKmqmpfeZQrZBajNil4XSfVdQt10VW+DwoH8R1qKmbBC3X6vWVYNfaaZ+heRDxFFCXT3KaA6o/MRs9CkarVM2wz/ZQva1dRRQgw9mT6kWw9eOaOocBNGUqIsLOGeFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791591163; c=relaxed/simple;
	bh=NwughXIGc5rNopnJPSFCZrcXCw3jKA7Pad2iFAPvhQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BtBsy8FJemu1Qlof+fwEjJdx6BDSveUDomvv0E8XGjeLFcuQQWS4SxF8rjXwxll9fNNeaUZxZh5VSzlAGvojOndn8otZQ+QakhYt0JmP3Y+nLNY9BztlMThVLpRfnaLlqrmzNgpowsdFJnBFJ/vnDO5GQV4g4ePxPlb7arz5h+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jBgWjcRK; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jBgWjcRK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791591160; x=1823127160;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NwughXIGc5rNopnJPSFCZrcXCw3jKA7Pad2iFAPvhQQ=;
  b=jBgWjcRKRUYBxqeYli3kYvJBQWrqy0nBNquDRb2Xx5Fo+Q37D3u9qHrZ
   umYY67RNgBdHXyAYO6Tk7+BEy0JRm5t5iCKg5suFiGKradFlZiptjSBCO
   kJqnbZ+Z603dVrDZMaV+zKa/W5nu+YSGd1tZ6Bl8erQkrHKx3pE9WyvpI
   JOYKQ92oVAbraqzImGfpXcXpvPNFlyUwOQZ+1BjHQBDrnilawtdEP2OAu
   reppxOyk50VYtG/qOqeFI/TdcR0ghdhcVgDzBh+Epv+noGQhQat0y5KY0
   4i5XmYmsJhOFysh573m5PSMQ76x4qRITMbrc6QR0y7dhvZkPaEqHOdqyb
   A==;
X-CSE-ConnectionGUID: KIeULoPUTraf5tKbbAotWw==
X-CSE-MsgGUID: PsfWhKwSTSSH6DTh2t1e5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="491780"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="491780"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 17:12:39 -0700
X-CSE-ConnectionGUID: DoQ8kq1ETraqSefpfvdICg==
X-CSE-MsgGUID: +IgnTl2wQ/6YKleG4KfxwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="558178"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Oct 2026 17:12:38 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFKhX-000000006KG-2gou;
	Sat, 10 Oct 2026 00:12:35 +0000
Date: Sat, 10 Oct 2026 08:11:57 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] crypto: aes - Add import_core/export_core to
 cmac/xcbc/cbcmac
Message-ID: <202610100824.r4C5Hjk0-lkp@intel.com>
References: <asjT87HAZ_UUbbvm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asjT87HAZ_UUbbvm@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v7.3-rc6 next-20261008]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-aes-Add-import_core-export_core-to-cmac-xcbc-cbcmac/20261009-224555
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/asjT87HAZ_UUbbvm%40gondor.apana.org.au
patch subject: [PATCH] crypto: aes - Add import_core/export_core to cmac/xcbc/cbcmac
config: sparc-defconfig (https://download.01.org/0day-ci/archive/20261010/202610100824.r4C5Hjk0-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261010/202610100824.r4C5Hjk0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610100824.r4C5Hjk0-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> crypto/aes.c:234:12: warning: 'crypto_cbcmac_import' defined but not used [-Wunused-function]
     234 | static int crypto_cbcmac_import(struct shash_desc *desc, const void *in)
         |            ^~~~~~~~~~~~~~~~~~~~
>> crypto/aes.c:223:12: warning: 'crypto_cbcmac_export' defined but not used [-Wunused-function]
     223 | static int crypto_cbcmac_export(struct shash_desc *desc, void *out)
         |            ^~~~~~~~~~~~~~~~~~~~


vim +/crypto_cbcmac_import +234 crypto/aes.c

   222	
 > 223	static int crypto_cbcmac_export(struct shash_desc *desc, void *out)
   224	{
   225		struct aes_cbcmac_ctx *ctx = AES_CBCMAC_CTX(desc);
   226		unsigned int partial = ctx->partial_len;
   227		u8 *p = out;
   228	
   229		memset(p + AES_BLOCK_SIZE, 0, AES_BLOCK_SIZE);
   230		p[AES_BLOCK_SIZE * 2] = partial;
   231		return crypto_cbcmac_export_core(desc, p);
   232	}
   233	
 > 234	static int crypto_cbcmac_import(struct shash_desc *desc, const void *in)
   235	{
   236		struct aes_cbcmac_ctx *ctx = AES_CBCMAC_CTX(desc);
   237		unsigned int partial;
   238		const u8 *p = in;
   239	
   240		crypto_cbcmac_import_core(desc, p);
   241		p += AES_BLOCK_SIZE;
   242		partial = p[AES_BLOCK_SIZE];
   243		if (partial > AES_BLOCK_SIZE)
   244			return -EOVERFLOW;
   245		crypto_xor(ctx->h, p, partial);
   246		ctx->partial_len = partial;
   247		return 0;
   248	}
   249	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
