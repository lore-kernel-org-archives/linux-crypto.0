From: Joel Fernandes <joelf@ti.com>
Subject: [RFC] Unaligned CTR mode tests in crypto/testmgr.h
Date: Tue, 29 Oct 2013 19:11:23 -0500
Message-ID: <52704EAB.5000308@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34594 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3J3AL3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Oct 2013 20:11:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Some tests such as test 5 in AES CTR mode in crypto/testmgr.h have a unaligned
input buffer size such as 499 which is not aligned to any > 0 power of 2.

Due to this, omap-aes driver, and I think atmel-aes too error out when
encryption is requested for these buffers.

pr_err("request size is not exact amount of AES blocks\n") or a similar message.

Is this failure considered a bug? How do we fix it?

How were the result output vectors generated, did you use 0 padding? Do we 0 pad
the inputs to align in these cases to get correct results?

thanks,

-Joel
