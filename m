Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B085C352A4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 18:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C0CF2073C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 18:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="VINmwlAZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgBLS5U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 13:57:20 -0500
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:11326
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727264AbgBLS5U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 13:57:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wb9rCxAgsVFsCtmuQgt8gaH9B+OFeVK9hV5xv3TWIlhZ9pf1miIS4llEVe0ts5St6LaMLFHQERL+5y3ULkNl4jygNWrk4VMeO2Hw673Hpt5+BkFMLH+sJKnm/urbPxrNrOsP9Zkg9WTGK+jAOK2kDpS4cyYohatFMyFFz69AQrGv1zCGCyYYLvIXCN+bWLCorFw0cC6C2El7n9grwLSRO9dI8yQRLrxOaDYzKnFvhkhBfPskR+PhwvL+n5nm8CwRrKgfIoFyf4GfTd9tZ9J+psDxDQ4UqMm2d7hRGBnKF/iaoIfJial0xlkRTpJT6ffafCubPMpJyzaOnv4Hsyog9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdfkrpFwOQLefZxR/BeUQEfoz8iRf3B+e8fnhjutaS0=;
 b=WPPKCvMG6BZMOTN7+p8Y5dgJeevbiPyyHlN8Z6wVBEYjY65Yr3fN9BaN8HcqWnZQ/+QnLyrws7dllRn2miF+Sm+2Wa/94t4jXIMJn2AY1vvVrBVxhV2fkb4FPb1yScRU3dtvYI1vdoY5L6aHzpDCgClzvd8PAiSR4mmjBQ1YeZUavZP03oDotZlau43xUdJufkMNnRW6OwSJDAUj9J18wQUH9ZVfj5wiskbWBpd2XBbQg4WRzPlSZJLPFft0BgRVK7UUqL+wjcJ9ZAAipoi5rECNCJrTwqPtmh88bD4HU2aEsuG2/SF61UNiKrHQwPhTp2iCyM/R47Ez+59lNvfOOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdfkrpFwOQLefZxR/BeUQEfoz8iRf3B+e8fnhjutaS0=;
 b=VINmwlAZ84/sKv2ywxOtqVt/IpG31psjqnOz5rUHaXOyJ7aei3iuU8jMfYIxGRmb8lMlCyl9sgA6agF9crPmabrnRiqg3bmar6vAGfGfmsI75XfA62YYaGvTGZS0DezNolmAfUH6wfuU0CyE6fIWuowWTpFt+O0ptLa33lULPCU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3743.eurprd04.prod.outlook.com (52.134.16.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 18:57:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 18:57:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 7/9] crypto: caam - add crypto_engine support for AEAD
 algorithms
Thread-Topic: [PATCH v6 7/9] crypto: caam - add crypto_engine support for AEAD
 algorithms
Thread-Index: AQHV4c2x1+YQxFt3mEyIKbxGQppZYQ==
Date:   Wed, 12 Feb 2020 18:57:15 +0000
Message-ID: <VI1PR0402MB3485A0377A3AA3F7A69ADD94981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
 <1581530124-9135-8-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7c27ade9-80ea-425d-a4e1-08d7afed60b3
x-ms-traffictypediagnostic: VI1PR0402MB3743:|VI1PR0402MB3743:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37437D09F0DE90BEBD50724D981B0@VI1PR0402MB3743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(199004)(189003)(186003)(26005)(4326008)(91956017)(7696005)(478600001)(76116006)(44832011)(9686003)(4744005)(55016002)(64756008)(66476007)(66946007)(6636002)(8676002)(54906003)(110136005)(5660300002)(81166006)(8936002)(66556008)(66446008)(86362001)(52536014)(2906002)(33656002)(316002)(53546011)(81156014)(6506007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3743;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EgArPRZQsHDgEQbepV98kxzJnR48fEEW0Spum6BRBErgYvouvZWw3JuM1gZTO+TK8VvGO1DWEv739L3hZKxQHIYFp81W2D+cGW+wiveJ9ByEibUm1xnDrP3znvwh5Krh1e8TJbuxGCxS09LKeYvNm77RGw9jSdCm2VroVEiksZCRvCFG4zmqRwmA4Hjg1aX+Knde5R5BgYUNybcus3VZVzvMz3d+zbBR1Uu4/5Q5Owd65rcW+BpC6D/UuMPrNzTUnY+l985DcPmVtmfs4xPaohLo94yIcGRfF8IeKV6K17hBDoEGbwZRH2cPANprOuBLyIs2HL71RIWkbNrTeo6I0RIsRPsbie4Ck2gxhKCQnirC8cB9H5RuMQS/Pgs2lyBNFh4aRIE0COsUiVYKhVh4Vn/iJbOVk6cZR9V66MuHzhCBqR/kXldFOQgWGrfjGff3
x-ms-exchange-antispam-messagedata: +J3GWWc3eDZilDaF0vAa3wStM1bmEad/aP6+kt8jnf+BlYncvV2TfQerhUpZLOcHRTzqz7fld2R0ehcBc4cS9GZXunJs/S+T6Kz11EKVp7b2mnraNvDazoyAyVKm7UfzLh8dD8TuM/BFyTX3sxjOcQ==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c27ade9-80ea-425d-a4e1-08d7afed60b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 18:57:15.9111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tylmQnFHautQ/lpniiksniwwaMaTCukE0ikPDMJBq5IWMWam404b5isXMxqrst5Xkx3yMR6xVwc4NE9YdgSrXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3743
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/12/2020 7:56 PM, Iuliana Prodan wrote:=0A=
> Add crypto_engine support for AEAD algorithms, to make use of=0A=
> the engine queue.=0A=
> The requests, with backlog flag, will be listed into crypto-engine=0A=
> queue and processed by CAAM when free.=0A=
> If sending just the backlog request to crypto-engine, and non-blocking=0A=
> directly to CAAM, the latter requests have a better chance to be=0A=
> executed since JR has up to 1024 entries, more than the 10 entries=0A=
> from crypto-engine.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
