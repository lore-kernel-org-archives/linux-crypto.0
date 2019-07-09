Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A5BC606B0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 06:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0959A216FD
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 06:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="mpN28U79"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfGIGoB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 02:44:01 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:31421 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfGIGoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 02:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1562654640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xbRnNarh96gi1rrRO6YEqCAYsXB1bkW8OPqwABLvYiE=;
        b=mpN28U79xFm4lXUC0uhokK5YJhLxeB4hFfdXJkAnZaMDGPfzlVYmzttZf5lzcJxmhxsTG8
        Ixk1UoShIybR6/JPFzNEXnjI9+jwe8g8KRKoeT7fVY41nxsdZQOJrJ2TCbkzpN3YnW3mEo
        U8PwjfbnD8H6s5W4q3ZCUAfbTTQeCss=
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01lp2057.outbound.protection.outlook.com [104.47.33.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-594rqCpiPxKKX7qV_0xhEQ-1; Tue, 09 Jul 2019 02:43:56 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB0590.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 06:43:51 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41%8]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 06:43:51 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: CAVS test harness
Thread-Topic: CAVS test harness
Thread-Index: AdU2IaQXtQPkG6HVRT2zauBDH3qftA==
Date:   Tue, 9 Jul 2019 06:43:51 +0000
Message-ID: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.56.132.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7b694fd-d4c7-47fe-6fcf-08d70438ce02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:TU4PR8401MB0590;
x-ms-traffictypediagnostic: TU4PR8401MB0590:
x-microsoft-antispam-prvs: <TU4PR8401MB0590AC161D7CE32912031E14F6F10@TU4PR8401MB0590.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(53754006)(199004)(6602003)(189003)(5640700003)(9686003)(2906002)(25786009)(102836004)(55016002)(52536014)(53936002)(68736007)(5660300002)(6436002)(6506007)(7116003)(476003)(4744005)(8936002)(66066001)(71200400001)(71190400001)(6916009)(76116006)(66476007)(66556008)(486006)(73956011)(64756008)(66946007)(66446008)(86362001)(2501003)(8676002)(26005)(478600001)(3480700005)(14454004)(74316002)(7696005)(6116002)(3846002)(2351001)(316002)(305945005)(81156014)(81166006)(186003)(33656002)(7736002)(99286004)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB0590;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C54wrqk5VhggwJjaXJlDfP/LXKWtZ9v++IWPCKQlisA11Z4saEyLB/xEpA7pJLVXdZc3Ip0VgA9rdxgBeQmPQhcb1Fy1OrLjgr57BFSNAq1qHW4XDIvsUGy/TzSHDX3JvxsTIchbAlt6Exh9I+xF5j8dgVh48LP3oC/hVN9Fir7G59RuoDmUCKsCdsWeOPkY02n/zIgJqvc/5thg/chHlj6V6Vrhj4Aboz54lepFPT5f93uHfX1wWWrB+HCF/krKbHiH6zk/Ny+2K3uORX7m8CsZhdRoKB7e3nihLvQWP5dh2dXGgHCUgmS/GgxyzCzYftiIXMxfnUz5IyjoAbVPGz4oK82EEc9Eg5veEpcRGc4xnsCsruysrxFH7UDq+nCDo52NR3AAqBmjJ4qTtgy+WsSkL8QQv5GK1g4mDYly4iY=
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b694fd-d4c7-47fe-6fcf-08d70438ce02
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 06:43:51.6419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jayalakshmi.bhat@hp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0590
X-MC-Unique: 594rqCpiPxKKX7qV_0xhEQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

We are working on a product that requires NIAP certification and use IPSec =
environment for certification. IPSec functionality is achieved by third par=
ty IPsec library and native XFRM.
Third  party IPsec library is used for ISAKMP and XFRM for IPsec.=20

CAVS test cases are required for NIAP certification.  Thus we need to imple=
ment CAVS test harness for Third party library and Linux crypto algorithms.=
 I found the documentation on kernel crypto
API usage.=20

Please can you indication what is the right method to implement the test ha=
rness for Linux crypto algorithms.
1.=09Should I implement CAVS test harness for Linux kernel crypto algorithm=
s as a user space application that exercise the kernel crypto API?
2.=09Should I implement  CAVS test harness as module in Linux kernel?


Any information on this will help me very much on implementation.

Regards,
Jayalakshmi

