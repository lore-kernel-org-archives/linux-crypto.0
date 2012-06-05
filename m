From: Ajay Matai <ajay@symform.com>
Subject: mv_cesa 1920 limit still happening
Date: Tue, 5 Jun 2012 20:59:01 +0000
Message-ID: <4E322BC03786A946BBEEBD86B35E53F3016816@EXMBX11.netplexity.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp02.myhostedservice.com ([66.129.85.153]:9286 "EHLO
	smtp02.myhostedservice.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545Ab2FEU7i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jun 2012 16:59:38 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,
 I am running QNAP NAS device with Marvell SoC and having issues with both AES and SHA1 when accelerated through mv_cesa. Both the encryption and hash algorithms work fine for file sizes up to 1920 bytes, while anything greater than that gets broken (comparing AES with openssl and SHA1 output with sha1sum command).

This is what I have done:
Back ported the mv_cesa driver from linux-3.4.rc7 to linux-2.6.33.2
Built and insmoded the driver, which loads fine and the algorithms show up in /proc/crypto

The kernel/userspace interface is provided by crypto-linux-1.4

Unfortunately, I am unable to test mv_cesa with latest kernel as this device is running linux-2.6.33.2 and QNAP has not made linux-3.x based firmware available.

Here's the CPU info:
[/share/HDA_DATA/Public/linux-3.4-rc7/drivers/crypto] # cat /proc/cpuinfo
Processor       : Feroceon 88F6281 rev 1 (v5l)
BogoMIPS        : 799.53
Features        : swp half thumb fastmult edsp
CPU implementer : 0x56
CPU architecture: 5TE
CPU variant     : 0x2
CPU part        : 0x131
CPU revision    : 1

Hardware        : Feroceon-KW ARM
Revision        : 0000
Serial          : 0000000000000000

Do you think this is a genuine bug or an artifact of running mv_cesa under linux-2.6.33.2 ?
Thanks for any help/pointers or anything else I can try?

--ajay
Symform.com
