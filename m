From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Change all references to use the JOB ID
 macro
Date: Tue, 18 Jul 2017 18:35:59 +0800
Message-ID: <20170718103559.GG6479@gondor.apana.org.au>
References: <149857189631.26668.7228199918497769629.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33186 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdGRKgY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:36:24 -0400
Content-Disposition: inline
In-Reply-To: <149857189631.26668.7228199918497769629.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 27, 2017 at 08:58:16AM -0500, Gary R Hook wrote:
> Use the CCP_NEW_JOBID() macro when assigning an identifier
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
