Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F7DC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 08:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7B85216C4
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 08:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5hLKCNP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgLAIhz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgLAIhy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 03:37:54 -0500
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1A47216C4;
        Tue,  1 Dec 2020 08:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606811834;
        bh=e8JrzJWeuIo1NZeYPMcOvF7yCpKy+jzFNIQUQ88Bvqg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E5hLKCNPzPZ8UenenX+jbkaIda/JRuJ7VSF0RevT/+xfrHF2faxfp8xLuVAxyXxAc
         rfqHpbl+TXREjuhdw4SBWeqJ/Hu4vH2V8q/6vK+sF2tAuCpDxA9/PtyTaUoZ06xH8K
         yhlEXBBSkurzj6jqVS2UrXOwYXzAm3ZaSGPI0h1U=
Received: by mail-oi1-f182.google.com with SMTP id w15so933159oie.13;
        Tue, 01 Dec 2020 00:37:13 -0800 (PST)
X-Gm-Message-State: AOAM532vpzVYN+cv2vBEWVTMlGCq0dkUDCmX0X2sVbi/xBCzlSUyRuaS
        EvbDzuLhoVIZqrrwH6oQMpBUHRgmXDF6+VYxkaQ=
X-Google-Smtp-Source: ABdhPJx90wJXi/uYHsmH7ZqUTSQfpMzmABaIjcGD0/COs+03flTvBPfUTB+JmvdfainOr2k7yZGqlzw4R+oAFyTiBTE=
X-Received: by 2002:aca:b809:: with SMTP id i9mr1080357oif.174.1606811832882;
 Tue, 01 Dec 2020 00:37:12 -0800 (PST)
MIME-Version: 1.0
References: <20201015110241.89676-1-tianjia.zhang@linux.alibaba.com>
 <20201015120504.GA12976@gondor.apana.org.au> <f6d98764-dde8-6f40-c0e7-9eb5b087d713@linux.alibaba.com>
 <20201130022422.GA21049@gondor.apana.org.au> <df22e694-0a2e-811a-412e-269303c5d27d@linux.alibaba.com>
In-Reply-To: <df22e694-0a2e-811a-412e-269303c5d27d@linux.alibaba.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 1 Dec 2020 09:37:02 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFUG8Q8YB4M1GBsjcehrSMH8DYcPu4dFebxVAiZdew2gA@mail.gmail.com>
Message-ID: <CAMj1kXFUG8Q8YB4M1GBsjcehrSMH8DYcPu4dFebxVAiZdew2gA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecrdsa - use subsys_initcall instead of module_init
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Vitaly Chikunov <vt@altlinux.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Nov 2020 at 07:58, Tianjia Zhang
<tianjia.zhang@linux.alibaba.com> wrote:
>
>
>
> On 11/30/20 10:24 AM, Herbert Xu wrote:
> > On Mon, Nov 30, 2020 at 10:21:56AM +0800, Tianjia Zhang wrote:
> >>
> >>> That is true only if there are non-generic implementations of
> >>> the algorithms, which is not the case here.  Please explain the
> >>> real reason why this is needed.
> >>
> >> This is a generic algorithm, the author Vitaly Chikunov has also confi=
rmed
> >> it, please consider this patch again.
> >
> > As I said, the generic algorithm only needs to be loaded early *if*
> > there are non-generic implementations.
> >
> > Cheers,
> >
>
> For ecrdsa, there is no reason to advance the initialization to
> subsys_init, this is just to make code clean up to have algorithm
> initialization uniform with other implementations.
>
> It=E2=80=99s just that I think that in the commit c4741b230597 ("crypto: =
run
> initcalls for generic implementations earlier"), the modification to
> ecrdsa happened to be omitted, because from the point of commit time, it
> was submitted at the same time as the ecrdsa commits, and it may happen
> to be omitted for ecrdsa.
>

Whether or not it is a generic algorithm is irrelevant.

What is relevant is whether any other implementations exist of the
same algorithm, because in this case, the generic implementation must
be available earlier, so that it can be used for testing the other
implementation.

This concern does not apply for ecrdsa, so this patch is unnecessary.
