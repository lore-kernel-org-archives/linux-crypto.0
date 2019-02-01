Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC98C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0196A20863
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfBAFbt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 00:31:49 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56550 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfBAFbt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 00:31:49 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpRQZ-0007fF-AD; Fri, 01 Feb 2019 13:31:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpRQY-0004vX-FN; Fri, 01 Feb 2019 13:31:46 +0800
Date:   Fri, 1 Feb 2019 13:31:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC/RFT PATCH 09/15] crypto: testmgr - introduce
 CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
Message-ID: <20190201053146.mgswr6w7zktl7cet@gondor.apana.org.au>
References: <20190123224926.250525-1-ebiggers@kernel.org>
 <20190123224926.250525-10-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123224926.250525-10-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 23, 2019 at 02:49:20PM -0800, Eric Biggers wrote:
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 86960aa53e0f..cbeba16fd8c1 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -168,6 +168,16 @@ config CRYPTO_MANAGER_DISABLE_TESTS
>  	  Disable run-time self tests that normally take place at
>  	  algorithm registration.
>  
> +config CRYPTO_MANAGER_EXTRA_TESTS
> +	bool "Enable extra run-time crypto self tests"
> +	depends on !CRYPTO_MANAGER_DISABLE_TESTS

Perhaps add a dependency on DEBUG_KERNEL so we don't bother people
who don't care?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
