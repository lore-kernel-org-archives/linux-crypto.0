From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW accelerated
 crypto modules
Date: Sun, 16 Feb 2014 22:56:22 -0300
Message-ID: <CAKi4VA+L1YxmhyBrzxHzqyjXY4xnLbfzm1H_X6aze+Wr8Fw2qw@mail.gmail.com>
References: <1392405277.27116.72.camel@schen9-DESK> <20140214202828.GA17267@hmsreliant.think-freely.org>
 <1392412566.27116.77.camel@schen9-DESK> <87ob26d1br.fsf@rustcorp.com.au> <20140217012150.GA7542@bongo.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Marco d'Itri" <md@linux.it>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Lucas Martins De Marchi <lucas.de.marchi@gmail.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42143 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaBQB4n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 Feb 2014 20:56:43 -0500
Received: by mail-ob0-f171.google.com with SMTP id wp4so16329882obc.2
        for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2014 17:56:43 -0800 (PST)
In-Reply-To: <20140217012150.GA7542@bongo.bofh.it>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 16, 2014 at 10:21 PM, Marco d'Itri <md@linux.it> wrote:
> On Feb 17, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> > Do you know if the upstream modprobe has the fixes (or plan) to
>> > recognize soft dependencies?  I was under the impression that it
>> > is the case.
>> Marco CC'd...
> I only maintain the Debian package, but Lucas should know.

The way the softdep is declared e.g. in crc32 pretty much broke the
concept of softdep that we had before: it was intended to pass
dependencies we should try to load, but not bail out if they failed.

For softdeps coming from kernel it means: "this is a dependency, but I
can't express it in terms of symbols, so consider XXXX the module I
depend on". The problem  is that depmod has no knowledge of softdeps,
only modprobe, which means the dependency loop check is done only
while loading a module, not while generating modules.dep.

I have a pending patch to make modprobe consider the softdep coming
from kernel, but I think it isn't ideal... I'll take a deeper look on
this issue this week.


Lucas De Marchi
