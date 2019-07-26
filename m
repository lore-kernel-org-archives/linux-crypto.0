Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F71C76191
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69AF022CE5
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="gbeAFiu5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbfGZNuC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:50:02 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:40672
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388763AbfGZNts (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:49:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dor/wjAfNm2fGNzYiJlM4i04lf29wNnVvdCDaeT54bozdQHIL8+WOs+A8UDii86TKnktOzFyErv5LGFjX+Pljtm2y17LQZzjpFM2vqlX8Wei5BxiZAFX5lU/B1EtDHLr09qQgh3J/TTQiIj5bh2pXlt1ps7tjkMoLRgcbpKlRboEDsrlKgk1f6kzrYrkzkO2dOwASwR+6Rb8WfBoV7HWzMv8RvYSsCNQCsShK1vEjdYXgXPg54q7XHGTURl6a+DCJkBK7lB9gTZSUQCiNXuX5EpxlEVoRy+n/b03kTlTo1QQ0Id/dKOh+CTyXhIdzto4jbugT703N/kGNcrdlInzGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2lxrbfXCAq/f3DnHYW0id94UZkJcFpMIYbFzOdApLM=;
 b=QL4QX6C1JQsfaDBbL/bR0Ft6/HB3qS+TXgH1+YCkLf0RYe7pbS/GV86A7zBcaxjqhqxENOk5M8ANRxRguWXP5akYbzZEfj2ivYxzDKS+ilCIX0oN09oVWzFpV2yG8FXcyQ/N83TwaEAO1etP78FEUk4yQf2iVU43smBWPmd2Tl4iCDNY9nSh3xmR6FXTyahHmhsTj/rBCqR51872vnQi2HtrmaC4IBOCk3o42EpQ0+VRilR7kBNu/4+iyPSkGuU00ys3FFlF5vWR8+MdVRLbACR+oEOqa1Nzy+lZkT8B3IF/lH/OtbQIubjnik5qba+F2jIfNXbKIbuHzwnU2cN15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2lxrbfXCAq/f3DnHYW0id94UZkJcFpMIYbFzOdApLM=;
 b=gbeAFiu5ir0QEx4QUAyE4Muyf8Aq35iDC5w5lrwR7xtFDjACyFRPK0n8zK6Tb9TIMwhFZdnsRq+RS0dLA94JA9v3ErTnNRvAEi06wfXpAdZBOyB+T0nQ7j3DXRGOD5O4PzMykyCGz+jCEWqASpk75/3YBB3VawUyXrcgVNVoeFU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3774.eurprd04.prod.outlook.com (52.134.15.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 13:49:46 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 13:49:46 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 2/2] crypto: aes - helper function to validate key length
 for AES algorithms
Thread-Topic: [PATCH 2/2] crypto: aes - helper function to validate key length
 for AES algorithms
Thread-Index: AQHVQu+BMaF0j5tHz0K2l7Z8IRB8oA==
Date:   Fri, 26 Jul 2019 13:49:46 +0000
Message-ID: <VI1PR0402MB34850C8A88CBD9370BEDBD8F98C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564062431-8873-1-git-send-email-iuliana.prodan@nxp.com>
 <1564062431-8873-3-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 292f386f-51cc-4f7a-5361-08d711d01eb8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3774;
x-ms-traffictypediagnostic: VI1PR0402MB3774:
x-microsoft-antispam-prvs: <VI1PR0402MB3774E1A1E9F1781C47A974D598C00@VI1PR0402MB3774.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(189003)(199004)(52536014)(8676002)(110136005)(26005)(33656002)(76176011)(316002)(5660300002)(54906003)(44832011)(8936002)(446003)(71200400001)(71190400001)(476003)(66946007)(7696005)(486006)(91956017)(256004)(76116006)(81156014)(81166006)(66446008)(68736007)(229853002)(64756008)(66556008)(66476007)(4744005)(102836004)(9686003)(6246003)(6436002)(53546011)(6506007)(55016002)(53936002)(25786009)(478600001)(6116002)(66066001)(3846002)(14454004)(186003)(7736002)(86362001)(2906002)(305945005)(74316002)(99286004)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3774;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t3LJ86OuTF2uW0GwX1YiC51M2rg5X9+3u+RGJ1ImqpdBlYsAYKqTvpCz1leuPyqmb9VVisnJ2blHIMSUmzDg/QF4lMGSALRVpkjnxkSUsnKWs/mePn7hB1AsCUG/V4kxlqltqy5SvckbOAvMLmtnw+85z7mg2n9p2+UcLqN9RK/b8ioRuYyisD7yXwhxzvptumuxT5b9yY/V2Mg6ygvB10t6Bnm6p9nITVvy2liAicBUNYIHeTBkRTlIf+Pcxjfk4nT01z8mcKHDEUgar0y0iZLjZDGddCuQMcb9URFeVFCiFCUxhlSj8PL/Qsw7yxBHutOcQ4ejnvjz/yp6W1tP09keSV8aEyJNsnetl26dI1VyxjzqMEN16Nv4T59A+nCr7eZKHdSQd+B5ZQuyuQepe5Qrvmoir6D09wo5fB3SzMM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292f386f-51cc-4f7a-5361-08d711d01eb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 13:49:46.0751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3774
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:47 PM, Iuliana Prodan wrote:=0A=
> Add inline helper function to check key length for AES algorithms.=0A=
> The key can be 128, 192 or 256 bits size.=0A=
> This function is used in the generic aes and aes_ti implementations.=0A=
> =0A=
Looks good.=0A=
Will need to respin it, since aes has just been refactored and moved in lib=
/crypto/.=0A=
=0A=
Horia=0A=
