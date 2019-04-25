Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDB9C43219
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 18:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 232C420578
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 18:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="fHFO05Sx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfDYSoB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 14:44:01 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:37761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbfDYSoB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 14:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02+rVAEz+XvTAvpfSNB4GQtgpSTFDSxcv4/zVb0aRMA=;
 b=fHFO05SxTCvRCb0VcaroElnqK0B8KStsVTEGW910ffVQ2cw36ptK+gX2gsDegwLE73V+MOJAhpBAOIHcixWLRuJTIIknAZVAtxN53aLjvliJEceGlbRuUdbDRcTHw0CVHFAr0jttNGgcpFDCyZJLg9TvzXVjcgfJac/AJ310UPI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3823.eurprd04.prod.outlook.com (52.134.16.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Thu, 25 Apr 2019 18:43:58 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1813.017; Thu, 25 Apr 2019
 18:43:58 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/3] crypto: caam/qi2 - ahash fixes for 5.2
Thread-Topic: [PATCH 0/3] crypto: caam/qi2 - ahash fixes for 5.2
Thread-Index: AQHU+3aJRC0xHP1GxkedpAY0R95qkg==
Date:   Thu, 25 Apr 2019 18:43:58 +0000
Message-ID: <VI1PR0402MB34858A47B8E703B556AC1EAA983D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190425145223.28603-1-horia.geanta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ca2c884-f4b2-4188-681f-08d6c9adfa33
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3823;
x-ms-traffictypediagnostic: VI1PR0402MB3823:
x-microsoft-antispam-prvs: <VI1PR0402MB38238CF5836AC95B229824FB983D0@VI1PR0402MB3823.eurprd04.prod.outlook.com>
x-forefront-prvs: 0018A2705B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39860400002)(396003)(199004)(189003)(3846002)(6116002)(76176011)(73956011)(53936002)(66066001)(33656002)(86362001)(256004)(99286004)(14454004)(7736002)(76116006)(74316002)(52536014)(4326008)(25786009)(97736004)(7696005)(53546011)(6916009)(305945005)(102836004)(478600001)(91956017)(26005)(186003)(6246003)(66446008)(54906003)(64756008)(66556008)(66476007)(229853002)(44832011)(8936002)(476003)(81166006)(558084003)(446003)(486006)(6506007)(6436002)(81156014)(55016002)(8676002)(71190400001)(68736007)(2906002)(66946007)(5660300002)(71200400001)(9686003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3823;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mvaSf6jtPb8tJZA297yp7K2XIdVqQLsrB0tsiTtsQIj8NzyVIRmf6rHFs3LlQs2WUQw6OQC8lKNnXmiMe+VAy8b2HT2K8DRKggwJeWP2wpw7VW+B9bvxNbKw8S8bB8gF5Y1HJ9xfAQr5eF+xzgomtFxrRWRBJ40PRKfHI4dU2scZg7ZCSFICw6sZaY4R6uaF0qjIpfsCIUA3guqzp6+qajShLt2rvKrgfF40aUKzvzpZmzLGYLNqulOBWwwgEpvxiFcD3/QfAGw4zjzzMZBHaUu8NIp8DBZpKE3puslrpVS+W5MBtllGrTLscux1HkW7qR5KBYnB41jQ+5y9dQa6kdU659QLT+Kumd7ZF32YThZshjHuZwi/AfkfIc3C7FLU3VpnE45fRpOK536f67Shk1Y02V9zRic9hWRIqODHAdo=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca2c884-f4b2-4188-681f-08d6c9adfa33
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2019 18:43:58.2371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3823
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/25/2019 5:52 PM, Horia Geant=E3 wrote:=0A=
> ahash implementation in caam/jr driver has undergone a few=0A=
> DMA API related fixes.=0A=
> =0A=
> This patch set contains similar fixes for ahash implementation=0A=
> in caam/qi2 driver.=0A=
> =0A=
Sorry, I meant "for 5.1" - of course, if it's still possible.=0A=
=0A=
Thanks,=0A=
Horia=0A=
