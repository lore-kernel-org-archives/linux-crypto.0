Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E00C35669
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3022206EF
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgBVBlT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:41:19 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52174 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbgBVBlT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 20:41:19 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1j5Jmp-0002qz-1P; Sat, 22 Feb 2020 12:40:56 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2020 12:40:54 +1100
Date:   Sat, 22 Feb 2020 12:40:54 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Kitt <steve@sk2.org>
Cc:     Atul Gupta <atul.gupta@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: chelsio - remove extra allocation for chtls_dev
Message-ID: <20200222014054.GA18997@gondor.apana.org.au>
References: <20200124222051.1925415-1-steve@sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124222051.1925415-1-steve@sk2.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 24, 2020 at 11:20:51PM +0100, Stephen Kitt wrote:
> chtls_uld_add allocates room for info->nports net_device structs
> following the chtls_dev struct, presumably because it was originally
> intended that the ports array would be stored there. This is suggested
> by the assignment which was present in initial versions and removed by
> c4e848586cf1 ("crypto: chelsio - remove redundant assignment to
> cdev->ports"):
> 
> 	cdev->ports = (struct net_device **)(cdev + 1);
> 
> This assignment was never used, being overwritten by lldi->ports
> immediately afterwards, and I couldn't find any uses of the memory
> allocated past the end of the struct.
> 
> Signed-off-by: Stephen Kitt <steve@sk2.org>
> ---
>  drivers/crypto/chelsio/chtls/chtls_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
