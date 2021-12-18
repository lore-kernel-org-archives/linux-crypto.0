Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA15C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Dec 2021 13:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhLRNer (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Dec 2021 08:34:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:36519 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhLRNer (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Dec 2021 08:34:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639834487; x=1671370487;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=FIliIVPEglEa4my8yizWBOgsqX0iYfI5+w5XMlsqaGE=;
  b=Bxf1gBHkeAM2SHlJq1CdL/4ToF82GkCajgz7zUmakHYc84mdwXA6RY1s
   k/Ia+IWorkKArQKrRBN8IcQ0lKJt4yMSDx+bDj7A5xdO/T61uvhk5KL3w
   RfmRD6rwTwlXSDH9PaZ5nEKtyN5TQI0W5qoX1+3eGDaZo1JzdFfQ/qsYp
   FZYxsXv5T5fMDk1+yvZ4L5wAF9UDdslJKWb4lD0FPRUiDXhDH/hIc3+7D
   fjeiUmQqBPquFuJnNA5KhhXeEolxg1VN2wXA3n4I5wqvCMXbtcXzpz+f6
   5x3mxIig9OA9oqjGGPQFOphAYnUj+ST9ADdM7SzDsakDZhSrMzadRogXn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="326216654"
X-IronPort-AV: E=Sophos;i="5.88,216,1635231600"; 
   d="scan'208";a="326216654"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2021 05:34:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,216,1635231600"; 
   d="scan'208";a="683713326"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 18 Dec 2021 05:34:44 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1myZrI-00062B-4n; Sat, 18 Dec 2021 13:34:44 +0000
Date:   Sat, 18 Dec 2021 21:33:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Rientjes <rientjes@google.com>
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>
Subject: [herbert-cryptodev-2.6:master 83/95]
 drivers/crypto/ccp/sev-dev.c:263:2-3: Unneeded semicolon
Message-ID: <202112182124.feBfXHg8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   696645d25bafd6ba3562611c29bc8ecd47066dfe
commit: 3d725965f836a7acbd1674e33644bec18373de53 [83/95] crypto: ccp - Add SEV_INIT_EX support
config: x86_64-randconfig-c002-20211216 (https://download.01.org/0day-ci/archive/20211218/202112182124.feBfXHg8-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cocci warnings: (new ones prefixed by >>)
>> drivers/crypto/ccp/sev-dev.c:263:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
