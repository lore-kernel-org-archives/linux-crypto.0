Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F3FC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jun 2022 00:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiFTAdS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jun 2022 20:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiFTAdR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jun 2022 20:33:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D85C63AB
        for <linux-crypto@vger.kernel.org>; Sun, 19 Jun 2022 17:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655685197; x=1687221197;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=msh46hx1IaYxUU2Xnu2UDI8ureFsATqrZ40wO03bMWI=;
  b=DUsMAzo++4cHmCFPB/eCxyKrEx3qH9HaJzzolgAoLFYQcT2NxOmDWVP+
   hStN+U0Xxw6e0C7gkgk/vuxJQnusDDdtxQbfY/fidLlDyvJlRy6Yfx9NE
   Brz9SEy8lLixbcYImJ1UFTmnrOgk4jU9P+I7dBwolk7UdY1RZFdNDwNlm
   VtqMhlOowLWyQQs/UNBwKT9itMM5QNAkAykTJDd9pENWph6iXzegj7TLu
   vGtdCNt65H3YIQBsasRYM+dbubIlQZDH2JnamXlCfdXwkGytP5NrB3nLg
   VJiiSUEHysL9LajVGcBbvYcR7U4T4Fke3aZsi0Tooi9SyfxcmFQXWBNmL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280831573"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280831573"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2022 17:33:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="689193254"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jun 2022 17:33:15 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o35Lu-000Rgv-GU;
        Mon, 20 Jun 2022 00:33:14 +0000
Date:   Mon, 20 Jun 2022 08:32:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Jason A. Donenfeld" <zx2c4@kernel.org>
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [herbert-cryptodev-2.6:master 18/27]
 lib/crypto/blake2s-selftest.c:632:1: warning: the frame size of 1088 bytes
 is larger than 1024 bytes
Message-ID: <202206200851.gE3MHCgd-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   bffa1fc065893a14703545efba7d69bb4082b18a
commit: 2d16803c562ecc644803d42ba98a8e0aef9c014e [18/27] crypto: blake2s - remove shash module
config: riscv-randconfig-r042-20220619 (https://download.01.org/0day-ci/archive/20220620/202206200851.gE3MHCgd-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=2d16803c562ecc644803d42ba98a8e0aef9c014e
        git remote add herbert-cryptodev-2.6 https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
        git fetch --no-tags herbert-cryptodev-2.6 master
        git checkout 2d16803c562ecc644803d42ba98a8e0aef9c014e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash lib/crypto/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   lib/crypto/blake2s-selftest.c: In function 'blake2s_selftest':
>> lib/crypto/blake2s-selftest.c:632:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
     632 | }
         | ^


vim +632 lib/crypto/blake2s-selftest.c

2d16803c562ecc Jason A. Donenfeld 2022-05-28  614  
2d16803c562ecc Jason A. Donenfeld 2022-05-28  615  		memcpy(&state1, &state, sizeof(state1));
2d16803c562ecc Jason A. Donenfeld 2022-05-28  616  		blake2s_compress(&state1, blocks, 1, BLAKE2S_BLOCK_SIZE);
2d16803c562ecc Jason A. Donenfeld 2022-05-28  617  		for (l = 1; l < TEST_ALIGNMENT; ++l) {
2d16803c562ecc Jason A. Donenfeld 2022-05-28  618  			memcpy(unaligned_block + l, blocks,
2d16803c562ecc Jason A. Donenfeld 2022-05-28  619  			       BLAKE2S_BLOCK_SIZE);
2d16803c562ecc Jason A. Donenfeld 2022-05-28  620  			memcpy(&state2, &state, sizeof(state2));
2d16803c562ecc Jason A. Donenfeld 2022-05-28  621  			blake2s_compress(&state2, unaligned_block + l, 1,
2d16803c562ecc Jason A. Donenfeld 2022-05-28  622  					 BLAKE2S_BLOCK_SIZE);
2d16803c562ecc Jason A. Donenfeld 2022-05-28  623  			if (memcmp(&state1, &state2, sizeof(state1))) {
2d16803c562ecc Jason A. Donenfeld 2022-05-28  624  				pr_err("blake2s random compress align %d self-test %d: FAIL\n",
2d16803c562ecc Jason A. Donenfeld 2022-05-28  625  				       l, i + 1);
2d16803c562ecc Jason A. Donenfeld 2022-05-28  626  				success = false;
2d16803c562ecc Jason A. Donenfeld 2022-05-28  627  			}
2d16803c562ecc Jason A. Donenfeld 2022-05-28  628  		}
2d16803c562ecc Jason A. Donenfeld 2022-05-28  629  	}
2d16803c562ecc Jason A. Donenfeld 2022-05-28  630  
66d7fb94e4ffe5 Jason A. Donenfeld 2019-11-08  631  	return success;
66d7fb94e4ffe5 Jason A. Donenfeld 2019-11-08 @632  }

:::::: The code at line 632 was first introduced by commit
:::::: 66d7fb94e4ffe5acc589e0b2b4710aecc1f07a28 crypto: blake2s - generic C library implementation and selftest

:::::: TO: Jason A. Donenfeld <Jason@zx2c4.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
