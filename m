Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62A0C77B75
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 18:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjEPSIc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 14:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjEPSIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 14:08:32 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE0F11C
        for <linux-crypto@vger.kernel.org>; Tue, 16 May 2023 11:08:29 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-331632be774so45523785ab.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 May 2023 11:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684260509; x=1686852509;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7cfmVckDHddvRqZ8odcZBeCbYSIduTckoQySA1Yp2w=;
        b=DlZmvQhyoQohopSNHXQwwUQRFntvBgGe05h38wIasH6pB/goLlmK2+7yhZmXucKGVu
         J5nIDs1RzQd9/k77KpAgSRWkXzN55LgxM8pQhDIrGBbD8pQVCzNj9yulJ+kIGhm6M6zP
         a1mAr9YoeVASQI/FImWVWUVUFMhSG9oLBAWrqZOUxuZD1eINiip3IaV7bOBOauspW9ir
         DO9Yl+UdnB9jVttlzz3nTRVkiTNcwsoE7M3N1xaMUqizLGLt3xllZRD91eYkX9qH+fJe
         5yNiu2kP0XrQ74awnZhqj9KUbT+nUskQaKXO9elGfHy6fkrAwj2FocH0kc9pt4afdZMD
         q4BA==
X-Gm-Message-State: AC+VfDwhULG1lfy7/3Y+1qV7Su3hKysEiHHXh2L6C+mlft2SId3cmkX4
        lAp3PRSirdwVsWEysklH5fzfVUTrdAhTFaSqqPgRE+YLEWYi
X-Google-Smtp-Source: ACHHUZ63BE9GYHrroUdVptFYUVNfxy+8tYlUHvBejzt2rUT9DhZdFrbd4+sq88RXmQVswjnq12HB6/+V+e7muZaqmwJn/Q3txz7K
MIME-Version: 1.0
X-Received: by 2002:a02:862b:0:b0:418:81f5:6f39 with SMTP id
 e40-20020a02862b000000b0041881f56f39mr6649927jai.3.1684260508921; Tue, 16 May
 2023 11:08:28 -0700 (PDT)
Date:   Tue, 16 May 2023 11:08:28 -0700
In-Reply-To: <CAMj1kXH8B6dmt0LVVyyorAzrKmkD2uFZ-5r4w0kMTYKbhqSPMA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057f58705fbd375a3@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in __aria_aesni_avx_gfni_crypt_16way
From:   syzbot <syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, ardb@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com

Tested on:

commit:         d5253ed2 crypto: x86/aria - Use 16 byte alignment for ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git crypto-aria-x86-fix
console output: https://syzkaller.appspot.com/x/log.txt?x=17fed781280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8bc832f563d8bf38
dashboard link: https://syzkaller.appspot.com/bug?extid=a6abcf08bad8b18fd198
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
