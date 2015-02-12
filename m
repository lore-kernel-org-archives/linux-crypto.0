From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: AF_ALG interface not marking the end of the scatter-gather list
Date: Thu, 12 Feb 2015 17:41:59 -0600
Message-ID: <54DD3A47.8010102@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:7728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbbBLXm5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Feb 2015 18:42:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was doing some testing of the CCP driver using the AF_ALG interface
and encountered a BUG_ON statement during scatter-gather DMA mapping.

In algif_skcipher.c, before submitting a request to the the Crypto API
the input sg list is not updated to mark the last valid sg entry of the
input data. So even if there is only a single valid sg entry, sg_nents
returns 127 (the initial value used when creating the sg table).

In the CCP driver, when making a call to dma_map_sg I supply the number
of entries as returned by sg_nents. During this call, the sg elements
that are not valid cause a BUG_ON statement to be hit.

I've worked around the issue in skcipher_recvmsg by marking the last
valid sg entry (sg_mark_end(sgl->sg + sgl->cur - 1)) just before the
call to ablkcipher_request_set_crypt and then unmarking the entry after
the return from af_alg_wait_for_completion (using sg_unmark_end).

Is this an appropriate/valid solution for this issue?  If so, I can
submit a patch with the fix in algif_skcipher and algif_hash.

Thanks,
Tom
