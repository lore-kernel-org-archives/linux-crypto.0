Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD643C33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 10:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57A8324672
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 10:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ltS93JHK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgANKk6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:40:58 -0500
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:51526
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbgANKk5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 05:40:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNmqgz6Jq7FeCy99BudO0gEnsgJwmoW7UrFyL1SYsrgrDyVZ7Uka+OsAQ7vkXgjbjelWu1RawQDcQw4NaS0jirQuXTxFsteUWe99oFRa4F3Xm85LkCnz+t3uJ9+Uw7lq4J60AOYnKzduN42ZQi5m9nAlD2d1s4t+PqiLSaSYd4ijvTjUNRPYVB+8H2d+gaSaLDgf7Us8a1FCN6XHWXkU/+ZL6PalLqUz5cDJnpvEN73yRQ56TKatFP6iJTwUK0qpCkFqaKuPXbvP4mBa6e5Y7Zjo+kq2usGXLH36Tcb+/RO3ngtmuzaqdVa9M85TP1LGdGTGH7TAmUUPG6OglOqufQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3ypCjYtczfO7NR9myQU4FsVPotwGShPMgzl7IrIK8k=;
 b=UYKpZrtbb+wh4eUF7chex0lidRkhAFeA34JY1bNFMeRF/q6SIabTtcjN5JNANECTJjvEBVA7JiA2LZ1VQevCbAP70JXAd0qdIlrdhWgkxXSMyCyOolI9V2x1gDYXYwbneTnFtJu8n4YJnr0RpAIjxc5YnyF1p1lX75XFporDiN9lMSlImW6tbOCqRGU9GJr4mx2K1Pcvyb0jhsEQWi34vN8QWw4tOIpLuWiK5IY8zT9KxgqdJL+hGS9+RXTXAMMF0+rqxGPm/cGc8INkhMIF6L711vvD+wZp5SvipcgHnxhKWir1vhx3220UzdqREziVI/kyMmvMrwEDSB2S6/9Jdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3ypCjYtczfO7NR9myQU4FsVPotwGShPMgzl7IrIK8k=;
 b=ltS93JHKX4/iozk8Nus53j2MA/mQPLBMUJNRKlhsLNmGRs0yli7xz8hOzpM4RfhSNUpcFSoryyc4zM1mCI+5xq27eFIuKk1fX1bDJi1236mpv4Q9tV4qRENILa026tyNhU9TDlhb6qZNNGrvJXaVXfqdKBp0HB0LYyYp2Jz8SEU=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB6960.eurprd04.prod.outlook.com (52.133.244.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Tue, 14 Jan 2020 10:40:54 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 10:40:54 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "baolin.wang@linaro.org" <baolin.wang@linaro.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>
Subject: Re: [PATCH v2 09/10] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Topic: [PATCH v2 09/10] crypto: caam - add crypto_engine support for
 RSA algorithms
Thread-Index: AQHVwdGq8oNojU3+Pkqj8F8q9Ip8Bw==
Date:   Tue, 14 Jan 2020 10:40:53 +0000
Message-ID: <VI1PR04MB4445E44C69277F17CFBDB9128C340@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-10-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB3485162217C242B16CF1371B98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR04MB44452FF06F35075413CF87F88C350@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20200114001440.baeadihvlqiucw63@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a6b0f04f-10c5-4f20-e33b-08d798de3b42
x-ms-traffictypediagnostic: VI1PR04MB6960:|VI1PR04MB6960:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB69608CE45CB018C4874215DF8C340@VI1PR04MB6960.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(186003)(33656002)(8676002)(81156014)(9686003)(26005)(44832011)(54906003)(52536014)(66556008)(66446008)(6506007)(81166006)(8936002)(66476007)(53546011)(64756008)(2906002)(91956017)(71200400001)(76116006)(7696005)(55016002)(86362001)(66946007)(316002)(110136005)(5660300002)(4326008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6960;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6z8rfFK0C6wTnCH/qN6Pl+JYanl7LZimnS9rje23x6P7fDcmFTGJAVB0CnSY6N0QNPuyQxPnqZkkQHYsqwoTVrEiPkW2GtlTMaIVBhJB2LlEJq/Tx6nje+Dc3h0AxPZyBE8xX7w8le/5qKa9Zm7agRQR5fEgUE53wW18NODRMRLNCyRPxr+1RYWo7IbmRHqTsJC6/R/IC1buzZ79gahWnWMUrcjkCKGSlNoi4EMtockoKn+tbqFlXj30WrbGS64SmYlr5skmmcm9fIrYvP33fp3T5lzRO7zvzDUKrqICAxHBW1Fy4K8oUKvZeLYGvhyN11IV/7dK2M2txQTblxdd3IKt0FuMiCykVv40CVEW2rrDqMEAVnpLCl7TOniYgNuL8OmEb8hoLdGHNf5D7FXFEfY/bJwh439WdgH9/staQW1Q10qyOVk21SvzjoHyg5K6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b0f04f-10c5-4f20-e33b-08d798de3b42
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 10:40:53.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7XqXcpGgUnQLpqSIPZ3vp5teIRza4qf0llkdYzb9jkLi1YPmpMP8f/1VQlCwhE5LUsOt8a1BnAQLoFKpdtLPDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6960
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/14/2020 2:14 AM, Herbert Xu wrote:=0A=
> On Mon, Jan 13, 2020 at 09:48:11AM +0000, Iuliana Prodan wrote:=0A=
>>=0A=
>> Regarding the transfer request to crypto-engine: if sending all requests=
=0A=
>> to crypto-engine, multibuffer tests, for non-backlogging requests fail=
=0A=
>> after only 10 requests, since crypto-engine queue has 10 entries.=0A=
> =0A=
> That isn't right.  The crypto engine should never refuse to accept=0A=
> a request =0A=
Crypto-engine accepts all request that have the backlog flag, the =0A=
non-backlog are accepted till the configured limit (of 10).=0A=
=0A=
> unless the hardware queue is really full.  =0A=
Crypto-engine doesn't check the status of hardware queue.=0A=
The non-backlog requests are dropped after 10 entries.=0A=
=0A=
> Perhaps the=0A=
> crypto engine code needs to be fixed?=0A=
To me, crypto-engine seems to be made for backlogged request, that's why =
=0A=
I'm sending the non-backlog directly to CAAM. The implicit serialization =
=0A=
of request in crypto-engine is the bottleneck.=0A=
=0A=
But, as I said before, I want to update crypto-engine to set queue =0A=
length when initialize crypto-engine, and remove serialization of =0A=
requests in crypto-engine by adding knowledge about the underlying hw =0A=
accelerator (number of request that can be processed in parallel).=0A=
I'll send a RFC with my proposal for crypto-engine enhancements.=0A=
=0A=
But, until then, I would like to have a backlogging solution in CAAM driver=
.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
