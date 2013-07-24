From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [BUG] 3.11 boot failure caused by commit crypto
Date: Wed, 24 Jul 2013 10:28:28 +0800
Message-ID: <51EF3BCC.30102@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <tim.c.chen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:18758 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3GXCcT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jul 2013 22:32:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When i boot my system with the latest 3.11-rc2 kernel, something occur as follow:

Waiting for device /dev/disk/by-id/... to appear: ............ Could not find //dev/disk/by-id/...
Want me to fall back to /dev/disk/by-id/..... ?

I found out the patch commit id: 2d31e518a42828df7877bca23a958627d60408bc (crypto: crct10dif - 
Wrap crc_t10dif function all to use crypto transform framework) cause this problem by bisect.

I revert this patch and this problem go away, the boot become successful.
