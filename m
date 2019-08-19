Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AC6C3A59B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 06:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BD3A20851
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 06:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfHSGdu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 02:33:50 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57704 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfHSGdu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 02:33:50 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hzbEh-0007Fs-4y; Mon, 19 Aug 2019 16:33:47 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hzbEf-0008KV-Uw; Mon, 19 Aug 2019 16:33:45 +1000
Date:   Mon, 19 Aug 2019 16:33:45 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, gmazyland@gmail.com,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH v2] crypto: xts - add support for ciphertext stealing
Message-ID: <20190819063345.GB31821@gondor.apana.org.au>
References: <20190809171457.12400-1-ard.biesheuvel@linaro.org>
 <20190815120800.GI29355@gondor.apana.org.au>
 <20190816010233.GA653@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816010233.GA653@sol.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 15, 2019 at 06:02:33PM -0700, Eric Biggers wrote:
> 
> I'm confused why this was applied as-is, since there are no test vectors for
> this added yet.  Nor were any other XTS implementations updated yet, so now
> users see inconsistent behavior, and all the XTS comparison fuzz tests fail.
> What is the plan for addressing these?  I had assumed that as much as possible
> would be fixed up at once.

Yes we should get all the arch xts code fixed up but as far as
the fuzz testing status is concerned we were already broken in
that some drivers supported this while the generic code didn't
so I don't think this makes it that much worse.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
