From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: serpent-sse2 - different key size same speed?
Date: Mon, 19 Mar 2012 19:06:47 +0100
Message-ID: <jk7sn8$blt$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55494 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab2CSSIv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Mar 2012 14:08:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1S9h0j-0004Wi-LB
	for linux-crypto@vger.kernel.org; Mon, 19 Mar 2012 19:08:49 +0100
Received: from ip-89-176-6-41.net.upcbroadband.cz ([89.176.6.41])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Mon, 19 Mar 2012 19:08:49 +0100
Received: from zkaspar82 by ip-89-176-6-41.net.upcbroadband.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Mon, 19 Mar 2012 19:08:49 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello everyone,

I just quick tested 3.3.0 kernel (x86_64) to get idea how serpent-sse2
implementation works on Core2 machine. My dirty testing revealed that
key size doesn't have impact on speed. Is such behavior normal ?

Test machine: Core2 E6600 (2.40GHz), 3GB RAM, Scientific Linux 6.2
dm-crypt on /dev/loop0, 1.5G image file:
/dev/loop0: [0010]:11323 (/dev/shm/test.img)


Encrypt (dd if=/dev/zero of=/dev/mapper/test bs=1M)
-s 256 -c aes-xts-plain64     : 159 - 162 MB/s
-s 512 -c aes-xts-plain64     : 129 - 141 MB/s

-s 256 -c serpent-xts-plain64 : 142 - 146 MB/s
-s 512 -c serpent-xts-plain64 : 139 - 148 MB/s


Decrypt (dd if=/dev/mapper/test of=/dev/null bs=1M)
-s 256 -c aes-xts-plain64     : 113 - 114 MB/s
-s 512 -c aes-xts-plain64     :   90.1 MB/s

-s 256 -c serpent-xts-plain64 :  105.0 MB/s
-s 512 -c serpent-xts-plain64 :  105.0 MB/s


(perf top shows as expected high usage of: serpent_dec_blk_8way and
serpent_enc_blk_8way)

Z.
