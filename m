Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CEAC4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 22:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiKHWjg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 17:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKHWje (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 17:39:34 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB3160356
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 14:39:34 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13ae8117023so17849594fac.9
        for <linux-crypto@vger.kernel.org>; Tue, 08 Nov 2022 14:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/iT2V0+tQxLZsJICdQg59XlFu2/MLGUwh4giryzJ2M0=;
        b=ICm23jsQ4wdOkSkDuvly1QVqoPytp9haz2v1LjvoeGLVJH9FIR4AyyOH/NFjOrtxi1
         B/H6EBQqzG7LanFT66euegYuzZFZZiTmk/DcaMWZtl1n4lK6Az2iCmQ3HxD++xJOx8Qd
         HkOMIF1ZZ2Ohq0FCllMqc2J4z135+5BpkMihQLi5XuVlfDhicgi3lxbE3h/5TDttK7Mf
         pOfN3kaFDtIlLyD4sozk8RI1jslvNTObnkLpfycgwiQEQPAL6l/HZpE1jjEHhgip8JzZ
         3gs8i7tZ2V56xO1OCuHRfEKQ/oxejvmnKNz9oY57bkozIMB8nOzi/d5oLykBS2UpRcNp
         pq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/iT2V0+tQxLZsJICdQg59XlFu2/MLGUwh4giryzJ2M0=;
        b=3P3jwuC7OIsoIqcVeaUYDAx/YQdkmJnyNaibjDbc1d00Q9VRr4/5TpPhMe2k3HPrDK
         jOsTtHiPGQAojvawYFYgKqy4T7HaldcdR7REOe/YCb7++WomRfryKNo2TfQJoYYW3pnm
         kzAePjqx7qgrHiQ57cJtWCuKlm7Oac6+7HKenQof8NTq/mB/eZnNQe+rsMIiHpGQbgZ2
         ddwH5Yl1kZWGfyeXArMZ2gbS8HKEhxqPOeIPwiLOlkIbw2+HgzxfO8UVb0cwsyr32EiE
         4oS26afWGyzamnrXFjHKUJ0oPSPG6DxI3a5tMd1Zulx/Mf4NLcbDwEWsPQezya8ordTT
         udGg==
X-Gm-Message-State: ACrzQf2HBkt1xcrW54jn/MGToxEouUCChJpPdb52CHZjvZBR4xI1bLIE
        5oOuQP0oL0mH8X0f2wFR1UKlUKDN/Eu5s+Wa2Cd65w==
X-Google-Smtp-Source: AMsMyM4IufYTlvc6thSOGbvJFOSUOuyMiyKKIhnuNmYNTwpkUcVkstkGJdDySVWlN34cPCqWVOREmvOavwxL3Nc1Ajs=
X-Received: by 2002:a05:6870:b6a3:b0:13b:f4f1:7dec with SMTP id
 cy35-20020a056870b6a300b0013bf4f17decmr34481709oab.282.1667947173215; Tue, 08
 Nov 2022 14:39:33 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e915eb05ecf9dc4d@google.com> <Y2qjerZigLiO8YVw@zx2c4.com>
In-Reply-To: <Y2qjerZigLiO8YVw@zx2c4.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 8 Nov 2022 14:39:22 -0800
Message-ID: <CACT4Y+a3bJmMf8JNm=SZYOKtgSVnOpY4+bgdT4ugLLhVV-NCEA@mail.gmail.com>
Subject: Re: [syzbot] linux-next boot error: WARNING in kthread_should_stop
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     syzbot <syzbot+25aae26fb74bd5909706@syzkaller.appspotmail.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux@dominikbrodowski.net, olivia@selenic.com,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 8 Nov 2022 at 10:44, 'Jason A. Donenfeld' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> Already fixed in the tree.

Hi Jason,

The latest commit touching this code in linux-next is this one. Is it
the fixing commit?

commit e0a37003ff0beed62e85a00e313b21764c5f1d4f
Author:     Jason A. Donenfeld <Jason@zx2c4.com>
CommitDate: Mon Nov 7 12:47:57 2022 +0100
    hw_random: use add_hwgenerator_randomness() for early entropy
