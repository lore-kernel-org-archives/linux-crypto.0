From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Fix handling of RSA exponent on a v5 device
Date: Thu, 17 Nov 2016 21:14:48 +0800
Message-ID: <20161117131447.GA2029@gondor.apana.org.au>
References: <20161101190505.1191.20536.stgit@taos>
 <20161113094921.GB7399@gondor.apana.org.au>
 <60b38fe7-e08e-05c4-8316-e2408bef2f33@amd.com>
 <20161116090125.GC29644@gondor.apana.org.au>
 <368b41ee-45e3-c330-10c5-16fcc22d3d16@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        thomas.lendacky@amd.com, davem@davemloft.net
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58359 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934776AbcKQRTb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2016 12:19:31 -0500
Content-Disposition: inline
In-Reply-To: <368b41ee-45e3-c330-10c5-16fcc22d3d16@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 16, 2016 at 11:25:19AM -0600, Gary R Hook wrote:
>
> The kernel crypto layer does not yet support RSA, true. However, we
> designed the ccp.ko layer to be available to anyone that wants to use
> it. The underlying module currently has differing behavior/results
> between the v3 and v5 implementations of the RSA command function.
> This patch fixes the borked v5 code.

Do you mean that an out-of-tree module could enter the buggy
code path?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
