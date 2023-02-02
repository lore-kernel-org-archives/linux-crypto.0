Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7B7C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 16:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjBBQ4C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 11:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjBBQ4C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 11:56:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335EC65EF4
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 08:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675356920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JV11BQfFbz8y/OihZFs3ax0HCNcH7wh9QP2DsX+dYHU=;
        b=PQNTcMS1v1U+5dr+h9aISuQR2b+zZK2CfALUXDC9u3Nu+TezqFlRZuCYMuxp439VkWEG+M
        e5mQXkxubTg+ifg0d17SxWeFrr7tQtb+729SMX6L8Z7OSqloEeDr6V6ci12rrDYTB0CJAU
        EWHAA0ChuOGqREa19CDPOCCqhBIYldo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121-LZ_M8JmsOr2aARNyVtBe4A-1; Thu, 02 Feb 2023 11:55:19 -0500
X-MC-Unique: LZ_M8JmsOr2aARNyVtBe4A-1
Received: by mail-qv1-f71.google.com with SMTP id ly4-20020a0562145c0400b0054d2629a759so1243925qvb.16
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 08:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JV11BQfFbz8y/OihZFs3ax0HCNcH7wh9QP2DsX+dYHU=;
        b=ItgOwXAkovb9aYfR2UtF0UyvBqJtEBU5yoajHcllVNGVXKi0TeruBrju2yFKUVs/QF
         ERZk4Pit0OLEtWbxApNExALZb5z6osq+8dK5fSxiClyJiBaKHl7i+v6DVnRMEUWE/Bsn
         sMJ0D8lvPM2g2QhWWMAIjhsEm+valHRnvVyWFZ0kQYiQpnpSnZHJOwxVJ/PwOJGPwIeT
         7Aiism4P0ycyYNFbX3tlKvxMgrMVRHsNs4c9CCzVrwQzqTe231cguseO2syfyU/xkJuP
         MGmIDdsfLHnx/Du8GhVwG8X2CxnjT1f5CPfoPSA3/3A1rY7ObDbhTH+MDnIjHzNcHEoO
         9jqw==
X-Gm-Message-State: AO0yUKXnLmXickYfxz8/3+yRFv2VFbQE0ZGFKQNUVac9Op4cdKCq43aX
        HmANJLWclRWs/b8YWpDi21YQ7TL+yuk3TFN1zOuYiDzliHEiUVyPrnvajYDzZBr7ABRe7+0O2af
        sEPI3s9/rjIqSZ9XVO0U2XDI+yuhxU+VGsQJ9Hial
X-Received: by 2002:a05:620a:46a8:b0:705:bc80:7220 with SMTP id bq40-20020a05620a46a800b00705bc807220mr550062qkb.248.1675356918530;
        Thu, 02 Feb 2023 08:55:18 -0800 (PST)
X-Google-Smtp-Source: AK7set9FA8KkGmVOEKtiVVb+Ihk7Yb2ApB0ALIbLiZagHeK/tfzbxY5gPB5blJeXiL0+tagTwSgS8tiJScmKmKNa7tA=
X-Received: by 2002:a05:620a:46a8:b0:705:bc80:7220 with SMTP id
 bq40-20020a05620a46a800b00705bc807220mr550058qkb.248.1675356918227; Thu, 02
 Feb 2023 08:55:18 -0800 (PST)
MIME-Version: 1.0
References: <20230201170441.29756-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20230201170441.29756-1-giovanni.cabiddu@intel.com>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Thu, 2 Feb 2023 17:55:07 +0100
Message-ID: <CAMusb+S_Fxyt-KMjK+-SFenuypdmziK6qJcriHaXP4iux=W5gQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - drop log level of msg in get_instance_node()
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, Fiona Trahe <fiona.trahe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Giovanni, all,

On Wed, Feb 1, 2023 at 6:05 PM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> The functions qat_crypto_get_instance_node() and
> qat_compression_get_instance_node() allow to get a QAT instance (ring
> pair) on a device close to the node specified as input parameter.
> When this is not possible, and a QAT device is available in the system,
> these function return an instance on a remote node and they print a
> message reporting that it is not possible to find a device on the specified
> node. This is interpreted by people as an error rather than an info.
>
> The print "Could not find a device on node" indicates that a kernel
> application is running on a core in a socket that does not have a QAT
> device directly attached to it and performance might suffer.
>
> Due to the nature of the message, this can be considered as a debug
> message, therefore drop the severity to debug and report it only once
> to avoid flooding.
>
> Suggested-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_compression.c | 2 +-
>  drivers/crypto/qat/qat_common/qat_crypto.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/qat/qat_common/qat_compression.c b/drivers/crypto/qat/qat_common/qat_compression.c
> index 9fd10f4242f8..3f1f35283266 100644
> --- a/drivers/crypto/qat/qat_common/qat_compression.c
> +++ b/drivers/crypto/qat/qat_common/qat_compression.c
> @@ -72,7 +72,7 @@ struct qat_compression_instance *qat_compression_get_instance_node(int node)
>         }
>
>         if (!accel_dev) {
> -               pr_info("QAT: Could not find a device on node %d\n", node);
> +               pr_debug_ratelimited("QAT: Could not find a device on node %d\n", node);
>                 /* Get any started device */
>                 list_for_each(itr, adf_devmgr_get_head()) {
>                         struct adf_accel_dev *tmp_dev;
> diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
> index e31199eade5b..40c8e74d1cf9 100644
> --- a/drivers/crypto/qat/qat_common/qat_crypto.c
> +++ b/drivers/crypto/qat/qat_common/qat_crypto.c
> @@ -70,7 +70,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
>         }
>
>         if (!accel_dev) {
> -               pr_info("QAT: Could not find a device on node %d\n", node);
> +               pr_debug_ratelimited("QAT: Could not find a device on node %d\n", node);
>                 /* Get any started device */
>                 list_for_each_entry(tmp_dev, adf_devmgr_get_head(), list) {
>                         if (adf_dev_started(tmp_dev) &&
> --
> 2.39.1
>

Thanks, the fix seems to be working. It was tested on "Intel(R) Xeon(R)
Platinum 8468H / Sapphire Rapids 4 skt (SPR) XCC-SP, Qual E-3
stepping" machine with 8086:4940 (rev 40) QAT device:

Without the fix:

# dmesg | grep "QAT: Could not find a device" | wc -l
498

With the fix:

# dmesg | grep "QAT: Could not find a device"
<not output>

So,

Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Tested-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

