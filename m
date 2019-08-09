Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582D7C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 07:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B082086A
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 07:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="VTIBBCDX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405825AbfHIHoY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 03:44:24 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:43203
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfHIHoY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 03:44:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNhxpVRu6Tygv+cjYZnfUAuaM/HumANV9fTqWPPXbrQjIDmzCJhdKwD+dqcGLiFOj+cXAD7xDOStLxyodqPoCqTb4YIg1OEK8si0tZVtLJGv8dCHVqvRXxOopxidvig5+UdE6BnGnYDEuudVZC4Y6b2idpGKYMrJUE822gWNszt+ih735Cu2rPRLhPZWS7jD9QXCQisn1t0h4mh+nsw26hX3/30aVp25l3UPGh46G3Al4BdAzV6/KpMPGDkXtzU9gqWK5GS7SE+Zv/54MyhIv3d81Hke6RokNSNZyAlios1iD+I0lUEE1BAeY3Bpue1zH0XRPIc4GG945dn2A/x39w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TejtegoLuEy0HNXcTHoVu1dk03K686SpcV5ScJuhLAM=;
 b=NaM0ox0P6SsHkxTQlhhYgGiA/p8cAXqqR6cedfksdlD4ZysP08QVBHI2eyrJNFmv4KxaznJa8sNBXUR3Oy4ZGT9nfOdsvHQvWP7G29K/Mq7tK4ePJjfCLOpXshSNFxPhjJ0kUfkl6bA/O/5Z4uSdQV28UHM814koJASzvQyFCf+mAW90GzlcPCo8elGywE8TDyfAiANdZGMpyNi8SZdtDKULpJUAl0OopDT2yQqsCQ2DxBzqxtYyq+ZPZSWnW8D+6LaWEHWwezIwE/hJElA8EImpXd0sJ2rdcA0VeUZ+Q3AEZdurMEEZ586i5CSTedI4fJeTP7wYA3qijJE7y47TSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TejtegoLuEy0HNXcTHoVu1dk03K686SpcV5ScJuhLAM=;
 b=VTIBBCDXCkTWdOVvgKpaUtXJKIyzw3LRo/qqrQsgYk2Wu7e943FQ+m1JtfGJ/cXm25/wiP2oS0QIYMBhrt9Rq03JFbTJe2SyPzQuJoX14Lgzjf30xK/a+DYMmxVFCAzOgT8b0fjUJgkyIYLc7tGEoUl6mSkKuxuGUCBoJsIlKCk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2718.eurprd04.prod.outlook.com (10.175.21.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Fri, 9 Aug 2019 07:44:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617%7]) with mapi id 15.20.2157.015; Fri, 9 Aug 2019
 07:44:19 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Milan Broz <gmazyland@gmail.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDg==
Date:   Fri, 9 Aug 2019 07:44:19 +0000
Message-ID: <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
 <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190809024821.GA7186@gondor.apana.org.au>
 <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cf79cac-4fda-4dfe-ff35-08d71c9d634a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2718;
x-ms-traffictypediagnostic: VI1PR0402MB2718:
x-microsoft-antispam-prvs: <VI1PR0402MB271849AF7ED002DA258713A798D60@VI1PR0402MB2718.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(199004)(189003)(8676002)(66556008)(76116006)(66446008)(66946007)(8936002)(14454004)(74316002)(5660300002)(66476007)(91956017)(64756008)(3846002)(66066001)(6116002)(186003)(7736002)(478600001)(86362001)(6506007)(53546011)(44832011)(110136005)(316002)(446003)(25786009)(476003)(52536014)(486006)(26005)(53936002)(229853002)(256004)(6436002)(9686003)(81156014)(2906002)(81166006)(4326008)(305945005)(6246003)(99286004)(55016002)(54906003)(71190400001)(71200400001)(102836004)(7696005)(33656002)(14444005)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2718;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7UomAyfP9Oah7jwr2CiHM5332KEUShYw3O2lGrxI4Fpd6FxzdDSziBFuuyNMo4z2Yv/g/n6MB/zoARDsXx75Ekitnt4SBKcTthMdPULlfi5EzErOR/mpFAQqCLHRL/dFphqKO7Lcew6W2RYLIMI97kBsH7P8eJrvEpL/EdU7DfMob2/BGj/nkPZM55skD46pGLiH8sb3c7bfjTilUvOuip88G14TXIuSCwApY3TaDFNeNo6XQoPyJxz4IQArKMpEZJte25inusS5rUOfGy6OTsQJ1SaFoGiU2Mr7yDDXbgmXe5TYGP2SQYd8GNh7uU7Oxgll0qtxLFTX5T76bFKorp5IflJaBUaqkUquImuwO6zIAt71zWKXW+Dei2NSIYKyMibDFQ1KVKO3DWu1Y1FfYrF4E5VgLVTzHsP1hFkTjXw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf79cac-4fda-4dfe-ff35-08d71c9d634a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 07:44:19.6487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HdNPswYI6IVXW2eGafiQOW5dajuFLm+1ENdT9r3kPSuj6Q/7dvKsToqCmzV6QlaVSab6JYWbIsL30HBQFQvZgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2718
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/9/2019 9:45 AM, Ard Biesheuvel wrote:=0A=
> On Fri, 9 Aug 2019 at 05:48, Herbert Xu <herbert@gondor.apana.org.au> wro=
te:=0A=
>>=0A=
>> On Thu, Aug 08, 2019 at 06:01:49PM +0000, Horia Geanta wrote:=0A=
>>>=0A=
>>> -- >8 --=0A=
>>>=0A=
>>> Subject: [PATCH] crypto: testmgr - Add additional AES-XTS vectors for c=
overing=0A=
>>>  CTS (part II)=0A=
>>=0A=
>> Patchwork doesn't like it when you do this and it'll discard=0A=
>> your patch.  To make it into patchwork you need to put the new=0A=
>> Subject in the email headers.=0A=
>>=0A=
> =0A=
> IMO, pretending that your XTS implementation is compliant by only=0A=
I've never said that.=0A=
Some parts are compliant, some are not.=0A=
=0A=
> providing test vectors with the last 8 bytes of IV cleared is not the=0A=
> right fix for this issue. If you want to be compliant, you will need=0A=
It's not a fix.=0A=
It's adding test vectors which are not provided in the P1619 standard,=0A=
where "data unit sequence number" is at most 5B.=0A=
=0A=
> to provide a s/w fallback for these cases.=0A=
> =0A=
Yes, the plan is to:=0A=
=0A=
-add 16B IV support for caam versions supporting it - caam Era 9+,=0A=
currently deployed in lx2160a and ls108a=0A=
=0A=
-remove current 8B IV support and add s/w fallback for affected caam versio=
ns=0A=
I'd assume this could be done dynamically, i.e. depending on IV provided=0A=
in the crypto request to use either the caam engine or s/w fallback.=0A=
=0A=
Horia=0A=
