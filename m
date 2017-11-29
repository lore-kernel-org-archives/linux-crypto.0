From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Wed, 29 Nov 2017 17:28:21 +1100
Message-ID: <20171129062821.GA21594@gondor.apana.org.au>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Robert Baronescu <robert.baronescu@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40540 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751165AbdK2G2o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:28:44 -0500
Content-Disposition: inline
In-Reply-To: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 10, 2017 at 01:21:59PM +0300, Robert Baronescu wrote:
> In case buffer length is a multiple of PAGE_SIZE,
> the S/G table is incorrectly generated.
> Fix this by handling buflen = k * PAGE_SIZE separately.
> 
> Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
