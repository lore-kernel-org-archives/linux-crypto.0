Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F8FC352A4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 19:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AE5F20848
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 19:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MB8kHTH8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgBLTAZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 14:00:25 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6043
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727279AbgBLTAZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 14:00:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nsd8CMQAYAl6m91rkEgI0hUNq8RNt3Jkb+XXUOeIhkpHNko4+VeDK7DqWYolnEqp+wHpznMvmYQ01heqgBOtUV/GRYLwjE8zMZy3EKeZTOMsA3SryEkAjwqfVft9DS9+znydswvo1RCPuUTlqNPIcBJ8Z2pGsd6RoCT+VO644/pHQy0x7oWwmUqxob5tsMWDimP/WU33rpRyMbde7lbt9j5uLZrHJ2Jej7UMBjXNdqOSYTBZicEqDY/bOLuZx/wdBskuQj3TTqUFIIaRZ3HCpZpyrkdCscc31978uN6Bo2J31tDdQpxG8yXMDmyYEYbUlWcofPpWxFT90cjDNti8iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvWwywSExVLHf7aJUCILMfZEdbKV8YpJWBSfgagRGyA=;
 b=kBxbloYxyWFetdC7U2yubaNS8RkIQfIJXNPVEMGmsMlWm6k23//xX93GwnF56SRMNJmPDYtYd8AXDVUc73bv5YhTuGzRw6I9VesDD3HuwZzjy/h+xNAp9TNM8geIJtcThNuKDFoeWhBMPfRGhR+mEks3O2x0R0vszKCfVydtgGq57AOhW32JorkARD4gCJ2ou9sAbRV/kT2MdhHCZ7SKl7BGrAGrvDPKRZFGqg4c/GzNxoKs57hGfAd7AD4vVqSR5jzkBMysCPDP4k0ZWJpDINhOBsteiSgMYHgwyUEx+E12HFk9BGW6F5iVa6D5S9glZs167RWSCRwsrhg/lko8hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvWwywSExVLHf7aJUCILMfZEdbKV8YpJWBSfgagRGyA=;
 b=MB8kHTH8yCkYBQorxr2LLLnxxdLgSjpHtrKWlAsFCL0GZQdCMkVqosM+WUzsbYOQNkiqilimyIZWzmRL/BcP34wVOtEY1/3ESJp66EBa8ydrwW4jcOtQ0S3/taZ29jgUMjAwNnWAD1iQWWh4hS4mXGVeuyxuENvcWrDXa2RDJ6M=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2909.eurprd04.prod.outlook.com (10.175.20.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 12 Feb 2020 19:00:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 19:00:21 +0000
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
Subject: Re: [PATCH v6 8/9] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Topic: [PATCH v6 8/9] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Index: AQHV4c21U6Y++bjQ102+YQorjnUY5g==
Date:   Wed, 12 Feb 2020 19:00:21 +0000
Message-ID: <VI1PR0402MB3485B7B969B68BDCD8FED823981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
 <1581530124-9135-9-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05920c5a-6b04-42d9-9017-08d7afedcf4f
x-ms-traffictypediagnostic: VI1PR0402MB2909:|VI1PR0402MB2909:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB290936E1C5FCC1B32B4A974E981B0@VI1PR0402MB2909.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(199004)(189003)(8936002)(33656002)(8676002)(81166006)(6636002)(81156014)(7696005)(110136005)(54906003)(316002)(4744005)(5660300002)(52536014)(4326008)(55016002)(9686003)(64756008)(66556008)(66476007)(66946007)(76116006)(91956017)(86362001)(478600001)(6506007)(53546011)(66446008)(186003)(71200400001)(2906002)(26005)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2909;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MKV4DmKkf/+S41c9ZKKgwGz3qeqC90VpPQ8f/OzRrnnRe2nGu3BtBWwB7ENUx6qP8jtqDfVB8izZqoHggjMxNxOrTxLwncEFetNY9TLjz1MKo4VoGUypbJvEJMUZzGrvEECrix7DPdCispTvF3YYzQiOdJanStcgKYRjnrMSogA43JEet6vXnJfpXAhfnT8WdTMp1cYnXVBHCkmUl7EkW+5QOJrvy6MjtB+JO8wjsC123IFNq3pHOBfGLaVQmIiP7R3YDXkC21+6hjHH1CV1zVtXbVRjDoJIqn6LvNEoJ/bS+ZHNvi7ywbLVgantXeorCPPTWlaBF5f7Ogd6Ek5VwDs0xgsRNosx2a4gZYPfaA9dHCxgurXHyKbA2z814gf+v1HJ31a24+bgN8t/Brlinl0sHHJ9ng20U6j/7wc+eZGSa/4t5QpssxQnze6ZDYc6
x-ms-exchange-antispam-messagedata: 9OQMN61EB4XgF6rFpFcDyAoMKmjhhYEC1MgeIjKCiZYlwfvQ/L1eUhQco9gxvfWL6yAzDO4sehLS1qKzy00bPkDbJ9a8wYQQv1MUk+Ee/l/c0yqB/RlqrKg7BimsKZi0T6Z9de9fgkyxrd15A7SoeA==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05920c5a-6b04-42d9-9017-08d7afedcf4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 19:00:21.5672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TrC+gUIQpRaJ5bWxc45joXbwelPWPUFhh/zJtWkCnDElUxoLCpMzgYpHkCgGLzlYbpN1nqNHnoVTy+zTo3VCww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2909
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/12/2020 7:56 PM, Iuliana Prodan wrote:=0A=
> Add crypto_engine support for RSA algorithms, to make use of=0A=
> the engine queue.=0A=
> The requests, with backlog flag, will be listed into crypto-engine=0A=
> queue and processed by CAAM when free. In case the queue is empty,=0A=
> the request is directly sent to CAAM.=0A=
> Only the backlog request are sent to crypto-engine since the others=0A=
> can be handled by CAAM, if free, especially since JR has up to 1024=0A=
> entries (more than the 10 entries from crypto-engine).=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
