From: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] OF: mark released devices as no longer populated
Date: Fri, 31 Mar 2017 11:59:50 -0500
Message-ID: <CAL_JsqLHEycZLaxLZcAnDS4gp6D8xQDpgZXV1g3dokzF_EeQtQ@mail.gmail.com>
References: <E1bX3Pw-00088i-KU@rmk-PC.armlinux.org.uk> <CAL_Jsq+pDeL1_=p06ynrV4CK+h8-Yx_KDbH-W=d-aSdARe3ZHw@mail.gmail.com>
 <20170331103950.GA18376@n2100.armlinux.org.uk> <VI1PR0401MB2591E5FD962023914F042C9B98370@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Fabio Estevam <fabio.estevam-3arQi8VN3Tc@public.gmane.org>,
        Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0401MB2591E5FD962023914F042C9B98370-9IDQY6o3qQhGNIhRVge97I3W/0Ik+aLCnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 31, 2017 at 10:23 AM, Horia Geantă <horia.geanta-3arQi8VN3Tc@public.gmane.org> wrote:
> On 3/31/2017 1:40 PM, Russell King - ARM Linux wrote:
>> Ping, this issue still exists with 4.11-rc4 - and there's been no
>> reaction from the alleged CAAM maintainers.
>>
> Sorry, this somehow slipped through (Cc vs. To, no linux-crypto).
>
>> On Tue, Aug 09, 2016 at 11:48:38AM -0500, Rob Herring wrote:
>>> On Tue, Aug 9, 2016 at 4:33 AM, Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org> wrote:
>>>> When a Linux device is released and cleaned up, we left the OF device
>>>> node marked as populated.  This causes the Freescale CAAM driver
>>>> (drivers/crypto/caam) problems when the module is removed and re-
>>>> inserted:
>>>>
>>>> JR0 Platform device creation error
>>>> JR0 Platform device creation error
>>>> caam 2100000.caam: no queues configured, terminating
>>>> caam: probe of 2100000.caam failed with error -12
>>>>
>>>> The reason is that CAAM creates platform devices for each job ring:
>>>>
>>>>         for_each_available_child_of_node(nprop, np)
>>>>                 if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
>>>>                     of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
>>>>                         ctrlpriv->jrpdev[ring] =
>>>>                                 of_platform_device_create(np, NULL, dev);
>>>>
>>>> which sets OF_POPULATED on the device node, but then it cleans these
>>>> up:
>>>>
>>>>         /* Remove platform devices for JobRs */
>>>>         for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
>>>>                 if (ctrlpriv->jrpdev[ring])
>>>>                         of_device_unregister(ctrlpriv->jrpdev[ring]);
>>>
>>> This looks a bit asymmetrical to me with a of_platform_device_* call
>>> and a of_device_* call.
>>>
>>> I think you could use of_platform_{de}populate here instead. That
>>> would simplify things in the driver a bit too as you wouldn't need to
>>> store jrpdev. It wouldn't work if there are other child nodes with
> Indeed, this would clean-up the driver a bit. However, the driver needs
> to know how many of the devices probed successfully - to print the
> number and more importantly to exit in case total_jobrs = 0.

The only thing you are guaranteed is the OF code created some platform
devices. That's it. Whether any driver probed successfully is separate
and a lot more things can go wrong there. The only thing you are
checking is that your dtb is not crap.

> Thus, I would keep the one-by-one probing of the devices.
> What options are there in this case?
> Should a function symmetric to of_platform_device_create() be added - to
> replace of_device_unregister() - or rely on an open-coded solution?

Certainly not the latter. We don't want drivers mucking with flags
internal to the DT code.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
