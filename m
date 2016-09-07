From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] char: hw_random: bcm2835: handle of_iomap failures in
 bcm2835 driver
Date: Wed, 7 Sep 2016 21:19:42 +0800
Message-ID: <20160907131942.GE17176@gondor.apana.org.au>
References: <1472490616-9597-1-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, lee@kernel.org,
        eric@anholt.net, yendapally.reddy@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44301 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752960AbcIGNUB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:20:01 -0400
Content-Disposition: inline
In-Reply-To: <1472490616-9597-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 29, 2016 at 10:40:16PM +0530, Arvind Yadav wrote:
> Check return value of of_iomap and handle errors correctly.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
