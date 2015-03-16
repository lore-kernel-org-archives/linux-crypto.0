From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 4/4] crypto: talitos - add software backlog queue handling
Date: Mon, 16 Mar 2015 08:58:08 -0400
Message-ID: <CAJUS3Xk=_9kZsLS0CvQ-kbZwdiux8+w6P2x4PbJ4pS66GMgTSw@mail.gmail.com>
References: <1426266882-31626-1-git-send-email-horia.geanta@freescale.com>
	<1426266984-31823-1-git-send-email-horia.geanta@freescale.com>
	<55032E6F.4010700@amd.com>
	<55046CD3.5000500@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@freescale.com>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33854 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbbCPM6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2015 08:58:09 -0400
Received: by iecsl2 with SMTP id sl2so168821760iec.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2015 05:58:08 -0700 (PDT)
In-Reply-To: <55046CD3.5000500@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Mar 14, 2015 at 1:16 PM, Horia Geant=C4=83
<horia.geanta@freescale.com> wrote:
> On 3/13/2015 8:37 PM, Tom Lendacky wrote:
>>> +
>>> +            /* Try to backlog request (if allowed) */
>>> +            return crypto_enqueue_request(&priv->chan[ch].queue, a=
req);
>>
>> I'd remembered something about how hardware drivers should use their
>> own list element for queuing, searched back and found this:
>>
>> http://marc.info/?l=3Dlinux-crypto-vger&m=3D137609769605139&w=3D2
>
> The crypto_async_request "list" field is used only for queuing using =
the
> crypto API functions - crypto_{enqueue,dequeue}_request.
>
> I am not sure I understand what is the problem.
> Are crypto_{enqueue,dequeue}_request part of *internal* crypto API?

I don't believe that the enqueue/dequeue functions are internal API.
I based my code on the usage of other hardware offload drivers.  Their
use is somewhat different because most of the other hardware can only
handle a single request at a time.

mh

--=20
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296
