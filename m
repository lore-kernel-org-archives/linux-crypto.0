From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - consolidation of duplicate code
Date: Wed, 9 Aug 2017 21:57:34 +0800
Message-ID: <20170809135733.GG743@gondor.apana.org.au>
References: <2922624.oQubu9mOmR@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36834 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752935AbdHIN5l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 09:57:41 -0400
Content-Disposition: inline
In-Reply-To: <2922624.oQubu9mOmR@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 02, 2017 at 07:56:19AM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> as agreed, the individual patches from the first submission are now changed.
> 
> After review of the changes I had to apply to algif_aead and algif_skcipher,
> I saw that they are all in the category that you agreed that can be rolled
> into this patch. Though, I documented the changes so that a review should
> be easier.
> 
> Ciao
> Stephan
> 
> ---8<---
> 
> Consolidate following data structures:
> 
> skcipher_async_req, aead_async_req -> af_alg_async_req
> skcipher_rsgl, aead_rsql -> af_alg_rsgl
> skcipher_tsgl, aead_tsql -> af_alg_tsgl
> skcipher_ctx, aead_ctx -> af_alg_ctx
> 
> Consolidate following functions:
> 
> skcipher_sndbuf, aead_sndbuf -> af_alg_sndbuf
> skcipher_writable, aead_writable -> af_alg_writable
> skcipher_rcvbuf, aead_rcvbuf -> af_alg_rcvbuf
> skcipher_readable, aead_readable -> af_alg_readable
> aead_alloc_tsgl, skcipher_alloc_tsgl -> af_alg_alloc_tsgl
> aead_count_tsgl, skcipher_count_tsgl -> af_alg_count_tsgl
> aead_pull_tsgl, skcipher_pull_tsgl -> af_alg_pull_tsgl
> aead_free_areq_sgls, skcipher_free_areq_sgls -> af_alg_free_areq_sgls
> aead_wait_for_wmem, skcipher_wait_for_wmem -> af_alg_wait_for_wmem
> aead_wmem_wakeup, skcipher_wmem_wakeup -> af_alg_wmem_wakeup
> aead_wait_for_data, skcipher_wait_for_data -> af_alg_wait_for_data
> aead_data_wakeup, skcipher_data_wakeup -> af_alg_data_wakeup
> aead_sendmsg, skcipher_sendmsg -> af_alg_sendmsg
> aead_sendpage, skcipher_sendpage -> af_alg_sendpage
> aead_async_cb, skcipher_async_cb -> af_alg_async_cb
> aead_poll, skcipher_poll -> af_alg_poll
> 
> Split out the following common code from recvmsg:
> 
> af_alg_alloc_areq: allocation of the request data structure for the
> cipher operation
> 
> af_alg_get_rsgl: creation of the RX SGL anchored in the request data
> structure
> 
> The following changes to the implementation without affecting the
> functionality have been applied to synchronize slightly different code
> bases in algif_skcipher and algif_aead:
> 
> The wakeup in af_alg_wait_for_data is triggered when either more data
> is received or the indicator that more data is to be expected is
> released. The first is triggered by user space, the second is
> triggered by the kernel upon finishing the processing of data
> (i.e. the kernel is ready for more).
> 
> af_alg_sendmsg uses size_t in min_t calculation for obtaining len.
> Return code determination is consistent with algif_skcipher. The
> scope of the variable i is reduced to match algif_aead. The type of the
> variable i is switched from int to unsigned int to match algif_aead.
> 
> af_alg_sendpage does not contain the superfluous err = 0 from
> aead_sendpage.
> 
> af_alg_async_cb requires to store the number of output bytes in
> areq->outlen before the AIO callback is triggered.
> 
> The POLLIN / POLLRDNORM is now set when either not more data is given or
> the kernel is supplied with data. This is consistent to the wakeup from
> sleep when the kernel waits for data.
> 
> The request data structure is extended by the field last_rsgl which
> points to the last RX SGL list entry. This shall help recvmsg
> implementation to chain the RX SGL to other SG(L)s if needed. It is
> currently used by algif_aead which chains the tag SGL to the RX SGL
> during decryption.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
