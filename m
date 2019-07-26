Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080F8C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD727229F9
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGZMKS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:10:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49038 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfGZMKQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:10:16 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hqz2z-0001PB-Ua; Fri, 26 Jul 2019 14:10:06 +0200
Date:   Fri, 26 Jul 2019 14:10:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/7] crypto: ux500: Use spinlock_t instead of struct
 spinlock
In-Reply-To: <20190704153803.12739-2-bigeasy@linutronix.de>
Message-ID: <alpine.DEB.2.21.1907261409540.1791@nanos.tec.linutronix.de>
References: <20190704153803.12739-1-bigeasy@linutronix.de> <20190704153803.12739-2-bigeasy@linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 4 Jul 2019, Sebastian Andrzej Siewior wrote:

Polite reminder...

> For spinlocks the type spinlock_t should be used instead of "struct
> spinlock".
> 
> Use spinlock_t for spinlock's definition.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/crypto/ux500/cryp/cryp.h     | 4 ++--
>  drivers/crypto/ux500/hash/hash_alg.h | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/ux500/cryp/cryp.h b/drivers/crypto/ux500/cryp/cryp.h
> index bd89504e81678..8da7f87b339b4 100644
> --- a/drivers/crypto/ux500/cryp/cryp.h
> +++ b/drivers/crypto/ux500/cryp/cryp.h
> @@ -241,12 +241,12 @@ struct cryp_device_data {
>  	struct clk *clk;
>  	struct regulator *pwr_regulator;
>  	int power_status;
> -	struct spinlock ctx_lock;
> +	spinlock_t ctx_lock;
>  	struct cryp_ctx *current_ctx;
>  	struct klist_node list_node;
>  	struct cryp_dma dma;
>  	bool power_state;
> -	struct spinlock power_state_spinlock;
> +	spinlock_t power_state_spinlock;
>  	bool restore_dev_ctx;
>  };
>  
> diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
> index ab2bd00c1c365..7c9bcc15125ff 100644
> --- a/drivers/crypto/ux500/hash/hash_alg.h
> +++ b/drivers/crypto/ux500/hash/hash_alg.h
> @@ -366,10 +366,10 @@ struct hash_device_data {
>  	phys_addr_t             phybase;
>  	struct klist_node	list_node;
>  	struct device		*dev;
> -	struct spinlock		ctx_lock;
> +	spinlock_t		ctx_lock;
>  	struct hash_ctx		*current_ctx;
>  	bool			power_state;
> -	struct spinlock		power_state_lock;
> +	spinlock_t		power_state_lock;
>  	struct regulator	*regulator;
>  	struct clk		*clk;
>  	bool			restore_dev_state;
> -- 
> 2.20.1
> 
> 
