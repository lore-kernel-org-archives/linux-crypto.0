Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB10C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 01:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DD032082C
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 01:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405599AbfIGBTo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 21:19:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60898 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfIGBTo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 21:19:44 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i6PO9-0003eF-1w; Sat, 07 Sep 2019 11:19:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Sep 2019 11:19:40 +1000
Date:   Sat, 7 Sep 2019 11:19:40 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: skcipher - Unmap pages after an external error
Message-ID: <20190907011940.GA8663@gondor.apana.org.au>
References: <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
 <20190903065438.GA9372@gondor.apana.org.au>
 <20190903135020.GB5144@zzz.localdomain>
 <20190903223641.GA7430@gondor.apana.org.au>
 <20190905052217.GA722@sol.localdomain>
 <20190905054032.GA3022@gondor.apana.org.au>
 <20190906015753.GA803@sol.localdomain>
 <20190906021550.GA17115@gondor.apana.org.au>
 <20190906031306.GA20435@gondor.apana.org.au>
 <CAKv+Gu8n5AtzzRG-avEsAjcrNSGKKcs73VRneDTJeTsNc+fUrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8n5AtzzRG-avEsAjcrNSGKKcs73VRneDTJeTsNc+fUrA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 06, 2019 at 05:52:56PM -0700, Ard Biesheuvel wrote:
>
> With this change, we still copy out the output in the
> SKCIPHER_WALK_COPY or SKCIPHER_WALK_SLOW cases. I'd expect the failure
> case to only do the kunmap()s, but otherwise not make any changes that
> are visible to the caller.

I don't think it matters.  After all, for the fast/common path
whatever changes that have been made will be visible to the caller.
I don't see the point in making the slow-path different in this
respect.  It also makes no sense to optimise specifically for the
uncommon error case on the slow-path.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
