Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA3AC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33E64218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfAYKr2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:47:28 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44434 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYKr2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:47:28 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmz1C-0005fa-Gf; Fri, 25 Jan 2019 18:47:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmz1B-00025F-MC; Fri, 25 Jan 2019 18:47:25 +0800
Date:   Fri, 25 Jan 2019 18:47:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, dt@chelsio.com
Subject: Re: [PATCH 1/2] crypto/chelsio: avoid using sa_entry imm
Message-ID: <20190125104725.pb4lhhkal6yrilnh@gondor.apana.org.au>
References: <20190117171835.6029-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117171835.6029-1-atul.gupta@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 17, 2019 at 09:18:35AM -0800, Atul Gupta wrote:
> use is_eth_imm to determine immediate data than use sa_entry
> field which is common for tunnel and not per skb.
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_core.h  |  2 +-
>  drivers/crypto/chelsio/chcr_ipsec.c | 10 ++++------
>  2 files changed, 5 insertions(+), 7 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
