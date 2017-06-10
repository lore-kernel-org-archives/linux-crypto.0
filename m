From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] X.509: Fix error code in x509_cert_parse()
Date: Sat, 10 Jun 2017 12:18:20 +0800
Message-ID: <20170610041820.GH14719@gondor.apana.org.au>
References: <4045.1495558143@warthog.procyon.org.uk>
 <20170529132622.6tapug7i7aqmvnqz@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53024 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751881AbdFJE6y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 00:58:54 -0400
Content-Disposition: inline
In-Reply-To: <20170529132622.6tapug7i7aqmvnqz@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 29, 2017 at 04:26:22PM +0300, Dan Carpenter wrote:
> We forgot to set the error code on this path so it could result in
> returning NULL which leads to a NULL dereference.
> 
> Fixes: db6c43bd2132 ("crypto: KEYS: convert public key and digsig asym to the akcipher api")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2:  Style change

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
