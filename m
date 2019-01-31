Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325E2C169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 09:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06626218AF
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 09:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="l/EBx+Sp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbfAaJiA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 04:38:00 -0500
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:38220
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbfAaJiA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 04:38:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuoZZPY3dn/qhcUsiPqx5Rw3pMuht3u3gA9UrjsDFXI=;
 b=l/EBx+Sp48UYxVUF0QKCCBSD323IUQ0HiSummJ90GUfOA6w//j/GFetMj+Il08Q60j5PAbHJGhG05kefp2meuJHpnhrLFBXmMfmtrNdDX2OmYBxqSP1xuUJAYO/TkRFyqW2imw9ipuNkTbu0RWiNlJmd6KKdT/tIiJC9G+2joeM=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3597.eurprd04.prod.outlook.com (52.134.5.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.17; Thu, 31 Jan 2019 09:37:57 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1558.026; Thu, 31 Jan 2019
 09:37:56 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Arun Pathak <arun.pathak@nxp.com>
Subject: Re: [PATCH] fixed caam driver handling of sg list.
Thread-Topic: [PATCH] fixed caam driver handling of sg list.
Thread-Index: AQHUuTUbLrzB8lCy0EaMPxLEvzKAKQ==
Date:   Thu, 31 Jan 2019 09:37:56 +0000
Message-ID: <VI1PR0402MB34853768D9824C6FE33536E098910@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <Pankaj Gupta <pankaj.gupta@nxp.com>
 <20190131070556.44832-1-pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3597;6:rUtw6N+THPfV0IX0sEVkPVJt3Lnnc7xBrk7VkYr3oyrCbQxMQWg0ZJoemqRNovsLi40OkhM/B/wuMWBtnVx3Gjcci91fmeBvWM5rGWLBZ4x1fP0hgYKqDRbfVtZrrg2OSzA0no+Csd7aQGLja5lyeBzcmzlr+4jRA+2AVLqG3U2R/3OVorlsiTIYryvF8iUZ1vhPXIHP8C/xbgWNeh5t92PtziKWxA5elNQ7wxakeYQyukP4yO8IWn0e4SKpFpWn0MJPNkt9EuQkzjNFklbye11ErEd9XnZFw84CVA10iwoZMjLG5IhMWb3FAfUxIJrh7ledq4+b5BsstHxR8phigKNkroi2hADkJXZ3DXOpFkYncqwQFI8ufoz6GAbB4fEKRrEaeWrY0xT9EbB0UMSup7BkPrcT7v/09nZI7ZNlGRcwx0u9xtEkWbAnVQm/OCH7/kAVoBht57Of2IKvXHPDJg==;5:FDO7cpyZL+0ivyraKnLKEtecFz59GSA2DqK576+ZErom56eJbjyBGyajj0/Jarb+CYWoEo6gRJaKKlYaq4RwfGoPlwkIiYJI4kGaSijcitTYiSxxik/+yaIwcQ6R14Yo6hmvII5RVUlz1VLPhgJ/kudNYaIdNAFjG1Q5W6IxzRzHgRiHHdSpfw1VOeDIDirCjZYhrWrbyZJ7FeQQuUDAQQ==;7:ZRQqzdsnhzLbRZ2b0iOjK2jqWaSREYsF9/wj0mmWJ4yGbDLPC6C/OzW/KmidhApsNgYrwix0gRNSk/DfkxzJxGDTMlJ4v+uKR/OFQeVqa8bNDBYQBQb4ltVxlY4zh7cs97FFCZNYXdyIGwNGgUXaTg==
x-ms-office365-filtering-correlation-id: 08805c3d-7e9c-488e-fc29-08d6875fc82f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3597;
x-ms-traffictypediagnostic: VI1PR0402MB3597:
x-microsoft-antispam-prvs: <VI1PR0402MB359704D4685B264241685BB898910@VI1PR0402MB3597.eurprd04.prod.outlook.com>
x-forefront-prvs: 09347618C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(396003)(366004)(39860400002)(199004)(189003)(102836004)(6246003)(53936002)(105586002)(4744005)(478600001)(33656002)(305945005)(68736007)(74316002)(110136005)(486006)(316002)(256004)(106356001)(71190400001)(71200400001)(8936002)(44832011)(446003)(2906002)(6116002)(3846002)(97736004)(6436002)(6506007)(76176011)(476003)(7736002)(186003)(4326008)(26005)(53546011)(229853002)(9686003)(55016002)(99286004)(8676002)(2501003)(66066001)(25786009)(81156014)(7696005)(86362001)(14454004)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3597;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fQv2GEDMnfvO7ci0N48d09fg70VY13vAaposoXa11uIw5p6HoLVo5JKWqIghteKr43Nh/FJ7vI2c82QbCUnu/idiuaW6sKMcJkEmpnUZole+CAR311hxigkJfDgDBIW/F/z/qxp20PucwYBhj0BMhc9aJsvs02mlFFuqzs9QAG2Zy9jrYpubZZSn4AQY1Elc3AtUWEMJLu0zR0cM/alsOOwNeZ5av89VsFIIF9LngjxgBBbxq2oTrnbfs11XVwrtf+SRzIMmXEjsoXgj+yhGmfVKD2Guw4NCOKvh2BjS72AD/PuIn52H/3orFvn3XSpbZmmjgNoJdJ/x7G5DQ0PB9eX09wLfSnrscNaLnWnvmvGhSKuJr5yxim2geSxptBLIlqrNvftR7Wq2xSC8yPInXkvcO3VK24w1adk3I8fR6QA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08805c3d-7e9c-488e-fc29-08d6875fc82f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2019 09:37:56.8383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3597
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks Pankaj.=0A=
=0A=
On 1/31/2019 9:18 AM, Pankaj Gupta wrote:=0A=
> when the source sg contains more than 1 fragment and=0A=
> destination sg contains 1 fragment, the caam driver=0A=
> mishandle the buffers to be sent to caam.=0A=
> =0A=
Patch subject prefix should be: "crypto: caam -"=0A=
=0A=
Please Cc stable by adding:=0A=
Cc: <stable@vger.kernel.org> # 4.3+=0A=
=0A=
The root cause is commit:=0A=
f2147b88b2b1 ("crypto: caam - Convert GCM to new AEAD interface")=0A=
=0A=
however the issue was not visible until the switch to new AEAD interface=0A=
completed, in commit:=0A=
479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface")=0A=
=0A=
Thus it's probably correct to also add=0A=
Fixes: 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface"=
)=0A=
=0A=
Horia=0A=
=0A=
P.S. You are supposed to add driver maintainers in the loop, see MAINTAINER=
S=0A=
file and the handy scripts/get_maintainer.pl.=0A=
