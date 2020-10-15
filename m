Return-Path: <SRS0=zNo2=DW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A895EC433E7
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 12:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FAB2145D
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 12:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgJOMFQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Oct 2020 08:05:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:45404 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727139AbgJOMFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Oct 2020 08:05:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kT20H-00032D-2t; Thu, 15 Oct 2020 23:05:06 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2020 23:05:05 +1100
Date:   Thu, 15 Oct 2020 23:05:05 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecrdsa - use subsys_initcall instead of
 module_init
Message-ID: <20201015120504.GA12976@gondor.apana.org.au>
References: <20201015110241.89676-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015110241.89676-1-tianjia.zhang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 15, 2020 at 07:02:41PM +0800, Tianjia Zhang wrote:
> All templates and generic algorithms have been registered in
> subsys_initcall instead of module_init. The ecrdsa algorithm
> happened to be missed. Here is a fix for it.

That is true only if there are non-generic implementations of
the algorithms, which is not the case here.  Please explain the
real reason why this is needed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
