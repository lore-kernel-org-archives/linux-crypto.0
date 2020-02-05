Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EB6C3F68F
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 09:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57BD21741
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 09:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kXOMH7pF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgBEJte (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 04:49:34 -0500
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:40832
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728031AbgBEJte (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 04:49:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkoKNYRLyGcdSwHr7oxA0fTR2QFn9Adh//eIXGrnvhZSwFzSNRSwXSwMyySr0Dgucq/bohIrIgmr/p24Etv9joHyiJdaKE/WgO/Jxt4Z9jBmjQDSNCrdHxEVG1kFP94bg9SJ59S0O+TeTGBiw2NyqqmRaaYdPKptMyucg6jaOhnnh1Lsiyinezym6rPblzHe8RDujT1taJFV5cLGKSXcIKyxPkfZBjDLP2Tm7njNayhpDxffolIfSs2GfxSJtiCugbIv3jQnnaCJkmWco4OBL6q0gSmKT5xXLRgesB4B6mrmI3UddTXuAOJRX+14YvwLz7SLbqz2tf86DHO7FcP8ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15wZ6CkBoqfL4hv3h66jaCUhYQHAY+TQXRw3kHe/6Z8=;
 b=apd8D4cZbZaOKORkqbh2m3k++4QWU2crTjCuTAmhVGLO4CCk2PGy6Efm4WsvdVjXcBpsR3Brf98vIK9yJArb9TlqDXwKrdzvCbJqjO7LBIoL52mAo/FKpjK4xiRH3IAjs3KziTnh8vH8YGL7wD4XwNhAQaDZEQHRrSqbEE6yuh+Hq0Z+cU5QEBSD6wg0J6jopIP+9qayUdhQbyfOwHl6R7qQTrHjaAEr7f0g27786oObgqQAsb95ugTlaXDrBJ7kTyvC/VKQpwAsCBStvKsR62Fis/vDUJvk4uTWqozqNcmQvWeVoQndVfgzsj3mPAlWKt9w8SVtGKu7e6cWh5yQWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15wZ6CkBoqfL4hv3h66jaCUhYQHAY+TQXRw3kHe/6Z8=;
 b=kXOMH7pFdSPH29IC42xLzTNvvOYrw8gsyK2ZQSyfBpB9GZZm/JpOgWAYBreZNCgQs5n2Awhj0kXX5tvp/FAGIYHpVkPgMuJtgfmhqrsQ+PBDvhUhj2lqFSsMdEMRsT5UmntigdlO9/hbSxzq3T9PI8PwbjV9ChdAAn1QOalqkBA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3726.eurprd04.prod.outlook.com (52.134.14.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.33; Wed, 5 Feb 2020 09:49:29 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2686.035; Wed, 5 Feb 2020
 09:49:29 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/qi - optimize frame queue cleanup
Thread-Topic: [PATCH] crypto: caam/qi - optimize frame queue cleanup
Thread-Index: AQHV2ED0kruhWvne9kajdpPmzr8twQ==
Date:   Wed, 5 Feb 2020 09:49:29 +0000
Message-ID: <VI1PR0402MB348534009BEB42A1BBA806B398020@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1580480151-1299-1-git-send-email-valentin.ciocoi@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5b2d5d0a-03ef-4562-9d28-08d7aa20b1e4
x-ms-traffictypediagnostic: VI1PR0402MB3726:|VI1PR0402MB3726:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37265220E016AD4F7DFBD79298020@VI1PR0402MB3726.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(199004)(189003)(478600001)(44832011)(71200400001)(91956017)(76116006)(66476007)(52536014)(66446008)(66946007)(64756008)(66556008)(8676002)(33656002)(26005)(4326008)(86362001)(7696005)(2906002)(55016002)(6506007)(53546011)(110136005)(5660300002)(316002)(8936002)(81166006)(81156014)(9686003)(4744005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3726;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hr+n22NxTiVYZeLPp9K7jHKuNCx6YnhjrqUw7FhFDlHMe1i/vHmFBeghHFSEC9IBWb4uIhJTSRPeXNmxllzTSrkHZ3pgEVWvJJUGcRFyp0pDzo8jCWbmH6kTdjdlnzRKRTqwRZ9OmpI8I7XRvaQ9YWebhkpWO2ZDj653s9f4XmpRekKbcpZ4PPIm1AC52VWWYoJwqZjnhFRfn94zpytJAE8G617TBzoLUqkI4seUlfHLovDbe5S1q/UgNHrpSbVWtnxyogpQWXC3qh0rEuntjRSOPkkCpB3uHtA2egoFJOS2RWKEXT9y3+CGZqPjRNn3cWttbUuMV+MgoOhSPiCC6Iu/Wb9rYgaZkSQtKzLM1hffo8rJ0H8IAA/ekgyj7LDUtkx2cDXqIEsb691wZlER+Qpnb1TvgEAPUte7thb1hmwMqCknt3OwPJXjV9k7dd0m
x-ms-exchange-antispam-messagedata: mBEycM8WCyTbtbk+8w03jTWIq8QKetmbQVCjU3tWqcFGaavAeu6QnjqmY+0GQjXyrsPX44Krt0LiqEBG6d0u60W9WEHskiad2q0CUvi5bPh/L5gnIHIi1sd2sGJ8l2Wbv2jtKBg7EvYlzSZLYAfdOg==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2d5d0a-03ef-4562-9d28-08d7aa20b1e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 09:49:29.4600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyP2f0GTyxNtdn6fqoK/v2yxQ1LhSkSh54G60EZPxYsbPQHOSBLBszJ3SE6nJGRsyDs9JNittyOTUIm/vWvZ9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3726
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/31/2020 4:15 PM, Valentin Ciocoi Radulescu wrote:=0A=
> Add reference counter incremented for each frame enqueued in CAAM=0A=
> and replace unconditional sleep in empty_caam_fq() with polling the=0A=
> reference counter.=0A=
> =0A=
> When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy boot time on LS1043A=0A=
> platform with this optimization decreases from ~1100s to ~11s.=0A=
> =0A=
> Signed-off-by: Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
