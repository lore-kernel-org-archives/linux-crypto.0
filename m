From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 03/13] serial: 8250_dma: Support for deferred probing
 when requesting DMA channels
Date: Wed, 27 May 2015 13:58:25 +0300
Message-ID: <5565A351.7020409@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com> <20150526150852.GC16525@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <vinod.koul@intel.com>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dan.j.williams@intel.com>,
	<dmaengine@vger.kernel.org>, <linux-serial@vger.kernel.org>,
	<linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-spi@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <alsa-devel@alsa-project.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59523 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbbE0K6g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 06:58:36 -0400
In-Reply-To: <20150526150852.GC16525@atomide.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/26/2015 06:08 PM, Tony Lindgren wrote:
> * Peter Ujfalusi <peter.ujfalusi@ti.com> [150526 06:28]:
>> Switch to use ma_request_slave_channel_compat_reason() to request th=
e DMA
>> channels. In case of error, return the error code we received includ=
ing
>> -EPROBE_DEFER
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/tty/serial/8250/8250_dma.c | 18 ++++++++----------
>>  1 file changed, 8 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial=
/8250/8250_dma.c
>> index 21d01a491405..a617eca4e97d 100644
>> --- a/drivers/tty/serial/8250/8250_dma.c
>> +++ b/drivers/tty/serial/8250/8250_dma.c
>> @@ -182,21 +182,19 @@ int serial8250_request_dma(struct uart_8250_po=
rt *p)
>>  	dma_cap_set(DMA_SLAVE, mask);
>> =20
>>  	/* Get a channel for RX */
>> -	dma->rxchan =3D dma_request_slave_channel_compat(mask,
>> -						       dma->fn, dma->rx_param,
>> -						       p->port.dev, "rx");
>> -	if (!dma->rxchan)
>> -		return -ENODEV;
>> +	dma->rxchan =3D dma_request_slave_channel_compat_reason(mask, dma-=
>fn,
>> +					dma->rx_param, p->port.dev, "rx");
>> +	if (IS_ERR(dma->rxchan))
>> +		return PTR_ERR(dma->rxchan);
>> =20
>>  	dmaengine_slave_config(dma->rxchan, &dma->rxconf);
>> =20
>>  	/* Get a channel for TX */
>> -	dma->txchan =3D dma_request_slave_channel_compat(mask,
>> -						       dma->fn, dma->tx_param,
>> -						       p->port.dev, "tx");
>> -	if (!dma->txchan) {
>> +	dma->txchan =3D dma_request_slave_channel_compat_reason(mask, dma-=
>fn,
>> +					dma->tx_param, p->port.dev, "tx");
>> +	if (IS_ERR(dma->txchan)) {
>>  		dma_release_channel(dma->rxchan);
>> -		return -ENODEV;
>> +		return PTR_ERR(dma->txchan);
>>  	}
>> =20
>>  	dmaengine_slave_config(dma->txchan, &dma->txconf);
>=20
> In general the drivers need to work just fine also without DMA.
>=20
> Does this handle the case properly where no DMA channel is configured
> for the driver in the dts file?

The 8250 core will fall back to PIO mode if the DMA can not be requeste=
d.
At the morning I was looking at the 8250 stack and realized that
serial8250_request_dma() will not be called at driver probe time so thi=
s patch
can be ignored and will be dropped from the v2 series.

--=20
P=E9ter
