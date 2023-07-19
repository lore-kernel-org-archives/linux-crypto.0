Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B5BC0015E
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jul 2023 17:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjGSR5E (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jul 2023 13:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGSR5D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2023 13:57:03 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C22E1FFE
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jul 2023 10:56:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3fbb07e7155so9155e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jul 2023 10:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689789414; x=1692381414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DD1IusQWRz6p2k0vZ6mCPvoLmaSeWQRMjCUQkOWqtZ4=;
        b=tokZw9dfLqWCkA//xRWaD3/62VJCQvQV+NksrMsFB3gANBGXmcp0kknUxUY88Ja52d
         otMnaSRZyF0woIeqeePP9qQM7+7RxUCU0Hdaqq14PmVZzBVoY4EI5pz5tzaJj1UAFdud
         2NfcmFmW99tltTR6vU3ux+cnaAhdPEnNGa1vad8CwhiE0pM2UyKQlp4dr+wS4jQpA7bx
         uLakX3lCdxTDhkbwwVFfogIcAuDkY7ebx6HVutkOKNmLhW7/Vl30UzLarBnLCzXnR51v
         ls4NF1NRyc7kIsHAckEFx72s9UO15Ygztw90IMhfSekugKUEy86jP+gMGASY8Z1HbIJK
         XpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689789414; x=1692381414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DD1IusQWRz6p2k0vZ6mCPvoLmaSeWQRMjCUQkOWqtZ4=;
        b=Ifxa8BpMIJJ/ByNq4vjFVnK2W7U4ZwYiAs+T6bfhkFTRtucmUH3IUIgJnsNvdQX/Dc
         PZWUEkm6PocDFXV4HPbsFyBHEOTl/9zdYrI3knbpA2vejjppFGK1B+N+25AENuNtIZzq
         c/VPzPaPPgZoUNNQKBHxWWUcRbeALtjTSieBHMi5rCz8VLV3wspTrt97jDORD2F0u++c
         LmnpOinR0uFrd006Aoh1ZEY1ImYPPqr2od52qXdJE+yaX9zaomwQJxwEDaPTnJa93QLB
         LjpzvbLvCz971CJcphh9No0ewBE+yH9KhRBoUWPw5BvH2xZdaNHlnrAQSwqhXKFcXMqw
         mnzA==
X-Gm-Message-State: ABy/qLZcBIOeaR3b0ahg0C+8XJFPDsfHYaEaOTson9dZOVOS2VyshX9T
        BJilwdIWVZkULVPqdfCdIICC5N4dNqlAk5J4EsHNhA==
X-Google-Smtp-Source: APBJJlG5bTRD5YkszX4iw8+wglBuRr66CaZUTcAakzDmbxj2WKqLn2P0+Qoo7JohL/GOWrxSJZrgc4+E+BQi5RXNWfo=
X-Received: by 2002:a05:600c:4754:b0:3f6:f4b:d4a6 with SMTP id
 w20-20020a05600c475400b003f60f4bd4a6mr4947wmo.7.1689789413718; Wed, 19 Jul
 2023 10:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ada87505fe7cf809@google.com> <0000000000002361ee0600da8ec5@google.com>
In-Reply-To: <0000000000002361ee0600da8ec5@google.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Wed, 19 Jul 2023 19:56:42 +0200
Message-ID: <CANp29Y6QHom7Db6y3azXS0MACKSW6hUQzypZs7qrB-3TtxO1zA@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_ahash_update
To:     syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
Cc:     Jiadong.Zhu@amd.com, alexander.deucher@amd.com,
        davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 19, 2023 at 7:42=E2=80=AFPM syzbot
<syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 1dbcf770cc2d15baf8a1e8174d6fd014a68b45ca
> Author: Jiadong Zhu <Jiadong.Zhu@amd.com>
> Date:   Wed May 24 03:42:19 2023 +0000
>
>     drm/amdgpu: Reset CP_VMID_PREEMPT after trailing fence signaled
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D1622cafaa8=
0000
> start commit:   9a94d764e9bc Merge tag 'mlx5-updates-2023-06-16' of git:/=
/..
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da4a7d74e6a7c3=
211
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D88f4b1e6cf88da1=
1f5cd
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1152c4ff280=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1307cbcf28000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:

No, that's unrelated.

>
> #syz fix: drm/amdgpu: Reset CP_VMID_PREEMPT after trailing fence signaled
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
