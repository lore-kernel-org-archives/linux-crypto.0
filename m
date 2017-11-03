From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Fwd: virtio:rng: Virtio RNG devices need to be re-registered after suspend/resume
Date: Fri, 3 Nov 2017 20:55:35 +0530
Message-ID: <CANc+2y7MjX4WKagAiUGz2NA2w-p8NkF4CXMOOEtTW8PdpsHj6A@mail.gmail.com>
References: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
 <CANc+2y7jg67sT9GdxEA4NXA+xCFpLNHUVAJbrGs8p0bC77JJOQ@mail.gmail.com>
 <a8cc4bc4-abb5-b9ba-018f-bee985b09117@oracle.com> <CANc+2y4cEAHudxdK6Y0TbskGMH6jpLg0cfWt77JR44fzYU94HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Jim Quigley <Jim.Quigley@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:47824 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdKCPZh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 11:25:37 -0400
Received: by mail-io0-f195.google.com with SMTP id h70so7039940ioi.4
        for <linux-crypto@vger.kernel.org>; Fri, 03 Nov 2017 08:25:36 -0700 (PDT)
In-Reply-To: <CANc+2y4cEAHudxdK6Y0TbskGMH6jpLg0cfWt77JR44fzYU94HA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Did reply instead of reply all. Forwarding my previous message.

---------- Forwarded message ----------
From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date: 3 November 2017 at 20:19
Subject: Re: virtio:rng: Virtio RNG devices need to be re-registered
after suspend/resume
To: Jim Quigley <jim.quigley@oracle.com>


Hi Jim,

On 3 November 2017 at 20:11, Jim Quigley <jim.quigley@oracle.com> wrote:
>
>
> On 03/11/2017 13:06, PrasannaKumar Muralidharan wrote:
>>
>> Hi Jim,
>>
>> On 3 November 2017 at 15:27, Jim Quigley <Jim.Quigley@oracle.com> wrote:
>>>
>>> The patch for
>>>
>>> commit: 5c06273401f2eb7b290cadbae18ee00f8f65e893
>>> Author: Amit Shah <amit.shah@redhat.com>
>>> Date:   Sun Jul 27 07:34:01 2014 +0930
>>>
>>>      virtio: rng: delay hwrng_register() till driver is ready
>>>
>>> moved the call to hwrng_register() out of the probe routine into the scan
>>> routine. We need to call hwrng_register() after a suspend/restore cycle
>>> to re-register the device, but the scan function is not invoked for the
>>> restore. Add the call to hwrng_register() to virtio_restore().
>>>
>>> Reviewed-by: Liam Merwick <Liam.Merwick@oracle.com>
>>> Signed-off-by: Jim Quigley <Jim.Quigley@oracle.com>
>>> ---
>>>   drivers/char/hw_random/virtio-rng.c | 21 ++++++++++++++++++++-
>>>   1 file changed, 20 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/char/hw_random/virtio-rng.c
>>> b/drivers/char/hw_random/virtio-rng.c
>>> index 3fa2f8a..b89df66 100644
>>> --- a/drivers/char/hw_random/virtio-rng.c
>>> +++ b/drivers/char/hw_random/virtio-rng.c
>>> @@ -184,7 +184,26 @@ static int virtrng_freeze(struct virtio_device
>>> *vdev)
>>>
>>>   static int virtrng_restore(struct virtio_device *vdev)
>>>   {
>>> -       return probe_common(vdev);
>>> +       int err;
>>> +
>>> +       err = probe_common(vdev);
>>> +       if (!err) {
>>> +               struct virtrng_info *vi = vdev->priv;
>>> +
>>> +               /*
>>> +                * Set hwrng_removed to ensure that virtio_read()
>>> +                * does not block waiting for data before the
>>> +                * registration is complete.
>>> +                */
>>> +               vi->hwrng_removed = true;
>>> +               err = hwrng_register(&vi->hwrng);
>>> +               if (!err) {
>>> +                       vi->hwrng_register_done = true;
>>> +                       vi->hwrng_removed = false;
>>> +               }
>>> +       }
>>> +
>>> +       return err;
>>>   }
>>>   #endif
>>>
>>> --
>>> 1.8.3.1
>>>
>> This patch makes me wonder why hwrng_unregister is required in
>> virtrng_freeze. Looks strange and unusual. May be that is not required
>> and it can be removed. If it is required can you please add a comment
>> on why it is required?
>
>
>     The reason it's required is because the virtrng_restore() uses
> probe_common() which allocates
>     a new virtrng_info struct, changing  the devices private pointer . This
> virtrng struct is used in
>     hwrng_register() to set the current RNG etc.  If we don't
> unregister/re-register then we would
>     need to split probe_common() to avoid
>
>                     vi = kzalloc(sizeof(struct virtrng_info), GFP_KERNEL);
>
>     overwriting vdev->priv on a restore.

True. As restore uses probe_common calling hwrng_register is required.

But I think it is not correct way to do.

>
>     It would be cleaner to just get rid of probe_common() altogether in that
> case, and do whatever
>     needs to be done in virtrng_probe()/virtrng_restore() respectively, but

That's correct.

> I didn't want to change code
>     affecting the normal probe path as well as suspend/resume. Is it OK to
> leave it that way to avoid
>     the more extensive changes ?

Personally I would prefer to do the cleaner way. It is up to the
virtio and hwrng maintainer.

Regards,
PrasannaKumar
