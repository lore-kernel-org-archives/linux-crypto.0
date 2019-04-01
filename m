Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599A1C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27AC0206B7
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GudLKih6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfDAMJ6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:09:58 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:56059
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbfDAMJ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 08:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLfuiLFRH4OBomwkvw/4IFij8Rhr9ut0dpQ4jRUJqtI=;
 b=GudLKih6OwOVZVJANz9hNqZkYPZNUrIN/gfu3oUg6rY2JltsdRf9uE5HaMjiybJd5wDQXUqCtjzQ1AzLX2ZJGJ4QIpSU7cJenGU1RqQC+2HiV8hOwwgWCrmQIj826nnK7yvqO4zJmnMFzswf7lhBElW603yde2IrCmdVKM5em2Q=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3421.eurprd04.prod.outlook.com (52.134.3.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.15; Mon, 1 Apr 2019 12:09:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1750.017; Mon, 1 Apr 2019
 12:09:54 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/qi - Change a couple IS_ERR_OR_NULL() checks
 to IS_ERR()
Thread-Topic: [PATCH] crypto: caam/qi - Change a couple IS_ERR_OR_NULL()
 checks to IS_ERR()
Thread-Index: AQHU5XOmScyRtgADwEuysi/C+xYnmA==
Date:   Mon, 1 Apr 2019 12:09:54 +0000
Message-ID: <VI1PR0402MB34858D2A39582719767800D298550@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190328143601.GQ32590@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54e13fc6-dd2a-4fc1-bd20-08d6b69af358
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3421;
x-ms-traffictypediagnostic: VI1PR0402MB3421:
x-microsoft-antispam-prvs: <VI1PR0402MB34215D2E2CAF12207AB5614998550@VI1PR0402MB3421.eurprd04.prod.outlook.com>
x-forefront-prvs: 0994F5E0C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(396003)(136003)(39860400002)(199004)(189003)(71190400001)(9686003)(102836004)(256004)(33656002)(6916009)(6116002)(76176011)(25786009)(186003)(478600001)(97736004)(316002)(54906003)(14454004)(2906002)(3846002)(53546011)(486006)(476003)(105586002)(66066001)(446003)(55016002)(99286004)(229853002)(68736007)(7696005)(5660300002)(6506007)(44832011)(6436002)(71200400001)(6246003)(8936002)(53936002)(26005)(4744005)(8676002)(81166006)(86362001)(52536014)(305945005)(7736002)(74316002)(4326008)(81156014)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3421;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Db/DODenQa1AsjjCnrUTtXL48DUgPbj+7frpbGv6s3SOAFcikvh24+EZIN3eEg6gDG0d4qL3ob02YTkps07Jdq09WC72YpcN3DTiSGJ3xC1QfGKpBHGnMPDLUMU+1+iDqie7vFSfA4YHm25+3D4nrcSXPJRFpZsIATWqXR1IpN2HqmhOBxyp4XfWW9N85ai8OVOV2GK6iNwe16pVuLWKAlCmFNAQ0nw3qLgG3NUVJfDzXFCT/tqS97ezLQHoRjIIg4CtEqpqtdUJ+CoBXL+YioVs5kPRDWQZ1ygb/RQqyiT5P/Fn4wpecqlxZ11YhzUFOCHtIbHGjKzMymsu33psf1h7VNz4sIAglWKW94qoY0x27dS6Bb/qaFMtiPPNAPTRGfkAzZd5s8jk4yg9+JtrRhZ1fSix7Mpv2urQFoh8Uzo=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e13fc6-dd2a-4fc1-bd20-08d6b69af358
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2019 12:09:54.2421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3421
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/28/2019 4:36 PM, Dan Carpenter wrote:=0A=
> create_caam_req_fq() doesn't return NULL pointers so there is no need to=
=0A=
> check.  The NULL checks are problematic because it's hard to say how a=0A=
> NULL return should be handled, so removing the checks is a nice cleanup.=
=0A=
> =0A=
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
