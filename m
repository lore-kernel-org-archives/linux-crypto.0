From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - add missing release in
 ccp_dmaengine_register
Date: Wed, 7 Sep 2016 21:21:30 +0800
Message-ID: <20160907132130.GJ17176@gondor.apana.org.au>
References: <20160902094853.21376-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51720 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753362AbcIGNVm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:21:42 -0400
Content-Disposition: inline
In-Reply-To: <20160902094853.21376-1-lambert.quentin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 02, 2016 at 11:48:53AM +0200, Quentin Lambert wrote:
> ccp_dmaengine_register used to return with an error code before
> releasing all resource. This patch adds a jump to the appropriate label
> ensuring that the resources are properly released before returning.
> 
> This issue was found with Hector.
> 
> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
