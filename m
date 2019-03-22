Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C63C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 16:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BEDD218FC
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 16:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfCVQ32 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:29:28 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:39660 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726061AbfCVQ32 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 12:29:28 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 46CB3100E86C7;
        Fri, 22 Mar 2019 16:29:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wish39_182d8e060ce3f
X-Filterd-Recvd-Size: 2071
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Fri, 22 Mar 2019 16:29:26 +0000 (UTC)
Message-ID: <d5afa96440c81888aeedc66bedd1d45c7b8f58c3.camel@perches.com>
Subject: Re: [possible PATCH] crypto: sahara - Use #ifdef DEBUG not
 IS_ENABLED(DEBUG)
From:   Joe Perches <joe@perches.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date:   Fri, 22 Mar 2019 09:29:24 -0700
In-Reply-To: <CAKv+Gu8nds6WgE5UWj8iy=fr7AOmCsaQsrE4Dcj0oiNOXkkt6g@mail.gmail.com>
References: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
         <20190322124331.s5iu4ontsakv7he5@gondor.apana.org.au>
         <CAKv+Gu_SBkhV8SVXpOBDoPRBJYhFdmF3jJdZ5OPm3SrPBTSarQ@mail.gmail.com>
         <f8cb10b3dcce0703a652f2f544161abd41bc67f3.camel@perches.com>
         <CAKv+Gu8nds6WgE5UWj8iy=fr7AOmCsaQsrE4Dcj0oiNOXkkt6g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2019-03-22 at 17:21 +0100, Ard Biesheuvel wrote:
> On Fri, 22 Mar 2019 at 16:07, Joe Perches <joe@perches.com> wrote:
> > Maybe just adding a global #define in kernel.h like
> > #define IS_DEBUG_ENABLED        IS_ENABLED(DEBUG)
[]
> __is_defined(DEBUG) seems to be the most appropriate here. I don't
> feel strongly about whether we or not should wrap it in another macro.
[]
> > A good thing about using IS_ENABLED or the suggested IS_DEBUG_ENABLED
> > would be that least gcc 5+ seems to automatically elide the uses of any
> > unreferenced static const char * arrays like the sahara_state uses here.
[]
> My vote would be to use __is_defined(DEBUG) in place, but if others
> prefer wrapping it in a macro, that is also fine with me.

I think __is_defined is fine too.
Either works for me.


