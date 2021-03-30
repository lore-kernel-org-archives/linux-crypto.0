Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC419C433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 06:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2E76619A7
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 06:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhC3G5W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:57:22 -0400
Received: from mail-bn8nam11on2107.outbound.protection.outlook.com ([40.107.236.107]:12961
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229483AbhC3G4x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 02:56:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVDe165QmXA7GmHoZP/Iukzk38DJxY11C3FB5c/9sQ1vX+RS15/e0PiiHpEBm5mhSIFi0n5PToPRevq0Ezeut1qgrE6vvWEl6xu9FLnd71mG0H0CPx6ZJkXkfhK9zS6SwnzTXDPZ7nC9tYeajxSOcExEw8XYgfNPrApb2DZhdxdMgbxMseAtfGy103cRDw2T6tMbBRAwGrfNoTkYWWwa4dyRqNDodoaEsl3bwbdZiTGrGQBfvdjjp1BRGEbNyrchsxGw+2koHJ8QSY86A3lk08ey+OeQUCXOxeCukBafhQnEQ4jYvNfH7ztDQ1VevCZP8eyZpNDijvP8q2mLEAtxkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EKagDDWqoT4Q/Oy2Y/bXk/sG5M6dJJ3sGyCso1TOXo=;
 b=jigDC+UBK3oH8iHzijeoTXFui5ncfNYezDp7A+E0gDMz+QWcysndrB8St7zO9zpL9A7WdiwMjD9uu9wIdKrWdmQwFTNHQFl5NfsvsH8fT7FthVxhe3BuIi2JC9WJZ0mjN7JURkr7qbsYYmpZfNyQKgz58+UF0+rnw+7bOULIEjfM/UObvRL/RPTpjOa5pYIqGwjfAs2I23wvYw+XMBzP31UYQfO4Ua4M6qvA39hCHEDCXMhfvmmOx5nUnkdG6XjpiHRcl4jn8LoBToG9QlHFABZY3KXfi+JnZNSFXx7KwBmWKadUj1FT3ucz0cvQZtZlOyXNorUtqluIF8nR/Y9QgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EKagDDWqoT4Q/Oy2Y/bXk/sG5M6dJJ3sGyCso1TOXo=;
 b=QiujVq03wKz2qJgNfKt5CLDUA1YHQ9g0MeQUwVFjRId+SYQtp8SDca3bI62GcO99243KJSiXoAb5XUWASjHowNF93TmMna4YSHJGmv47swqPbsxlzTIjD7zopKjCN6WFHX9WGIHglQ9SuMv2MfjujlVTiquTNyhzWz7BW6htDaE=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com (52.132.152.24) by
 MW2PR2101MB1051.namprd21.prod.outlook.com (52.132.149.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.1; Tue, 30 Mar 2021 06:56:50 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%5]) with mapi id 15.20.3999.019; Tue, 30 Mar 2021
 06:56:50 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: v5.12.0-rc5: the kernel panics if FIPS mode is on
Thread-Topic: v5.12.0-rc5: the kernel panics if FIPS mode is on
Thread-Index: Adck5k/vM341SpSZQYayHia5DENU7QAHUl8AAAsnLtA=
Date:   Tue, 30 Mar 2021 06:56:50 +0000
Message-ID: <MW2PR2101MB08925B7CAAE1019D7809D460BF7D9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <MW2PR2101MB0892C9A8BF670DEC3628CFAFBF7E9@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YGJ+FrwrSRyvMHoF@gmail.com>
In-Reply-To: <YGJ+FrwrSRyvMHoF@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d27a9a7d-440f-4fe0-8999-3d51e90a7bb3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-03-30T06:45:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:e965:792d:4f45:db60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01aba343-0025-45e5-1d96-08d8f348fe9f
x-ms-traffictypediagnostic: MW2PR2101MB1051:
x-microsoft-antispam-prvs: <MW2PR2101MB10519D082E2DC402EEB34459BF7D9@MW2PR2101MB1051.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: twcxlrqb1SuTfV2PJUU4CemtLojoPtI1xMoDSlZaHydR9YHfqmDQ/Id4Eiek166L0tLCmGPY8AVb/Q8ByMwEND24RmqVDxYJtRMvVWqZ39HuwC6uuMR2VMHweKbHGQAU1WtsouxipkKZCvEb2WrtfUHygqmSOvHc0vNdISNR9SqNKXU+JF4NYBmgOKTn7ho/fQ2ZsqotKzYQZA2zTd8GRyc0RfTipF4Gm4K/LKl4GXLClG6+gfv5ZQyyM1gTNZpTdDmEo3mWJzfmlIaGWJMiWVXzz7mUkZ/t0luFBYJSNjO80aFAtbPBIJPQ2BFZvyg/hbsZ3A14GD+NW9MjHv9gg5Yi76axX/+1hNAtrs1sorysMgBASpB6R2LEQP92yN8wMAQu1sr6+wgHiKEEa9NyNnP0vAmsn5sYbhqsvFqMR0ZOYUMB2bpdzROworULXUbVDcuKAKo5xX7lnwbVV/FNKbQ4GIeI+NE5/qd9XrWtA49rB0xR7PSCXAJwk0/byjohK0Le5qqhVm1URGB8z6eRnF8jUSabcGq6z6NGAwX1aeQqahL4HxMbLtJtqcQ3BNnVVkTo6dTGYERWgXtae71KBn8S//+wMW8MirFfo6jnvKVMmFFlxsVUiuE6w2XSoD9B081+BX9izQZGsTDBYDhDjfaoee13ISHXDkbLYIXlb2Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(71200400001)(478600001)(66476007)(186003)(64756008)(54906003)(8936002)(6506007)(66556008)(55016002)(66446008)(66946007)(76116006)(52536014)(6916009)(83380400001)(7696005)(33656002)(316002)(38100700001)(8676002)(9686003)(10290500003)(82950400001)(5660300002)(8990500004)(82960400001)(4326008)(2906002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZQfilEUasXChX5bWC1GnZoyz27h/O4bUJVHry5gkaIUn0M/YJwLQKvwbHA6j?=
 =?us-ascii?Q?2w9uCU8U7u+UzvJD9dVDux1kg0NT7qyjVDZrf2y4FK14gfVezuZOfzEP9UJb?=
 =?us-ascii?Q?hIgX3cqpfhBWAPqYdTSLkK4P/kFipCJrQI5V0CEKB5JLx7dO+UdUzKU+vAxI?=
 =?us-ascii?Q?fQtTJ80DiecvRR3cEgoYofuYkuMXfV8H3PK1kNoaiiOTLgVhxcGUC8uxqojV?=
 =?us-ascii?Q?W6KJ+wwZKd6QHoAbVgu77U1EIqspzmfygZlkJuOT6JuBU4BuQA71CeovIqvx?=
 =?us-ascii?Q?fZNfx+mnEEbFxtgFGSXmrgAww1DnDfN0GSgvnE+Wt74RSSUcCYKKS/EHCgsq?=
 =?us-ascii?Q?ctbPxmjHMb5c2AFnaC3Rjha3MNbpNL2vXa2TUNsp+QUR/Ks9e0oKke3zP8Np?=
 =?us-ascii?Q?+n0kuXOsX2Jof9JveG9z0L1UZnxy3VJPAQ8GtdEVMMJfO+MwuG4g3l2KYGsV?=
 =?us-ascii?Q?hkdDxepAm/e7CkbfrXrU5exaXIDjoGUWU19cuyUCXXvzgSfOgNXauMeh3qz0?=
 =?us-ascii?Q?5CUwOS/O+j6ECal0nqfkga+ai2e5CIhn22shuEdKsjoWLkCTOppZPcs0vwoH?=
 =?us-ascii?Q?BEuBThRKCg+7FNifJG5FFc+WlnRQjlKWpugcZoZ5VPPOwbmF+JMF6B19v7c2?=
 =?us-ascii?Q?5DP/JsyVOdOsZo949BXQTz3HNpnHSq+Zua4qW0Yow0tMT2djV/i6drs1OfyY?=
 =?us-ascii?Q?MKz2fpoUL1yrTu9lDsrKzuTGdq0WLNBTo5g8jNig46dddZsX7E8NvfD1s+lV?=
 =?us-ascii?Q?r+tCHjQkzpe1hFLywJsATeQoUq39YLCUhm3oPgyI11I21p/QTs6LpED6t+gk?=
 =?us-ascii?Q?rUVdsvdsgkQ5KCrWFwSbj8SgMdWmH99B90GxNdibDFAPUoV45Bl38R7tlIpR?=
 =?us-ascii?Q?4X6COzrC7hw8fUXhSoxwYDAsHmwQxYyebHaUCNsJxYSXoQebTH2HLocgM1oC?=
 =?us-ascii?Q?V/KrIeGkOWoOwURXjRZQaNLseXYHlKvAOJFKfOcYRWFJ430BmhACXGZOJK+L?=
 =?us-ascii?Q?ua9pD1POSFdBZnYAZm0tB1WO3UUULqb2EJxv68lJ0NdFEZSTKWZPKXomyfOj?=
 =?us-ascii?Q?Lem4ii2qp/4x4T2J6Ug7lACs/6rD9Whd/EuR4Czx2YOwnpu1YbEROxDwo6Zg?=
 =?us-ascii?Q?AaQvdk/Mm6eOwxhaeVmmkwhacy4LbHPFVLiVCP8vYj2/rGHvn7xISqXCP7Ta?=
 =?us-ascii?Q?RL+FZ+ie8ppWcD6q+1Fvfe2I56TiN8fwaydvn0hah1lJX9TtUMjGS0YEvDQ6?=
 =?us-ascii?Q?5rdLsH0j11UMpXet5UF040OnjP9azebjavKgZ/dEayame7AwJdMXoEb1E01r?=
 =?us-ascii?Q?kYeiDcWowHy5pa2BmYNafybgrW2lQtavfNtr8yM+MMFSWFPeEAB8FMZGKT5J?=
 =?us-ascii?Q?SwUGF6YonemEK7esN5EuIK2usivh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01aba343-0025-45e5-1d96-08d8f348fe9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 06:56:50.6971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hwfWTU7ixHImRSn2agMuOmz9i+SNEe8fW4xPFB3ZKlZB/8YiP2chP9286+2ZXWB/X0GaZVN7HBQojCD1SmqJ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1051
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Monday, March 29, 2021 6:26 PM
> ...
> It looks like your userspace is using tcrypt.ko to request that the kerne=
l test
> "ofb(aes)", but your kernel doesn't have CONFIG_CRYPTO_OFB enabled so the
> test fails as expected. =20

Hi Eric,
Thanks for the explanation! Yes, that's it!=20

Sorry for the false alarm! Actually the kernel is faultless here.

> Are you sure that anything changed on the kernel side
> besides the kconfig you are using? It looks like this was always the beha=
vior
> when tcrypt.ko is used to test a non-existing algorithm.

After I rebuilt the kernel with the 3 options:
CONFIG_CRYPTO_OFB=3Dy
CONFIG_CRYPTO_DEV_PADLOCK_AES=3Dy
CONFIG_CRYPTO_ANSI_CPRNG=3Dy

and generated the .hmac file:
sha512hmac /boot/vmlinuz-5.12.0-rc5+  > /boot/.vmlinuz-5.12.0-rc5+.hmac
=20
now the kernel boots up successfully with fips=3D1. :-)

> Is your userspace code intentionally trying to test "ofb(aes)", or is it
> accidental?
>=20
> - Eric

I'm not sure. This is a CentOS 8.3 VM, and I use the default configuration.
I have been trying to build & run a v5.12.0-rc5+ kernel with fips=3D1, and
now this is working for me, thanks to your explanation. Thanks again!

Thanks,
-- Dexuan
