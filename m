From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 269/278] drivers/crypto/marvell/cipher.c:298:60:
 sparse: incorrect type in argument 2 (different base types)
Date: Sat, 20 Jun 2015 03:06:30 +0800
Message-ID: <201506200324.SzSX9ODk%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-crypto@vger.kernel.org
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:15319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbbFSTGs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 15:06:48 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   2df6bb5d8b22bc06a6ea83e8b2a6bcf3bb445304
commit: db509a45339fd786de355b11db34ff7421488cb1 [269/278] crypto: marvell/cesa - add TDMA support
reproduce:
  # apt-get install sparse
  git checkout db509a45339fd786de355b11db34ff7421488cb1
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/marvell/cipher.c:82:47: sparse: incorrect type in argument 3 (different address spaces)
   drivers/crypto/marvell/cipher.c:82:47:    expected void *buf
   drivers/crypto/marvell/cipher.c:82:47:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cesa.h:656:26: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:656:26:    expected unsigned int [unsigned] [usertype] enc_len
   drivers/crypto/marvell/cesa.h:656:26:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cipher.c:90:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/cipher.c:90:17:    expected void *to
   drivers/crypto/marvell/cipher.c:90:17:    got void [noderef] <asn:2>*sram
   drivers/crypto/marvell/cipher.c:93:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/cipher.c:93:17:    expected void *to
   drivers/crypto/marvell/cipher.c:93:17:    got void [noderef] <asn:2>*sram
   drivers/crypto/marvell/cipher.c:110:49: sparse: incorrect type in argument 3 (different address spaces)
   drivers/crypto/marvell/cipher.c:110:49:    expected void *buf
   drivers/crypto/marvell/cipher.c:110:49:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cipher.c:137:9: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/cipher.c:137:9:    expected void const *from
   drivers/crypto/marvell/cipher.c:137:9:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cipher.c:235:41: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cipher.c:235:41:    expected unsigned int [unsigned] <noident>
   drivers/crypto/marvell/cipher.c:235:41:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:656:26: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:656:26:    expected unsigned int [unsigned] [usertype] enc_len
   drivers/crypto/marvell/cesa.h:656:26:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/cipher.c:298:60: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/cipher.c:298:60:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/cipher.c:298:60:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cipher.c:383:44: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cipher.c:383:44:    expected unsigned int [unsigned] <noident>
   drivers/crypto/marvell/cipher.c:383:44:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:644:24: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:644:24:    expected unsigned int [unsigned] [usertype] enc_p
   drivers/crypto/marvell/cesa.h:644:24:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:645:28: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:645:28:    expected unsigned int [unsigned] [usertype] enc_key_p
   drivers/crypto/marvell/cesa.h:645:28:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:646:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:646:25:    expected unsigned int [unsigned] [usertype] enc_iv
   drivers/crypto/marvell/cesa.h:646:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:648:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:648:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:648:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:650:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:650:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:650:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:651:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:651:25:    expected unsigned int [unsigned] [usertype] mac_iv
   drivers/crypto/marvell/cesa.h:651:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cipher.c:173:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/cipher.c:173:9:    expected void *to
   drivers/crypto/marvell/cipher.c:173:9:    got void [noderef] <asn:2>*sram
--
   drivers/crypto/marvell/hash.c:205:17: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:205:17:    expected void *to
   drivers/crypto/marvell/hash.c:205:17:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/hash.c:219:77: sparse: incorrect type in argument 3 (different address spaces)
   drivers/crypto/marvell/hash.c:219:77:    expected void *buf
   drivers/crypto/marvell/hash.c:219:77:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:247:33: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/hash.c:247:33:    expected void const *from
   drivers/crypto/marvell/hash.c:247:33:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/hash.c:253:68: sparse: incorrect type in argument 2 (different address spaces)
   drivers/crypto/marvell/hash.c:253:68:    expected unsigned char [usertype] *buf
   drivers/crypto/marvell/hash.c:253:68:    got void [noderef] <asn:2>*
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:268:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:268:9:    expected void *to
   drivers/crypto/marvell/hash.c:268:9:    got void [noderef] <asn:2>*sram
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:644:24: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:644:24:    expected unsigned int [unsigned] [usertype] enc_p
   drivers/crypto/marvell/cesa.h:644:24:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:645:28: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:645:28:    expected unsigned int [unsigned] [usertype] enc_key_p
   drivers/crypto/marvell/cesa.h:645:28:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:646:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:646:25:    expected unsigned int [unsigned] [usertype] enc_iv
   drivers/crypto/marvell/cesa.h:646:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:648:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:648:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:648:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:650:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:650:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:650:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:651:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:651:25:    expected unsigned int [unsigned] [usertype] mac_iv
   drivers/crypto/marvell/cesa.h:651:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:308:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/crypto/marvell/hash.c:308:9:    expected void *to
   drivers/crypto/marvell/hash.c:308:9:    got void [noderef] <asn:2>*sram
   drivers/crypto/marvell/hash.c:340:32: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/hash.c:340:32:    expected restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:340:32:    got unsigned int
   drivers/crypto/marvell/hash.c:350:42: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:350:42: sparse: incorrect type in argument 1 (different base types)
   drivers/crypto/marvell/hash.c:350:42:    expected unsigned int [unsigned] [usertype] val
   drivers/crypto/marvell/hash.c:350:42:    got restricted __be32 <noident>
   drivers/crypto/marvell/hash.c:350:42: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:350:42: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:350:42: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:350:42: sparse: cast from restricted __be32
   drivers/crypto/marvell/hash.c:375:35: sparse: incorrect type in argument 1 (different base types)
   drivers/crypto/marvell/hash.c:375:35:    expected unsigned int [unsigned] val
   drivers/crypto/marvell/hash.c:375:35:    got restricted __be32 <noident>
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
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
>> drivers/crypto/marvell/hash.c:485:59: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:485:59:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:485:59:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:521:51: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:521:51:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:521:51:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:631:16: sparse: cast to restricted __le32
   drivers/crypto/marvell/cesa.h:625:25: sparse: invalid assignment: &=
   drivers/crypto/marvell/cesa.h:625:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:625:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:626:25: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:626:25:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:626:25:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:670:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:670:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:670:29:    right side has type restricted __le32
   drivers/crypto/marvell/hash.c:607:51: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:607:51:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:607:51:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/hash.c:668:57: sparse: incorrect type in argument 2 (different base types)
   drivers/crypto/marvell/hash.c:668:57:    expected unsigned int [unsigned] [usertype] flags
   drivers/crypto/marvell/hash.c:668:57:    got restricted gfp_t [usertype] flags
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:663:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:663:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:663:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:636:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:636:25:    expected unsigned int [unsigned] [usertype] config
   drivers/crypto/marvell/cesa.h:636:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/hash.c:1071:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1071:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1071:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1071:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1071:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1071:30: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1074:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1074:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1074:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1074:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1074:34: sparse: cast to restricted __be32
   drivers/crypto/marvell/hash.c:1074:34: sparse: cast to restricted __be32
--
>> drivers/crypto/marvell/tdma.c:68:39: sparse: cast to restricted __le32
   drivers/crypto/marvell/tdma.c:72:31: sparse: cast to restricted __le32
>> drivers/crypto/marvell/tdma.c:86:35: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/tdma.c:86:35:    expected unsigned int [unsigned] [usertype] dst
   drivers/crypto/marvell/tdma.c:86:35:    got restricted __le32 [usertype] <noident>
>> drivers/crypto/marvell/tdma.c:89:35: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/tdma.c:89:35:    expected unsigned int [unsigned] [usertype] src
   drivers/crypto/marvell/tdma.c:89:35:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:644:24: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:644:24:    expected unsigned int [unsigned] [usertype] enc_p
   drivers/crypto/marvell/cesa.h:644:24:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:645:28: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:645:28:    expected unsigned int [unsigned] [usertype] enc_key_p
   drivers/crypto/marvell/cesa.h:645:28:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:646:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/marvell/cesa.h:646:25:    expected unsigned int [unsigned] [usertype] enc_iv
   drivers/crypto/marvell/cesa.h:646:25:    got restricted __le32 [usertype] <noident>
   drivers/crypto/marvell/cesa.h:648:28: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:648:28:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:648:28:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:650:29: sparse: invalid assignment: |=
   drivers/crypto/marvell/cesa.h:650:29:    left side has type unsigned int
   drivers/crypto/marvell/cesa.h:650:29:    right side has type restricted __le32
   drivers/crypto/marvell/cesa.h:651:25: sparse: incorrect type in assignment (different base types)
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

vim +298 drivers/crypto/marvell/cipher.c

   131		else
   132			ret = mv_cesa_ablkcipher_std_process(ablkreq, status);
   133	
   134		if (ret)
   135			return ret;
   136	
 > 137		memcpy(ablkreq->info, engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
   138		       crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq)));
   139	
   140		return 0;
   141	}
   142	
   143	static void mv_cesa_ablkcipher_step(struct crypto_async_request *req)
   144	{
   145		struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
   146		struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
   147	
   148		if (creq->req.base.type == CESA_DMA_REQ)
   149			mv_cesa_dma_step(&creq->req.dma);
   150		else
   151			mv_cesa_ablkcipher_std_step(ablkreq);
   152	}
   153	
   154	static inline void
   155	mv_cesa_ablkcipher_dma_prepare(struct ablkcipher_request *req)
   156	{
   157		struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
   158		struct mv_cesa_tdma_req *dreq = &creq->req.dma;
   159	
   160		mv_cesa_dma_prepare(dreq, dreq->base.engine);
   161	}
   162	
   163	static inline void
   164	mv_cesa_ablkcipher_std_prepare(struct ablkcipher_request *req)
   165	{
   166		struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
   167		struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
   168		struct mv_cesa_engine *engine = sreq->base.engine;
   169	
   170		sreq->size = 0;
   171		sreq->offset = 0;
   172		mv_cesa_adjust_op(engine, &sreq->op);
   173		memcpy(engine->sram, &sreq->op, sizeof(sreq->op));
   174	}
   175	
   176	static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
   177						      struct mv_cesa_engine *engine)
   178	{
   179		struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
   180		struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
   181	
   182		creq->req.base.engine = engine;
   183	
   184		if (creq->req.base.type == CESA_DMA_REQ)
   185			mv_cesa_ablkcipher_dma_prepare(ablkreq);
   186		else
   187			mv_cesa_ablkcipher_std_prepare(ablkreq);
   188	}
   189	
   190	static inline void
   191	mv_cesa_ablkcipher_req_cleanup(struct crypto_async_request *req)
   192	{
   193		struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
   194	
   195		mv_cesa_ablkcipher_cleanup(ablkreq);
   196	}
   197	
   198	static const struct mv_cesa_req_ops mv_cesa_ablkcipher_req_ops = {
   199		.step = mv_cesa_ablkcipher_step,
   200		.process = mv_cesa_ablkcipher_process,
   201		.prepare = mv_cesa_ablkcipher_prepare,
   202		.cleanup = mv_cesa_ablkcipher_req_cleanup,
   203	};
   204	
   205	static int mv_cesa_ablkcipher_cra_init(struct crypto_tfm *tfm)
   206	{
   207		struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(tfm);
   208	
   209		ctx->base.ops = &mv_cesa_ablkcipher_req_ops;
   210	
   211		tfm->crt_ablkcipher.reqsize = sizeof(struct mv_cesa_ablkcipher_req);
   212	
   213		return 0;
   214	}
   215	
   216	static int mv_cesa_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
   217				      unsigned int len)
   218	{
   219		struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
   220		struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(tfm);
   221		int remaining;
   222		int offset;
   223		int ret;
   224		int i;
   225	
   226		ret = crypto_aes_expand_key(&ctx->aes, key, len);
   227		if (ret) {
   228			crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
   229			return ret;
   230		}
   231	
   232		remaining = (ctx->aes.key_length - 16) / 4;
   233		offset = ctx->aes.key_length + 24 - remaining;
   234		for (i = 0; i < remaining; i++)
   235			ctx->aes.key_dec[4 + i] =
   236				cpu_to_le32(ctx->aes.key_enc[offset + i]);
   237	
   238		return 0;
   239	}
   240	
   241	static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
   242					const struct mv_cesa_op_ctx *op_templ)
   243	{
   244		struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
   245		gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
   246			      GFP_KERNEL : GFP_ATOMIC;
   247		struct mv_cesa_tdma_req *dreq = &creq->req.dma;
   248		struct mv_cesa_ablkcipher_dma_iter iter;
   249		struct mv_cesa_tdma_chain chain;
   250		bool skip_ctx = false;
   251		int ret;
   252	
   253		dreq->base.type = CESA_DMA_REQ;
   254		dreq->chain.first = NULL;
   255		dreq->chain.last = NULL;
   256	
   257		if (req->src != req->dst) {
   258			ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
   259					 DMA_TO_DEVICE);
   260			if (!ret)
   261				return -ENOMEM;
   262	
   263			ret = dma_map_sg(cesa_dev->dev, req->dst, creq->dst_nents,
   264					 DMA_FROM_DEVICE);
   265			if (!ret) {
   266				ret = -ENOMEM;
   267				goto err_unmap_src;
   268			}
   269		} else {
   270			ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
   271					 DMA_BIDIRECTIONAL);
   272			if (!ret)
   273				return -ENOMEM;
   274		}
   275	
   276		mv_cesa_tdma_desc_iter_init(&chain);
   277		mv_cesa_ablkcipher_req_iter_init(&iter, req);
   278	
   279		do {
   280			struct mv_cesa_op_ctx *op;
   281	
   282			op = mv_cesa_dma_add_op(&chain, op_templ, skip_ctx, flags);
   283			if (IS_ERR(op)) {
   284				ret = PTR_ERR(op);
   285				goto err_free_tdma;
   286			}
   287			skip_ctx = true;
   288	
   289			mv_cesa_set_crypt_op_len(op, iter.base.op_len);
   290	
   291			/* Add input transfers */
   292			ret = mv_cesa_dma_add_op_transfers(&chain, &iter.base,
   293							   &iter.src, flags);
   294			if (ret)
   295				goto err_free_tdma;
   296	
   297			/* Add dummy desc to launch the crypto operation */
 > 298			ret = mv_cesa_dma_add_dummy_launch(&chain, flags);
   299			if (ret)
   300				goto err_free_tdma;
   301	

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
