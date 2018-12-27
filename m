Return-Path: <SRS0=t27p=PE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6502C43387
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Dec 2018 13:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6128820869
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Dec 2018 13:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="N8rfypLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbeL0NkF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Dec 2018 08:40:05 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:56307 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbeL0NkF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Dec 2018 08:40:05 -0500
Received: by mail-it1-f195.google.com with SMTP id m62so24548198ith.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Dec 2018 05:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGEYqEYB/EBzFC/fiqobx8OB81HG30xImUzVxpff8ck=;
        b=N8rfypLjerffE/I62cFwxRd45uRI2QXxMO1v5sSv3QJNiR/uDowl2rH5Boaadma3Zk
         J/iTvrn9ej93x1I9eqcIpJS7dVHXxiFadQ0bi75NYI5Dqp9eXKsTEJgPP1jEaHAVrQak
         LiAfM4SU7mIFETxtOvSVrtAPDW8jNGR1FG5Zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGEYqEYB/EBzFC/fiqobx8OB81HG30xImUzVxpff8ck=;
        b=PAcq8MhL8LNRGhc8d3PkOPCQ5gp91dQoNsLJb+MQTj8wvKxvIQGALs0QJgVbT+aP4m
         X0xFhgihAmOCC8+HBEWxQDGEZgRh+hbmQ9EP2P+UNeygUO9gUDRO6beicVWZUsMqEBKY
         wnXiym7R0a2Y5PmoYFW2G0Ra5aLNVvGXmdHbO6IPTlqeW8ti6IAjr5cHTEkrU0ptn2xo
         IBaQttyiXXBo6BKk6LjL+W3TzwWStPq511v8kGIhVC1yfWjyZdCcnqkgOPybLaxyGfcY
         HoMEvgKE5VhkoixIj6n1W/bzTiIagXbyMUU9NpfXZ4p05thXQ9Z/ytsB/yL6PRu1R8VR
         abcA==
X-Gm-Message-State: AA+aEWZQQaBNNWFDjtW8lRcfhMGN+l/gW1dwVNeX1CZK3geXeeDsvKeA
        mfCaeyArvOjV9SV5pmEwu5UqQlfN0TCEYlCLMuMXhQ==
X-Google-Smtp-Source: AFSGD/UW0iTQABaqgubZWToK7Hjs/DJBXugTBRz+Y4vfoqjKCWkDC1IU7bOubdDPNQS8CObEcVgQpX/8ALayc6uWydk=
X-Received: by 2002:a05:660c:4b:: with SMTP id p11mr15697578itk.71.1545918003765;
 Thu, 27 Dec 2018 05:40:03 -0800 (PST)
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org> <1545908831-25910-2-git-send-email-sumit.garg@linaro.org>
In-Reply-To: <1545908831-25910-2-git-send-email-sumit.garg@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Dec 2018 14:39:52 +0100
Message-ID:
 <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] dt/bindings: add bindings for optional optee
 rng-uuid property
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181227133952.9g5h_nHqqi6huGkXFUSwyqPntLUZM9qk38u8DktzLJ4@z>

On Thu, 27 Dec 2018 at 12:08, Sumit Garg <sumit.garg@linaro.org> wrote:
>
> Add bindings for OP-TEE based optional hardware random number
> generator identifier property. It could be used on ARM based devices
> where entropy source is not accessible to normal world (linux in this
> case).
>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> index d38834c..e3a4c35 100644
> --- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> +++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> @@ -20,6 +20,9 @@ the reference implementation maintained by Linaro.
>                     "hvc" : HVC #0, with the register assignments specified
>                            in drivers/tee/optee/optee_smc.h
>
> +- rng-uuid       : Optional OP-TEE based RNG service identifier in case
> +                   hardware entropy source is not accesible to normal world
> +                   (Linux).
>
>
>  Example:
> @@ -27,5 +30,6 @@ Example:
>                 optee {
>                         compatible = "linaro,optee-tz";
>                         method = "smc";
> +                       rng-uuid = "ab7a617c-b8e7-4d8f-8301-d09b61036b64";

If OP-TEE is going to expose devices in this way, it should be modeled
more like a bus driver, i.e., sub-nodes that represent the devices,
with compatible strings, and perhaps even 'reg' properties for the
UUIDs.

>                 };
>         };
> --
> 2.7.4
>
