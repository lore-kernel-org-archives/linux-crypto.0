From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Fix handling of RSA exponent on a v5 device
Date: Wed, 16 Nov 2016 17:01:25 +0800
Message-ID: <20161116090125.GC29644@gondor.apana.org.au>
References: <20161101190505.1191.20536.stgit@taos>
 <20161113094921.GB7399@gondor.apana.org.au>
 <60b38fe7-e08e-05c4-8316-e2408bef2f33@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        thomas.lendacky@amd.com, davem@davemloft.net
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56611 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932281AbcKPJBh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 04:01:37 -0500
Content-Disposition: inline
In-Reply-To: <60b38fe7-e08e-05c4-8316-e2408bef2f33@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 15, 2016 at 03:41:25PM -0600, Gary R Hook wrote:
> On 11/13/2016 03:49 AM, Herbert Xu wrote:
> >On Tue, Nov 01, 2016 at 02:05:05PM -0500, Gary R Hook wrote:
> >>The exponent size in the ccp_op structure is in bits. A v5
> >>CCP requires the exponent size to be in bytes, so convert
> >>the size from bits to bytes when populating the descriptor.
> >>
> >>The current code references the exponent in memory, but
> >>these fields have not been set since the exponent is
> >>actually store in the LSB. Populate the descriptor with
> >>the LSB location (address).
> >>
> >>Signed-off-by: Gary R Hook <gary.hook@amd.com>
> >
> >Patch applied.  Thanks.
> >
> 
> Thanks, Herbert.
> 
> Is there a possibility of getting this pushed to 4.9, being
> it's a bug fix?

I thought ccp doesn't support RSA yet or is there another entry
path into this code?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
