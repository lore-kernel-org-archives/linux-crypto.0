From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell - Add a NULL entry at the end of
 mv_cesa_plat_id_table[]
Date: Mon, 6 Nov 2017 15:09:41 +0800
Message-ID: <20171106070941.GG14274@gondor.apana.org.au>
References: <20171103165201.18997-1-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51762 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751789AbdKFHKJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 02:10:09 -0500
Content-Disposition: inline
In-Reply-To: <20171103165201.18997-1-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 03, 2017 at 05:52:01PM +0100, Boris Brezillon wrote:
> struct platform_device_id should be NULL terminated to let the core detect
> where the last entry is.
> 
> Fixes: 07c50a8be41a ("crypto: marvell - Add a platform_device_id table")
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
