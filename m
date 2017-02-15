From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers: crypto: cpt: cpt_bind_vq_to_grp could return an
 error code
Date: Wed, 15 Feb 2017 13:35:10 +0800
Message-ID: <20170215053510.GI14043@gondor.apana.org.au>
References: <1487064197-1659-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45051 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750732AbdBOFfX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:35:23 -0500
Content-Disposition: inline
In-Reply-To: <1487064197-1659-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 14, 2017 at 09:23:17AM +0000, George Cherian wrote:
> cpt_bind_vq_to_grp() could return an error code. However, it currently
> returns a u8. This produce the static checker warning.
> 
> drivers/crypto/cavium/cpt/cptpf_mbox.c:70 cpt_bind_vq_to_grp() warn: signedness bug returning '(-22)'
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: George Cherian <george.cherian@cavium.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
