From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: HWCAP_CRYPTO define for ARMv8?
Date: Fri, 20 May 2016 09:56:00 +0000
Message-ID: <AM2PR04MB0673B777A1EFD0F95545244B984B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <CAH8yC8kRozR6Nf-Eozsuh4zdtAyx_+4gHOWYSrDWDmqwTVdWYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "noloader@gmail.com" <noloader@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0064.outbound.protection.outlook.com ([157.56.112.64]:19646
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752668AbcETM2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 May 2016 08:28:23 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/15/2016 1:13 PM, Jeffrey Walton wrote:
> Hi Everyone,
> 
> It appears defines like HWCAP_CRC32 fall under the purview of the
> kernel. Confer, http://www.google.com/search?q="HWCAP_CRC32" (my
> apologies if this is not the case).
> 
> We use getauxval(AT_HWCAP) and HWCAP_CRC32 for runtime detection of
> processor support for CRC. However, I can't find a similar symbol in
> the context of the crypto instructions. Confer,
> http://www.google.com/search?q="HWCAP_CRYPTO".
> 
> My question is, what are the equivalent defines for Crypto features?
> 
Take a look at arch/arm64/include/uapi/asm/hwcap.h
#define HWCAP_AES               (1 << 3)
#define HWCAP_PMULL             (1 << 4)
#define HWCAP_SHA1              (1 << 5)
#define HWCAP_SHA2              (1 << 6)

Horia

> Thanks in advance.
> 
> *****
> 
> Below is from a 64-bit LeMaker HiKey
> (http://www.lemaker.org/product-hikey-index.html). It responds to
> getauxval(AT_HWCAP) and HWCAP_CRC32.
> 
> $ cat /proc/cpuinfo
> Processor    : AArch64 Processor rev 3 (aarch64)
> processor    : 0
> ...
> processor    : 7
> Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32
> CPU implementer    : 0x41
> CPU architecture: AArch64
> CPU variant    : 0x0
> CPU part    : 0xd03
> CPU revision    : 3
> 
> Hardware    : HiKey Development Board
