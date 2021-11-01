Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BEDC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 16:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A72D61101
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 16:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhKAQbg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhKAQbf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 12:31:35 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743C9C061764
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 09:29:02 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id n13-20020a9d710d000000b005558709b70fso19578456otj.10
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 09:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+pMFjfXFIIHye+Qf/lRPy2TQKIeRzNoHifmZkxgId4k=;
        b=caQHYMaeWihqeIuqRGd7eTEY5NvxaSCVSErtMnRNEWTtBapqhNShr1d89prWYR8k3N
         ZcFkezocxC74a92tOa3uEVchC6fu2lGLiieDSC3c+U1RD/juBAB/lUE9YOux25ff5BxD
         AMRUvKF0QAuSl1PUGKzSfApJcwOs08jTwY+CywLFKd2x+VrIAT0GUlsdq2A22S0LgwV+
         gyZY5I+NyZ17l7MzjknZqSUxuqj+BuE85xIlz8JzqUFPMvOewW8oQjTVcmylmaDNuPpK
         DOUagdPdVwm4yssedv9zQ/T42tJf748nSzFvRQlR4ThEbbOHbEmZBbrw3mvzXhAAN6HZ
         qhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+pMFjfXFIIHye+Qf/lRPy2TQKIeRzNoHifmZkxgId4k=;
        b=byLBxKHBlL+8e504+zrBjUuNikUPPxiZx5gZhJmkCPpWCRkpKFzFaVVqed+CFYEjDI
         4Gtk9IFAP5OjuThodUWl6V49GcR0Zs0hIDy66oPPvhtNOeAmCwjsOfYnmrFyVeR1oYCg
         fq+zKvYnunnK6dDAhZngy/S7sWoNEo1YwsgAYftZYm9uCdkAXKgLs4sGO3dcnnZuW6fv
         rYuGmocOaKjDIe/QwvbZLoYHdmkrSYW4wphjWTcU/CSj873P1uxGlknw/y4aaqNfwGOE
         JYeR+pxnyVAns2XTvY6YFW8U5rxLF+vwDTSOs4ZzTXSGNvcRnJeuCMbfSb4uz7ZpSnww
         NXag==
X-Gm-Message-State: AOAM531ZrEil/An3jC7JVjkxMgQ4sUKYH8XsH9hdHQwkz2uVbo5opZ2z
        cXj2W7DSScroAi66xGblDGnaIVhRwzT2RheaoqCypQ==
X-Google-Smtp-Source: ABdhPJzlWu8IzEe7e54Mv6V6L0N6NEFgHJaupm6rTlEzFIK6BrerkG5r4nQm//P+es7hWJxEQ5cmAGRGYCnlnluphno=
X-Received: by 2002:a9d:1c8c:: with SMTP id l12mr21782340ota.35.1635784141619;
 Mon, 01 Nov 2021 09:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com> <20211028175749.1219188-3-pgonda@google.com>
In-Reply-To: <20211028175749.1219188-3-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 1 Nov 2021 09:28:50 -0700
Message-ID: <CAA03e5EnS_dJZgTOLM_-52mArAU14EFTJ1SOjg6ZVk2fvJUHhw@mail.gmail.com>
Subject: Re: [PATCH 2/4] crypto: ccp - Move SEV_INIT retry for corrupted data
To:     Peter Gonda <pgonda@google.com>
Cc:     Thomas.Lendacky@amd.com, David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 28, 2021 at 10:58 AM Peter Gonda <pgonda@google.com> wrote:
>
> This change moves the data corrupted retry of SEV_INIT into the
> __sev_platform_init_locked() function. This is for upcoming INIT_EX
> support as well as helping direct callers of
> __sev_platform_init_locked() which currently do not support the
> retry.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paolo Bonzini <pbonzini@redhat.com> (
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ec89a82ba267..e4bc833949a0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -267,6 +267,18 @@ static int __sev_platform_init_locked(int *error)
>         }
>
>         rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +       if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
> +               /*
> +                * INIT command returned an integrity check failure
> +                * status code, meaning that firmware load and
> +                * validation of SEV related persistent data has
> +                * failed and persistent state has been erased.
> +                * Retrying INIT command here should succeed.
> +                */
> +               dev_dbg(sev->dev, "SEV: retrying INIT command");
> +               rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +       }
> +
>         if (rc)
>                 return rc;
>
> @@ -1091,18 +1103,6 @@ void sev_pci_init(void)
>
>         /* Initialize the platform */
>         rc = sev_platform_init(&error);
> -       if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> -               /*
> -                * INIT command returned an integrity check failure
> -                * status code, meaning that firmware load and
> -                * validation of SEV related persistent data has
> -                * failed and persistent state has been erased.
> -                * Retrying INIT command here should succeed.
> -                */
> -               dev_dbg(sev->dev, "SEV: retrying INIT command");
> -               rc = sev_platform_init(&error);
> -       }
> -
>         if (rc) {
>                 dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>                         error, rc);
> --
> 2.33.1.1089.g2158813163f-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>
