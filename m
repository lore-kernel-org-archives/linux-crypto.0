Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602DCC77B61
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Apr 2023 11:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbjDYLNh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Apr 2023 07:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbjDYLNg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2023 07:13:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7F6A9
        for <linux-crypto@vger.kernel.org>; Tue, 25 Apr 2023 04:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682421214; x=1713957214;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=4hutvCJZaamOKTTrOn/paj9U2Qm/G/q4+mrguAPoyRY=;
  b=m5q593HD28GzspHchFYdPjFYlHzNVXarr3F/jl4+bpo883NEYeRox+DL
   sj+bHFrgtr2jh/Du5DRQsieMobnNSSjPGB/U2tkDTc98UDxeaDP/ieb65
   LQkewjSVCYpz0Mz8jTn77mlX4hmAI2yyuo3BDP3l39OygM7IYJGzJOSnq
   gJIujceFDWnwCqsZhUDM8aR4gh0yLaLoKAYfBFqCww2nS/7kC6XghfIlg
   R56sQ6Nn9UxkjgoHteR/KCieEC6sTYBUs1lwstBtx4oFqQ3TNh/hcixnD
   yIiju9Jm0gTl+4sAaysEfXQ03swREcqr/jJ8B/ZujLuKGpEfVlv0TT5ih
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="344210798"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="344210798"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 04:13:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="805036958"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="805036958"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 25 Apr 2023 04:13:33 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prGbz-000jLQ-1J;
        Tue, 25 Apr 2023 11:13:31 +0000
Date:   Tue, 25 Apr 2023 19:13:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:pending-fixes] BUILD SUCCESS
 0a6daccdbdd65cc86e2c4479211cd7f5915c9cd8
Message-ID: <6447b5d1.S8ddEFO98syfkQ3Q%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git pending-fixes
branch HEAD: 0a6daccdbdd65cc86e2c4479211cd7f5915c9cd8  Merge branch 'for-linux-next-fixes' of git://anongit.freedesktop.org/drm/drm-misc

Unverified Warning (likely false positive, please contact us if interested):

drivers/crypto/intel/qat/qat_common/qat_compression.c:238:24-25: WARNING opportunity for kfree_sensitive/kvfree_sensitive (memset at line 237)
drivers/crypto/intel/qat/qat_common/qat_uclo.c:1989:16-17: WARNING opportunity for min()

Warning ids grouped by kconfigs:

gcc_recent_errors
`-- loongarch-randconfig-c034-20230423
    |-- drivers-crypto-intel-qat-qat_common-qat_compression.c:WARNING-opportunity-for-kfree_sensitive-kvfree_sensitive-(memset-at-line-)
    `-- drivers-crypto-intel-qat-qat_common-qat_uclo.c:WARNING-opportunity-for-min()

elapsed time: 1020m

configs tested: 152
configs skipped: 15

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230423   gcc  
alpha                randconfig-r021-20230423   gcc  
alpha                randconfig-r026-20230423   gcc  
alpha                randconfig-r031-20230423   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r001-20230423   gcc  
arc                                 defconfig   gcc  
arc                     nsimosci_hs_defconfig   gcc  
arc                  randconfig-r002-20230423   gcc  
arc                  randconfig-r036-20230423   gcc  
arc                  randconfig-r043-20230423   gcc  
arc                  randconfig-r043-20230424   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r002-20230424   gcc  
arm                  randconfig-r023-20230423   gcc  
arm                  randconfig-r031-20230424   gcc  
arm                  randconfig-r046-20230423   gcc  
arm                  randconfig-r046-20230424   clang
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r004-20230423   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r036-20230424   clang
csky                                defconfig   gcc  
csky                 randconfig-r001-20230424   gcc  
csky                 randconfig-r003-20230423   gcc  
csky                 randconfig-r006-20230424   gcc  
csky                 randconfig-r022-20230423   gcc  
csky                 randconfig-r025-20230423   gcc  
csky                 randconfig-r026-20230424   gcc  
csky                 randconfig-r034-20230423   gcc  
hexagon      buildonly-randconfig-r006-20230423   clang
hexagon              randconfig-r034-20230424   clang
hexagon              randconfig-r041-20230423   clang
hexagon              randconfig-r041-20230424   clang
hexagon              randconfig-r045-20230423   clang
hexagon              randconfig-r045-20230424   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230424   clang
i386                 randconfig-a002-20230424   clang
i386                 randconfig-a003-20230424   clang
i386                 randconfig-a004-20230424   clang
i386                 randconfig-a005-20230424   clang
i386                 randconfig-a006-20230424   clang
i386                 randconfig-a011-20230424   gcc  
i386                 randconfig-a012-20230424   gcc  
i386                 randconfig-a013-20230424   gcc  
i386                 randconfig-a014-20230424   gcc  
i386                 randconfig-a015-20230424   gcc  
i386                 randconfig-a016-20230424   gcc  
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r003-20230424   gcc  
ia64         buildonly-randconfig-r004-20230423   gcc  
ia64         buildonly-randconfig-r004-20230424   gcc  
ia64         buildonly-randconfig-r005-20230423   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r006-20230423   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r005-20230423   gcc  
loongarch    buildonly-randconfig-r006-20230424   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r003-20230423   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230424   gcc  
m68k                                defconfig   gcc  
m68k                          multi_defconfig   gcc  
m68k                 randconfig-r003-20230424   gcc  
m68k                 randconfig-r006-20230423   gcc  
m68k                 randconfig-r016-20230423   gcc  
m68k                 randconfig-r021-20230424   gcc  
microblaze   buildonly-randconfig-r003-20230423   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r003-20230423   clang
mips         buildonly-randconfig-r004-20230424   gcc  
nios2        buildonly-randconfig-r006-20230423   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r024-20230423   gcc  
nios2                randconfig-r025-20230424   gcc  
nios2                randconfig-r026-20230423   gcc  
nios2                randconfig-r033-20230423   gcc  
openrisc             randconfig-r006-20230424   gcc  
openrisc             randconfig-r015-20230423   gcc  
parisc       buildonly-randconfig-r003-20230424   gcc  
parisc       buildonly-randconfig-r005-20230424   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r003-20230424   gcc  
parisc               randconfig-r021-20230423   gcc  
parisc               randconfig-r032-20230423   gcc  
parisc               randconfig-r032-20230424   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r006-20230424   gcc  
powerpc              randconfig-r013-20230423   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r001-20230424   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230423   clang
riscv                randconfig-r042-20230424   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r002-20230424   clang
s390                 randconfig-r014-20230423   clang
s390                 randconfig-r035-20230423   gcc  
s390                 randconfig-r044-20230423   clang
s390                 randconfig-r044-20230424   gcc  
sh                               allmodconfig   gcc  
sh                          kfr2r09_defconfig   gcc  
sh                   randconfig-r004-20230424   gcc  
sh                   randconfig-r005-20230424   gcc  
sh                   randconfig-r011-20230423   gcc  
sh                   randconfig-r023-20230424   gcc  
sh                   randconfig-r025-20230423   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r001-20230423   gcc  
sparc                randconfig-r035-20230424   gcc  
sparc64              randconfig-r023-20230423   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230424   clang
x86_64               randconfig-a002-20230424   clang
x86_64                        randconfig-a002   gcc  
x86_64               randconfig-a003-20230424   clang
x86_64               randconfig-a004-20230424   clang
x86_64                        randconfig-a004   gcc  
x86_64               randconfig-a005-20230424   clang
x86_64               randconfig-a006-20230424   clang
x86_64                        randconfig-a006   gcc  
x86_64               randconfig-a011-20230424   gcc  
x86_64               randconfig-a012-20230424   gcc  
x86_64               randconfig-a013-20230424   gcc  
x86_64               randconfig-a014-20230424   gcc  
x86_64               randconfig-a015-20230424   gcc  
x86_64               randconfig-a016-20230424   gcc  
x86_64               randconfig-r033-20230424   clang
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r002-20230424   gcc  
xtensa               randconfig-r005-20230423   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
