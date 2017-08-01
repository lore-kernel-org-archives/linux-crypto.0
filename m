From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/16] crypto: AF_ALG - consolidation
Date: Tue, 1 Aug 2017 16:58:58 +0800
Message-ID: <20170801085858.GA32240@gondor.apana.org.au>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37322 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdHAI7G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 04:59:06 -0400
Content-Disposition: inline
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 31, 2017 at 02:04:58PM +0200, Stephan Müller wrote:
> Hi,
> 
> with the update of the algif_aead and algif_skcipher memory management,
> a lot of code duplication has been introduced deliberately.
> 
> This patch set cleans up the low-hanging fruits. The cleanup of the
> recvmsg RX SGL copy will come separately as this is not a simple copy
> and paste operation.
> 
> Each patch was tested individually with libkcapi's test suite.
> 
> The patch set goes on top of patches "crypto: AF_ALG - return error code when
> no data was processed" and "crypto: algif_aead - copy AAD from src to dst".
> 
> Stephan Mueller (16):
>   crypto: AF_ALG - consolidation of common data structures
>   crypto: AF_ALG - consolidation of context data structure
>   crypto: AF_ALG - consolidate send buffer service functions
>   crypto: AF_ALG - consolidate RX buffer service functions
>   crypto: AF_ALG - consolidate TX SGL allocation
>   crypto: AF_ALG - consolidate counting TX SG entries
>   crypto: AF_ALG - consolidate counting TX SG entries
>   crypto: AF_ALG - consolidate freeing TX/RX SGLs
>   crypto: AF_ALG - consolidate waiting for wmem
>   crypto: AF_ALG - consolidate waking up on writable memory
>   crypto: AF_ALG - consolidate waiting for TX data
>   crypto: AF_ALG - consolidate waking up caller for TX data
>   crypto: AF_ALG - consolidate sendmsg implementation
>   crypto: AF_ALG - consolidate sendpage implementation
>   crypto: AF_ALG - consolidate AIO callback handler
>   crypto: AF_ALG - consolidate poll syscall handler

This split makes no sense.  I don't see why you can't merge them
into a single patch if it's just rearranging the code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
