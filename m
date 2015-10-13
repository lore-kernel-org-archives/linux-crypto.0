From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] crypto: Allow drivers to build if COMPILE_TEST is enabled
Date: Wed, 14 Oct 2015 05:03:30 +0800
Message-ID: <201510140540.8v7D383Q%fengguang.wu@intel.com>
References: <1444743760-15155-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbbJMVEb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 17:04:31 -0400
Content-Disposition: inline
In-Reply-To: <1444743760-15155-1-git-send-email-javier@osg.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Javier,

[auto build test WARNING on cryptodev/master -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Javier-Martinez-Canillas/crypto-Allow-drivers-to-build-if-COMPILE_TEST-is-enabled/20151013-214554
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/s5p-sss.c:385:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/s5p-sss.c:385:17:    expected void *to
   drivers/crypto/s5p-sss.c:385:17:    got void [noderef] <asn:2>*
>> drivers/crypto/s5p-sss.c:394:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/s5p-sss.c:394:9:    expected void *to
   drivers/crypto/s5p-sss.c:394:9:    got void [noderef] <asn:2>*[assigned] keystart
--
>> drivers/crypto/marvell/cesa.c:327:30: sparse: incorrect type in assignment (different address spaces)
   drivers/crypto/marvell/cesa.c:327:30:    expected void [noderef] <asn:2>*sram
   drivers/crypto/marvell/cesa.c:327:30:    got void *
--
>> drivers/crypto/marvell/cipher.c:93:47: sparse: incorrect type in argument 3 (different address spaces)
   drivers/crypto/marvell/cipher.c:93:47:    expected void *buf
   drivers/crypto/marvell/cipher.c:93:47:    got void [noderef] <asn:2>*
>> drivers/crypto/marvell/cesa.h:656:26: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:656:26:    expected unsigned int [unsigned] [usertype] enc_len
   drivers/crypto/marvell/cesa.h:656:26:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cipher.c:101:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/cipher.c:101:17:    expected void *to
   drivers/crypto/marvell/cipher.c:101:17:    got void [noderef] <asn:2>*sram
   drivers/crypto/marvell/cipher.c:104:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/cipher.c:104:17:    expected void *to
   drivers/crypto/marvell/cipher.c:104:17:    got void [noderef] <asn:2>*sram
>> drivers/crypto/marvell/cipher.c:121:49: sparse: incorrect type in argument 3 (different address spaces)
   drivers/crypto/marvell/cipher.c:121:49:    expected void const *buf
   drivers/crypto/marvell/cipher.c:121:49:    got void [noderef] <asn:2>*
>> drivers/crypto/marvell/cipher.c:148:9: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/cipher.c:148:9:    expected void const *from
   drivers/crypto/marvell/cipher.c:148:9:    got void [noderef] <asn:2>*
>> drivers/crypto/marvell/cipher.c:246:41: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cipher.c:246:41:    expected unsigned int [unsigned] <noident>
   drivers/crypto/marvell/cipher.c:246:41:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:656:26: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:656:26:    expected unsigned int [unsigned] [usertype] enc_len
   drivers/crypto/marvell/cesa.h:656:26:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cipher.c:349:60: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/cipher.c:349:60:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/cipher.c:349:60:    got restricted gfp_t [usertype] flags
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cipher.c:680:44: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cipher.c:680:44:    expected unsigned int [unsigned] <noident>
   drivers/crypto/marvell/cipher.c:680:44:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:644:24: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:644:24:    expected unsigned int [unsigned] [usertype] enc_p
   drivers/crypto/marvell/cesa.h:644:24:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:645:28: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:645:28:    expected unsigned int [unsigned] [usertype] enc_key_p
   drivers/crypto/marvell/cesa.h:645:28:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:646:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:646:25:    expected unsigned int [unsigned] [usertype] enc_iv
   drivers/crypto/marvell/cesa.h:646:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:648:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:648:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:648:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:650:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:650:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:650:29:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:651:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:651:25:    expected unsigned int [unsigned] [usertype] mac_iv
   drivers/crypto/marvell/cesa.h:651:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cipher.c:184:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/cipher.c:184:9:    expected void *to
   drivers/crypto/marvell/cipher.c:184:9:    got void [noderef] <asn:2>*sram
--
>> drivers/crypto/marvell/hash.c:206:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:206:17:    expected void *to
   drivers/crypto/marvell/hash.c:206:17:    got void [noderef] <asn:2>*
>> drivers/crypto/marvell/hash.c:220:77: sparse: incorrect type in argument 3 (different address spaces)
   drivers/crypto/marvell/hash.c:220:77:    expected void *buf
   drivers/crypto/marvell/hash.c:220:77:    got void [noderef] <asn:2>*
>> drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
>> drivers/crypto/marvell/hash.c:248:33: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/hash.c:248:33:    expected void const *from
   drivers/crypto/marvell/hash.c:248:33:    got void [noderef] <asn:2>*
>> drivers/crypto/marvell/hash.c:254:68: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/hash.c:254:68:    expected unsigned char [usertype] *buf
   drivers/crypto/marvell/hash.c:254:68:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:269:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:269:9:    expected void *to
   drivers/crypto/marvell/hash.c:269:9:    got void [noderef] <asn:2>*sram
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:644:24: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:644:24:    expected unsigned int [unsigned] [usertype] enc_p
   drivers/crypto/marvell/cesa.h:644:24:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:645:28: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:645:28:    expected unsigned int [unsigned] [usertype] enc_key_p
   drivers/crypto/marvell/cesa.h:645:28:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:646:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:646:25:    expected unsigned int [unsigned] [usertype] enc_iv
   drivers/crypto/marvell/cesa.h:646:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:648:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:648:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:648:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:650:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:650:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:650:29:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:651:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:651:25:    expected unsigned int [unsigned] [usertype] mac_iv
   drivers/crypto/marvell/cesa.h:651:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:309:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:309:9:    expected void *to
   drivers/crypto/marvell/hash.c:309:9:    got void [noderef] <asn:2>*sram
>> drivers/crypto/marvell/hash.c:341:32: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/hash.c:341:32:    expected restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:341:32:    got unsigned int
>> drivers/crypto/marvell/hash.c:356:50: sparse: cast from restricted __be32
>> drivers/crypto/marvell/hash.c:356:48: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/hash.c:356:48:    expected restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:356:48:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
>> drivers/crypto/marvell/hash.c:358:50: sparse: incorrect type in argument 1 (different base types)
   drivers/crypto/marvell/hash.c:358:50:    expected unsigned int [unsigned] [usertype] val
   drivers/crypto/marvell/hash.c:358:50:    got restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:358:50: sparse: cast from restricted __be32
>> drivers/crypto/marvell/hash.c:384:35: sparse: incorrect type in argument 1 (different base types)
   drivers/crypto/marvell/hash.c:384:35:    expected unsigned int [unsigned] val
   drivers/crypto/marvell/hash.c:384:35:    got restricted __be32 <noident>
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
>> drivers/crypto/marvell/hash.c:494:59: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:494:59:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:494:59:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:530:51: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:530:51:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:530:51:    got restricted gfp_t [usertype] flags
>> drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
>> drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:616:51: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:616:51:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:616:51:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/hash.c:677:57: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:677:57:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:677:57:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/hash.c:1258:30: sparse: cast to restricted __be32
>> drivers/crypto/marvell/hash.c:1258:30: sparse: cast to restricted __be32
>> drivers/crypto/marvell/hash.c:1258:30: sparse: cast to restricted __be32
>> drivers/crypto/marvell/hash.c:1258:30: sparse: cast to restricted __be32
>> drivers/crypto/marvell/hash.c:1258:30: sparse: cast to restricted __be32
>> drivers/crypto/marvell/hash.c:1258:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1261:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1261:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1261:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1261:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1261:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1261:34: sparse: cast to restricted __be32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:1328:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1328:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1328:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1328:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1328:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1328:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1331:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1331:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1331:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1331:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1331:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1331:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1385:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1385:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1385:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1385:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1385:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1385:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1388:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1388:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1388:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1388:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1388:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1388:34: sparse: cast to restricted __be32
>> drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
--
>> drivers/crypto/marvell/tdma.c:68:39: sparse: cast to restricted __le32
   drivers/crypto/marvell/tdma.c:72:31: sparse: cast to restricted __le32
>> drivers/crypto/marvell/tdma.c:86:35: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/tdma.c:86:35:    expected unsigned int [unsigned] [usertype] dst
   drivers/crypto/marvell/tdma.c:86:35:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/tdma.c:89:35: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/tdma.c:89:35:    expected unsigned int [unsigned] [usertype] src
   drivers/crypto/marvell/tdma.c:89:35:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:644:24: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:644:24:    expected unsigned int [unsigned] [usertype] enc_p
   drivers/crypto/marvell/cesa.h:644:24:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:645:28: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:645:28:    expected unsigned int [unsigned] [usertype] enc_key_p
   drivers/crypto/marvell/cesa.h:645:28:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cesa.h:646:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:646:25:    expected unsigned int [unsigned] [usertype] enc_iv
   drivers/crypto/marvell/cesa.h:646:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:648:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:648:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:648:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:650:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:650:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:650:29:    right side has type restricted __le32
>> drivers/crypto/marvell/cesa.h:651:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:651:25:    expected unsigned int [unsigned] [usertype] mac_iv
   drivers/crypto/marvell/cesa.h:651:25:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/tdma.c:108:27: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/tdma.c:108:27:    expected unsigned int [unsigned] [usertype] cur_dma
   drivers/crypto/marvell/tdma.c:108:27:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/tdma.c:174:44: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/tdma.c:174:44:    expected restricted gfp_t [usertype] flags
   drivers/crypto/marvell/tdma.c:174:44:    got unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/tdma.c:185:44: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/tdma.c:185:44:    expected restricted gfp_t [usertype] flags
   drivers/crypto/marvell/tdma.c:185:44:    got unsigned int [unsigned] [usertype] flags

vim +385 drivers/crypto/s5p-sss.c

a49e490c Vladimir Zapolskiy       2011-04-08  379  static void s5p_set_aes(struct s5p_aes_dev *dev,
a49e490c Vladimir Zapolskiy       2011-04-08  380  			uint8_t *key, uint8_t *iv, unsigned int keylen)
a49e490c Vladimir Zapolskiy       2011-04-08  381  {
a49e490c Vladimir Zapolskiy       2011-04-08  382  	void __iomem *keystart;
a49e490c Vladimir Zapolskiy       2011-04-08  383  
8f9702aa Naveen Krishna Chatradhi 2014-05-08  384  	if (iv)
89245107 Naveen Krishna Chatradhi 2014-05-08 @385  		memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
a49e490c Vladimir Zapolskiy       2011-04-08  386  
a49e490c Vladimir Zapolskiy       2011-04-08  387  	if (keylen == AES_KEYSIZE_256)
89245107 Naveen Krishna Chatradhi 2014-05-08  388  		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
a49e490c Vladimir Zapolskiy       2011-04-08  389  	else if (keylen == AES_KEYSIZE_192)
89245107 Naveen Krishna Chatradhi 2014-05-08  390  		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(2);
a49e490c Vladimir Zapolskiy       2011-04-08  391  	else
89245107 Naveen Krishna Chatradhi 2014-05-08  392  		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(4);
a49e490c Vladimir Zapolskiy       2011-04-08  393  
a49e490c Vladimir Zapolskiy       2011-04-08 @394  	memcpy(keystart, key, keylen);
a49e490c Vladimir Zapolskiy       2011-04-08  395  }
a49e490c Vladimir Zapolskiy       2011-04-08  396  
a49e490c Vladimir Zapolskiy       2011-04-08  397  static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)

:::::: The code at line 385 was first introduced by commit
:::::: 892451071de77a088a6227e36d3a2732d51c5b84 crypto: s5p-sss - Add support for SSS module on Exynos

:::::: TO: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
