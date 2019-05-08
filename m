Return-Path: <SRS0=esIh=TI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30981C04AAD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 09:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E0821479
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 09:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="h/onXt5u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfEHJbM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 May 2019 05:31:12 -0400
Received: from mail-eopbgr680062.outbound.protection.outlook.com ([40.107.68.62]:62070
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726706AbfEHJbM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 May 2019 05:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyqtR7B2Lf1TKwEbmc/6VL5N+9sbm0Ga7ske+385XgU=;
 b=h/onXt5uytBSimHhzh5iN7dIuUyuq3/r6tUfVb+DalgmLH9/fVzJhwji7cnasTFGevTTR4Ic1OYpfzYR1/p4mAbOsxD8BEA73oTxH7HysnCIh4wlUUT05AFxT15dtN1yjTfx4aPeQ8eq/isUANhkpjY+oRBhF+VbxnEKzPnjFZ0=
Received: from SN6PR02MB5135.namprd02.prod.outlook.com (52.135.99.152) by
 SN6PR02MB4175.namprd02.prod.outlook.com (52.135.70.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 8 May 2019 09:31:09 +0000
Received: from SN6PR02MB5135.namprd02.prod.outlook.com
 ([fe80::2c30:d205:7e7e:adc7]) by SN6PR02MB5135.namprd02.prod.outlook.com
 ([fe80::2c30:d205:7e7e:adc7%4]) with mapi id 15.20.1878.019; Wed, 8 May 2019
 09:31:09 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: RE: [RFC PATCH 4/5] crypto: Adds user space interface for
 ALG_SET_KEY_TYPE
Thread-Topic: [RFC PATCH 4/5] crypto: Adds user space interface for
 ALG_SET_KEY_TYPE
Thread-Index: AQHUrjLRC0KQY4vUUEiutylzuXEA7qWzVM+AgJUjQyCAA8MlgIAVaNiQ
Date:   Wed, 8 May 2019 09:31:08 +0000
Message-ID: <SN6PR02MB5135CE53C3E3FB34CA5E6BA8AF320@SN6PR02MB5135.namprd02.prod.outlook.com>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
 <4735882.YQOrfzxm5S@tauon.chronox.de>
 <BN7PR02MB5124AC0C75B15E5FB66DF2B6AF220@BN7PR02MB5124.namprd02.prod.outlook.com>
 <18759853.IUaQuE38eh@tauon.chronox.de>
In-Reply-To: <18759853.IUaQuE38eh@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23aae62e-b2ff-4387-c1ec-08d6d397e72f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN6PR02MB4175;
x-ms-traffictypediagnostic: SN6PR02MB4175:
x-microsoft-antispam-prvs: <SN6PR02MB4175109B704A62A3B398BDB3AF320@SN6PR02MB4175.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(13464003)(76176011)(6436002)(76116006)(26005)(102836004)(186003)(6506007)(229853002)(14444005)(53546011)(446003)(486006)(256004)(476003)(11346002)(2906002)(99286004)(316002)(7696005)(81156014)(8676002)(81166006)(68736007)(71200400001)(3846002)(71190400001)(6116002)(54906003)(25786009)(86362001)(14454004)(53936002)(6246003)(478600001)(9686003)(8936002)(107886003)(55016002)(33656002)(66556008)(73956011)(66476007)(66446008)(66946007)(74316002)(305945005)(7736002)(64756008)(6916009)(66066001)(4326008)(5660300002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4175;H:SN6PR02MB5135.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cs4DEVNuEoMLh/XAw8Vh/k9p4FIu43uAgeZFTIEuw/jWtJcRypBkk/lpeC2RlpgIzXYaF5IZFJt6wnOKMhRHwauwmyqpmEY78GjaeyCeuSoUUXHrR2oHNklMSh/EWnOfUuuySO1zBBfBLs+pOq7ljLnFEU8d3IRQdzHUd8zXckj5jkqwueQf1CfdnFqGgbxbODhLWAmmwhfkQALtcuoovRoOkSXwXiqfb82jpEfOs9NggkPt8hD8CgdejcH+b75jAYQKjs8/06Z6kyqAQDRbaiccImGKcx5JJ1z0s6MiNjVU4F7nuddBhVPOY0fZe8ZQaTv4zWe0cqg28t216kbiTkBjry7fcjAOgnCactXbo3HYuq2QCmgB1DMjswwm1eegY/BJPOxEThkYPyOcSBVW1TYCOfkoKhahnp9xr0d7kks=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23aae62e-b2ff-4387-c1ec-08d6d397e72f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 09:31:08.9611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4175
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Keyrings is in-kernel key-management and retention facility. User can use i=
t to manage keys used for applications.=20

Xilinx cryptographic hardware has a mechanism to store keys in its internal=
 hardware and do not have mechanism to read it back due to security reasons=
.=20
It stores key internally in different forms like simple key, key encrypted =
with unique hardware DNA, key encrypted with hardware family key,=20
key stored in eFUSEs/BBRAM etc.=20
Based on security level expected, user can select one of the key for AES op=
eration. Since AES hardware internally has access to these keys,=20
user do not require to provide key to hardware, but need to tell which inte=
rnal hardware key user application like to use for AES operation.=20

Basic need is to pass information to AES hardware about which internal hard=
ware key to be used for AES operation.=20

I agree that from general use case perspective we are not selecting key typ=
e but selecting internal hardware keys provided by user.=20
How about providing option to select custom hardware keys provided by hardw=
are (AES_SEL_HW_KEY)?

Thanks
kalyani

> -----Original Message-----
> From: Stephan Mueller <smueller@chronox.de>
> Sent: Thursday, April 25, 2019 12:01 AM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH 4/5] crypto: Adds user space interface for
> ALG_SET_KEY_TYPE
>=20
> Am Montag, 22. April 2019, 11:17:55 CEST schrieb Kalyani Akula:
>=20
> Hi Kalyani,
>=20
> > > Besides, seem to be more a key handling issue. Wouldn't it make
> > > sense to rather have such issue solved with key rings than in the
> > > kernel crypto API?
> >
> > [kalyani] Can you please elaborate on this further ?
>=20
> The kernel has a keyring support in security/keys which has a user space
> interface with keyutils. That interface is commonly used for any sort of =
key
> manipulation.
>=20
> Ciao
> Stephan
>=20

