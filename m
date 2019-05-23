Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E02C282E1
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 10:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF428217D7
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 10:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="gc+NxhC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfEWKCq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 06:02:46 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:45259
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726299AbfEWKCq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 06:02:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsW2rlqtoDz9NkrJW2gfwY+BZtsg/xwg3peM0Snd2Qc=;
 b=gc+NxhC9gdGksWYBg/sKdHEk1iV8UD4EZVqbZRWlycwii5iujfcGDhTbnmCdBPeEWvy0AHHoNmPWVXldT3OTqT/cwkrHy1g5dtvAOm9JBfmKKuKEJULHcpWUXojQNjFztoYIupRs00s8h73JPqmXmF8YkJlDsAq8nGbFQRcMT/U=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3457.eurprd04.prod.outlook.com (52.133.50.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.19; Thu, 23 May 2019 10:02:42 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::1cc6:b168:7419:aa48]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::1cc6:b168:7419:aa48%6]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 10:02:42 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Topic: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Index: AQHVES51mI1lYxB850GcRxowCCF+GA==
Date:   Thu, 23 May 2019 10:02:41 +0000
Message-ID: <AM0PR0402MB3476BE4FE08AC135742D262998010@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
 <20190523061202.ic2vgimgzvvm6dzc@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50572e9b-fb64-4988-b289-08d6df65cbad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR0402MB3457;
x-ms-traffictypediagnostic: AM0PR0402MB3457:
x-microsoft-antispam-prvs: <AM0PR0402MB345781EBD49F515F77CA341E98010@AM0PR0402MB3457.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(8936002)(102836004)(33656002)(81156014)(81166006)(6636002)(4326008)(186003)(68736007)(6436002)(4744005)(5660300002)(53936002)(6246003)(26005)(7696005)(14454004)(110136005)(86362001)(54906003)(478600001)(71190400001)(6506007)(55016002)(53546011)(76176011)(229853002)(9686003)(71200400001)(316002)(99286004)(44832011)(52536014)(486006)(66556008)(25786009)(305945005)(66066001)(66446008)(64756008)(66476007)(73956011)(2906002)(6116002)(66946007)(76116006)(3846002)(74316002)(8676002)(7736002)(446003)(256004)(14444005)(476003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3457;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X6zKjsQ8j/7klM7rcWxSPQzWItHu1YwLC2WgCB6f5FU6iI8GgcU5l9xeMbYu/Wvpoymyy45Wdh/xSaWcCsaChTXKv0cjWCwaXpH9l9VBL2f5yeAm/ZxB2Yno4bgDOUzNAyImeP+cV+nGydgmQFOLCVzzAtHsWB+TKbMwJ51OvPfYHZIimPVm52tLAl4AFOLngDCyMp7aezrnVtZozBQD2XLwBYWZndWo18m2ZYZgGV0EAkUI5SGEmJXptt4UKLXJs8zHP8lTS0Zzdlqp3Jvu4pLOr6+qdGGW3zVAmd78yRU7d2xS8nJ/L+rGjBVi6xjLi2F7Ut/8dgx0J/8mNCOz1/Wmj3+5WhYWIdTw6euoWByNSEY7ALhKKfAlQD+VLqPTUyQNhcJEJAEJzlKc1JsYU+8LBkHrdbljiXhBbhjSkb8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50572e9b-fb64-4988-b289-08d6df65cbad
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 10:02:41.9993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3457
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/23/2019 9:12 AM, Herbert Xu wrote:=0A=
> On Wed, May 15, 2019 at 02:25:45PM +0300, Iuliana Prodan wrote:=0A=
>>=0A=
>> @@ -1058,6 +1105,14 @@ static int __init caam_pkc_init(void)=0A=
>>  		goto out_put_dev;=0A=
>>  	}=0A=
>>  =0A=
>> +	/* allocate zero buffer, used for padding input */=0A=
>> +	zero_buffer =3D kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_DMA |=0A=
>> +			      GFP_KERNEL);=0A=
>> +	if (!zero_buffer) {=0A=
>> +		err =3D -ENOMEM;=0A=
>> +		goto out_put_dev;=0A=
>> +	}=0A=
>> +=0A=
>>  	err =3D crypto_register_akcipher(&caam_rsa);=0A=
>>  	if (err)=0A=
>>  		dev_warn(ctrldev, "%s alg registration failed\n",=0A=
> =0A=
> This patch does not apply on top of the caam patch-series from Horia.=0A=
The patch was considered a fix, and thus developed on top of crypto-2.6.=0A=
I guess you are implicitly asking to resubmit based on cryptodev-2.6, corre=
ct?=0A=
=0A=
> You're also going to leak zero_buffer if crypto_register_akcipher=0A=
> fails.=0A=
> =0A=
When crypto_register_akcipher fails, it merely prints a warning and falls=
=0A=
through (does not immediately return), thus there's no leak.=0A=
=0A=
Thanks,=0A=
Horia=0A=
