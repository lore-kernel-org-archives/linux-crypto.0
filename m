From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - mark ctr(des3_ede) as fips_allowed
Date: Fri, 24 Mar 2017 22:14:39 +0800
Message-ID: <20170324141439.GI14780@gondor.apana.org.au>
References: <1490041685-25947-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Stephan Muller <stephan.mueller@atsec.com>
To: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42726 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936123AbdCXOPI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:15:08 -0400
Content-Disposition: inline
In-Reply-To: <1490041685-25947-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 20, 2017 at 05:28:05PM -0300, Marcelo Henrique Cerri wrote:
> 3DES is missing the fips_allowed flag for CTR mode.
> 
> Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
