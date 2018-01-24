From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH] crypto: picoxcell - Fix error handling in spacc_probe()
Date: Wed, 24 Jan 2018 13:08:25 +0000
Message-ID: <20180124130825.tjcywfbcdfikklfl@willow>
References: <1516398795-9018-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jamie Iles <jamie@jamieiles.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:44437 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933571AbeAXNI1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 08:08:27 -0500
Received: by mail-wr0-f182.google.com with SMTP id w50so3951565wrc.11
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2018 05:08:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1516398795-9018-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks Alexey!

On Sat, Jan 20, 2018 at 12:53:15AM +0300, Alexey Khoroshilov wrote:
> If clk_get() fails, device_remove_file() looks inappropriate.
> 
> The error path, where all crypto_register fail, misses resource
> deallocations.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Reviewed-by: Jamie Iles <jamie@jamieiles.com>
