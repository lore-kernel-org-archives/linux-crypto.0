Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FEDC7C829
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9293F21841
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgD0ITr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:19:47 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:44305 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgD0ITq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 04:19:46 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MzQwa-1jFhIm3dU8-00vMhr; Mon, 27 Apr 2020 10:19:44 +0200
Received: by mail-lf1-f43.google.com with SMTP id f8so13062817lfe.12;
        Mon, 27 Apr 2020 01:19:44 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ85yEie7SI4mXbpUNxbNq/kyBtKnIm2qtWiwp4PS/aZbZjsbIB
        qKx6tBrOml2/5Cj0EZldo2UdoQ+QzqXYZfMHX9w=
X-Google-Smtp-Source: APiQypKq+e3NC+Rf8KzaYonKc9dxCoJqQRrJrRG2Yg0jxksCGlJ48uH8hPHx64NKuyd+sZ0TBuXz/6X9HC2EUJLCFf0=
X-Received: by 2002:a19:4b90:: with SMTP id y138mr14393819lfa.39.1587975584363;
 Mon, 27 Apr 2020 01:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <1587966099-28139-1-git-send-email-hadar.gat@arm.com>
 <1587966099-28139-3-git-send-email-hadar.gat@arm.com> <CAMj1kXGwVZiGbsT2NwWTyka0FVZnQcmfMSeoBKD03PdC=fRZeA@mail.gmail.com>
 <DB6PR0802MB25334429B7DD333780E7BABBE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB25334429B7DD333780E7BABBE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 27 Apr 2020 10:19:28 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1LYAESnePbwbn7x7x=2MCTWUNZVmmoiuv+_-J2ntFGmA@mail.gmail.com>
Message-ID: <CAK8P3a1LYAESnePbwbn7x7x=2MCTWUNZVmmoiuv+_-J2ntFGmA@mail.gmail.com>
Subject: Re: [PATCH 2/3] hwrng: cctrng - change default to n
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:JZk1rY2QBY2t6QRgHFCvHTZYoKOBY6GwFBii/ryiTzIpqlx/XN6
 Fng27KvbkdMXSsM9mBVlxKMWNMy7nSJUEu2Os7Wqwp9quhCHInVvvA7LCN91eun4KjNrDfD
 xpl3Ookw2O3m8kkrHDyhnHjS/4ufKvsnVIF4MhA+rYsrSfgW5mCLa0yNJzB6mg127ZlWZLB
 f8pkb5W3vJgpjdgGMpyhg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8QlHj3zZLkY=:NYM1FTY3EEbenHMb1D71Mn
 i4LDcgNURbhhEgVvEBn+cZ5WBI/5/go8lcoMuCr0wTNT+RXxBc6yLT5RhOSjVyNjrcF6nBxV5
 EQIHs2w1awPkIiUTwdDfo2521UUXqYXpzW7OMymAoRHIFH+ltaNzCb5VMjqygcG5z8/k234vo
 2cAlLBlGMMWlJbCzu2OPL5bsr0fzsMTvJroh+JjlgpiSBihIvIUwkP6QGJugLgfzbbZxAxMIa
 u5EH2XB7EiNJsip7pkFu/HgIkAIuTdaHfhZSiCliTI+MRAsDpawc++SfgcvD+O28n+YeSNaJN
 BBo6S5gXvv+p3Abf7U2lp9UyiNf0+7Orcf/XzbYPIBKRbd+snuxQUhbwkYjUgTGyTTahqoyug
 CgKgsBWvR5UJzVNFE9TCGKKerTaE4umLUAOdUkU8bDmkRoBUe8pVvzUMABMdIiyVEVjlifsvd
 RcleteP27G7ZYoh5wH31wPr7g8q8Yb1wTCP6Tw2GVSB55s2rp2nedEnNYHPZ5A7Rmhjm9oRHd
 JE0JZszm6fWq5TnGSF4q5+MUWoxLTx1bqAnBRAZoCd3qiwrSdJ6tCki0f7vkhZrDCxD0hxbyj
 oqG4CTF2485vo6RsF8v6klv3FDDHIehf0sLf4By7k/gsbKWCXjOYhs0HW7+TdJgVcwLUqaLxp
 5fNk0tqDYDKsFFBJ7MJYyr0DJpeeHINuhf/JLgwGyuc3VLz3m+mrKR/sxYkIBUUVC1Y4AMW2F
 +6dwHVdd2UxiZCE0sx3EnagPJdDIjEHinl9ZAdDwawnPkrpfOyf7IUvTc5PBHrZ2AO01OPFq/
 YBBORCIsHqbQ9YetLJ3UXvkIqegUYKlCnRx+NrVQHZB7J2dLkA=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 27, 2020 at 9:26 AM Hadar Gat <Hadar.Gat@arm.com> wrote:
> > -----Original Message-----
> > From: Ard Biesheuvel <ardb@kernel.org>
> > > +       default n
> >
> > 'default n' is the default so you can just remove the line
>
> Is this a guideline or just optional?
> Personally I like things to be explicit and if allowed I prefer to keep this line.

It's a common convention, and we have had patches in the past that
mass-removed those lines. I'd also just leave it out. It is generally well
understood that all options default to 'n' unless specified otherwise.

        Arnd
