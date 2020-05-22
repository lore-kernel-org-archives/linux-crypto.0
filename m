Return-Path: <SRS0=VFM7=7E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49B2C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 03:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8761D207E8
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 03:20:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="Wfi9oRA1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEVDUx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 23:20:53 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:55297 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727779AbgEVDUx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 23:20:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1590117651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IbnyWKJpnzWMST2DcvORWBehlncGDgYvCxJg+y1ea0=;
        b=Wfi9oRA1LdC6KyGXY5NlfJCftg2E1cTkiMCNlCi+W47cSbop8TmJczU6glXwGHuoJmHppF
        grvmpT77fIIE363ZbFVUzbu/34ksMQ3HYsRsxONiqDn3AKGDGggWq0dehVUXZMESMOc0Pg
        4Xvi1mol2E7YyqM61ZVYzGhZGu0mRRs=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-ge51-xN_NqKYTwZqZlXl3g-1; Thu, 21 May 2020 23:20:50 -0400
X-MC-Unique: ge51-xN_NqKYTwZqZlXl3g-1
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770b::13) by TU4PR8401MB1296.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7709::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 22 May
 2020 03:20:49 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::fc7d:9cd:f9db:cfbf]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::fc7d:9cd:f9db:cfbf%12]) with mapi id 15.20.3021.027; Fri, 22 May 2020
 03:20:49 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Monte Carlo Test (MCT) for AES
Thread-Topic: Monte Carlo Test (MCT) for AES
Thread-Index: AdYv5DokmuoSohTcS6aV9BTI5pb2mgAA7F8w
Date:   Fri, 22 May 2020 03:20:49 +0000
Message-ID: <TU4PR8401MB054452A7CD9FF3A50F994C4DF6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544BD5EDA39A5E1E3388940F6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB0544BD5EDA39A5E1E3388940F6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.106.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03e810c8-27c5-429c-f988-08d7fdff2051
x-ms-traffictypediagnostic: TU4PR8401MB1296:
x-microsoft-antispam-prvs: <TU4PR8401MB1296DC4526CEA236DC082903F6B40@TU4PR8401MB1296.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 04111BAC64
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: repbVzOzdO87ZMQUd9OZlq3XViiYUsAKCr2DDpcJKUi0wWpIGwiVhrJKzP1SuUzFsUno8DKBf+7M2E4fMkWi+dcz4NoKtvPXb05Efpz612e/PERVebm8z70IKFduGO4SYmg1a3fpwM7zPWkh8edhisqCe0flGh4My3uEL4V5epGxQBzhTnn7su/SYsRgUzOnxVKRkbynHcU55gXTxsiknAOwEtDGI6IP9Fid2xGc7HuiBI1tGut1PLi3uHaZPvgbSc2xXuXviHxIgIppZkqpVrlwVS2HRPndatSfBK1tVSp5UOxtlYsaprn+RiubuUeIX1FsmC0G992Y8Xep2XDCIK2wxQdQQdT2Uk2TUZ105qWxac4xcgEo/xZ+X+wCTIEZa30et7nQCjWGDRNPmd5SHLFno7nPseEsZvDtlTVbLfA2tACbwjecGPznPGXT6CaA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(396003)(346002)(39860400002)(366004)(76116006)(66446008)(66476007)(66556008)(9686003)(86362001)(64756008)(52536014)(6916009)(71200400001)(478600001)(55016002)(5660300002)(55236004)(8936002)(2940100002)(186003)(66946007)(6506007)(8676002)(7696005)(2906002)(4744005)(26005)(316002)(4743002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wsVZ+VJuApEFEQZBIKoKZ7NFBR9A7veeHK5P1l9vU3oW41jlE1nzcpSX9vjd7DpZUdnUiVhMVCBu0AXwRARkYIi+vfxuYVBrNK5TN9sH+HQu20qujRJud/IAzE+qxhZk6/z0JzpMwtmSQDmvbjA8bamMz4jEcpqPMpSd0pSzbEBi7fvNtX4A1WvBArWd9rktml6JUSjosz+VH3ZZp46RMRfclfUmHmjKc/dEn8/fR9cu9QO0fh/A5vG69CxFPRFz5c3MUEa2CvXX869qDXSqOMIzwWddCa8H68voIOasB9luFfc7TFif7xAoDib+NpcWN1pIYVqnxTLN3IuLmtcnu3ShOhNb2k+Bbg9/uFxwkUMMY2CXhJi+XiJG6xtnEbX8J3n0HEYw5f/fvN5Bc9+A1k4jaGBhCTugwdpH4XSzqqPd+psV+uXVjsVkgro5Cl4UJZU610KAejXHYre1aP3/6JFoJbU7Uyw4vgYI5eZC7+keNWaSpkUx/CcdkB68M0JC
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e810c8-27c5-429c-f988-08d7fdff2051
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2020 03:20:49.5486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+6aM/NpuLQeQORhC9Y/47gQog9yrv1POxM+YoaVU/47PXr4djtCHTBtiRCL0pJqlErINwfrEoI7WR/KP7ZXqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1296
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

We are using libkcapi for CAVS vectors verification on our Linux kernel. Ou=
r Linux kernel version is 4.14.=A0 Monte Carlo Test (MCT) for SHA worked fi=
ne using libkcapi. We are trying to perform Monte Carlo Test (MCT) for AES =
using libkcapi.
We not able to get the result successfully. Is it possible to use libkcapi =
to achieve AES MCT?

Regards,
Jayalakshmi

