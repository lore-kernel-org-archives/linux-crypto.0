Return-Path: <SRS0=1Cfx=ZR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BC0C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 12:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41AF12082F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 12:03:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="TIghguSE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfKYMDW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Nov 2019 07:03:22 -0500
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:17639
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727124AbfKYMDW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Nov 2019 07:03:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEs2JYY+SbSpV99gEaGofmC/iN4+jO3+EPHPRIeByUEAYoMln00YsW36HvbIu583Xb8Qu4DjD+LmOSXgMTJcKa0xzgr9V519DXGUUa8icI+gmI2dBt8KCFvkcLNPJ2glXIEnH7HMfdDIkVrNJtr/GGCw/mcf9Pw/ogI3qUz86Eiw5CCsv0iBOUgLniKJxYsKdL+rzgiwhC0R08WPl72xXqYYO5B6flVTCbhm03CNoIXqmBX18TA1VlOukl5bml4d73Qc+Gq+veALP/uvlRO+4Pf+b/LCWjiWd0Pmu47wHy0N4eoMEINTUWZiKYqDx7r4ywuCsMUqvy9Ds4qlKqIMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaegIZSZSKcKq0wwqi9/KOXIfgoWSpL6pm/ZPwk1XtA=;
 b=LWY1GM+lNS+LZ9U8fHUJ2O71KRdhZ3JlilKHHl9RaOzf995iMDALdq/vyT+R95JaJSrOnGXXyAD99m541jzetZo3H8DGEZFpTW+xKRQUNM6V+Iu1AHWeLsJqPvz6YWxCxDdNo/BIi00780/yotqAfc0n3XRw3IbUueetsmSIjLaQScDmNKErZS2Wzsn23W+EW7fNHe17YWspz+Crcsaad0EYZOR4O1uu4vYgm7TIlYIOYysi+qJHS5RrYxjJBy1p0OTdSnFLNqLg9MKgW3vlO6DwrGmmWqe3setbDV8gE4VS7Yh5s9uX/O0Cd6u5JiKBBIAaoh09xDvZm5oyJyX6Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaegIZSZSKcKq0wwqi9/KOXIfgoWSpL6pm/ZPwk1XtA=;
 b=TIghguSE2M8lSX9GGf3kVV1uzu1h1RX+ERion9pTW7Ghp4DdLIG/mWBzofWq7xod4yKbgmhlbLVrGbxSar+fs+MkP/trzIY3iwtelBwWnBBZXb8EDRFmyFmLUr5Ay988POcTnUfmYRTvyJ24a5T8KqUbmQfS0eMX4IkJC3aYoWQ=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB6800.eurprd04.prod.outlook.com (52.133.245.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Mon, 25 Nov 2019 12:02:38 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d%5]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 12:02:38 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Alison Wang <alison.wang@nxp.com>
Subject: Re: [PATCH] crypto: caam - do not reset pointer size if caam_ptr_size
 is 64 bits
Thread-Topic: [PATCH] crypto: caam - do not reset pointer size if
 caam_ptr_size is 64 bits
Thread-Index: AQHVoxct9YNV/+sCCkCTnpGbBimKsg==
Date:   Mon, 25 Nov 2019 12:02:38 +0000
Message-ID: <VI1PR04MB44455C61E2D64EFF88CE39768C4A0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574634784-10571-1-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB34857C5B83AC9811BB87F419984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05b5a397-d782-441e-e700-08d7719f5e0e
x-ms-traffictypediagnostic: VI1PR04MB6800:|VI1PR04MB6800:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6800E4825DF79677CFAEC1218C4A0@VI1PR04MB6800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(3846002)(71200400001)(71190400001)(74316002)(6506007)(52536014)(7696005)(76176011)(6116002)(256004)(53546011)(6636002)(99286004)(446003)(7736002)(305945005)(91956017)(76116006)(4326008)(66946007)(26005)(66446008)(102836004)(186003)(25786009)(5660300002)(66476007)(66556008)(64756008)(14454004)(478600001)(66066001)(229853002)(8676002)(44832011)(6436002)(55016002)(81156014)(81166006)(8936002)(86362001)(14444005)(33656002)(6246003)(110136005)(54906003)(316002)(2906002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6800;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sd+CnHDSPx1hu4Cq18mMTkJ0Y4LJSztyNt7Unig79HoGnvIpv/V1bDUMwclwKZ3JBuAoyTmceeOF7xn+Q0p1qxLNGSrJDQGgmH9EGEiRefEoPuwrZBS8Et8RWKjDOBsHPMtIr2rGffElnWx9Ne1wZ2WpO0ddOQz8Bu5aUBhWxYM+Y1PjoGudqf1SssJKes/hEJ0aAPPIaSumz6ojY7rKDt1xY2syBiQ1/967+pbNc2we/fIHfgIM9vAq8bU73j1Rz43isQnDG9cmqUuhkQUqS8ehX7oOoZAWiGC6Y5SAyrflzBcyZBChyp4s+8iV5Zr8kRiixsi0DqOKxDMa95jjcHgFiX4RSpvGj5R5DkhpR613yztMTApk1haAVX4ioRn0yEeGRPaG88KNNs5SrG5DHiUlezCpYUUuEeQcQSR6M6/0dR8V69svb/OHE5prQi8/
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b5a397-d782-441e-e700-08d7719f5e0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 12:02:38.6960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NoA6LAlmG8RW+qPZXTD+TaPJYNOBDqw1mn2yHOYEeA7EanVmKxr5ADPkfP2R8nOlgp4pF+RjFqKgrTGjdvOt1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/25/2019 9:49 AM, Horia Geanta wrote:=0A=
> On 11/25/2019 12:33 AM, Iuliana Prodan wrote:=0A=
>> In commit 'a1cf573ee95 ("crypto: caam - select DMA address=0A=
>> size at runtime")' CAAM pointer size (caam_ptr_size) is changed=0A=
>> from sizeof(dma_addr_t) to runtime value computed from MCFGR register.=
=0A=
>> At some point, the bit for Pointer Size should be reset to 0,=0A=
>> but only for the case when the CAAM pointer size if 32 bits.=0A=
>> Therefore, use caam_ptr_size instead of sizeof(dma_addr_t).=0A=
>>=0A=
> The logic is circular, see below.=0A=
> =0A=
>> Fixes: a1cf573ee95 ("crypto: caam - select DMA address size at runtime")=
=0A=
> Please Cc the author(s) when adding Fixes tag.=0A=
> =0A=
>> Cc: <stable@vger.kernel.org>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> ---=0A=
>>   drivers/crypto/caam/ctrl.c | 2 +-=0A=
>>   1 file changed, 1 insertion(+), 1 deletion(-)=0A=
>>=0A=
>> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
>> index d7c3c38..786eef6 100644=0A=
>> --- a/drivers/crypto/caam/ctrl.c=0A=
>> +++ b/drivers/crypto/caam/ctrl.c=0A=
>> @@ -674,7 +674,7 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>>   		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK | MCFGR_LONG_PTR,=0A=
>>   			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |=0A=
>>   			      MCFGR_WDENABLE | MCFGR_LARGE_BURST |=0A=
>> -			      (sizeof(dma_addr_t) =3D=3D sizeof(u64) ?=0A=
>> +			      (caam_ptr_sz =3D=3D sizeof(u64) ?=0A=
>>   			       MCFGR_LONG_PTR : 0));=0A=
>>   =0A=
> Before this in caam_probe() there's:=0A=
> 	if (comp_params & CTPR_MS_PS && rd_reg32(&ctrl->mcr) & MCFGR_LONG_PTR)=
=0A=
> 		caam_ptr_sz =3D sizeof(u64);=0A=
> 	else=0A=
> 		caam_ptr_sz =3D sizeof(u32);=0A=
> =0A=
> thus caam_ptr_sz is determined based on MCFGR:=0A=
> MCFGR[PS] =3D=3D> caam_ptr_sz=0A=
> so it no longer makes sense to reconfigure MCFGR based on caam_ptr_sz:=0A=
> caam_ptr_sz =3D=3D> MCFGR[PS]=0A=
> =0A=
> The short-term fix would be to no longer touch MCFGR[PS], which is in lin=
e with=0A=
> commit a1cf573ee95 ("crypto: caam - select DMA address size at runtime")=
=0A=
> =0A=
> Note however there's a small issue with the logic of kernel relying on=0A=
> MCFGR[PS] being previously configured (by U-boot etc.), see=0A=
> commit 39eaf759466f ("crypto: caam - fix pointer size for AArch64 boot lo=
ader, AArch32 kernel")=0A=
> =0A=
=0A=
So, what's your suggestion? We shouldn't reset the MCFGR[PS] at all? We =0A=
should use the value set by u-boot?=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
> In the long run, IMO the proper thing for the driver to do is to rely,=0A=
> whenever possible, on DT ("dma-ranges" property) / dma_mask provided by=
=0A=
> the device driver infrastructure, and not on MCFGR[PS]:=0A=
> [ DT "dma-ranges" =3D=3D> ] dma_mask =3D=3D> MCFGR[PS], caam_ptr_sz=0A=
> but that would probably involve too many changes for getting into -stable=
.=0A=
> =0A=
> Horia=0A=
> =0A=
=0A=
