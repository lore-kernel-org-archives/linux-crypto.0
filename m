From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: Query about ahash support
Date: Tue, 22 Jan 2013 10:42:36 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B9416B394@039-SN2MPN1-011.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:58009
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab3AVKm4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jan 2013 05:42:56 -0500
Received: from mail24-ch1 (localhost [127.0.0.1])	by mail24-ch1-R.bigfish.com
 (Postfix) with ESMTP id 350B7C0BC5	for <linux-crypto@vger.kernel.org>; Tue,
 22 Jan 2013 10:42:55 +0000 (UTC)
Received: from CH1EHSMHS031.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.254])	by mail24-ch1.bigfish.com (Postfix) with ESMTP id 000CF2C0095
	for <linux-crypto@vger.kernel.org>; Tue, 22 Jan 2013 10:42:53 +0000 (UTC)
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi

Currently, tcrypt ahash speed test code waits for previous request to complete
before sending next crypto_ahash_update() request.
The cryptographic offload hard accelerators (e.g. CAAM) supports multiple
outstanding crypto requests for the same transform.

Does the asynchronous hash support in cryptoapi mean that one can call
crypto_ahash_update() multiple times (in pipelined fashion) without waiting
for previous crypto_ahash_update() to complete and give back the result?

Thanks & Regards

Vakul
