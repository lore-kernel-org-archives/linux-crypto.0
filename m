Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02287C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Mar 2022 22:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiCKWwo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Mar 2022 17:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiCKWwc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Mar 2022 17:52:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EC9ED95A
        for <linux-crypto@vger.kernel.org>; Fri, 11 Mar 2022 14:26:16 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id m12so12529230edc.12
        for <linux-crypto@vger.kernel.org>; Fri, 11 Mar 2022 14:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oImblYsWVMGS5zQ1ePppQmmiYR91J0cAmcAcM48NpcI=;
        b=BaIqFmBKr8M3m70S+XXZ+EK/lp61e4SxKkFzvYgGOAMCqZ62uQhxJc0a0eJRAcsRDZ
         6XgQyQti/ldlLBGCz5rTVteS7sXgX8UEe7vq0E+ofzVKR85UMClwc+Kd6rwHVGWxzJkQ
         UPyR/daTal0IWwV/faCbCO/cI9R+ef3bLTOOwYmU57JORRTmFNIb97c/9ewKfmDrcrjS
         wBR9Ia5Op6N4lfye4lLq4ziPdfZWHDVoJHK+0zm2Tl3Jy6FqW+ifaxp52Zo7BMJuXlZM
         5TrqFdjBivg9HPYoH6WzzwonQl7aroWvbKBIY3v08ODzxt4RqqDDmNsXjdTQ4WYvrZUA
         TLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oImblYsWVMGS5zQ1ePppQmmiYR91J0cAmcAcM48NpcI=;
        b=ZweuwbxXt6a/bphiW3m0tWu+MlmgGhGS+7MHPLqQhQA3oxO4HTPbsTZ5gCoNw1FoT2
         s9jYfL50cgW6WHRdE78ZFke6mYzswByZZIoRpzlWdsz6rbZtnkR3ukZVOQ3zIFlqEC0Y
         FhUbOriMQX6syottZgAudz0J+in9J86bFX7Kx42sNnBQLHxRsK+GGP18Jf6jIiOBFP0O
         sR/IxL5+5DV8ppJtDcBzpnkG1FsGy4lSxgXUoqefcwyP90aBtKxGMWEqaHB4c+hfpz7d
         kQSlbM3+jKpUrsIZ35/dv2/VATlB6j92h4b72q553ti2AjH8aecOvbwdlllXvkNrUIy5
         JPkw==
X-Gm-Message-State: AOAM532uKYh/YIrSb5tYU0f29IgroWsbCCHV1Db83kW7ykIPdEK9jORP
        +i19ULc7ZuYYcSLBRwgle+UqtPkjboDPC2+1Zxug+HIDiA==
X-Google-Smtp-Source: ABdhPJyWZ5aNzu/C+Tv46rBVFwOppvij1Tsq5Wb6owJWam9upz7UNT/kuEZFR5xQPSh3XaZxX4DQpJCXtDxrawj2CPQ=
X-Received: by 2002:a17:907:1b09:b0:6d8:faa8:4a06 with SMTP id
 mp9-20020a1709071b0900b006d8faa84a06mr10170156ejc.701.1647036043563; Fri, 11
 Mar 2022 14:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20220311174741.250424-1-mic@digikod.net> <20220311174741.250424-2-mic@digikod.net>
In-Reply-To: <20220311174741.250424-2-mic@digikod.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 11 Mar 2022 17:00:32 -0500
Message-ID: <CAHC9VhThwFbO83D8u09XmRRvQxft7fHZ+KPciGfmrBJNZA1wGQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] certs: Remove panic() calls from blacklist_init()
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 11, 2022 at 12:47 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>
> Replace panic() calls from device_initcall(blacklist_init) with proper
> error handling using -ENODEV.
>
> Suggested-by: Jarkko Sakkinen <jarkko@kernel.org> [1]
> Link: https://lore.kernel.org/r/Yik0C2t7G272YZ73@iki.fi [1]
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Link: https://lore.kernel.org/r/20220311174741.250424-2-mic@digikod.net
> ---
>  certs/blacklist.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)

I'm not sure we can safely rely on a non-zero error code saving us in
the care of failure, can we?

The blacklist_init() function is registered as an initcall via
device_initcall() which I believe is either executed via
do_init_module() in the case of a dynamic module load, or via
do_initcalls() if built into the kernel.  In either case the result is
that the module/functionality doesn't load and the kernel continues on
executing.  While this could be acceptable for some non-critical
modules, if this particular module fails to load it defeats the
certificate/key based deny list for signed modules, yes?

I completely understand the strong desire to purge the kernel of
panic()s, BUG()s, and the like, but if a critical piece of security
functionality that users expect to be present fails to initialize,
panic()ing is likely the right thing to do.

> diff --git a/certs/blacklist.c b/certs/blacklist.c
> index 486ce0dd8e9c..ea7a77f156da 100644
> --- a/certs/blacklist.c
> +++ b/certs/blacklist.c
> @@ -313,12 +313,16 @@ static int __init blacklist_init(void)
>         const char *const *bl;
>         struct key_restriction *restriction;
>
> -       if (register_key_type(&key_type_blacklist) < 0)
> -               panic("Can't allocate system blacklist key type\n");
> +       if (register_key_type(&key_type_blacklist) < 0) {
> +               pr_err("Can't allocate system blacklist key type\n");
> +               return -ENODEV;
> +       }
>
>         restriction =3D kzalloc(sizeof(*restriction), GFP_KERNEL);
> -       if (!restriction)
> -               panic("Can't allocate blacklist keyring restriction\n");
> +       if (!restriction) {
> +               pr_err("Can't allocate blacklist keyring restriction\n");
> +               goto err_restriction;
> +       }
>         restriction->check =3D restrict_link_for_blacklist;
>
>         blacklist_keyring =3D
> @@ -333,13 +337,24 @@ static int __init blacklist_init(void)
>                               , KEY_ALLOC_NOT_IN_QUOTA |
>                               KEY_ALLOC_SET_KEEP,
>                               restriction, NULL);
> -       if (IS_ERR(blacklist_keyring))
> -               panic("Can't allocate system blacklist keyring\n");
> +       if (IS_ERR(blacklist_keyring)) {
> +               pr_err("Can't allocate system blacklist keyring\n");
> +               goto err_keyring;
> +       }
>
>         for (bl =3D blacklist_hashes; *bl; bl++)
>                 if (mark_raw_hash_blacklisted(*bl) < 0)
>                         pr_err("- blacklisting failed\n");
>         return 0;
> +
> +
> +err_keyring:
> +       kfree(restriction);
> +
> +err_restriction:
> +       unregister_key_type(&key_type_blacklist);
> +
> +       return -ENODEV;
>  }

--=20
paul-moore.com
