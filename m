Return-Path: <SRS0=vipQ=TG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF08C04AAD
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 08:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0EC9205C9
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 08:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="m5BOiJ6K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfEFIGK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 May 2019 04:06:10 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:3958
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725834AbfEFIGK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 May 2019 04:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYJH78geWAufTebZxNWMwpYNaSe+IL9Q7aD21mPOVaM=;
 b=m5BOiJ6KKE8lKwSUS7wejc36sPwf7cnHjqB2KbNSYJz/muDdyPfzqdkWNov4C5f1lBWjUBdHZWPCt90w+z9+1J4TtZ39w04X0vdCNjU5bjdwdgraW7Ib3iFbz/20QaUORDrvGNMKmdVxjHvoVLF3MXUhSGVoX4OPMlewyiLxCDY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2814.eurprd04.prod.outlook.com (10.172.255.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Mon, 6 May 2019 08:06:06 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 08:06:06 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [v2 PATCH] crypto: caam - fix DKP detection logic
Thread-Topic: [v2 PATCH] crypto: caam - fix DKP detection logic
Thread-Index: AQHVA9ai0d8oKocRHke5SDfLD84+PA==
Date:   Mon, 6 May 2019 08:06:06 +0000
Message-ID: <VI1PR0402MB3485B440F9D3F033F021307298300@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190503120548.5576-1-horia.geanta@nxp.com>
 <20190506063944.enwkbljhy42rcaqq@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74ea71b0-21ea-4fb7-8f9b-08d6d1f9b11a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2814;
x-ms-traffictypediagnostic: VI1PR0402MB2814:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB2814C294CC3AB6D31994B7D498300@VI1PR0402MB2814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(366004)(136003)(396003)(199004)(189003)(54906003)(14454004)(26005)(305945005)(99286004)(6246003)(8936002)(7736002)(6916009)(68736007)(316002)(86362001)(25786009)(446003)(44832011)(76116006)(4326008)(66946007)(186003)(66476007)(66446008)(66556008)(229853002)(2906002)(486006)(64756008)(74316002)(6436002)(71190400001)(6116002)(71200400001)(3846002)(81166006)(81156014)(73956011)(966005)(5660300002)(33656002)(76176011)(55016002)(66066001)(53546011)(7696005)(52536014)(6306002)(478600001)(8676002)(9686003)(476003)(102836004)(6506007)(256004)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2814;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ho6mAYPXCVdyXR72HEVFH1RsIpbICOtap+mNcz1pOHC6LuQBx1iGJNGn9roPISbusRpibepG4eBYX8F+o/El7zOITVFFEDNkHdLAYCNQDAILV7aKNPA4W0Jrr6GMjsW6UOynx+pRhEvXdiblQM56D9L6QOfB84ZvcN/fJcUSKUliyyxAwzrUNNm+LBSFXmyhWdOpct4ASCRgX62aBEeNE3Yh0ZHTr9ifYokRfTYz8Op6566CgFoExCpIdV/IVubZK9H7O+QBBdsZsk9YnPd/h9vK+quQ7GyDV0GP/cYbOQr7c/n/wUMS9SnFQgQtjyH92dZFDYG/jiWNoUqMQkxw5lRjz0gbyH4V3lyoZ4/amUPM+AbrXt30E9nTZpuqdBCQbqVQH1HwkuSXH0AZe3JmRwU4/XdIT0WY+H4X68h2a0Q=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ea71b0-21ea-4fb7-8f9b-08d6d1f9b11a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 08:06:06.6682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/6/2019 9:40 AM, Herbert Xu wrote:=0A=
> On Fri, May 03, 2019 at 03:05:48PM +0300, Horia Geant=E3 wrote:=0A=
>> The detection whether DKP (Derived Key Protocol) is used relies on=0A=
>> the setkey callback.=0A=
>> Since "aead_setkey" was replaced in some cases with "des3_aead_setkey"=
=0A=
>> (for 3DES weak key checking), the logic has to be updated - otherwise=0A=
>> the DMA mapping direction is incorrect (leading to faults in case caam=
=0A=
>> is behind an IOMMU).=0A=
>>=0A=
>> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> ---=0A=
>>=0A=
>> This issue was noticed when testing with previously submitted IOMMU supp=
ort:=0A=
>> https://patchwork.kernel.org/project/linux-crypto/list/?series=3D110277&=
state=3D*=0A=
> =0A=
> Thanks for catching this Horia!=0A=
> =0A=
> My preference would be to encode this logic separately rather than=0A=
> relying on the setkey test.  How about this patch?=0A=
> =0A=
This is probably more reliable.=0A=
=0A=
> ---8<---=0A=
> The detection for DKP (Derived Key Protocol) relied on the value=0A=
> of the setkey function.  This was broken by the recent change which=0A=
> added des3_aead_setkey.=0A=
> =0A=
> This patch fixes this by introducing a new flag for DKP and setting=0A=
> that where needed.=0A=
> =0A=
> Reported-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
