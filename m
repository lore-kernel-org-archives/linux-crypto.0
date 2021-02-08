Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B94BC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 21:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A0164E26
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 21:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhBHV2h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 16:28:37 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:39638 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbhBHV2b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 16:28:31 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 2849772C8B4;
        Tue,  9 Feb 2021 00:27:46 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 05B704A474B;
        Tue,  9 Feb 2021 00:27:46 +0300 (MSK)
Date:   Tue, 9 Feb 2021 00:27:45 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Berger <stefanb@linux.ibm.com>,
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
Message-ID: <20210208212745.yi5shr4gkmdqy4xl@altlinux.org>
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
 <1611299395-675-5-git-send-email-yumeng18@huawei.com>
 <20210128050354.GA30874@gondor.apana.org.au>
 <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
 <ff63fffd-2d65-337f-d802-adcf4352fdc3@linux.ibm.com>
 <20210129030004.GA3463@gondor.apana.org.au>
 <20210208063541.ribifj3445djxfy5@altlinux.org>
 <CAMj1kXF18T11WQm6coYOO8yD7g=AxSBDP1QjWghWRVAp6dCJ8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <CAMj1kXF18T11WQm6coYOO8yD7g=AxSBDP1QjWghWRVAp6dCJ8w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard,

On Mon, Feb 08, 2021 at 07:47:44AM +0100, Ard Biesheuvel wrote:
> On Mon, 8 Feb 2021 at 07:37, Vitaly Chikunov <vt@altlinux.org> wrote:
> >
> > Herbert,
> >
> > On Fri, Jan 29, 2021 at 02:00:04PM +1100, Herbert Xu wrote:
> > > On Thu, Jan 28, 2021 at 09:49:41PM -0500, Stefan Berger wrote:
> > > >
> > > > In my patch series I initially had registered the akciphers under the names
> > > > ecc-nist-p192 and ecc-nist-p256 but now, in V4, joined them together as
> > > > 'ecdsa'. This may be too generic for a name. Maybe it should be called
> > > > ecsda-nist for the NIST family.
> > >
> > > What I'm proposing is specifying the curve in the name as well, i.e.,
> > > ecdsa-nist-p192 instead of just ecdsa or ecdsa-nist.
> > >
> > > This simplifies the task of handling hardware that only supports a
> > > subset of curves.
> >
> > So, if some implementation supports multiple curves (like EC-RDSA
> > currently supports 5 curves), it should add 5 ecrdsa-{a,b,c,..}
> > algorithms with actually the same top level implementation?
> > Right?
> >
> 
> Yes. The only difference will be the init() function, which can be
> used to set the TFM properties that define which curve is being used.
> The other routines can be generic, and refer to those properties if
> the behavior is curve-specific.

Thanks. This may be good!

JFYI. There is possible non-hardware accelerated implementations
for ECC algorithms which (perhaps) may never go to the kernel source,
because they are generated code. For example
  https://gitlab.com/nisec/ecckiila

