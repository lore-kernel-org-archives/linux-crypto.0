From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 65/80] drivers/pci/quirks.c:843:6: error:
 'struct pci_dev' has no member named 'sriov'
Date: Mon, 5 Sep 2016 17:12:57 +0800
Message-ID: <20160905091257.GA30714@gondor.apana.org.au>
References: <201609040817.Rs5sdqia%fengguang.wu@intel.com>
 <59722569-EC4C-4A31-AB54-B6BF9B8B7A5C@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Ananth Jasty <Ananth.Jasty@cavium.com>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org,
        Omer Khaliq <okhaliq@caviumnetworks.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ananth Jasty <ajasty@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58274 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbcIEJNZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2016 05:13:25 -0400
Content-Disposition: inline
In-Reply-To: <59722569-EC4C-4A31-AB54-B6BF9B8B7A5C@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 03, 2016 at 06:40:27PM -0700, Ananth Jasty wrote:
> As this fix is purely SRIOV related, an ifdef guard for SRIOV support should be sufficient to prevent this header dependency.

Please don't top-post.

> On Sep 3, 2016, at 5:16 PM, kbuild test robot <fengguang.wu@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > head:   10faa8c0d6c3b22466f97713a9533824a2ea1c57
> > commit: 21b5b8eebbae427d7d890b7dd1e43a63aca7c26c [65/80] PCI: quirk fixup for cavium invalid sriov link value.
> > config: arm64-kexec_dev_defconfig (attached as .config)
> > compiler: aarch64-linux-gnu-gcc (Debian 5.4.0-6) 5.4.0 20160609
> > reproduce:
> >        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
> >        chmod +x ~/bin/make.cross
> >        git checkout 21b5b8eebbae427d7d890b7dd1e43a63aca7c26c
> >        # save the attached .config to linux build tree
> >        make.cross ARCH=arm64 
> > 
> > All errors (new ones prefixed by >>):
> > 
> >   drivers/pci/quirks.c: In function 'quirk_cavium_sriov_rnm_link':
> >>> drivers/pci/quirks.c:843:6: error: 'struct pci_dev' has no member named 'sriov'
> >      dev->sriov->link = dev->devfn;
> >         ^
> > 
> > vim +843 drivers/pci/quirks.c
> > 
> >   837	#ifdef CONFIG_ARM64
> >   838	
> >   839	static void quirk_cavium_sriov_rnm_link(struct pci_dev *dev)
> >   840	{
> >   841		/* Fix for improper SRIOV configuration on Cavium cn88xx  RNM device */
> >   842		if (dev->subsystem_device == 0xa118)
> >> 843			dev->sriov->link = dev->devfn;
> >   844	}
> >   845	DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CAVIUM, 0xa018, quirk_cavium_sriov_rnm_link);
> >   846	#endif

---8<---
Subject: PCI: Fix cavium quirk compile failure with PCI_ATS off

The newly added quirk_cavium_sriov_rnm_link doesn't compile if
PCI_ATS is off.  This patch adds a check for PCI_ATS.

Fixes: 21b5b8eebbae ("PCI: quirk fixup for cavium invalid sriov...")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5980aae..7060823 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -834,7 +834,7 @@ static void quirk_amd_ioapic(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_VIPER_7410,	quirk_amd_ioapic);
 #endif /* CONFIG_X86_IO_APIC */
 
-#ifdef CONFIG_ARM64
+#if defined(CONFIG_ARM64) && defined(CONFIG_PCI_ATS)
 
 static void quirk_cavium_sriov_rnm_link(struct pci_dev *dev)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
