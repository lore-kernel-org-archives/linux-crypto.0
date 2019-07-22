Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04FDC7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 18:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32DD421903
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 18:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="TL8iaLzf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfGVSHN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 14:07:13 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:59795 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfGVSHN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 14:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1563818828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rHoJl6RSNSzYqLbYvbNenBt6HUkXVqVPz2VJmMRhFs8=;
        b=TL8iaLzf8BhKA9EGt2FTb4azVC2B2dm6qBRwDgU1mpYvjPM4H+MHkw19X7GRmWyZkvTr1q
        r+CD9cL1YKEghfxFyuF1Vrr/6gnxhDyeOtTpmnrk/btETORqzdbgbJxbYiIuquLb8xjcco
        u8/OI4FKqPAyn4WRnV6dOSm84OQtxZg=
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01lp2052.outbound.protection.outlook.com [104.47.33.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-GEjlRg6OMJ-3E3tU4G8E0Q-1; Mon, 22 Jul 2019 14:07:06 -0400
Received: from AT5PR8401MB0531.NAMPRD84.PROD.OUTLOOK.COM (10.169.6.19) by
 AT5PR8401MB0962.NAMPRD84.PROD.OUTLOOK.COM (10.169.4.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 18:07:05 +0000
Received: from AT5PR8401MB0531.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::7136:9d27:cb19:6a1f]) by AT5PR8401MB0531.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::7136:9d27:cb19:6a1f%11]) with mapi id 15.20.2094.013; Mon, 22 Jul
 2019 18:07:05 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: CAVS test implementation
Thread-Topic: CAVS test implementation
Thread-Index: AdVAt7svsrcEQPaqToicmX1CpYepyA==
Date:   Mon, 22 Jul 2019 18:07:05 +0000
Message-ID: <AT5PR8401MB053183BECE5BCE7EBDB2BC00F6C40@AT5PR8401MB0531.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.111.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4db56636-cb89-4e16-ea40-08d70ecf6779
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AT5PR8401MB0962;
x-ms-traffictypediagnostic: AT5PR8401MB0962:
x-microsoft-antispam-prvs: <AT5PR8401MB09622B624D2BA3A85438753FF6C40@AT5PR8401MB0962.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(6602003)(53754006)(189003)(199004)(102836004)(55236004)(6506007)(186003)(305945005)(7736002)(99286004)(7116003)(4744005)(53936002)(33656002)(25786009)(8676002)(71200400001)(71190400001)(74316002)(2501003)(7696005)(478600001)(26005)(55016002)(6916009)(78486014)(9686003)(3480700005)(68736007)(6116002)(52536014)(66066001)(8936002)(14454004)(5640700003)(66476007)(66556008)(64756008)(66446008)(2351001)(6436002)(86362001)(476003)(81166006)(81156014)(9456002)(316002)(486006)(5660300002)(2906002)(76116006)(66946007)(3846002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:AT5PR8401MB0962;H:AT5PR8401MB0531.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z8LWemc0Pi2+IlmDKM8JwV6czxS9DPYVhAG8jO76B+GPjsNHFBIX5Fr2u/mygemGU39z0FjneSMxnX7j6F+hDI5cZqfzJQ81i2kUNUXrlqRW0lUyGnsferYjmWXYOSpFqqG0+sHSOBe5f/rYT0oNWPTrmApzjUSRHdqCCbwaodXpz4X5TBhi/ziV3NMsmj97vyy2EEI1fyMLF97xdScG9v6crh379RGiVv2UVcMlrb55x/DgUuZt+U1nUzJsNC6gFhqtDtKih+/4DI8t2hYQIgfcG70HeYY3oP8xlDKHo758XGYIozt2ls5F8R1PfIzh2xcWuK/Gw9O2+jHfG82WV2OLd+rwuh6BxzAb0uNbWmOAQ+Wslf22EyBYvgU5bZ8/+c9Xk3bO5mcFp+0NxedTYE7Yepa6FFlJv58SN3jjKkg=
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db56636-cb89-4e16-ea40-08d70ecf6779
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 18:07:05.2736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jayalakshmi.bhat@hp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT5PR8401MB0962
X-MC-Unique: GEjlRg6OMJ-3E3tU4G8E0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

We are in the process of implementing
=09KAT -  known answer test
=09MMT - Multi-block Message Test
=09MCT - Monte Carlo Test
=09KAS FFC - Key Agreement Scheme, Finite Field Cryptography=20
=09KAS ECC - Elliptic Curve Cryptography

Our approach to implement the testing is via writing a kernel character dri=
ver module to pass the test vectors to kernel. Once vectors are processed r=
ead the result from kernel. There are synchronous and asynchronous kernel A=
PIs.
Can any one provide inputs on which set of API will suite better for us?

Regards,
Jaya

