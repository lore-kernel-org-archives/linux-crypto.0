Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D53FC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 13:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42D7320656
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 13:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgGaNaf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 09:30:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40552 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731291AbgGaNaf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 09:30:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k1V73-00016h-DV; Fri, 31 Jul 2020 23:30:18 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Jul 2020 23:30:17 +1000
Date:   Fri, 31 Jul 2020 23:30:17 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH 0/7] crypto: caam - updates for 5.9
Message-ID: <20200731133017.GF14360@gondor.apana.org.au>
References: <20200722121458.8478-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200722121458.8478-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 22, 2020 at 03:14:51PM +0300, Horia Geantă wrote:
> Hi Herbert,
> 
> This patch set contains a few caam driver updates.
> The fixes are minor and thus ok to go through the cryptodev tree.
> 
> Dan Douglass (1):
>   crypto: caam/jr - remove incorrect reference to caam_jr_register()
> 
> Franck LENORMAND (1):
>   crypto: caam - remove deadcode on 32-bit platforms
> 
> Horia Geantă (5):
>   crypto: caam/qi2 - fix error reporting for caam_hash_alloc
>   crypto: caam/qi2 - create ahash shared descriptors only once
>   crypto: caam - silence .setkey in case of bad key length
>   crypto: caam - add more RNG hw error codes
>   crypto: caam/qi2 - add module alias
> 
>  drivers/crypto/caam/caamalg.c     |  2 +-
>  drivers/crypto/caam/caamalg_qi.c  |  2 +-
>  drivers/crypto/caam/caamalg_qi2.c | 11 ++++++++---
>  drivers/crypto/caam/error.c       |  3 +++
>  drivers/crypto/caam/jr.c          |  3 +--
>  drivers/crypto/caam/regs.h        | 11 ++++++++---
>  6 files changed, 22 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
