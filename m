From: Stephan Mueller <smueller@chronox.de>
Subject: Re: skcipher
Date: Mon, 02 May 2016 17:33:38 +0200
Message-ID: <2792780.OUI9jL64lE@tauon.atsec.com>
References: <CAKJ7aR5-GbkuFPQkw7DdKJLCKV48LzRY-WUeTeayZkK_h7cTUQ@mail.gmail.com> <1544687.NtFoiUyCFs@tauon.atsec.com> <CAKJ7aR4YrALNdFcwifdfo-Qx8izSpwd_D68UHU_gGjWK8aZjdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Gadre Nayan <gadrenayan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54476 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbcEBPdo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 11:33:44 -0400
In-Reply-To: <CAKJ7aR4YrALNdFcwifdfo-Qx8izSpwd_D68UHU_gGjWK8aZjdQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 2. Mai 2016, 21:00:25 schrieb Gadre Nayan:

Hi Gadre,

> Hi Stephan,
> 
> I checked modinfo aesni_intel:
> filename:       /lib/modules/4.5.0/kernel/arch/x86/crypto/aesni-intel.ko
> alias:          crypto-aes
> alias:          aes
> license:        GPL
> description:    Rijndael (AES) Cipher Algorithm, Intel AES-NI
> instructions optimized
> alias:          crypto-fpu
> alias:          fpu
> srcversion:     55C6346DCF663DDD74D3F13
> alias:          cpu:type:x86,ven*fam*mod*:feature:*0099*
> depends:        xts,aes-i586,lrw,ablk_helper
> intree:         Y
> vermagic:       4.5.0 SMP mod_unload modversions 686
> 
> when I do modprobe crypto-aes,
> modprobe: ERROR: could not insert 'aesni_intel': No such device
> modprobe: ERROR: could not insert 'padlock_aes': No such device

Well, maybe your CPU does not have AES-NI?

Besides, why fiddle around with special implementations? Simply use the 
standard names of, say, "aes" and let the kernel crypto API do its magic to 
find the fastest implementation for your system?
> 
> I have these modules: xts,aes-i586,lrw,ablk_helper loaded as well (
> the dependencies).

Well, a 32 bit system does not have AES-NI support.
> 
> I think I am still missing something. Any hardware feature. Or some
> other module is using some IRQ or region which is not shared.
> 
> Thanks.
> Nayan Gadre.
> 
> On Mon, May 2, 2016 at 11:21 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Montag, 2. Mai 2016, 11:14:01 schrieb Gadre Nayan:
> > 
> > Hi Gadre,
> > 
> >> Hello,
> >> 
> >> I have read the crypto library documentation on chronox.de.
> >> 
> >> I used there sample code for symmetric key cipher operation.
> >> However in the check:
> >> 
> >> skcipher = crypto_alloc_skcipher("cbc-aes-aesni", 0, 0);
> >> if (IS_ERR(skcipher)) {
> >> pr_info("could not allocate skcipher handle\n");
> >> return PTR_ERR(skcipher);
> >> }
> >> 
> >> I get could not allocate skcipher handle.
> >> 
> >> I have loaded all possible related modules for crypto:
> >> lsmod (relevant):
> >> algif_skcipher         32768  0
> >> algif_hash             20480  0
> >> algif_aead             20480  0
> >> af_alg                 24576  3 algif_aead,algif_hash,algif_skcipher
> >> cryptd
> >> ablk_helper.
> >> 
> >> What am I missing here?
> >> 
> >> Also IS_ERR checks if the skcipher value may be <1000, it may include
> >> the NULL check right?.
> > 
> > The allocation of the cipher failed. Please check /proc/crypto whether you
> > have the cipher registered with the kernel crypto API.
> > 
> > The module listing does not show the AESNI cipher module.
> > 
> > Ciao
> > Stephan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
