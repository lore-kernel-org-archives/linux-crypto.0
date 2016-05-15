From: Jeffrey Walton <noloader@gmail.com>
Subject: HWCAP_CRYPTO define for ARMv8?
Date: Sun, 15 May 2016 06:13:49 -0400
Message-ID: <CAH8yC8kRozR6Nf-Eozsuh4zdtAyx_+4gHOWYSrDWDmqwTVdWYg@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34169 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbcEOKNu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 May 2016 06:13:50 -0400
Received: by mail-io0-f175.google.com with SMTP id 190so180192924iow.1
        for <linux-crypto@vger.kernel.org>; Sun, 15 May 2016 03:13:49 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Everyone,

It appears defines like HWCAP_CRC32 fall under the purview of the
kernel. Confer, http://www.google.com/search?q="HWCAP_CRC32" (my
apologies if this is not the case).

We use getauxval(AT_HWCAP) and HWCAP_CRC32 for runtime detection of
processor support for CRC. However, I can't find a similar symbol in
the context of the crypto instructions. Confer,
http://www.google.com/search?q="HWCAP_CRYPTO".

My question is, what are the equivalent defines for Crypto features?

Thanks in advance.

*****

Below is from a 64-bit LeMaker HiKey
(http://www.lemaker.org/product-hikey-index.html). It responds to
getauxval(AT_HWCAP) and HWCAP_CRC32.

$ cat /proc/cpuinfo
Processor    : AArch64 Processor rev 3 (aarch64)
processor    : 0
...
processor    : 7
Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32
CPU implementer    : 0x41
CPU architecture: AArch64
CPU variant    : 0x0
CPU part    : 0xd03
CPU revision    : 3

Hardware    : HiKey Development Board
