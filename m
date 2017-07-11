From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 0/5] staging: ccree: fix checkpatch errors
Date: Tue, 11 Jul 2017 16:38:34 +0300
Message-ID: <CAOtvUMeYKs2-6LgzP9Mfp2P7cDxXfF8Gki7ePO-v4V7=Nv6DYw@mail.gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: gregkh@linuxfoundation.orgc, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
To: sleepingzucchini@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36515 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932229AbdGKNig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 09:38:36 -0400
Received: by mail-yb0-f194.google.com with SMTP id o195so5514980yba.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 06:38:35 -0700 (PDT)
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 10, 2017 at 12:10 AM,  <sleepingzucchini@gmail.com> wrote:
> From: Tyler Olivieri <sleepingzucchini@gmail.com>
>
> This patchset fixes several checkpatch errors and warnings in /staging/ccree:
>
> ERROR: that open brace { should be on the previous line
> ERROR: open brace '{' following function declarations go on the next line
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> ERROR: do not use assignment in if condition
> ERROR: switch and case should be at the same indent
> WARNING: Statements terminations use 1 semicolon
>
> This is also a submission for the eudyptula challenge.
>
> Tyler Olivieri (5):
>   staging: ccree: remove redudant semicolons
>   staging: ccree: fix placement of curly braces
>   staging: ccree: remove assignement in conditional
>   staging: ccree: export symbol immediately following function
>   staging: ccree: fix switch case indentation
>
>  drivers/staging/ccree/ssi_buffer_mgr.c | 14 ++----
>  drivers/staging/ccree/ssi_cipher.c     |  6 ++-
>  drivers/staging/ccree/ssi_driver.c     |  5 +-
>  drivers/staging/ccree/ssi_fips.c       |  2 -
>  drivers/staging/ccree/ssi_fips_ll.c    | 85 +++++++++++-----------------------
>  drivers/staging/ccree/ssi_hash.c       | 33 +++++++------
>  drivers/staging/ccree/ssi_sysfs.c      |  3 +-
>  7 files changed, 57 insertions(+), 91 deletions(-)
>
> --
> 2.9.4
>


Looks good to me.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks!

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
