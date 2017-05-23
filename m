From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] hw_random : omap3-rom-rng:- Handle return value of
 clk_prepare_enable
Date: Tue, 23 May 2017 13:00:12 +0800
Message-ID: <20170523050012.GA17569@gondor.apana.org.au>
References: <1494836523-7438-1-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:47962 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750993AbdEWFA3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 01:00:29 -0400
Content-Disposition: inline
In-Reply-To: <1494836523-7438-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 15, 2017 at 01:52:03PM +0530, Arvind Yadav wrote:
> Here, Clock enable can failed. So adding an error check for
> clk_prepare_enable.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
