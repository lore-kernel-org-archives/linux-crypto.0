Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6897018A93C
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 10:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739703120; cv=none; b=ShXxToVauHT3UGSG6Ao9Lj3c+vl9KQRpiUr6Iq+CwaK19sMPLsfJ1SP//z+HR3MzEUaYA5RL3DPXsPUtwkPFP3RfS1WL9DWQ7rlzTabeKMxT9vbvKiNXH+uLvY+5cG07P92ZKWvu+yRHKTPGGT3uZCW7ZmMtfYSRsDHwo8pydtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739703120; c=relaxed/simple;
	bh=gTrHxzvLYEoDSEoxQObl+E1wepxLTdhe1lAqpGwcQro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sw7mtcmxd8hLE2mwmKRienY43+N/ox4b3/jyteuZynh+3oayaZ8P+U7Q0b087qBXhs39du/1eol10teXYryxd1f+49b0ugLHxB+2CNkP/xQx2AqFH38i4eZdh7XBUe13n2TGPZN1A/uOuGLtCT/d6MXR7K0xcnSmGXCAuoKT8o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M4RfHC6r; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4RfHC6r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739703119; x=1771239119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gTrHxzvLYEoDSEoxQObl+E1wepxLTdhe1lAqpGwcQro=;
  b=M4RfHC6rKJpTM++B2ZnpkMtO0XMbL9NopS6lbNV1w9mzFvrDSNfdPp8/
   WMnTX1jcwGPFfEm5Y7/8rhm/PU2jRw26ahbFcvrCJPW6+IiIkUjaz/syb
   uF3fk8pnRGgioBGxtmlRbWgQjgUebCMfauTb5ZBnJXuAodp0QKIX0AFIA
   GnyOwl5farCCniUf91yhsYUn0Ym6PWFZuRR7BhvFyKni1yoYjHNiXptp4
   FQRsgWUa6a9PnhQThx5aXOBl3vp3NPKdghQqhuaw5AAQu+j+cJQmVnOwg
   P6Znjf0/ojPTtZp3WIWnuSqm5A/nvJsd/HkqOMGokDNSmIUdqv1WPzhBO
   A==;
X-CSE-ConnectionGUID: E3y8mKYtQkiyKlUeWpNs2g==
X-CSE-MsgGUID: lR6mVROmRkaoSQF+kTvDOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11346"; a="51382238"
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="51382238"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2025 02:51:58 -0800
X-CSE-ConnectionGUID: mVO5dN2AR5+5M9SrY2oyyA==
X-CSE-MsgGUID: aaLi8zGNS1WR+WJOq7I5Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="114062726"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 16 Feb 2025 02:51:55 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tjcFd-001BqX-1J;
	Sun, 16 Feb 2025 10:51:53 +0000
Date: Sun, 16 Feb 2025 18:51:13 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 09/11] crypto: hash - Add sync hash interface
Message-ID: <202502161850.W7NEHTk3-lkp@intel.com>
References: <d6e10dbf172f0b7c791f5406d55e8f1c74492d57.1739674648.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e10dbf172f0b7c791f5406d55e8f1c74492d57.1739674648.git.herbert@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250214]
[cannot apply to herbert-crypto-2.6/master brauner-vfs/vfs.all linus/master v6.14-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-ahash-Only-save-callback-and-data-in-ahash_save_req/20250216-150941
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/d6e10dbf172f0b7c791f5406d55e8f1c74492d57.1739674648.git.herbert%40gondor.apana.org.au
patch subject: [v2 PATCH 09/11] crypto: hash - Add sync hash interface
config: um-randconfig-002-20250216 (https://download.01.org/0day-ci/archive/20250216/202502161850.W7NEHTk3-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250216/202502161850.W7NEHTk3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502161850.W7NEHTk3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/crypto/internal/hash.h:12,
                    from crypto/hash.h:10,
                    from crypto/ahash.c:26:
   In function 'ahash_request_set_callback',
       inlined from 'crypto_sync_hash_digest' at crypto/ahash.c:1153:2:
>> include/crypto/hash.h:690:18: warning: '*(struct ahash_request *)(&__req_req[0]).base.flags' is used uninitialized [-Wuninitialized]
     690 |         req->base.flags &= keep;
         |         ~~~~~~~~~^~~~~~
   crypto/ahash.c: In function 'crypto_sync_hash_digest':
   include/crypto/hash.h:183:14: note: '__req_req' declared here
     183 |         char __##name##_req[sizeof(struct ahash_request) + \
         |              ^~
   crypto/ahash.c:1150:9: note: in expansion of macro 'SYNC_HASH_REQUEST_ON_STACK'
    1150 |         SYNC_HASH_REQUEST_ON_STACK(req, tfm);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +690 include/crypto/hash.h

18e33e6d5cc049 Herbert Xu      2008-07-10  654  
90240ffb127729 Stephan Mueller 2014-11-12  655  /**
90240ffb127729 Stephan Mueller 2014-11-12  656   * ahash_request_set_callback() - set asynchronous callback function
90240ffb127729 Stephan Mueller 2014-11-12  657   * @req: request handle
90240ffb127729 Stephan Mueller 2014-11-12  658   * @flags: specify zero or an ORing of the flags
90240ffb127729 Stephan Mueller 2014-11-12  659   *	   CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
90240ffb127729 Stephan Mueller 2014-11-12  660   *	   increase the wait queue beyond the initial maximum size;
90240ffb127729 Stephan Mueller 2014-11-12  661   *	   CRYPTO_TFM_REQ_MAY_SLEEP the request processing may sleep
90240ffb127729 Stephan Mueller 2014-11-12  662   * @compl: callback function pointer to be registered with the request handle
90240ffb127729 Stephan Mueller 2014-11-12  663   * @data: The data pointer refers to memory that is not used by the kernel
90240ffb127729 Stephan Mueller 2014-11-12  664   *	  crypto API, but provided to the callback function for it to use. Here,
90240ffb127729 Stephan Mueller 2014-11-12  665   *	  the caller can provide a reference to memory the callback function can
90240ffb127729 Stephan Mueller 2014-11-12  666   *	  operate on. As the callback function is invoked asynchronously to the
90240ffb127729 Stephan Mueller 2014-11-12  667   *	  related functionality, it may need to access data structures of the
90240ffb127729 Stephan Mueller 2014-11-12  668   *	  related functionality which can be referenced using this pointer. The
90240ffb127729 Stephan Mueller 2014-11-12  669   *	  callback function can access the memory via the "data" field in the
90240ffb127729 Stephan Mueller 2014-11-12  670   *	  &crypto_async_request data structure provided to the callback function.
90240ffb127729 Stephan Mueller 2014-11-12  671   *
90240ffb127729 Stephan Mueller 2014-11-12  672   * This function allows setting the callback function that is triggered once
90240ffb127729 Stephan Mueller 2014-11-12  673   * the cipher operation completes.
90240ffb127729 Stephan Mueller 2014-11-12  674   *
90240ffb127729 Stephan Mueller 2014-11-12  675   * The callback function is registered with the &ahash_request handle and
0184cfe72d2f13 Stephan Mueller 2016-10-21  676   * must comply with the following template::
90240ffb127729 Stephan Mueller 2014-11-12  677   *
90240ffb127729 Stephan Mueller 2014-11-12  678   *	void callback_function(struct crypto_async_request *req, int error)
90240ffb127729 Stephan Mueller 2014-11-12  679   */
18e33e6d5cc049 Herbert Xu      2008-07-10  680  static inline void ahash_request_set_callback(struct ahash_request *req,
18e33e6d5cc049 Herbert Xu      2008-07-10  681  					      u32 flags,
3e3dc25fe7d5e3 Mark Rustad     2014-07-25  682  					      crypto_completion_t compl,
18e33e6d5cc049 Herbert Xu      2008-07-10  683  					      void *data)
18e33e6d5cc049 Herbert Xu      2008-07-10  684  {
07b1948dc8bac5 Herbert Xu      2025-02-16  685  	u32 keep = CRYPTO_AHASH_REQ_VIRT;
07b1948dc8bac5 Herbert Xu      2025-02-16  686  
3e3dc25fe7d5e3 Mark Rustad     2014-07-25  687  	req->base.complete = compl;
18e33e6d5cc049 Herbert Xu      2008-07-10  688  	req->base.data = data;
07b1948dc8bac5 Herbert Xu      2025-02-16  689  	flags &= ~keep;
07b1948dc8bac5 Herbert Xu      2025-02-16 @690  	req->base.flags &= keep;
07b1948dc8bac5 Herbert Xu      2025-02-16  691  	req->base.flags |= flags;
c0cd3e787da854 Herbert Xu      2025-02-16  692  	crypto_reqchain_init(&req->base);
18e33e6d5cc049 Herbert Xu      2008-07-10  693  }
18e33e6d5cc049 Herbert Xu      2008-07-10  694  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
