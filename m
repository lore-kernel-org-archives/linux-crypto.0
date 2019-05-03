Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B60C43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBBD42075E
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfECN0D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 09:26:03 -0400
Received: from [5.180.42.13] ([5.180.42.13]:38092 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbfECN0C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 09:26:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hMQnB-0005bI-IK; Fri, 03 May 2019 13:31:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hMQn7-0004Cj-HR; Fri, 03 May 2019 13:31:25 +0800
Date:   Fri, 3 May 2019 13:31:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH 3/7] crypto: caam - convert top level drivers to libraries
Message-ID: <20190503053125.rymyv7cwnee5mgmm@gondor.apana.org.au>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
 <20190425162501.4565-4-horia.geanta@nxp.com>
 <20190503051241.w5kya646beljkx34@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190503051241.w5kya646beljkx34@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 03, 2019 at 01:12:41PM +0800, Herbert Xu wrote:
> On Thu, Apr 25, 2019 at 07:24:57PM +0300, Horia Geantă wrote:
> >
> > @@ -86,8 +92,9 @@ config CRYPTO_DEV_FSL_CAAM_INTC_TIME_THLD
> >  	  threshold. Range is 1-65535.
> >  
> >  config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
> > -	tristate "Register algorithm implementations with the Crypto API"
> > +	bool "Register algorithm implementations with the Crypto API"
> >  	default y
> > +	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
> >  	select CRYPTO_AEAD
> >  	select CRYPTO_AUTHENC
> >  	select CRYPTO_BLKCIPHER
> 
> Why the change to bool? This will force everything to be built-in
> even if I'm just compile testing your driver.

OK I think this should be fine as it sits under a tristate further
up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
