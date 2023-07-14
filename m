Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71844C0015E
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 15:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbjGNPbY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbjGNPbX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 11:31:23 -0400
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C970E2D65
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 08:31:22 -0700 (PDT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3a44a32d3b5so270228b6e.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 08:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689348682; x=1691940682;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7sSZHfmPmMwSnKDeS/LYNRFHMjooDKw3TKG4ZxrK+w=;
        b=XumR1JizLyYn5vwPE5aoRc9sIj5KUsUXg7da/U014LqXvATBxBxIgm6xKqE3Q6S4wW
         05cqUmsMUrSQYoae4ZANZBfuana8SgZewcQCxCLk3Y2ugV3I1RrmPhi1/1sSZhoBCWaW
         M0cH+G6IOsDkSyDlmGh0RXbO23A5ra+JbATj5sDKJNS4WM2XTKq0Ug+MWOz6N4u3MSF+
         mwrOtufhJY4XIH8T0szujilO08lnA0TOzKn0iUWTX+hZjuivefXlMd8Mak4nGydIg5rT
         gFc6C7BQzFmeQITv9QW15GDMjQbGzI4AzS7vRbyGKOO3rYwOSssvTWxhl4Ad3I7V4gDC
         4LXg==
X-Gm-Message-State: ABy/qLbX72hT1+s+7x0vX5XkIODkAT8/z3b0RsEI940nJTkpOCBGZdB/
        Fgaj+0LJ2/NOgGmd4NPprgdpc/H58uU/yJ84gVrmoHTVF48M
X-Google-Smtp-Source: APBJJlEO7SDJzBanjllHj0OMQaarkOBoeRSZBRQYOWiHUr5A816YDqucajDumEt8SgiTfLBkERkeNjV6wMiR4iwf4GZGQhd4Xxyy
MIME-Version: 1.0
X-Received: by 2002:a05:6808:208a:b0:3a4:1e93:8984 with SMTP id
 s10-20020a056808208a00b003a41e938984mr7270461oiw.1.1689348682197; Fri, 14 Jul
 2023 08:31:22 -0700 (PDT)
Date:   Fri, 14 Jul 2023 08:31:22 -0700
In-Reply-To: <9f0365cb-413f-2395-2219-748f77dd95a4@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001aaf4d06007424f4@google.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in af_alg_free_resources
From:   syzbot <syzbot+cba21d50095623218389@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        paskripkin@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+cba21d50095623218389@syzkaller.appspotmail.com

Tested on:

commit:         4b810bf0 Merge tag 'erofs-for-6.5-rc2-fixes' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1584e7d4a80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=81133937a108454e
dashboard link: https://syzkaller.appspot.com/bug?extid=cba21d50095623218389
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1305e904a80000

Note: testing is done by a robot and is best-effort only.
