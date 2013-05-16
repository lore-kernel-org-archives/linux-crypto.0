From: Xiong Zhou <jencce.kernel@gmail.com>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
Date: Thu, 16 May 2013 11:57:48 +0800 (CST)
Message-ID: <alpine.DEB.2.02.1305161152530.31865@M2420>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au> <5193CCEC.7070909@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	jencce.kernel@gmail.com
To: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <5193CCEC.7070909@infradead.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Wed, 15 May 2013, Randy Dunlap wrote:

> On 05/14/13 20:26, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130514:
> > 
> 
> on x86_64:
> 
> crypto/built-in.o: In function `chksum_digest':
> crct10dif.c:(.text+0x2789f): undefined reference to `crc_t10dif_generic'
> crypto/built-in.o: In function `chksum_finup':
> crct10dif.c:(.text+0x278c7): undefined reference to `crc_t10dif_generic'
> crypto/built-in.o: In function `chksum_update':
> crct10dif.c:(.text+0x278ef): undefined reference to `crc_t10dif_generic'
> 
> 
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRC_T10DIF=m
> 
> 
> 
> Full randconfig file is attached.
> 
> 
> -- 
> ~Randy
> 
just try.

From: Xiong Zhou <jencce.kernel@gmail.com>

Try to fix randconfig build error reported by Randy Dunlap:

on x86_64:

crypto/built-in.o: In function `chksum_digest':
crct10dif.c:(.text+0x2789f): undefined reference to `crc_t10dif_generic'
crypto/built-in.o: In function `chksum_finup':
crct10dif.c:(.text+0x278c7): undefined reference to `crc_t10dif_generic'
crypto/built-in.o: In function `chksum_update':
crct10dif.c:(.text+0x278ef): undefined reference to `crc_t10dif_generic'

CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRC_T10DIF=m

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
 crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 25b5209..28655bc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -378,6 +378,7 @@ config CRYPTO_CRC32_PCLMUL
 
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
+	depends on CRC_T10DIF
 	select CRYPTO_HASH
 	help
 	  CRC T10 Data Integrity Field computation is being cast as
