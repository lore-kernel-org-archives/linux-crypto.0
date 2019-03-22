Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7063C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 06:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C2FD218B0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 06:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IH4XA4F9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfCVG4m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 02:56:42 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:56545
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727375AbfCVG4m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 02:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBtUNTmbr4Z2RTmlQDd3Zad8bTXrL3izzIrmoGzXX8s=;
 b=IH4XA4F9A9G2yKS1B3ps/BkqVZHT3j5QVBJgm17Q7wURUP25cTdMLZyJjPYroZ5DbXQKyNA2w8/0ULqWs2dTaWqit6FguJXBozIR2cwQmgmRIWfQBZMyCNC+wfL9ZkZTnMdRE1Gjm5skcKjWPXI92Mk/pH5sYJ4CgHPIKjkCmmI=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3363.eurprd04.prod.outlook.com (52.133.45.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Fri, 22 Mar 2019 06:56:28 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::211a:4b31:ec05:6b2d]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::211a:4b31:ec05:6b2d%4]) with mapi id 15.20.1730.017; Fri, 22 Mar 2019
 06:56:28 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>
Subject: Re: [PATCH v3 0/3] CAAM job ring driver cleanups
Thread-Topic: [PATCH v3 0/3] CAAM job ring driver cleanups
Thread-Index: AQHU4FMI7cL4deuKsk+aqZy0MdGBEQ==
Date:   Fri, 22 Mar 2019 06:56:28 +0000
Message-ID: <AM0PR0402MB34762DD76FAEEAF636688C1B98430@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <20190322015746.27395-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5bb5af3-ffee-4981-acac-08d6ae9381ed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR0402MB3363;
x-ms-traffictypediagnostic: AM0PR0402MB3363:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR0402MB33636BD155B4C7E20E1A7D5B98430@AM0PR0402MB3363.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(346002)(366004)(396003)(189003)(199004)(3846002)(74316002)(8936002)(6116002)(33656002)(97736004)(8676002)(110136005)(71200400001)(558084003)(6306002)(52536014)(256004)(71190400001)(14454004)(81166006)(81156014)(44832011)(446003)(66066001)(6246003)(186003)(53936002)(55016002)(316002)(105586002)(305945005)(486006)(478600001)(229853002)(476003)(966005)(99286004)(9686003)(7736002)(86362001)(2501003)(68736007)(2906002)(26005)(6436002)(25786009)(4326008)(102836004)(53546011)(2201001)(76176011)(7696005)(6506007)(106356001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3363;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L3mYt6ba7Qcqcy8Ang05IZg+ziTLSG8kviKQn6dN0rFHm7e/rfWefhaMf77AO8L5qVJz1Nt7n3eP5JzXigBmTKWHHZz8dR4kiPha4bbqGJBtVECBkO7GETxe35svTV8Q+lfD/Mktzc9TB8rsKRoX7TsaqKJmuux+fDZRglEhMY5RwUbaoSHV6KPu6LYxJ3bJHAzDCQ9zUW170/88IHVKR3qZpBmkPCuhyrmgr8sEFfs5uNS2R/LObsxMe6PgfpxYlUV3Py9ASNlUkNXOy00BVLEBIQt9YOqPp4tH4oa/jF25WcmOqBkqF/3iyZTCrCRXidzpSIYVWXlhHpcqSE/K2ClI4g9uOUfn4VL7BWjvqJQX8oNGCCfQzkSqHkyfoAmkscfY8AcV/KLXm4gU/877BCNyzy+J9Iy4pbSy6Uu5qQ0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bb5af3-ffee-4981-acac-08d6ae9381ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 06:56:28.2025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3363
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/22/2019 4:00 AM, Vakul Garg wrote:=0A=
> This patchset cleans up caam job ring driver.=0A=
> The patch series needs to be applied after merging below mentioned=0A=
> patch.=0A=
> =0A=
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg37068.html=
=0A=
> =0A=
For the series:=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
