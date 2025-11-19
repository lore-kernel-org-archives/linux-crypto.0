Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DDE2EA158;
	Wed, 19 Nov 2025 10:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763548658; cv=none; b=FKxafkVmC4He2zLZUl/lmvry0vjsCKV+WMs9HUzfYNFDt+DVPAtRdx/vY56uCB3kvIdnUBVcsekEab0B8Bl8eoPmSz2L0J/4tz5YTJ/dEuJYx7SuKPFonHgyNI9azfKmxqeIoRL2MVBQ+Wzezl8yLWZ9YMs1op8SvMKZcXoJDIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763548658; c=relaxed/simple;
	bh=uz9BVyfkCdlbHT0ASnX/NSFrExl1oVyHkEaFMaaghGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CN9aM1oGcPpqHUeKqcQuqLp4eImezrqXJ1f9JuR5QDtD0CiuY6pFBq5uAWUHxPm4jp2wEk2CpaiTJFgRza8xmg0E5FJX42LqYGcKHLGFeFr/6lVUcEvSMJLLAkXsuecYpu+5/cDMQDvbVjwGrbJ1xHEV14oineTztvqyOc0hrlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=az+9sbhe; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="az+9sbhe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763548657; x=1795084657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uz9BVyfkCdlbHT0ASnX/NSFrExl1oVyHkEaFMaaghGQ=;
  b=az+9sbheuCY7P2kXtoULRzwe63faSnJTtkYU9Di7GlicWMjej47DsHnB
   S0C0arwrBRFVKyjcrqTqUu4/X2LEWwoCEBzQt7Upp44LQip/LYQwpODWH
   QrfQPZgiuOBV88Jf2XZu9OLirZn5qhMRTJS/p1aBJqYDBoolkGLRLJR4F
   DQ7s7GSDMyb2DzjB+f+4ZrzZg2FVWywIIfM4JL6VV3YNsmJYAQBju1Nhj
   xXF/TIoef0LBNw4PvsvTr6exfeAE/vELGVJvzORfFx6emSyp0D/KJZp/K
   w/TqG4eZ4RGD7EdeeTKBLUz98vBY5HuX0Wa6esrPvZwBwFJALQFp6pTB+
   A==;
X-CSE-ConnectionGUID: cucyoykQSM+M+HoWY1tnQg==
X-CSE-MsgGUID: arlIqTvFTamsR4Jhdwi+eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="64782715"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="64782715"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 02:37:36 -0800
X-CSE-ConnectionGUID: piT3SsmyQ7K9pggikPDWDQ==
X-CSE-MsgGUID: ocqkq51PSPa8wMG2H3m8nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="228366658"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 19 Nov 2025 02:37:33 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vLfZ5-0002m7-0z;
	Wed, 19 Nov 2025 10:37:31 +0000
Date: Wed, 19 Nov 2025 18:36:43 +0800
From: kernel test robot <lkp@intel.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH libcrypto 2/2] crypto: chacha20poly1305: statically check
 fixed array lengths
Message-ID: <202511191846.AAKP7VQw-lkp@intel.com>
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
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20251119/202511191846.AAKP7VQw-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251119/202511191846.AAKP7VQw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511191846.AAKP7VQw-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/wireguard/cookie.c: In function 'wg_cookie_message_create':
>> drivers/net/wireguard/cookie.c:193:9: warning: 'xchacha20poly1305_encrypt' reading 32 bytes from a region of size 31 [-Wstringop-overread]
     193 |         xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     194 |                                   macs->mac1, COOKIE_LEN, dst->nonce,
         |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     195 |                                   checker->cookie_encryption_key);
         |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireguard/cookie.c:193:9: note: referencing argument 7 of type 'const u8[32]' {aka 'const unsigned char[32]'}
   In file included from drivers/net/wireguard/messages.h:10,
                    from drivers/net/wireguard/cookie.h:9,
                    from drivers/net/wireguard/cookie.c:6:
   include/crypto/chacha20poly1305.h:29:6: note: in a call to function 'xchacha20poly1305_encrypt'
      29 | void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/xchacha20poly1305_encrypt +193 drivers/net/wireguard/cookie.c

e7096c131e5161f Jason A. Donenfeld 2019-12-09  179  
e7096c131e5161f Jason A. Donenfeld 2019-12-09  180  void wg_cookie_message_create(struct message_handshake_cookie *dst,
e7096c131e5161f Jason A. Donenfeld 2019-12-09  181  			      struct sk_buff *skb, __le32 index,
e7096c131e5161f Jason A. Donenfeld 2019-12-09  182  			      struct cookie_checker *checker)
e7096c131e5161f Jason A. Donenfeld 2019-12-09  183  {
e7096c131e5161f Jason A. Donenfeld 2019-12-09  184  	struct message_macs *macs = (struct message_macs *)
e7096c131e5161f Jason A. Donenfeld 2019-12-09  185  		((u8 *)skb->data + skb->len - sizeof(*macs));
e7096c131e5161f Jason A. Donenfeld 2019-12-09  186  	u8 cookie[COOKIE_LEN];
e7096c131e5161f Jason A. Donenfeld 2019-12-09  187  
e7096c131e5161f Jason A. Donenfeld 2019-12-09  188  	dst->header.type = cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE);
e7096c131e5161f Jason A. Donenfeld 2019-12-09  189  	dst->receiver_index = index;
e7096c131e5161f Jason A. Donenfeld 2019-12-09  190  	get_random_bytes_wait(dst->nonce, COOKIE_NONCE_LEN);
e7096c131e5161f Jason A. Donenfeld 2019-12-09  191  
e7096c131e5161f Jason A. Donenfeld 2019-12-09  192  	make_cookie(cookie, skb, checker);
e7096c131e5161f Jason A. Donenfeld 2019-12-09 @193  	xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN,
e7096c131e5161f Jason A. Donenfeld 2019-12-09  194  				  macs->mac1, COOKIE_LEN, dst->nonce,
e7096c131e5161f Jason A. Donenfeld 2019-12-09  195  				  checker->cookie_encryption_key);
e7096c131e5161f Jason A. Donenfeld 2019-12-09  196  }
e7096c131e5161f Jason A. Donenfeld 2019-12-09  197  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
