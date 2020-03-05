Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58679C3F2D1
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 16:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25A0020637
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 16:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="HdyEWBeb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgCEQsM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 11:48:12 -0500
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:31807 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgCEQsM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 11:48:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1583426890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5Puqy9yI7JgdwGwojW1NcsFNpiHcJichm2gxg3ZJ/k=;
        b=HdyEWBebkH8jJrd0SzGnwLumCHzH6iFNWM8bkxdSLuiN2vljMI1Vb7z0sER7s7QYVMulNH
        tHLaRcKeLjxraR8X0YaZmPlyfaNHzVtQSsFjeEh4xtTixs0uwJvQJGkwvLVXKhtHgayPKj
        aIwMEVP7U0/a0HmIGOSdU8wUeOKGjkc=
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-rXAOwNMyNGCCnSkk0dt39Q-1; Thu, 05 Mar 2020 11:48:09 -0500
X-MC-Unique: rXAOwNMyNGCCnSkk0dt39Q-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3651.namprd04.prod.outlook.com
 (2603:10b6:910:8f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Thu, 5 Mar
 2020 16:48:06 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda%3]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 16:48:06 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC] crypto: xts - limit accepted key length
Thread-Topic: [RFC] crypto: xts - limit accepted key length
Thread-Index: AQHV8Gr7c7FFE6Bn/kS7vrAYuVJAN6g09vgAgAHW44CAAAkGMIADTCMAgAAOtN4=
Date:   Thu, 5 Mar 2020 16:48:06 +0000
Message-ID: <CY4PR0401MB365264BDC0F6ECE487E826A9C3E20@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <b8c0cbbf0cb94e389bae5ae3da77596d@DM6PR20MB2762.namprd20.prod.outlook.com>
 <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <c69cebf0d6cb48ff93389d73dea6ba3e@DM6PR20MB2762.namprd20.prod.outlook.com>
 <CY4PR0401MB3652485437D698D9F9FD1603C3E40@CY4PR0401MB3652.namprd04.prod.outlook.com>,<a9b2a676329c4905be6efe088cbb7663@DM6PR20MB2762.namprd20.prod.outlook.com>
In-Reply-To: <a9b2a676329c4905be6efe088cbb7663@DM6PR20MB2762.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccf0e84d-6443-413b-3390-08d7c124faab
x-ms-traffictypediagnostic: CY4PR0401MB3651:
x-microsoft-antispam-prvs: <CY4PR0401MB3651747009A118EADA1C9989C3E20@CY4PR0401MB3651.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(346002)(39850400004)(366004)(199004)(189003)(6506007)(7696005)(81166006)(478600001)(81156014)(2906002)(8676002)(186003)(86362001)(26005)(4326008)(55016002)(71200400001)(66476007)(5660300002)(76116006)(91956017)(66946007)(66556008)(66446008)(52536014)(9686003)(64756008)(33656002)(8936002)(110136005)(54906003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3651;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4TpjahJxqI3SA+OZaCKPMfMBGUQqzLFiS/YqAf0G8/xDiDAGr/sOmFRGU7o341NYiFC5c070T3o57+6m5yaWjXX8wGYeuUctEEOTiz3ANBGaB7scO9MSE567EB+92z4qBWnKG4zlqkTM+jcP40CphrEoj9tjhslIp9u9JgMoQ2ez9U8/50JPGBote2/249cUcQ94DqmcPDvDufoH4seJbQxBRu6F9Z3UY7cxXovYZCPcKtm3SbefqNY6Qd14tgPxDE4OJ7P2dlxHi0tmNvnL6qMnX4svnosVvVJql7VdvyqGN+prHH7Vyw0CtWID9+fLra0UBJAYvhlR5oDKQUcLxPLvuGUT4eJt1uHxjvcpe/U1ZAYz2qqSGZZNkrEQEmgAX9LgZag7oGfyMGIcTTBHn2WuIvhHkGIXPVkukYf/kxWld3ed78lmvRqJmhFDfIVl
x-ms-exchange-antispam-messagedata: h+XzHVd43AQsM8gZzKq+7aHuziyXDz6dimADrLK5kcEz+YTx8tvLBwEYXf8Jj1PHw/QLLsEosSr4IKCvIzbbeozdE7WshLc+ZetIEAanveaHfBOrOjRGxIWi/FO9MY5LbfrhG/sbMZtn+YZKEH/fuw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccf0e84d-6443-413b-3390-08d7c124faab
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 16:48:06.3402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: liJCsNHA3z//I+fRB38mccsM+DLJB5j/heGw+EjHSpcTanj021esZ2K+9qAI8yNG2A7WxsR43Lw5eZhXldDpLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3651
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>> What is wrong with software fallback for the 192 bit keys in your driver=
?
> More code to maintain.
>
That applies to many corner cases not relevant to and therefore not support=
ed by "my" HW as well ...
From personal experience, it's not generally accepted as an excuse though.

> AES-XTS-192 should be:
> -either rejected (since there's a standard in place) or
>
There is a standard for storage encryption _using_ AES in XTS mode, i.e. IE=
EE-P1619, which indeed does not mention 192 bit keys.
But there is no _standard_ for _generic_ XTS mode that prohibits the use of=
 keysizes of the underlying blockcipher.
There really is no good reason to disallow the use of 192 bit keys with AES=
 for XTS. As the software implementation as well as other hardware implemen=
tations can do it just fine.
Also, making an exception specifically for one particular blockcipher (bein=
g AES) inside the XTS wrapper is pretty ugly.

> -at most made optional (allowing for implementations to *optionally* supp=
ort
> more key sizes), meaning crypto fuzz testing shouldn't fail.
>
Agree that it is a major burden on hardware device drivers to support every=
 possible corner of a generic software implementation though software fallb=
ack mechanisms. Some mechanism allowing hardware drivers some freedom not t=
o support certain corner cases that are not relevant to the scenarios where=
 the driver is _known_ to be actually used would be terribly nice.

Regards,
Pascal van Leeuwen
Silicon IP Architect Multi-Protocol Engines, Rambus Security
Rambus ROTW Holding BV
+31-73 6581953

** This message and any attachments are for the sole use of the intended re=
cipient(s). It may contain information that is confidential and privileged.=
 If you are not the intended recipient of this message, you are prohibited =
from printing, copying, forwarding or saving it. Please delete the message =
and attachments and notify the sender immediately. **

Rambus Inc.<http://www.rambus.com>

