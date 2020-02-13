Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEE8C2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 10:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C507D217F4
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 10:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581590676;
	bh=JbaaM3wCQgbP43CQfcEhVYnKbvSGI/oQuNsbU2J944Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AqcDZI9qlAjz50GxGcv3FuVJixGLY53Llraly5uW2UdV5i6ImisRJuuZvjzPm8phw
	 393G8TkoXO6Ci2lcyhZJv2GZLlmhVle/Nxo9DqdMefFwSuThr3fThuE3Jmuz0sev4n
	 d/b7UPkkfBVpHjo1W5xAtG3WsXh5hBcGt97tWg88=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgBMKog (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 05:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbgBMKog (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 05:44:36 -0500
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BFE324670
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2020 10:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581590675;
        bh=JbaaM3wCQgbP43CQfcEhVYnKbvSGI/oQuNsbU2J944Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d1EIBB3fpdOYfbZVDlipDaNZI7pfvlPVWpb//iA7HKs/0lMMjXl5mDJe5t4qceIAz
         5e2Uk1qNGCZ205/6pzh87+HEzpmGlgvHip0vzlAN41V5acTE0o0sEfLH+Ar0Zgvc3q
         DKvC4pdoosfd+AtmO4C8DnAMtJvycS+9DJ79Qx9I=
Received: by mail-wm1-f42.google.com with SMTP id p9so5650299wmc.2
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2020 02:44:35 -0800 (PST)
X-Gm-Message-State: APjAAAVB/42PQaCa5aLRivaEiNrSjyKxqOJfpTZeI5DyJVyMJZUiOOkE
        AWV92ELgOIqhAefm0Skyyr4frmSprWNVmyn1fFAV/g==
X-Google-Smtp-Source: APXvYqyeNAdVe/yqJLR6H0X+hoGPMP4zBD/FxKoWXql/TI0MpTRDK9n3nhyRYZYAox7MRIUl0lMPJapkr9XL/Aa5l2U=
X-Received: by 2002:a1c:b603:: with SMTP id g3mr5427492wmf.133.1581590673662;
 Thu, 13 Feb 2020 02:44:33 -0800 (PST)
MIME-Version: 1.0
References: <20200203233933.19577-1-mcroce@redhat.com> <20200213092355.i77luefms23jkud2@gondor.apana.org.au>
 <20200213103444.GA700076@zx2c4.com> <20200213103851.d26zufgvivamulcg@gondor.apana.org.au>
In-Reply-To: <20200213103851.d26zufgvivamulcg@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 13 Feb 2020 10:44:22 +0000
X-Gmail-Original-Message-ID: <CAKv+Gu8XYoCLPN3F3BbMXt6JbbhBvbHvEiyJZu=EdLGxc6tcwA@mail.gmail.com>
Message-ID: <CAKv+Gu8XYoCLPN3F3BbMXt6JbbhBvbHvEiyJZu=EdLGxc6tcwA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/poly1305: ignore build files
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Matteo Croce <mcroce@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 13 Feb 2020 at 11:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Feb 13, 2020 at 11:34:44AM +0100, Jason A. Donenfeld wrote:
> > On Thu, Feb 13, 2020 at 05:23:55PM +0800, Herbert Xu wrote:
> > > On Tue, Feb 04, 2020 at 12:39:33AM +0100, Matteo Croce wrote:
> > > > Add arch/arm64/crypto/poly1305-core.S to .gitignore
> > > > as it's built from poly1305-core.S_shipped
> > > >
> > > > Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> > > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > > ---
> > > >  arch/arm64/crypto/.gitignore | 1 +
> > > >  1 file changed, 1 insertion(+)
> > >
> > > Patch applied.  Thanks.
> >
> > Probably makes sense for 5.6, no?
>
> No this is too minor.  Only critical bug fixes (e.g., user
> triggerable crashes) or build issues are routinely accepted.
>

Sasha Levin's 'AI' bot finds everything with a 'fixes' tag and
proposes to backport it if it applies cleanly and doesn't break the
build, so this patch is going to end up in v5.6 anyway.
