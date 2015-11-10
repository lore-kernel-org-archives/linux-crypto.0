From: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 12/13] [media] omap3isp: Support for deferred probing when
 requesting DMA channel
Date: Tue, 10 Nov 2015 09:56:17 +0200
Message-ID: <5641A321.2070209@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-13-git-send-email-peter.ujfalusi@ti.com>
 <11319647.puY9n5DpsR@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
	<devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>,
	Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <11319647.puY9n5DpsR@avalon>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Laurent,

On 11/09/2015 09:50 PM, Laurent Pinchart wrote:
> Hi Peter,
>=20
> Thank you for the patch.
>=20
> What happened to this patch series ? It looks like=20
> dma_request_slave_channel_compat_reason() isn't in mainline, so I can=
't apply=20
> this patch.
>=20
> I'll mark this patch as deferred in patchwork, please resubmit it if =
you=20
> resubmit the series

The original series - containing this patch - generated a bit of discus=
sion
and it seams that I will need to do bigger change in the dmaengine API
compared to this.
I think this patch can be dropped as the dmaengine changes will not go =
in as
they were.

(and by the look of it the issue you're trying to fix
> still exists, so it would be nice if you could get it eventually fixe=
d).

Yes, the issue still valid for the OMAP/DaVinci driver the series was t=
ouching.

I will try to send a new series in the coming weeks.

Thanks,
P=E9ter
>=20
> On Tuesday 26 May 2015 16:26:07 Peter Ujfalusi wrote:
>> Switch to use ma_request_slave_channel_compat_reason() to request th=
e DMA
>> channel. Only fall back to pio mode if the error code returned is no=
t
>> -EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFE=
R.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
>> CC: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
>> CC: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  drivers/media/platform/omap3isp/isphist.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/isphist.c
>> b/drivers/media/platform/omap3isp/isphist.c index
>> 7138b043a4aa..e690ca13af0e 100644
>> --- a/drivers/media/platform/omap3isp/isphist.c
>> +++ b/drivers/media/platform/omap3isp/isphist.c
>> @@ -499,14 +499,20 @@ int omap3isp_hist_init(struct isp_device *isp)
>>  		if (res)
>>  			sig =3D res->start;
>>
>> -		hist->dma_ch =3D dma_request_slave_channel_compat(mask,
>> +		hist->dma_ch =3D dma_request_slave_channel_compat_reason(mask,
>>  				omap_dma_filter_fn, &sig, isp->dev, "hist");
>> -		if (!hist->dma_ch)
>> +		if (IS_ERR(hist->dma_ch)) {
>> +			ret =3D PTR_ERR(hist->dma_ch);
>> +			if (ret =3D=3D -EPROBE_DEFER)
>> +				return ret;
>> +
>> +			hist->dma_ch =3D NULL;
>>  			dev_warn(isp->dev,
>>  				 "hist: DMA channel request failed, using PIO\n");
>> -		else
>> +		} else {
>>  			dev_dbg(isp->dev, "hist: using DMA channel %s\n",
>>  				dma_chan_name(hist->dma_ch));
>> +		}
>>  	}
>>
>>  	hist->ops =3D &hist_ops;
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
