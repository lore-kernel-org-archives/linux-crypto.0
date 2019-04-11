Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20568C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 06:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDCC620873
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 06:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfDKG05 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 02:26:57 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:40302 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfDKG05 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 02:26:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hETAm-0000km-9i; Thu, 11 Apr 2019 14:26:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hETAl-0002kA-39; Thu, 11 Apr 2019 14:26:55 +0800
Date:   Thu, 11 Apr 2019 14:26:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 18/18] crypto: run initcalls for generic
 implementations earlier
Message-ID: <20190411062655.evmjmf4vwjozkuog@gondor.apana.org.au>
References: <20190331200428.26597-19-ebiggers@kernel.org>
 <20190408055322.kke6emtixhhbkppn@gondor.apana.org.au>
 <20190408174402.GB9145@gmail.com>
 <20190409062409.gs5a6o2kuxeuztt2@gondor.apana.org.au>
 <20190409181608.GA122471@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409181608.GA122471@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 09, 2019 at 11:16:09AM -0700, Eric Biggers wrote:
>
> All modules are already loaded, but there's no "adiantum(xchacha12,aes)"
> algorithm directly available so it has be instantiated using the template.
> 
> Then with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the self-tests for the
> accelerated instance will allocate a generic instance to compare it against.
> This causes the generic instance to be tested and registered first, so the first
> user will get the generic instance, not the accelerated one as expected.

Thanks for the explanation Eric.

This sounds like a bug in how we mature the larvals where we should
not fulfil an outstanding request against an existing larval if a
higher-priority larval is still waiting for test completion.  Let me
see if I can come up with a fix for it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
