From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - unmap pages and remove unmap objects in
 callback
Date: Sat, 7 Oct 2017 12:18:20 +0800
Message-ID: <20171007041820.GB29803@gondor.apana.org.au>
References: <20170905220150.28464.76800.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57356 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdJGESm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 00:18:42 -0400
Content-Disposition: inline
In-Reply-To: <20170905220150.28464.76800.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 05, 2017 at 05:01:51PM -0500, Gary R Hook wrote:
> From: amd <amd@sosxen2.amd.com>
> 
> Clean up the mapped pages and the unmap object once we are done with
> it. This enables the final clean-up of the object once the transfer
> is complete.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
