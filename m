Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A9DC33CA1
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 10:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E29B321741
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 10:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Ff2NnP5w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBEKYJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 05:24:09 -0500
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:6043
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727367AbgBEKYJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 05:24:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVg3pNtCU/ONH5Ibg22Qor9nBbwBrRLTbL7bIfRPgC573uLbvN00qT7w7J10RpHKT96WCAmKv7GRnjVifIk7daGyPMLbl7uN9iAINFMfJYDdIND7ZyXdRp77tSrBgmgZFR+gzEQdDl+n/LKexzyMRP0wrboNsr2MmqT4q7ELuTdp2+Qfr1c8P5zW3omMvW5fqWSVge//NDJjVHZd1n/HqS3zKk5Xd+kmEU9bZdpl/Kz+UNFjXo3wfQq7KE8autDm+swQXrDcgfqQvuSQK0E3v/P8kTDvM0jbwrWw78yRkHPbtc8crdsF4cjvp2EM/TxO2GV2R+DRckWtF8AK6je34Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4zu0o4iHftSkkihVGQiWZIGln5qFQesyLKv0H/fEa0=;
 b=UXse0cOvrwBzKy1IkaZkcfMrgJxteFA6PJCkvSC0X5ZlXyhuPiD6FYYsQjnsmqD/6vKldLDBwviEVh9MnrARxPokm1aKvGknQWaH9V3gLcm0t0oFQC5f4Jf5wmb92zP9RI+Lz9r/PeLmbl+34i2PUmUYEnd6LosaVbRx8LQX0t9m8mZ7EDFldfTdGT/TWVokGcAut4COo5SPgWMvBDb8VR8TH1lNr3pfrXIjZw+WViGHLj5+e7i+SY4Mk58HPe9SWEkMswy00pNggdkuIsFpYEekzbq7Kyy7F2FRu5TFCuQD9eVtkUtKo0lyAJNO0zQ2udTEhohh9H4GSyxygR0zPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4zu0o4iHftSkkihVGQiWZIGln5qFQesyLKv0H/fEa0=;
 b=Ff2NnP5wqKgNKB2zWLJScdekrRMGPA7HGZ3F2rg9NSnWrfLdyaksnVB6rlC5UPg3PWkq9mh5t1Endrbct6meTtLXWWvUwpXO9RGiOLmCoOftoLSwoyuVnzDMv7j/CtD388xIS/ljtoLmPczWcR9+g0ZiWtvMZ59L0o1yRQkN1n8=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3918.eurprd04.prod.outlook.com (52.134.16.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Wed, 5 Feb 2020 10:24:04 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2686.035; Wed, 5 Feb 2020
 10:24:04 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: tcrypt - fix printed skcipher [a]sync mode
Thread-Topic: [PATCH] crypto: tcrypt - fix printed skcipher [a]sync mode
Thread-Index: AQHV3A3YTFyI95bRXkiCfF6hc7OJ9Q==
Date:   Wed, 5 Feb 2020 10:24:04 +0000
Message-ID: <VI1PR0402MB34852601F6A4D66FCFD482F598020@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200205101958.29879-1-horia.geanta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0472fb3d-0398-42ba-6677-08d7aa2586a2
x-ms-traffictypediagnostic: VI1PR0402MB3918:|VI1PR0402MB3918:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB39181BB1B8A4128CD7FBC8B098020@VI1PR0402MB3918.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(199004)(189003)(4744005)(52536014)(55016002)(9686003)(66476007)(76116006)(66446008)(4326008)(91956017)(64756008)(66556008)(66946007)(33656002)(71200400001)(5660300002)(54906003)(26005)(2906002)(81166006)(86362001)(44832011)(478600001)(81156014)(316002)(6506007)(53546011)(8936002)(186003)(7696005)(6916009)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3918;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PilpspIHtxlbxGSYddC0nxGQ9FyfXdRACVZ/I84kXyhEZWYzJC4WRaiPfnbbezGkD2fPVvQ/NqD7MdisswtZ/1zBLJuK8TmMthYNYdKGN+mHGd7KtZI2kkam4XAfY/wgj4fqyn3vflss92ah+Eaz+rJuJIGkWYq6tNzL4gUpnHOLwUegdNXm4LvmSpTG3oWwCDqw1RnCBfmsiabL7m4NnalVx+/lp7y6jyshsTAZc32IwAtMxt1UgeOkueQJNzTB+4oKBjMgS7XlaKCk+YLXXj60qXwzgEymGTODmrRCG3p9xP9fhBzzJaoXCV2PWitovX0PheBoZjYr56EigPcpMUDI6WQOwfHScTeAWekMSP3iKh+AZsAMTh0HzFiCe4ZMn68NnzB51fQya5v749CSlMKIl08qD+am9a2OZGOXZggEFzzOaxE+He8PYPS+4lpp
x-ms-exchange-antispam-messagedata: MK0MsHzDDnbmqRMer6nYKP5yBnwjPt52PBRQKRTkFQ3B4Mtged9OeEZWquNU0zvdwAT0Oo2g3dTSZtcS7FwpG6UCfzEtgEZp2iup23XAlFBXMWPRrqUNW0vBrAGxSvXWHcu+q2TZXq4RmAe2tn2SGQ==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0472fb3d-0398-42ba-6677-08d7aa2586a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 10:24:04.3897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LPba16qRqdz8d8PJCA2yyfNu3kcyqzAI0gE1ik0FoNo/766RZVu2DY+sQyw6B9AhlqtfFaQTtXhHYXbYh2G4kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3918
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/5/2020 12:20 PM, Horia Geant=E3 wrote:=0A=
> When running tcrypt skcipher speed tests, logs contain things like:=0A=
> testing speed of async ecb(des3_ede) (ecb(des3_ede-generic)) encryption=
=0A=
> or:=0A=
> testing speed of async ecb(aes) (ecb(aes-ce)) encryption=0A=
> =0A=
> The algorithm implementations are sync, not async.=0A=
> Fix this inaccuracy.=0A=
> =0A=
> Fixes: 7166e589da5b6 ("7166e589da5b crypto: tcrypt - Use skcipher")=0A=
Just noticed the typo in the Fixes tag.=0A=
Let me know if you could fix this before applying (in case=0A=
this is the only issue with the patch), or you want me to send v2.=0A=
=0A=
Thanks,=0A=
Horia=0A=
