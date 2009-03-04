From: Ronen Shitrit <rshitrit@marvell.com>
Subject: RE: [WIP] crypto: add support for Orion5X crypto engine
Date: Wed, 4 Mar 2009 18:05:12 +0200
Message-ID: <309002C0DA137042828828FC53D7A9347E13354619@IL-MB01.marvell.com>
References: <20090302221058.GA11493@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk>
In-Reply-To: <20090302221058.GA11493@Chamillionaire.breakpoint.cc>
Content-Language: en-US
List-Unsubscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=unsubscribe>
List-Archive: <http://lists.arm.linux.org.uk/lurker/list/linux-arm-kernel.html>
List-Post: <mailto:linux-arm-kernel@lists.arm.linux.org.uk>
List-Help: <mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=help>
List-Subscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.arm.linux.org.uk
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk
List-Id: linux-crypto.vger.kernel.org

The only functional part is ecb-aes in encryption mode. The decryption
seems to work in 16 byte key mode. According to the spec [1] the
decryption key is different and has to be computed by the HW.
Chapter 11.1.4 says, that the decryption key is computed by performing a
dummy encrypt operation. This does not alter my key at all. Point 1 on
the next side is referring to the AesKeyRdMode bit which must be set
prior reading the key. I can't find a definition of this bit so I guess
the spec is out of date here.
[Ronen Shitrit] you are right, this should be fix accordingly:

" To decrypt a data block with a given key, the host must first load this key into the decryption engine, then start the key generation process setting <AesDecMakeKey> field in the AES Decryption Command Register bit to 1. At the end of the key generation process, the host reads the key registers from the Encryption engine. This decryption key is loaded by the host into the decryption key registers, to start the required description process.
To read the decryption key from the encryption engine, the host must set the
<AesDecKeyReady> field in the AES Decryption Command Register to 1 prior to the reading of the AES encryption key registers. Setting this bit enables reading of the internal key in the AES Encryption engine, which at the end of an encryption process, is the key for the decryption start point."


However a SW calculation is also possible.
Chapter 11.1.4 in [1] says, that the decrypt key is the last 16/24/32 bytes
created by the expansion algorithm. So I picked the key expand routine
from generic aes module and just passed the crypto test for decryption
with a 16 byte long key. The other two key sizes failed. Probably the
the key slots are different. Currently I have no idea what's wrong.

[Ronen Shitrit] on our driver we also chose the SW calculation WA, I'm not sure why your code fail, but I can refer you to our driver as a reference, maybe you can find it as a good reference also for other issues.

This is an old LSP for the 5182, but the crypto driver supposed to work on the 5182 just fine:
http://downloads.buffalo.nas-central.org/KBPro_ARM9/GPL/source/linux-2.6.12_lsp.1.10.3.src.tar.gz

Look for aesMakeKey API under arch/arm/mach-mv88fxx81/Soc/cesa/

I also wanted to point that the crypto engine on the 5182 passed 2 more evolutions after the 5182, which included:
- Add a dedicated DMA to the crypto unit.
- Support only one channel.
- Fix main erratas.
- Decrease SRAM size to 2K.
- Add support for chain mode.
Maybe you should take those into account in your design to allow support for other crypto versions in the future.
If you need more details pls check the security chapter on:
http://www.marvell.com/files/products/embedded_processors/kirkwood/FS_88F6180_9x_6281_OpenSource.pdf



-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
