Return-Path: <SRS0=RoNa=TC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180BCC04AA8
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 12:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2AC02085A
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 12:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfEBMsS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 May 2019 08:48:18 -0400
Received: from [5.180.42.13] ([5.180.42.13]:58200 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbfEBMsR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 May 2019 08:48:17 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hMB8I-0007Az-I6; Thu, 02 May 2019 20:48:14 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hMB8F-0006nS-UW; Thu, 02 May 2019 20:48:12 +0800
Date:   Thu, 2 May 2019 20:48:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Message-ID: <20190502124811.l4yozv4llqtdvozx@gondor.apana.org.au>
References: <1852500.fyBc0DU23F@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1852500.fyBc0DU23F@positron.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan:

On Thu, May 02, 2019 at 02:40:51PM +0200, Stephan Müller wrote:
>
> +static int drbg_fips_continuous_test(struct drbg_state *drbg,
> +				     const unsigned char *entropy)
> +{
> +#ifdef CONFIG_CRYPTO_FIPS

Please use the IS_ENABLED macro from linux/kconfig.h so that all
of the code gets compiler coverage.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
