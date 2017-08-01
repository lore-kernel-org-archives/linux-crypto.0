From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging/ccree: Declare compiled out fuctions static inline
Date: Tue, 1 Aug 2017 15:35:41 +0300
Message-ID: <CAOtvUMd3ykdzoLu1UykJgA4cMhu8xoVgae2FGv612zbMn5VnUw@mail.gmail.com>
References: <1501492643-7087-1-git-send-email-rishabheudyptula@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        RishabhHardas <rishabhhardas@gmail.com>
To: RishabhHardas <rishabheudyptula@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36094 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdHAMfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 08:35:42 -0400
Received: by mail-io0-f194.google.com with SMTP id j32so1431786iod.3
        for <linux-crypto@vger.kernel.org>; Tue, 01 Aug 2017 05:35:42 -0700 (PDT)
In-Reply-To: <1501492643-7087-1-git-send-email-rishabheudyptula@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 31, 2017 at 12:17 PM, RishabhHardas
<rishabheudyptula@gmail.com> wrote:
> From: RishabhHardas <rishabhhardas@gmail.com>
>
> Sparse was giving out a warning for symbols 'cc_set_ree_fips_status' and 'fips_handler'
> that they were not declared and need to be made static. This patch makes both the symbols
> static inline, to remove the warnings.
>
> Signed-off-by: RishabhHardas <rishabhhardas@gmail.com>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
