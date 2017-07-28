From: Matt Corallo <linux@bluematt.me>
Subject: Re: KPP API and Temporary Keys
Date: Fri, 28 Jul 2017 16:24:33 -0400
Message-ID: <3042887c-6663-2246-55d7-0298ca7993c3@bluematt.me>
References: <315eea31-1548-e61d-e355-a523dbcefb7f@bluematt.me>
 <8680768.s9vD93Vl1j@tauon.chronox.de>
 <9394e0ca-b45b-1a87-e638-0e3d76e3cd22@bluematt.me>
 <CAJU8_nWGZOtc_6uprittEQQ855T7pGsHNdF7kwPtojeEqmKs-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: Kyle Rose <krose@krose.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.bluematt.me ([192.241.179.72]:41338 "EHLO mail.bluematt.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752660AbdG1UZH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 16:25:07 -0400
In-Reply-To: <CAJU8_nWGZOtc_6uprittEQQ855T7pGsHNdF7kwPtojeEqmKs-A@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hmm, fair, I hadn't considered the desire to pre-cache keys with the
rest, in which case I suppose the existing API is likely about as good
as you'd need (+/- duplicative extra tfm overhead, which annoys me, but
likely isn't actually worth worrying about). I'll retract my criticism
until I've written a full "worker" cache and see what it looks like.

Matt

On 07/28/17 16:20, Kyle Rose wrote:
> On Fri, Jul 28, 2017 at 4:00 PM, Matt Corallo <linux@bluematt.me> wrote:
>>
>> Even worse, when I'm looking at tcpcrypt, not adding undue complication,
>> or, really, overhead, is a pretty important goal for something in the
>> tcp stack (especially for someone who doesn't know the TCP stack, and
>> avoiding complexity is a good target for avoiding breaking things), and
>> while a pool of "workers" should work fine, spending time optimizing
>> that to ensure it properly frees workers if load decreases (or memory
>> load increases) while avoiding hitting the slowpath all the time strikes
>> me as non-ideal complexity.
> 
> For performance reasons, we're probably going to want to go the route
> of generating one ECDH share every N seconds for small N, since
> computing the public share for a randomly-selected point requires an
> EC point multiplication that you don't necessarily want to do on every
> connection. (You already have to do one per connection for the actual
> key agreement; better to avoid doing two.) Every few seconds isn't
> long-term, but it does mean that a pool has somewhat different
> implications as keys can be shared between them, assuming they're
> const. You could refcount them, always use the newest one when a
> connection is opened, and then throw away old ones when the refcount
> hits zero.
> 
> Kyle
> 
