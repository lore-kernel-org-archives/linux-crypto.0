Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2862CCCA479
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jun 2022 00:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383713AbiFRAio (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jun 2022 20:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383754AbiFRAih (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jun 2022 20:38:37 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A95766CB4;
        Fri, 17 Jun 2022 17:38:36 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id b7so832953uap.5;
        Fri, 17 Jun 2022 17:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lZ79sX+NJPfDAxCDBVsMrqEoMTGb5GcEdj4eYBesXgk=;
        b=p1upQiOUMA8PL2CVEC6xwDEj/NXS9hZCuYq2h9VFhcZbwa7Iji2IfJbpJKs6+pz4HT
         iQKpTBiaIkZZbMAaB5YyaMHa3SkkDkxnurDzhu5hz1RkGgCPMbwx+a9bNB3wENYI1vXM
         JgBymJBBv00MrQk445/3gsty58kJcWyvSELlOLLFYRsbsKvP33cFOjpwmY7LP6cf0Miq
         W3dr5Gdpj2dPT94ZwHLypJ8Koh4HidHmdyHjQq0nO29gMeKFw+zsmeJq7bYJksF/+ZuM
         DlY4TSoamJkBEUKxYGGEvKnNcpgIX5f1/QPSc9ooVuyushZt39kntnahUFVrMMHQJQvJ
         BZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lZ79sX+NJPfDAxCDBVsMrqEoMTGb5GcEdj4eYBesXgk=;
        b=kRcOt6dQvZZKUUHKM3h/E01amgGCXyOpBUkhwNMLDyUBxYpf4z8eDrF8dYm3fbz9Oy
         7UNWliHJgkliiDJPFfHbKrE43PUsuLeK/Vry1Zj6IDI8LDpoFRdoZNjxvZB4DJgnJolo
         fQHSiVZiMmxaBKgU45b0fpRAvASCJSCCh/vN/uojpZWgqaRVk247TUsddMRtmnfEX096
         kG1S6GbiMinpgx+Vevan/7ucTaxUUItcdaFJB3lqVZOW1o/pVc/JMiuH9o4GPbGAPXnD
         wHFLQcRP/30PJJkzde+WakHbVHDc0Ky7PKVPDk2Jj7puY9eVWtOWtw/SeC4Tb+aCm59o
         Pxuw==
X-Gm-Message-State: AJIora9AX5ZDPH/4qNvikrGpNGAkqmcfNvHzE4vcPFnsfQpl28jWJedi
        sCpLXv5j/IX29TLk/cMdOrYv/RJXNAZE97qp8aDf+YYFdiU=
X-Google-Smtp-Source: AGRyM1vnNl+hFRmEmbioJB8SqizkgKILAZoKeV4oL7t6SWB2/iK4GIUoO+SGdJu0TGdOlKDEmsVbLCe/CF47y7MXERw=
X-Received: by 2002:ab0:7844:0:b0:37e:fc7f:ecd0 with SMTP id
 y4-20020ab07844000000b0037efc7fecd0mr2355220uaq.45.1655512715469; Fri, 17 Jun
 2022 17:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFmmw8bzSr-pmTauMS7a=036eW0=1KLdwAD1MOB_fY-7VRg@mail.gmail.com>
 <Yqr+rFeixFuHzyHD@zx2c4.com> <CACXcFmmdrELd8CkwmBQf5-W7PkR=McjcUz9kPDzaCh=NrODKUA@mail.gmail.com>
 <Yq0QOmahm8m018NK@zx2c4.com>
In-Reply-To: <Yq0QOmahm8m018NK@zx2c4.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sat, 18 Jun 2022 08:38:23 +0800
Message-ID: <CACXcFmma8euek8Z9T6m4jiyD1poyo3WHrLZKuN22sE20hFXNpA@mail.gmail.com>
Subject: Re: [PATCH] random Remove setting of chacha state to constant values.
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> > There is no such argument for
> > memset(&chacha_state[12], 0, sizeof(u32) * 4);
> > ChaCha has a counter and a nonce in those
> > bits, so setting them to zero is a deviation.
>
> No. There's a new key each time. So the nonce begins at zero. And the
> counter begins at zero as well at the beginning like usual. So it's
> actually a rather boring by-the-books usage of chacha.

No. ChaCha has a random nonce.

> But the larger reason for rejecting your idea wholesale is that I'm
> trying to enforce the property that input data goes through our hash
> function (via mix_pool_bytes). Full stop! It's time that this
> willy-nilly stuff ends where we're feeding in things right and left with
> no actual design on which is ingesting what input and how it interacts.

For input data, I agree completely.

> So if you do think that a particular block of memory somewhere at some
> point has some entropic value, then by all means call mix_pool_bytes or
> add_device_randomness on it. But don't try to stuff it in where it
> doesn't belong.

This is not input data but more-or-less random state. I'm not trying
to input it, just to leave it where it belongs rather than overwriting
it with constants.
