Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61753C636D4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 21:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjBJVaT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJVaR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 16:30:17 -0500
X-Greylist: delayed 670 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Feb 2023 13:30:11 PST
Received: from smtp.dei.uc.pt (smtp.dei.uc.pt [193.137.203.253])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAE67D3EE
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 13:30:11 -0800 (PST)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
        (user=sneves mech=PLAIN bits=0)
        by smtp.dei.uc.pt (8.15.2/8.14.4) with ESMTPSA id 31ALIdSX027635
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 21:18:45 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.dei.uc.pt 31ALIdSX027635
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dei.uc.pt;
        s=default; t=1676063925;
        bh=ya4qlSuIvMigLEB1O4Pz0n1WW0cLDEnOeYrLghcHOE4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oN8eso62Duz1xxOrEUca8nP9aX80nyOcYDxtBy49+yPPL99IZ+yrGR4v+fW3MbZ/2
         BkAqTo6TUnKdNWJV+FTVg+UfkwfShvQ0bv6ksjEjdQ5adjy3f4bbPlAoG1GQJ1Csqo
         1dFGtqWJ2raeQBuZy82UlCeWJib6NMQXP9eg1W6U=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-501c3a414acso84910197b3.7
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 13:18:45 -0800 (PST)
X-Gm-Message-State: AO0yUKUcbGQedLTR5i2kRENxgjEzJBi8iMNhnmJJlxsWiF6DIMmu8N3o
        gm3+TiSYzm0h+KsBDBvlv25rryY6ANFJMGGcx9Y=
X-Google-Smtp-Source: AK7set8shvWf1qWO1Um1BrkNIkEEabHWlh9wAm4VrPTWihlxCOKSe2fVaQLNe5uA3TqA+muu6pV/OOzP82gyHHBUbiQ=
X-Received: by 2002:a0d:c7c5:0:b0:46a:cb68:9add with SMTP id
 j188-20020a0dc7c5000000b0046acb689addmr2185762ywd.102.1676063918799; Fri, 10
 Feb 2023 13:18:38 -0800 (PST)
MIME-Version: 1.0
References: <20230210181541.2895144-1-ap420073@gmail.com>
In-Reply-To: <20230210181541.2895144-1-ap420073@gmail.com>
From:   Samuel Neves <sneves@dei.uc.pt>
Date:   Fri, 10 Feb 2023 21:18:02 +0000
X-Gmail-Original-Message-ID: <CAEX_ruFsUzDheaa0GMSeoauFMnymU9kcN1r0MZR3Mai1vrRS9g@mail.gmail.com>
Message-ID: <CAEX_ruFsUzDheaa0GMSeoauFMnymU9kcN1r0MZR3Mai1vrRS9g@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-FCTUC-DEI-SIC-MailScanner-Information: Please contact helpdesk@dei.uc.pt for more information
X-FCTUC-DEI-SIC-MailScanner-ID: 31ALIdSX027635
X-FCTUC-DEI-SIC-MailScanner: Found to be clean
X-FCTUC-DEI-SIC-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-59.69, required 3.252, autolearn=not spam, ALL_TRUSTED -10.00,
        BAYES_00 -0.10, DKIM_SIGNED 0.10, KAM_DMARC_STATUS 0.01,
        L_SMTP_AUTH -50.00, T_DKIM_INVALID 0.30)
X-FCTUC-DEI-SIC-MailScanner-From: sneves@dei.uc.pt
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 10, 2023 at 6:18 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> Also, vpbroadcastd is simply replaced by vmovdqa in it.
>
>  #ifdef CONFIG_AS_GFNI
>  #define aria_sbox_8way_gfni(x0, x1, x2, x3,            \
>                             x4, x5, x6, x7,             \
>                             t0, t1, t2, t3,             \
>                             t4, t5, t6, t7)             \
> -       vpbroadcastq .Ltf_s2_bitmatrix, t0;             \
> -       vpbroadcastq .Ltf_inv_bitmatrix, t1;            \
> -       vpbroadcastq .Ltf_id_bitmatrix, t2;             \
> -       vpbroadcastq .Ltf_aff_bitmatrix, t3;            \
> -       vpbroadcastq .Ltf_x2_bitmatrix, t4;             \
> +       vmovdqa .Ltf_s2_bitmatrix, t0;                  \
> +       vmovdqa .Ltf_inv_bitmatrix, t1;                 \
> +       vmovdqa .Ltf_id_bitmatrix, t2;                  \
> +       vmovdqa .Ltf_aff_bitmatrix, t3;                 \
> +       vmovdqa .Ltf_x2_bitmatrix, t4;                  \

You can use vmovddup to replicate the behavior of vpbroadcastq for xmm
registers. It's as fast as a movdqa and does not require increasing
the data fields to be 16 bytes.
