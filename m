From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [-next] crypto: 842 propagate PTR_ERR value instead of -ENOMEM
Date: Mon, 19 Jun 2017 14:28:33 +0800
Message-ID: <20170619062833.GA13622@gondor.apana.org.au>
References: <1496307446-12377-1-git-send-email-zhangshengju@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: haren@us.ibm.com, linux-crypto@vger.kernel.org
To: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59614 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752531AbdFSG25 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 02:28:57 -0400
Content-Disposition: inline
In-Reply-To: <1496307446-12377-1-git-send-email-zhangshengju@cmss.chinamobile.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Zhang Shengju <zhangshengju@cmss.chinamobile.com> wrote:
> It is better to propagate PTR_ERR value instead of a hardcoded
> value(-ENOMEM here).
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>

...

> -               return -ENOMEM;
> +               return PTR_ERR(ctx-wmem);

Please test your patches before submission.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
