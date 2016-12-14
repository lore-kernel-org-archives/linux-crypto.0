From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: asymmetric_keys: set error code on failure
Date: Wed, 14 Dec 2016 18:38:51 +0800
Message-ID: <20161214103851.GA11960@gondor.apana.org.au>
References: <148162117870.19689.15511298103589902019.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pan Bian <bianpan2016@163.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36235 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755247AbcLNKjg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 05:39:36 -0500
Content-Disposition: inline
In-Reply-To: <148162117870.19689.15511298103589902019.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 09:26:18AM +0000, David Howells wrote:
> From: Pan Bian <bianpan2016@163.com>
> 
> In function public_key_verify_signature(), returns variable ret on
> error paths. When the call to kmalloc() fails, the value of ret is 0,
> and it is not set to an errno before returning. This patch fixes the
> bug.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188891
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
