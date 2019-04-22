Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3126C282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 16:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B148C21734
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 16:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g83I4adh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfDVQ1x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 12:27:53 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41002 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfDVQ1x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 12:27:53 -0400
Received: by mail-ot1-f68.google.com with SMTP id 64so10095897otb.8;
        Mon, 22 Apr 2019 09:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=vTWNdmSRCHAvhrV8mGv2PU69tbQg4NXFWSn07Y6DfHc=;
        b=g83I4adhmSzUdIMZGLG3smgTs8AZJAbs+VQpwCizw7BCSEtdmM0JlkcYOkV51hbkE4
         Koims/fjiYb0sS9qqJAfJXOw/DB6S6ef+jqRYj130EREIZCNJRqCpAU2TTjNkzwA/DW9
         bSrjHrLrkoDMyd7VLwh5QdAzADr5fsXqkuhCgpcyvWKqK4XtwBuR9Q9RvhuxFPg9c5oN
         b7SbqvAChAd7648cU9OF+fmfCZdawG8mnabg4jk32xJEl6PqfmMvN8yI7Q5Lp4lBf0Ib
         396foPKE9P11wvleaaMK9n+aevUSFiBiMAx/72cI52gYw21FQtHokrsRVC29PpRxxVzH
         /Iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=vTWNdmSRCHAvhrV8mGv2PU69tbQg4NXFWSn07Y6DfHc=;
        b=ZUqCnkZ94PF5ysdh1Rh0brE3hH2XeG7UD2POlCvaVqyoSPkg+XcePbhOXsV6uwaN9Y
         7JWFP4kK0m/Kiw5VnU76wT1giWaJI15wHqFww1c5Jo2EuqzvpXvNS97l46Rk80KOxTNT
         VQ4V0sjS85VyAgoUcBT1TDxsl5eVb5MnoylavvFbiQTCOUX8X8YbAX/4Kou3sU5Aafmc
         gnc0Ktg6qfOiW0OAP5yWEmBQaheeC8W5TUnYn5dqvbzoe/YUMVF+M1YJJyZWNkKEpC+s
         dG4iTCn6u9J4sb+4Lskkt27ycZ3YeKITbsjyGWqVtof3S2NX7rz+cX9+w1y30xdgEbBk
         wQJQ==
X-Gm-Message-State: APjAAAWYg8/g+ehPVByYy9NGZGe4X8o8aYMcwyWjhfTPcHJP0rIPe8Z2
        6BMneyyjSEYjfb2J8gqYEhBv8MJXQtd4YgXrmXI=
X-Google-Smtp-Source: APXvYqx7dPXqmyKviFCr0pF3nPLMPgb9IhW/vZaZRY8kLpJX00HNaPhdU8qY62dKOkystn6qmbQ+iupyge0mPqBnM/c=
X-Received: by 2002:a9d:7f08:: with SMTP id j8mr12567471otq.284.1555950472688;
 Mon, 22 Apr 2019 09:27:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:d14a:0:0:0:0:0 with HTTP; Mon, 22 Apr 2019 09:27:52
 -0700 (PDT)
In-Reply-To: <20190422131848.3AD9A20693@mail.kernel.org>
References: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com>
 <20190422131848.3AD9A20693@mail.kernel.org>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Mon, 22 Apr 2019 18:27:52 +0200
Message-ID: <CAAd0S9CK0Krb6h6hL=mHuZr6AVBv3S0fWtzbVQxdKgTb2oWniA@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto4xx: fix ctr-aes missing output IV
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/22/19, Sasha Levin <sashal@kernel.org> wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.0.9, v4.19.36, v4.14.113,
> v4.9.170, v4.4.178, v3.18.138.
>
> v5.0.9: Build OK!
> v4.19.36: Build OK!
> v4.14.113: Failed to apply! Possible dependencies:
>     fc340115ffb8 ("crypto: crypto4xx - properly set IV after de- and
> encrypt")
>
> v4.9.170: Failed to apply! Possible dependencies:
>     fc340115ffb8 ("crypto: crypto4xx - properly set IV after de- and
> encrypt")
>
> v4.4.178: Failed to apply! Possible dependencies:
>     fc340115ffb8 ("crypto: crypto4xx - properly set IV after de- and
> encrypt")
>
> v3.18.138: Failed to apply! Possible dependencies:
>     fc340115ffb8 ("crypto: crypto4xx - properly set IV after de- and
> encrypt")
>
>
> How should we proceed with this patch?

I only added AES-CTR support around a year ago.
https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable/+/98e87e3d933b8e504ea41b8857c038d2cd06cddc
(so, this is another dependency)

In my opinion back-porting the patch to 4.14 and older would not do
much since the mode is not available there. But, I'm glad that the
patches got a bit of attention.

Cheers,
Christian
