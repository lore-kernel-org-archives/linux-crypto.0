Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80800C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 11:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5739F20665
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 11:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565868785;
	bh=htLQyccyyZq45OLs8p2cO5sUWxPFaNLzaE6EwhwfkXk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=y+0rF9zBqF8mxng2MtMUdqMmp6SHZxvse56nLMAihu4mvkdZ2+upyP2JPrUdhDZlK
	 NbGTgXBoddU69yqldRnlH04TjiNgw3zkPKven7xWM0F1LHjDTgvd6qI90ZB+SDJfnC
	 9WAYor9kl+z88o3NapY1m2Mlr0Z1xD1asMGO+oNo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbfHOLdD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 07:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731463AbfHOLdD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 07:33:03 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB68220665
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 11:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565868782;
        bh=htLQyccyyZq45OLs8p2cO5sUWxPFaNLzaE6EwhwfkXk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sxMHIGQDLg1eAexYUqgtA+vdCrWhQPHQm166/9cUBo8uuvknhliXIr4BFrtASmX0V
         0/n1ONXtSBB6B80h+qIpkedjM/flSFWEji68QMtH6AqqAos3aGiTYzlKWetNrYfJr/
         e+a5qJmdaqvOfkj9hEBCRpvqDhLINyepvpsa5yXE=
Received: by mail-qt1-f178.google.com with SMTP id u34so1975626qte.2
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 04:33:02 -0700 (PDT)
X-Gm-Message-State: APjAAAUs/1WBynVh8t6cGwscOE7FZvpsZgLVoy8iU/FK1FODSR5p9INR
        KLQmcD+wiDNDzu2ODV+RVwqQyRPt7x2K0QHzsMo=
X-Google-Smtp-Source: APXvYqwQufZiIh+xxs/a/m0h0OrI9uLFsgVcdwYRXQR3GBN1s0x70v3AGodzXqKkeNxSZLJt5c3xKzpy4UWJJGDl5oQ=
X-Received: by 2002:ad4:438c:: with SMTP id s12mr2906142qvr.17.1565868781944;
 Thu, 15 Aug 2019 04:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAK9qPMA=-MnkdpkUE_CU5FRmZ6LSk2FzfBJNsB0XRiaYxy9UWA@mail.gmail.com>
In-Reply-To: <CAK9qPMA=-MnkdpkUE_CU5FRmZ6LSk2FzfBJNsB0XRiaYxy9UWA@mail.gmail.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Thu, 15 Aug 2019 07:32:50 -0400
X-Gmail-Original-Message-ID: <CA+5PVA5BC7AtcJ4Ud33Ft9h_=kRcqeLoHtjRfvu_XBSvgej74g@mail.gmail.com>
Message-ID: <CA+5PVA5BC7AtcJ4Ud33Ft9h_=kRcqeLoHtjRfvu_XBSvgej74g@mail.gmail.com>
Subject: Re: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the
 EIP197 driver
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 6, 2019 at 8:54 AM Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
>
> The following changes since commit dff98c6c57383fe343407bcb7b6e775e0b87274f:
>
>   Merge branch 'master' of git://github.com/skeggsb/linux-firmware
> (2019-07-26 07:32:37 -0400)
>
> are available in the git repository at:
>
>
>   https://github.com/pvanleeuwen/linux-firmware-clean.git is_driver_fw
>
> for you to fetch changes up to fbfe41f92f941d19b840ec0e282f422379982ccb:
>
>   inside-secure: add new GPLv2 "mini" firmware for the EIP197 driver
> (2019-08-06 13:19:44 +0200)
>
> ----------------------------------------------------------------
> Pascal van Leeuwen (1):
>       inside-secure: add new GPLv2 "mini" firmware for the EIP197 driver
>
>  WHENCE                               |  10 ++++++++++
>  inside-secure/eip197_minifw/ifpp.bin | Bin 0 -> 100 bytes
>  inside-secure/eip197_minifw/ipue.bin | Bin 0 -> 108 bytes
>  3 files changed, 10 insertions(+)
>  create mode 100644 inside-secure/eip197_minifw/ifpp.bin
>  create mode 100644 inside-secure/eip197_minifw/ipue.bin

If this is GPLv2, where is the source code?

josh


> diff --git a/WHENCE b/WHENCE
> index 31edbd4..fce2ef7 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -4514,3 +4514,13 @@ File: meson/vdec/gxl_mpeg4_5.bin
>  File: meson/vdec/gxm_h264.bin
>
>  Licence: Redistributable. See LICENSE.amlogic_vdec for details.
> +
> +--------------------------------------------------------------------------
> +
> +Driver: inside-secure -- Inside Secure EIP197 crypto driver
> +
> +File: inside-secure/eip197_minifw/ipue.bin
> +File: inside-secure/eip197_minifw/ifpp.bin
> +
> +Licence: GPLv2. See GPL-2 for details.
> +
> diff --git a/inside-secure/eip197_minifw/ifpp.bin
> b/inside-secure/eip197_minifw/ifpp.bin
> new file mode 100644
> index 0000000..b4a8322
> Binary files /dev/null and b/inside-secure/eip197_minifw/ifpp.bin differ
> diff --git a/inside-secure/eip197_minifw/ipue.bin
> b/inside-secure/eip197_minifw/ipue.bin
> new file mode 100644
> index 0000000..2f54999
> Binary files /dev/null and b/inside-secure/eip197_minifw/ipue.bin differ
