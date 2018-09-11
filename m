From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 07/11] crypto: caam/qi2 - add DPAA2-CAAM driver
Date: Tue, 11 Sep 2018 13:20:04 +0800
Message-ID: <201809111311.rqCiSh3E%fengguang.wu@intel.com>
References: <20180910171550.5659-8-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180910171550.5659-8-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Horia,

I love your patch! Perhaps something to improve:

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.19-rc3 next-20180910]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Horia-Geant/crypto-caam-add-DPAA2-DPSECI-driver/20180911-055735
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:96:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned long long @@    got restricted unsigned long long @@
   drivers/crypto/caam/regs.h:96:1:    expected unsigned long long
   drivers/crypto/caam/regs.h:96:1:    got restricted __le64 [usertype] <noident>
>> drivers/crypto/caam/regs.h:96:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned long long @@    got restricted unsigned long long @@
   drivers/crypto/caam/regs.h:96:1:    expected unsigned long long
   drivers/crypto/caam/regs.h:96:1:    got restricted __be64 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: too many warnings
--
>> drivers/crypto/caam/caamalg_qi2.c:83:6: sparse: symbol 'dpaa2_caam_iova_to_virt' was not declared. Should it be static?
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:95:1: sparse: incorrect type in return expression (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/caam/regs.h:95:1:    expected unsigned int
   drivers/crypto/caam/regs.h:95:1:    got restricted __be32 [usertype] <noident>
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __le32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
>> drivers/crypto/caam/regs.h:92:1: sparse: cast to restricted __be32
   drivers/crypto/caam/regs.h:92:1: sparse: too many warnings
   drivers/crypto/caam/caamalg_qi2.c:288:13: warning: 'split_key_sh_done' defined but not used [-Wunused-function]
    static void split_key_sh_done(void *cbk_ctx, u32 err)
                ^~~~~~~~~~~~~~~~~

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
