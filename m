Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DE9C33CAA
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 06:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA5A24125
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 06:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IrfQCIZ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgAUGUO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 01:20:14 -0500
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:26405
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726911AbgAUGUO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 01:20:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9+iwHGeRKCxvRzIWvQSf/iW2h2D4mE08U8h1BGEHD368RpNiv7sbtnWlknvsU4qXD2bB5kInfG8v4SmnKocH0w5ykQN2/DmwlcF1Qk6HDg8QZ2+fPIyRweVcM2apTcLe4aNpsCcKGqEVOLGXfbwMOohruMI96y7Sk3CILUizgBlGLqdyd7N9JTX5xeIIMzCDZxYS088p2LEWKgYtZk4quEii2jcFqwja4uvgbAjSumEkZMSCexm8GneFsXjT6ekiEk8uCmQhH0MIQkzHuejoeLLg4NdWFVWstLg1iJPamDhWTL3qnvYoT6wDHtap8EgMVL2O2Hm3LD9XtdikarMng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcOgTGYbpjgKfjm3xpsTp9k/yITGqmQiAh41q+c0d0E=;
 b=R9MdbLidz4R/uPFz05YzlwdfjRkJOMa6596GEIgeQwFL42e7SOTrzRDDWLT23wmfzorLSBn5Cu2l9e6az5kkbQzZgTNWbDPvQwY1zDrblSxvKsEXupeKkLnGtyz+ur/HyHTCrJaPco0YWQuJWLqZnA8igBgG7ntNYmK/9jamoTxnYOf7nlPujnQisSCYvIiTgMb7IXtSXqcue02KxjSeULDds+cpuBE8iBXABOrCvrel+uMPG1nU4Sb16aLdRbuylZKxoIbgWTasbwahR94wxcSVljxTo632dJJv+/kNu1R4/TPkOQaegMITXXo6lYLaiaQGjOUakMGJEIr8KlGu9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcOgTGYbpjgKfjm3xpsTp9k/yITGqmQiAh41q+c0d0E=;
 b=IrfQCIZ/xqtSM2NIVB13EGaeN8tqT+248v6wL4YU/MTtL/QVV884HX0Llo7yGr+WC5h8XPGsUPsicxVe1Gx2VG6JVHuDgvRX2Sx6WH08ivzZTelPI8Q2Bdf11URXbFRyWry8qn8tPAeEkimYh0+FAcHo825+uFMo9KbaAsvhPQU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3855.eurprd04.prod.outlook.com (52.134.17.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 06:20:10 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2644.024; Tue, 21 Jan 2020
 06:20:10 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Topic: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Index: AQHVxjouh/c8xz5csUKnQ9CkhtEExg==
Date:   Tue, 21 Jan 2020 06:20:10 +0000
Message-ID: <VI1PR0402MB34854643C3C96A841DA6ABDB980D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-7-andrew.smirnov@gmail.com>
 <VI1PR0402MB3485F1AF6DC4B74FF373B16998320@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ab50066-4489-4e62-c195-08d79e39f809
x-ms-traffictypediagnostic: VI1PR0402MB3855:|VI1PR0402MB3855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38555DB0A37450546D084730980D0@VI1PR0402MB3855.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(189003)(199004)(26005)(7696005)(81156014)(81166006)(8676002)(52536014)(186003)(66446008)(64756008)(8936002)(33656002)(66476007)(66556008)(91956017)(76116006)(66946007)(5660300002)(6506007)(9686003)(55016002)(53546011)(4326008)(44832011)(110136005)(54906003)(2906002)(86362001)(71200400001)(478600001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3855;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8z82s0PcmacPeGaJwcU3G6Ir5FXpeyhsaAxCH13c9UWehLHMbZVk//w+ezST6g2IQdHhNrYePhbY2PUwZO6iSPBFup1jH6e97DJRExVBmr5BVE0wAew7KwlKeEv7cxvWpAvoEeJC8LiKcPToHoiDe/zYUEmsJuyI1vQW98gbQw6MAPvSRVoSAs4VRtoZloQ+goM6XVx9aHmAOB59Ux9GonCU8JzktTvV+hJXHtUbWI3eLAeLSQeDrqk+JrpqpghEOtgeZHJzvJ0QK6MavHeyewDasSc3pF1WMkjOPKblf6EWKIOxyV5g4+edvOL4fmTcBENfwb3i0EUINZ06/9lGIdEW1t2C/jf1X61SIotR9cppF1meQGSPqjoBhSA2mykl46hW7oWbNcPUxuUahMZhs3jplKHKP6yWO8kMUfFBWnjWXi+pUavSME7BI2EwBf1e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab50066-4489-4e62-c195-08d79e39f809
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 06:20:10.6660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oVKLzoleS7mbz2nlUq6xYM+Rq7MpCqcQIK6qTXuXVpcOhqa6D1vuA5fh772/oO1FthUV8twT62GGw95XjJyBHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3855
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/20/2020 6:38 PM, Horia Geanta wrote:=0A=
> On 1/8/2020 5:42 PM, Andrey Smirnov wrote:=0A=
>> @@ -275,12 +276,25 @@ static int instantiate_rng(struct device *ctrldev,=
 int state_handle_mask,=0A=
>>  		return -ENOMEM;=0A=
>>  =0A=
>>  	for (sh_idx =3D 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {=0A=
>> +		const u32 rdsta_if =3D RDSTA_IF0 << sh_idx;=0A=
>> +		const u32 rdsta_pr =3D RDSTA_PR0 << sh_idx;=0A=
>> +		const u32 rdsta_mask =3D rdsta_if | rdsta_pr;=0A=
>>  		/*=0A=
>>  		 * If the corresponding bit is set, this state handle=0A=
>>  		 * was initialized by somebody else, so it's left alone.=0A=
>>  		 */=0A=
>> -		if ((1 << sh_idx) & state_handle_mask)=0A=
>> -			continue;=0A=
>> +		if (rdsta_if & state_handle_mask) {=0A=
>> +			if (rdsta_pr & state_handle_mask)=0A=
>> +				continue;=0A=
>> +=0A=
>> +			dev_info(ctrldev,=0A=
>> +				 "RNG4 SH%d was previously instantiated without prediction resistan=
ce. Tearing it down\n",=0A=
>> +				 sh_idx);=0A=
>> +=0A=
>> +			ret =3D deinstantiate_rng(ctrldev, rdsta_if);=0A=
>> +			if (ret)=0A=
>> +				break;=0A=
> In case state handle 0 is deinstantiated, its reinstantiation with PR sup=
port=0A=
> will have the side effect of re-generating JDKEK, TDKEK, TDSK.=0A=
> This needs to be avoided, since other SW components (like OP-TEE f/w)=0A=
> could have black keys in use. Overwriting the KEK registers would no long=
er=0A=
> allow CAAM to decrypt them.=0A=
> =0A=
Never mind, looks like there is logic in place to check whether=0A=
keys have been generated or not, by looking at RDSTA[SKVN].=0A=
=0A=
Horia=0A=
