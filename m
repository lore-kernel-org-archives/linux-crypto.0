Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A24C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5953B20896
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409245AbfFLN60 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 09:58:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56100 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409244AbfFLN60 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 09:58:26 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hb3lh-0008CA-AQ; Wed, 12 Jun 2019 21:58:25 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hb3lf-0000x6-8i; Wed, 12 Jun 2019 21:58:23 +0800
Date:   Wed, 12 Jun 2019 21:58:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [RFC PATCH 00/20] AES cleanup
Message-ID: <20190612135823.5w2dkibl4r7qcxx4@gondor.apana.org.au>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 02:48:18PM +0200, Ard Biesheuvel wrote:
>
> All the patches leading up to that are cleanups for the AES code, to reduce
> the dependency on the generic table based AES code, or in some cases, hardcoded
> dependencies on the scalar arm64 asm code which suffers from the same problem.
> It also removes redundant key expansion routines, and gets rid of the x86
> scalar asm code, which is a maintenance burden and is not actually faster than
> the generic code built with a modern compiler.

Nice, I like this a lot.

I presume you'll be converting the AES cipher users throughout
the kernel (such as net/ipv4/tcp_fastopen) at some point, right?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
