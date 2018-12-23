Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38966 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbeLWEB5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:01:57 -0500
Date: Sun, 23 Dec 2018 12:01:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harsh@chelsio.com>
Cc: linux-crypto@vger.kernel.org, atul.gupta@chelsio.com,
        indranil@chelsio.com
Subject: Re: [PATCH 0/6] crypto:chelsio: Bug Fixes
Message-ID: <20181223040155.tptao3ftqm66xwcc@gondor.apana.org.au>
References: <cover.1544520025.git.harsh@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 11, 2018 at 04:21:36PM +0530, Harsh Jain wrote:
> It includes Bug Fixes
> 
> Harsh Jain (5):
>   crypto:chcr: Swap location of AAD and IV sent in WR
>   crypto:chcr:Use same value for both channel in single WR
>   crypto:chcr: cleanup:send addr as value in function argument
>   crypto:chelsio: Fix wrong error counter increments
>   Crypto:Chelsio:Handle PCI shutdown event
> 
> Atul Gupta (5):
>   crypto:chelsio: Reset counters on cxgb4 Detach
> 
>  drivers/crypto/chelsio/chcr_algo.c   | 401 +++++++++++++++++++++--------------
>  drivers/crypto/chelsio/chcr_algo.h   |   2 +-
>  drivers/crypto/chelsio/chcr_core.c   | 195 +++++++++++------
>  drivers/crypto/chelsio/chcr_core.h   |  35 ++-
>  drivers/crypto/chelsio/chcr_crypto.h |  10 +-
>  5 files changed, 407 insertions(+), 236 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
