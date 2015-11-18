From: Ismail Kizir <ikizir@gmail.com>
Subject: A new, fast and "unbreakable" encryption algorithm
Date: Wed, 18 Nov 2015 07:10:30 +0200
Message-ID: <CAFJyfaOpgXj7pJfGA5jf7-95VfgC+-yZu4t6_6OGRvx_OtuzuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34541 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbKRFKb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 00:10:31 -0500
Received: by wmvv187 with SMTP id v187so260152326wmv.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2015 21:10:30 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I've developed a new encryption algorithm, which dynamically changes
the key according to plaintext and practically impossible to break. I
also opened to public with MIT&GPL dual License.
It is also quite fast; ~80% faster than the fastest mode of AES
without cpu instruction set support.
I will present a paper on a Turkish National Inet-tr 2015 Symposium on
3 December:
It is a very simple and yet efficient logic. Anyone who looks at the
self documented(in English) C code at
http://ismail-kizir.blogspot.com/2015/11/hohha-dynamic-xor-algorithm-source-code.html
 may understand why and how it is unbreakable.

I simply use the key as a jump table and, with every encrypted byte, I
change the jump table(the key) as a result of 3-4 parameters including
the last plaintext byte itself. Briefly, I encypt the plaintext with
the key and also dynamically encrypt the key with the plaintext.
The code is self documented in English.
On Linux simply
gcc HohhaDynamicXOR.c -O2 -Wall
./a.out
will make integrity checks and print benchmarks. It is production ready.
Other algorithm results are the output of the "openssl speed" command.
If I am right; you will not be disappointed to include "Hohha Dynamic
XOR Encryption Algorithm" on Linux Kernel.

I will be glad to see my algorithm included in Linux distributions.

Regards
Ismail Kizir
