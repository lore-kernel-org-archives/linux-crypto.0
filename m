From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: crypto_user: Replace GFP_ATOMIC with GFP_KERNEL
 in crypto_report
Date: Thu, 15 Feb 2018 23:43:21 +0800
Message-ID: <20180215154321.GI7352@gondor.apana.org.au>
References: <1516874762-12046-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39522 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033987AbeBOPn0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 10:43:26 -0500
Content-Disposition: inline
In-Reply-To: <1516874762-12046-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 25, 2018 at 06:06:02PM +0800, Jia-Ju Bai wrote:
> After checking all possible call chains to crypto_report here,
> my tool finds that crypto_report is never called in atomic context.
> And crypto_report calls crypto_alg_match which calls down_read, 
> thus it proves again that crypto_report can call functions which may sleep.
> Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
