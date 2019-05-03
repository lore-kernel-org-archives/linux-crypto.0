Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E3CC43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 405BA2075E
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aRqx4I8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfECNZX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 09:25:23 -0400
Received: from mail-eopbgr00040.outbound.protection.outlook.com ([40.107.0.40]:34375
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfECNZX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 09:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jiolykk9X1ca21pgHTZLJMwTtcUujJTTXj+sI1ti7Vs=;
 b=aRqx4I8ZH4++YmBLDP6hsR9RijFR1OE6CvhCaqotuPW3T1G7GRx/ooBxn8H2LeUazl60CNzH8DABJk+QtwzgNJ+F5p2ikBJxwm9SfdTBVdR0bGyxRMdFYuEmuRxWMPT+MRaT6PYKFAAfj3d0SW3Pm2nRS5hTr2POECvARGFBbps=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3375.eurprd04.prod.outlook.com (52.134.1.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Fri, 3 May 2019 13:25:17 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1835.018; Fri, 3 May 2019
 13:25:17 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 3/7] crypto: caam - convert top level drivers to libraries
Thread-Topic: [PATCH 3/7] crypto: caam - convert top level drivers to
 libraries
Thread-Index: AQHU+4N5g9H/2PNb1ESwjP342qcqNw==
Date:   Fri, 3 May 2019 13:25:17 +0000
Message-ID: <VI1PR0402MB34859CC7D78081E33A4BA24498350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
 <20190425162501.4565-4-horia.geanta@nxp.com>
 <20190503060524.kyc3ktst5k3hu2kb@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d1caaa9-209b-4df5-bb40-08d6cfcac869
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3375;
x-ms-traffictypediagnostic: VI1PR0402MB3375:
x-microsoft-antispam-prvs: <VI1PR0402MB3375068867F0D04975236FFB98350@VI1PR0402MB3375.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(39860400002)(366004)(346002)(199004)(189003)(2906002)(14454004)(7736002)(478600001)(86362001)(186003)(305945005)(52536014)(76176011)(486006)(74316002)(5660300002)(25786009)(6436002)(81166006)(55016002)(8936002)(102836004)(53936002)(68736007)(26005)(81156014)(9686003)(8676002)(6506007)(53546011)(6916009)(99286004)(44832011)(256004)(229853002)(66066001)(4326008)(66476007)(66946007)(66556008)(66446008)(54906003)(64756008)(33656002)(3846002)(14444005)(71200400001)(446003)(73956011)(76116006)(316002)(7696005)(476003)(6246003)(71190400001)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3375;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r47EAe/R5S3Of/BIxANtFvX4MZQshFrZOi583cqAHnN/BlsN0CFSmEXJ4Y4QfCmQjTsWIx+go0aV3yqxefcaveOOvVMU9NHktmQM1ltph1cjI6aAoNxfji6UbxcnrUaqjA12bKxIn/uWv+7zf8NWYr55QKSkOqN4iJuXhX212jXDvDPfDnzRh0W6v0k9FrnPYIFrZWKHPrsaZQPDlE79E9lnvzTG3J9fYQ9wwrOZpTxvoJEAXN2x04Ltmhjh6Elb4ememDCDhQCGsTSJLbeG6C3Ygw3R6dsy1uEnmKngKe34N+eI9eMQ6+yJd0F6wLcPJJYonjpiTZknI8EsMiFuDqeBV+g5lL2heizbpoiRtU1S8h1VUkgPtQsrpjnDIFXEkO3wBXmqlu3MGBmJc5Mshe6ujocWAkwwAJfWdB6jM78=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1caaa9-209b-4df5-bb40-08d6cfcac869
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 13:25:17.0378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3375
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/3/2019 4:08 PM, Herbert Xu wrote:=0A=
> On Thu, Apr 25, 2019 at 07:24:57PM +0300, Horia Geant=E3 wrote:=0A=
>>=0A=
>> @@ -3511,43 +3511,17 @@ static void caam_aead_alg_init(struct caam_aead_=
alg *t_alg)=0A=
>>  	alg->exit =3D caam_aead_exit;=0A=
>>  }=0A=
>>  =0A=
>> -static int __init caam_algapi_init(void)=0A=
>> +int caam_algapi_init(struct device *ctrldev)=0A=
>>  {=0A=
>>  	struct device_node *dev_node;=0A=
>>  	struct platform_device *pdev;=0A=
>> -	struct caam_drv_private *priv;=0A=
>> +	struct caam_drv_private *priv =3D dev_get_drvdata(ctrldev);=0A=
>>  	int i =3D 0, err =3D 0;=0A=
>>  	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst=
;=0A=
>>  	u32 arc4_inst;=0A=
>>  	unsigned int md_limit =3D SHA512_DIGEST_SIZE;=0A=
>>  	bool registered =3D false, gcm_support;=0A=
>>  =0A=
>> -	dev_node =3D of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");=0A=
>> -	if (!dev_node) {=0A=
>> -		dev_node =3D of_find_compatible_node(NULL, NULL, "fsl,sec4.0");=0A=
>> -		if (!dev_node)=0A=
>> -			return -ENODEV;=0A=
>> -	}=0A=
>> -=0A=
>> -	pdev =3D of_find_device_by_node(dev_node);=0A=
>> -	if (!pdev) {=0A=
>> -		of_node_put(dev_node);=0A=
>> -		return -ENODEV;=0A=
>> -	}=0A=
>> -=0A=
>> -	priv =3D dev_get_drvdata(&pdev->dev);=0A=
>> -	of_node_put(dev_node);=0A=
>> -=0A=
>> -	/*=0A=
>> -	 * If priv is NULL, it's probably because the caam driver wasn't=0A=
>> -	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.=
=0A=
>> -	 */=0A=
>> -	if (!priv) {=0A=
>> -		err =3D -ENODEV;=0A=
>> -		goto out_put_dev;=0A=
>> -	}=0A=
>> -=0A=
>> -=0A=
>>  	/*=0A=
>>  	 * Register crypto algorithms the device supports.=0A=
>>  	 * First, detect presence and attributes of DES, AES, and MD blocks.=
=0A=
> =0A=
> This introduces two new warnings regarding unused variables.  Please=0A=
> fix and resubmit.=0A=
> =0A=
Ouch.=0A=
This is due to developing on linux-next followed by incorrect merge conflic=
t=0A=
resolution when moving to cryptodev-2.6 tree.=0A=
Will resubmit.=0A=
=0A=
Thanks,=0A=
Horia=0A=
