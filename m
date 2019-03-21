Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11460C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 11:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A067C218FD
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 11:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="m6PIam5+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfCULpP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:45:15 -0400
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:56572
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727870AbfCULpP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 07:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnBT5E7/5vGCxfF8Mwx1VnA9bPfN2pL34oF8KI3ZeBY=;
 b=m6PIam5+jB0kvVX3aOu8haf2GPo1AtjLYocEaSYPWVXG88NnBl5KgECWgkc4OUFTu0BNcWeQa0sHPUxj4dk3CqvTeD7+g3V1MIVd+HR4NSsiFwHrqDRshAW4F8awqKe409JgtiHrCrB6a7zVB+5v40mzrbUSZuW6EBdF8OdYF9U=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2766.eurprd04.prod.outlook.com (10.172.255.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.14; Thu, 21 Mar 2019 11:45:05 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 11:45:05 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>
Subject: Re: [PATCH v2 3/3] crypto: caam/jr - Remove extra memory barrier
 during job ring enqueue
Thread-Topic: [PATCH v2 3/3] crypto: caam/jr - Remove extra memory barrier
 during job ring enqueue
Thread-Index: AQHU2yHJke/R0x4RREab8EZbsyxNzg==
Date:   Thu, 21 Mar 2019 11:45:05 +0000
Message-ID: <VI1PR0402MB3485F8A3B2912FBEFD622E9F98420@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190315112238.24337-1-vakul.garg@nxp.com>
 <20190315112238.24337-4-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52c3b8ba-380e-4643-3f40-08d6adf2a959
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB2766;
x-ms-traffictypediagnostic: VI1PR0402MB2766:
x-microsoft-antispam-prvs: <VI1PR0402MB2766B6F097B2267755C4C76F98420@VI1PR0402MB2766.eurprd04.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(366004)(136003)(346002)(39860400002)(189003)(199004)(256004)(99286004)(44832011)(53546011)(71190400001)(71200400001)(14454004)(76176011)(8936002)(478600001)(186003)(6246003)(5660300002)(102836004)(316002)(4326008)(4744005)(6506007)(25786009)(110136005)(52536014)(7696005)(476003)(486006)(26005)(14444005)(2906002)(446003)(7736002)(8676002)(81166006)(55016002)(81156014)(6436002)(2501003)(74316002)(97736004)(33656002)(305945005)(229853002)(105586002)(66066001)(86362001)(68736007)(9686003)(2201001)(106356001)(53936002)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2766;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oCtiAvkf0r5tBP5zzSOvX6EUwaTrWUf+tJ6txlOPUe7wzZM2lf1ib9V0zN0zM3pwfDr2eSNel1CFEyuuDrvsbqj+Gmo4mX1PyIBV10GH2RAIAfTZkH3IMf4I9wskZiF+WsI79ssW3kbdp7fsLjB6W56rfenHAcLK15trQNi7q+vbeUZlW0rUS4q6AzzbvIB4xLoGVvYjWLS1e88csIK8uG9reWADlwr+Vm7HyuDE0Oqn4ZXA4Zg7c9nb0CLZIz0NzXlFDeppJPAWy1BJjiGDc7bw7Vz9PZTa2Qs/sYIQudRweRh8Dd2TChTr4tkiXJYiIUKGiqkbOmm+TPCCiJxsp85Uq8WPZ3UtmREcNkzpQVZkk39T7I3RurLJAZdo1kPzPZH7qXPN645dMP8s1+VyBcbjqLkLoj8TR8CSgaHP3oo=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c3b8ba-380e-4643-3f40-08d6adf2a959
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 11:45:05.3302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2766
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/15/2019 1:25 PM, Vakul Garg wrote:=0A=
> In caam_jr_enqueue(), a write barrier is needed to order stores to job=0A=
> ring slot before declaring addition of new job into input job ring.=0A=
> The register write is done using wr_reg32() which internally uses=0A=
> iowrite32() for write operation. The api iowrite32() issues a write=0A=
> barrier before issuing write operation. Therefore, the wmb() preceding=0A=
> wr_reg32() can be safely removed.=0A=
> =0A=
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
