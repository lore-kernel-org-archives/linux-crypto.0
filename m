Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43A1C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 18:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352130AbiCUSZh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 14:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346032AbiCUSZf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 14:25:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3B620F47
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 11:24:06 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t1so18921686edc.3
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 11:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Znlv0HuHzVHaeUAmdIRV55nsLLlzSzHPvRIX7fedcUo=;
        b=dZCkQITWm7aAaXjcdC9aaJGWOSDwwhmiHMzz4T9vFTAIrBgplBxfZm25g+walJOkE/
         s/1+FK3Q8iyr12mvERqN/SQqQAx8+ypB1IxkVGIV+lbjLfch6NahK1lz9WUKIGbWGR+O
         E8IS8fJy3WHAEZa0+eSiOxCHHFxFvaGzoT6eqWf2r56tqqoqrFu3VkO5TgA3xK9qS83K
         w2IIw1WGHDs8sRYaMoc2DFd1XNRIWbdYPKvYXJv0nfEchin0hxv2AgKt5z2XBcK6yq7K
         HzJG2S05OOtbPXSquUIJ7TEcM50PtjqiTEyoJkHNlHnL/pml7b0fEo0Pch55ynrJWRjB
         DxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Znlv0HuHzVHaeUAmdIRV55nsLLlzSzHPvRIX7fedcUo=;
        b=JshcvQDofd068c9ktyS6CmrOSSVHy7QlfRdD8/P2XBlfvwZEapgo0I6SMNoHYxzx8w
         hKwlyG6RXcvLJVJt+pDp8LGroHu7B3ClaMDghI5P1EputyExoFYx2R4psvREDU5HScpq
         yU8ggmpoXienSf5fSg5PhGdd1DQ2VP8IFHM4t+G/57v3NVGCwL/RR6+kWmU5z1x0tkFF
         FdInVnB+29cBbBzDteQZq64nqpgbg0klHbEx/t70h/6VfVqqq6CjzVM9zUrXEpXYur83
         3jTEBub1bPvDbwCz8p3hrOgmwB54x2ifRU3P0+TnoFS6G5E+iufWHjqjZhJ0pyvvc8Zx
         +OfA==
X-Gm-Message-State: AOAM531k9Ti97RLiYwQ5vB3VIjID35OK0gxELP8KCyMVtnOgMoHvl/Cd
        uEBTX0Fb9k/j3YPXthOnwO7wk3kl7xbbtvUYOIEf
X-Google-Smtp-Source: ABdhPJxssqPmh+qHcCzxF3xsED5nNaiei08foUJkKVXI+HTgBGne1+hBjJb9fvtjCFtPaT8nVral3z+eTHU4RmFkNkk=
X-Received: by 2002:a05:6402:42d4:b0:412:c26b:789 with SMTP id
 i20-20020a05640242d400b00412c26b0789mr24724801edc.232.1647887045389; Mon, 21
 Mar 2022 11:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220321174548.510516-1-mic@digikod.net> <20220321174548.510516-2-mic@digikod.net>
In-Reply-To: <20220321174548.510516-2-mic@digikod.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 21 Mar 2022 14:23:54 -0400
Message-ID: <CAHC9VhR+Ss5VAUHLutTvyS8g+agZy7d0YGcu_9dV1LBx_8ifNQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] certs: Explain the rational to call panic()
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 21, 2022 at 1:45 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>
> The blacklist_init() function calls panic() for memory allocation
> errors.  This change documents the reason why we don't return -ENODEV.
>
> Suggested-by: Paul Moore <paul@paul-moore.com> [1]
> Requested-by: Jarkko Sakkinen <jarkko@kernel.org> [1]
> Link: https://lore.kernel.org/r/YjeW2r6Wv55Du0bJ@iki.fi [1]
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Link: https://lore.kernel.org/r/20220321174548.510516-2-mic@digikod.net
> ---
>  certs/blacklist.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

I would suggest changing the second sentence as shown below, but
otherwise it looks good to me.

Reviewed-by: Paul Moore <paul@paul-moore.com>

> diff --git a/certs/blacklist.c b/certs/blacklist.c
> index 486ce0dd8e9c..ac26bcf9b9a5 100644
> --- a/certs/blacklist.c
> +++ b/certs/blacklist.c
> @@ -307,6 +307,14 @@ static int restrict_link_for_blacklist(struct key *d=
est_keyring,
>
>  /*
>   * Initialise the blacklist
> + *
> + * The blacklist_init() function is registered as an initcall via
> + * device_initcall().  As a result the functionality doesn't load and th=
e

"As a result if the blacklist_init() function fails for any reason the
kernel continues to execute."

> + * kernel continues on executing.  While cleanly returning -ENODEV could=
 be
> + * acceptable for some non-critical kernel parts, if the blacklist keyri=
ng
> + * fails to load it defeats the certificate/key based deny list for sign=
ed
> + * modules.  If a critical piece of security functionality that users ex=
pect to
> + * be present fails to initialize, panic()ing is likely the right thing =
to do.
>   */
>  static int __init blacklist_init(void)
>  {

--
paul-moore.com
