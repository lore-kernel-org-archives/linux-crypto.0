From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2] crypto: ccp - Rearrange structure members to minimize
 size
Date: Wed, 5 Apr 2017 22:10:05 +0800
Message-ID: <20170405141005.GF27150@gondor.apana.org.au>
References: <20170328155725.9578.85077.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        arnd@arndb.de, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37498 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932371AbdDEOLI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 10:11:08 -0400
Content-Disposition: inline
In-Reply-To: <20170328155725.9578.85077.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:57:26AM -0500, Gary R Hook wrote:
> The AES GCM function (in ccp-ops) requires a fair amount of
> stack space, which elicits a complaint when KASAN is enabled.
> Rearranging and packing a few structures eliminates the
> warning.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
