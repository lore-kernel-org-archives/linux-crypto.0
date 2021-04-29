Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD702C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C27961440
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 00:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhD2AT3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Apr 2021 20:19:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36220 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231858AbhD2AT2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Apr 2021 20:19:28 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lbuO4-0007Ho-UQ; Thu, 29 Apr 2021 08:18:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lbuO2-0007DD-3b; Thu, 29 Apr 2021 08:18:34 +0800
Date:   Thu, 29 Apr 2021 08:18:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Revert "crypto: cavium/nitrox - add an error message to
 explain the failure of pci_request_mem_regions"
Message-ID: <20210429001834.liqriwtjetecfnr6@gondor.apana.org.au>
References: <YIkTi9a3nnL50wMq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIkTi9a3nnL50wMq@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 28, 2021 at 09:49:31AM +0200, Greg Kroah-Hartman wrote:
> This reverts commit 9fcddaf2e28d779cb946d23838ba6d50f299aa80 as it was
> submitted under a fake name and we can not knowingly accept anonymous
> contributions to the repository.
> 
> This commit was part of a submission "test" to the Linux kernel
> community by some "researchers" at umn.edu.  As outlined at:
> 	https://www-users.cs.umn.edu/%7Ekjlu/papers/full-disclosure.pdf
> it was done so as an attempt to submit a known-buggy patch to see if it
> could get by our review.  However, the submission turned out to actually
> be correct, and not have a bug in it as the author did not understand
> how the PCI driver model works at all, and so the submission was
> accepted.
> 
> As this change is of useless consequence, there is no loss of
> functionality in reverting it.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> Herbert, I will be taking this as part of my larger "revert buggy patch
> submissions from umn.edu" tree, so no need for you to take this in your
> tree at this point in time, I just wanted to give you a heads up as to
> what is happening here.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
