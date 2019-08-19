Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464CDC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 23:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23B9A22CF5
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 23:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfHSXfw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 19:35:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57882 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfHSXfv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 19:35:51 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hzrBd-0002PV-AY; Tue, 20 Aug 2019 09:35:41 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hzrBa-0002OH-P6; Tue, 20 Aug 2019 09:35:38 +1000
Date:   Tue, 20 Aug 2019 09:35:38 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v12 1/4] crypto: essiv - create wrapper template for
 ESSIV generation
Message-ID: <20190819233538.GB9089@gondor.apana.org.au>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
 <20190815192858.28125-2-ard.biesheuvel@linaro.org>
 <20190819063218.GA31821@gondor.apana.org.au>
 <CAKv+Gu9Zcaq5gygGtgmf5f4L6U6sBDd0CVAzrBydjiLDenyrag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Zcaq5gygGtgmf5f4L6U6sBDd0CVAzrBydjiLDenyrag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 19, 2019 at 05:14:25PM +0300, Ard Biesheuvel wrote:
>
> OK, but it should be the cra_driver_name not the cra_name. Otherwise,
> allocating essiv(cbc(aes),sha256-generic) may end up using a different
> implementation of sha256, which would be bad.

I agree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
