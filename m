Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE030C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 06:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F42D600EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 06:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhJ2Gok (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 02:44:40 -0400
Received: from pv50p00im-ztdg10011901.me.com ([17.58.6.50]:57609 "EHLO
        pv50p00im-ztdg10011901.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232055AbhJ2Gok (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 02:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1635489731;
        bh=q7k5mhE9I022huI+BNBDsLwxWAbA4hEUlL+gJFi5pB4=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=sJRfoxMtuHF9lJytCqKdO9KyMkTAq/XH8Jhj/L8nlAcH53Vt8BN4bDqTyjNupZiWS
         hyXJB2rNV7TKNjw5zxmdOsRhqFDx+KyoZQwsOmOp4RaK+fgg5JnOfZZlvBa1JhmtjR
         eNYMwsXyQ5spcTCD6pxE6kxIip6056FvTLn3n5rJdCO76qaMipgFrJpC+8eVmmkjgD
         Kj+cvzFGbnInnQIYHNUtNJ9V0RqtuyMtXFKKSvoYx3fenePUWQ7rKaEEO9GGdo/kvs
         U2vUWfZOqR6XO76IIfZYEOtPs3UUpjX3psR0FcuJK/Qpn7tsPb0fooeNTvV8m4ebZs
         XGnGFSjmSP74g==
Received: from [10.81.0.6] (unknown [85.203.23.187])
        by pv50p00im-ztdg10011901.me.com (Postfix) with ESMTPSA id 4A234800230;
        Fri, 29 Oct 2021 06:42:01 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: Re: [PATCH v3 2/2] crypto: mtk-eip93 - Add Mediatek EIP-93 crypto
 engine
From:   Richard van Schagen <vschagen@icloud.com>
In-Reply-To: <202110281412.4M0edOjI-lkp@intel.com>
Date:   Fri, 29 Oct 2021 14:41:53 +0800
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FECCFD1C-99CA-4DF7-9684-526D5385B2CB@icloud.com>
References: <20211027091329.3093641-3-vschagen@icloud.com>
 <202110281412.4M0edOjI-lkp@intel.com>
To:     linux-crypto@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.7)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.790
 definitions=2021-10-29_01:2021-10-26,2021-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2110290036
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

Before I send another version of this patch I have one question:

I am seeing /warnings from arch/riscv/include/asm/io.h

In my Kconfig I have: depends on SOC_MT7621 || COMPILE_TEST=20

I need to keep the include/linux/dma-mapping.h so should I remove=20
the COMPILE_TEST or can I safely ignore those warnings?

Thanks,
Richard van Schagen


> On 28 Oct 2021, at 14:27, kernel test robot <lkp@intel.com> wrote:
>=20
> Hi Richard,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on herbert-cryptodev-2.6/master]
> [also build test WARNING on herbert-crypto-2.6/master robh/for-next =
v5.15-rc7 next-20211027]
> [If your patch is applied to the wrong git tree, kindly drop us a =
note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>=20
> url:    =
https://github.com/0day-ci/linux/commits/Richard-van-Schagen/Enable-the-Me=
diatek-EIP-93-crypto-engine/20211027-171429
> base:   =
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git =
master
> config: riscv-randconfig-r031-20211027 (attached as .config)
> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project =
5db7568a6a1fcb408eb8988abdaff2a225a8eb72)
> reproduce (this is a W=3D1 build):
>        wget =
https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross =
-O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # install riscv cross compiling tool for clang build
>        # apt-get install binutils-riscv64-linux-gnu
>        # =
https://github.com/0day-ci/linux/commit/b4ea2578718d77c7cbac42427a511182d9=
1ac5f1
>        git remote add linux-review https://github.com/0day-ci/linux
>        git fetch --no-tags linux-review =
Richard-van-Schagen/Enable-the-Mediatek-EIP-93-crypto-engine/20211027-1714=
29
>        git checkout b4ea2578718d77c7cbac42427a511182d91ac5f1
>        # save the attached .config to linux build tree
>        COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross =
W=3D1 ARCH=3Driscv=20
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
>   In file included from drivers/crypto/mtk-eip93/eip93-common.c:15:
>   In file included from include/linux/dma-mapping.h:10:
>   In file included from include/linux/scatterlist.h:9:
>   In file included from arch/riscv/include/asm/io.h:136:
>   include/asm-generic/io.h:464:31: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           val =3D __raw_readb(PCI_IOBASE + addr);
>                             ~~~~~~~~~~ ^
>   include/asm-generic/io.h:477:61: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           val =3D __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE =
+ addr));
>                                                           ~~~~~~~~~~ ^
>   include/uapi/linux/byteorder/little_endian.h:36:51: note: expanded =
from macro '__le16_to_cpu'
>   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
>                                                     ^
>   In file included from drivers/crypto/mtk-eip93/eip93-common.c:15:
>   In file included from include/linux/dma-mapping.h:10:
>   In file included from include/linux/scatterlist.h:9:
>   In file included from arch/riscv/include/asm/io.h:136:
>   include/asm-generic/io.h:490:61: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           val =3D __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE =
+ addr));
>                                                           ~~~~~~~~~~ ^
>   include/uapi/linux/byteorder/little_endian.h:34:51: note: expanded =
from macro '__le32_to_cpu'
>   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
>                                                     ^
>   In file included from drivers/crypto/mtk-eip93/eip93-common.c:15:
>   In file included from include/linux/dma-mapping.h:10:
>   In file included from include/linux/scatterlist.h:9:
>   In file included from arch/riscv/include/asm/io.h:136:
>   include/asm-generic/io.h:501:33: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           __raw_writeb(value, PCI_IOBASE + addr);
>                               ~~~~~~~~~~ ^
>   include/asm-generic/io.h:511:59: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + =
addr);
>                                                         ~~~~~~~~~~ ^
>   include/asm-generic/io.h:521:59: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + =
addr);
>                                                         ~~~~~~~~~~ ^
>   include/asm-generic/io.h:1024:55: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
>                                                     ~~~~~~~~~~ ^
>   drivers/crypto/mtk-eip93/eip93-common.c:282:6: warning: no previous =
prototype for function 'mtk_set_saRecord' [-Wmissing-prototypes]
>   void mtk_set_saRecord(struct saRecord_s *saRecord, const unsigned =
int keylen,
>        ^
>   drivers/crypto/mtk-eip93/eip93-common.c:282:1: note: declare =
'static' if the function is not intended to be used outside of this =
translation unit
>   void mtk_set_saRecord(struct saRecord_s *saRecord, const unsigned =
int keylen,
>   ^
>   static=20
>   drivers/crypto/mtk-eip93/eip93-common.c:527:18: warning: cast to =
smaller integer type 'u32' (aka 'unsigned int') from 'const u8 *' (aka =
'const unsigned char *') [-Wpointer-to-int-cast]
>           if (!IS_ALIGNED((u32)reqiv, rctx->ivsize) || =
IS_RFC3686(flags)) {
>                           ^~~~~~~~~~
>   include/linux/align.h:13:30: note: expanded from macro 'IS_ALIGNED'
>   #define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - =
1)) =3D=3D 0)
>                                              ^
>   drivers/crypto/mtk-eip93/eip93-common.c:527:18: warning: cast to =
smaller integer type 'u32' (aka 'unsigned int') from 'const u8 *' (aka =
'const unsigned char *') [-Wpointer-to-int-cast]
>           if (!IS_ALIGNED((u32)reqiv, rctx->ivsize) || =
IS_RFC3686(flags)) {
>                           ^~~~~~~~~~
>   include/linux/align.h:13:44: note: expanded from macro 'IS_ALIGNED'
>   #define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - =
1)) =3D=3D 0)
>                                                            ^
>   drivers/crypto/mtk-eip93/eip93-common.c:593:19: warning: cast to =
smaller integer type 'u32' (aka 'unsigned int') from 'struct =
crypto_async_request *' [-Wpointer-to-int-cast]
>           cdesc.arc4Addr =3D (u32)async;
>                            ^~~~~~~~~~
>   drivers/crypto/mtk-eip93/eip93-common.c:693:5: warning: no previous =
prototype for function 'mtk_skcipher_send_req' [-Wmissing-prototypes]
>   int mtk_skcipher_send_req(struct crypto_async_request *async)
>       ^
>   drivers/crypto/mtk-eip93/eip93-common.c:693:1: note: declare =
'static' if the function is not intended to be used outside of this =
translation unit
>   int mtk_skcipher_send_req(struct crypto_async_request *async)
>   ^
>   static=20
>   drivers/crypto/mtk-eip93/eip93-common.c:709:6: warning: no previous =
prototype for function 'mtk_skcipher_handle_result' =
[-Wmissing-prototypes]
>   void mtk_skcipher_handle_result(struct mtk_device *mtk,
>        ^
>   drivers/crypto/mtk-eip93/eip93-common.c:709:1: note: declare =
'static' if the function is not intended to be used outside of this =
translation unit
>   void mtk_skcipher_handle_result(struct mtk_device *mtk,
>   ^
>   static=20
>>> drivers/crypto/mtk-eip93/eip93-common.c:725:5: warning: no previous =
prototype for function 'mtk_authenc_setkey' [-Wmissing-prototypes]
>   int mtk_authenc_setkey(struct crypto_shash *cshash, struct =
saRecord_s *sa,
>       ^
>   drivers/crypto/mtk-eip93/eip93-common.c:725:1: note: declare =
'static' if the function is not intended to be used outside of this =
translation unit
>   int mtk_authenc_setkey(struct crypto_shash *cshash, struct =
saRecord_s *sa,
>   ^
>   static=20
>   14 warnings generated.
> --
>   In file included from drivers/crypto/mtk-eip93/eip93-aead.c:24:
>   In file included from include/linux/dma-mapping.h:10:
>   In file included from include/linux/scatterlist.h:9:
>   In file included from arch/riscv/include/asm/io.h:136:
>   include/asm-generic/io.h:464:31: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           val =3D __raw_readb(PCI_IOBASE + addr);
>                             ~~~~~~~~~~ ^
>   include/asm-generic/io.h:477:61: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           val =3D __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE =
+ addr));
>                                                           ~~~~~~~~~~ ^
>   include/uapi/linux/byteorder/little_endian.h:36:51: note: expanded =
from macro '__le16_to_cpu'
>   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
>                                                     ^
>   In file included from drivers/crypto/mtk-eip93/eip93-aead.c:24:
>   In file included from include/linux/dma-mapping.h:10:
>   In file included from include/linux/scatterlist.h:9:
>   In file included from arch/riscv/include/asm/io.h:136:
>   include/asm-generic/io.h:490:61: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           val =3D __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE =
+ addr));
>                                                           ~~~~~~~~~~ ^
>   include/uapi/linux/byteorder/little_endian.h:34:51: note: expanded =
from macro '__le32_to_cpu'
>   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
>                                                     ^
>   In file included from drivers/crypto/mtk-eip93/eip93-aead.c:24:
>   In file included from include/linux/dma-mapping.h:10:
>   In file included from include/linux/scatterlist.h:9:
>   In file included from arch/riscv/include/asm/io.h:136:
>   include/asm-generic/io.h:501:33: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           __raw_writeb(value, PCI_IOBASE + addr);
>                               ~~~~~~~~~~ ^
>   include/asm-generic/io.h:511:59: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + =
addr);
>                                                         ~~~~~~~~~~ ^
>   include/asm-generic/io.h:521:59: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + =
addr);
>                                                         ~~~~~~~~~~ ^
>   include/asm-generic/io.h:1024:55: warning: performing pointer =
arithmetic on a null pointer has undefined behavior =
[-Wnull-pointer-arithmetic]
>           return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
>                                                     ~~~~~~~~~~ ^
>>> drivers/crypto/mtk-eip93/eip93-aead.c:30:6: warning: no previous =
prototype for function 'mtk_aead_handle_result' [-Wmissing-prototypes]
>   void mtk_aead_handle_result(struct mtk_device *mtk,
>        ^
>   drivers/crypto/mtk-eip93/eip93-aead.c:30:1: note: declare 'static' =
if the function is not intended to be used outside of this translation =
unit
>   void mtk_aead_handle_result(struct mtk_device *mtk,
>   ^
>   static=20
>>> drivers/crypto/mtk-eip93/eip93-aead.c:49:5: warning: no previous =
prototype for function 'mtk_aead_send_req' [-Wmissing-prototypes]
>   int mtk_aead_send_req(struct crypto_async_request *async)
>       ^
>   drivers/crypto/mtk-eip93/eip93-aead.c:49:1: note: declare 'static' =
if the function is not intended to be used outside of this translation =
unit
>   int mtk_aead_send_req(struct crypto_async_request *async)
>   ^
>   static=20
>>> drivers/crypto/mtk-eip93/eip93-aead.c:152:7: warning: variable 'err' =
is used uninitialized whenever 'if' condition is true =
[-Wsometimes-uninitialized]
>                   if (keys.enckeylen < CTR_RFC3686_NONCE_SIZE)
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/crypto/mtk-eip93/eip93-aead.c:209:9: note: uninitialized use =
occurs here
>           return err;
>                  ^~~
>   drivers/crypto/mtk-eip93/eip93-aead.c:152:3: note: remove the 'if' =
if its condition is always false
>                   if (keys.enckeylen < CTR_RFC3686_NONCE_SIZE)
>                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/crypto/mtk-eip93/eip93-aead.c:145:9: note: initialize the =
variable 'err' to silence this warning
>           int err;
>                  ^
>                   =3D 0
>   10 warnings generated.
>=20
>=20
> vim +/mtk_authenc_setkey +725 drivers/crypto/mtk-eip93/eip93-common.c
>=20
>   708=09
>> 709	void mtk_skcipher_handle_result(struct mtk_device *mtk,
>   710					struct crypto_async_request =
*async,
>   711					int err)
>   712	{
>   713		struct skcipher_request *req =3D =
skcipher_request_cast(async);
>   714		struct mtk_cipher_reqctx *rctx =3D =
skcipher_request_ctx(req);
>   715=09
>   716		mtk_unmap_dma(mtk, rctx, req->src, req->dst);
>   717		mtk_handle_result(mtk, rctx, req->iv);
>   718=09
>   719		skcipher_request_complete(req, err);
>   720	}
>   721	#endif
>   722=09
>   723	#if IS_ENABLED(CONFIG_CRYPTO_DEV_EIP93_HMAC)
>   724	/* basically this is set hmac - key */
>> 725	int mtk_authenc_setkey(struct crypto_shash *cshash, struct =
saRecord_s *sa,
>=20
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> <.config.gz>

