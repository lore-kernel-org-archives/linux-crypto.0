Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14337C169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 11:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C01B1218D3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 11:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MRM3pygB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfAaLVC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:21:02 -0500
Received: from mail-eopbgr00057.outbound.protection.outlook.com ([40.107.0.57]:63232
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726863AbfAaLVC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 06:21:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=np4iVlVVjD5ZmdchfxUwLwyYtImTzdPAN+O+ktISS8U=;
 b=MRM3pygB9TkVW7oz3TQHs0y6iEQd8B8cRm+OuHVqYmZ7zFX1+kTC+SSsPZ+V8RIg3Q3Bs1Qowa4yO5l+GgkNGO9IGhpLl8FBQsE20eU6nlmLbSAYSapw7LtRjwJWwbYm5a+YfA3JDRVzykVo+KqzhVuo26TfWuLQAXjo9uMIjRk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2752.eurprd04.prod.outlook.com (10.175.22.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.20; Thu, 31 Jan 2019 11:20:59 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1558.026; Thu, 31 Jan 2019
 11:20:59 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Arun Pathak <arun.pathak@nxp.com>
Subject: Re: [PATCH] fixed caam driver handling of sg list.
Thread-Topic: [PATCH] fixed caam driver handling of sg list.
Thread-Index: AQHUuTUbLrzB8lCy0EaMPxLEvzKAKQ==
Date:   Thu, 31 Jan 2019 11:20:59 +0000
Message-ID: <VI1PR0402MB34858863410A59EFE18B8E0C98910@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <Pankaj Gupta <pankaj.gupta@nxp.com>
 <20190131070556.44832-1-pankaj.gupta@nxp.com>
 <VI1PR0402MB34853768D9824C6FE33536E098910@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB2752;6:J+dFvPJmyvyqeQT+nyO6JiKWrZ6FLccOF/c+JgxTvVKQFIF9ja07hkxpaDUtwFovvebrXxrBE/igBmiHg+greioMx6X8zgtlZMIfldL6yhxsoULSJDGSUnA4/MXb1zkf1WbOqI8sCe5bdk+RLmVXOvZY443wI+2dafSbnmTqueFsOOKH2GMkAAvpBd+hJhDoymjvEs/HjdgOD4E5lBzX5qVHjJ9mWmiM6EsZYJR80iMdD90+BLVrVw2KcNrC6QpHissI+fz3x+UUpHj9gHL/HXRVK4h4Wk6y8y36PwjXf5Qv3EPjZBGKeF7XwcR9pVIymndji0M8RqCL/0MGrH+YmWptP9pOXnfq9+iNZEkhXT3F+VjSgZu1bM+oL8MImN/kv/ZAqMjMz3RrK0kSpyni2R8CJyPZ25fNccMWK17M7B1khI9kagUnYcXwIL40DzMlTLcuAygV/nfFMV2Nbt6FBw==;5:pbTuiDldPHeUCXgMoeq3WyKIdDKFkMpv5S8y1VmFZCObaWqXpyz0P/3qseYgmL/p2LW4oUMTmeb5ltfjycAJ8QIi5KvpKbmK5Y07k+DMWIIjOu1LnrSJj5AtOAEVhY3w9UTV4QTTlqLKvqOEjszcHINnjRqJfJRcLQ/lgM4279rRisWEpb2Y7UMt9z9Gah9o8TiFa1Y6uFTKdwO62ZFsHA==;7:LzbI3kdwnKCo9JuhobUZGB1H6hb19Bc3MUBMeTLYA5zDNFoslVYP9s3oGRF5hpY47BVmFebh/8cNrkM+0jZE6ju2AXEoSzuCYXdswpWGqaGhJmip/HQKqLb9/tzpf80yTjpVJJ7Q/ob2Rl6Xy8Hhrw==
x-ms-office365-filtering-correlation-id: ff149a5d-3f67-4503-4510-08d6876e2d30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB2752;
x-ms-traffictypediagnostic: VI1PR0402MB2752:
x-microsoft-antispam-prvs: <VI1PR0402MB27527C35F67CD259ED986A2798910@VI1PR0402MB2752.eurprd04.prod.outlook.com>
x-forefront-prvs: 09347618C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(486006)(44832011)(102836004)(476003)(6436002)(99286004)(6246003)(74316002)(26005)(53936002)(3846002)(81156014)(81166006)(106356001)(446003)(478600001)(316002)(186003)(55016002)(66066001)(86362001)(256004)(33656002)(68736007)(14454004)(9686003)(110136005)(8676002)(71200400001)(105586002)(71190400001)(6116002)(6506007)(2906002)(4326008)(76176011)(53546011)(7736002)(305945005)(7696005)(25786009)(93156006)(2501003)(97736004)(229853002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2752;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cU0B+gLpjL/ZooB1DMgBqfBclqVXBGJQMsZ/hLZo0e6xKepCc3ym2heLqPsOROYvLtX8lrGY/p5WUittTvGZGOwiduaAOvRvjxgsM+/NnM3Z4Yjty17pXvCD3XfYOBAdSUaBhix7hJsvozzfIqrbK8mvbTymhgrxdJa3t12xSUt1FjbmM+sNd/iNm/Vmbpt6ADGF+sOyibIb6u3hGyh2QxlfHu8An3aBE7kfxB7w1KHJ728PHPl6mrpVQgkrejrCKXTO6/dXTi4O5W2jlcToOBq0J2Q3gxL0s8wNsguypjUzlbc6OwgdWTZjB8OlqGHlSCwj5jGDlotGcGd/AOs/AHXx4XBJ7A9gomFilSCHbuNYGYPfhXN+Qk4ZSJ+zYQhXSu6oytrEKhx7vBdpwLsqkm7pMJGxXgaVNRs/d9iUGs8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff149a5d-3f67-4503-4510-08d6876e2d30
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2019 11:20:59.2733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2752
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/31/2019 11:38 AM, Horia Geanta wrote:=0A=
> Thanks Pankaj.=0A=
> =0A=
> On 1/31/2019 9:18 AM, Pankaj Gupta wrote:=0A=
>> when the source sg contains more than 1 fragment and=0A=
>> destination sg contains 1 fragment, the caam driver=0A=
>> mishandle the buffers to be sent to caam.=0A=
>>=0A=
> Patch subject prefix should be: "crypto: caam -"=0A=
> =0A=
> Please Cc stable by adding:=0A=
> Cc: <stable@vger.kernel.org> # 4.3+=0A=
> =0A=
> The root cause is commit:=0A=
> f2147b88b2b1 ("crypto: caam - Convert GCM to new AEAD interface")=0A=
> =0A=
> however the issue was not visible until the switch to new AEAD interface=
=0A=
> completed, in commit:=0A=
> 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface")=0A=
> =0A=
> Thus it's probably correct to also add=0A=
> Fixes: 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interfac=
e")=0A=
> =0A=
Actually for gcm the issue should show up from the very beginning, so=0A=
Fixes: f2147b88b2b1 ("crypto: caam - Convert GCM to new AEAD interface")=0A=
Cc: <stable@vger.kernel.org> # 4.2+=0A=
is better.=0A=
=0A=
Thanks,=0A=
Horia=0A=
