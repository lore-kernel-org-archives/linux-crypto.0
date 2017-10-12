From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: keywrap - simplify code
Date: Thu, 12 Oct 2017 23:19:21 +0800
Message-ID: <20171012151921.GG31122@gondor.apana.org.au>
References: <83738816.byIHpQSsDj@positron.chronox.de>
 <5659514.0BUO5u15Qm@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37352 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdJLPTo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 11:19:44 -0400
Content-Disposition: inline
In-Reply-To: <5659514.0BUO5u15Qm@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 03, 2017 at 04:19:59AM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> Changes v2:
> * use __be64 for A and R variables
> * eliminate tbe variable
> * use initial IV value with cpu_to_be64 when accessing variable A
> 
> ---8<---
> 
> The code is simplified by using two __be64 values for the operation
> instead of using two arrays of u8. This allows to get rid of the memory
> alignment code. In addition, the crypto_xor can be replaced with a
> native XOR operation. Finally, the definition of the variables is
> re-arranged such that the data structures come before simple variables
> to potentially reduce memory space.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
