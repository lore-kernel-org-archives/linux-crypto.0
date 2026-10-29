Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793263476;
	b=DMSR0ar6Ba/Gyn5kDjFFKfMS3vvmMcr1Xw9mLEqtAuhAGTg4gEwS7IXpOiJqvR5/KHzQ
	 p39uq4xwT3J00sJlRZ9EGrE6hMmB10Q/HF2wOEjWVgL3hXxCWF81D64sBfyNrmaceNkK4
	 v9c8Kz/lAlW9XhQ/SHPgrmBUlGUgHY14VXQqi76Riw+eC/E9n0q+81aHfusrTN/xG3fdY
	 TEfHjoayxYiYvcviQnzqg80ijlaPY/TMiuw/kHZoq2PPeDhNvdV0Q7WrkEhfhc4X8cJlp
	 Kc6n7mJEN5t+Nk0bzGT55BByYUkQ4H18OLLj5nF4BE2/0UqvL/UFHFVCfgEuum2vW+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793263476;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/oWraMZQPV6fMMEjMwIgrElFPlULY+ClRBpUMakebME=;
	b=02GvyR4uN4qTKIkJ0NiO9PdF+s1mfZf12vj0Xx8YlRokuvWcBoKDjFgyodhFkOa+FvC3
	 PWsmfbgwBPhZGSPuYKdpMaigvgfHgQjNTjJhJpJVbia+5Wy4u5IsCl+BiPtRQGv5+FiUM
	 Y9r2syk3eAiKlYCyi91vJeNxyOLqkc5XWVr/AQzuHBrboPEZW5XTnOjN3vbQxAbm32J0E
	 +EUlMi82Q2Kj0YNRjwPP1IVOt/qu2CmDi6YQgbNOkVyr0uQq8kVhsD4/e5BJx/D8Bmwwu
	 SJJu8vBFJU/i89H/QQrmPUwE1S+XqVl4HGhdbzk2/T2CUP7SZPURoSxpL9K7rvY08+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="N/YldqI7";
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFA0606A31C;
	Thu, 29 Oct 2026 08:44:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FFA0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=N/YldqI7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793263475; x=1824799475;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zP6j9o6F/w03axY+MsD6UxM7gNTFpqrQ1pytm/sRx+k=;
  b=N/YldqI7ne2V98PNHu6FXMXomdG9cX9o9cei0knZRPnhzS9ANauYcKxs
   g9Lbc8aXnAGnJGji+3hS5sP5IHfxrVQ7/0eLI9slrjmBxPpIOlfpiWFL4
   6Tc0DQkrvNBO6ukCp1UvDbEr3DLOYddyqZXT5n61Cwuju1t2nvdwghm5n
   geUrS+vsgGxR9JDSsZK+8nnNwW1HLEZINriC7usDVTt20B+m7a12Rh7ks
   bIvlAX7QY8EfVhCmvzt266Z5UstxKvqtmqLd4QQL+bvRa9e/aiw298m3T
   QMChIara4DR2ODRVRQYnHQjxo1yeW4BblGG11tDLXnYoLP7DzAOv3qsf5
   w==;
X-CSE-ConnectionGUID: F9urCpzVSbeJAwhG/kfrYw==
X-CSE-MsgGUID: kF81pAjhTz6Y7LirktJ+PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1883081"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="1883081"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 01:44:34 -0700
X-CSE-ConnectionGUID: 4rCsOan0TAGSv25eri71LQ==
X-CSE-MsgGUID: rzUW03PeSzOCgCTooWn4jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="4986244"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 29 Oct 2026 01:44:31 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMLkK-00000000Zqq-0ZYA;
	Thu, 29 Oct 2026 08:44:28 +0000
Date: Thu, 29 Oct 2026 16:43:48 +0800
From: kernel test robot <lkp@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <202610291634.MckYHsJq-lkp@intel.com>
References: <20261025001105.1824178-6-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025001105.1824178-6-jarkko@kernel.org>

Hi Jarkko,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[cannot apply to akpm-mm/mm-nonmm-unstable manguebit/cifs-next manguebit/cifs-fixes device-mapper-dm/for-next fsverity/for-next fsverity/for-current shuah-kselftest/next shuah-kselftest/fixes dhowells-fs/fscache-next dhowells-fs/keys-next v7.3 next-20261028]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/KEYS-Expand-key-datalen-quotalen-to-unsigned-int/20261025-031009
base:   linus/master
patch link:    https://lore.kernel.org/r/20261025001105.1824178-6-jarkko%40kernel.org
patch subject: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261029/202610291634.MckYHsJq-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610291634.MckYHsJq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610291634.MckYHsJq-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   kernel/bpf/keys.c: In function 'bpf_lookup_keyring':
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:635:53: note: in definition of macro '__unqual_scalar_typeof'
     635 | #define __unqual_scalar_typeof(x) __typeof_unqual__(x)
         |                                                     ^
   include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |         ^~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
   In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:391,
                    from include/uapi/linux/filter.h:9,
                    from include/linux/bpf.h:8,
                    from kernel/bpf/keys.c:4:
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/asm-generic/rwonce.h:44:73: note: in definition of macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                         ^
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~


vim +32 kernel/bpf/keys.c

abaa0835b4f3810 Daniel Borkmann 2026-08-28  25  
264d8fd2794fabe Daniel Borkmann 2026-08-28  26  struct bpf_key *bpf_lookup_keyring(void)
264d8fd2794fabe Daniel Borkmann 2026-08-28  27  {
264d8fd2794fabe Daniel Borkmann 2026-08-28  28  	struct bpf_key *bkey;
264d8fd2794fabe Daniel Borkmann 2026-08-28  29  
264d8fd2794fabe Daniel Borkmann 2026-08-28  30  	if (!bpf_keyring)
264d8fd2794fabe Daniel Borkmann 2026-08-28  31  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28 @32  	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
264d8fd2794fabe Daniel Borkmann 2026-08-28  33  	    !READ_ONCE(bpf_keyring->restrict_link))
264d8fd2794fabe Daniel Borkmann 2026-08-28  34  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28  35  
264d8fd2794fabe Daniel Borkmann 2026-08-28  36  	bkey = kmalloc_obj(*bkey);
264d8fd2794fabe Daniel Borkmann 2026-08-28  37  	if (!bkey)
264d8fd2794fabe Daniel Borkmann 2026-08-28  38  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28  39  
264d8fd2794fabe Daniel Borkmann 2026-08-28  40  	bkey->key = bpf_keyring;
264d8fd2794fabe Daniel Borkmann 2026-08-28  41  	bkey->has_ref = false;
264d8fd2794fabe Daniel Borkmann 2026-08-28  42  	return bkey;
264d8fd2794fabe Daniel Borkmann 2026-08-28  43  }
264d8fd2794fabe Daniel Borkmann 2026-08-28  44  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
