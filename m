Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F6EC433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 22:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60937610C8
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 22:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbhJGWct (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Oct 2021 18:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbhJGWct (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Oct 2021 18:32:49 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12922C061570
        for <linux-crypto@vger.kernel.org>; Thu,  7 Oct 2021 15:30:55 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id s24so11104392oij.8
        for <linux-crypto@vger.kernel.org>; Thu, 07 Oct 2021 15:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+SJoi0Snz/oq9JLZNnX6mqSWELZniZgWhRIMWDewmho=;
        b=AVcnW+XSkKZ72eLY8MixRNioRH04dH52umImlb/oo36/V9316NGN1xJKaHVg9n4hqT
         tCmBCM28VaXulLZBMaWUD344x2BOrxzh3wr6twwyXRuYS9hGzS6zBNaFK4JnbIVc09/y
         P78JuNKFvPLVuTrZ5MzI6FNr+AaAIpuTyUDexmdqtMvlDlSSSgdCbpTZJk+2lqyN8q2x
         HqA3swjceXCCM5B73YLIR6PuX3BeWuV226we53zX45jRIrQUPYVHbXJWgE9NGSJjS0sj
         aPH0KZqUv7xS9uPwySqO9jo0qx3IuJhuVB6lxW9/m7uU2ap0F7rfZbpC+ZdQ/qO8VfGk
         4rSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+SJoi0Snz/oq9JLZNnX6mqSWELZniZgWhRIMWDewmho=;
        b=OdINPzSh4sHhccerlxN4p2WDc4F5LWDYrgCCDsioSVm/ZdF8mzc+AFyYUxBxUF3epp
         Fsw3EShxU0fePRR2UOGfbSLq8HKU0QpmSQy1KfjSnQClkpLOlZHUP3NEuSQRK9wlTnQn
         EdVBMJxcv31J+tW0FzCw24xswS9nyjJvFlNQVhZJI7KnhRRiQ86adMA6YejgwYl4xeHB
         EhImttyvclkL5V69g+W4QYdc8CMz7gXG2+n6LZx5GuxkwVL5AdUwJQyp6/iDjhxvaEqq
         AsrLPnCNQmmef0Yx3B9Ncaj99udS+zmLy0Ij+ayLg8LUZRI3uTTQnJu+Bn2ccj0c7JhP
         JNrA==
X-Gm-Message-State: AOAM5300tp6d38YynCZ72DlYvdz6aaHSaXbJkvQvEW30zWYpFVpgZZ4x
        N6XORf/1sVTmJqlXLQiyoRA6PqOrZv6wftGjqEOz9w==
X-Google-Smtp-Source: ABdhPJzD9AouEqEHxIcbYnUOPTHlfOXjH5VZQW/OzgCaxpM+6OOAokXt9bw+TAy+TP3wOS8pWmS8vaLoxF8Hu5vsLFg=
X-Received: by 2002:a05:6808:60f:: with SMTP id y15mr5294386oih.15.1633645854179;
 Thu, 07 Oct 2021 15:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20211005195213.2905030-1-pgonda@google.com>
In-Reply-To: <20211005195213.2905030-1-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 7 Oct 2021 15:30:43 -0700
Message-ID: <CAA03e5FpP2XbWB5T=aM7jE9FTHHwJ04Kqc0PAz07F2f2ux6RuA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp - Consolidate sev INIT logic
To:     Peter Gonda <pgonda@google.com>
Cc:     "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 5, 2021 at 12:52 PM Peter Gonda <pgonda@google.com> wrote:
>
> Adds new helper function sev_init_if_required() for use in sev_ioctl().
> The function calls __sev_platform_init_locked() if the command requires
> the PSP's internal state be at least SEV_STATE_INIT. This consolidates
> many checks scattered through out the ioctl delegation functions.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/ccp/sev-dev.c | 63 +++++++++++++++---------------------
>  1 file changed, 26 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e09925d86bf3..071d57fec4c4 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -386,24 +386,14 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>
>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>  {
> -       struct sev_device *sev = psp_master->sev_data;
> -       int rc;
> -
>         if (!writable)
>                 return -EPERM;

This check can be removed because it's is handled by
`sev_init_if_required()`. Same is true for all the other commands.

>
> -       if (sev->state == SEV_STATE_UNINIT) {
> -               rc = __sev_platform_init_locked(&argp->error);
> -               if (rc)
> -                       return rc;
> -       }
> -
>         return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>  }
>
>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  {
> -       struct sev_device *sev = psp_master->sev_data;
>         struct sev_user_data_pek_csr input;
>         struct sev_data_pek_csr data;
>         void __user *input_address;
> @@ -435,12 +425,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>         data.len = input.length;
>
>  cmd:
> -       if (sev->state == SEV_STATE_UNINIT) {
> -               ret = __sev_platform_init_locked(&argp->error);
> -               if (ret)
> -                       goto e_free_blob;
> -       }
> -
>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>
>          /* If we query the CSR length, FW responded with expected data. */
> @@ -586,7 +570,6 @@ static int sev_update_firmware(struct device *dev)
>
>  static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  {
> -       struct sev_device *sev = psp_master->sev_data;
>         struct sev_user_data_pek_cert_import input;
>         struct sev_data_pek_cert_import data;
>         void *pek_blob, *oca_blob;
> @@ -617,17 +600,10 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>         data.oca_cert_address = __psp_pa(oca_blob);
>         data.oca_cert_len = input.oca_cert_len;
>
> -       /* If platform is not in INIT state then transition it to INIT */
> -       if (sev->state != SEV_STATE_INIT) {
> -               ret = __sev_platform_init_locked(&argp->error);
> -               if (ret)
> -                       goto e_free_oca;
> -       }
> -
>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>
> -e_free_oca:
>         kfree(oca_blob);
> +
>  e_free_pek:
>         kfree(pek_blob);
>         return ret;
> @@ -730,7 +706,6 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
>
>  static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  {
> -       struct sev_device *sev = psp_master->sev_data;
>         struct sev_user_data_pdh_cert_export input;
>         void *pdh_blob = NULL, *cert_blob = NULL;
>         struct sev_data_pdh_cert_export data;
> @@ -738,16 +713,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>         void __user *input_pdh_cert_address;
>         int ret;
>
> -       /* If platform is not in INIT state then transition it to INIT. */
> -       if (sev->state != SEV_STATE_INIT) {
> -               if (!writable)
> -                       return -EPERM;
> -
> -               ret = __sev_platform_init_locked(&argp->error);
> -               if (ret)
> -                       return ret;
> -       }
> -
>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>                 return -EFAULT;
>
> @@ -819,6 +784,26 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>         return ret;
>  }
>
> +static int sev_init_if_required(int cmd_id, bool writable,
> +                               struct sev_issue_cmd *argp)
> +{
> +       struct sev_device *sev = psp_master->sev_data;
> +
> +       lockdep_assert_held(&sev_cmd_mutex);
> +
> +       if (!writable)
> +               return -EPERM;
> +
> +       if (cmd_id == SEV_FACTORY_RESET || cmd_id == SEV_PLATFORM_STATUS ||
> +           cmd_id == SEV_GET_ID || cmd_id == SEV_GET_ID2)
> +               return 0;

I really like this patch and would like to see it get reviewed and
merged. I've often thought of writing up a similar patch every time I
look at the PSP code, but never took the initiative to do it myself.
Overall, I wonder if it's trying too hard to reduce redundant code. In
particular, we could avoid this awkward check if we put this helper
inline, in the command helpers themselves. Perhaps we split this out
into two helpers or instead add a parameter to this helper to control
whether to check if `state` is `SEV_STATE_UNINIT`. What do you think?

> +
> +       if (sev->state == SEV_STATE_UNINIT)
> +               return __sev_platform_init_locked(&argp->error);
> +
> +       return 0;
> +}
> +
>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
>         void __user *argp = (void __user *)arg;
> @@ -840,8 +825,11 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>
>         mutex_lock(&sev_cmd_mutex);
>
> -       switch (input.cmd) {
> +       ret = sev_init_if_required(input.cmd, writable, &input);
> +       if (ret)
> +               goto copy_out;
>
> +       switch (input.cmd) {

nit: Not sure what changed on this line. Was there an unintended
whitespace change here?

>         case SEV_FACTORY_RESET:
>                 ret = sev_ioctl_do_reset(&input, writable);
>                 break;
> @@ -875,6 +863,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>                 goto out;
>         }
>
> +copy_out:
>         if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
>                 ret = -EFAULT;
>  out:
> --
> 2.33.0.800.g4c38ced690-goog
>
