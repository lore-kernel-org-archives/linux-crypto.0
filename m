Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C20C4CECD
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 21:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65A8C2074F
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 21:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgD0VtX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 17:49:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:7184 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgD0VtX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 17:49:23 -0400
IronPort-SDR: L1Fsd08YbbPqlvXiDVEF915WeQ7T6XmabXlMRfus547Krlw9RePqvKrndbKDby//4T6n/XDUGB
 aVFXOLojpEMA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 14:48:52 -0700
IronPort-SDR: PZmJOOsoXLXJ/OuPEAXzoT+Rf3laqhaP33UVxMD4G0hAdD/vm7RMOG4WCpetx+1PgxcDko8qzg
 u03ThpeV1IkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="404460048"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 Apr 2020 14:48:47 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jTBcN-00069u-92; Tue, 28 Apr 2020 05:48:47 +0800
Date:   Tue, 28 Apr 2020 05:48:27 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hadar Gat <hadar.gat@arm.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Subject: Re: [PATCH 1/3] hwrng: cctrng - Add dependency on OF
Message-ID: <202004280504.VpbWxVeI%lkp@intel.com>
References: <1587966099-28139-2-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1587966099-28139-2-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hadar,

I love your patch! Yet something to improve:

[auto build test ERROR on cryptodev/master]
[also build test ERROR on next-20200424]
[cannot apply to char-misc/char-misc-testing arm-soc/for-next v5.7-rc3]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Hadar-Gat/hwrng-cctrng-kconfig-updates/20200428-051649
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: um-x86_64_defconfig
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce:
        make ARCH=um SUBARCH=x86_64 defconfig
        make ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/char/hw_random/Kconfig:479:warning: ignoring unsupported character '&'
>> drivers/char/hw_random/Kconfig:480: syntax error
>> drivers/char/hw_random/Kconfig:479: invalid statement
   drivers/char/hw_random/Kconfig:480: invalid statement
   drivers/char/hw_random/Kconfig:481: invalid statement
>> drivers/char/hw_random/Kconfig:482: unknown statement "This"
   drivers/char/hw_random/Kconfig:483:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:483: unknown statement "Generator"
   drivers/char/hw_random/Kconfig:485:warning: ignoring unsupported character ','
   drivers/char/hw_random/Kconfig:485:warning: ignoring unsupported character ':'
>> drivers/char/hw_random/Kconfig:485: unknown statement "To"
   drivers/char/hw_random/Kconfig:486:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:486: unknown statement "will"
   drivers/char/hw_random/Kconfig:488:warning: ignoring unsupported character ','
   drivers/char/hw_random/Kconfig:488:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:488: unknown statement "If"
   make[2]: *** [scripts/kconfig/Makefile:81: defconfig] Error 1
   make[1]: *** [Makefile:588: defconfig] Error 2
   make: *** [Makefile:180: sub-make] Error 2
--
   drivers/char/hw_random/Kconfig:479:warning: ignoring unsupported character '&'
>> drivers/char/hw_random/Kconfig:480: syntax error
>> drivers/char/hw_random/Kconfig:479: invalid statement
   drivers/char/hw_random/Kconfig:480: invalid statement
   drivers/char/hw_random/Kconfig:481: invalid statement
>> drivers/char/hw_random/Kconfig:482: unknown statement "This"
   drivers/char/hw_random/Kconfig:483:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:483: unknown statement "Generator"
   drivers/char/hw_random/Kconfig:485:warning: ignoring unsupported character ','
   drivers/char/hw_random/Kconfig:485:warning: ignoring unsupported character ':'
>> drivers/char/hw_random/Kconfig:485: unknown statement "To"
   drivers/char/hw_random/Kconfig:486:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:486: unknown statement "will"
   drivers/char/hw_random/Kconfig:488:warning: ignoring unsupported character ','
   drivers/char/hw_random/Kconfig:488:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:488: unknown statement "If"
   make[2]: *** [scripts/kconfig/Makefile:71: oldconfig] Error 1
   make[1]: *** [Makefile:588: oldconfig] Error 2
   make: *** [Makefile:180: sub-make] Error 2
--
   drivers/char/hw_random/Kconfig:479:warning: ignoring unsupported character '&'
>> drivers/char/hw_random/Kconfig:480: syntax error
>> drivers/char/hw_random/Kconfig:479: invalid statement
   drivers/char/hw_random/Kconfig:480: invalid statement
   drivers/char/hw_random/Kconfig:481: invalid statement
>> drivers/char/hw_random/Kconfig:482: unknown statement "This"
   drivers/char/hw_random/Kconfig:483:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:483: unknown statement "Generator"
   drivers/char/hw_random/Kconfig:485:warning: ignoring unsupported character ','
   drivers/char/hw_random/Kconfig:485:warning: ignoring unsupported character ':'
>> drivers/char/hw_random/Kconfig:485: unknown statement "To"
   drivers/char/hw_random/Kconfig:486:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:486: unknown statement "will"
   drivers/char/hw_random/Kconfig:488:warning: ignoring unsupported character ','
   drivers/char/hw_random/Kconfig:488:warning: ignoring unsupported character '.'
>> drivers/char/hw_random/Kconfig:488: unknown statement "If"
   make[2]: *** [scripts/kconfig/Makefile:71: olddefconfig] Error 1
   make[1]: *** [Makefile:588: olddefconfig] Error 2
   make: *** [Makefile:180: sub-make] Error 2

vim +480 drivers/char/hw_random/Kconfig

0200161834534f Jean Delvare           2014-04-08   23  
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   24  config HW_RANDOM_TIMERIOMEM
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   25  	tristate "Timer IOMEM HW Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08   26  	depends on HAS_IOMEM
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   27  	---help---
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   28  	  This driver provides kernel-side support for a generic Random
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   29  	  Number Generator used by reading a 'dumb' iomem address that
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   30  	  is to be read no faster than, for example, once a second;
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   31  	  the default FPGA bitstream on the TS-7800 has such functionality.
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   32  
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   33  	  To compile this driver as a module, choose M here: the
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   34  	  module will be called timeriomem-rng.
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   35  
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   36  	  If unsure, say Y.
9c3c133b1ed6e6 Alexander Clouter      2009-02-22   37  
ca644bd5039566 Michael Buesch         2006-06-26   38  config HW_RANDOM_INTEL
ca644bd5039566 Michael Buesch         2006-06-26   39  	tristate "Intel HW Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08   40  	depends on (X86 || IA64) && PCI
fed806f4072bad Jan Beulich            2006-12-06   41  	default HW_RANDOM
ca644bd5039566 Michael Buesch         2006-06-26   42  	---help---
ca644bd5039566 Michael Buesch         2006-06-26   43  	  This driver provides kernel-side support for the Random Number
ca644bd5039566 Michael Buesch         2006-06-26   44  	  Generator hardware found on Intel i8xx-based motherboards.
ca644bd5039566 Michael Buesch         2006-06-26   45  
ca644bd5039566 Michael Buesch         2006-06-26   46  	  To compile this driver as a module, choose M here: the
ca644bd5039566 Michael Buesch         2006-06-26   47  	  module will be called intel-rng.
ca644bd5039566 Michael Buesch         2006-06-26   48  
ca644bd5039566 Michael Buesch         2006-06-26   49  	  If unsure, say Y.
96d63c0297ccfd Michael Buesch         2006-06-26   50  
96d63c0297ccfd Michael Buesch         2006-06-26   51  config HW_RANDOM_AMD
96d63c0297ccfd Michael Buesch         2006-06-26   52  	tristate "AMD HW Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08   53  	depends on (X86 || PPC_MAPLE) && PCI
fed806f4072bad Jan Beulich            2006-12-06   54  	default HW_RANDOM
96d63c0297ccfd Michael Buesch         2006-06-26   55  	---help---
96d63c0297ccfd Michael Buesch         2006-06-26   56  	  This driver provides kernel-side support for the Random Number
96d63c0297ccfd Michael Buesch         2006-06-26   57  	  Generator hardware found on AMD 76x-based motherboards.
96d63c0297ccfd Michael Buesch         2006-06-26   58  
96d63c0297ccfd Michael Buesch         2006-06-26   59  	  To compile this driver as a module, choose M here: the
96d63c0297ccfd Michael Buesch         2006-06-26   60  	  module will be called amd-rng.
96d63c0297ccfd Michael Buesch         2006-06-26   61  
96d63c0297ccfd Michael Buesch         2006-06-26   62  	  If unsure, say Y.
ef5d862734b842 Michael Buesch         2006-06-26   63  
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   64  config HW_RANDOM_ATMEL
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   65  	tristate "Atmel Random Number Generator support"
4951db7edc9460 Boris Brezillon        2014-11-20   66  	depends on ARCH_AT91 && HAVE_CLK && OF
2d9cab5194c89a Jean Delvare           2014-04-08   67  	default HW_RANDOM
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   68  	---help---
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   69  	  This driver provides kernel-side support for the Random Number
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   70  	  Generator hardware found on Atmel AT91 devices.
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   71  
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   72  	  To compile this driver as a module, choose M here: the
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   73  	  module will be called atmel-rng.
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   74  
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   75  	  If unsure, say Y.
677d3e2f07d1b3 Peter Korsgaard        2011-10-06   76  
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   77  config HW_RANDOM_BCM2835
8705f24f7b575f Florian Fainelli       2017-11-07   78  	tristate "Broadcom BCM2835/BCM63xx Random Number Generator support"
8705f24f7b575f Florian Fainelli       2017-11-07   79  	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
8705f24f7b575f Florian Fainelli       2017-11-07   80  		   ARCH_BCM_63XX || BCM63XX || BMIPS_GENERIC
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   81  	default HW_RANDOM
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   82  	---help---
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   83  	  This driver provides kernel-side support for the Random Number
8705f24f7b575f Florian Fainelli       2017-11-07   84  	  Generator hardware found on the Broadcom BCM2835 and BCM63xx SoCs.
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   85  
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   86  	  To compile this driver as a module, choose M here: the
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   87  	  module will be called bcm2835-rng
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   88  
8c4196a2fd7c31 Lubomir Rintel         2013-03-28   89  	  If unsure, say Y.
553072b27e0990 Florian Fainelli       2012-07-24   90  
c83d45d5685f63 Scott Branden          2015-03-04   91  config HW_RANDOM_IPROC_RNG200
c3577f6100ca43 Florian Fainelli       2017-11-01   92  	tristate "Broadcom iProc/STB RNG200 support"
0f95b09a5f6249 Stefan Wahren          2019-11-19   93  	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BRCMSTB
c83d45d5685f63 Scott Branden          2015-03-04   94  	default HW_RANDOM
c83d45d5685f63 Scott Branden          2015-03-04   95  	---help---
c83d45d5685f63 Scott Branden          2015-03-04   96  	  This driver provides kernel-side support for the RNG200
c3577f6100ca43 Florian Fainelli       2017-11-01   97  	  hardware found on the Broadcom iProc and STB SoCs.
c83d45d5685f63 Scott Branden          2015-03-04   98  
c83d45d5685f63 Scott Branden          2015-03-04   99  	  To compile this driver as a module, choose M here: the
c83d45d5685f63 Scott Branden          2015-03-04  100  	  module will be called iproc-rng200
c83d45d5685f63 Scott Branden          2015-03-04  101  
c83d45d5685f63 Scott Branden          2015-03-04  102  	  If unsure, say Y.
c83d45d5685f63 Scott Branden          2015-03-04  103  
ef5d862734b842 Michael Buesch         2006-06-26  104  config HW_RANDOM_GEODE
ef5d862734b842 Michael Buesch         2006-06-26  105  	tristate "AMD Geode HW Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  106  	depends on X86_32 && PCI
fed806f4072bad Jan Beulich            2006-12-06  107  	default HW_RANDOM
ef5d862734b842 Michael Buesch         2006-06-26  108  	---help---
ef5d862734b842 Michael Buesch         2006-06-26  109  	  This driver provides kernel-side support for the Random Number
ef5d862734b842 Michael Buesch         2006-06-26  110  	  Generator hardware found on the AMD Geode LX.
ef5d862734b842 Michael Buesch         2006-06-26  111  
ef5d862734b842 Michael Buesch         2006-06-26  112  	  To compile this driver as a module, choose M here: the
ef5d862734b842 Michael Buesch         2006-06-26  113  	  module will be called geode-rng.
ef5d862734b842 Michael Buesch         2006-06-26  114  
ef5d862734b842 Michael Buesch         2006-06-26  115  	  If unsure, say Y.
13523363577d49 Michael Buesch         2006-06-26  116  
ce087150211412 David S. Miller        2008-06-03  117  config HW_RANDOM_N2RNG
ce087150211412 David S. Miller        2008-06-03  118  	tristate "Niagara2 Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  119  	depends on SPARC64
ce087150211412 David S. Miller        2008-06-03  120  	default HW_RANDOM
ce087150211412 David S. Miller        2008-06-03  121  	---help---
ce087150211412 David S. Miller        2008-06-03  122  	  This driver provides kernel-side support for the Random Number
ce087150211412 David S. Miller        2008-06-03  123  	  Generator hardware found on Niagara2 cpus.
ce087150211412 David S. Miller        2008-06-03  124  
ce087150211412 David S. Miller        2008-06-03  125  	  To compile this driver as a module, choose M here: the
ce087150211412 David S. Miller        2008-06-03  126  	  module will be called n2-rng.
ce087150211412 David S. Miller        2008-06-03  127  
ce087150211412 David S. Miller        2008-06-03  128  	  If unsure, say Y.
ce087150211412 David S. Miller        2008-06-03  129  
13523363577d49 Michael Buesch         2006-06-26  130  config HW_RANDOM_VIA
13523363577d49 Michael Buesch         2006-06-26  131  	tristate "VIA HW Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  132  	depends on X86
fed806f4072bad Jan Beulich            2006-12-06  133  	default HW_RANDOM
13523363577d49 Michael Buesch         2006-06-26  134  	---help---
13523363577d49 Michael Buesch         2006-06-26  135  	  This driver provides kernel-side support for the Random Number
13523363577d49 Michael Buesch         2006-06-26  136  	  Generator hardware found on VIA based motherboards.
13523363577d49 Michael Buesch         2006-06-26  137  
13523363577d49 Michael Buesch         2006-06-26  138  	  To compile this driver as a module, choose M here: the
13523363577d49 Michael Buesch         2006-06-26  139  	  module will be called via-rng.
13523363577d49 Michael Buesch         2006-06-26  140  
13523363577d49 Michael Buesch         2006-06-26  141  	  If unsure, say Y.
d7174bcb919c15 Michael Buesch         2006-06-26  142  
d7174bcb919c15 Michael Buesch         2006-06-26  143  config HW_RANDOM_IXP4XX
553da857b1b917 Krzysztof Hałasa       2010-03-23  144  	tristate "Intel IXP4xx NPU HW Pseudo-Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  145  	depends on ARCH_IXP4XX
fed806f4072bad Jan Beulich            2006-12-06  146  	default HW_RANDOM
d7174bcb919c15 Michael Buesch         2006-06-26  147  	---help---
553da857b1b917 Krzysztof Hałasa       2010-03-23  148  	  This driver provides kernel-side support for the Pseudo-Random
553da857b1b917 Krzysztof Hałasa       2010-03-23  149  	  Number Generator hardware found on the Intel IXP45x/46x NPU.
d7174bcb919c15 Michael Buesch         2006-06-26  150  
d7174bcb919c15 Michael Buesch         2006-06-26  151  	  To compile this driver as a module, choose M here: the
d7174bcb919c15 Michael Buesch         2006-06-26  152  	  module will be called ixp4xx-rng.
d7174bcb919c15 Michael Buesch         2006-06-26  153  
d7174bcb919c15 Michael Buesch         2006-06-26  154  	  If unsure, say Y.
ebc915ad26d881 Michael Buesch         2006-06-26  155  
ebc915ad26d881 Michael Buesch         2006-06-26  156  config HW_RANDOM_OMAP
ebc915ad26d881 Michael Buesch         2006-06-26  157  	tristate "OMAP Random Number Generator support"
383212425c926f Romain Perier          2016-09-16  158  	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU
fed806f4072bad Jan Beulich            2006-12-06  159  	default HW_RANDOM
ebc915ad26d881 Michael Buesch         2006-06-26  160   	---help---
ebc915ad26d881 Michael Buesch         2006-06-26  161   	  This driver provides kernel-side support for the Random Number
a9f5a62a112b6c Russell King           2017-02-13  162  	  Generator hardware found on OMAP16xx, OMAP2/3/4/5, AM33xx/AM43xx
a9f5a62a112b6c Russell King           2017-02-13  163  	  multimedia processors, and Marvell Armada 7k/8k SoCs.
ebc915ad26d881 Michael Buesch         2006-06-26  164  
ebc915ad26d881 Michael Buesch         2006-06-26  165  	  To compile this driver as a module, choose M here: the
ebc915ad26d881 Michael Buesch         2006-06-26  166  	  module will be called omap-rng.
ebc915ad26d881 Michael Buesch         2006-06-26  167  
ebc915ad26d881 Michael Buesch         2006-06-26  168   	  If unsure, say Y.
b8cb34481edfee Olof Johansson         2007-05-09  169  
1c6b7c2108bdb0 Pali Rohár             2013-09-20  170  config HW_RANDOM_OMAP3_ROM
1c6b7c2108bdb0 Pali Rohár             2013-09-20  171  	tristate "OMAP3 ROM Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  172  	depends on ARCH_OMAP3
1c6b7c2108bdb0 Pali Rohár             2013-09-20  173  	default HW_RANDOM
1c6b7c2108bdb0 Pali Rohár             2013-09-20  174  	---help---
1c6b7c2108bdb0 Pali Rohár             2013-09-20  175  	  This driver provides kernel-side support for the Random Number
1c6b7c2108bdb0 Pali Rohár             2013-09-20  176  	  Generator hardware found on OMAP34xx processors.
1c6b7c2108bdb0 Pali Rohár             2013-09-20  177  
1c6b7c2108bdb0 Pali Rohár             2013-09-20  178  	  To compile this driver as a module, choose M here: the
1c6b7c2108bdb0 Pali Rohár             2013-09-20  179  	  module will be called omap3-rom-rng.
1c6b7c2108bdb0 Pali Rohár             2013-09-20  180  
1c6b7c2108bdb0 Pali Rohár             2013-09-20  181  	  If unsure, say Y.
1c6b7c2108bdb0 Pali Rohár             2013-09-20  182  
f7557dc8215a2e David Daney            2009-08-20  183  config HW_RANDOM_OCTEON
f7557dc8215a2e David Daney            2009-08-20  184  	tristate "Octeon Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  185  	depends on CAVIUM_OCTEON_SOC
f7557dc8215a2e David Daney            2009-08-20  186  	default HW_RANDOM
f7557dc8215a2e David Daney            2009-08-20  187  	---help---
f7557dc8215a2e David Daney            2009-08-20  188  	  This driver provides kernel-side support for the Random Number
f7557dc8215a2e David Daney            2009-08-20  189  	  Generator hardware found on Octeon processors.
f7557dc8215a2e David Daney            2009-08-20  190  
f7557dc8215a2e David Daney            2009-08-20  191  	  To compile this driver as a module, choose M here: the
f7557dc8215a2e David Daney            2009-08-20  192  	  module will be called octeon-rng.
f7557dc8215a2e David Daney            2009-08-20  193  
f7557dc8215a2e David Daney            2009-08-20  194  	  If unsure, say Y.
f7557dc8215a2e David Daney            2009-08-20  195  
b8cb34481edfee Olof Johansson         2007-05-09  196  config HW_RANDOM_PASEMI
b8cb34481edfee Olof Johansson         2007-05-09  197  	tristate "PA Semi HW Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  198  	depends on PPC_PASEMI
b8cb34481edfee Olof Johansson         2007-05-09  199  	default HW_RANDOM
b8cb34481edfee Olof Johansson         2007-05-09  200  	---help---
b8cb34481edfee Olof Johansson         2007-05-09  201  	  This driver provides kernel-side support for the Random Number
0d08a84770cb03 Olof Johansson         2007-11-04  202  	  Generator hardware found on PA Semi PWRficient SoCs.
b8cb34481edfee Olof Johansson         2007-05-09  203  
b8cb34481edfee Olof Johansson         2007-05-09  204  	  To compile this driver as a module, choose M here: the
b8cb34481edfee Olof Johansson         2007-05-09  205  	  module will be called pasemi-rng.
b8cb34481edfee Olof Johansson         2007-05-09  206  
b8cb34481edfee Olof Johansson         2007-05-09  207  	  If unsure, say Y.
b8cb34481edfee Olof Johansson         2007-05-09  208  
f7f510ec195781 Rusty Russell          2008-05-30  209  config HW_RANDOM_VIRTIO
f7f510ec195781 Rusty Russell          2008-05-30  210  	tristate "VirtIO Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  211  	depends on VIRTIO
f7f510ec195781 Rusty Russell          2008-05-30  212  	---help---
f7f510ec195781 Rusty Russell          2008-05-30  213  	  This driver provides kernel-side support for the virtual Random Number
f7f510ec195781 Rusty Russell          2008-05-30  214  	  Generator hardware.
f7f510ec195781 Rusty Russell          2008-05-30  215  
f7f510ec195781 Rusty Russell          2008-05-30  216  	  To compile this driver as a module, choose M here: the
f7f510ec195781 Rusty Russell          2008-05-30  217  	  module will be called virtio-rng.  If unsure, say N.
45001e92d0249a Alan Carvalho de Assis 2009-04-02  218  
049a947c611a19 Atsushi Nemoto         2009-06-02  219  config HW_RANDOM_TX4939
049a947c611a19 Atsushi Nemoto         2009-06-02  220  	tristate "TX4939 Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  221  	depends on SOC_TX4939
049a947c611a19 Atsushi Nemoto         2009-06-02  222  	default HW_RANDOM
049a947c611a19 Atsushi Nemoto         2009-06-02  223  	---help---
049a947c611a19 Atsushi Nemoto         2009-06-02  224  	  This driver provides kernel-side support for the Random Number
049a947c611a19 Atsushi Nemoto         2009-06-02  225  	  Generator hardware found on TX4939 SoC.
049a947c611a19 Atsushi Nemoto         2009-06-02  226  
049a947c611a19 Atsushi Nemoto         2009-06-02  227  	  To compile this driver as a module, choose M here: the
049a947c611a19 Atsushi Nemoto         2009-06-02  228  	  module will be called tx4939-rng.
049a947c611a19 Atsushi Nemoto         2009-06-02  229  
049a947c611a19 Atsushi Nemoto         2009-06-02  230  	  If unsure, say Y.
049a947c611a19 Atsushi Nemoto         2009-06-02  231  
45001e92d0249a Alan Carvalho de Assis 2009-04-02  232  config HW_RANDOM_MXC_RNGA
45001e92d0249a Alan Carvalho de Assis 2009-04-02  233  	tristate "Freescale i.MX RNGA Random Number Generator"
f74bdd4cb5d0d4 Fabian Frederick       2016-08-16  234  	depends on SOC_IMX31
2d9cab5194c89a Jean Delvare           2014-04-08  235  	default HW_RANDOM
45001e92d0249a Alan Carvalho de Assis 2009-04-02  236  	---help---
45001e92d0249a Alan Carvalho de Assis 2009-04-02  237  	  This driver provides kernel-side support for the Random Number
45001e92d0249a Alan Carvalho de Assis 2009-04-02  238  	  Generator hardware found on Freescale i.MX processors.
45001e92d0249a Alan Carvalho de Assis 2009-04-02  239  
45001e92d0249a Alan Carvalho de Assis 2009-04-02  240  	  To compile this driver as a module, choose M here: the
45001e92d0249a Alan Carvalho de Assis 2009-04-02  241  	  module will be called mxc-rnga.
45001e92d0249a Alan Carvalho de Assis 2009-04-02  242  
45001e92d0249a Alan Carvalho de Assis 2009-04-02  243  	  If unsure, say Y.
bc85b25e5de17d Alessandro Rubini      2009-12-19  244  
1d5449445bd0af Martin Kaiser          2017-07-23  245  config HW_RANDOM_IMX_RNGC
1d5449445bd0af Martin Kaiser          2017-07-23  246  	tristate "Freescale i.MX RNGC Random Number Generator"
fcdba3c33a4dfd Uwe Kleine-König       2020-02-05  247  	depends on HAS_IOMEM && HAVE_CLK
fcdba3c33a4dfd Uwe Kleine-König       2020-02-05  248  	depends on SOC_IMX25 || COMPILE_TEST
1d5449445bd0af Martin Kaiser          2017-07-23  249  	default HW_RANDOM
1d5449445bd0af Martin Kaiser          2017-07-23  250  	---help---
1d5449445bd0af Martin Kaiser          2017-07-23  251  	  This driver provides kernel-side support for the Random Number
1d5449445bd0af Martin Kaiser          2017-07-23  252  	  Generator Version C hardware found on some Freescale i.MX
1d5449445bd0af Martin Kaiser          2017-07-23  253  	  processors. Version B is also supported by this driver.
1d5449445bd0af Martin Kaiser          2017-07-23  254  
1d5449445bd0af Martin Kaiser          2017-07-23  255  	  To compile this driver as a module, choose M here: the
1d5449445bd0af Martin Kaiser          2017-07-23  256  	  module will be called imx-rngc.
1d5449445bd0af Martin Kaiser          2017-07-23  257  
1d5449445bd0af Martin Kaiser          2017-07-23  258  	  If unsure, say Y.
1d5449445bd0af Martin Kaiser          2017-07-23  259  
bc85b25e5de17d Alessandro Rubini      2009-12-19  260  config HW_RANDOM_NOMADIK
bc85b25e5de17d Alessandro Rubini      2009-12-19  261  	tristate "ST-Ericsson Nomadik Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  262  	depends on ARCH_NOMADIK
2d9cab5194c89a Jean Delvare           2014-04-08  263  	default HW_RANDOM
bc85b25e5de17d Alessandro Rubini      2009-12-19  264  	---help---
bc85b25e5de17d Alessandro Rubini      2009-12-19  265  	  This driver provides kernel-side support for the Random Number
bc85b25e5de17d Alessandro Rubini      2009-12-19  266  	  Generator hardware found on ST-Ericsson SoCs (8815 and 8500).
bc85b25e5de17d Alessandro Rubini      2009-12-19  267  
bc85b25e5de17d Alessandro Rubini      2009-12-19  268  	  To compile this driver as a module, choose M here: the
bc85b25e5de17d Alessandro Rubini      2009-12-19  269  	  module will be called nomadik-rng.
bc85b25e5de17d Alessandro Rubini      2009-12-19  270  
bc85b25e5de17d Alessandro Rubini      2009-12-19  271  	  If unsure, say Y.
5efb94ee144c1c Jamie Iles             2011-01-23  272  
649e9ea0ab611a Kent Yoder             2012-04-12  273  config HW_RANDOM_PSERIES
649e9ea0ab611a Kent Yoder             2012-04-12  274  	tristate "pSeries HW Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  275  	depends on PPC64 && IBMVIO
649e9ea0ab611a Kent Yoder             2012-04-12  276  	default HW_RANDOM
649e9ea0ab611a Kent Yoder             2012-04-12  277  	---help---
649e9ea0ab611a Kent Yoder             2012-04-12  278  	  This driver provides kernel-side support for the Random Number
649e9ea0ab611a Kent Yoder             2012-04-12  279  	  Generator hardware found on POWER7+ machines and above
649e9ea0ab611a Kent Yoder             2012-04-12  280  
649e9ea0ab611a Kent Yoder             2012-04-12  281  	  To compile this driver as a module, choose M here: the
649e9ea0ab611a Kent Yoder             2012-04-12  282  	  module will be called pseries-rng.
649e9ea0ab611a Kent Yoder             2012-04-12  283  
649e9ea0ab611a Kent Yoder             2012-04-12  284  	  If unsure, say Y.
b329669ea0b5b0 Jonghwa Lee            2012-06-29  285  
66548e40583b14 Michael Ellerman       2013-10-11  286  config HW_RANDOM_POWERNV
66548e40583b14 Michael Ellerman       2013-10-11  287  	tristate "PowerNV Random Number Generator support"
0200161834534f Jean Delvare           2014-04-08  288  	depends on PPC_POWERNV
66548e40583b14 Michael Ellerman       2013-10-11  289  	default HW_RANDOM
66548e40583b14 Michael Ellerman       2013-10-11  290  	---help---
66548e40583b14 Michael Ellerman       2013-10-11  291  	  This is the driver for Random Number Generator hardware found
66548e40583b14 Michael Ellerman       2013-10-11  292  	  in POWER7+ and above machines for PowerNV platform.
66548e40583b14 Michael Ellerman       2013-10-11  293  
66548e40583b14 Michael Ellerman       2013-10-11  294  	  To compile this driver as a module, choose M here: the
66548e40583b14 Michael Ellerman       2013-10-11  295  	  module will be called powernv-rng.
66548e40583b14 Michael Ellerman       2013-10-11  296  
66548e40583b14 Michael Ellerman       2013-10-11  297  	  If unsure, say Y.
66548e40583b14 Michael Ellerman       2013-10-11  298  
afc39d6e89b4f4 Kefeng Wang            2016-04-13  299  config HW_RANDOM_HISI
afc39d6e89b4f4 Kefeng Wang            2016-04-13  300  	tristate "Hisilicon Random Number Generator support"
afc39d6e89b4f4 Kefeng Wang            2016-04-13  301  	depends on HW_RANDOM && ARCH_HISI
afc39d6e89b4f4 Kefeng Wang            2016-04-13  302  	default HW_RANDOM
afc39d6e89b4f4 Kefeng Wang            2016-04-13  303  	---help---
afc39d6e89b4f4 Kefeng Wang            2016-04-13  304  	  This driver provides kernel-side support for the Random Number
afc39d6e89b4f4 Kefeng Wang            2016-04-13  305  	  Generator hardware found on Hisilicon Hip04 and Hip05 SoC.
afc39d6e89b4f4 Kefeng Wang            2016-04-13  306  
afc39d6e89b4f4 Kefeng Wang            2016-04-13  307  	  To compile this driver as a module, choose M here: the
afc39d6e89b4f4 Kefeng Wang            2016-04-13  308  	  module will be called hisi-rng.
afc39d6e89b4f4 Kefeng Wang            2016-04-13  309  
afc39d6e89b4f4 Kefeng Wang            2016-04-13  310  	  If unsure, say Y.
afc39d6e89b4f4 Kefeng Wang            2016-04-13  311  
3e90efd129593c Zaibo Xu               2019-10-31  312  config HW_RANDOM_HISI_V2
3e90efd129593c Zaibo Xu               2019-10-31  313  	tristate "HiSilicon True Random Number Generator V2 support"
3e90efd129593c Zaibo Xu               2019-10-31  314  	depends on HW_RANDOM && ARM64 && ACPI
3e90efd129593c Zaibo Xu               2019-10-31  315  	default HW_RANDOM
3e90efd129593c Zaibo Xu               2019-10-31  316  	help
3e90efd129593c Zaibo Xu               2019-10-31  317  	  This driver provides kernel-side support for the True Random Number
3e90efd129593c Zaibo Xu               2019-10-31  318  	  Generator V2 hardware found on HiSilicon Hi1620 SoC.
3e90efd129593c Zaibo Xu               2019-10-31  319  
3e90efd129593c Zaibo Xu               2019-10-31  320  	  To compile this driver as a module, choose M here: the
3e90efd129593c Zaibo Xu               2019-10-31  321  	  module will be called hisi-trng-v2.
3e90efd129593c Zaibo Xu               2019-10-31  322  
3e90efd129593c Zaibo Xu               2019-10-31  323  	  If unsure, say Y.
3e90efd129593c Zaibo Xu               2019-10-31  324  
4a4da53c408c9e Lee Jones              2015-09-17  325  config HW_RANDOM_ST
4a4da53c408c9e Lee Jones              2015-09-17  326  	tristate "ST Microelectronics HW Random Number Generator support"
4a4da53c408c9e Lee Jones              2015-09-17  327  	depends on HW_RANDOM && ARCH_STI
4a4da53c408c9e Lee Jones              2015-09-17  328  	---help---
4a4da53c408c9e Lee Jones              2015-09-17  329  	  This driver provides kernel-side support for the Random Number
4a4da53c408c9e Lee Jones              2015-09-17  330  	  Generator hardware found on STi series of SoCs.
4a4da53c408c9e Lee Jones              2015-09-17  331  
4a4da53c408c9e Lee Jones              2015-09-17  332  	  To compile this driver as a module, choose M here: the
4a4da53c408c9e Lee Jones              2015-09-17  333  	  module will be called st-rng.
4a4da53c408c9e Lee Jones              2015-09-17  334  
a91ae4eba9f997 Feng Kan               2014-08-22  335  config HW_RANDOM_XGENE
a91ae4eba9f997 Feng Kan               2014-08-22  336  	tristate "APM X-Gene True Random Number Generator (TRNG) support"
a91ae4eba9f997 Feng Kan               2014-08-22  337  	depends on HW_RANDOM && ARCH_XGENE
a91ae4eba9f997 Feng Kan               2014-08-22  338  	default HW_RANDOM
a91ae4eba9f997 Feng Kan               2014-08-22  339  	---help---
a91ae4eba9f997 Feng Kan               2014-08-22  340  	  This driver provides kernel-side support for the Random Number
a91ae4eba9f997 Feng Kan               2014-08-22  341  	  Generator hardware found on APM X-Gene SoC.
a91ae4eba9f997 Feng Kan               2014-08-22  342  
a91ae4eba9f997 Feng Kan               2014-08-22  343  	  To compile this driver as a module, choose M here: the
a91ae4eba9f997 Feng Kan               2014-08-22  344  	  module will be called xgene_rng.
a91ae4eba9f997 Feng Kan               2014-08-22  345  
a91ae4eba9f997 Feng Kan               2014-08-22  346  	  If unsure, say Y.
a91ae4eba9f997 Feng Kan               2014-08-22  347  
c6a97c42e399ad Daniel Thompson        2015-10-12  348  config HW_RANDOM_STM32
c6a97c42e399ad Daniel Thompson        2015-10-12  349  	tristate "STMicroelectronics STM32 random number generator"
c6a97c42e399ad Daniel Thompson        2015-10-12  350  	depends on HW_RANDOM && (ARCH_STM32 || COMPILE_TEST)
625b4a982788fe Richard Weinberger     2016-01-25  351  	depends on HAS_IOMEM
af513781f21ca9 lionel.debieve@st.com  2018-04-23  352  	default HW_RANDOM
c6a97c42e399ad Daniel Thompson        2015-10-12  353  	help
c6a97c42e399ad Daniel Thompson        2015-10-12  354  	  This driver provides kernel-side support for the Random Number
c6a97c42e399ad Daniel Thompson        2015-10-12  355  	  Generator hardware found on STM32 microcontrollers.
c6a97c42e399ad Daniel Thompson        2015-10-12  356  
c6a97c42e399ad Daniel Thompson        2015-10-12  357  	  To compile this driver as a module, choose M here: the
c6a97c42e399ad Daniel Thompson        2015-10-12  358  	  module will be called stm32-rng.
c6a97c42e399ad Daniel Thompson        2015-10-12  359  
c6a97c42e399ad Daniel Thompson        2015-10-12  360  	  If unsure, say N.
c6a97c42e399ad Daniel Thompson        2015-10-12  361  
730d02e27670fa Joshua Henderson       2016-02-08  362  config HW_RANDOM_PIC32
730d02e27670fa Joshua Henderson       2016-02-08  363  	tristate "Microchip PIC32 Random Number Generator support"
730d02e27670fa Joshua Henderson       2016-02-08  364  	depends on HW_RANDOM && MACH_PIC32
730d02e27670fa Joshua Henderson       2016-02-08  365  	default y
730d02e27670fa Joshua Henderson       2016-02-08  366  	---help---
730d02e27670fa Joshua Henderson       2016-02-08  367  	  This driver provides kernel-side support for the Random Number
730d02e27670fa Joshua Henderson       2016-02-08  368  	  Generator hardware found on a PIC32.
730d02e27670fa Joshua Henderson       2016-02-08  369  
730d02e27670fa Joshua Henderson       2016-02-08  370  	  To compile this driver as a module, choose M here. the
730d02e27670fa Joshua Henderson       2016-02-08  371  	  module will be called pic32-rng.
730d02e27670fa Joshua Henderson       2016-02-08  372  
730d02e27670fa Joshua Henderson       2016-02-08  373  	  If unsure, say Y.
730d02e27670fa Joshua Henderson       2016-02-08  374  
e123be16120df6 Neil Armstrong         2016-06-10  375  config HW_RANDOM_MESON
e123be16120df6 Neil Armstrong         2016-06-10  376  	tristate "Amlogic Meson Random Number Generator support"
e123be16120df6 Neil Armstrong         2016-06-10  377  	depends on HW_RANDOM
e123be16120df6 Neil Armstrong         2016-06-10  378  	depends on ARCH_MESON || COMPILE_TEST
e123be16120df6 Neil Armstrong         2016-06-10  379  	default y
e123be16120df6 Neil Armstrong         2016-06-10  380  	---help---
e123be16120df6 Neil Armstrong         2016-06-10  381  	  This driver provides kernel-side support for the Random Number
e123be16120df6 Neil Armstrong         2016-06-10  382  	  Generator hardware found on Amlogic Meson SoCs.
e123be16120df6 Neil Armstrong         2016-06-10  383  
e123be16120df6 Neil Armstrong         2016-06-10  384  	  To compile this driver as a module, choose M here. the
e123be16120df6 Neil Armstrong         2016-06-10  385  	  module will be called meson-rng.
e123be16120df6 Neil Armstrong         2016-06-10  386  
e123be16120df6 Neil Armstrong         2016-06-10  387  	  If unsure, say Y.
e123be16120df6 Neil Armstrong         2016-06-10  388  
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  389  config HW_RANDOM_CAVIUM
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  390  	tristate "Cavium ThunderX Random Number Generator support"
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  391  	depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  392  	default HW_RANDOM
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  393  	---help---
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  394  	  This driver provides kernel-side support for the Random Number
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  395  	  Generator hardware found on Cavium SoCs.
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  396  
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  397  	  To compile this driver as a module, choose M here: the
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  398  	  module will be called cavium_rng.
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  399  
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  400  	  If unsure, say Y.
cc2f1908c6b8f6 Omer Khaliq            2016-08-23  401  
7701d1ff8ed1b8 Sean Wang              2017-04-21  402  config HW_RANDOM_MTK
7701d1ff8ed1b8 Sean Wang              2017-04-21  403  	tristate "Mediatek Random Number Generator support"
7701d1ff8ed1b8 Sean Wang              2017-04-21  404  	depends on HW_RANDOM
7701d1ff8ed1b8 Sean Wang              2017-04-21  405  	depends on ARCH_MEDIATEK || COMPILE_TEST
7701d1ff8ed1b8 Sean Wang              2017-04-21  406  	default y
7701d1ff8ed1b8 Sean Wang              2017-04-21  407  	---help---
7701d1ff8ed1b8 Sean Wang              2017-04-21  408  	  This driver provides kernel-side support for the Random Number
7701d1ff8ed1b8 Sean Wang              2017-04-21  409  	  Generator hardware found on Mediatek SoCs.
7701d1ff8ed1b8 Sean Wang              2017-04-21  410  
7701d1ff8ed1b8 Sean Wang              2017-04-21  411  	  To compile this driver as a module, choose M here. the
7701d1ff8ed1b8 Sean Wang              2017-04-21  412  	  module will be called mtk-rng.
7701d1ff8ed1b8 Sean Wang              2017-04-21  413  
7701d1ff8ed1b8 Sean Wang              2017-04-21  414  	  If unsure, say Y.
7701d1ff8ed1b8 Sean Wang              2017-04-21  415  
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  416  config HW_RANDOM_S390
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  417  	tristate "S390 True Random Number Generator support"
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  418  	depends on S390
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  419  	default HW_RANDOM
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  420  	---help---
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  421  	  This driver provides kernel-side support for the True
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  422  	  Random Number Generator available as CPACF extension
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  423  	  on modern s390 hardware platforms.
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  424  
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  425  	  To compile this driver as a module, choose M here: the
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  426  	  module will be called s390-trng.
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  427  
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  428  	  If unsure, say Y.
bbcb478e3fefa5 Harald Freudenberger   2017-02-24  429  
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  430  config HW_RANDOM_EXYNOS
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  431  	tristate "Samsung Exynos True Random Number Generator support"
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  432  	depends on ARCH_EXYNOS || COMPILE_TEST
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  433  	default HW_RANDOM
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  434  	---help---
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  435  	  This driver provides support for the True Random Number
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  436  	  Generator available in Exynos SoCs.
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  437  
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  438  	  To compile this driver as a module, choose M here: the module
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  439  	  will be called exynos-trng.
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  440  
6cd225cc5d8a65 Łukasz Stelmach        2017-12-22  441  	  If unsure, say Y.
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  442  
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  443  config HW_RANDOM_OPTEE
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  444  	tristate "OP-TEE based Random Number Generator support"
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  445  	depends on OPTEE
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  446  	default HW_RANDOM
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  447  	help
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  448  	  This  driver provides support for OP-TEE based Random Number
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  449  	  Generator on ARM SoCs where hardware entropy sources are not
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  450  	  accessible to normal world (Linux).
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  451  
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  452  	  To compile this driver as a module, choose M here: the module
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  453  	  will be called optee-rng.
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  454  
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  455  	  If unsure, say Y.
5fe8b1cc6a03c4 Sumit Garg             2019-01-29  456  
c98429297d8b25 Tomer Maimon           2019-09-12  457  config HW_RANDOM_NPCM
c98429297d8b25 Tomer Maimon           2019-09-12  458  	tristate "NPCM Random Number Generator support"
c98429297d8b25 Tomer Maimon           2019-09-12  459  	depends on ARCH_NPCM || COMPILE_TEST
c98429297d8b25 Tomer Maimon           2019-09-12  460  	default HW_RANDOM
c98429297d8b25 Tomer Maimon           2019-09-12  461  	help
c98429297d8b25 Tomer Maimon           2019-09-12  462   	  This driver provides support for the Random Number
c98429297d8b25 Tomer Maimon           2019-09-12  463  	  Generator hardware available in Nuvoton NPCM SoCs.
c98429297d8b25 Tomer Maimon           2019-09-12  464  
c98429297d8b25 Tomer Maimon           2019-09-12  465  	  To compile this driver as a module, choose M here: the
c98429297d8b25 Tomer Maimon           2019-09-12  466  	  module will be called npcm-rng.
c98429297d8b25 Tomer Maimon           2019-09-12  467  
c98429297d8b25 Tomer Maimon           2019-09-12  468   	  If unsure, say Y.
c98429297d8b25 Tomer Maimon           2019-09-12  469  
ace74b627c88ea Randy Dunlap           2020-03-04  470  config HW_RANDOM_KEYSTONE
ace74b627c88ea Randy Dunlap           2020-03-04  471  	depends on ARCH_KEYSTONE || COMPILE_TEST
ace74b627c88ea Randy Dunlap           2020-03-04  472  	default HW_RANDOM
ace74b627c88ea Randy Dunlap           2020-03-04  473  	tristate "TI Keystone NETCP SA Hardware random number generator"
ace74b627c88ea Randy Dunlap           2020-03-04  474  	help
ace74b627c88ea Randy Dunlap           2020-03-04  475  	  This option enables Keystone's hardware random generator.
ace74b627c88ea Randy Dunlap           2020-03-04  476  
a583ed310bb6b5 Hadar Gat              2020-03-27  477  config HW_RANDOM_CCTRNG
a583ed310bb6b5 Hadar Gat              2020-03-27  478  	tristate "Arm CryptoCell True Random Number Generator support"
1cb06aa1c8f17a Hadar Gat              2020-04-27 @479  	depends on HAS_IOMEM & OF
a583ed310bb6b5 Hadar Gat              2020-03-27 @480  	default HW_RANDOM
a583ed310bb6b5 Hadar Gat              2020-03-27  481  	help
a583ed310bb6b5 Hadar Gat              2020-03-27 @482  	  This driver provides support for the True Random Number
a583ed310bb6b5 Hadar Gat              2020-03-27 @483  	  Generator available in Arm TrustZone CryptoCell.
a583ed310bb6b5 Hadar Gat              2020-03-27  484  
a583ed310bb6b5 Hadar Gat              2020-03-27 @485  	  To compile this driver as a module, choose M here: the module
a583ed310bb6b5 Hadar Gat              2020-03-27 @486  	  will be called cctrng.
a583ed310bb6b5 Hadar Gat              2020-03-27  487  
a583ed310bb6b5 Hadar Gat              2020-03-27 @488  	  If unsure, say Y.
a583ed310bb6b5 Hadar Gat              2020-03-27  489  

:::::: The code at line 480 was first introduced by commit
:::::: a583ed310bb6b514e717c11a30b5a7bc3a65d1b1 hwrng: cctrng - introduce Arm CryptoCell driver

:::::: TO: Hadar Gat <hadar.gat@arm.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
