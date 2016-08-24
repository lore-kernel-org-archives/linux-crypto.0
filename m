From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/xor: skip speed test if the xor function is
 selected automatically
Date: Wed, 24 Aug 2016 21:17:07 +0800
Message-ID: <20160824131707.GA4016@gondor.apana.org.au>
References: <1471609170-18816-1-git-send-email-schwidefsky@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        schwidefsky@de.ibm.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57194 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754455AbcHXNRN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 09:17:13 -0400
Content-Disposition: inline
In-Reply-To: <1471609170-18816-1-git-send-email-schwidefsky@de.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> If the architecture selected the xor function with XOR_SELECT_TEMPLATE
> the speed result of the do_xor_speed benchmark is of limited value.
> The speed measurement increases the bootup time a little, which can
> makes a difference for kernels used in container like virtual machines.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
