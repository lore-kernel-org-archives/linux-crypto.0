Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A09C32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA80E216F4
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbfI3LO2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 07:14:28 -0400
Received: from ns.iliad.fr ([212.27.33.1]:36304 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729870AbfI3LO1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 07:14:27 -0400
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id DDB6620274;
        Mon, 30 Sep 2019 13:14:25 +0200 (CEST)
Received: from [192.168.108.37] (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id A199D20187;
        Mon, 30 Sep 2019 13:14:25 +0200 (CEST)
Subject: Re: France didn't want GSM encryption
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org>
 <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
 <MN2PR20MB2973A696B92A8C5A74A738F1CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wj9BSMzoDD31R-ymjGpkpt0u-ndX6+p0ZWsrJFDTAN+zg@mail.gmail.com>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
Message-ID: <3e5347a2-9aa7-bffb-2343-42eda87a6c83@free.fr>
Date:   Mon, 30 Sep 2019 13:14:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj9BSMzoDD31R-ymjGpkpt0u-ndX6+p0ZWsrJFDTAN+zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Mon Sep 30 13:14:25 2019 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[ Trimming recipients list ]

On 27/09/2019 18:23, Linus Torvalds wrote:

> It's not the crypto engine that is part of the untrusted hardware.
> It's the box itself, and the manufacturer, and you having to trust
> that the manufacturer didn't set up some magic knocking sequence to
> disable the encryption.
> 
> Maybe the company that makes them is trying to do a good job. But
> maybe they are based in a country that has laws that require
> backdoors.
> 
> Say, France. There's a long long history of that kind of thing.
> 
> It's all to "fight terrorism", but hey, a little industrial espionage
> is good too, isn't it? So let's just disable GSM encryption based on
> geographic locale and local regulation, shall we.
> 
> Yeah, yeah, GSM encryption wasn't all that strong to begin with, but
> it was apparently strong enough that France didn't want it.

Two statements above have raised at least one of my eyebrows.

1) France has laws that require backdoors.

2) France did not want GSM encryption.


The following article claims that it was the British who demanded that
A5/1 be weakened (not the algorithm, just the key size; which is what
the USgov did in the 90s).

https://www.aftenposten.no/verden/i/Olkl/Sources-We-were-pressured-to-weaken-the-mobile-security-in-the-80s


Additional references for myself

https://lwn.net/Articles/368861/
https://en.wikipedia.org/wiki/Export_of_cryptography_from_the_United_States
https://gsmmap.org/assets/pdfs/gsmmap.org-country_report-France-2017-06.pdf
https://gsmmap.org/assets/pdfs/gsmmap.org-country_report-France-2018-06.pdf
https://gsmmap.org/assets/pdfs/gsmmap.org-country_report-France-2019-08.pdf


As for your first claim, can you provide more information, so that I could
locate the law(s) in question? (Year the law was discussed, for example.)

I've seen a few propositions ("projet de loi") but none(?) have made it into
actual law, as far as I'm aware.

https://www.nextinpact.com/news/98039-loi-numerique-nkm-veut-backdoor-dans-chaque-materiel.htm
https://www.nextinpact.com/news/107546-lamendement-anti-huawei-porte-pour-backdoors-renseignement-francais.htm

Regards.
