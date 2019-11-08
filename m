Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE270C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C47A4206BA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfKHJPH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 04:15:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:36782 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbfKHJPG (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 8 Nov 2019 04:15:06 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iT0M4-0001zl-6I; Fri, 08 Nov 2019 17:14:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iT0Ll-0002Ku-4Z; Fri, 08 Nov 2019 17:14:37 +0800
Date:   Fri, 8 Nov 2019 17:14:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 25/29] crypto: qat - switch to skcipher API
Message-ID: <20191108091437.kkpx3top6slrueuh@gondor.apana.org.au>
References: <20191105132826.1838-1-ardb@kernel.org>
 <20191105132826.1838-26-ardb@kernel.org>
 <20191107112616.GA744@silpixa00400314>
 <CAKv+Gu8TNmpmHCaKd2V=0oKTsrRufgUWc8S2bFN146kdN_jdcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8TNmpmHCaKd2V=0oKTsrRufgUWc8S2bFN146kdN_jdcA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 07, 2019 at 12:34:04PM +0100, Ard Biesheuvel wrote:
>
> Are you taking this directly, or would you like me to incorporate it
> into the next revision of my ablkcipher series? (assuming we'll need
> one)

Please squash it into your series.  Thanks Ard!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
