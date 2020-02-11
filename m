Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF086C352A3
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 14:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8397020708
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 14:39:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MrVk9xkV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgBKOjg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 09:39:36 -0500
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:44768
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728868AbgBKOjf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 09:39:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HK3O19jk4WBp/DTwBaRAG4UVxNn2AbNjuW0B2MA2h5uGbtm/1khmlg8ck2Os406nOyFO7ponB3PmNDqmN9qFDdwnMYoiNIPjHh0oqwHHgbwvGtIky25sEkwxqUV0WUtm3Vd1mtoWoU9BMHTMi/dzcDOMRtQSFGytqkuLpagmdEG8a2s6/tsdj387NbJLI+jNTUTCgRO04C1Q1sTQZzGYajs0LkayLQkrLlk4o+aEfWn9TcYiX9/SAaSDhy3YiziY5CIski1SDNHE9rCbHzhiXe6mUUsMGT/vVIeAHjqh5CCx49KKfxttc+EXsJakKLCt9LJT3OrfuI1N5+ihqV7qCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jI0Y+Wqt2jOM/oQXgfKDapBcoT2AfBndMk+X9/G2k3Y=;
 b=AMFvcNcWsh6hfvCnCo2iHYPwyhn29Jy/lxP/gN1LIszS4FK71jxWBQHJadAu2pJdmgPXbmJ+ZLHtyhv5GiqftXpqgs/Nnl3uuFZFQZQB7+NnOn5P77m8xGuVHnNl/3bh9s2HfQfvSLzd9DzLzC4+XuSgPqC4vPLWN/wB7xOvMmMS8NE1S62jkv7AjYbf8gX1V99GlAehBsvxPI+cYirBtHlRJV64Ib8+m/F1yiJFxaXotaX2VR2AnY8ihzL2UIgbfWwL77h9maXjcoAptHz7MFyxW3EkJIobnwbR/7HOic3RxiSYMPkowa+HgPxKNQeTg/6sPkdFxLAgIvTsMnLe4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jI0Y+Wqt2jOM/oQXgfKDapBcoT2AfBndMk+X9/G2k3Y=;
 b=MrVk9xkV96+2ngkiy6RXELW/xuHlxSqX496uy2JTzm2amFRsXV7ZRopu2bsb3WMS/DdTukbHA7CHdoj/Ax/dqs8R5ZZig417jpqZJgh+TZOTRkOdgmeV/uED0kgPUUKFg+SRUsIO4dYFHcTQQYV3rWCWTb6F8devrtzgGudQV9Q=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3949.eurprd04.prod.outlook.com (52.134.17.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.28; Tue, 11 Feb 2020 14:39:32 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 14:39:32 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v7 2/9] crypto: caam - use struct hwrng's .init for
 initialization
Thread-Topic: [PATCH v7 2/9] crypto: caam - use struct hwrng's .init for
 initialization
Thread-Index: AQHV1TLQxUc6zq3eJUWWauKEoHl1ZA==
Date:   Tue, 11 Feb 2020 14:39:32 +0000
Message-ID: <VI1PR0402MB3485B40FAB528ADE331F506198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46d547e3-e365-4330-e966-08d7af003540
x-ms-traffictypediagnostic: VI1PR0402MB3949:|VI1PR0402MB3949:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB39491AB76AB401497C7DD31998180@VI1PR0402MB3949.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(189003)(199004)(55016002)(316002)(54906003)(8936002)(110136005)(9686003)(71200400001)(7696005)(53546011)(186003)(478600001)(6506007)(26005)(91956017)(4744005)(66446008)(76116006)(4326008)(66476007)(66946007)(66556008)(64756008)(8676002)(33656002)(81166006)(81156014)(44832011)(2906002)(86362001)(5660300002)(52536014)(142923001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3949;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7hjnxELXT6r7KQpb6j/8Il4L+56aF5477XoXACHh0sAVNfyJiXVV/XqnLmE4I9DrwaFdFrLvdUy+woAnlbEzKKV0B7B9+88mjY/K1vi1nTAy7/7+zABhBSEk9EiNVs4zCaQrdBaWfMt8prNF+iOJomyU1E+pLbjPx8sgX1p633GZcZ/H1JbDj4NcfAeEjwYk366cfihv7DpFWSPBP/fx2rom4c5uG+1nkQSyC0zSj+IO19PjM2Zl91eFfToGUO3IhiW/bNRRjM5LdvpztNnvZrBJwu+ktm/6ENhRRQtZKKE+dXXWE5JdfyVeTRMsM5F4++yPPfqsttsBCeB85l3P4YbV1wdHHvRoZLdezkkGs39lRw0sHZlJZuG0paZvhZc+lbB3qhextgDhEa2lCfERePzGSq/eMZNAwdYfGvmIE4OTpNlucGnYW3WTzHdSvDJ86Wu1rtBZhm0+xH+8SBsVUb4RyvQ3F/0Rrc8+OF73xed6iOxGZ8mD8HukLb+t1OXw
x-ms-exchange-antispam-messagedata: Z3rDhYmlQvFBMfA2SnHsa2xY+//ouSn0uuxUcb/P/2MlSs67H0L9cizP3+cJcUoJUGfO0UZmw1c5/4V693UE7T3ISzlGG3tH6kZe8uIFrhF4tIP1P7M5GMvJg9iYrD/eCZGop8jQNTtWuxJJ9PW8HA==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d547e3-e365-4330-e966-08d7af003540
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 14:39:32.3512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dOYKntdtKKboIZWXXm1hIBLzImo5DetImMSYWOW6OENcruvNUGDJPxZKdEB2B5zn6YkAyQetA3ZajvfKmxGGlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3949
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> Make caamrng code a bit more symmetric by moving initialization code=0A=
> to .init hook of struct hwrng.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
> Cc: linux-imx@nxp.com=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
