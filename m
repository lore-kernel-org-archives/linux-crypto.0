From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH -next] Re: randconfig build error with next-20131210, in drivers/crypto/ccp/ccp-pci.c
Date: Fri, 20 Dec 2013 09:32:32 -0600
Message-ID: <8808826.01Y7Jbimcb@tlendack-t1>
References: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com> <1785749.ip5jsEzFz7@tlendack-t1> <52B34A6D.7010903@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-next@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58121 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab3LTPcj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Dec 2013 10:32:39 -0500
In-Reply-To: <52B34A6D.7010903@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Thursday, December 19, 2013 11:35:09 AM Randy Dunlap wrote:
> On 12/10/13 07:34, Tom Lendacky wrote:
> >=20
> > On Tuesday, December 10, 2013 07:21:36 AM Jim Davis wrote:
> >> Building with the attached random configuration file,
> >>
> >> drivers/crypto/ccp/ccp-pci.c: In function =E2=80=98ccp_get_msix_ir=
qs=E2=80=99:
> >> drivers/crypto/ccp/ccp-pci.c:44:20: error: array type has incomple=
te
> >> element type
> >> drivers/crypto/ccp/ccp-pci.c:48:18: error: negative width in bit-f=
ield
> >> =E2=80=98<anonymous>=E2=80=99
> >> drivers/crypto/ccp/ccp-pci.c:51:2: error: implicit declaration of
> >> function =E2=80=98pci_enable_msix=E2=80=99 [-Werror=3Dimplicit-fun=
ction-declaration]
> >> drivers/crypto/ccp/ccp-pci.c:76:2: error: implicit declaration of
> >> function =E2=80=98pci_disable_msix=E2=80=99 [-Werror=3Dimplicit-fu=
nction-declaration]
> >> drivers/crypto/ccp/ccp-pci.c:44:20: warning: unused variable
> >> =E2=80=98msix_entry=E2=80=99 [-Wunused-variable]
> >> drivers/crypto/ccp/ccp-pci.c: In function =E2=80=98ccp_get_msi_irq=
=E2=80=99:
> >> drivers/crypto/ccp/ccp-pci.c:89:2: error: implicit declaration of
> >> function =E2=80=98pci_enable_msi=E2=80=99 [-Werror=3Dimplicit-func=
tion-declaration]
> >> drivers/crypto/ccp/ccp-pci.c:102:2: error: implicit declaration of
> >> function =E2=80=98pci_disable_msi=E2=80=99 [-Werror=3Dimplicit-fun=
ction-declaration]
> >> cc1: some warnings being treated as errors
> >> make[3]: *** [drivers/crypto/ccp/ccp-pci.o] Error 1
> >=20
> > Thanks for finding this, I'll update to the Kconfig to add PCI to
> > the 'depends on' statement.
>=20
> Tom,
>=20
> Can you get this patch and the HW_RANDOM patch merged into linux-next=
, please?
> linux-next builds are still failing for both of these reasons.

Please consider the following patch that addresses some randconfig
build errors being experienced in the linux-next tree.  This patch
has already been accepted in the cryptodev-2.6 tree with a commit
id of d5aa80952aba9071b50a74c8daf7feb1caa2fd8c.

---
=46rom: Tom Lendacky <thomas.lendacky@amd.com>

crypto: ccp - CCP Kconfig fixes

Update the Kconfig to include PCI on the 'depends on'
and add 'select HW_RANDOM' to insure the necessary PCI
and HW_RANDOM functions are available/included in the
build.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig     |    2 +-
 drivers/crypto/ccp/Kconfig |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4954d75..9dee00f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -401,7 +401,7 @@ config CRYPTO_DEV_ATMEL_SHA
=20
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
-	depends on X86
+	depends on X86 && PCI
 	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 335ed5c..7639ffc 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -2,6 +2,7 @@ config CRYPTO_DEV_CCP_DD
 	tristate "Cryptographic Coprocessor device driver"
 	depends on CRYPTO_DEV_CCP
 	default m
+	select HW_RANDOM
 	help
 	  Provides the interface to use the AMD Cryptographic Coprocessor
 	  which can be used to accelerate or offload encryption operations


>=20
> thanks,
>=20
