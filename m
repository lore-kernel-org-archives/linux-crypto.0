From: kbuild test robot <lkp@intel.com>
Subject: Re: [Part2 PATCH v4 07/29] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Sat, 23 Sep 2017 05:35:58 +0800
Message-ID: <201709230544.TcZ8OD1t%fengguang.wu@intel.com>
References: <20170919204627.3875-8-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21915 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752134AbdIVVgX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 17:36:23 -0400
Content-Disposition: inline
In-Reply-To: <20170919204627.3875-8-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Brijesh,

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on v4.14-rc1 next-20170922]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Brijesh-Singh/x86-Secure-Encrypted-Virtualization-AMD/20170923-033600
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/crypto/ccp/psp-dev.c:311:5-11: ERROR: allocation function on line 310 returns NULL not ERR_PTR on failure

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
