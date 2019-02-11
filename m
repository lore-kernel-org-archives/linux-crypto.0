Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49952C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 12:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED028214DA
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 12:51:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Iv8RIXdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfBKMvp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 07:51:45 -0500
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:32689
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbfBKMvo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 07:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQ/A6SqaOspMG+ehvE2Je4+NCCnnoeB25UiVle5yn14=;
 b=Iv8RIXdzAStHVGU6d+BoWLFo2gfByfT07njjccCezcGysqlsx1VZvdI+0Lk6KxkYR1Iq9CxeEilMSUD0OaqvdHzt3w4Qqy0aVPtYS6emcAnj4zdZTAbSsbOzcJD6JzsGTPjY/AvUoo/+6t2AoKbG+9qjfh9pGE6EXEr0BPgbLPk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3664.eurprd04.prod.outlook.com (52.134.15.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Mon, 11 Feb 2019 12:51:40 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1601.023; Mon, 11 Feb 2019
 12:51:40 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Wen Yang <yellowriver2010@hotmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: caam - add missing put_device() call
Thread-Topic: [PATCH v3] crypto: caam - add missing put_device() call
Thread-Index: AQHUwgWo2AboFXVoTkSR17x7SBHQ9Q==
Date:   Mon, 11 Feb 2019 12:51:40 +0000
Message-ID: <VI1PR0402MB3485B70D86FA9D9A06C770C698640@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <HK0PR02MB36344FD6A5ECF3B220D7B55CB2640@HK0PR02MB3634.apcprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3664;6:Yn4oDGP3TVWjczR45/molD1EOf6ejeobxVqXk8nJ1wr/2yWOOuyLkGViog3AqDnOU5OR50vfIeewON5lEqfICQqWXFQQPnJhW5nAEgSZcOdA1pwQvXTNpoaycQm73dmHxMJzqQPoP9J9pivIXxeRZlxk/bY/aTNJQoBRAdhgGgsyMQMIiVhCnCURIkE0WVK/6ANRADcAqhD0lht9veF9GHjwkjodBTVkE41nSQLHCw4VM71xFLbBOkajKk1+33jV84CwiX5QrVTv0LGrR7tHYirmCQfGZxUin/26FLjXfoXBQTqj0MCRcpfw4o3CIxYQ2CuEkLqeRRLuQ5TS6ycJ88r54CvVq2Q6UGjOWsBCEHUryeNqemKwEaw2vOtCnYo96OCSbIg8g2hqzW56U0DsdPiTqLpWi0lPV6S88zdEZC4RT7s9hHJB6pfd8IbY25AW+PbbXV/d4joTLNlAAVLYEw==;5:KL1Eb+rj1iOJi2V4zE8QpXsPP81s+DehBitT4t2uduHhzUXZj+4i93iRcFtGpXe9B4H1uHYHS+t/cp9CNzlmWJmQ35dM0QvERd1D37bH8Dw8uBwXmYdBM04Eb8vbZVmtqWvjqyGdmIcJFi2HlngiDizeP/1iEB5XRpmoTqGyxLe+DxbulSDMmsjXf3PszTCIqYJUJvCoBvzLP5ORl6WHFQ==;7:zGCsYlC3Wd7csaifohZUOTjSdOqurheiLKuNvvE0lRtmIgPjzeg2pnCZF/MJMkYpcanLjyHIWvt6/AuBUh6xx5kGTLePaOfUrEkRfO91PzNX/JGdNGF+JM8u1szo5Ojoofr/HzfSJBybk0rkb5DfTw==
x-ms-office365-filtering-correlation-id: b4ae3817-e0df-4b70-1685-08d6901fab0c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3664;
x-ms-traffictypediagnostic: VI1PR0402MB3664:
x-microsoft-antispam-prvs: <VI1PR0402MB3664B583059A499CFC5A086398640@VI1PR0402MB3664.eurprd04.prod.outlook.com>
x-forefront-prvs: 0945B0CC72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(189003)(9686003)(8936002)(106356001)(110136005)(99286004)(7696005)(33656002)(476003)(102836004)(446003)(186003)(26005)(54906003)(4744005)(71190400001)(53546011)(6506007)(6346003)(71200400001)(76176011)(55016002)(105586002)(68736007)(6436002)(8676002)(81166006)(81156014)(66066001)(229853002)(25786009)(6116002)(3846002)(74316002)(4326008)(2501003)(316002)(97736004)(7736002)(2906002)(44832011)(486006)(6246003)(305945005)(14454004)(478600001)(53936002)(256004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3664;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qWYwJ/SV9OlO3bUmCsAi2IHcq9zZxOeAPdq1dqwJI17lTcE7mM+ECaKZ52SoDX0yWbc//u9nlnENbyVl2aoTwUodAGoXA31G+/ZWKSzdDf4qkjTcdRSM/4ebJkTVb4xtkqA2fsyvvDiZkp5sDWe7xI7CnnrRFnWlBpAIesKBcVQ00Q0DOLmiOaOc1nNOOwE+VPlJuZ9rZT55cJM58QE+7P98eUTYMNS2bk4XiBYDmfOGyDiDLFaXtxSZv0vWQgX2jJPMQse5zWlnoSfCn0qBtYmpD9hui5nSDELWZGwp/r92YBagQ/TDMR/prwjaNQMo78sujp4TYaYur1CHWeLCC9Xou8CXewTUzB64DpjgZXC3sYPvNFOvAsOdzkhkssRXNHfxbxMTwti2PkiAG2f89mD9QCTHsWS4J6KDRg/JCJc=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ae3817-e0df-4b70-1685-08d6901fab0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2019 12:51:40.5724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3664
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/11/2019 2:31 PM, Wen Yang wrote:=0A=
> The of_find_device_by_node() takes a reference to the underlying device=
=0A=
> structure, we should release that reference.=0A=
> =0A=
> Fixes: 35af64038623 ("crypto: caam - Check for CAAM block presence before=
 registering with crypto layer")=0A=
Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorith=
ms")=0A=
=0A=
> Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
