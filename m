Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8791EC433DB
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 20:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49BD522C7B
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 20:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAXUkb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jan 2021 15:40:31 -0500
Received: from mout.gmx.net ([212.227.17.22]:38845 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbhAXUkZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jan 2021 15:40:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1611520712;
        bh=0B/eGqEMyDGUzaCNtHH6MwjEnj2C/qg3WkdMqiknQU4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=L0/Hm/TLKEmUCWc7XhqkiZ594nasJvbocdQonOe6IEebu4Tso/WPlVB36Q2rfoLyo
         dSFBFdGLTuE6l2GNcGa1sLn/Lc5qlS0MDkWTZfuM8kwYK1ykpq/RD1s78Dv56rBDh7
         SIKcfl5klTMfnPwKrwEy4jXPPdq7sjCt/aLB9G+8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.141.229]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N79u8-1m4HHI2Kui-017SNm; Sun, 24
 Jan 2021 21:38:32 +0100
Subject: Re: [PATCH] crypto: xor - avoid division by zero crash
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Douglas Anderson <dianders@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>
References: <20210124142806.GA29180@ls3530.fritz.box>
 <CAMj1kXEfw2a7QAfFUGemV-uiXF1oSeWnBzWouXFbp2u6g7rojQ@mail.gmail.com>
From:   Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
 c2TFWAS8k6RLkk41ZUU8ENX8+qZx/Q==
Message-ID: <5448bd16-f2c3-1ea0-9a3f-ab124e345d37@gmx.de>
Date:   Sun, 24 Jan 2021 21:38:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXEfw2a7QAfFUGemV-uiXF1oSeWnBzWouXFbp2u6g7rojQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TPhIAIXqKN6TPFN5jw/GKf76iW4DSAhBkYVSVXB7rTLkgNNo8fB
 oPbVIg6xLfa/FvkdbSJYHi4S+myNkZTKxEoBcezJtwF6566whkB5FliLDHZzJlfCpz0qN9N
 pq+eTkcl501ta0z0wE7aqTDWw8ifLDAbusfZ25wbDjds43/garcTsG/qr1tFidNzyqb5sSN
 L7NKU2lWeBK206G4eJtRQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hd7iwY5rRsE=:YuhcG6D7h9gegcQCifiYjG
 v3nDsAmiyK/0Z+dlfcau82i/Qh+L9HPOrJm2NAx3YSNjJhe4aQmxkQ9sD6/ha/8BMYTfat1zN
 06C8FK5YmvvF0qcWNh34g+dX2sS1Ikue2cfhceRxVSkV35hviMObcBTuYapCjJBv4o5ZrUkpn
 tL8NvmAi1hiMudT8CN939xHWN1HaXDLNpbWhxcCr7Dc3wJnmQV4vqFfrrkstHCszETQBWBORs
 UDJFbOMsv5J3L7sYfkqq/Ou3LnrtY0vhOlJqUQWXMJe/Yc9N4dBh8s/hm75bHCmXAGWDLPPJg
 +4CsgzH33avoNy9lNsi21m0bBstARVDbUQkiMkUw9PKymfj8ys7BY3m9sr0qxK0UWlZjpOETt
 HZAfLOYl+MJfUUdbs7UUXQFO3pntLTJyX0q7kA+709pUS4HEpEo2hGuUUXSaQZNcX2VLEDPzf
 lY4IyHIbfRFPawy9DOl6C0A+jk7ubu00w6V9HhnePH8VG/BTETwpgwLKcdfaf+J/j3zXpWU2O
 hYhEyHsqNCRVITZhhDO+WcDIgpM5iMjP2nC0avASdJcu76xgDEXVyqvR7To37RgrKu+jvZW6e
 itRlSZkZWcI82Tw41xIxpB3QUlee1ghBa5RyYWvSbKopLFZEOgOC5Sge+ibUH6qDZMjnbrwLe
 /gUmh8oCSlJGwiH2L6zTFVTeJVrqviwRr4kUTEpMQwrdx4qflugIR+s+hiMuA9nc27Qj7USBm
 WguLdLwh90lzj+oE4QT6F9rJzQWs5GHdtC4nZwxjTfdDP8IPLQkcwctEHvcF1VpQ2PEhtb9pB
 ruV1ncpKSy9IE3yj9DGHAlRpysI+mGDQXkg/iLT1NVAXTQ1Wd10OsvUjexggIJM0TcihXpILG
 y/c+lq62KjOMC8DVpwsA==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/24/21 3:30 PM, Ard Biesheuvel wrote:
> On Sun, 24 Jan 2021 at 15:28, Helge Deller <deller@gmx.de> wrote:
>>
>> On some of my parisc machines, this patch c055e3eae0f1 ("crypto: xor -
>> use ktime for template benchmarking") triggers a dividy-by-zero
>> exception because "min" becomes zero, which then leads to a kernel
>> crash.
>>
>> It's not clear yet, why I see the issue only on some machines. At least
>> on those the measured time to run the xor speed tests becomes zero
>> nanoseconds. Maybe it's because gcc-10 optimizes the speed test out, or
>> because of some other changes in the time keeping routines.
>>
>> In either case, the kernel should not crash.
>>
>> This patch adds a workaround by reporting such cases with a kernel
>> warning and continues as if the xor tests would have run in 1 ns.
>>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>> Cc: stable@vger.kernel.org # 5.10+
>>
>> ---
>>
>> diff --git a/crypto/xor.c b/crypto/xor.c
>> index eacbf4f93990..3639341bac7e 100644
>> --- a/crypto/xor.c
>> +++ b/crypto/xor.c
>> @@ -100,6 +100,8 @@ do_xor_speed(struct xor_block_template *tmpl, void =
*b1, void *b2)
>>                         mb();
>>                 }
>>                 diff =3D ktime_sub(ktime_get(), start);
>> +               if (WARN_ON(diff =3D=3D 0))
>> +                       diff =3D 1;
>>                 if (diff < min)
>>                         min =3D diff;
>>         }
>
> This should already be fixed in mainline - please check whether that
> fix works for you.

Yes, it's basically the same fix and a good step.
It fixes the kernel crash at least, but it's still strange that
the timing calculation will be wrong.

Helge
