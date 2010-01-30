From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: device driver for hardware encryption
Date: Sat, 30 Jan 2010 15:54:12 +0100
Message-ID: <20100130145412.GA8508@Chamillionaire.breakpoint.cc>
References: <f3566d61001280112i7d125852l1cd0a6b241ec33e3@mail.gmail.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Bai Shuwei <baishuwei@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33001 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab0A3OyO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jan 2010 09:54:14 -0500
Content-Disposition: inline
In-Reply-To: <f3566d61001280112i7d125852l1cd0a6b241ec33e3@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Bai Shuwei | 2010-01-28 17:12:46 [+0800]:

>   When I add the hardware device driver for crypto, i get the bellow
>error information. My kernel is 2.6.26
>
>[  319.938922] Call Trace:
>[  319.938926]  [<ffffffff80427cd4>] schedule+0x95/0x635
>[  319.938934]  [<ffffffffa0eb629b>] :libfpga:fpga_dma_open+0xa5/0xab
>[  319.938941]  [<ffffffffa0eb67ea>] :libfpga:fpga_dma_block_read+0x12b/0x167
>[  319.938945]  [<ffffffff802461c5>] autoremove_wake_function+0x0/0x2e
>[  319.938954]  [<ffffffffa039a248>] :dsi_aes:dsi_aes_crypt+0x1db/0x24b
>[  319.938960]  [<ffffffffa03a832a>] :cbc:crypto_cbc_encrypt+0xe6/0x138
>[  319.938964]  [<ffffffffa039e043>] :aes_generic:aes_encrypt+0x0/0x21
>[  319.938980]  [<ffffffffa0384f6f>] :crypto_blkcipher:async_encrypt+0x35/0x3a
That looks wrong from the implementation POV: If your FPGA is doing aes
in CBC mode you shouldn't hack it into aes_generic.c or cbc.c but
implement your own driver with a higher priority.

>I think it is happed when calling the
>wait_event_interruptible(fdev->wait) routine, but i don't know how to
>fix it. Hope can get you help. Thanks!
>
>The encryption calling tree and irq handler tree showed in bellow
>
>/* ecryption callint tree */
>aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>|-->dsi_aes_crypt((unsigned int *)in, (unsigned int *) out);
>   |-->do_crypt
>      |-->down_interruptible(&fpga->sem)
>           fpga_dma_block_write()
>           |--> fpga_dma_block_transfer(base, pcie_addr, local_addr,
>size, flag | FPGA_DMA_READ_FLAG); /*write data to hardware */
>                |-->wait_event_interruptible(fdev->wait) /* waiting event*/
>          up()

This isn't helping. Please look at a few drivers which use DMA to
transfer the data and use hardware encryption. Examples are:
- drivers/crypto/talitos.c
- drivers/crypto/hifn_795x.c

>Best Regards
>
>Bai Shuwei

Sebastian
