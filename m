From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: Re: [WIP] crypto: add support for Orion5X crypto engine
Date: Wed, 4 Mar 2009 17:35:39 +0100
Message-ID: <20090304163539.GA29206@Chamillionaire.breakpoint.cc>
References: <20090302221058.GA11493@Chamillionaire.breakpoint.cc> <309002C0DA137042828828FC53D7A9347E13354619@IL-MB01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: "linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ronen Shitrit <rshitrit@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52346 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbZCDQfo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Mar 2009 11:35:44 -0500
Content-Disposition: inline
In-Reply-To: <309002C0DA137042828828FC53D7A9347E13354619@IL-MB01.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Ronen Shitrit | 2009-03-04 18:05:12 [+0200]:

>However a SW calculation is also possible.
>Chapter 11.1.4 in [1] says, that the decrypt key is the last 16/24/32 bytes
>created by the expansion algorithm. So I picked the key expand routine
>from generic aes module and just passed the crypto test for decryption
>with a 16 byte long key. The other two key sizes failed. Probably the
>the key slots are different. Currently I have no idea what's wrong.
>
>[Ronen Shitrit] on our driver we also chose the SW calculation WA, I'm not sure why your code fail, but I can refer you to our driver as a reference, maybe you can find it as a good reference also for other issues.
>
>This is an old LSP for the 5182, but the crypto driver supposed to work on the 5182 just fine:
>http://downloads.buffalo.nas-central.org/KBPro_ARM9/GPL/source/linux-2.6.12_lsp.1.10.3.src.tar.gz
>
>Look for aesMakeKey API under arch/arm/mach-mv88fxx81/Soc/cesa/
Oh thanks a lot. I take a look on this.

>I also wanted to point that the crypto engine on the 5182 passed 2 more evolutions after the 5182, which included:
>- Add a dedicated DMA to the crypto unit.
Does this mean that the crypto unit itself is now able to copy data and
I don't have to use the idma for that? That sounds great.

>- Support only one channel.
>- Fix main erratas.
>- Decrease SRAM size to 2K.
>- Add support for chain mode.
I can understand that, since SRAM is not that cheap and with chaining
support it should not matter.

>Maybe you should take those into account in your design to allow support for other crypto versions in the future.
>If you need more details pls check the security chapter on:
>http://www.marvell.com/files/products/embedded_processors/kirkwood/FS_88F6180_9x_6281_OpenSource.pdf
I take a look on this as well.

Sebastian
