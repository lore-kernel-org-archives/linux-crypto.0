Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD8AC43215
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 14:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12AFE22303
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 14:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Zw7y4m7G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfKSO4i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 09:56:38 -0500
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:21479
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728071AbfKSO4i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 09:56:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUUVmIT0y1/EjFRSsaJOqxLFrkQN5lnEZXwmi+O/bZg0YBFfg/v76gS2VJgACcjJeCrv+b6lbxs9HKswBrNBHJyJq6U5C/y71m34y3M/ESqW8fOVXh0ZT745VQytzFxyNPP0Z7X/2na100MAiYNSkeXOfVvJwE1ZwDhGcJk57duAnv6ocldmKmZq3Ma+EkDlZmY+Wup6vaFtAnDj8BmAL15AP7mEFK+fLgRKRq+RIOF8MUgtVM+r2nSpd1/jO3KJAzyN9Ac68gw2VA9SfOHzp35rE7yDgoYtuYlrq1EKTLSfDr1rU4DhyIk4F9Ox1iN2t7L/2e1CD93in0WQZTe+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKbjRLRfqWT6CnXo3MhHeHtqb1u69HA/nddLCOhk2K0=;
 b=Eyzw79qm248LH5myne2Aa/JJ4p6isoQ0cM3SpnNM4Wg4RFYXw0VWCt9ib+rL55eDHrikufOlQQYFWEsvXEnQFUlkYUu7/m27tn7XwNnhDjmtPI8qFMlc6EeHyjYFhqKJJa4bPiyDf6DTL7LnfH0ZorTgcduoGPQAXo2izLWQeVBQoAtzb6YJ5ytNu+7CMqCQ8Z6upKhEqbe501FnH+Sy17SRVDLWDnxjuhLS/H25R9KCN0mQA540iqnC+EFDsXkeq97sibGlCv020VAMWJ3YcosQHgKFVQ6FChhxfSSBscPT89qEfccwKS0QB4P5G5OWism+kBHZ6qxsHOZp3ejABQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKbjRLRfqWT6CnXo3MhHeHtqb1u69HA/nddLCOhk2K0=;
 b=Zw7y4m7Gtb5bSH0tKAkylDhvpUucFfxFbpRHfu05wfa4iF+2ritUSX0ut+lylIkWs31lGSPKE3NHCs2MKP8SLR6P6b0wHEk/Cf8QojFcDXCPwlDDP6U+9dYA82OW53o357Bxf0ePGUy4OyxT2KVQryQW1cUb6D6G68ET41rZUac=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3536.eurprd04.prod.outlook.com (52.134.1.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 14:56:30 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 14:56:30 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 03/12] crypto: caam - refactor ahash_done callbacks
Thread-Topic: [PATCH 03/12] crypto: caam - refactor ahash_done callbacks
Thread-Index: AQHVnZayXIBTED7Av0G5EEEbA3XwdA==
Date:   Tue, 19 Nov 2019 14:56:30 +0000
Message-ID: <VI1PR0402MB3485B14652A134EC5317B828984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-4-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: be2aa05e-28ee-431c-4cdf-08d76d00a99c
x-ms-traffictypediagnostic: VI1PR0402MB3536:|VI1PR0402MB3536:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB353677F6176400072C37C05A984C0@VI1PR0402MB3536.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(189003)(199004)(71190400001)(3846002)(52536014)(6636002)(66476007)(66446008)(9686003)(81166006)(81156014)(64756008)(66556008)(7696005)(186003)(86362001)(5660300002)(26005)(229853002)(7736002)(6246003)(14454004)(305945005)(6506007)(102836004)(76116006)(53546011)(25786009)(8936002)(91956017)(71200400001)(8676002)(446003)(66946007)(6116002)(4326008)(558084003)(478600001)(256004)(99286004)(66066001)(2906002)(54906003)(44832011)(74316002)(6436002)(316002)(76176011)(110136005)(486006)(33656002)(55016002)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3536;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DEbq5pV6bV3dEXIKV07VSioDU0GDb0kVY5kyQ/xsREoUVQKpkI9NMUveelrw1ta0jm5nCl6+t3Y9M9zmdeAAqoo7CrGLjzvEYQCYxO7sxHnIBSfTmb5dzqNHaSbLBxtN9F2nF4SInQjnC52rltFBSOjaif0eUI6O4Sn+Q11pK88DPhqVvdnUzdDoLhGBQEaCVM/FB17+vnWMrDAfx+qnr3ockQBelmHtP+HiUn2HZZxFi057GumUZYBGbamnymGVE9OySC26pK9O68sBjKp43mZsrQuclZ879xqZJmzFCdCqh31c/gp52UlisyFGPkIxcD3QAll7PAHwZy9xuKe55BCQuKYPcfmPtDwtkaXRY31A2kcTtj4pbafa/m9SR8K+GjIzQA3DMH4AkNjjloc8R/cJ3aSGAAKhxZqgSVyuBmLRalWuprhqDaToR5RlPu0q
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2aa05e-28ee-431c-4cdf-08d76d00a99c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 14:56:30.7395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OM5PWasHNwicf2lLlD+sJWneueIst8z00pxpDnSrdqYLR2m0yNlu9EHro7mu1VhwAcdWsRC5iFyaZCTILT/kdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3536
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Create two common ahash_done_* functions with the dma=0A=
> direction as parameter. Then, these 2 are called with=0A=
> the proper direction for unmap.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
