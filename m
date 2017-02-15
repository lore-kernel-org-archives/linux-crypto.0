From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: brcm - Avoid double free in ahash_finup()
Date: Wed, 15 Feb 2017 13:35:53 +0800
Message-ID: <20170215053553.GK14043@gondor.apana.org.au>
References: <1487094352-2016-1-git-send-email-rob.rice@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
To: Rob Rice <rob.rice@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52621 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbdBOFgI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:36:08 -0500
Content-Disposition: inline
In-Reply-To: <1487094352-2016-1-git-send-email-rob.rice@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 14, 2017 at 12:45:52PM -0500, Rob Rice wrote:
> In Broadcom SPU driver, in case where incremental hash
> is done in software in ahash_finup(), tmpbuf was freed
> twice.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Rob Rice <rob.rice@broadcom.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
