Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0798EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 05:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbjFPFBZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjFPFBY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 01:01:24 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98853270E
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 22:01:22 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77ac4aa24eeso25575439f.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 22:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686891682; x=1689483682;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGnwxdo2DEMIi7tpDl/sj1NsuPf/fjo1eZwFLbHh/oc=;
        b=OD5PaAfr9jDUkISyS5uu1uAw1xWDWVWMODK6UfnH6ySIj+lLygLFZgRFvfCY7KlHP4
         ZUIQJq2//TVM05J4s/NCn25I7QX9Pz/h4Q4hmmRgIFP0BnBYnj5OK5sAZxw3X8Icz+5N
         Ehi2kdbkj8NqAs/U2BrN5c4CVj3YiBUy+kwUTZqHxJmDcwoH0mnGRisVaYRu9WV+I5Mn
         m/BmIIXGOpM7xaYTWOk9VnW6ZFZGlQ7MsFdaUvDFGlhFq3smB14zvk0y/DBff9XYcbp1
         YOPoHovEi2XTQP8iRKOiW5XwlhEc+9AiUQi4A1P+gfw0q+iVnJfKce5nBtJ1PWO/TtzR
         VxZg==
X-Gm-Message-State: AC+VfDy3xMMgL/TNwnvlnhBsgYOoKwfghmcnAPWOpA3OrZzWvnHLoPla
        em8j4HmWEf7MxVwI28QIDq7HE/s9DlvOcfULhdmvU3mINoNI
X-Google-Smtp-Source: ACHHUZ6chEzs+H370XGbzmOcYS60hX1wyOhuKQHSGSvTc8wzvYQfpRdk/s8FYqZChd2H1Q8CFppxMqo46ogMdIqov/rMlSBJIyS+
MIME-Version: 1.0
X-Received: by 2002:a02:3319:0:b0:423:141e:f20b with SMTP id
 c25-20020a023319000000b00423141ef20bmr303599jae.2.1686891681994; Thu, 15 Jun
 2023 22:01:21 -0700 (PDT)
Date:   Thu, 15 Jun 2023 22:01:21 -0700
In-Reply-To: <415439.1686877276@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007adf2d05fe38132a@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_final
From:   syzbot <syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com

Tested on:

commit:         97c5209b leds: trigger: netdev: uninitialized variable..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=159c4d9b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=13a08c0bf4d212766c3c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16962727280000

Note: testing is done by a robot and is best-effort only.
