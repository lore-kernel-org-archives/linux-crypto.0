Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37492 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbeJQOUQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 10:20:16 -0400
Date: Wed, 17 Oct 2018 14:21:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam/qi - simplify CGR allocation, freeing
Message-ID: <20181017062123.fykdj2ixrpfzk7eq@gondor.apana.org.au>
References: <20181005125443.dfhd2asqktm22ney@linutronix.de>
 <20181008110937.29198-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181008110937.29198-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 08, 2018 at 02:09:37PM +0300, Horia Geantă wrote:
> CGRs (Congestion Groups) have to be freed by the same CPU that
> initialized them.
> This is why currently the driver takes special measures; however, using
> set_cpus_allowed_ptr() is incorrect - as reported by Sebastian.
> 
> Instead of the generic solution of replacing set_cpus_allowed_ptr() with
> work_on_cpu_safe(), we use the qman_delete_cgr_safe() QBMan API instead
> of qman_delete_cgr() - which internally takes care of proper CGR
> deletion.
> 
> Link: https://lkml.kernel.org/r/20181005125443.dfhd2asqktm22ney@linutronix.de
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/qi.c | 43 ++++---------------------------------------
>  drivers/crypto/caam/qi.h |  2 +-
>  2 files changed, 5 insertions(+), 40 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
