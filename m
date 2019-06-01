Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD2DC28CC5
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E21827724
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfFANxd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:53:33 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58773 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfFANxd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 09:53:33 -0400
Received: from orion.localdomain ([95.114.112.19]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MDN3O-1hOrFU0BKY-00AZwR; Sat, 01 Jun 2019 15:53:06 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     vireshk@kernel.org, b.zolnierkie@samsung.com, axboe@kernel.dk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: RFC: declaring DT match tables (2nd take)
Date:   Sat,  1 Jun 2019 15:52:55 +0200
Message-Id: <1559397179-5833-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:6eR5FuObvStzaTwaSeJMTXjT3YTabwPEW7ElLE9COJw4VhtMuUe
 7klRWzxM0qEKRYASBKKWOgd4JLRnOW9D8256GOrsBf2kwpkGP/oPYI/+dYEax0EGgqLzyVL
 wQvba3P8HARfrEU/VyV/vXPdPJd8HBurS3F0nasiuGJJfc1om5av0pwSQpw1Fd/IHLPPMAk
 Fs6A8S0bThYHnX7m5zbHA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2taVwbVMVbk=:xHjxX+T6hP9V71LkUfGcf+
 VZ6QpOwcS0hJuPHuZPfabEXDMz5mHZ1Y3FPMF/EtfV4Y3Wen2q4h/xi5TNS/NrhCg5SFg3BX6
 SuuDgzklm8/fh2hvz9/sov7v6tOBTQfdnz+VBdrpP1Ht5butdbR0lMEk8M3S/ep/uQ+irkd78
 B5MI8ehPCY7d0NF2Mm1cX5cnH5DhimHJFeVLZP/Kxg0OorhwduACcspyYVVwZGoKUwY1Epkcr
 5I9Qz05WNjwLRmTb33wjmx3xgw4uwAEI2NBT9lAkeGpctR3wADBpiVIQX17f1aJbaluFGj0dj
 5A0UZeWTTktaeytgznjBLu8NKrKkrAEKylBCX74HYODKWa9GPOIYIh1Q/cGXrxV2DqbqQgb2J
 bud+gSdtrXrssHchBHaXXXVZM5CNJ+T4Qi3Mi3SJQTnSYjTbeF0s/A7aHPBSDXilZ+IHrtJoh
 AHw67RUWzf1xVYBU4/t42NQb2ymJ9ixcwE5ANhRM6w1gDRGhbuiiVNwAfnFCZvlf8OVpwp/Nv
 Sa7KJ78kIYpiVUngrSSO8wdH6FTsoDCc+Ys2/mVL1tqQvKcB0I0RtgMCuJbhslLxJfk4r4QxQ
 SIDcLZVAQYiROiPo8APmfafWXWfWBH280GbQaC2aRSkxI3gVnQfazSzEbr6qnPepXxQX2qQ77
 8lI19iP599vJkXawWpWEBePEUuD4E7ayBh2WfSNpAc007dEd0RTysmor1cKfz35P7KLPUWAyj
 oORAMyfac7fd2ctBb/bYPyNleMUvomnZojFIdQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi folks,


few days ago I've posted a RFC for getting rid of many #ifdef CONFIG_OF
cases by using a macro that checks for it on its own.
(see: "RFC: get rid of #ifdef CONFIG_OF's around of match tables")

I've already mentioned I'm working on another approach that not just
cares about adding the table to the module, but the also the declaration
of the table itself. Here it is:

Introducing a macro MODULE_DECLARE_OF_TABLE(foo, entries), which declares
a static struct of_device_id array, fills in the entries (automatically
adds the sentinel) and calls MODULE_DEVICE_TABLE() - if CONFIG_OF is
enabled.

The current version isn't fully noop in absence of CONFIG_OF, but also
declares a static const *pointer* variable, initialized NULL, with the
same name. The idea behind: we don't need to use of_match_ptr() anymore.

I believe, the compiler should be clever enough to find out that this
field is always NULL and can't ever change, so it can be easily optimized
away. (correct me if I'm wrong).


Please have a look at the following example patches and let me know,
whether we can go that way. If you're okay w/ that, I'll continue
w/ converting the whole tree to using this approach. I've already did
most of it, yet needs to be sorted out into easily digestable patches :)
And I'd also do the same w/ the other table types (ACPI, PCI, I2C, ...)

By the way: an interesting question arises: shall that conversion be
done *everywhere*, or just those sites where explicit CONFIG_OF's are
involved ?


have fun,

--mtx





