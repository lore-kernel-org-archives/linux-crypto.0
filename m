From: Shuai Xiao <shuai.xiao@ruckuswireless.com>
Subject: Linux-crypto: Do we have AES-CBC implementation using Intel SSSE3?
Date: Mon, 25 Aug 2014 19:27:39 +0000
Message-ID: <c75f3a957c2041618753b94316a88bc7@DM2PR0801MB555.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:19342
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752351AbaHYT1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Aug 2014 15:27:42 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
   I want to find a AES-CBC implementation using Intel SSSE3, because the CPU I works with have no AES-NI. I have to use SSSE3 to get better performance. There is a module in Openssl using SSSE3 to implement AES. According Openssl's test result, there are +28%/64% improvement between regular assembly code and SSSE3 assembly code.

  But I can't find a implementation which available in kernel space and fit in Linux crypto API. Anyone have some info about this?

  And I noticed that Linux-crypto are using SSSE3 to implement sha1,sha256,sha512, why not for AES?

  Here is the info for SSSE3 AES implementation, http://shiftleft.org/papers/vector_aes/  and  http://crypto.stanford.edu/vpaes/.
or you can read the Openssl code in Openssl\crypto\aes\asm\vpaes-x86.pl

   Thank you for your time!

Regards
Shuai
