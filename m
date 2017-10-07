From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto:ccp - invoke the DMA callback in a standard way
Date: Sat, 7 Oct 2017 12:18:30 +0800
Message-ID: <20171007041830.GC29803@gondor.apana.org.au>
References: <20170905220813.18963.86148.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57370 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdJGESu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 00:18:50 -0400
Content-Disposition: inline
In-Reply-To: <20170905220813.18963.86148.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 05, 2017 at 05:08:14PM -0500, Gary R Hook wrote:
> From: amd <amd@sosxen2.amd.com>
> 
> Use the provided mechanism in dmaengine.h to invoke the
> completion callback.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
