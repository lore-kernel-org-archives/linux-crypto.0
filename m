Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF375C282DB
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD6820870
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfBAGuD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:50:03 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56966 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGuD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:50:03 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSeH-0000AD-TD; Fri, 01 Feb 2019 14:50:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSeF-0005mo-MG; Fri, 01 Feb 2019 14:49:59 +0800
Date:   Fri, 1 Feb 2019 14:49:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lars Persson <lars.persson@axis.com>
Cc:     linux-crypto@vger.kernel.org, Lars Persson <larper@axis.com>
Subject: Re: [PATCH 0/7] crypto: axis - fixes for the Artpec SoCs
Message-ID: <20190201064959.urcild7uckthjjnf@gondor.apana.org.au>
References: <cover.1548243646.git.larper@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1548243646.git.larper@axis.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 23, 2019 at 12:59:39PM +0100, Lars Persson wrote:
> Hi
> 
> This series brings to mainline fixes done during our product development and
> fixes for errors detected by the IPsec testsuite in LTP.
> 
> Lars Persson (6):
>   crypto: axis - remove sha384 support for artpec7
>   crypto: axis - remove sha512 support for artpec7
>   crypto: axis - fix for recursive locking from bottom half
>   crypto: axis - give DMA the start of the status buffer
>   crypto: axis - support variable AEAD tag length
>   crypto: axis - use a constant time tag compare
> 
> Vincent Whitchurch (1):
>   crypto: axis - move request unmap outside of the queue lock
> 
>  drivers/crypto/axis/artpec6_crypto.c | 317 ++++++++---------------------------
>  1 file changed, 71 insertions(+), 246 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
