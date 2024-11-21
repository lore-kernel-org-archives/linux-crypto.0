Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C6C1D0E27
	for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2024 10:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732185883; cv=none; b=XqojhtsKi+/zVe7b6iEZjrsUVRtKbSxiwwLI80+QTbO1aFmz/ANGpb3M4IETvWJ0wHG4kbB31rpHQLJ2Qd5YkWSm7eITk5vJ20DUbELGjergPc4xaH78dxjWww2X7S+hZVFGE9+lk4ojFKChDt0R5Gy1NFtXwWVCj+zGnVBYZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732185883; c=relaxed/simple;
	bh=zTmWI0KmNoOKw6BQqMhF3Ls+TquqPpC5m9B1f8OOaxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvKfjWNqrZzTB6S3OFyvWX+L6OPfUqS0HULzn2vyE+lWmNYcrLlYTRqJbJ2DQ2ZA6wvLpQC2caSH4+XQHdbKUHuAlvxw6OheQJHBYNKdY/Oo/rZ9l0Q9j4WpE8c3SwhPST6Rtl9aa78pYPctAIorw2MPb9KO5qepOEbjbRFhrCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[IPV6:::1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1tE4fk-0004fj-E2; Thu, 21 Nov 2024 11:44:29 +0100
Message-ID: <54c5de0c-3c5f-4411-a345-a34852cf9112@pengutronix.de>
Date: Thu, 21 Nov 2024 11:44:17 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access page
 0 regs
To: Gaurav Jain <gaurav.jain@nxp.com>, Horia Geanta <horia.geanta@nxp.com>,
 Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Silvano Di Ninno <silvano.dininno@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
 Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
 Sahil Malhotra <sahil.malhotra@nxp.com>,
 Nikolaus Voss <nikolaus.voss@haag-streit.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20241111121020.4013077-1-gaurav.jain@nxp.com>
 <93e915b3-ef8e-4b98-aa7f-7759ae0b3091@pengutronix.de>
 <DB9PR04MB8409AC6672B7A209ABC8F9DAE7272@DB9PR04MB8409.eurprd04.prod.outlook.com>
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <DB9PR04MB8409AC6672B7A209ABC8F9DAE7272@DB9PR04MB8409.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

Hello Gaurav,

On 18.11.24 10:31, Gaurav Jain wrote:
>> -----Original Message-----
>> From: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> Sent: Monday, November 11, 2024 5:52 PM
>> To: Gaurav Jain <gaurav.jain@nxp.com>; Horia Geanta
>> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Herbert
>> Xu <herbert@gondor.apana.org.au>; David S . Miller
>> <davem@davemloft.net>; Silvano Di Ninno <silvano.dininno@nxp.com>;
>> Varun Sethi <V.Sethi@nxp.com>; Meenakshi Aggarwal
>> <meenakshi.aggarwal@nxp.com>; Sahil Malhotra
>> <sahil.malhotra@nxp.com>; Nikolaus Voss <nikolaus.voss@haag-streit.com>
>> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Pengutronix
>> Kernel Team <kernel@pengutronix.de>
>> Subject: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access page 0
>> regs
>>
>> Caution: This is an external email. Please take care when clicking links or
>> opening attachments. When in doubt, report the message using the 'Report
>> this email' button
>>
>>
>> Hello Guarav,
>>
>> Thanks for your patch.
>>
>> On 11.11.24 13:10, Gaurav Jain wrote:
>>> Access to controller region is not permitted.
>>
>> It's permitted on most of the older SoCs. Please mention on which SoCs this
>> is no longer true and which SoCs you tested your change on.
> Yes, it is permitted on iMX6/7/8M SoCs but not on iMX8DXL/QM/QXP/8ULP.

Ok, please add this to the commit message.

>>
>>> use JobR's register space to access page 0 registers.
>>>
>>> Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is
>>> insecure")
>>
>> Did the CAAM even support any of the SoCs, where this doesn't work
>> anymore back when the code was mainlined?
> Yes, for all SECO/ELE based SoCs, CAAM page 0 is not accessible from Non secure world.

Same, this information needs to be in the commit message.

>>
>>> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
>>> ---
>>>  drivers/crypto/caam/blob_gen.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/caam/blob_gen.c
>>> b/drivers/crypto/caam/blob_gen.c index 87781c1534ee..079a22cc9f02
>>> 100644
>>> --- a/drivers/crypto/caam/blob_gen.c
>>> +++ b/drivers/crypto/caam/blob_gen.c
>>> @@ -2,6 +2,7 @@
>>>  /*
>>>   * Copyright (C) 2015 Pengutronix, Steffen Trumtrar
>> <kernel@pengutronix.de>
>>>   * Copyright (C) 2021 Pengutronix, Ahmad Fatoum
>>> <kernel@pengutronix.de>
>>> + * Copyright 2024 NXP
>>>   */
>>>
>>>  #define pr_fmt(fmt) "caam blob_gen: " fmt @@ -104,7 +105,7 @@ int
>>> caam_process_blob(struct caam_blob_priv *priv,
>>>       }
>>>
>>>       ctrlpriv = dev_get_drvdata(jrdev->parent);
>>> -     moo = FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->ctrl-
>>> perfmon.status));
>>> +     moo = FIELD_GET(CSTA_MOO,
>>> + rd_reg32(&ctrlpriv->jr[0]->perfmon.status));
>>
>> I believe your change is correct, but I would prefer that ctrlpriv gets a
>> perfmon member that is initialized in caam_probe to either &ctrlpriv->ctrl-
>>> perfmon.status or &ctrlpriv->jr[0]->perfmon.status and then the code here
>> would just use &ctrlpriv->perfmon->status.
>>
>> This would simplify code not only here, but also in caam_ctrl_rng_init.
> As already communicated by Horia, a separate patch is good to cover this.

Are you interested in writing that separate patch?

Cheers,
Ahmad

> 
> Thanks
> Gaurav
>>
>> Thanks,
>> Ahmad
>>
>>
>>>       if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
>>>               dev_warn(jrdev,
>>>                        "using insecure test key, enable HAB to use
>>> unique device key!\n");
>>
>>
>> --
>> Pengutronix e.K.                           |                             |
>> Steuerwalder Str. 21                       |
>> https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.
>> pengutronix.de%2F&data=05%7C02%7Cgaurav.jain%40nxp.com%7C758768
>> 98a8044b366f4808dd024b7740%7C686ea1d3bc2b4c6fa92cd99c5c30163
>> 5%7C0%7C0%7C638669245367988594%7CUnknown%7CTWFpbGZsb3d8e
>> yJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIj
>> oiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=aaQ65iMsvuHn3q
>> 0bo5UU%2FYU7Fpyw3El7wNVHd%2BMNee0%3D&reserved=0  |
>> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
>> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
