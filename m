Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B32C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20D8E2087F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IEQTu8uc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfG3MJA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:09:00 -0400
Received: from mail-eopbgr10080.outbound.protection.outlook.com ([40.107.1.80]:38454
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727561AbfG3MI7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:08:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaHlEDWbv4/Sl1QKOI6VFleandBG+0Op/11+278tTWQdh8EKFWH9hMprmoXvEI27qkgQYea+PEOhZaS+wcbcy/q9W+gVWo+zj7989CWkZ77Do7jxp5yUXFEt1iFZ/ZXWYKALDgJ27TUc6GsQBrKUON2wqtid2+sbOz+Tqk73OPRzqita/GyLfZCM4z2VSYX5h0h9fCS1gFRbP/yRCs377+PTFbGqVeqJ0Fos2B5t6vGnPWp3/z2xceYa0+kpN54ONAp2ahTBXvFeqMPJeHum2u0vyUYkl9JhC474TPfpRVjkRC6TjvFWiIimSqQXJJOneX49yDBOzPbvpDsfUq5XBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnA17Rl/Si7Qzb5GcC1LQm/ImxXKefEXEML+rwxUEig=;
 b=gVc4+yRSY/xusiq4KXVBIX6+D/uxSJRko1px59cIqgSyDq8qJnsQVLL/hj2nnim9yPBv9z8rT5sudxnGEuLRdLzCrW+XAyrWVzyeTBk6xBYBTQF2ONnRqwdgHtfVAWSQQblcMwj1hNrmt+9fS3P8if5o0WB0zMnrolwHZYbOZClomCCgl01M+F9vaV99hOLAVgV3M7ZevLoV60mEnCvkKVc2+Db9cVcgUl7sMOdeCGEPFcjnSQVeECI+8F1w9m1pJBvF8j93DAJpL1uQHT+rD4+FSeHw9ngyejEgOI9XjpI4OXKNECstvFO2JkaVgY2wvxrN+E9eIJ3bK8GH/Us6gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnA17Rl/Si7Qzb5GcC1LQm/ImxXKefEXEML+rwxUEig=;
 b=IEQTu8ucenfaSs2OnlWgjC919sPoi7qp+NsaJYuhcf72csSq5y7Z/JtmrNDx8AZ/mUZoE4hkrHMG1HtKBCAl8FDOkx8i2/9Q/EfFySpanEt7WWFdDhx/SkZyqiETmnxTr6MCcSQLofg/ZPw1FCsewN5GhRm4LXgK4lK5lYYzpOc=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5166.eurprd04.prod.outlook.com (20.177.50.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 12:08:55 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 12:08:55 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 01/14] crypto: caam/qi - fix error handling in ERN
 handler
Thread-Topic: [PATCH v4 01/14] crypto: caam/qi - fix error handling in ERN
 handler
Thread-Index: AQHVRsbjjJcTdui1rUy/A3tkeP7Ozg==
Date:   Tue, 30 Jul 2019 12:08:55 +0000
Message-ID: <VI1PR04MB4445B5459C40E99E386005F88CDC0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1564484805-28735-1-git-send-email-iuliana.prodan@nxp.com>
 <1564484805-28735-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a759a979-7122-4ae2-5754-08d714e6b1c0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5166;
x-ms-traffictypediagnostic: VI1PR04MB5166:
x-microsoft-antispam-prvs: <VI1PR04MB51669E2530720A1AB2B982918CDC0@VI1PR04MB5166.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(199004)(189003)(86362001)(110136005)(4744005)(66066001)(6636002)(476003)(53546011)(14444005)(7696005)(8676002)(44832011)(81156014)(76176011)(14454004)(186003)(229853002)(81166006)(102836004)(478600001)(26005)(7736002)(8936002)(6436002)(68736007)(33656002)(486006)(54906003)(6506007)(2906002)(316002)(66446008)(66476007)(66556008)(64756008)(66946007)(91956017)(6246003)(25786009)(4326008)(53936002)(3846002)(256004)(6116002)(74316002)(9686003)(52536014)(305945005)(5660300002)(55016002)(99286004)(446003)(71200400001)(76116006)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5166;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pO+HxbA9zRoRN19KPq90Ax7yyUogQU1oCYJmuRDH5KPKgxyoB7kB6pRjx50aClVEdfi7NKXs7mqB5wKFEi/nJ4n7uvhRK0oHN4kutK+nTOEF6G7LvQcLjQqoeNubS0IQ2SrIrmRHOs3bSDG5KGe8YozeGIW9v+AQgYk6GQWru0XOkwFHrWJdOGeC2THPUWS0OpTuZ8q0KH00HxqU6b9esxWVxch24Z0odlh8kTZliZ6kM86rf8muWtrACKS9Itcd9rKOu1kjQXRRJrq2z0WG5VO74l1KjfSit5egbdBC4U6Lsuyf4awtV8+bfOP4EXFSCkJh67kWuaGz5ONGeUX7sELrEt9nuAhLRYJvLTRxqW+u9Vbd4BZ8JBgGGidfOlYMRHXFwjUXS7M3hi9tXt8RnkzogdDQQGfWQAxHc8tHPq0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a759a979-7122-4ae2-5754-08d714e6b1c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 12:08:55.1671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5166
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 2:06 PM, Iuliana Prodan wrote:=0A=
> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> ERN handler calls the caam/qi frontend "done" callback with a status=0A=
> of -EIO. This is incorrect, since the callback expects a status value=0A=
> meaningful for the crypto engine - hence the cryptic messages=0A=
> like the one below:=0A=
> platform caam_qi: 15: unknown error source=0A=
> =0A=
> Fix this by providing the callback with:=0A=
> -the status returned by the crypto engine (fd[status]) in case=0A=
> it contains an error, OR=0A=
> -a QI "No error" code otherwise; this will trigger the message:=0A=
> platform caam_qi: 50000000: Queue Manager Interface: No error=0A=
> which is fine, since QMan driver provides details about the cause of=0A=
> failure=0A=
> =0A=
> Cc: <stable@vger.kernel.org> # v5.1+=0A=
> Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend sup=
port")=0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> ---=0A=
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
Thanks,=0A=
Iulia=0A=
