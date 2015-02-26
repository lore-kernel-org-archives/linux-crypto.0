From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 5/5] crypto: talitos: Add software backlog queue handling
Date: Thu, 26 Feb 2015 14:22:38 -0500
Message-ID: <CAJUS3X=jFNi9yoKkrHtMxir5DfLaWoCqAoVfj2a7-wHo-29woA@mail.gmail.com>
References: <1424449276-5288-1-git-send-email-mort@bork.org>
	<1424449276-5288-6-git-send-email-mort@bork.org>
	<54ECC140.9090100@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44963 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbbBZTWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2015 14:22:39 -0500
Received: by iecar1 with SMTP id ar1so19768648iec.11
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2015 11:22:38 -0800 (PST)
In-Reply-To: <54ECC140.9090100@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Horia,

On Tue, Feb 24, 2015 at 1:21 PM, Horia Geant=C4=83
<horia.geanta@freescale.com> wrote:
> On 2/20/2015 6:21 PM, Martin Hicks wrote:
>> +     int ret =3D -EINPROGRESS;
>>
>>       spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
>>
>> +     if (edesc) {
>> +             orig_request =3D &edesc->req;
>> +             crypto_enqueue_request(&priv->chan[ch].queue, &orig_re=
quest->base);
>> +     }
>
> The request goes through the SW queue even if there are empty slots i=
n
> the HW queue, doing unnecessary crypto_queue_encrypt() and
> crypto_queue_decrypt(). Trying to use the HW queue first would be bet=
ter.
>

Definitely a valid point.  In trying to reorganize this it really
complicates things.
Splitting the submit from issuing requests from the backlog seems to
make it much more straightforward.

>> @@ -1170,6 +1211,8 @@ static struct talitos_edesc *talitos_edesc_all=
oc(struct device *dev,
>>                                                    edesc->dma_len,
>>                                                    DMA_BIDIRECTIONAL=
);
>>       edesc->req.desc =3D &edesc->desc;
>> +     /* A copy of the crypto_async_request to use the crypto_queue =
backlog */
>> +     memcpy(&edesc->req.base, areq, sizeof(struct crypto_async_requ=
est));
>
> Why not have a
> struct crypto_async_request *base;
> instead of
> struct crypto_async_request base;
> in talitos_request structure?
>
> This way:
> 1. memcopy above is avoided
> 2. talitos_request structure gets smaller - remember that
> talitos_request is now embedded in talitos_edesc structure, which get=
s
> kmalloc-ed for every request

The trouble I ran into was that after a request is backlogged and put
on the crypto queue, I couldn't see how else I could go from the
crypto_async_request that is pulled from the queue back to the
talitos_request that is needed in order put the pointer into the
hardware FIFO.

This is the one issue from you review that I didn't address in v2 of th=
e patch.

Thanks for the review.  Not releasing / re-acquiring the spinlock
while trying to flush the backlog really improved performance.

mh

--=20
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296
