Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FDFC433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 12:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E505206EB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 12:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599136341;
	bh=yWbf0IQWQYG8GUApvqXEYmzQbtffQP1dqs9sWRRBJYc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=DNMseKi5FMn6Do0+v+P29djJbMTQLj1iKp+vFw2OMt4cxTC2L/bx2Z8zh9V2YjU8l
	 7jJSIOAfg/DegEKd8or426L1s90rY+GHcXVIJLQEK0H6R5nkXA4rCBWXwN5Lq0zzk6
	 ywNWmMN47TQzUZAyqN+7kmlOe9kLkohz2sw1HKb8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgICMbX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 08:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728875AbgICMbC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 08:31:02 -0400
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8BB820786;
        Thu,  3 Sep 2020 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599135689;
        bh=yWbf0IQWQYG8GUApvqXEYmzQbtffQP1dqs9sWRRBJYc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=v0u/xa9UJLUXrcWTZZoUMemPv+zBd3CSMpgN589Suv8VQ1s2XkrmOvk0DKpCHcV9h
         +dtPze1EGoTag6uBqgmM+xje7iv1HeWIjYXOV4pZBnBR+pLeQTXu8+AmpBUgAkJix7
         vqYjvd43z1HisoswK7ROdFWnV2NJDW/HlftwNars=
Received: by mail-ej1-f47.google.com with SMTP id a15so3512473ejf.11;
        Thu, 03 Sep 2020 05:21:28 -0700 (PDT)
X-Gm-Message-State: AOAM530KlP1INTDQ8mPvZZVj5n5n3Xuef0kalsZD7CN4dDXQOlhu9tQJ
        psvHJTA1iLWj8YmEaok0ptAJ1jI6IAuWlFuUt08=
X-Google-Smtp-Source: ABdhPJzJRFulG1b/WDsGvl2hfP2WPQAa7GdutvEhBtO7QHdWlTs5d/drIeB5SLH6d3FMPswoRFOciAGFyokm39RWT10=
X-Received: by 2002:a17:907:724f:: with SMTP id ds15mr1405794ejc.119.1599135687298;
 Thu, 03 Sep 2020 05:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200902150530.14640-1-krzk@kernel.org> <a273f81f-cdf9-70ae-3691-816fa24be0a9@nxp.com>
In-Reply-To: <a273f81f-cdf9-70ae-3691-816fa24be0a9@nxp.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 3 Sep 2020 14:21:16 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfpvnMr9UnyQ3vSJOmNdNqAXdVnCDJ8W9OF=rH_amaOvQ@mail.gmail.com>
Message-ID: <CAJKOXPfpvnMr9UnyQ3vSJOmNdNqAXdVnCDJ8W9OF=rH_amaOvQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: caam - Fix kerneldoc
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 3 Sep 2020 at 14:08, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> On 9/2/2020 6:05 PM, Krzysztof Kozlowski wrote:
> > Fix kerneldoc warnings:
> >
> >    drivers/crypto/caam/caamalg_qi2.c:73: warning: cannot understand function prototype: 'struct caam_ctx '
> >    drivers/crypto/caam/caamalg_qi2.c:2962: warning: cannot understand function prototype: 'struct caam_hash_ctx '
> >
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > ---
> This LGTM, but, while here, can you, please, check the other kernel-doc
> warnings:
> drivers/crypto/caam/ctrl.c:449: warning: Function parameter or member
> 'ctrl' not described in 'caam_get_era'
> drivers/crypto/caam/jr.c:331: warning: Function parameter or member
> 'rdev' not described in 'caam_jr_free'
> drivers/crypto/caam/jr.c:369: warning: Excess function parameter
> 'status' description in 'caam_jr_enqueue'
> drivers/crypto/caam/caamalg_desc.c:387: warning: Function parameter or
> member 'geniv' not described in 'cnstr_shdsc_aead_decap'

Sure, I'll take a look.

Best regards,
Krzysztof
