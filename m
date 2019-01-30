Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79980C282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 21:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31CA92184D
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 21:01:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="VOXAuruu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfA3VBJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 16:01:09 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:51676 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfA3VBJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 16:01:09 -0500
Received: by mail-it1-f195.google.com with SMTP id w18so528237ite.1
        for <linux-crypto@vger.kernel.org>; Wed, 30 Jan 2019 13:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjMxvtUGyvdMJmKFM2cu9vVa62OCkGlFeyT+Eg545qY=;
        b=VOXAuruuzM3naeCYrXul79K0++MGWQ7Ek+8Tx1+CDYjY+Bt3Fl8gfnOo19hYuopXya
         pjceY3vPn8V04CnBFf5ZDmksWxBAmd1dyYlD1r7NijuIWHmKDhdZlFbCR/R+HoTrxt0h
         Hv4/xl9goSaPBL30oPhgMLsOJHwhbudn4QPkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjMxvtUGyvdMJmKFM2cu9vVa62OCkGlFeyT+Eg545qY=;
        b=qjYzjc3E8enIZavxC+mRMf5MGSVY6lTwSHpM70UC5ymjW588vSIa/X2mgzh9h1Qhka
         8A7sse7m4bO98/kUmLnnDZNsF3hr7mwaFWA52HQ6NxgaeRDbWxZT1xwcbZewHfaxrDLh
         KbnAK9K/zofvPQfczSf4IJdmP6QZxtLc2hL3VUce8JSXw8KQRD8UY81hvwCX5qqgvME9
         XFQcdH7aKC0/BshCPs6++LbA5lmISNeVcF8kMwFQedJTzn5AWZBorAy9u+KanxsbEsQM
         wtUO7VWv2a56l13V4CzK+3zjbJsj8oWgqPeMKIiqpU77dfVnPyNA7mYgDB1bRF4SBW77
         g59g==
X-Gm-Message-State: AJcUukdR6bVdMHVRxBuj1ds6Q3aobPH0otLa1PDPaKDjYs3qp0f6ickV
        qdZPeq1WqUKbSvAsykYomExypRR1l0iSZpOQUlU7iw==
X-Google-Smtp-Source: ALg8bN7I73utdrxejqKmM9oYGl/sbIkFhFJbv1GG96aFFZ7+kloiyRhPMwxJQTCZFoKJ8oIWx4ogUyGjjoXFk0Ra/f0=
X-Received: by 2002:a02:734b:: with SMTP id a11mr18399958jae.62.1548882067736;
 Wed, 30 Jan 2019 13:01:07 -0800 (PST)
MIME-Version: 1.0
References: <20190130031444.28935-1-ebiggers@kernel.org> <20190130031444.28935-3-ebiggers@kernel.org>
 <20190130205553.GA231835@gmail.com>
In-Reply-To: <20190130205553.GA231835@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 30 Jan 2019 22:00:53 +0100
Message-ID: <CAKv+Gu95XurUKRqV7VR5X1ECfDqDEw78qS_ggn9pcG30S-6zFg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] crypto: arm/crct10dif-ce - cleanup and optimizations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 30 Jan 2019 at 21:55, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jan 29, 2019 at 07:14:43PM -0800, Eric Biggers wrote:
> > +     .macro          __adrl, out, sym
> > +     movw            \out, #:lower16:\sym
> > +     movt            \out, #:upper16:\sym
> > +     .endm
>
> Hi Ard, it seems we need the __LINUX_ARM_ARCH__ < 7 case after all?
> The kbuild test robot reported a build error, which can be reproduced with:
>
> ( cat arch/arm/configs/multi_v7_defconfig;
>   echo CONFIG_ARCH_MULTI_V6=y;
>   echo CONFIG_CRC_T10DIF=y;
>   echo CONFIG_CRYPTO_CRCT10DIF_ARM_CE=y ) > .config
> make olddefconfig
> make arch/arm/crypto/crct10dif-ce-core.o
>
>
>   AS      arch/arm/crypto/crct10dif-ce-core.o
> arch/arm/crypto/crct10dif-ce-core.S: Assembler messages:
> arch/arm/crypto/crct10dif-ce-core.S:165: Error: .err encountered
> arch/arm/crypto/crct10dif-ce-core.S:165: Error: selected processor does not support `movw fold_consts_ptr,#:lower16:.Lfold_across_128_bytes_consts' in ARM mode
> arch/arm/crypto/crct10dif-ce-core.S:165: Error: selected processor does not support `movt fold_consts_ptr,#:upper16:.Lfold_across_128_bytes_consts' in ARM mode
> arch/arm/crypto/crct10dif-ce-core.S:267: Error: .err encountered
> arch/arm/crypto/crct10dif-ce-core.S:267: Error: selected processor does not support `movw r3,#:lower16:.Lbyteshift_table+16' in ARM mode
> arch/arm/crypto/crct10dif-ce-core.S:267: Error: selected processor does not support `movt r3,#:upper16:.Lbyteshift_table+16' in ARM mode
> arch/arm/crypto/crct10dif-ce-core.S:329: Error: .err encountered
> arch/arm/crypto/crct10dif-ce-core.S:329: Error: selected processor does not support `movw fold_consts_ptr,#:lower16:.Lfold_across_16_bytes_consts' in ARM mode
> arch/arm/crypto/crct10dif-ce-core.S:329: Error: selected processor does not support `movt fold_consts_ptr,#:upper16:.Lfold_across_16_bytes_consts' in ARM mode
> scripts/Makefile.build:367: recipe for target 'arch/arm/crypto/crct10dif-ce-core.o' failed
> make[1]: *** [arch/arm/crypto/crct10dif-ce-core.o] Error 1
> Makefile:1709: recipe for target 'arch/arm/crypto/crct10dif-ce-core.o' failed
> make: *** [arch/arm/crypto/crct10dif-ce-core.o] Error 2
>

That does not make sense. That code can only execute on a NEON capable
CPU, which is guaranteed to support movw/movt as well. So I'd prefer
solving this by adding '.arch armv7-a' to this .S file.
