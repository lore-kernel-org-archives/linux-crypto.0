From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/aes-ce: assign err return conditionally
Date: Sat, 11 Feb 2017 17:39:46 +0800
Message-ID: <20170211093946.GA749@gondor.apana.org.au>
References: <1486560979-25240-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55073 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753216AbdBKJku (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 04:40:50 -0500
Content-Disposition: inline
In-Reply-To: <1486560979-25240-1-git-send-email-der.herr@hofr.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 08, 2017 at 02:36:19PM +0100, Nicholas Mc Guire wrote:
> As the err value is not used unless there was an error it can be assigned
> conditionally here. 
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

This patch just adds noise to the commit history.  So I'm not going
to apply it.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
