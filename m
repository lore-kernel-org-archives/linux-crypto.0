Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:45714 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbeJZIVV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 04:21:21 -0400
Received: by mail-lj1-f181.google.com with SMTP id j4-v6so9841822ljc.12
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2018 16:46:40 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id q78-v6sm1073363lfi.44.2018.10.25.16.46.38
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Oct 2018 16:46:38 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id p1-v6so9851558ljg.6
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2018 16:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20161119102748.GA4277@gondor.apana.org.au> <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au> <20170904101225.GA12613@gondor.apana.org.au>
 <20171113074346.GA20245@gondor.apana.org.au> <20181023100958.GA11991@gondor.apana.org.au>
In-Reply-To: <20181023100958.GA11991@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2018 16:46:22 -0700
Message-ID: <CAHk-=whrfStPeB=5_HoaYraL8XnS5qfbGMDdLOw7sxDF4FKgHg@mail.gmail.com>
Subject: Re: Crypto Update for 4.20
To: herbert@gondor.apana.org.au
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 23, 2018 at 3:10 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Here is the crypto update for 4.20:

Pulled.

> Please note that there is a conflict with the compiler-attributes
> tree as one of the lines that was removed by a patch in the crypto
> tree was moved to a different file in the compiler-attributes tree.
> The fix is to remove that line from the moved file.

Thanks for noting that. I haven't pulled the compiler-attributes tree
yet, but I will hopefully remember this note when I do.

The lib80211 conflicts looked trivial, but I'm building the tree to
verify that I didn't screw something up..

               Linus
