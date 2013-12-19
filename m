From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: randconfig build error with next-20131210, in drivers/crypto/ccp/ccp-pci.c
Date: Thu, 19 Dec 2013 11:35:09 -0800
Message-ID: <52B34A6D.7010903@infradead.org>
References: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com> <1785749.ip5jsEzFz7@tlendack-t1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Jim Davis <jim.epost@gmail.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1785749.ip5jsEzFz7@tlendack-t1>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 12/10/13 07:34, Tom Lendacky wrote:
>=20
> On Tuesday, December 10, 2013 07:21:36 AM Jim Davis wrote:
>> Building with the attached random configuration file,
>>
>> drivers/crypto/ccp/ccp-pci.c: In function =E2=80=98ccp_get_msix_irqs=
=E2=80=99:
>> drivers/crypto/ccp/ccp-pci.c:44:20: error: array type has incomplete
>> element type
>> drivers/crypto/ccp/ccp-pci.c:48:18: error: negative width in bit-fie=
ld
>> =E2=80=98<anonymous>=E2=80=99
>> drivers/crypto/ccp/ccp-pci.c:51:2: error: implicit declaration of
>> function =E2=80=98pci_enable_msix=E2=80=99 [-Werror=3Dimplicit-funct=
ion-declaration]
>> drivers/crypto/ccp/ccp-pci.c:76:2: error: implicit declaration of
>> function =E2=80=98pci_disable_msix=E2=80=99 [-Werror=3Dimplicit-func=
tion-declaration]
>> drivers/crypto/ccp/ccp-pci.c:44:20: warning: unused variable
>> =E2=80=98msix_entry=E2=80=99 [-Wunused-variable]
>> drivers/crypto/ccp/ccp-pci.c: In function =E2=80=98ccp_get_msi_irq=E2=
=80=99:
>> drivers/crypto/ccp/ccp-pci.c:89:2: error: implicit declaration of
>> function =E2=80=98pci_enable_msi=E2=80=99 [-Werror=3Dimplicit-functi=
on-declaration]
>> drivers/crypto/ccp/ccp-pci.c:102:2: error: implicit declaration of
>> function =E2=80=98pci_disable_msi=E2=80=99 [-Werror=3Dimplicit-funct=
ion-declaration]
>> cc1: some warnings being treated as errors
>> make[3]: *** [drivers/crypto/ccp/ccp-pci.o] Error 1
>=20
> Thanks for finding this, I'll update to the Kconfig to add PCI to
> the 'depends on' statement.

Tom,

Can you get this patch and the HW_RANDOM patch merged into linux-next, =
please?
linux-next builds are still failing for both of these reasons.

thanks,
--=20
~Randy
