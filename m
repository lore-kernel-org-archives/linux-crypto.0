From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto/caam: Export gen_split_key symbol for other
 modules
Date: Fri, 24 Aug 2012 18:35:50 -0500
Message-ID: <20120824183550.0f27912aaf947cc035dabb9b@freescale.com>
References: <BD4C563D-C5E9-494F-91DD-EA145917FCEC@servergy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>
To: Ben Collins <ben.c@servergy.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:9948 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755632Ab2HXXia (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Aug 2012 19:38:30 -0400
In-Reply-To: <BD4C563D-C5E9-494F-91DD-EA145917FCEC@servergy.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 23 Aug 2012 18:39:57 -0400
Ben Collins <ben.c@servergy.com> wrote:

> In 3.6-rc3, without this patch, the following error occurs with a modular build:
> 
> ERROR: "gen_split_key" [drivers/crypto/caam/caamhash.ko] undefined!
> ERROR: "gen_split_key" [drivers/crypto/caam/caamalg.ko] undefined!
> 
> Signed-off-by: Ben Collins <ben.c@servergy.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Yuan Kang <Yuan.Kang@freescale.com>

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Kim
