From: David Lamparter <lists@diac24.net>
Subject: XTS cipher mode not using assembler AES implementation?
Date: Thu, 30 Apr 2009 20:56:51 +0200
Message-ID: <1241117811.8320.14.camel@arkology.n2.diac24.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from spaceboyz.net ([87.106.131.203]:39280 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZD3T1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2009 15:27:07 -0400
Received: from [2001:8d8:81:5c2:21b:fcff:fe4c:9e6f] (helo=jupiter.n2.diac24.net)
	by spaceboyz.net with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <lists@diac24.net>)
	id 1LzbRH-0002EN-0U
	for linux-crypto@vger.kernel.org; Thu, 30 Apr 2009 20:56:55 +0200
Received: from arkology.n2.diac24.net ([2001:8d8:81:5c2:219:dbff:feea:a8a8])
	by jupiter.n2.diac24.net with esmtps (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.69)
	(envelope-from <lists@diac24.net>)
	id 1LzbRF-0007s0-31
	for linux-crypto@vger.kernel.org; Thu, 30 Apr 2009 20:56:55 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello linux-crypto list,


I beg pardon for bothering you with this, but I'm slightly irritated
by /proc/crypto output on my box. It lists:

name         : xts(aes)
driver       : xts(aes-generic)
module       : kernel
priority     : 100
refcnt       : 2
[...]
name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 4
[...]
name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 1

[no xts(aes-asm) entry]

So, basically, my dm-crypt (cipher: aes-xts-essiv:wp256) uses the
generic AES implementation if I'm reading this right? What do I need to
do to get it to use the aes-asm one?

(In case it matters, I have the crypto stuff compiled into the kernel
because my rootfs is on crypto, so I'm just booting a kernel with
everything needed compiled in for ease of setup... maybe xts initializes
before aes-asm does?)

Thankful for any information, please Cc me as I'm not subscribed on
linux-crypto,


David Lamparter


(# uname -a
Linux jupiter 2.6.28.7-grsec-00001-gcd4f8cc #1 SMP Tue Mar 3 18:05:40
CET 2009 x86_64 AMD Athlon(tm) Dual Core Processor 4450e AuthenticAMD
GNU/Linux
# gunzip -c /proc/config.gz | pcregrep '_AES|_XTS'
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y

crypto device performance is 35 MB/s, underlying device does 200 MB/s)


