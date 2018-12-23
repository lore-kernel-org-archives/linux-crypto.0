Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38974 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbeLWECX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:02:23 -0500
Date: Sun, 23 Dec 2018 12:02:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: crypto_user_stat: remove unused dump
 functions
Message-ID: <20181223040216.ebailnnyyq4fzkpg@gondor.apana.org.au>
References: <1544690198-21993-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544690198-21993-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 13, 2018 at 08:36:37AM +0000, Corentin Labbe wrote:
> This patch removes unused dump functions for crypto_user_stats.
> There are remains of the copy/paste of crypto_user_base to
> crypto_user_stat and I forgot to remove them.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/crypto_user_base.c            |  4 +---
>  crypto/crypto_user_stat.c            | 33 ----------------------------
>  include/crypto/internal/cryptouser.h | 12 ----------
>  3 files changed, 1 insertion(+), 48 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
