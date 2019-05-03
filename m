Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD1CC43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D6B12087F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:00:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PDXV5fpk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfECNAv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 09:00:51 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:19361
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfECNAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 09:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJFd+IU6bkmUA6IZCSzQ/T5NuT2tuPAFvEUixEEs0fg=;
 b=PDXV5fpkU9iudTlq0hIx+8Ip9B4q2K/jVwhQLrCS+iLIGosBqECfuNCCAj5LH5dH7fbjZB2c1ReU1/FKktosfoBzs76dictxbyYcO10HbxbS1OW7XXoPgQysDoZGCkXI0bFSuiWdmrUVbQifiZBgqU1F8e7ptq6PZcbf6Fz9Q6c=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3599.eurprd04.prod.outlook.com (52.134.5.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Fri, 3 May 2019 13:00:46 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1835.018; Fri, 3 May 2019
 13:00:46 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Topic: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Index: AQHU+4N3anqMDo9NOUqVDDhJ3xPEHA==
Date:   Fri, 3 May 2019 13:00:46 +0000
Message-ID: <VI1PR0402MB3485EAD0CC9D3CF8C91E9F7098350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
 <VI1PR04MB513455960753AA04259CBAA4EC3F0@VI1PR04MB5134.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58feba90-2544-4fd6-37d4-08d6cfc75bb8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3599;
x-ms-traffictypediagnostic: VI1PR0402MB3599:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB3599DA9EDBDC773B8BC2A84498350@VI1PR0402MB3599.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(346002)(366004)(376002)(13464003)(189003)(199004)(8936002)(476003)(52536014)(186003)(44832011)(6506007)(53546011)(102836004)(2906002)(486006)(99286004)(446003)(7696005)(26005)(76176011)(66476007)(110136005)(66556008)(66946007)(64756008)(86362001)(73956011)(66446008)(76116006)(68736007)(54906003)(81156014)(81166006)(8676002)(33656002)(7736002)(316002)(71190400001)(71200400001)(256004)(55016002)(6306002)(9686003)(6116002)(3846002)(5660300002)(53936002)(4744005)(6246003)(25786009)(966005)(14454004)(478600001)(4326008)(66066001)(305945005)(74316002)(229853002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3599;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qgkZBvEs5s+CoeZeRDJ501sT7Me+vn5RjjkHPHLt+38OQmzABQicb/Ye35k5E+fZbtkVprrhT872h9QL1Ve2FtcIP74pLBD2MZsViDBGDnyBqd5Gts2po4SG67GMBvN++6hIuy7wijaTFyAwjfMmOnJR3LhjpB7yi9NrSQNzR+JoO5MpkbzCE3EPVWVcBvCS3OShj4bosnwOxii3U2d7o/WrSsvSXRuuzfreO/c41NUrbSK1FPUYIiJoAdtyIOCyqByElCE381A9WZQJdVu2bgtBe8MursbzFi3v9TpIgOTQAJebbFJu0125gFMpf+wwutDQueuzCBaW0MitcDGcP025hJ8vkNqlFqNmdWALR6mDLQbaexIvWekj1cpRTmBx71gp49WfRFQAw39JXn2QNXvoIcUzXmEZIrUItkds02E=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58feba90-2544-4fd6-37d4-08d6cfc75bb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 13:00:46.2494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3599
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/27/2019 10:17 AM, Laurentiu Tudor wrote:=0A=
> Hi Horia,=0A=
> =0A=
>> -----Original Message-----=0A=
>> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> Sent: Thursday, April 25, 2019 7:25 PM=0A=
>>=0A=
>> This patch set adds support in caam drivers (caam/jr, caam/qi, caam/qi2)=
=0A=
>> for the crypto engine to work behind an IOMMU.=0A=
>>=0A=
> =0A=
> [snip]=0A=
> =0A=
>>=0A=
>> i. Patch 9/9 (crypto: caam - defer probing until QMan is available) shou=
ld=0A=
>> NOT be merged, since there are compilation dependencies on the patch=0A=
>> series:=0A=
>> (*) Prerequisites for NXP LS104xA SMMU enablement=0A=
> =0A=
> FYI, I've submitted a v2 of the series dropping several some patches that=
 need additional work but including the patch you depend on, see here:=0A=
> =0A=
> https://patchwork.kernel.org/project/linux-arm-kernel/list/?series=3D1108=
99=0A=
> =0A=
Thanks.=0A=
I've tested with it and worked without any change in this patch set.=0A=
=0A=
Herbert,=0A=
=0A=
I've noticed the patchwork status is "Changes requested".=0A=
I am not aware of any other comment requesting modifications.=0A=
=0A=
Thanks,=0A=
Horia=0A=
