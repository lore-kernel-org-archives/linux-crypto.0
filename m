Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2702C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 16:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F960610FD
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 16:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhKAQbJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhKAQbI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 12:31:08 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EE4C061714
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 09:28:35 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id z11-20020a4a870b000000b002b883011c77so6448038ooh.5
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 09:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pRSGvWwbmkorypXjIr/1Ir1j2xAMlHXbfH63oWX7RAw=;
        b=k5F2Nv73mWZ3sur0rBli/9IAPQeUS9EJy8tHteXZkvL1KVLm2sM2wOqCrNVrYK9phz
         M0gA9rCF6a1U43ed4iB/drSwTLwoqgsQF24hDnr3pJT1N+wXM2iA4a47KU6VqzXWJwEI
         QKJcKcCY3mcdq3aOMlg4ZOMBeXrWot3x9Z/2VI79h3x5yioT1mrUksMdInbZcKCGz005
         ZJdi0Zc5fIagKDjgPRuk+erZgYhAQ/SIySEtlVbFlyMQRf2uO1eGT9pnX8V6AgaOW7b7
         NRY5w0p+IlmGvel2SBXfKUMNyf5NNpRiV0yB50v1wsV0guYJmtsq/YccW+zLPFdXcf1S
         tYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pRSGvWwbmkorypXjIr/1Ir1j2xAMlHXbfH63oWX7RAw=;
        b=e5EWuM3TZoyAB1rebyUp+ieDUxgARIX/nljJ84Ky+rF7pfp7kv6/DW8kQVj7ee4njg
         CWiSMShE/3nAx8u+jJXCgXCQ201XPor1GwZv8oHgyEgKCGY1LbjUU6jUsYQIituHnE/w
         wVe2AQvl07NLHKQJhj8krGgdehogg1GDZNk5GtS/+MWASsF66Hie8ft4/+15dXsi7J8M
         /m0m7HmbhBrVMnFW1aoVCB5Jf5hhWjXlICWSU1Ea3EoccRRNPgIPoF2mgwgKJ8i99doU
         ZV6MgT8EETalVsmbgJd6EOQnc17F9E2dCkyIbLECgLg0f8v+h9MT1pXZkPS4WcRWX6jL
         prpA==
X-Gm-Message-State: AOAM531PUrO7HLxqbhR5dUvf/IznqpAQNA8hn4X3o4qfDZpfYkiBRwN4
        1RWRGUxQMTj3mR2w/4PTAhPrcQZazeGq5/EQwEIGdg==
X-Google-Smtp-Source: ABdhPJyAyhM3W7OP8NxtT/7y7xdrtQwC4Zu4D13/rUvHkHKfSM4grOLPVbYDBa1cMlOEo6xrjVYjQLdToMW3oAYFv68=
X-Received: by 2002:a4a:b501:: with SMTP id r1mr19682330ooo.20.1635784114171;
 Mon, 01 Nov 2021 09:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com> <20211028175749.1219188-2-pgonda@google.com>
In-Reply-To: <20211028175749.1219188-2-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 1 Nov 2021 09:28:23 -0700
Message-ID: <CAA03e5FgzHp-PHfi+v_R3hwxhbr2Z7O6hZuZQ8sDr-ryGVhxRQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: ccp - Fix SEV_INIT error logging on init
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

On Thu, Oct 28, 2021 at 10:57 AM Peter Gonda <pgonda@google.com> wrote:
>
> Currently only the firmware error code is printed. This is incomplete
> and also incorrect as error cases exists where the firmware is never
> called and therefore does not set an error code. This change zeros the
> firmware error code in case the call does not get that far and prints
> the return code for non firmware errors.
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
>  drivers/crypto/ccp/sev-dev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2ecb0e1f65d8..ec89a82ba267 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1065,7 +1065,7 @@ void sev_pci_init(void)
>  {
>         struct sev_device *sev = psp_master->sev_data;
>         struct page *tmr_page;
> -       int error, rc;
> +       int error = 0, rc;
>
>         if (!sev)
>                 return;
> @@ -1104,7 +1104,8 @@ void sev_pci_init(void)
>         }
>
>         if (rc) {
> -               dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
> +               dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> +                       error, rc);
>                 return;
>         }
>
> --
> 2.33.1.1089.g2158813163f-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>
