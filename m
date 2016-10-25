From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Move RSA+MPI constructs into an #include file
Date: Tue, 25 Oct 2016 10:48:42 +0800
Message-ID: <20161025024842.GB17875@gondor.apana.org.au>
References: <20161014193559.4342.74036.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41111 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbcJYCsr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 22:48:47 -0400
Content-Disposition: inline
In-Reply-To: <20161014193559.4342.74036.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 14, 2016 at 02:36:00PM -0500, Gary R Hook wrote:
> Move RSA support of general use into internal/rsa.h.
> This allows reuse of, e.g. RSA MPI keys and support
> functions.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Please fold this patch into the series that makes use of it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
