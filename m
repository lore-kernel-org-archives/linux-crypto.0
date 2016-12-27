From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 7/7] hwrng: core: Remove linux/sched.h from includes
Date: Tue, 27 Dec 2016 17:14:49 +0800
Message-ID: <20161227091449.GE10121@gondor.apana.org.au>
References: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
 <20161213145115.30082-7-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54311 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750846AbcL0JPM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 04:15:12 -0500
Content-Disposition: inline
In-Reply-To: <20161213145115.30082-7-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 03:51:15PM +0100, Corentin Labbe wrote:
> linux/sched.h is useless for hw_random/core.c.
> This patch remove it.

I see a schedule_timeout_interruptible call in core.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
