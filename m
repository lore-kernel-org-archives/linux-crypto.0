Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8214C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 06:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3E164E59
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 06:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhBHGhE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:37:04 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:59096 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhBHGge (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 01:36:34 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 7409972C8B4;
        Mon,  8 Feb 2021 09:35:41 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 4A4554A474B;
        Mon,  8 Feb 2021 09:35:41 +0300 (MSK)
Date:   Mon, 8 Feb 2021 09:35:41 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stefan Berger <stefanb@linux.ibm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Meng Yu <yumeng18@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Zaibo Xu <xuzaibo@huawei.com>, wangzhou1@hisilicon.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Patrick Uiterwijk <patrick@puiterwijk.org>
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
Message-ID: <20210208063541.ribifj3445djxfy5@altlinux.org>
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
 <1611299395-675-5-git-send-email-yumeng18@huawei.com>
 <20210128050354.GA30874@gondor.apana.org.au>
 <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
 <ff63fffd-2d65-337f-d802-adcf4352fdc3@linux.ibm.com>
 <20210129030004.GA3463@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210129030004.GA3463@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

On Fri, Jan 29, 2021 at 02:00:04PM +1100, Herbert Xu wrote:
> On Thu, Jan 28, 2021 at 09:49:41PM -0500, Stefan Berger wrote:
> >
> > In my patch series I initially had registered the akciphers under the names
> > ecc-nist-p192 and ecc-nist-p256 but now, in V4, joined them together as
> > 'ecdsa'. This may be too generic for a name. Maybe it should be called
> > ecsda-nist for the NIST family.
> 
> What I'm proposing is specifying the curve in the name as well, i.e.,
> ecdsa-nist-p192 instead of just ecdsa or ecdsa-nist.
> 
> This simplifies the task of handling hardware that only supports a
> subset of curves.

So, if some implementation supports multiple curves (like EC-RDSA
currently supports 5 curves), it should add 5 ecrdsa-{a,b,c,..}
algorithms with actually the same top level implementation?
Right?


> There is a parallel discussion of exactly what curves we should
> support in the kernel.  Personally if there is a user in the kernel
> for it then I'm happy to see it added.  In your specific case, as
> long as your use of the algorithm in x509 is accepted then I don't
> have any problems with adding support in the Crypto API.
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
