Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8083DC12002
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 07:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CF29611AE
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 07:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhGSHPB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 03:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234314AbhGSHPB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 03:15:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D45E5611AE
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 07:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626678721;
        bh=SfzfIESiqweKbJA1ZkJ1o77v1rHeHijV5oCcsieISZg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FyTGCQAQGRbn5WriW1wqxoIc6SGkUGdPQF30WZ+w/W6Td5dy9YpuNo/KVuAJEYIr3
         fDpI4zSU5VNysM55pNFWt0+ZuiTv98E1hgaYHbdFjhA9pOfNrKrt0Mc/8KOQsvxHbf
         XRevG48ipHRdyb6YMfZFZy0GF8bZ2x0ikeXHzmfXdhcex3bBkiKsBo+nn7/iMByCMY
         OiYgYrjiywaWYoLLMCOzlin2sut4oxuEEmvh9P5Cy0pHspb6mxAzXVQ9ETdiUf3LPl
         1GWhchKme8Bb9BEPJGL1MSU+4hX/AOj/sErL6JPe1y1nkueHRoYe8YWfZXtTn3NL8q
         J75xsWEJel0HA==
Received: by mail-ot1-f52.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so17310678otl.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 00:12:01 -0700 (PDT)
X-Gm-Message-State: AOAM530K9rCfMzSVFmDjrUtYpUjZ4bOe4Vq77qpoOx0ghReLPE3oDVmW
        oDfmWfkwhwlE0BfQb3p9ldpezPhQOFu2KQfgEtY=
X-Google-Smtp-Source: ABdhPJzXOGo5+Gqg2wwsjzhA51a+r7LwM9eS/lcDEEYNTxRzq7iuTe1tBXoZruF8FUG9XBvfl8h6pEioyfX5IsTjljs=
X-Received: by 2002:a9d:2625:: with SMTP id a34mr12685927otb.77.1626678721252;
 Mon, 19 Jul 2021 00:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210716165403.6115-1-ardb@kernel.org> <YPIdEwVJsOdrpJJH@quark.localdomain>
In-Reply-To: <YPIdEwVJsOdrpJJH@quark.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 19 Jul 2021 09:11:50 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEyoOnke4=bcCvKuqLP2On63XK2JUP-LgmoBi-H_m+XmA@mail.gmail.com>
Message-ID: <CAMj1kXEyoOnke4=bcCvKuqLP2On63XK2JUP-LgmoBi-H_m+XmA@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/aes-ni - add missing error checks in XTS code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dave Hansen <dave.hansen@intel.com>,
        syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 17 Jul 2021 at 01:58, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jul 16, 2021 at 06:54:03PM +0200, Ard Biesheuvel wrote:
> > The updated XTS code fails to check the return code of skcipher_walk_virt,
> > which may lead to skcipher_walk_abort() or skcipher_walk_done() being called
> > while the walk argument is in an inconsistent state.
> >
> > So check the return value after each such call, and bail on errors.
> >
> > Fixes: 2481104fe98d ("crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper")
>
> Add Cc stable?
>
> > Reported-by: Dave Hansen <dave.hansen@intel.com>
> > Reported-by: syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 5 +++++
> >  1 file changed, 5 insertions(+)
>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
>

Thanks Eric. Herbert can add the cc:stable if he decides to, but IIRC,
he prefers relying on the fixes: tag only.
