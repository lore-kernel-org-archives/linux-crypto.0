From: Karl Hiramoto <karl@hiramoto.org>
Subject: pcomp for lzma for later use with squashfs
Date: Fri, 08 May 2009 14:00:37 +0200
Message-ID: <4A041EE5.4000008@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, phillip@lougher.demon.co.uk
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:34487 "EHLO
	spunkymail-a18.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831AbZEHMAn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 May 2009 08:00:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Geert,

Was wondering if there are any patches for pcomp lzma. it it just a matter of adding crypto/lzma to make the calls to lib/decompress_unlzma.c ?

I just started looking at this, my end goal is to use your pcomp patch for squashfs and get lzma squahsfs.


Thanks,

karl.
