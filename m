Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71191C76195
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Mar 2023 11:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjCOLKD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Mar 2023 07:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjCOLJQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2023 07:09:16 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE99B89F0A
        for <linux-crypto@vger.kernel.org>; Wed, 15 Mar 2023 04:07:22 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id v17-20020a9d6051000000b0069a413e9cf6so664439otj.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Mar 2023 04:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1678878440;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KGQqOqOpjdPwjfp6rUoV/LSKKOdR5bXz0gLa5D6q8M8=;
        b=NfU7ky0pTFamou9nX5SukTXVqMgHMpQu1Jw6n3AOGGC9ReTsLdtSd+npjiEEiKVXHx
         bciOtd+pkbi2iCQ3iWqUqEP/hWpz/XjEAbpWRolzlrt+rl9AAkoZo+X+zTKhus7f29q3
         KZdTPof8WLcw7dnfhlLhKASbTkRUvHbWF02MxNSd0HFRUfbreGLXap6iH8Xnir3SubMo
         aK54nvkmHUkWlAAuMFXCAX2AzL5sZdq2DF8prOd5pM9LySPxK4wSy9FcSCwOqjOzYowi
         Rdqmvgv/HsV+BF9TnYz3nKBjYt4K/WuTcXbqQSaB3cXofTxl16A5JLveCIoG2OultmUW
         JxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878440;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KGQqOqOpjdPwjfp6rUoV/LSKKOdR5bXz0gLa5D6q8M8=;
        b=0YtBfBTnhZZ12mhiLASrYLUl88hVHyQ0wGMDnQrH//NR/xkU/Dd4BJc0GAmnCjomev
         fUVQZDrNt/bglXClso+0YbWsqfbVeKueValepsQuOwPrwqVGzV+BUpmFkormqfzODU3/
         7v8EHf90v5fdhn5BfbnxmkGZ4wfN6KSzikeY1JhDbJLrgObGW3F/4c/eZdUQ99H0jDCz
         18g5RNb8z+pmKVCPX3XBuhzLGINKz5iv/jj7VgOXr5YJFjJ+LF0u2ZKRRBTiv6GRt3b7
         p/9tKUBfil0eXaEInE9B59PYD0UCsQFRU2xwe0FGrQz0oI+rTKXpCYZ3pVMBOXX7DHoe
         SThg==
X-Gm-Message-State: AO0yUKX5hxo0WjLL712GwBUlR6Vp6BYs4OKZXE+iysusZZUl8HXqwPwb
        MDWcRRBhCkwlvWx9xGGCXodNkFz3wTgivhaWUNKOuhFP2nVDAa87wng=
X-Google-Smtp-Source: AK7set8BdBU6LkFTYjo2gFwe8AD34oucPZCJv8AcMgIr6Hd4YxH72eziFJ4BgYbENfIqkU5Lst49d6+S/14XW/3W/KA=
X-Received: by 2002:a9d:173:0:b0:698:6b65:f563 with SMTP id
 106-20020a9d0173000000b006986b65f563mr1418002otu.4.1678878440457; Wed, 15 Mar
 2023 04:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230310211954.2490-1-mario.limonciello@amd.com> <20230310211954.2490-8-mario.limonciello@amd.com>
In-Reply-To: <20230310211954.2490-8-mario.limonciello@amd.com>
From:   Grzegorz Bernacki <gjb@semihalf.com>
Date:   Wed, 15 Mar 2023 12:07:09 +0100
Message-ID: <CAA2Cew7p7iu=J_4pFjWCHFZuGva0tkdmmdy2QmBdK_fXVxm07g@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] crypto: ccp: Add support for ringing a platform doorbell
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        Rijo-john.Thomas@amd.com, Thomas.Lendacky@amd.com,
        herbert@gondor.apana.org.au, John Allen <john.allen@amd.com>,
        Felix.Held@amd.com, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mario,
[...]
> +int psp_ring_platform_doorbell(int msg)
> +{
> +       struct psp_device *psp = psp_get_master_device();
> +       struct psp_platform_access_device *pa_dev;
> +       u32 __iomem *button, *cmd;
> +       int ret, val;
> +
> +       if (!psp || !psp->platform_access_data)
> +               return -ENODEV;
> +
> +       pa_dev = psp->platform_access_data;
> +       button = psp->io_regs + pa_dev->vdata->doorbell_button_reg;
> +       cmd = psp->io_regs + pa_dev->vdata->doorbell_cmd_reg;
> +
> +       mutex_lock(&pa_dev->doorbell_mutex);
> +
> +       if (check_doorbell(button)) {
> +               dev_dbg(psp->dev, "doorbell is not ready\n");

Can you change dev_dbg()  to dev_err() when there is an error in all
cases in that function?
[...]

> +
> +       val = FIELD_GET(PSP_CMDRESP_STS, ioread32(cmd));
> +       if (val) {
> +               ret = -EIO;
> +               goto unlock;
> +       }

Are you sure that PSP_CMDRESP_STS should be zero? My tests failed due
to the fact the val is 1 and moreover I don't see that check in the
original Jan's patch.
Can you also add here dev_err()?

thanks,
grzegorz
