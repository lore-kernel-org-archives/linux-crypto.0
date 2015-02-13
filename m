From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AF_ALG interface not marking the end of the scatter-gather list
Date: Fri, 13 Feb 2015 12:43:40 +0100
Message-ID: <1554206.3ZPmnjpxYl@tachyon.chronox.de>
References: <54DD3A47.8010102@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60254 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbbBMLnq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2015 06:43:46 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S15675> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Fri, 13 Feb 2015 12:43:41 +0100
In-Reply-To: <54DD3A47.8010102@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Februar 2015, 17:41:59 schrieb Tom Lendacky:

Hi Tom,

> I was doing some testing of the CCP driver using the AF_ALG interface
> and encountered a BUG_ON statement during scatter-gather DMA mapping.
> 
> In algif_skcipher.c, before submitting a request to the the Crypto API
> the input sg list is not updated to mark the last valid sg entry of the
> input data. So even if there is only a single valid sg entry, sg_nents
> returns 127 (the initial value used when creating the sg table).
> 
> In the CCP driver, when making a call to dma_map_sg I supply the number
> of entries as returned by sg_nents. During this call, the sg elements
> that are not valid cause a BUG_ON statement to be hit.
> 
> I've worked around the issue in skcipher_recvmsg by marking the last
> valid sg entry (sg_mark_end(sgl->sg + sgl->cur - 1)) just before the
> call to ablkcipher_request_set_crypt and then unmarking the entry after
> the return from af_alg_wait_for_completion (using sg_unmark_end).
> 
> Is this an appropriate/valid solution for this issue?  If so, I can
> submit a patch with the fix in algif_skcipher and algif_hash.

There has been a patch around this issue -- see patch 
0f477b655a524515ec9a263d70d51f460c05a161
> 
> Thanks,
> Tom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
