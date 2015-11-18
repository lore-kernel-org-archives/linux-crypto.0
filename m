From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: A new, fast and "unbreakable" encryption algorithm
Date: Wed, 18 Nov 2015 14:31:23 -0500
Message-ID: <CACXcFmkefuSVyk1vrFQ12c9UdyN1zBqqtz-2MpdKcs4hS15d7A@mail.gmail.com>
References: <CAFJyfaOpgXj7pJfGA5jf7-95VfgC+-yZu4t6_6OGRvx_OtuzuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ismail Kizir <ikizir@gmail.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34872 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbbKRTbY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 14:31:24 -0500
Received: by ioc74 with SMTP id 74so64806962ioc.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2015 11:31:24 -0800 (PST)
In-Reply-To: <CAFJyfaOpgXj7pJfGA5jf7-95VfgC+-yZu4t6_6OGRvx_OtuzuQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 18, 2015 at 12:10 AM, Ismail Kizir <ikizir@gmail.com> wrote:

> I've developed a new encryption algorithm, which dynamically changes
> the key according to plaintext and practically impossible to break.

There is a very long history of crypto whose author considers is
secure being quickly broken. This happens to nearly all methods
devised by amateurs and quite a few from professionals.

Despite that, amateurs like me & (I presume) you keep trying.
This is probably a good thing. Here's one of mine:
https://aezoo.compute.dtu.dk/doku.php?id=enchilada

> I also opened to public with MIT&GPL dual License.

This is excellent. Many people make claims for their
algorithm without publishing details, which is ludicrous
since no-one can analyze it without those details. You
have avoided that pitfall.

> I will present a paper on a Turkish National Inet-tr 2015 Symposium

A paper describing the design would make analysis
much easier than doing it from source code, and
like every other algorithm yours will need lots of
analysis before it might become sensible for
people to trust it.

I suggest you subscribe to the crypto list:
http://www.metzdowd.com/mailman/listinfo/cryptography

Once your paper is published, post a link there
to invite analysis.
