Return-Path: <SRS0=pvly=O5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:12096
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730527AbeLTV1W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Dec 2018 16:27:22 -0500
From: Horia Geanta <horia.geanta@nxp.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/qi2 - add a CRYPTO_DEV_FSL_CAAM dependency
Date: Thu, 20 Dec 2018 21:27:16 +0000
Message-ID: <VI1PR0402MB3485B39F40CFFDED08D8701698BF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20181220152815.3613164-1-arnd@arndb.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/20/2018 5:28 PM, Arnd Bergmann wrote:=0A=
> My previous bugfix was incomplete, we still have a broken kernel=0A=
> with CRYPTO_DEV_FSL_CAAM=3Dm and CRYPTO_DEV_FSL_DPAA2_CAAM=3Dy:=0A=
> =0A=
> drivers/crypto/caam/caamalg_desc.o: In function `cnstr_shdsc_aead_null_en=
cap':=0A=
> caamalg_desc.c:(.text+0x14): undefined reference to `caam_little_end'=0A=
> drivers/crypto/caam/caamalg_desc.o: In function `cnstr_shdsc_aead_null_en=
cap':=0A=
> caamalg_desc.c:(.text+0x310): undefined reference to `caam_imx'=0A=
> caamalg_desc.c:(.text+0x4a8): undefined reference to `caam_little_end'=0A=
> drivers/crypto/caam/caamalg_desc.o: In function `cnstr_shdsc_aead_null_en=
cap':=0A=
> caamalg_desc.c:(.text+0x664): undefined reference to `caam_imx'=0A=
> =0A=
> Everything is fine for the other combinations: if both are loadable=0A=
> modules, or both are built-in, the flags work as expected, also if=0A=
> only one of the two is enabled.=0A=
> =0A=
> Add a dependency to enforce using one of the working configurations.=0A=
> Overall, I'm still not happy with that dependency, but for now=0A=
> it documents what the code requires.=0A=
> =0A=
Thanks Arnd.=0A=
This indeed solves the issue, but as you mentioned won't allow for=0A=
CRYPTO_DEV_FSL_DPAA2_CAAM=3Dy when CRYPTO_DEV_FSL_CAAM=3Dm.=0A=
=0A=
I think a better solution is the following:=0A=
=0A=
-- >8 --=0A=
Subject: [PATCH] crypto: caam - move shared symbols in a common location=0A=
=0A=
There are several issues with symbols shared b/w:=0A=
-caam/jr and caam/qi drivers on one hand=0A=
-caam/qi2 driver on the other hand=0A=
=0A=
Commit 52813ab24959 ("crypto: caam/qi2 - avoid double export") fixed=0A=
some of them, however compilation still fails for CRYPTO_DEV_FSL_CAAM=3Dm=
=0A=
and CRYPTO_DEV_FSL_DPAA2_CAAM=3Dy.=0A=
=0A=
Another issue is related to dependency cycles reported by depmod when=0A=
CRYPTO_DEV_FSL_CAAM=3Dn and CRYPTO_DEV_FSL_DPAA2_CAAM=3Dm, as mentioned in=
=0A=
82c7b351be3f ("Revert "arm64: defconfig: Enable FSL_MC_BUS and FSL_MC_DPIO"=
")=0A=
=0A=
To fix all these, move the symbols shared by these drivers in a common=0A=
location. The only existing possibility is error.c file (note that naming=
=0A=
doesn't help and should eventually change).=0A=
=0A=
Fixes: 52813ab24959 ("crypto: caam/qi2 - avoid double export")=0A=
Reported-by: Arnd Bergmann <arnd@arndb.de>=0A=
Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
---=0A=
 drivers/crypto/caam/caamalg_qi2.c | 7 -------=0A=
 drivers/crypto/caam/ctrl.c        | 4 ----=0A=
 drivers/crypto/caam/error.c       | 6 ++++++=0A=
 3 files changed, 6 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamal=
g_qi2.c=0A=
index 425d5d974613..cc59814afd29 100644=0A=
--- a/drivers/crypto/caam/caamalg_qi2.c=0A=
+++ b/drivers/crypto/caam/caamalg_qi2.c=0A=
@@ -25,13 +25,6 @@=0A=
 #define CAAM_MAX_KEY_SIZE	(AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE + \=
=0A=
 				 SHA512_DIGEST_SIZE * 2)=0A=
=0A=
-#if !IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM)=0A=
-bool caam_little_end;=0A=
-EXPORT_SYMBOL(caam_little_end);=0A=
-bool caam_imx;=0A=
-EXPORT_SYMBOL(caam_imx);=0A=
-#endif=0A=
-=0A=
 /*=0A=
  * This is a a cache of buffers, from which the users of CAAM QI driver=0A=
  * can allocate short buffers. It's speedier than doing kmalloc on the hot=
path.=0A=
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
index 16bbc72f041a..14fb09223156 100644=0A=
--- a/drivers/crypto/caam/ctrl.c=0A=
+++ b/drivers/crypto/caam/ctrl.c=0A=
@@ -18,12 +18,8 @@=0A=
 #include "desc_constr.h"=0A=
 #include "ctrl.h"=0A=
=0A=
-bool caam_little_end;=0A=
-EXPORT_SYMBOL(caam_little_end);=0A=
 bool caam_dpaa2;=0A=
 EXPORT_SYMBOL(caam_dpaa2);=0A=
-bool caam_imx;=0A=
-EXPORT_SYMBOL(caam_imx);=0A=
=0A=
 #ifdef CONFIG_CAAM_QI=0A=
 #include "qi.h"=0A=
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c=0A=
index 7e8d690f2827..21a70fd32f5d 100644=0A=
--- a/drivers/crypto/caam/error.c=0A=
+++ b/drivers/crypto/caam/error.c=0A=
@@ -50,6 +50,12 @@ void caam_dump_sg(const char *level, const char *prefix_=
str,=0A=
int prefix_type,=0A=
 #endif /* DEBUG */=0A=
 EXPORT_SYMBOL(caam_dump_sg);=0A=
=0A=
+bool caam_little_end;=0A=
+EXPORT_SYMBOL(caam_little_end);=0A=
+=0A=
+bool caam_imx;=0A=
+EXPORT_SYMBOL(caam_imx);=0A=
+=0A=
 static const struct {=0A=
 	u8 value;=0A=
 	const char *error_text;=0A=
-- =0A=
2.16.2=0A=
