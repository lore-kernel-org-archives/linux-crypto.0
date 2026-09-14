Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013008.outbound.protection.outlook.com [40.107.159.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD3B367B8E;
	Mon, 14 Sep 2026 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789402874; cv=fail; b=Fh31tbNEA3LMWDaNaiSRujeukaEIzyY4rr5vXOgpfx3s6tsrGGwp1jgUcStaSfxHpaS0wGwC340+M3AQoLjBQJPcJcDwv4VzwUP3Rdibk1AmTIOt2CUDFZeLhItVgdlgY2TNg0SgXi88j0mIaNYwwFhJPffO7jj3IyonHTOFzJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789402874; c=relaxed/simple;
	bh=V0SUQgnm2BgWi+X5ejMvdfVvob4yznuIob/bxHjG9E0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BUFwFKSk/wkaFMtnDm6vHSID5lFZUm81LMT6ui68lr+SVgOinQOX7kNb/KHJQvdj5Y849Znr+65XSGbtA7YGp+fC8+dmYPy7JpIPolITFTcjXGYGaFu/R4lQz8Yt2AhCzFS5HvyHvji9QGSgncaVbmcx7SU7Iste+kPvVW9PA3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=U+c/4IDA; arc=fail smtp.client-ip=40.107.159.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="U+c/4IDA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gAfLVIhTsmExYwSr99Ranu6uC7U6Vvz6f5mMhhBMqmplfjrspgojW4xToDQ40gm2qsFdVM3Gj4a3rEnCwW+qVDnevV5SoGlIaBKypSaPVJ5Al9L9L8N5jR/5uCJXqCoqzpphCPqfPrsCInuUWGwtBHsXGE2JSlzNLhle2XZajGCQVguOy2UzIX4UM77GdR8VMhLmWFsgzYm9R8nCaG7mLAbkgp/xHosHFJty71knncl4PjTLxDOKxIIJ0JYxp4aEALjYmDpBr1yYNONFsQiVwJwEXE0v4s5vByQ6573TR0ZC4WPGsDb05qoouq7/247u0heSGQEI8diVIxPU3k8C7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zmq5FrwAqWt6q4RgIIUKkG/uJl5bU1qWzcJFaLLE5mY=;
 b=HphVtsZFgeGapUIblr0auNlscQKV4D8m2SGa9tE1yG6cUp3fSHyK+xP7IcPJI49KSdhWhyoZDHJRtqjCxXEJkpMomrPOhXzjYEWrewdh+pjKlam1IsX6YqUtMLi0FCK0UMdi3/7lH5x86x/ZHA5P+2RSUl51jZIwCqhHdYWYRUrQJBpo2duRppRgYy3Nhf1o3xsc23uYW6HPSD9lxDT0/9nJfD8krmC4oxiYRgZuhNUbeT8jke8ff2PtL/ZxHPnNpPD9MxXajGu4UAYDT3+KLsfKfDoB0HDcupG4VJWONSptYlHHnG+SNIGq5hQW69++lAvhC6IY7lHOJWpBuJAgXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zmq5FrwAqWt6q4RgIIUKkG/uJl5bU1qWzcJFaLLE5mY=;
 b=U+c/4IDApuv3n5iFbPyV+LhI39RyQ1ekkPwPGOFzwoeFh2UkRWw4m1JGEycjx8gR1l+f1pDfzN1Kn5gRJqVd2gAegEUvZv0K3xgjmTZpeIrx6II0weTo2fPzu62ZijPYsQk8Ko08B9bIXM5wKCgAAt8HcgB3bew4AYch4QVJwg+dzyCbhQjX+h5AJhosy3f6QwyZOef02Wo6Iuhlv7vVJNzfxIf8wKIH2PiUVFBoHc6ronxZZkm4rgAe5/3G8IrFalmqsWMyftbtrl64no3dMKVgLyF2NxeHO2Fw4E9foET4laTViS4s9ohnNHTx+l8IeolUdH6c/RRVIGkDf/Ww6w==
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com (2603:10a6:10:248::17)
 by PA4PR04MB9269.eurprd04.prod.outlook.com (2603:10a6:102:2a4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 16:21:08 +0000
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43]) by DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 16:21:08 +0000
From: Sahil Malhotra <sahil.malhotra@nxp.com>
To: Rosen Penev <rosenp@gmail.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
CC: Horia Geanta <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] crypto: caam: map job ring registers without
 claiming region
Thread-Topic: [EXT] [PATCH] crypto: caam: map job ring registers without
 claiming region
Thread-Index: AQHdOlHBxOyB/olM2USbN8iaAfsVmLbODS0g
Date: Mon, 14 Sep 2026 16:21:08 +0000
Message-ID:
 <DB9PR04MB8139BF843778E6EAFC836D6282BB2@DB9PR04MB8139.eurprd04.prod.outlook.com>
References: <20260901203736.13248-1-rosenp@gmail.com>
In-Reply-To: <20260901203736.13248-1-rosenp@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-09-14T12:02:26.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8139:EE_|PA4PR04MB9269:EE_
x-ms-office365-filtering-correlation-id: 48da256b-f1b6-487e-27dd-08df127c2f39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|19092799006|376014|6049299003|10067099003|18002099003|22082099003|56012099006|11063799006|4053099003|38070700021;
x-microsoft-antispam-message-info:
 KHeHjnvXG0jzcJ0/rSsNCoetGivzWTQ+Zo8rPENHIsaYRQOWYtQluzMYqeMygRbRl8e3BYkD5SuUJvXTtfe5fEfPV5LEd7YnjMzS8Z7PFvu2BT3rmvGSrGhyABklAFo2EBDVgm9o2VR+JO0Ews+PUiEresolTJWMmQ/Ta0K/oNYzIImwq85CxPANZQq7pK0RoMXtaRDDgn+7186JZdE3ZELwYOV5gUaj147ounyAWw+f528/feJ4GlDE/gI5Z8++s5TN+SrI5kSkIER6lkncd3ak6dJZnRXfPQJuvwi6gRZvhebpiQrA1/rsgO1eThM2IaS+REawViK3SaoeQ3pedo0DvvqQCOREFMKO5z4fcG2N/WKcUnnMDx9yr/JbVk/trKyVgHIM4r+CWpP+mSwIo9Fba/SeMsB5ddnRqQgjHEsg66znToNvJbc3z97+Qt28lwGaJS9sG/DiinsBli5ZfFwdx2vdqDo/8XcPz9iwLNOjNVnh5v5VhgG3fkBaQYOTlTlZqg63KVTbnDFYfuUxrndImUeE9RZciipRZoi6IjRdM4vUhxX+GwwkxnS+CavGoSU1PvvZ97vYKQeR1rOVth+8kI4txe5u8NDn8EQ+VQV4979ZCKOkSMf3FYTblgcPxWNMlDT/QkvuV75lhTo2sa23dPo4D3FijzGvf0rLfIjYusDYYl/T0TTljTmZ3nYg+wTAM2YlkFmVuzv3mBgRSb/kjB0Q48Db4UUogt9URUI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(19092799006)(376014)(6049299003)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006)(4053099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?MmLTRxDLvz7KzvXFlXLQfTTide8getKdBIk4oI4ml3MNCORLZalMeir4S/aG?=
 =?us-ascii?Q?cC8Wqy/4VUPF59BcneZZSvI1AVe43V6BqVh7dANQcZeJ8/kJpIZ56OSapS2E?=
 =?us-ascii?Q?+kqpZi3xDZlUWreXmwmezyZr7QtWDoZLTfRFSbX2pbCEm9VjT/1WEVbFcOnA?=
 =?us-ascii?Q?q1ZsRg81McCutz+l3drRTXUR6c6dl1y8z/mA0oBiHrfqdllMeJVwtkm92YZs?=
 =?us-ascii?Q?VUZCVjLJanLAwQ6m9h/smDfOoYz9MysGaPBswNcnhd2MvmPXI174DUZz0L0p?=
 =?us-ascii?Q?2SdfnfAFw2LkcyMopBOHpxIsSe9yC4yict58uWwxO/0PQl8i84I6q+b8RVHf?=
 =?us-ascii?Q?m2jXsnBbew+1ElgI+qkHq08l0Er1SLwACChpy8I1J1Jb5jAfuq7oFzTIg8Cf?=
 =?us-ascii?Q?ebffrPhZVOfne4/hGsVaDN/YwVF/UrQI8UfHlaCIax6uxdc4OIZw9E5K64dO?=
 =?us-ascii?Q?V5OyD7YkQi472o37taVmaGXobJL20NBW2w6APW/Ifn/RzvYwC5LjnbYB9UdU?=
 =?us-ascii?Q?tlLt0KJW/ae3dH574zECaae22X1BiUJqq3BrCqcKXHhKKMPPTPYRFCvdhzZM?=
 =?us-ascii?Q?6TzEpa7pegpquLKfmnk5JNC3V1EVLo8uGtEvT12Dxch/ebvsJOH8Wy981rdi?=
 =?us-ascii?Q?/Iu0YcFV3o+xsK6c4IOvHNbv3gpmH4+e9y9AkGGh5RZWoD1m7ovJnu3llHCs?=
 =?us-ascii?Q?PmMxc1AaQ7pcKF8cxd3NTfBdnpbtz5V1wMi1+ZGJBYf0lTW4BeMGacxjnull?=
 =?us-ascii?Q?jtoT5u6Ge4NhgDgmv3daz3Yg6jR5YjLq4Ibxmlm4A6PuoxtLOheFDhpmDLJG?=
 =?us-ascii?Q?5NTl2mSUeDlQwPQiVwQN0+8PcN8As9rUgoyxLusUWWEiUYsQvmj5MZJRT4L9?=
 =?us-ascii?Q?uZJAWI14OByrV6ydm6tgeZ5US6Y3a4JJCqf/mVzFGizuGOjmT5pc2rXrtIdm?=
 =?us-ascii?Q?D+A65i9Znu+Dc+NORzlZ+AdxOkgnM0OFEcpvbNUDuVkNsVleONF6CtObLXUl?=
 =?us-ascii?Q?+8bMoqZvGzQh9rZ6Eow8oaPVaPUMTMYSnFmM5gaBBDlEZtkjmRrpWq4NIhgj?=
 =?us-ascii?Q?FthX5dqvsm5KzZe1OoA48hC2VzNxVjD6kiboS9/M6+wmkw7tPIXUE1vR0yX+?=
 =?us-ascii?Q?dqpmFpBnq0p/1rtlW0AblwMsXzRq1ztwoSMux99eBOEorQwSRc3ME62Xpir7?=
 =?us-ascii?Q?BCSqKm/6rEHLdSzKq1HcThiRi+gZuIVfu+f+BRtgLm1PolUrcPcuje9mzcFR?=
 =?us-ascii?Q?OAi6aK2AK0w2c4ktMdRB4gWV61tEBEOHNpl5zv4pwJNUNMLbpDnHhtp7XrJV?=
 =?us-ascii?Q?jpy/Iw/ki7lj1vWCbiPASvkyFcZRSwkh/tUErzopaWkt48izexHS2qkasitF?=
 =?us-ascii?Q?b9WCyG4qIDhcN9o3164E2IG9CRNDPVr0vjcMSye0LzMnTTOm3IztVENHmslv?=
 =?us-ascii?Q?ZstVQp4x/P7jCj1xML2w0YVGLUSJMo5VKiLUX8oX1TWPM+nepz6G5evKB7Mw?=
 =?us-ascii?Q?OTxn/qtjmVOlYA0yzxxgTjge8JvbVnhF/qS7w+wLorW0jhbkh2O2bGjZet0e?=
 =?us-ascii?Q?tPSoi82GOdDLn2EyQGnEXvcVfEtcgCum6uIkk2ak4qWDhKNmTb2j2vpL+1CH?=
 =?us-ascii?Q?x/NH8jKIkEzDLEYkzUQXVCpz8BpYmlEstWg+851tHVE4cDv1J3EGwBkU/bHs?=
 =?us-ascii?Q?OTyHkJZ5MtNqdpbtiO0r7Z5afm/vXfmZxa1gE4tmLeW4g1aaW4J8oNxAbEO2?=
 =?us-ascii?Q?y79xmegfxg=3D=3D?=
Content-Type: multipart/signed;
	protocol="application/x-pkcs7-signature";
	micalg=SHA1;
	boundary="----=_NextPart_000_010E_01DD4493.23CC3650"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48da256b-f1b6-487e-27dd-08df127c2f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2026 16:21:08.7114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MlkFGt8pQXkdt9ZKDTBqsEmKKmynZmMxD2OjAGS6rM7MbbIayB110nsI0S2jVytyGwIpg8lhAbDz7bqCa19cjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9269

------=_NextPart_000_010E_01DD4493.23CC3650
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Rosen,

Thanks for the fix.

Tested-by: Sahil Malhotra <sahil.malhotra@nxp.com> # i.MX8MM-EVK

> -----Original Message-----
> From: Rosen Penev <rosenp@gmail.com>
> Sent: 02 September 2026 02:08
> To: linux-crypto@vger.kernel.org
> Cc: Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>;
Rosen
> Penev <rosenp@gmail.com>; open list <linux-kernel@vger.kernel.org>
> Subject: [EXT] [PATCH] crypto: caam: map job ring registers without
claiming
> region
> 
> Caution: This is an external email. Please take care when clicking links
or opening
> attachments. When in doubt, report the message using the 'Report this
email'
> button
> 
> 
> devm_platform_ioremap_resource() ends up calling request_mem_region(),
> which fails with -EBUSY on i.MX SoCs:
> 
> There the job rings are modelled as sub-regions of their parent
> fsl,sec-v4.0 register window, and caam_probe() already reserves the whole
> window exclusively via devm_of_iomap() before the children are populated.
> Every job ring therefore collides with its own parent and fails to probe,
taking the
> hardware RNG offline (seen on i.MX6, i.MX7 and i.MX8 boards such as
colibri-
> imx7 and verdin-imx8mp).
> 
> Map the job ring registers with devm_ioremap() instead, which does not
claim the
> (already owned) region.
> 
> Fixes: 9a955c0a7d11 ("crypto: caam - simplify probe resource and IRQ
handling")
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/caam/jr.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
> f9e029945b51..2ed8229d4733 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -583,12 +583,29 @@ static int caam_jr_probe(struct platform_device
> *pdev)
>         struct caam_drv_private_jr *jrpriv;
>         static int total_jobrs;
>         void __iomem *ctrl;
> +       struct resource *r;
>         int error;
>         int irq;
> 
> -       ctrl = devm_platform_ioremap_resource(pdev, 0);
> -       if (IS_ERR(ctrl))
> -               return PTR_ERR(ctrl);
> +       /*
> +        * The job rings live inside the register window of their parent
> +        * fsl,sec-v4.0 node, which caam_probe() already reserves (and
maps)
> +        * via devm_of_iomap().  A requested region that overlaps that
> +        * reservation, e.g. from devm_platform_ioremap_resource(), would
> +        * therefore fail with -EBUSY, so map the registers without
claiming
> +        * the region here.
> +        */
> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!r) {
> +               dev_err(&pdev->dev, "platform_get_resource() failed\n");
> +               return -EINVAL;
> +       }
> +
> +       ctrl = devm_ioremap(&pdev->dev, r->start, resource_size(r));
> +       if (!ctrl) {
> +               dev_err(&pdev->dev, "devm_ioremap() failed\n");
> +               return -ENOMEM;
> +       }
> 
>         irq = platform_get_irq(pdev, 0);
>         if (irq < 0)
> --
> 2.55.0
> 


------=_NextPart_000_010E_01DD4493.23CC3650
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIm1zCCBaIw
ggOKoAMCAQICCHIFyg1TnwEcMA0GCSqGSIb3DQEBCwUAMGUxIjAgBgNVBAMMGU5YUCBJbnRlcm5h
bCBQb2xpY3kgQ0EgRzIxCzAJBgNVBAsMAklUMREwDwYDVQQKDAhOWFAgQi5WLjESMBAGA1UEBwwJ
RWluZGhvdmVuMQswCQYDVQQGEwJOTDAeFw0yMzA0MTQwNzQ1MzFaFw0yODA0MTIwNzQ1MzFaMIG2
MRwwGgYDVQQDDBNOWFAgRW50ZXJwcmlzZSBDQSA0MQswCQYDVQQLDAJJVDERMA8GA1UECgwITlhQ
IEIuVi4xEjAQBgNVBAcMCUVpbmRob3ZlbjEWMBQGA1UECAwNTm9vcmQtQnJhYmFudDETMBEGCgmS
JomT8ixkARkWA3diaTETMBEGCgmSJomT8ixkARkWA254cDETMBEGCgmSJomT8ixkARkWA2NvbTEL
MAkGA1UEBhMCTkwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDVSMlM/AT8vRa4mBRQ
JwL0iYE6It2ipQbMoH8DzO7RQLmGmi82PhZs2XhTRcEWtedeDstWIRWwWC4vQiZvwshmknxltM+O
wkFHVcUrpG5slDwe2RllSij7099aHWJmOai6GjOz7C/aywDyzrftFuzd3+7JsGlBi4ge5d7AT9Nt
lhBOySz4omF4e1R+iNY8mqq/mfPcBFbAe6sGWQ96+0+UAAVxBpCZ8NmtwUjeSGvWVSfPDga4IW+V
oJdQWFsY0YoDVdglKSmA4n9J0hfq+gErN4nq8/1/Q8AamPaNqVRwtN1g/mI/1JyHa+J2nmqLiixj
tndxIPnwrKdS+sM34VuXAgMBAAGjggECMIH/MFIGCCsGAQUFBwEBBEYwRDBCBggrBgEFBQcwAoY2
aHR0cDovL253dy5wa2kubnhwLmNvbS9jZXJ0cy9OWFBJbnRlcm5hbFBvbGljeUNBRzIuY2VyMB0G
A1UdDgQWBBTlMnr0ZsFHliR//CeAOVjfKxfiuzASBgNVHRMBAf8ECDAGAQH/AgEAMEUGA1UdHwQ+
MDwwOqA4oDaGNGh0dHA6Ly9ud3cucGtpLm54cC5jb20vY3JsL05YUEludGVybmFsUG9saWN5Q0FH
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
EwJJTjEWMBQGA1UECxMNTWFuYWdlZCBVc2VyczETMBEGA1UECxMKRGV2ZWxvcGVyczERMA8GA1UE
AxMIbnhhMTk3MTMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD5LkFanwXxIroIIgls
Pu3ltIXx6xtFs2uP/LK9jocFjB6orMCaF+JBc+ejUdJsL9bkVvswHSZpoku2Jk8oGUzPz0Mid0Xm
7vjPly1yJiAB8NMHcT0luDFAyERcF14E3WNhFgJa2fR14kd2oPAhAClvIpbzdLz7Z86N4fCpDh3U
sRIGLl1srk072/9NzkJy9NuSB9/WV+gpOuOT26gRuvLvJwYlCuFRxCNkcO5sIoFh+tCf9CMZEfUh
ogv4w9M5MKtg8mriP6KN+gzZX5FuRFclkz8eL6JMOWJLqvLYxO4pEktrEN2r736MXA30ywO8tfRe
RpMtHukNUNkNiRZlVcidAgMBAAGjggOVMIIDkTAOBgNVHQ8BAf8EBAMCB4AwHQYDVR0lBBYwFAYI
KwYBBQUHAwIGCCsGAQUFBwMEMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFG/5AJJ0NqmGczL1seei
cOsG5iQ5MEkGA1UdEQRCMECgJgYKKwYBBAGCNxQCA6AYDBZzYWhpbC5tYWxob3RyYUBueHAuY29t
gRZzYWhpbC5tYWxob3RyYUBueHAuY29tMB8GA1UdIwQYMBaAFOUyevRmwUeWJH/8J4A5WN8rF+K7
MIIBSgYDVR0fBIIBQTCCAT0wggE5oIIBNaCCATGGgchsZGFwOi8vL0NOPU5YUCUyMEVudGVycHJp
c2UlMjBDQSUyMDQsQ049bmxhbXNwa2kwMDA0LENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2
aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXdiaSxEQz1ueHAsREM9Y29tP2Nl
cnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Q
b2ludIYxaHR0cDovL253dy5wa2kubnhwLmNvbS9jcmwvTlhQLUVudGVycHJpc2UtQ0E0LmNybIYx
aHR0cDovL3d3dy5wa2kubnhwLmNvbS9jcmwvTlhQLUVudGVycHJpc2UtQ0E0LmNybDCCARAGCCsG
AQUFBwEBBIIBAjCB/zCBuwYIKwYBBQUHMAKGga5sZGFwOi8vL0NOPU5YUCUyMEVudGVycHJpc2Ul
MjBDQSUyMDQsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENO
PUNvbmZpZ3VyYXRpb24sREM9d2JpLERDPW54cCxEQz1jb20/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29i
amVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwPwYIKwYBBQUHMAKGM2h0dHA6Ly9ud3cu
cGtpLm54cC5jb20vY2VydHMvTlhQLUVudGVycHJpc2UtQ0E0LmNlcjA8BgkrBgEEAYI3FQcELzAt
BiUrBgEEAYI3FQiFgsB+gY70VYbthTiC65lLmpJWP4TGzVyC5Y1+AgFkAgFBMCcGCSsGAQQBgjcV
CgQaMBgwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBADtv6vY/EF9j
RlcUiuRjuZRT0Mxv8uYyXhSMjTimnK7l2q9JoU36RBgbqWmG4YpBR8EtKu70TxYbp9cthrGIZnTk
3Pe+kEBdEXTNo6XHUoTqw/GuMVvGKwSX58hcW23fZZXnuBjS+rpmQv/nk03pvJEUJ4EiSsogha4E
ELUjA5h0yATvS99S+5u1StWQcUyhkSjAIha/xAE1DlQvgcJAgYfLj9ieFE6Wso0bH7QioEtOKgPc
pcpQF3wkeecDqs7pb0/kWR9+fn2MazIUC5KMi2Fd0ZDvUYTI7HC7ZMLEZaRZnIl/7OfhUoafXlvi
JN+acLSQTr2nPIS5edQmswhQ4NMwgggAMIIG6KADAgECAhMtAA/OMfXZwZVvm51kAAIAD84xMA0G
CSqGSIb3DQEBCwUAMIG2MQswCQYDVQQGEwJOTDETMBEGCgmSJomT8ixkARkWA2NvbTETMBEGCgmS
JomT8ixkARkWA254cDETMBEGCgmSJomT8ixkARkWA3diaTEWMBQGA1UECBMNTm9vcmQtQnJhYmFu
dDESMBAGA1UEBxMJRWluZGhvdmVuMREwDwYDVQQKEwhOWFAgQi5WLjELMAkGA1UECxMCSVQxHDAa
BgNVBAMTE05YUCBFbnRlcnByaXNlIENBIDUwHhcNMjYwNTMxMDEyMTUzWhcNMjgwNTMwMDEyMTUz
WjCBmjETMBEGCgmSJomT8ixkARkWA2NvbTETMBEGCgmSJomT8ixkARkWA254cDETMBEGCgmSJomT
8ixkARkWA3diaTEMMAoGA1UECxMDTlhQMQswCQYDVQQLEwJJTjEWMBQGA1UECxMNTWFuYWdlZCBV
c2VyczETMBEGA1UECxMKRGV2ZWxvcGVyczERMA8GA1UEAxMIbnhhMTk3MTMwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQDc3ATkqaNGksoCdWTSjY8U3Ja0JdzsT7KDYfK1QAWbNAmn5TKp
eA63XxJJtwqYAd74kDAGyRuE+ecMS4ivlBhKoDqur0XRo5V/SMyVtPXY0CyzChDwDd8mSlJlJGV3
GeSnZpyPjT7MQl2tq1+n9ITMqHuwY3b4t9K1UQxSBVp7rkSQescxwwQlVrEu9EckUCqZPi6J7Tcz
mVSLqGwQ7KgPMGla1dyqZp8DdL4Wo9I4GK0RR39XfpX/+8Ek7ZCgLyfDMblQgp602qv0AgxUxMGq
JHf0r8XbHczEJpXQAaWmBdbz0HdmqfCztLnoWjlmsVawZoir7taOqYBtKO71lBu1AgMBAAGjggQf
MIIEGzA8BgkrBgEEAYI3FQcELzAtBiUrBgEEAYI3FQiFgsB+gY70VYbthTiC65lLmpJWP4G3gjyD
7YcyAgFkAgFHMBMGA1UdJQQMMAoGCCsGAQUFBwMEMA4GA1UdDwEB/wQEAwIFIDAMBgNVHRMBAf8E
AjAAMBsGCSsGAQQBgjcVCgQOMAwwCgYIKwYBBQUHAwQwgZQGCSqGSIb3DQEJDwSBhjCBgzALBglg
hkgBZQMEASowCwYJYIZIAWUDBAEtMAsGCWCGSAFlAwQBFjALBglghkgBZQMEARkwCwYJYIZIAWUD
BAECMAsGCWCGSAFlAwQBBTAKBggqhkiG9w0DBzAHBgUrDgMCBzAOBggqhkiG9w0DAgICAIAwDgYI
KoZIhvcNAwQCAgIAMB0GA1UdDgQWBBQfYjIpjSw2UbsGLe5ZTCwCKUvN/TBJBgNVHREEQjBAoCYG
CisGAQQBgjcUAgOgGAwWc2FoaWwubWFsaG90cmFAbnhwLmNvbYEWc2FoaWwubWFsaG90cmFAbnhw
LmNvbTAfBgNVHSMEGDAWgBRCTsKYNL9dzm9wDaBb4olHA/sMYDCCAU8GA1UdHwSCAUYwggFCMIIB
PqCCATqgggE2hoHLbGRhcDovLy9DTj1OWFAlMjBFbnRlcnByaXNlJTIwQ0ElMjA1KDIpLENOPW5s
YW1zcGtpMDAwNSxDTj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMs
Q049Q29uZmlndXJhdGlvbixEQz13YmksREM9bnhwLERDPWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRp
b25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnSGMmh0dHA6Ly9ud3cu
cGtpLm54cC5jb20vY3JsL05YUEVudGVycHJpc2VDQTUoMikuY3JshjJodHRwOi8vd3d3LnBraS5u
eHAuY29tL2NybC9OWFBFbnRlcnByaXNlQ0E1KDIpLmNybDCCARQGCCsGAQUFBwEBBIIBBjCCAQIw
gbsGCCsGAQUFBzAChoGubGRhcDovLy9DTj1OWFAlMjBFbnRlcnByaXNlJTIwQ0ElMjA1LENOPUFJ
QSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9u
LERDPXdiaSxEQz1ueHAsREM9Y29tP2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0
aWZpY2F0aW9uQXV0aG9yaXR5MEIGCCsGAQUFBzAChjZodHRwOi8vbnd3LnBraS5ueHAuY29tL2Nl
cnRzL05YUC1FbnRlcnByaXNlLUNBNSgyKS5jZXIwDQYJKoZIhvcNAQELBQADggEBAE0hlnqM14Np
n/OtlA31G04pFvpEzUOB22JVJQDmIfOoJYTfHmOvBDbnNCSrLxyGoeMlbxr/5Xf3LbngB1DIldyv
pPTFxqUb8F5ExFx1kSYwqOlhiwfuFTKwLm2S/yf8oSiuTkUmQarcQMJYlqp/DSIQZNIAu3rLoK6t
Sz5L+P7XXsE5IHKIVt71I+wsp6/TyXi8zhuZqsP58TXyRpyHsTVuX0PUwDDuRcjHx5rgopGVFvNT
/Dz/9w5fOatOwz2gBP03fwiHX18I/UYtNtbKYo18TTW8PtCzn0rXrtqV5F1j1HG6XsLQqQqsDE7q
MhmaQy+P0kq3ZZsdkGIxsK1hEbIxggSzMIIErwIBATCBzjCBtjEcMBoGA1UEAwwTTlhQIEVudGVy
cHJpc2UgQ0EgNDELMAkGA1UECwwCSVQxETAPBgNVBAoMCE5YUCBCLlYuMRIwEAYDVQQHDAlFaW5k
aG92ZW4xFjAUBgNVBAgMDU5vb3JkLUJyYWJhbnQxEzARBgoJkiaJk/IsZAEZFgN3YmkxEzARBgoJ
kiaJk/IsZAEZFgNueHAxEzARBgoJkiaJk/IsZAEZFgNjb20xCzAJBgNVBAYTAk5MAhM/AAgjh+a3
v32eoNZHAAUACCOHMAkGBSsOAwIaBQCgggK5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI2MDkxNDE2MjEwNFowIwYJKoZIhvcNAQkEMRYEFC6RpcBKXSwKPDuqI018
O4HAKWu0MIGTBgkqhkiG9w0BCQ8xgYUwgYIwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggq
hkiG9w0DBzALBglghkgBZQMEAQIwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIaMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgIwCwYJYIZIAWUDBAIBMIHfBgkrBgEEAYI3EAQx
gdEwgc4wgbYxCzAJBgNVBAYTAk5MMRMwEQYKCZImiZPyLGQBGRYDY29tMRMwEQYKCZImiZPyLGQB
GRYDbnhwMRMwEQYKCZImiZPyLGQBGRYDd2JpMRYwFAYDVQQIEw1Ob29yZC1CcmFiYW50MRIwEAYD
VQQHEwlFaW5kaG92ZW4xETAPBgNVBAoTCE5YUCBCLlYuMQswCQYDVQQLEwJJVDEcMBoGA1UEAxMT
TlhQIEVudGVycHJpc2UgQ0EgNQITLQAPzjH12cGVb5udZAACAA/OMTCB4QYLKoZIhvcNAQkQAgsx
gdGggc4wgbYxCzAJBgNVBAYTAk5MMRMwEQYKCZImiZPyLGQBGRYDY29tMRMwEQYKCZImiZPyLGQB
GRYDbnhwMRMwEQYKCZImiZPyLGQBGRYDd2JpMRYwFAYDVQQIEw1Ob29yZC1CcmFiYW50MRIwEAYD
VQQHEwlFaW5kaG92ZW4xETAPBgNVBAoTCE5YUCBCLlYuMQswCQYDVQQLEwJJVDEcMBoGA1UEAxMT
TlhQIEVudGVycHJpc2UgQ0EgNQITLQAPzjH12cGVb5udZAACAA/OMTANBgkqhkiG9w0BAQEFAASC
AQDjJVa7SqChPcecb6nSRngqcOLp4k4JYzhvYMrEL5LwYyrcQ9kwD/L+XNdmZp9BD6nCx6iLK51t
arXsljUwcl8jxL3Gcj+ln3Kk604IKE/uZ3U4XoqxWjZk+6+vjcdZhlTHKCnUozlZIXx+UwCGXt7x
AUsCYXbSXW9pF6Hal2chqqh5yjCkdaXsYtfwkPnZeaJkndirjku1SN0dV2hZ2WBWG1HbVGoPQun6
7/NbRhHmtyabq2edBnAatjYKDpHbFr5qUqdDl8RP43Dt25Me97aTc9/ZGd6HasUrWgS2Z0XfO1MB
QPGOcbJB/3nQRzG79+sn6cOuAY+s/HS/e9P2BoUlAAAAAAAA

------=_NextPart_000_010E_01DD4493.23CC3650--
