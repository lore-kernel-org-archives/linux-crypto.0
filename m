Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFD1C4742C
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 14:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3281A22226
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 14:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZHXrxNr+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKMOcX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 09:32:23 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:47959 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgKMOcW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 09:32:22 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 483cfae7
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Nov 2020 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=gB118LkbRDmahHGYvi9I7zzJykE=; b=ZHXrxN
        r+zy0w0I4V+s0762iZ85koays/+fIfJiAzhRicFphD8uPSRvLeo0Xu99bt8Cu8LP
        TWy/QiLochIgzd/uA95FI4VfEE5EGcHWqbe/Ew1nIA+rtI/XPogTwnJx6ovlnQlz
        K8BbC3HrX6tByq98qNOZPjilqNctc4JJ4HGzMv3IeSQZXV/iTw3gDHd6kOdxBz/E
        SskbzT5UGp2AirDGzE+74fX1hwoRHlJkEul95yu6ZTiVJqZHlzWvkLglPhjGDVwg
        LZmg3K8Tyt9SmSOdNwIZj1mS+Y1pg1FVH3VXFGD8fhDYUU3/ceSLjskFx+7sMHUI
        mrOO/7CAfpwgblDA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a594862e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Nov 2020 14:29:01 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id o71so8566887ybc.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2020 06:32:20 -0800 (PST)
X-Gm-Message-State: AOAM531JXhrKP+zKeep+dDREOC0/UyZMTNYN1duoi3o5lUiENWZTf4Ls
        LLhiWNnxGsyBD1HUVF/VnRYX4wpUZuz/qKKkyf0=
X-Google-Smtp-Source: ABdhPJyThvna/nHr+0eu5Z2Ppm2Gl8CSIF78xF77vqhy0EMaiuYMvXlSU+4zdgDGoTsHGW2zb5IklYYPq/vWVIT+QEs=
X-Received: by 2002:a25:9a02:: with SMTP id x2mr2736626ybn.306.1605277939888;
 Fri, 13 Nov 2020 06:32:19 -0800 (PST)
MIME-Version: 1.0
References: <20201113052021.968901-1-ebiggers@kernel.org>
In-Reply-To: <20201113052021.968901-1-ebiggers@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 13 Nov 2020 15:32:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9rErEGUngKDpq2GwG+C4A85pSbx=oUD2xKfn4f14WJPZw@mail.gmail.com>
Message-ID: <CAHmME9rErEGUngKDpq2GwG+C4A85pSbx=oUD2xKfn4f14WJPZw@mail.gmail.com>
Subject: Re: [PATCH] crypto: sha - split sha.h into sha1.h and sha2.h
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for doing this.

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
