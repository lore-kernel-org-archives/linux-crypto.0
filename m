Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49FFC10F14
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 12:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79570218DE
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 12:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfJOMsJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 08:48:09 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44615 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfJOMsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 08:48:08 -0400
Received: by mail-qk1-f194.google.com with SMTP id u22so18969762qkk.11;
        Tue, 15 Oct 2019 05:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dMgTdeD/9gJwcRCsNb/xPelcbI93Bt7zIb0T0pXCtjE=;
        b=MDabImphqlmlbigRIjdrOlznIibYBgWcw0Fr5h1GKAv4sEElFgE0wQdnG/dZjYPvcb
         6+tVBA97Qcs5dKl/6lzzbk9/96ZLJSuqZvN7NZQwtinRg4/DS8j+KaHxT1E7Acbvkg+C
         oCV0az4ysGubiTQp3FCshWsT4AP0kXHAvE0d62AMUg42khbjk+OXT9KxAQBiI1MqsVEd
         EZe2xFHVbJ8KU6P0qlgsusJAA2xcVmAViEUeMlI0HUqJkHuVT9mhezVAj0D2prLeU0iY
         +wrMex0DtJ+p0sWR/vNgjzqxLa3qRstgDbpHUOvNu2zPnEs1mCJ36ZsIzqSA+vG9RI+O
         ELCA==
X-Gm-Message-State: APjAAAWOZqE91UjUZet2541dOKQ07wpdtHVv3xK9jrIVZlynGWccaJly
        RLEwT/H/H8jp3dxU9twU2GcK8OSTXIyrEwldbx0TofOG
X-Google-Smtp-Source: APXvYqwKGZMwLi+3WikxwPF2m42/TzGbp99hfFBOSdx2vfVYuxSkTzY4UADajrdqJWr/6LZQCGCtTGWQGIMNpMGub7A=
X-Received: by 2002:a37:9442:: with SMTP id w63mr34467927qkd.138.1571143687521;
 Tue, 15 Oct 2019 05:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191015123604.28749-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20191015123604.28749-1-ben.dooks@codethink.co.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 15 Oct 2019 14:47:51 +0200
Message-ID: <CAK8P3a0CuRSCycTz_2a6RM+0yGW_g6Jdgby7grGy-0135-BhUw@mail.gmail.com>
Subject: Re: [PATCH] hwrng: ka-sa - fix __iomem on registers
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 15, 2019 at 2:36 PM Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>
> Add __ioemm attribute to reg_rng to fix the following
> sparse warnings:
>
> drivers/char/hw_random/ks-sa-rng.c:102:9: warning: incorrect type in argument 2 (different address spaces)
> drivers/char/hw_random/ks-sa-rng.c:102:9:    expected void volatile [noderef] <asn:2> *addr
> drivers/char/hw_random/ks-sa-rng.c:102:9:    got unsigned int *
> drivers/char/hw_random/ks-sa-rng.c:104:9: warning: incorrect type in argument 2 (different address spaces)
> drivers/char/hw_random/ks-sa-rng.c:104:9:    expected void volatile [noderef] <asn:2> *addr
> drivers/char/hw_random/ks-sa-rng.c:104:9:    got unsigned int *

>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by:  Arnd Bergmann <arnd@arndb.de>
