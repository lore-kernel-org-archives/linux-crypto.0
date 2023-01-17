Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A177C3DA78
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Jan 2023 19:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjAQTPV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Jan 2023 14:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbjAQSyX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2023 13:54:23 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4F45A342
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2023 10:18:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso38095537pjt.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2023 10:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0fpJFz+uumjj7KE/lorb8wR6u11JYG6vZ+zsVfls5E=;
        b=VBrRf9pTr/4IPYNmGourNvutyd/ceeVLNpGDPjYtcjudgwi8bWs3X2fID1pp4T6P9x
         kCxV6g3thz6inwVNXqUomT28JPS2ASsErK+GnX32+XdchqM1ZA9rZp1L54MNryjAKc2D
         3Y8dbKLBCXTr72HwAJPkq9mYKDdLlO9Ww4JA9vgJ+ariun+1gAwsRGjIgOetyIN/lKC8
         pBlvSQCFm1kfkCg1oJ0Gp9WU//JwlAYAoqDqvoUs0678SECg+yGXEuLIzQdsvAU9uMH/
         hlHBXvoF3ljJyon0Q4DggoJ1vVF1vkwaLkoZSDQW6aEmLBQARFMreCm7uLanSV6HKBfZ
         0xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q0fpJFz+uumjj7KE/lorb8wR6u11JYG6vZ+zsVfls5E=;
        b=yGizgE/UqrPTJnwAM0B7Pgg9a+U9yBk6SE+X/1Po2fk/SaapYqAwKHBLHcUVo8dphI
         K4i7sFWJx9/1IojaQUxFigL0g/w7LWqkg8sNmSRr3XgM2flZbYBryj8alE/nxdhpF6yc
         S8hV25i8CnYmXzDUG70rn2MlVaDUOaf429izW7byrI0WAgQZFakW+JI8VrDM4KGU3rYg
         94OWb/f1GDiXLSoBOLLv411wuSiRBy1XuJfDVu3t7sTyu8/Eny5admLXEno3ATlfQcsf
         tuIQDDTmCp1ZJcG4ti0n6JOzh13x4hZC2rDt03octF4zK2eKDJujgF9fvlWPnY0b8hOr
         6QGQ==
X-Gm-Message-State: AFqh2kqpHfC0loi6tk3KbTQ2TvRzj0w+JJoBC4LZ8m6VoNNl0pvJ1Y1B
        gEuzyP+fgeLl7goxv0w3LiPtRxWnnmzpLYGdU4o9qQ==
X-Google-Smtp-Source: AMrXdXsLciTK/2HzPHQv+ZKXUDNClH0QiJEUmRoQczErUi+3abrIY/ID2bNm4k6HDiWy8rkplZ05CxtNFA2LLMBhZzU=
X-Received: by 2002:a17:90a:c784:b0:227:202b:8eaa with SMTP id
 gn4-20020a17090ac78400b00227202b8eaamr359677pjb.147.1673979476682; Tue, 17
 Jan 2023 10:17:56 -0800 (PST)
MIME-Version: 1.0
References: <20230110170848.3022682-1-trix@redhat.com>
In-Reply-To: <20230110170848.3022682-1-trix@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 17 Jan 2023 10:17:45 -0800
Message-ID: <CAKwvOdnde5qmYCsU1V4ccRn4tkEmPZLwJ2UFFLQfR-to7wLQTw@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: ccp: initialize 'error' variable to zero
To:     Tom Rix <trix@redhat.com>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        nathan@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 10, 2023 at 9:09 AM Tom Rix <trix@redhat.com> wrote:
>
> Clang static analysis reports this problem
> drivers/crypto/ccp/sev-dev.c:1347:3: warning: 3rd function call
>   argument is an uninitialized value [core.CallAndMessage]
>     dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> __sev_platform_init_locked() can return without setting the
> error parameter, causing the dev_err() to report a garbage
> value.
>
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Signed-off-by: Tom Rix <trix@redhat.com>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
> v2 cleanup commit log
> v3 cleanup commit log
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 56998bc579d6..643cccc06a0b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1307,7 +1307,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>  void sev_pci_init(void)
>  {
>         struct sev_device *sev = psp_master->sev_data;
> -       int error, rc;
> +       int error = 0, rc;
>
>         if (!sev)
>                 return;
> --
> 2.27.0
>
>


-- 
Thanks,
~Nick Desaulniers
