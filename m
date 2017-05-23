From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: img-hash - Handle return value of
 clk_prepare_enable
Date: Tue, 23 May 2017 13:00:34 +0800
Message-ID: <20170523050034.GB17569@gondor.apana.org.au>
References: <1494923261-18884-1-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, will.thomas@imgtec.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:47972 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757604AbdEWFAy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 01:00:54 -0400
Content-Disposition: inline
In-Reply-To: <1494923261-18884-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 16, 2017 at 01:57:41PM +0530, Arvind Yadav wrote:
> Here, Clock enable can failed. So adding an error check for
> clk_prepare_enable.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
