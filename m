Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9840CC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 15:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 717F920830
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 15:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfCVPHQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:07:16 -0400
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:56930 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725982AbfCVPHQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 11:07:16 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 6EB1C181D3419;
        Fri, 22 Mar 2019 15:07:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: iron05_21f39d98df515
X-Filterd-Recvd-Size: 3047
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 22 Mar 2019 15:07:13 +0000 (UTC)
Message-ID: <f8cb10b3dcce0703a652f2f544161abd41bc67f3.camel@perches.com>
Subject: Re: [possible PATCH] crypto: sahara - Use #ifdef DEBUG not
 IS_ENABLED(DEBUG)
From:   Joe Perches <joe@perches.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date:   Fri, 22 Mar 2019 08:07:12 -0700
In-Reply-To: <CAKv+Gu_SBkhV8SVXpOBDoPRBJYhFdmF3jJdZ5OPm3SrPBTSarQ@mail.gmail.com>
References: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
         <20190322124331.s5iu4ontsakv7he5@gondor.apana.org.au>
         <CAKv+Gu_SBkhV8SVXpOBDoPRBJYhFdmF3jJdZ5OPm3SrPBTSarQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2019-03-22 at 15:29 +0100, Ard Biesheuvel wrote:
> On Fri, 22 Mar 2019 at 13:43, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Thu, Mar 07, 2019 at 04:15:55PM -0800, Joe Perches wrote:
> > > Normal use of IS_ENABLED is with a CONFIG_<SYMBOL> and
> > > there is no -DDEBUG in the Makefile here.
> > > 
> > > Replace the IS_ENABLED(DEBUG) with #ifdef DEBUG/#endif
> > > blocks.
> > > 
> > > Miscellanea:
> > > 
> > > o Move the sahara_state array into the function that uses it.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > >  drivers/crypto/sahara.c | 20 +++++++++-----------
> > >  1 file changed, 9 insertions(+), 11 deletions(-)
> > 
> > Even if this is correct this is way too ugly.  The original code
> > at least compiled everything regardless of macros.  Your new code
> > won't detect compile errors in debugging code unless debugging is
> > enabled.
> > 
> 
> What's wrong with IS_ENABLED(DEBUG) anyway? It may not be 'normal use'
> but it works fine.

drivers/crypto/sahara.c is the only user in the kernel tree.
So only it's abnormal use.  I rather like the concept actually.

IS_ENABLED is almost exclusively used with CONFIG_<FOO> symbols
and it could be useful to require it to be used with CONFIG_<FOO>
symbols and use some other similar mechanism for DEBUG use.

Maybe just adding a global #define in kernel.h like

#define IS_DEBUG_ENABLED	IS_ENABLED(DEBUG)

to isolate this in one place might be better.

A good thing about using IS_ENABLED or the suggested IS_DEBUG_ENABLED
would be that least gcc 5+ seems to automatically elide the uses of any
unreferenced static const char * arrays like the sahara_state uses here.

(I don't have gcc4 anymore so I couldn't check that version)

So using 'if (IS_DEBUG_ENABLED)' could simplify some existing code like
the many uses of

#ifdef DEBUG
	...
#endif

or equivalent


