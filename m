From: Kyle Rose <krose@krose.org>
Subject: Re: KPP API and Temporary Keys
Date: Fri, 28 Jul 2017 16:20:07 -0400
Message-ID: <CAJU8_nWGZOtc_6uprittEQQ855T7pGsHNdF7kwPtojeEqmKs-A@mail.gmail.com>
References: <315eea31-1548-e61d-e355-a523dbcefb7f@bluematt.me>
 <8680768.s9vD93Vl1j@tauon.chronox.de> <9394e0ca-b45b-1a87-e638-0e3d76e3cd22@bluematt.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: Matt Corallo <linux@bluematt.me>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:38634 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752505AbdG1UUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 16:20:08 -0400
Received: by mail-qk0-f175.google.com with SMTP id x191so58256561qka.5
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jul 2017 13:20:08 -0700 (PDT)
In-Reply-To: <9394e0ca-b45b-1a87-e638-0e3d76e3cd22@bluematt.me>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 28, 2017 at 4:00 PM, Matt Corallo <linux@bluematt.me> wrote:
>
> Even worse, when I'm looking at tcpcrypt, not adding undue complication,
> or, really, overhead, is a pretty important goal for something in the
> tcp stack (especially for someone who doesn't know the TCP stack, and
> avoiding complexity is a good target for avoiding breaking things), and
> while a pool of "workers" should work fine, spending time optimizing
> that to ensure it properly frees workers if load decreases (or memory
> load increases) while avoiding hitting the slowpath all the time strikes
> me as non-ideal complexity.

For performance reasons, we're probably going to want to go the route
of generating one ECDH share every N seconds for small N, since
computing the public share for a randomly-selected point requires an
EC point multiplication that you don't necessarily want to do on every
connection. (You already have to do one per connection for the actual
key agreement; better to avoid doing two.) Every few seconds isn't
long-term, but it does mean that a pool has somewhat different
implications as keys can be shared between them, assuming they're
const. You could refcount them, always use the newest one when a
connection is opened, and then throw away old ones when the refcount
hits zero.

Kyle
