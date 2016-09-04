From: Ananth Jasty <ajasty@caviumnetworks.com>
Subject: Re: [cryptodev:master 65/80] drivers/pci/quirks.c:843:6: error: 'struct pci_dev' has no member named 'sriov'
Date: Sat, 3 Sep 2016 18:40:27 -0700
Message-ID: <59722569-EC4C-4A31-AB54-B6BF9B8B7A5C@caviumnetworks.com>
References: <201609040817.Rs5sdqia%fengguang.wu@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Ananth Jasty <Ananth.Jasty@cavium.com>, <kbuild-all@01.org>,
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Omer Khaliq <okhaliq@caviumnetworks.com>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0074.outbound.protection.outlook.com ([104.47.34.74]:60000
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750785AbcIDCQE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Sep 2016 22:16:04 -0400
In-Reply-To: <201609040817.Rs5sdqia%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As this fix is purely SRIOV related, an ifdef guard for SRIOV support =
should be sufficient to prevent this header dependency.

Ananth

On Sep 3, 2016, at 5:16 PM, kbuild test robot <fengguang.wu@intel.com> =
wrote:

> tree:   =
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git =
master
> head:   10faa8c0d6c3b22466f97713a9533824a2ea1c57
> commit: 21b5b8eebbae427d7d890b7dd1e43a63aca7c26c [65/80] PCI: quirk =
fixup for cavium invalid sriov link value.
> config: arm64-kexec_dev_defconfig (attached as .config)
> compiler: aarch64-linux-gnu-gcc (Debian 5.4.0-6) 5.4.0 20160609
> reproduce:
>        wget =
https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/=
make.cross -O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        git checkout 21b5b8eebbae427d7d890b7dd1e43a63aca7c26c
>        # save the attached .config to linux build tree
>        make.cross ARCH=3Darm64=20
>=20
> All errors (new ones prefixed by >>):
>=20
>   drivers/pci/quirks.c: In function 'quirk_cavium_sriov_rnm_link':
>>> drivers/pci/quirks.c:843:6: error: 'struct pci_dev' has no member =
named 'sriov'
>      dev->sriov->link =3D dev->devfn;
>         ^
>=20
> vim +843 drivers/pci/quirks.c
>=20
>   837	#ifdef CONFIG_ARM64
>   838=09
>   839	static void quirk_cavium_sriov_rnm_link(struct pci_dev *dev)
>   840	{
>   841		/* Fix for improper SRIOV configuration on Cavium cn88xx =
 RNM device */
>   842		if (dev->subsystem_device =3D=3D 0xa118)
>> 843			dev->sriov->link =3D dev->devfn;
>   844	}
>   845	DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CAVIUM, 0xa018, =
quirk_cavium_sriov_rnm_link);
>   846	#endif
>=20
> ---
> 0-DAY kernel test infrastructure                Open Source Technology =
Center
> https://lists.01.org/pipermail/kbuild-all                   Intel =
Corporation
> <.config.gz>
