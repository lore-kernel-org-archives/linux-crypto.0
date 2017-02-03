From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp: Fix double add when creating new DMA command
Date: Fri, 3 Feb 2017 18:21:53 +0800
Message-ID: <20170203102153.GF2632@gondor.apana.org.au>
References: <20170127230904.31399.58184.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36657 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752988AbdBCKWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 05:22:06 -0500
Content-Disposition: inline
In-Reply-To: <20170127230904.31399.58184.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 27, 2017 at 05:09:04PM -0600, Gary R Hook wrote:
> Eliminate a double-add by creating a new list to manage
> command descriptors when created; move the descriptor to
> the pending list when the command is submitted. This
> 
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
