Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE78C001DE
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jul 2023 12:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjGYM7P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jul 2023 08:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjGYM7O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2023 08:59:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EC71B8
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 05:59:13 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3fd28ae8b90so53825e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690289952; x=1690894752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDsZSuqmM+rGTTq3XGxWZQLIR3riOkpSD8E9SwglKOE=;
        b=eEgaJ3PGFMgMtDL8tppMmm1dwf5hx4pCk1penH5gz3wKBQRxlBdCi5JzlGxR29Qyy1
         W05bxTpnhpfSzdDS2vrmktGgqjuKBoyakBDVmfyivi5jRg+xNFAxpd341k65RoV6eMDo
         7TkfaVR1WPXWBYEv6YFGMocbSLAlKs1C8alDwwVgOrNGkeXfWFsIYhOjkGmUVRPosv69
         2x+3iGRZWijDSiJgdwiP8NP/THF9ppFvA7bfuy5Dvc1HBvzVQWnflF1Lrq8p0igWRj19
         dwgHUQC6T8Owy9wUBOqjee76i3uXcp295YV08f2qRIbSODQuPR5BMO+JPaK4CLBHd21o
         Ic4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690289952; x=1690894752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RDsZSuqmM+rGTTq3XGxWZQLIR3riOkpSD8E9SwglKOE=;
        b=ElVcRizcPMoEvkICYaBcQasdEmMtwZT5eHTsaEpqE7gJw85jEVEfRGaPy/vc/i93LQ
         qLoiMmJDiDl0Ai28qrdLknxKrpDRQpWDi/rUW9hggE8Mgy1KScHh0DqZSqz8Rf2gABjT
         0gegEpBvq+JXIH1Et0sPj5d05ixO+F8V43mnuZkCkH7uj9YMWCHOW3mHyPKqTrN0pLBR
         NCrIq7CcPWvExzIGnJ4WXtEKpTLYSRPS0ok2JIMEdUn6qOIdRDM39sTgCHk7BHW+KiZL
         Y7JkAJjy1rO9709KREhJYnoC7zVcFABhCQH8gNG3yRUt7q2jVTqtsuDilfEyoFi6CtCT
         /gGA==
X-Gm-Message-State: ABy/qLaBY5Q5avmc/BRFUe2dfJH+9g3J4mt0aTT9oKCDK+bWvCmnYDwE
        Xc/Befy1ksPCHKvA7bn5kfQofgq1ltnsaoMATQjxLA==
X-Google-Smtp-Source: APBJJlG9w9Bhd6k3m0KjdikxCNQJAaXn/pCg6GjVlrrAKs0CjdmP/TLCGF0kN5RwhXuRKmTs659P1g6WoKbZUtPtISo=
X-Received: by 2002:a05:600c:8612:b0:3f4:2736:b5eb with SMTP id
 ha18-20020a05600c861200b003f42736b5ebmr53184wmb.1.1690289951656; Tue, 25 Jul
 2023 05:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000cb2c305fdeb8e30@google.com> <0000000000009eae2406014f451d@google.com>
In-Reply-To: <0000000000009eae2406014f451d@google.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Tue, 25 Jul 2023 14:58:59 +0200
Message-ID: <CANp29Y4ytfDf7B58CMGZpzhhuJ-LgfyxuAzxK6-yrnRGsXTUQw@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] general protection fault in cryptd_hash_export
To:     syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>
Cc:     alexander.deucher@amd.com, davem@davemloft.net,
        dhowells@redhat.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mario.limonciello@amd.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 25, 2023 at 2:57=E2=80=AFPM syzbot
<syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 30c3d3b70aba2464ee8c91025e91428f92464077
> Author: Mario Limonciello <mario.limonciello@amd.com>
> Date:   Tue May 30 16:57:59 2023 +0000
>
>     drm/amd: Disallow s0ix without BIOS support again
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D13ad506ea8=
0000
> start commit:   ded5c1a16ec6 Merge branch 'tools-ynl-gen-code-gen-improve=
m..
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D526f919910d4a=
671
> dashboard link: https://syzkaller.appspot.com/bug?extid=3De79818f5c12416a=
ba9de
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13c6193b280=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16c7a79528000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:

No, that's rather unlikely.

>
> #syz fix: drm/amd: Disallow s0ix without BIOS support again
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/0000000000009eae2406014f451d%40google.com.
