From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - add guard to dst buffer for
 ahash_export
Date: Sun, 2 Oct 2016 22:37:11 +0800
Message-ID: <20161002143711.GA18268@gondor.apana.org.au>
References: <26da11d26bf0d34f9a5896ab9f9540db5be17012.1475072761.git.jstancek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcelo.cerri@canonical.com
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41461 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbcJBOhS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Oct 2016 10:37:18 -0400
Content-Disposition: inline
In-Reply-To: <26da11d26bf0d34f9a5896ab9f9540db5be17012.1475072761.git.jstancek@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 28, 2016 at 04:38:37PM +0200, Jan Stancek wrote:
> Add a guard to 'state' buffer and warn if its consistency after
> call to crypto_ahash_export() changes, so that any write that
> goes beyond advertised statesize (and thus causing potential
> memory corruption [1]) is more visible.
> 
> [1] https://marc.info/?l=linux-crypto-vger&m=147467656516085
> 
> Signed-off-by: Jan Stancek <jstancek@redhat.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Marcelo Cerri <marcelo.cerri@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
