Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE07AC004D4
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Jan 2023 12:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjASMHf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Jan 2023 07:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjASMHe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2023 07:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EA04EC2
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 04:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674130001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MA+Tu3X5uLRzP6doE5KbzSpkyhzhncA6EFOFEasfI5U=;
        b=DK7pcS2u+aFZoC+wTDfap5awHqTSHIbqNhhHrINIuS6BreHRqcLfsDauJ420HGDARTc8d4
        ecQvl1+FN9h1gOU+3zMfuSuSdFS0WlkcabbbgKmtDy97NfdbG5OzaVj1HG6Oqi+fb+F/m0
        uKxepmwbvBuOlc5CkHBpy8mdORFo8Dw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-149-zHlema--PHWG5vpZMCCVaw-1; Thu, 19 Jan 2023 07:06:40 -0500
X-MC-Unique: zHlema--PHWG5vpZMCCVaw-1
Received: by mail-qk1-f197.google.com with SMTP id q21-20020a05620a0d9500b0070572ccdbf9so1244072qkl.10
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 04:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MA+Tu3X5uLRzP6doE5KbzSpkyhzhncA6EFOFEasfI5U=;
        b=QuS3xRUMgVbP+oowC9ifkzoNX25wGS2BhInZpy3WMmVN/Yj1fSgJa7Ph3n1WjRNwLW
         HMPkKRYo2KKf5cIxD4JIkhiKaxkavRpEijFvVk8WVDOLVU4mAFUHdYOv1cjgY+FfxB1b
         vylmesLiZObWUYYIYM6BMulFTjDnlenue+wOnR9FLJ8JwERI4o73A4qgh1XslQXlliaM
         cEMVe0ecDvhPTjl5fHHwpxOnC10IVq03Pkz4awbAi+ofj/2UmMJZoQtNNsgh1P8LsHAh
         IpWD5DZE9gayK5nQH8QdZupNqOOO9K0PSVDoVY9hM6crO89JC3nacB1FC9RjPZP9FoSy
         A8Aw==
X-Gm-Message-State: AFqh2koYGOsVbWvcNcObd1dWAGb3mBmCzqEX0m3FtFF1AYIy1ZMMHEoF
        gWFpOwe3kDrttaoEeKpGau7JXveEpId8tABM6HRCWqk5Cb9jU91hdKJO0JJkp8RLM+FDDO5AAyL
        VWq9fChDP3IXCYulVK3AENG7tydiPXkXl8hYp/h+V
X-Received: by 2002:a05:620a:2fb:b0:6fe:c73e:2579 with SMTP id a27-20020a05620a02fb00b006fec73e2579mr337816qko.756.1674129999582;
        Thu, 19 Jan 2023 04:06:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuB1xj8g49yNQDrZJdDlcymlZZ5MyruwIBZLgJ7+yb54wy/t1FK2bjN0BKkeFhzZVgJHoeEtvL+bWpF1BxEgVY=
X-Received: by 2002:a05:620a:2fb:b0:6fe:c73e:2579 with SMTP id
 a27-20020a05620a02fb00b006fec73e2579mr337811qko.756.1674129999344; Thu, 19
 Jan 2023 04:06:39 -0800 (PST)
MIME-Version: 1.0
References: <20230119080508.24235-1-meadhbh.fitzpatrick@intel.com>
In-Reply-To: <20230119080508.24235-1-meadhbh.fitzpatrick@intel.com>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Thu, 19 Jan 2023 13:06:28 +0100
Message-ID: <CAMusb+RPz8PHe3ab6n=TYQG761Rn0uA7OHY7WVQ68onA0wXJMg@mail.gmail.com>
Subject: Re: [PATCH] Documentation: qat: change kernel version
To:     Meadhbh <meadhbh.fitzpatrick@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, wojciech.ziemba@intel.com,
        tomaszx.kowalik@intel.com, bagasdotme@gmail.com,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Jan 19, 2023 at 9:15 AM Meadhbh <meadhbh.fitzpatrick@intel.com> wrote:
>
> Change kernel version from 5.20 to 6.0, as 5.20 is not a release.
>
> Signed-off-by: Meadhbh Fitzpatrick <meadhbh.fitzpatrick@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-qat | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
> index 185f81a2aab3..087842b1969e 100644
> --- a/Documentation/ABI/testing/sysfs-driver-qat
> +++ b/Documentation/ABI/testing/sysfs-driver-qat
> @@ -1,6 +1,6 @@
>  What:          /sys/bus/pci/devices/<BDF>/qat/state
>  Date:          June 2022
> -KernelVersion: 5.20
> +KernelVersion: 6.0
>  Contact:       qat-linux@intel.com
>  Description:   (RW) Reports the current state of the QAT device. Write to
>                 the file to start or stop the device.
> @@ -18,7 +18,7 @@ Description:  (RW) Reports the current state of the QAT device. Write to
>
>  What:          /sys/bus/pci/devices/<BDF>/qat/cfg_services
>  Date:          June 2022
> -KernelVersion: 5.20
> +KernelVersion: 6.0
>  Contact:       qat-linux@intel.com
>  Description:   (RW) Reports the current configuration of the QAT device.
>                 Write to the file to change the configured services.
> --
> 2.37.3

Indeed,

Reviewed-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

