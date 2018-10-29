Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:51360 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbeJ2RoX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 13:44:23 -0400
Date: Mon, 29 Oct 2018 09:56:29 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Horia Geanta <horia.geanta@nxp.com>
Cc: Roy Pledge <roy.pledge@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/qi - simplify CGR allocation, freeing
Message-ID: <20181029085629.55exxlamujlyvs3n@linutronix.de>
References: <20181005125443.dfhd2asqktm22ney@linutronix.de>
 <20181008110937.29198-1-horia.geanta@nxp.com>
 <20181009171101.jk6lgdx4g5rnq7cm@linutronix.de>
 <VI1PR0402MB3485A342A184BEBB004E74F998F70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485A342A184BEBB004E74F998F70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2018-10-25 14:05:32 [+0000], Horia Geanta wrote:
> > Now, what is the problem with the CPU limitation? Is this a HW
> > limitation that you can access the registers from a certain CPU?
> > 
> Roy confirmed the CPU limitation should actually be removed, there is nothing in
> HW requiring it.
> A clean-up patch will follow.

good. Thank you.

> Thanks,
> Horia

Sebastian
