Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17507C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 10:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAAF7206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 10:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfGaK6V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 06:58:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40262 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfGaK6V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 06:58:21 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hsmJ3-0003yI-8S; Wed, 31 Jul 2019 20:58:05 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hsmIu-0005KP-Ox; Wed, 31 Jul 2019 20:57:56 +1000
Date:   Wed, 31 Jul 2019 20:57:56 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Stephan Mueller <smueller@chronox.de>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC 3/3] crypto/sha256: Build the SHA256 core separately from
 the crypto module
Message-ID: <20190731105756.GA20469@gondor.apana.org.au>
References: <20190730123835.10283-1-hdegoede@redhat.com>
 <20190730123835.10283-4-hdegoede@redhat.com>
 <4384403.bebDo606LH@tauon.chronox.de>
 <20190730160335.GA27287@gmail.com>
 <cb888bfa-dd46-de7a-3b90-b54fa79fa3d4@redhat.com>
 <20190730200719.GB27287@gmail.com>
 <3d9fcb23-edf5-eaf4-53f2-5a455fa45110@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d9fcb23-edf5-eaf4-53f2-5a455fa45110@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 31, 2019 at 10:19:30AM +0200, Hans de Goede wrote:
> On 30-07-19 22:07, Eric Biggers wrote:
>
> >Well, seems like the solution needs to involve unifying the implementations.
> >
> >Note that Ard Biesheuvel recently added the arc4 and aes algorithms to
> >lib/crypto/, with options CONFIG_CRYPTO_LIB_ARC4 and CONFIG_CRYPTO_LIB_AES.  How
> >about following the same convention, rather than doing everything slightly
> >differently w.r.t. code organization, function naming, Kconfig option, etc.?
> 
> I'm fine with that, I'm still waiting for feedback from the crypto maintainers
> that they are open to doing that ...
> 
> Herbert? Dave?

I fully agree with what Eric said.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
