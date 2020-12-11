Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB05CC4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F3922D72
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgLKKLL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 05:11:11 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33372 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731557AbgLKKKm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 05:10:42 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1knfMu-0004qD-WF; Fri, 11 Dec 2020 21:09:46 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Dec 2020 21:09:45 +1100
Date:   Fri, 11 Dec 2020 21:09:45 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH 0/5] crypto: caam - avoid allocating memory at crypto
 request runtime
Message-ID: <20201211100944.GA1133@gondor.apana.org.au>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
 <d454a0da-395d-3893-9ae1-f52236bcdde8@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d454a0da-395d-3893-9ae1-f52236bcdde8@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 10, 2020 at 10:28:35AM +0200, Horia Geantă wrote:
>
> Moving the memory allocations from caam driver into the generic crypto API
> has the side effect of dropping the GFP_DMA allocation flag.
> 
> For cases when caam device is limited to 32-bit address space and
> there's no IOMMU, this could lead to DMA API using bounce buffering.
> 
> We need to measure the performance impact of this change before deciding
> what we should do next.

This only applies to the control data, right? The actual data
being operated on surely is the most important factor.

In any case, did you respond to Ard's concern about potentially
exhausting DMA memory?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
