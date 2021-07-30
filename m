Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18648C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 02:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D6F60FE7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 02:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhG3Cz4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jul 2021 22:55:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51562 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhG3Cz4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jul 2021 22:55:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m9Igd-0000O1-NJ; Fri, 30 Jul 2021 10:55:47 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m9Iga-0003Kz-Py; Fri, 30 Jul 2021 10:55:44 +0800
Date:   Fri, 30 Jul 2021 10:55:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Latypov <dlatypov@google.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        brendanhiggins@google.com, davidgow@google.com,
        linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com
Subject: Re: [RFC v1 1/2] crypto: tcrypt: minimal conversion to run under
 KUnit
Message-ID: <20210730025544.GA12781@gondor.apana.org.au>
References: <20210715213138.1363079-1-dlatypov@google.com>
 <20210715213138.1363079-2-dlatypov@google.com>
 <20210723064328.GA7986@gondor.apana.org.au>
 <CAGS_qxqOD+Bcvy7xti7_eg8+H1cJcfp94BtnRhuzijDcaGF_uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS_qxqOD+Bcvy7xti7_eg8+H1cJcfp94BtnRhuzijDcaGF_uA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 23, 2021 at 12:31:28PM -0700, Daniel Latypov wrote:
>
> Thanks, that makes a lot of sense.
> In that case, how useful would `kunit.py run` be? I.e. Do people
> mostly want to see numbers on bare metal?

I think it's a mix of both.  As in performance on bare metal and
under virtualisation may be of interest.  I don't think you're going
to be going through kunit for the speed tests though, because you
need to supply module parameters for tcrypt to do that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
