From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: Fix unnecessary NULL check before
 kfree'ing it
Date: Thu, 27 Jul 2017 19:09:44 +0300
Message-ID: <CAOtvUMeHKGaihasV4e4xmQ6MZgs3KtwkY7jqMkQRYwMP5shwjQ@mail.gmail.com>
References: <1500557827-29853-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: sunil.m@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33507 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdG0QJp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2017 12:09:45 -0400
Received: by mail-it0-f66.google.com with SMTP id t6so13851893itb.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jul 2017 09:09:45 -0700 (PDT)
In-Reply-To: <1500557827-29853-1-git-send-email-sunil.m@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Thu, Jul 20, 2017 at 4:37 PM,  <sunil.m@techveda.org> wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
>
> kfree(NULL) is safe and their is no need for a NULL check. Pointed out
> by checkpatch.
>
> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> ---
> Note:
> - Patch was compile tested and built(ARCH=arm) on next-20170719.
>   No build issues reported.

Patch applies against staging-next + latest changes and it builds and runs.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad
