From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix JR platform device subsequent
 (re)creations
Date: Wed, 5 Apr 2017 17:09:26 +0000
Message-ID: <VI1PR0401MB2591589307F6BA24DD98CB6E980A0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <CAL_JsqLHEycZLaxLZcAnDS4gp6D8xQDpgZXV1g3dokzF_EeQtQ@mail.gmail.com>
 <20170403151204.27488-1-horia.geanta@nxp.com>
 <20170405140834.GA27150@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Ruchika Gupta <ruchika.gupta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0051.outbound.protection.outlook.com ([104.47.2.51]:23184
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932856AbdDERJb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 13:09:31 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/5/2017 5:14 PM, Herbert Xu wrote:=0A=
> On Mon, Apr 03, 2017 at 06:12:04PM +0300, Horia Geant=E3 wrote:=0A=
>> The way Job Ring platform devices are created and released does not=0A=
>> allow for multiple create-release cycles.=0A=
>>=0A=
>> JR0 Platform device creation error=0A=
>> JR0 Platform device creation error=0A=
>> caam 2100000.caam: no queues configured, terminating=0A=
>> caam: probe of 2100000.caam failed with error -12=0A=
>>=0A=
>> The reason is that platform devices are created for each job ring:=0A=
>>=0A=
>>         for_each_available_child_of_node(nprop, np)=0A=
>>                 if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring")=
 ||=0A=
>>                     of_device_is_compatible(np, "fsl,sec4.0-job-ring")) =
{=0A=
>>                         ctrlpriv->jrpdev[ring] =3D=0A=
>>                                 of_platform_device_create(np, NULL, dev)=
;=0A=
>>=0A=
>> which sets OF_POPULATED on the device node, but then it cleans these up:=
=0A=
>>=0A=
>>         /* Remove platform devices for JobRs */=0A=
>>         for (ring =3D 0; ring < ctrlpriv->total_jobrs; ring++) {=0A=
>>                 if (ctrlpriv->jrpdev[ring])=0A=
>>                         of_device_unregister(ctrlpriv->jrpdev[ring]);=0A=
>>         }=0A=
>>=0A=
>> which leaves OF_POPULATED set.=0A=
>>=0A=
>> Use of_platform_populate / of_platform_depopulate instead.=0A=
>> This allows for a bit of driver clean-up, jrpdev is no longer needed.=0A=
>>=0A=
>> Logic changes a bit too:=0A=
>> -exit in case of_platform_populate fails, since currently even QI backen=
d=0A=
>> depends on JR; true, we no longer support the case when "some" of the JR=
=0A=
>> DT nodes are incorrect=0A=
>> -when cleaning up, caam_remove() would also depopulate RTIC in case=0A=
>> it would have been populated somewhere else - not the case for now=0A=
>>=0A=
>> Fixes: 313ea293e9c4d ("crypto: caam - Add Platform driver for Job Ring")=
=0A=
>> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
>> Suggested-by: Rob Herring <robh+dt@kernel.org>=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> ---=0A=
>> Not sending this directly to -stable, since it does not apply cleanly.=
=0A=
> =0A=
> Patch applied.  I forced it to apply on the crypto tree, then merged=0A=
> it forward to cryptodev.  Please check the end result and let me know=0A=
> if it's wrong.=0A=
> =0A=
Looks fine.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
