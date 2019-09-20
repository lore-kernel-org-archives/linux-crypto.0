Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9959C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A11B8208C3
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:10:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="hlFII1gx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391174AbfITPKi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:10:38 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:25252
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387614AbfITPKi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 11:10:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQ8/D/8h4IPPBrneAKwOTEwBpf1GlKbagfIwvcdZa+7HbOKKgqzlsjxENl8Tpw8tWYWvqtdmIe4IKqSb39RNdfzEhnwnA3qqgNpXuD8bUHK8xfnrmqiv4b+ICUsjGyYWLcXByhT9KFZlzpRNqzfUvDcDEYwzGSy3hWubli6DoDUWKjZWXW4G7EwEWL/VTWh4eoKPRlvSZ0AbCzqtNip4Y4wGl5MXexkIhIavHfDuVuMfPMZpg8sSAGftEA5IDXlzBLIl0JmO6H7jBgOxD8j+rekmYaozrXqBXQBcL+Y41dCTrOXqD+jm6kpVzHO0ta4YD7Xvylu3mcsdhl40/3NLGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Pdlvgjo+b2+ONsRIbYLHAOu2Wnqh0XWIYNMHetG/zY=;
 b=YwlqGivDw60UOYzi/fGtEVqcngLgjdc+FA90hzjYc5q/FN4Hj7+DkeS3+ykC5avK8WqybBxIE8UD90/1wdOwJ8MdikwmcK+62eyUn4J6yXQUL7BBKV6wUJgYNCNo54muz6yrMMK+iyJ4UilnxEZ+/gJRufF84Cs2fcHreY5PYlPuuZc9hz4mJ9BRSya51PmZEwtjNg/pp3LtgjNarbt+nvSk0r1t1N0VqxMPZnQ/IlgNn3ytX5e3WKgwPY8JIUZiCCjav5n2qf83BpG3tfyYH7rLy44FVLcdRMYLiwpIVEznxM/5Zo4lS0qYwroyK6biWe7xSqf0z09Hxgyv2TBviw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Pdlvgjo+b2+ONsRIbYLHAOu2Wnqh0XWIYNMHetG/zY=;
 b=hlFII1gxjdOCyt9SdQRXYnNtiiksjmk3PqcXUH2VnbZxVXm5xjWZBzraRZ3+M4aiREn73z34CregZY1Yvp3sVQsjHLyWlQSBkSL/VARFnmFYHoGgaJPZHe/FeFgCvZiIeiGUqymryBEv1/QZdh0dxvpVz8lsOzx+fXCz+xUALg4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3758.eurprd04.prod.outlook.com (52.134.15.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Fri, 20 Sep 2019 15:10:35 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196%7]) with mapi id 15.20.2263.023; Fri, 20 Sep 2019
 15:10:35 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] crypto: caam - use devres to de-initialize QI
Thread-Topic: [PATCH 08/12] crypto: caam - use devres to de-initialize QI
Thread-Index: AQHVYslz5HTVGbpFOkm2nlNFNP9K8w==
Date:   Fri, 20 Sep 2019 15:10:35 +0000
Message-ID: <VI1PR0402MB3485456ECDC7F92D332912CB98880@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-9-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b44076bb-cb67-43ed-9d78-08d73ddcb029
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3758;
x-ms-traffictypediagnostic: VI1PR0402MB3758:|VI1PR0402MB3758:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3758E58A80925517B6F2F75198880@VI1PR0402MB3758.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(199004)(189003)(110136005)(66066001)(71200400001)(71190400001)(305945005)(74316002)(186003)(26005)(4326008)(7736002)(316002)(102836004)(256004)(66446008)(64756008)(76116006)(6506007)(25786009)(53546011)(66946007)(66476007)(66556008)(9686003)(6246003)(7696005)(76176011)(99286004)(55016002)(478600001)(6436002)(2501003)(486006)(86362001)(8936002)(91956017)(14454004)(81156014)(33656002)(2906002)(8676002)(81166006)(52536014)(476003)(229853002)(54906003)(3846002)(5660300002)(44832011)(4744005)(446003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3758;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pUjnQXxKtAxRGKngPKQlN42X8k4QFLu89GQ7iemoOX/WQdaoaf1lQf/O+cofg/RYVm5tfYLEPRDd1a7PsIj6KU+N0MoPcZ+BWJGM/rHaoK7GvBDLxTJtpcONOC6XHiBQ8JMfZ+ynEkldL2BaasLeWAV62RuoXERyEdnc5xhrJyn0ZxXgP+Itv1sIcRUxm6PN7JFYnUBp+a/Wp7zufg6TUKA0Gp/yB7dfhmh9E7tqpHDfkjfdq98UM2hy+fDKXEr2dD+CY4EFRNvcSS7TtCfLmVJ2/UtT70AthFwchNS6FciHg6ELWq/tTaAxvgI0JVPR2C7iOesbzj1fvGjxpeTOWXzqxm4dHCrw5VJsZmj1/gfLD+e0SXbKENezjq/ZIhM9pUG5EcxKeIyKf7XbetK2d6S/hN7ROT0c9XPZ24p7N3M=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44076bb-cb67-43ed-9d78-08d73ddcb029
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 15:10:35.1132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V4rBpqlAIVIShwDjA6LX2x9tuvizBGYINr0GUmYc4s6alBsbXmYKsNOS8Df3OM72fT6f3u+OmzsEh3ir/Eo7jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3758
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> Use devres to de-initialize the QI and drop explicit de-initialization=0A=
> code in caam_remove().=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
