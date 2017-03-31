From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH] OF: mark released devices as no longer populated
Date: Fri, 31 Mar 2017 15:23:25 +0000
Message-ID: <VI1PR0401MB2591E5FD962023914F042C9B98370@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <E1bX3Pw-00088i-KU@rmk-PC.armlinux.org.uk>
 <CAL_Jsq+pDeL1_=p06ynrV4CK+h8-Yx_KDbH-W=d-aSdARe3ZHw@mail.gmail.com>
 <20170331103950.GA18376@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>
To: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Fabio Estevam <fabio.estevam-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 3/31/2017 1:40 PM, Russell King - ARM Linux wrote:=0A=
> Ping, this issue still exists with 4.11-rc4 - and there's been no=0A=
> reaction from the alleged CAAM maintainers.=0A=
> =0A=
Sorry, this somehow slipped through (Cc vs. To, no linux-crypto).=0A=
=0A=
> On Tue, Aug 09, 2016 at 11:48:38AM -0500, Rob Herring wrote:=0A=
>> On Tue, Aug 9, 2016 at 4:33 AM, Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org=
> wrote:=0A=
>>> When a Linux device is released and cleaned up, we left the OF device=
=0A=
>>> node marked as populated.  This causes the Freescale CAAM driver=0A=
>>> (drivers/crypto/caam) problems when the module is removed and re-=0A=
>>> inserted:=0A=
>>>=0A=
>>> JR0 Platform device creation error=0A=
>>> JR0 Platform device creation error=0A=
>>> caam 2100000.caam: no queues configured, terminating=0A=
>>> caam: probe of 2100000.caam failed with error -12=0A=
>>>=0A=
>>> The reason is that CAAM creates platform devices for each job ring:=0A=
>>>=0A=
>>>         for_each_available_child_of_node(nprop, np)=0A=
>>>                 if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring"=
) ||=0A=
>>>                     of_device_is_compatible(np, "fsl,sec4.0-job-ring"))=
 {=0A=
>>>                         ctrlpriv->jrpdev[ring] =3D=0A=
>>>                                 of_platform_device_create(np, NULL, dev=
);=0A=
>>>=0A=
>>> which sets OF_POPULATED on the device node, but then it cleans these=0A=
>>> up:=0A=
>>>=0A=
>>>         /* Remove platform devices for JobRs */=0A=
>>>         for (ring =3D 0; ring < ctrlpriv->total_jobrs; ring++) {=0A=
>>>                 if (ctrlpriv->jrpdev[ring])=0A=
>>>                         of_device_unregister(ctrlpriv->jrpdev[ring]);=
=0A=
>>=0A=
>> This looks a bit asymmetrical to me with a of_platform_device_* call=0A=
>> and a of_device_* call.=0A=
>>=0A=
>> I think you could use of_platform_{de}populate here instead. That=0A=
>> would simplify things in the driver a bit too as you wouldn't need to=0A=
>> store jrpdev. It wouldn't work if there are other child nodes with=0A=
Indeed, this would clean-up the driver a bit. However, the driver needs=0A=
to know how many of the devices probed successfully - to print the=0A=
number and more importantly to exit in case total_jobrs =3D 0.=0A=
=0A=
Thus, I would keep the one-by-one probing of the devices.=0A=
What options are there in this case?=0A=
Should a function symmetric to of_platform_device_create() be added - to=0A=
replace of_device_unregister() - or rely on an open-coded solution?=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
>> compatible strings which you don't want devices created.=0A=
>>=0A=
>>>         }=0A=
>>>=0A=
>>> which leaves OF_POPULATED set.=0A=
>>>=0A=
>>> Arrange for platform devices with a device node to clear the=0A=
>>> OF_POPULATED bit when they are released.=0A=
>>>=0A=
>>> Signed-off-by: Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>=0A=
>>> ---=0A=
>>> Please check this carefully - it may have issues where an of_node=0A=
>>> pointer is copied from one platform device to another, but IMHO=0A=
>>> doing that is itself buggy behaviour.=0A=
>>=0A=
>> Agreed, that is wrong.=0A=
>>=0A=
>>>=0A=
>>> Resending due to wrong list address, sorry.=0A=
>>>=0A=
>>>  include/linux/of_device.h | 1 +=0A=
>>>  1 file changed, 1 insertion(+)=0A=
>>>=0A=
>>> diff --git a/include/linux/of_device.h b/include/linux/of_device.h=0A=
>>> index cc7dd687a89d..7a8362d0c6d2 100644=0A=
>>> --- a/include/linux/of_device.h=0A=
>>> +++ b/include/linux/of_device.h=0A=
>>> @@ -43,6 +43,7 @@ extern int of_device_uevent_modalias(struct device *d=
ev, struct kobj_uevent_env=0A=
>>>=0A=
>>>  static inline void of_device_node_put(struct device *dev)=0A=
>>>  {=0A=
>>> +       of_node_clear_flag(dev->of_node, OF_POPULATED);=0A=
>>=0A=
>> This would result in clearing the flag twice in the=0A=
>> of_platform_populate/of_platform_depopulate case. It would do the same=
=0A=
>> for other bus types like i2c as well. That doesn't really hurt=0A=
>> anything that I can think of, but just not the best implementation. I=0A=
>> think adding a of_platform_device_unregister() call that wraps=0A=
>> of_platform_device_destroy would be more balanced.=0A=
>>=0A=
>> I looked thru all the callers of of_platform_device_create. The only=0A=
>> other ones affected by this are:=0A=
>>=0A=
>> drivers/macintosh/ams/ams-core.c=0A=
>> drivers/macintosh/therm_adt746x.c=0A=
>> drivers/macintosh/therm_windtunnel.c=0A=
>>=0A=
>> The others either have no remove path or a buggy remove path.=0A=
>>=0A=
>> Rob=0A=
> =0A=
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
