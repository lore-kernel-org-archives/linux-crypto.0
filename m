From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] Add more algorithms and some misc cleanups
Date: Mon, 19 Jun 2017 14:39:29 +0800
Message-ID: <20170619063929.GC13651@gondor.apana.org.au>
References: <1493897686-12330-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59646 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdFSGjw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 02:39:52 -0400
Content-Disposition: inline
In-Reply-To: <1493897686-12330-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 04, 2017 at 11:34:43AM +0000, George Cherian wrote:
> This series adds more algorithem support for CPT.
> Add support for
>         -ecb(aes)
>         -cfb(aes)
>         -ecb(des3_ede)
> 
> Some cleanups too.
> 
> George Cherian (3):
>   crypto: cavium: Downgrade the annoying misc interrupt print from
>     dev_err to dev_dbg
>   crypto: cavium: Remove the individual encrypt/decrypt function for
>     each algorithm
>   crypto: cavium: Add more algorithms

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
