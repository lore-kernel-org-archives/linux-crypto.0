Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC6835B157;
	Wed, 19 Nov 2025 12:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763556356; cv=none; b=LwvYdgJjuwkZyV6/bOdbG/At69BNU3tnhDUg3hhqqjvNN8Ls7Hl0n56u9dQ7YQ9ydk9kQLox/kLB8rQax92ZACcVNynLuuO1/2pMeHOPGT3oK3hFUWXVhrU8jiFjscCwjYf58mpgaVLnc/rAYSshS6lJreiIbE8LvAZwwZs4JC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763556356; c=relaxed/simple;
	bh=HF9GdCIMZF1sjrLdRxndNornshZnJxuUvneqfFK3BPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qj0/r2BJpnOoH+zvIjwejApHgd3BwbGm/J/d9Jpch6vg5CPxrvx/nVrVgrLiOEZoVhXuwtAvW8uaARDo/4tp/yKPq3pJEKK2xpaMfs/4GxuG0WBGWy7zIxtEZso6YQlxTyqCcuEMQtqwZ9MLwSVnCJHL65h+FmmTOBqk5Sddyt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mE9liDhx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mE9liDhx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763556354; x=1795092354;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HF9GdCIMZF1sjrLdRxndNornshZnJxuUvneqfFK3BPw=;
  b=mE9liDhxN/9SCPhYRl170wJYg2trpB357nlTb3khV1TNglOrWI/gu1h/
   axt5824lM0PAMFL2wjnoNPa7/GS2K9iVjHlCTMKYZ+3b46uX6KsuAQfzF
   q6eUgTbUG+Pp8nGGjmcQUSYsn8P1j62A+9a1tgkLgYdyGxScVU9ixIjfy
   EcoPMSAQL4Un9LAq1ygW3loV/oCVO59i1Y+klRIlVM04Zi1rabkQ8ysiW
   nfUJ5KT0VJMPgfhWXkceyUoEhlAHZT3TAkcfjp37O79rv3XBnXNRk60Of
   Apd6GIqalKAah0lOsAhWT/Z64az3Ydv8ictFAjLTh/e6ipLCj+GUWYU+n
   Q==;
X-CSE-ConnectionGUID: PG92Z0P1SBegtJk3lDSnJQ==
X-CSE-MsgGUID: EhgspRb9SYWC90R7o0ytPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="91070275"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="91070275"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 04:45:48 -0800
X-CSE-ConnectionGUID: B0RsA/byT9izExDqLpupDQ==
X-CSE-MsgGUID: fxKk5ZwHQG+ErFr+MlomYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190708391"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 19 Nov 2025 04:45:45 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vLhZ9-0002sn-2G;
	Wed, 19 Nov 2025 12:45:43 +0000
Date: Wed, 19 Nov 2025 20:45:15 +0800
From: kernel test robot <lkp@intel.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH libcrypto 2/2] crypto: chacha20poly1305: statically check
 fixed array lengths
Message-ID: <202511192000.TLYrcg0Z-lkp@intel.com>
References: <20251118170240.689299-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118170240.689299-2-Jason@zx2c4.com>

Hi Jason,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master ebiggers/libcrypto-next ebiggers/libcrypto-fixes linus/master linux/master v6.18-rc6 next-20251119]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-A-Donenfeld/crypto-chacha20poly1305-statically-check-fixed-array-lengths/20251119-011125
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20251118170240.689299-2-Jason%40zx2c4.com
patch subject: [PATCH libcrypto 2/2] crypto: chacha20poly1305: statically check fixed array lengths
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20251119/202511192000.TLYrcg0Z-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251119/202511192000.TLYrcg0Z-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511192000.TLYrcg0Z-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/wireguard/cookie.c:193:2: warning: array argument is too small; contains 31 elements, callee requires at least 32 [-Warray-bounds]
     193 |         xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN,
         |         ^
     194 |                                   macs->mac1, COOKIE_LEN, dst->nonce,
     195 |                                   checker->cookie_encryption_key);
         |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/crypto/chacha20poly1305.h:32:20: note: callee declares array parameter as static here
      32 |                                const u8 key[min_array_size(CHACHA20POLY1305_KEY_SIZE)]);
         |                                         ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireguard/cookie.c:6:
   In file included from drivers/net/wireguard/cookie.h:9:
   In file included from drivers/net/wireguard/messages.h:10:
   In file included from include/crypto/chacha20poly1305.h:11:
   In file included from include/linux/scatterlist.h:5:
   In file included from include/linux/string.h:382:
   include/linux/fortify-string.h:480:4: warning: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
     480 |                         __write_overflow_field(p_size_field, size);
         |                         ^
   2 warnings generated.


vim +193 drivers/net/wireguard/cookie.c

e7096c131e5161 Jason A. Donenfeld 2019-12-09  179  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  180  void wg_cookie_message_create(struct message_handshake_cookie *dst,
e7096c131e5161 Jason A. Donenfeld 2019-12-09  181  			      struct sk_buff *skb, __le32 index,
e7096c131e5161 Jason A. Donenfeld 2019-12-09  182  			      struct cookie_checker *checker)
e7096c131e5161 Jason A. Donenfeld 2019-12-09  183  {
e7096c131e5161 Jason A. Donenfeld 2019-12-09  184  	struct message_macs *macs = (struct message_macs *)
e7096c131e5161 Jason A. Donenfeld 2019-12-09  185  		((u8 *)skb->data + skb->len - sizeof(*macs));
e7096c131e5161 Jason A. Donenfeld 2019-12-09  186  	u8 cookie[COOKIE_LEN];
e7096c131e5161 Jason A. Donenfeld 2019-12-09  187  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  188  	dst->header.type = cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  189  	dst->receiver_index = index;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  190  	get_random_bytes_wait(dst->nonce, COOKIE_NONCE_LEN);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  191  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  192  	make_cookie(cookie, skb, checker);
e7096c131e5161 Jason A. Donenfeld 2019-12-09 @193  	xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN,
e7096c131e5161 Jason A. Donenfeld 2019-12-09  194  				  macs->mac1, COOKIE_LEN, dst->nonce,
e7096c131e5161 Jason A. Donenfeld 2019-12-09  195  				  checker->cookie_encryption_key);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  196  }
e7096c131e5161 Jason A. Donenfeld 2019-12-09  197  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
