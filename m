Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218B6C64E8A
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 02:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D45B720757
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 02:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgK3CZR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:25:17 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40860 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgK3CZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Nov 2020 21:25:17 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kjYrW-00023w-Fi; Mon, 30 Nov 2020 13:24:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 30 Nov 2020 13:24:22 +1100
Date:   Mon, 30 Nov 2020 13:24:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Vitaly Chikunov <vt@altlinux.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecrdsa - use subsys_initcall instead of
 module_init
Message-ID: <20201130022422.GA21049@gondor.apana.org.au>
References: <20201015110241.89676-1-tianjia.zhang@linux.alibaba.com>
 <20201015120504.GA12976@gondor.apana.org.au>
 <f6d98764-dde8-6f40-c0e7-9eb5b087d713@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6d98764-dde8-6f40-c0e7-9eb5b087d713@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 30, 2020 at 10:21:56AM +0800, Tianjia Zhang wrote:
>
> > That is true only if there are non-generic implementations of
> > the algorithms, which is not the case here.  Please explain the
> > real reason why this is needed.
> 
> This is a generic algorithm, the author Vitaly Chikunov has also confirmed
> it, please consider this patch again.

As I said, the generic algorithm only needs to be loaded early *if*
there are non-generic implementations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
