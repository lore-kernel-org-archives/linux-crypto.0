From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 02/10] crypto: add asynchronous compression api
Date: Thu, 2 Jun 2016 17:12:19 +0800
Message-ID: <20160602091219.GC15919@gondor.apana.org.au>
References: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
 <1464702936-27627-3-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46791 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbcFBJMZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 05:12:25 -0400
Content-Disposition: inline
In-Reply-To: <1464702936-27627-3-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 31, 2016 at 02:55:28PM +0100, Giovanni Cabiddu wrote:
>
> +/**
> + * struct acomp_req - asynchronous (de)compression request
> + *
> + * @base:     Common attributes for asynchronous crypto requests
> + * @src:      Source Data
> + * @dst:      Destination data
> + * @slen:     Size of the input buffer
> + * @dlen:     Size of the output buffer
> + * @consumed: Number of bytes consumed by the (de)compressor
> + * @produced: Number of bytes produced by the (de)compressor

Why do we need these two? For a moment I thought you were going
to add pcomp again :)

Since we're only support compression in one go, the number of
bytes consumed must be equal to slen unless there was an error.

For the number of bytes produced I'd prefer to just use dlen for it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
