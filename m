From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/5 v4] crypto: add zBeWalgo to crypto-api
Date: Fri, 23 Mar 2018 17:36:38 +0800
Message-ID: <201803231728.EQZdGg40%fengguang.wu@intel.com>
References: <1B59F77F-1AD8-484A-BA18-255502527323@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, minchan@kernel.org, ngupta@vflare.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1B59F77F-1AD8-484A-BA18-255502527323@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Benjamin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.16-rc6]
[cannot apply to next-20180322]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Benjamin-Warnke/add-compression-algorithm-zBeWalgo/20180323-155925
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> lib/zbewalgo/zbewalgo.c:70:12: sparse: symbol 'zbewalgo_stat_combination' was not declared. Should it be static?
>> lib/zbewalgo/zbewalgo.c:71:12: sparse: symbol 'zbewalgo_stat_count' was not declared. Should it be static?
>> lib/zbewalgo/zbewalgo.c:79:9: sparse: symbol 'zbewalgo_combinations' was not declared. Should it be static?
>> lib/zbewalgo/zbewalgo.c:80:4: sparse: symbol 'zbewalgo_combinations_count' was not declared. Should it be static?
>> lib/zbewalgo/zbewalgo.c:92:5: sparse: symbol 'zbewalgo_early_abort_size' was not declared. Should it be static?
>> lib/zbewalgo/zbewalgo.c:97:36: sparse: symbol 'zbewalgo_main_data_ptr' was not declared. Should it be static?
>> lib/zbewalgo/zbewalgo.c:103:9: sparse: symbol 'zbewalgo_base_algorithms' was not declared. Should it be static?
>> lib/zbewalgo/zbewalgo.c:104:4: sparse: symbol 'zbewalgo_base_algorithms_count' was not declared. Should it be static?
--
>> lib/zbewalgo/JBE2.c:46:44: sparse: constant 0xF0F0F0F00F0F0F0F is so big it is unsigned long
>> lib/zbewalgo/JBE2.c:47:42: sparse: constant 0x0F0F0F0F00000000 is so big it is long
   lib/zbewalgo/JBE2.c:127:40: sparse: constant 0xF0F0F0F00F0F0F0F is so big it is unsigned long
   lib/zbewalgo/JBE2.c:128:40: sparse: constant 0x0F0F0F0F00000000 is so big it is long
   lib/zbewalgo/JBE2.c:184:40: sparse: constant 0xF0F0F0F00F0F0F0F is so big it is unsigned long
   lib/zbewalgo/JBE2.c:185:40: sparse: constant 0x0F0F0F0F00000000 is so big it is long

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
