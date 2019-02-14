Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EEDC4360F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 16:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24D82222DA
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 16:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502774AbfBNQ52 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:57:28 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:39523 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502867AbfBNQ52 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 11:57:28 -0500
Received: by mail-it1-f193.google.com with SMTP id l15so3178596iti.4
        for <linux-crypto@vger.kernel.org>; Thu, 14 Feb 2019 08:57:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uR7QMXNd1yKBGiu/lg/ms8J+Ju4uZnkZopHIfNz3114=;
        b=bM7tioIc8k3sWE1qXExFt3Je63YwqtBsLFvh1lB9tsvy0fEq7YryEyuO+jG+QInx7Q
         hvCN62+LtRJM9ArD2oqE5Q9Tm4j+tbv0OugVxqZDows878UReCcwGhlUCVgbi4i5rFDo
         rbQTGL/y4xG2iVg7ZhpAgsUBPUA3jvxOWU22WTIAskIlh2qssDCJ/4tUmEL7kIa6d1Fa
         iIKH2o5uUmUHlhM1OHKOHDQM6AtPafBDyIS0BLr4OUO9sUgqGNPPTwPw68zHKRjt8L8Q
         KfE37IrClHriJLI3TpF1o5wTXYrfIuKSHtOksBOWZTBiAitID5O4v6fHoN4oVkoEvg0T
         Y7Uw==
X-Gm-Message-State: AHQUAuaYlvdiVK09HiZ2YUp9PjWZZq64owFpDJuTwh5VhfLG18Lb3av8
        jIr4NUH7/TMEA9CLq7R1iH35kELyXd8QDAihKAQndw==
X-Google-Smtp-Source: AHgI3IYAzXWVlT4S6h5PECwe8A6vhSZaRPcVsJZaOBI2nx/f0WLsX1M13Eq0KTkq8IBTH8WIPWvmBFDA+r+zoU7ABX4=
X-Received: by 2002:a24:29c8:: with SMTP id p191mr1273351itp.115.1550163446737;
 Thu, 14 Feb 2019 08:57:26 -0800 (PST)
MIME-Version: 1.0
References: <20190213192329.680-1-brijesh.singh@amd.com>
In-Reply-To: <20190213192329.680-1-brijesh.singh@amd.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Thu, 14 Feb 2019 10:57:15 -0600
Message-ID: <CAOASepMn-r+2fQjDxP3yM=JuM-YDXNiAZWOo2x0OdTQBj4pdYA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp: introduce SEV_GET_ID2 command
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I'm a little concerned that this immediately disables SEV_GET_ID.
IMHO, we should continue to support both for a period of time. One
justification for immediate disablement would be that if keeping it
around is likely to enabled incorrect or insecure userspace behavior
with a firmware change. Given that this value is passed directly to
the AMD server, I don't think either of these is the case and it can
probably be worked around on the server side.

On Wed, Feb 13, 2019 at 1:24 PM Singh, Brijesh <brijesh.singh@amd.com> wrote:
>
> The current definition and implementation of the SEV_GET_ID command
> does not provide the length of the unique ID returned by the firmware.
> As per the firmware specification, the firmware may return an ID
> length that is not restricted to 64 bytes as assumed by the SEV_GET_ID
> command.
>
> Introduce the SEV_GET_ID2 command to allow for querying and returing
> the length of the ID. Deprecate the SEV_GET_ID in the favor of
> SEV_GET_ID2.
>
> Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 65 +++++++++++++++++++++++++-----------
>  include/uapi/linux/psp-sev.h | 18 +++++++---
>  2 files changed, 60 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b16be8a11d92..b510900a9a83 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -584,40 +584,63 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
>
>  static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
>  {
> +       struct sev_user_data_get_id2 input;
>         struct sev_data_get_id *data;
> -       u64 data_size, user_size;
> -       void *id_blob, *mem;
> +       void *id_blob = NULL;
>         int ret;
>
> -       /* SEV GET_ID available from SEV API v0.16 and up */
> +       /* SEV GET_ID is available from SEV API v0.16 and up */
>         if (!SEV_VERSION_GREATER_OR_EQUAL(0, 16))
>                 return -ENOTSUPP;
>
> -       /* SEV FW expects the buffer it fills with the ID to be
> -        * 8-byte aligned. Memory allocated should be enough to
> -        * hold data structure + alignment padding + memory
> -        * where SEV FW writes the ID.
> -        */
> -       data_size = ALIGN(sizeof(struct sev_data_get_id), 8);
> -       user_size = sizeof(struct sev_user_data_get_id);
> +       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +               return -EFAULT;
>
> -       mem = kzalloc(data_size + user_size, GFP_KERNEL);
> -       if (!mem)
> +       /* Check if we have write access to the userspace buffer */
> +       if (input.address &&
> +           input.length &&
> +           !access_ok(input.address, input.length))
> +               return -EFAULT;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
>                 return -ENOMEM;
>
> -       data = mem;
> -       id_blob = mem + data_size;
> +       if (input.address && input.length) {
> +               id_blob = kmalloc(input.length, GFP_KERNEL);
> +               if (!id_blob) {
> +                       kfree(data);
> +                       return -ENOMEM;
> +               }
>
> -       data->address = __psp_pa(id_blob);
> -       data->len = user_size;
> +               data->address = __psp_pa(id_blob);
> +               data->len = input.length;
> +       }
>
>         ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
> -       if (!ret) {
> -               if (copy_to_user((void __user *)argp->data, id_blob, data->len))
> +
> +       /*
> +        * Firmware will return the length of the ID value (either the minimum
> +        * required length or the actual length written), return it to the user.
> +        */
> +       input.length = data->len;
> +
> +       if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
> +               ret = -EFAULT;
> +               goto e_free;
> +       }
> +
> +       if (id_blob) {
> +               if (copy_to_user((void __user *)input.address,
> +                                id_blob, data->len)) {
>                         ret = -EFAULT;
> +                       goto e_free;
> +               }
>         }
>
> -       kfree(mem);
> +e_free:
> +       kfree(id_blob);
> +       kfree(data);
>
>         return ret;
>  }
> @@ -760,6 +783,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>                 ret = sev_ioctl_do_pdh_export(&input);
>                 break;
>         case SEV_GET_ID:
> +               /* SEV_GET_ID is deprecated */
> +               ret = -ENOTSUPP;
> +               break;
> +       case SEV_GET_ID2:
>                 ret = sev_ioctl_do_get_id(&input);
>                 break;
>         default:
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index ac8c60bcc83b..43521d500c2b 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -6,8 +6,7 @@
>   *
>   * Author: Brijesh Singh <brijesh.singh@amd.com>
>   *
> - * SEV spec 0.14 is available at:
> - * http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
> + * SEV API specification is available at: https://developer.amd.com/sev/
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -30,7 +29,8 @@ enum {
>         SEV_PDH_GEN,
>         SEV_PDH_CERT_EXPORT,
>         SEV_PEK_CERT_IMPORT,
> -       SEV_GET_ID,
> +       SEV_GET_ID,     /* This command is deprecated, use SEV_GET_ID2 */
> +       SEV_GET_ID2,
>
>         SEV_MAX,
>  };
> @@ -125,7 +125,7 @@ struct sev_user_data_pdh_cert_export {
>  } __packed;
>
>  /**
> - * struct sev_user_data_get_id - GET_ID command parameters
> + * struct sev_user_data_get_id - GET_ID command parameters (deprecated)
>   *
>   * @socket1: Buffer to pass unique ID of first socket
>   * @socket2: Buffer to pass unique ID of second socket
> @@ -135,6 +135,16 @@ struct sev_user_data_get_id {
>         __u8 socket2[64];                       /* Out */
>  } __packed;
>
> +/**
> + * struct sev_user_data_get_id2 - GET_ID command parameters
> + * @address: Buffer to store unique ID
> + * @length: length of the unique ID
> + */
> +struct sev_user_data_get_id2 {
> +       __u64 address;                          /* In */
> +       __u32 length;                           /* In/Out */
> +} __packed;
> +
>  /**
>   * struct sev_issue_cmd - SEV ioctl parameters
>   *
> --
> 2.17.1
>
