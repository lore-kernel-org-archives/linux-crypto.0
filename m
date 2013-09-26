From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Thu, 26 Sep 2013 14:07:33 +0200
Message-ID: <201309261407.33923.marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de> <1380194306-5243-2-git-send-email-marex@denx.de> <CAOMZO5AU_R5aeHKbkGRGuyXsVOVdUwdF5oZXdEZZYs442nFnEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:46904 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab3IZMHg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 08:07:36 -0400
In-Reply-To: <CAOMZO5AU_R5aeHKbkGRGuyXsVOVdUwdF5oZXdEZZYs442nFnEA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Fabio Estevam,

> Hi Marek,
> 
> On Thu, Sep 26, 2013 at 8:18 AM, Marek Vasut <marex@denx.de> wrote:
> > Add support for the MXS DCP block. The driver currently supports
> > SHA-1/SHA-256 hashing and AES-128 CBC/ECB modes. The non-standard
> > CRC32 is not yet supported.
> > 
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > ---
> > 
> >  drivers/crypto/Kconfig   |   17 +
> >  drivers/crypto/Makefile  |    1 +
> >  drivers/crypto/mxs-dcp.c | 1082
> >  ++++++++++++++++++++++++++++++++++++++++++++++
> 
> What about the existing DCP driver at drivers/crypto/dcp.c ?

I was not aware of that one.

> Why do we need to have two drivers for the same IP block? It looks
> confusing to have both.

Sure, I agree. I reviewed the one in mainline just now and I see some 
deficiencies of the dcp.c driver:

1) It only supports AES_CBC (mine does support AES_ECB, AES_CBC, SHA1 and SH256)
2) The driver was apparently never ran behind anyone working with MXS. ie.:
   -> Restarting the DCP block is not done via mxs_reset_block()
   -> The DT name is not "fsl,dcp" or "fsl,mxs-dcp" as other MXS drivers
3) What are those ugly new IOCTLs in the dcp.c driver?
4) The VMI IRQ is never used, yet it even calls the IRQ handler, this is bogus
   -> The DCP always triggers the dcp_irq upon DMA completion
   -> VMI IRQ is not handled in the handler at all as I see it
5) The IRQ handler can't use usual completion() in the driver because that'd 
trigger "scheduling while atomic" oops, yes?

Finally, because the dcp.c driver only supports AES128 CBC, it depends on kernel 
_always_ passing the DCP scatterlist such that each of it's elements is 16-bytes 
long. If each of the elements is 16 bytes, there is no problem and the DCP will 
operate correctly. That is because the DCP has the following limitations:

-> For AES128, each buffer in the DMA chain must be multiple of 16 bytes.
-> For SHA1/SHA256, each buffer in the DMA chain must by multiple of 64 bytes 
BUT only the last buffer in the DMA chain can be shorter.

So, in the AES128 case, if the hardware is passed two (4 bytes + 12 bytes for 
example) DMA descriptors instead of single 16 bytes descriptor, the DCP will 
simply stall or produce incorrect result. This can happen if the user of the 
async crypto API passes such a scatterlist.

It is true this is not caught by the in-kernel crypto tests, because they mostly 
trigger the software fallback in this driver, since this driver only supports 16 
byte key (klen == 16 , see crypto/testmgr.h). It can be triggered by modifying 
the crypto tests so that they pass two buffers, multiple of 16 bytes in total, 
but each of them not multiple of 16 bytes.

I ran into many such problems when I was developing this driver I submitted 
here, I managed to trigger those by running the Cryptodev [1] tests [2] against 
this driver as well as testing the performance of this driver via 
Cryptodev/OpenSSL combination:

$ openssl speed sha1
$ openssl speed sha256
$ openssl speed aes-128-cbc

I also measured the performance via OpenSSL encryption/decryption. On larger 
files, the performance of encryption/decryption via DCP, even with fixups for 
unaligned buffers and the overhead of userspace-kernel-userspace switches due to 
cryptodev is still higher than software implementation:

$ time openssl enc -aes-128-ecb -in $IFILE -out $OFILE -k "test" -nosalt
$ time openssl enc -d -aes-128-ecb -in $OFILE -out $DFILE -k "test" -nosalt

Also, since OpenSSH uses OpenSSL, this helped my testing too.

[1] http://cryptodev-linux.org/
[2] https://github.com/nmav/cryptodev-linux/tree/master/tests

Best regards,
Marek Vasut
