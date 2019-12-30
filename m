Return-Path: <SRS0=xlaa=2U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E2CC2D0CE
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 08:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38D83207E0
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 08:40:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="QHbpJOt/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfL3Ikd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 03:40:33 -0500
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:45921
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727175AbfL3Ikd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 03:40:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvyVwqdHpYMy6UleMJQLBroIF4s2q6jle22EMJhAnP+5g07r0yQJrvbUU01UE/tC0g/xsG2RfprkKMcIeHnSsdYAfATU5cLfZW7vVFVBKjXDcho0wnS//Dokj1aUx9RsX4o4JhGoMNypYtn/7wJNFnOmD5M95dTLmgRkSkaYpLylOzOi42DKpKJhtP3HUBIVofdDeqA2dp8MnYJc358KrpQVkMsy047pPB16/4yA8fyQzFqVHaYo8tfh7AoR15+bCPMmwS1qMU7KM2B3+D+ghW8IEmr7Um0Plz3aX4UzpqhrqZw4SHczlvdQ6T0vNAFYPtHuiLuEUEsmv0vjbmhiwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js1ycgd1IC1DD9Eubkw+YUsuOwxYEscet+vU+Oc2Z6A=;
 b=Byi+XxvDA9LLNtMDjaxou7da82Zl8zJbTMpkdyEVrLsa+UxBKi6ghfJMQa1qtbYNy++nNGlAYcfN4Kvbwx1oaIAzRw0QowwYT8H/VMNm2ZqO3VZGot3UnvRDj+gBpGUMFrNEVxp9YsIvMnwtgE8dLQDW35D6ZXH4YIB7L0STqtpC3T/WLfMWr6X4SehKk/c9oBOU1iqkAdnRh4Y3TWMupWdXJZi2zVIxBH8/RAzm1G0bvV5pOCwGs7intYpT9pbbw95OQR0XnlOgcMAesPkeOVw+jMAAhOwjovsECq5ZqDeGb8eAHrayYJiIfz4OZx0MNs9nYEfNWYXK3pgCnyi8Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js1ycgd1IC1DD9Eubkw+YUsuOwxYEscet+vU+Oc2Z6A=;
 b=QHbpJOt/RXN4ge0hTHhs3p1JbvKxr/fufEQ8QnBUHKVLAT0WsDLI0D6xyjUBog9zylCaoX9IvIi8eJAf9fuG32uYMwzJgejGDzOZwmvOE4PIhMka/aUpV88AEHS36yhmxR5Oabm+o0lFODKwlEQcpNbolrc83eqDpokXN+uqvMg=
Received: from CH2PR02MB6040.namprd02.prod.outlook.com (52.132.228.77) by
 CH2PR02MB6760.namprd02.prod.outlook.com (10.141.156.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Mon, 30 Dec 2019 08:40:30 +0000
Received: from CH2PR02MB6040.namprd02.prod.outlook.com
 ([fe80::b42f:83e6:93c5:513c]) by CH2PR02MB6040.namprd02.prod.outlook.com
 ([fe80::b42f:83e6:93c5:513c%7]) with mapi id 15.20.2581.007; Mon, 30 Dec 2019
 08:40:30 +0000
From:   Mohan Marutirao Dhanawade <mohand@xilinx.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Hardware TRNG driver framework selection criteria
Thread-Topic: Hardware TRNG driver framework selection criteria
Thread-Index: AdW+4zXWPe6kfneES0SuZ+f4XUsl9wACXEDg
Date:   Mon, 30 Dec 2019 08:40:30 +0000
Message-ID: <CH2PR02MB60403861414CF41EBCD4C71FB6270@CH2PR02MB6040.namprd02.prod.outlook.com>
References: <CH2PR02MB60404BC572AFE710C2AFF42CB6270@CH2PR02MB6040.namprd02.prod.outlook.com>
In-Reply-To: <CH2PR02MB60404BC572AFE710C2AFF42CB6270@CH2PR02MB6040.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mohand@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 894580e8-73a9-47e7-355f-08d78d03ed91
x-ms-traffictypediagnostic: CH2PR02MB6760:
x-microsoft-antispam-prvs: <CH2PR02MB6760AE99BD037B6DFC92EFB3B6270@CH2PR02MB6760.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(53754006)(189003)(199004)(2906002)(76116006)(7696005)(6916009)(66446008)(66476007)(66946007)(64756008)(66556008)(6506007)(186003)(86362001)(26005)(52536014)(2940100002)(33656002)(55016002)(4744005)(71200400001)(9686003)(478600001)(316002)(81156014)(8936002)(81166006)(8676002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6760;H:CH2PR02MB6040.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FG908TW0H0cZP5i3GCNDsuH8PENdglUXHq0DJcJbUwxVYkKcc8Cf3BuT+9l89nV6cumq0vF8BZlKcPkuhRLTOOd6h3HPVCZlUG6xwwFstO3y3ebN3H7AE5E6vpu4OS99MKy7PZ0wB+Ayu0MQaVIL8AVILmlz2PS0e6/1mPc3uAE8oy0fDvfRTJ7ZJinbbJ1cWRJ2xbp4sW1DQAcq8zqCfVDP5c+bCkx8ATnG4F1G904BUvqcOOP8AvgYfpPpQHrkoLwnAnVcLd+v1WKkt+0XxNdGSyCVe3F3YMeYsKmZfeisr2Eg8AqlROSXYmCw6YOH+rxnQHHcPESc4yS44dysLpf6wOvRhasgsuWL36qyN5dVHbf1kHXSRBpzWJHRHzCGh/tPL0gXDTEXq85dfzlvaPEY0ty3iC7Z1apf+vlK5Az1LLkUhvEtTx3ve5+jJXeBLWtEYB58f5eCfhCVI5HYHn0K+8uwsYhlgPAWEQCUhRTwE2XEQYBAWGnnDj4Oi2u9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894580e8-73a9-47e7-355f-08d78d03ed91
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2019 08:40:30.5080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YY5ypuDxwrD4QLHy+gpTE/7pDin1uPq3OYSoI4VzHr7W2wmxdOTDU52eGxNNHCTsBTZ2KayaJGi6BjNxwJSA7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6760
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi everyone,

I am writing Linux driver to support TRNG hardware module for Xilinx SoC. I=
 am seeing two frameworks - crypto framework and hw_random (char driver) wh=
ich can be used to write driver for TRNG. Can someone please educate me on =
what criteria is to be used to decide which framework to use for TRNG (Cryp=
to framework / hw_random char driver)?

Regards,
Mohan
This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
