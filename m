Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9870AC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3C020B1F
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgGWH4y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 03:56:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34674 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgGWH4x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 03:56:53 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyW5b-0005td-7Q; Thu, 23 Jul 2020 17:56:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Jul 2020 17:56:27 +1000
Date:   Thu, 23 Jul 2020 17:56:27 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        j-keerthy@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv6 0/7] crypto: add driver for TI K3 SA2UL
Message-ID: <20200723075627.GA14246@gondor.apana.org.au>
References: <20200713083427.30117-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713083427.30117-1-t-kristo@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 13, 2020 at 11:34:20AM +0300, Tero Kristo wrote:
> Hi,
> 
> V6 has only a bunch of static checker warnings fixed. Tested building
> with W=1 and C=1 make options, also did a sanity test with crypto
> manager tests + extra tests, and did a quick trial with tcrypt.

Patches 1-5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
