Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDDEC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3892207BC
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598510424;
	bh=kgC/LeoD3L7v/aBecO8Vc8WQYmx2GmXIl0JTWg4zM18=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=gWZVa7So3boHDM/Oy+fyhwss6p83XLT3gxfnBN+TWFlf3PhNL51IG7Cxu6xghb8bE
	 IqaWm5DVuLv52nFqwI91JxmxOru2dNNm+ld/8moTx/Sk/ld1ylOQDXc0r7J0BpuwZw
	 xJpJIINF0eMYI9o/03c0AvdggUtZau/pnwPxa3fE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgH0GkS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgH0GkN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 02:40:13 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCBF722B4D;
        Thu, 27 Aug 2020 06:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598510412;
        bh=kgC/LeoD3L7v/aBecO8Vc8WQYmx2GmXIl0JTWg4zM18=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=heY28vwNYrdL25PvklxzVcOiJEp1BsuE4gSuoCKA+1eN9n4P2w+kDywf7QqJ6KzVR
         xOSYRpJXbUEHLTSxjSk69WJDo09qbs/dh9TuYlMgxe51yS+kCFcAn+fu53AaHHrYDm
         SDfZV2kYt+iw5fsjJGvysuNBd8iNX1fYXEqdypPU=
Received: by mail-oi1-f177.google.com with SMTP id j21so3732984oii.10;
        Wed, 26 Aug 2020 23:40:12 -0700 (PDT)
X-Gm-Message-State: AOAM530E+mlT9wWmBz+UM+U0k8AkMvsclS2gM+Dl/wIGkR7A1KD97jUN
        3WM/0q8VyoYOvi5D9DBBXjK3Od6jUOSzHgOVpA0=
X-Google-Smtp-Source: ABdhPJxus6DiBRAB1fIqohnewgwDtCgrNfEulF5QdjkIkNWJihBzpH7QoDWG8FAe9QBHL6uNOsdh/crajKixmjGXXbs=
X-Received: by 2002:a05:6808:b37:: with SMTP id t23mr6303306oij.174.1598510412227;
 Wed, 26 Aug 2020 23:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au> <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au> <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826130010.GA3232@gondor.apana.org.au> <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
 <20200826141907.GA5111@gondor.apana.org.au> <4bb6d926-a249-8183-b3d9-05b8e1b7808a@gmail.com>
 <CAMj1kXEn507bEt+eT6q7MpCwNH=oAZsTkFRz0t=kPEV0QxFsOQ@mail.gmail.com> <20200826221913.GA16175@gondor.apana.org.au>
In-Reply-To: <20200826221913.GA16175@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Aug 2020 08:40:01 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH-qZZhw5D5sBEVFP9=Z04pU+xCnQ78sDDw6WuSM-pRGQ@mail.gmail.com>
Message-ID: <CAMj1kXH-qZZhw5D5sBEVFP9=Z04pU+xCnQ78sDDw6WuSM-pRGQ@mail.gmail.com>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Aug 2020 at 00:19, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Aug 26, 2020 at 05:42:27PM +0200, Ard Biesheuvel wrote:
> >
> > I still get a failure in aes_siv_encrypt(), which does not occur with
> > the kernel side fix applied.
>
> Where is this test from? I can't find it in the ell git tree.
>

It is part of iwd - just build that and run 'make check'

With your patch applied, the occurrence of sendmsg() in
operate_cipher() triggers the warn_once(), but if I add MSG_MORE
there, the test hangs.
