From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: randconfig build error with next-20131210, in drivers/crypto/ccp/ccp-pci.c
Date: Tue, 10 Dec 2013 09:34:48 -0600
Message-ID: <1785749.ip5jsEzFz7@tlendack-t1>
References: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	<linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jim Davis <jim.epost@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On Tuesday, December 10, 2013 07:21:36 AM Jim Davis wrote:
> Building with the attached random configuration file,
>=20
> drivers/crypto/ccp/ccp-pci.c: In function =E2=80=98ccp_get_msix_irqs=E2=
=80=99:
> drivers/crypto/ccp/ccp-pci.c:44:20: error: array type has incomplete
> element type
> drivers/crypto/ccp/ccp-pci.c:48:18: error: negative width in bit-fiel=
d
> =E2=80=98<anonymous>=E2=80=99
> drivers/crypto/ccp/ccp-pci.c:51:2: error: implicit declaration of
> function =E2=80=98pci_enable_msix=E2=80=99 [-Werror=3Dimplicit-functi=
on-declaration]
> drivers/crypto/ccp/ccp-pci.c:76:2: error: implicit declaration of
> function =E2=80=98pci_disable_msix=E2=80=99 [-Werror=3Dimplicit-funct=
ion-declaration]
> drivers/crypto/ccp/ccp-pci.c:44:20: warning: unused variable
> =E2=80=98msix_entry=E2=80=99 [-Wunused-variable]
> drivers/crypto/ccp/ccp-pci.c: In function =E2=80=98ccp_get_msi_irq=E2=
=80=99:
> drivers/crypto/ccp/ccp-pci.c:89:2: error: implicit declaration of
> function =E2=80=98pci_enable_msi=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
> drivers/crypto/ccp/ccp-pci.c:102:2: error: implicit declaration of
> function =E2=80=98pci_disable_msi=E2=80=99 [-Werror=3Dimplicit-functi=
on-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/crypto/ccp/ccp-pci.o] Error 1

Thanks for finding this, I'll update to the Kconfig to add PCI to
the 'depends on' statement.

Tom
