Return-Path: <SRS0=Mcmw=PN=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfAEDHu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 22:07:50 -0500
Date: Fri, 4 Jan 2019 19:07:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 01/16] crypto: cfb - add missing 'chunksize' property
Message-ID: <20190105030747.GA661@sol.localdomain>
References: <20190104041625.3259-2-ebiggers@kernel.org>
 <20190104210311.5AC542087F@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104210311.5AC542087F@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 04, 2019 at 09:03:10PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: a7d85e06ed80 crypto: cfb - add support for Cipher FeedBack mode.
> 
> The bot has tested the following trees: v4.20.0, v4.19.13.
> 
> v4.20.0: Failed to apply! Possible dependencies:
>     7da66670775d ("crypto: testmgr - add AES-CFB tests")
> 
> v4.19.13: Failed to apply! Possible dependencies:
>     7da66670775d ("crypto: testmgr - add AES-CFB tests")
>     dfb89ab3f0a7 ("crypto: tcrypt - add OFB functional tests")
> 
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha

The following will need to be applied to 4.19 and 4.20 first.  Both had Cc stable:

fa4600734b74 ("crypto: cfb - fix decryption")
7da66670775d ("crypto: testmgr - add AES-CFB tests")

Herbert, why was CFB accepted without any test vectors in the first place?

- Eric
