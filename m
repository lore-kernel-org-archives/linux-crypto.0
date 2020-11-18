Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EEDC5519F
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E3E2465E
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="anOH7lsH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgKRD4G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 22:56:06 -0500
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:25248 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725613AbgKRD4F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 22:56:05 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2020 22:56:05 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1605671764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nAuWCyqSCKlxjA6DGp9/NBOYAPK1jxXANASBpPclsY=;
        b=anOH7lsHSa4j1MuxIz5l2iEnSJBv8vilUIH0S3ZprsTg/rBSMW+qMKZd9yxKZoky+KBn9b
        raERkIAzUpfyrg4Q4cDGaQtVJ2vH/AqhTyhMgBkkH9RxdPV5xOuYL8eGidtTcQO6A98Gv4
        IVX/U734J+YmM8SP/jXFXI1gsCHGfh0=
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-iSYAwJRgPA-LTFSu7xsL7g-1; Tue, 17 Nov 2020 22:49:37 -0500
X-MC-Unique: iSYAwJRgPA-LTFSu7xsL7g-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0590.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Wed, 18 Nov
 2020 03:49:34 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c03a:bba9:ff3a:ae3c]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c03a:bba9:ff3a:ae3c%8]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 03:49:34 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ESP failure when PTB is received as non ESP packet and payload as ESP
Thread-Topic: ESP failure when PTB is received as non ESP packet and payload
 as ESP
Thread-Index: Ada9XXB6jZQyerO4Rkin5F9kMdGAuAAADVBg
Date:   Wed, 18 Nov 2020 03:49:34 +0000
Message-ID: <TU4PR8401MB121629D61C3659EAD7C72441F6E10@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB12165581C53282069BF4EC7AF6E10@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB12165581C53282069BF4EC7AF6E10@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.218.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e3cd82b-e5e7-4ba6-a648-08d88b74f6c7
x-ms-traffictypediagnostic: TU4PR8401MB0590:
x-microsoft-antispam-prvs: <TU4PR8401MB059042046BF0C81A445244FAF6E10@TU4PR8401MB0590.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:407
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cNfzxmW7GBb4Q8VB7mNlKGDOFCTlmfEMmnTx6sbRApN77p8yGhNxIwXdnAu2vq38ai1xQdohwrlqwzNt9c7VehcrWDRojDXXBwmrDBe3LLHMgmmhuDJw7OcYBSRLGhlLSSLWpSTEbscTsh8S/8Qg5SGtHDFlk85xdQcFeRxeuaK1qR1V1wpRPkVQXPk+zN23iZXdGyYNS/LhNdk8XACT+zPJsAzh+0tNS1kBJPmdyEMlfd+/aQkaLcnnZlCLeqU+ehTmt5LcfN7e4HnVPFTPWT3Zet+nxehCvAdMFXUTY0QxFcrc4nX70yABewiM450l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(366004)(376002)(2906002)(66446008)(9686003)(71200400001)(8676002)(55016002)(33656002)(86362001)(26005)(110136005)(450100002)(52536014)(6506007)(55236004)(316002)(83380400001)(7696005)(186003)(64756008)(2940100002)(76116006)(66556008)(66946007)(478600001)(5660300002)(66476007)(8936002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: 9S9ZtekwIY/ywDjQUBcb2GU5fn38IBIZPDKGTuttzYByzkuUyrxp+NrOJZdGaPg630D7MteVoUYUqGGEsoKHO6/qg8X1Or/bhQk8hhyNtNxn0ATNwx2zzb5ctMhIuZ5q0BrvZyKDuXCbO9c7v7rtbS+Bp+bKD5Ou4lRtkOv3P1xFBI1XLuvY3hcEeqfN8RdyVM2gi/m1YVSlQDfe0OxBKG1i3He5RYC8wqZuAYtZ69yrAIAl6rRYl4Cq/C60gOKxQ6qNpNQfyQVpt5lCBRffBnLFRn1o4Z+YoVgOuLrYHLU9vM+Q9iCMeyuKKDhMsQtOo/ZpvCZQx7vTva3DEN6F2t3gHVdKlJusfMJT+KRQ5YPO6semZrMxNQBlq/jb7lFXU055jmBNLickCrxf6OU7XAWr+P/gav48WZhXbmQRAChn6dxj1oLUDzso8+OhB9e87pukU7H/l1PrEDFwDRUBZZdbFMeuQRmwPMwbWc1TjMGCuvgwjmGKJZLr1moIt9bRKNIWCAe6We+vWzkAfgjX1a7El8NGYdMGLxDd86nNhzzbko4xlwaMAX3e5Ii5SCGGrbD+cDLmm6cQSHgMzAqlTm3xgppxw+AywcQ2mEZ8vtJG3q2l4YomHiB5K1w63SBwvb2nJ9cmirAFKh4zKy0o7MbRmk7gEMf4eOejgW8y48JrkAQ5HaBN6sueMu31weUhsWs7LptIRYLxoXGzaEjiIglY7HtmK+lLfKtG8DtZSaaqEcPZBMssGEDi0lkYtr9TCuscrXKmSPN/f0NdaOOtc1eKqZCUPN9KD7KCpJeKt6KIo96bac817hdMM4/mnH4yS3x6cq5XQrVXYCnjCPMDs8eQbvqvk8z4IrZNFf4/y81L/+lD7VNBoa6/f2dxysRI/9LEdGTDG71vSDlmDUR41g==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3cd82b-e5e7-4ba6-a648-08d88b74f6c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 03:49:34.4272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7x34JxREoxxPha7Wu/ClqrJP+29BNjaW4sZ1cv7pMsvWQBDi4PsazOji/PIfRNKNU3FwOET6yqC7x6x1/hee1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0590
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

There are 2 difference scenarios our device receives PTB.

In the first scenario PTB is received as ESP packet. First ESP gets decrypt=
ed and has payload of ICMP packet as PTB. PTB is 1280.
PMTU is set on the device via icmp6_err function in kernel. =A0

This is followed by device receiving fragmented PING requests. =A0As part o=
f ESP and XFRM processing esp6_get_mtu gets called.
And esp6_get_mtu calculates MTU as MTU-ESP HEADER-IPHEADER etc. Here MTU re=
mains as 1500 and calculated MTU is also fine.
Thus the execution works good.=A0=20


In the second scenario PTB is received as non ESP packet. However payload i=
n this packet is an ESP. PTB is 1280.=A0 PMTU is set via=20
esp6_err function in kernel. This function also invokes xfrm_policy_destroy=
.=20

This is followed by device receiving fragmented PING requests. Device creat=
es new xfrm_state and sets the MTU as 1280.
esp6_get_mtu calculates MTU as 1280- ESP HEADER-IPHEADER etc which result M=
TU < IP6_MIN_MTU and test fails.

Has anyone encountered scenario 2. Any inputs are appreciated.

Thanks and Regards,
Jayalakshmi



