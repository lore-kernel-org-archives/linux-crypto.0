From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: caam: Remove unused dentry members
Date: Wed, 9 Aug 2017 21:57:21 +0800
Message-ID: <20170809135721.GF743@gondor.apana.org.au>
References: <1501595101-13919-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@nxp.com, linux-crypto@vger.kernel.org
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36830 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752461AbdHIN5a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 09:57:30 -0400
Content-Disposition: inline
In-Reply-To: <1501595101-13919-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 01, 2017 at 10:45:01AM -0300, Fabio Estevam wrote:
> Most of the dentry members from structure caam_drv_private
> are never used at all, so it is safe to remove them.
> 
> Since debugfs_remove_recursive() is called, we don't need the
> file entries.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
