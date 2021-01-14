Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B952C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 10:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0243B23A3B
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 10:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbhANKZ5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 05:25:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:14553 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbhANKZ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 05:25:56 -0500
IronPort-SDR: Iaemv8UG8BFGgWhLkNoXf4+fU9OhutJSYBXSPHTb0KfjNIJt0N6ru8v7Uy6EVENl6DllN6kyl/
 Fdkh9EOnKmtA==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="157522969"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="157522969"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 02:25:16 -0800
IronPort-SDR: jCnPvsNkg3N5g3ka/IS5Z0tuKrQSCYllz06thT7ZD/n3aM5LwACydveQYW7GuBEoekW1dQyD9Q
 073XIdARrgfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="364183561"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 14 Jan 2021 02:25:15 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Jan 2021 02:25:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Jan 2021 02:25:15 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 14 Jan 2021 02:25:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwfZNx1ekeA91z34k+4i7N7XQqQLJGGgJaxQAujAvjp56U+17jk8Aji5TNcI99vEsHR/91Vmrw1aSEDhKHoLzWFZSj0AJrspUFEbbo21uX+hPlTy2ozw1SR6YBt1CP7/XeCcZsNOzMSiwtHxl1qV7I3UD47nGQQjzST5f7hi/IqOralLuPq0va7jcEF8f1+zhvSaaUlZdG9TS8MINej25ZWC/WRb6H5l7zReGiyjAjgGwK8zuG+SHEKvyVp4KpXD9FRITeqEX1VA64TYpaZftHt1XRkuIQJE/bnshHxO6mCjX+8H9N79ODAhR46s6HYYM7N5HjrHgCKpS3Po3taz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERIrZ4m5d1KYk0MfTCJCnWt0s2c/hPhy+saT+4SvFPc=;
 b=Ln9ofRKutyyG+a+q1GlZQ+2+rvCqAbzsXCpbGMCoF6/40aZXKwTde4i/iKrdnQ2VJME83b3K3mtAminVekkpHFVEtGzGJrA/YGSmZ9TYKK74h30Er6TAPPr/p6Pay2Ql/jH2BkkEpByE+hbGVU4TAKpzChEkx1C+ibvTKWHNBxe2X8chdylqPWeRlvH19303gKtjbXNb6mftFMYMcBljroL7Jg64R5YhpFRIs5bP5vN02YVEAUP+8o0sh1hdK8aPgugMtNm+4wnBg9hddufuqedEGRVn1d4V8PmhvkxlI1vyxrs0SuZgRg/5pNRqU+KlzY21IJ+U2dGToDnIyBe5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERIrZ4m5d1KYk0MfTCJCnWt0s2c/hPhy+saT+4SvFPc=;
 b=SoApqTmRVHOufKPh2Qp//Qu9j+KPhMDc7eTsdMTMzet1dMhdpx9xKHUQX+iBz4+ZZqWo/MkyQTyFlYpUJ+eeJBIGznGpHgEJKfjVuc7va4zQ7hzHixHTILLdEraFNllqoUkuLbcUOfe2yeWBtag0gdP1YB+sK7tUkJ/zTFT+Jwc=
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 (2603:10b6:903:b3::23) by CY4PR1101MB2165.namprd11.prod.outlook.com
 (2603:10b6:910:24::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Thu, 14 Jan
 2021 10:25:14 +0000
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::98c3:2fe8:7b0c:f845]) by CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::98c3:2fe8:7b0c:f845%3]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 10:25:14 +0000
From:   "Reshetova, Elena" <elena.reshetova@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "ardb@kernel.org" <ardb@kernel.org>
CC:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>
Subject: RE: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Topic: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Index: AQHW1JkZ8lMRowq1QUyYZqNdBK9VvaoXNMxwgAA8YgCAADFl8IAPZGXA
Date:   Thu, 14 Jan 2021 10:25:14 +0000
Message-ID: <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
 <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <20210104113148.GA20575@gondor.apana.org.au>
 <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
In-Reply-To: <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [82.203.237.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f3ce9dc-13bc-4fc9-7b93-08d8b876ae64
x-ms-traffictypediagnostic: CY4PR1101MB2165:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB216516532C5CD77ED48279F6E7A80@CY4PR1101MB2165.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bYRk7yJ7ecaDLxTZqlXJy/GO9d/XLQW2kI4cWWAjTFjSPtWdBdOhQsAyyFzDs37T6VUVoyjUzG5yQSFR/87ixTBim5EM2NoYjkOSh+l85CJOD2Jf3WnChQpbvM78DFA6FO4RdagaAscEaxn1vARI8yW/4okittjG4ApArr3okSxt9I9yi+qOKXTK+788aMADLcbqkALrwOXLgCHaHpwu4RWdZhtsZgnBKX5f2g0MKRbH/VR6DWTGZMSwSn8U6bHwkNKHX+8jnHKf4V1Aab3LspYq6NRZZ8o36lct0pmo0pILwxFG+eu5Hrr14aPptEeWcLohbFcAGgSSvJFPGp/3JO8poxvn3wMunfuEzjDGfVGFVxHM9GQ/BjBewAX7vTzLWU3kxzcmBChjinaQj4sbdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(4326008)(76116006)(7696005)(64756008)(8936002)(71200400001)(66476007)(66946007)(66556008)(316002)(5660300002)(66446008)(8676002)(186003)(83380400001)(52536014)(478600001)(86362001)(54906003)(26005)(9686003)(55016002)(110136005)(6506007)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vgh2LSIac3BrxqPP6KbcR5h8Q/ehv4PwI1XNNbEXoVGXzAvIMbAm4ynFdCM0?=
 =?us-ascii?Q?/aW+BQ5KsupRUpqjNuap8fQdyNmpD8ckQGTQ2Ay34lACd5dGY+DhMVRaUl/1?=
 =?us-ascii?Q?3iln6ptX1avRLoUBXNsZPamL2Kuae1dvhVW9Xpv3+6R8AmSqtRKMUqWtU9Fq?=
 =?us-ascii?Q?Pn3rZdDa5sVqg+Dcj4CBmuRDSnMtAHVLCMIGBTE8GneO+c2oi7jdvWQtv3I9?=
 =?us-ascii?Q?6oxiitEaI8H0ujxgkS7606ZtBHyKPXhKdgV1tFqVuj8ZIjikAzbWtI78AHGp?=
 =?us-ascii?Q?H/vXysfHylzOqV+fPhF/g9zIXimHxf0T5DIO0KHNQQvS1fH0yOiH4ijPy9BE?=
 =?us-ascii?Q?2/+I2aUaE8u8h/6sz5K4OAd5Lk7GjpIKSfJjy/8Xj1/CcUKt+3Pc6HrTQbbL?=
 =?us-ascii?Q?+7FpVMBqOddvfu7F//CGpXfHY1tsnPDl6ECgqMjbWwHpS1x0IprDoyTZRCsn?=
 =?us-ascii?Q?YimuYUBTQHWBRJRMn1FlIbSr8nUwC7lXgvgKA2ASD4EflgjHGEUbVcF2aAIS?=
 =?us-ascii?Q?6H7isaIixibeM8gfD+Nu0dNOo82ICC4MQsFXjcR3u+X42hR+2ZKVOZL7FiVG?=
 =?us-ascii?Q?5vYdixf0TjP3mMs84qAE+UpjBn6ZpnK2FqcbVkKVkn5cG9AarjSZV2um9Kl5?=
 =?us-ascii?Q?obcOTQW/9b8huNaLXfLhLETy9G9PYW425tia3XxIUrZ57sAyIla+FrOMG519?=
 =?us-ascii?Q?7sZP8mSPe2x/lhHp0gw53P7/XxOFN0rksqe1YehWMF3vpqWNnMCy0FivmWfi?=
 =?us-ascii?Q?w2IWBaTqUjkIJYRRNNI77VstR7ZKgn690fHxbyK5xsru1iMkhVzY1FxY4yvY?=
 =?us-ascii?Q?NDYF1BdQ2LXl4n6MZuUJ9hoTy2/JUBh6K5MSFmmpXFPZUOVPFDTmv6y6eIIp?=
 =?us-ascii?Q?OLPddNJDA1BWVDwbTnZpcpO/142uHp/RA2UPNVm00hVYdN4ZoNxcyO3/UW9/?=
 =?us-ascii?Q?Dse2Xs0dzx/BG2NbL7NkjRPKMZ6cnND+q1QyfyPfvFM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3ce9dc-13bc-4fc9-7b93-08d8b876ae64
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 10:25:14.2218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nMnaX0MD9oHq1i95gm9AxHSuQRQ+xUj00ToVCbSZRqPhWsUA9VEiKvQA16zo5HPAjGrRT6XhjXwy0j2U1zU+NCscM4kdpu9a+GfQyUZp2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2165
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > On Mon, Jan 04, 2021 at 08:04:15AM +0000, Reshetova, Elena wrote:
> > > > 2. The OCS ECC HW does not support the NIST P-192 curve. We were pl=
anning
> to
> > > >    add SW fallback for P-192 in the driver, but the Intel Crypto te=
am
> > > >    (which, internally, has to approve any code involving cryptograp=
hy)
> > > >    advised against it, because they consider P-192 weak. As a resul=
t, the
> > > >    driver is not passing crypto self-tests. Is there any possible s=
olution
> > > >    to this? Is it reasonable to change the self-tests to only test =
the
> > > >    curves actually supported by the tested driver? (not fully sure =
how to do
> > > >    that).
> > >
> > > An additional reason against the P-192 SW fallback is the fact that i=
t can
> > > potentially trigger unsafe behavior which is not even "visible" to th=
e end user
> > > of the ECC functionality. If I request (by my developer mistake) a P-=
192
> > > weaker curve from ECC Keem Bay HW driver, it is much safer to return =
a
> > > "not supported" error that proceed behind my back with a SW code
> > > implementation making me believe that I am actually getting a HW-back=
ed up
> > > functionality (since I don't think there is a way for me to check tha=
t I am using
> > > SW fallback).
> >
> > Sorry, but if you break the Crypto API requirement then your driver
> > isn't getting merged.
>=20
> But should not we think what behavior would make sense for good crypto dr=
ivers in
> future?
> As cryptography moves forward (especially for the post quantum era), we w=
ill have
> lengths for all existing algorithms increased (in addition to having a bu=
nch of new
> ones),
> and we surely should not expect the new generation of HW drivers to imple=
ment
> the old/weaker lengths, so why there the requirement to support them? It =
is not a
> part of crypto API definition on what bit lengths should be supported, be=
cause it
> cannot be part of API to begin with since it is always changing parameter=
 (algorithms
> and attacks
> develop all the time).

I would really appreciate, if someone helps us to understand here. Maybe th=
ere is a
correct way to address this, but we just don't see it. The question is not =
even about
this particular crypto driver and the fact whenever it gests merged or not,=
 but the
logic of the crypto API subsystem.=20

As far as I understand the implementations that are provided by the special=
ized drivers
(like our Keem Bay OCS ECC driver example here) have a higher priority vs. =
generic
Implementations that exists in kernel, which makes sense because we expect =
these drivers
(and the security HW they talk to) to provide both more efficient and more =
secure
implementations than a pure SW implementation in kernel can do (even if it =
utilizes special
instructions, like SIMD, AESNI, etc.). However, naturally these drivers are=
 bound by=20
what security HW can do, and if it does not support a certain size/param of=
 the algorithm
(P-192 curve in our case), it is pointless and wrong for them to reimplemen=
t what SW is
already doing in kernel, so they should not do so and currently they re-dir=
ect to core kernel=20
implementation. So far good.=20

But now comes my biggest worry is that this redirection as far
as I can see is *internal to driver itself*, i.e. it does a callback to the=
se core functions from the driver
code, which again, unless I misunderstand smth, leads to the fact that the =
end user gets
P-192 curve ECC implementation from the core kernel that has been "promoted=
" to a highest
priority (given that ECC KeemBay driver for example got priority 300 to beg=
in with). So, if
we say we have another HW Driver 'Foo', which happens to implement P-192 cu=
rves more securely,
but happens to have a lower priority than ECC KeemBay driver, its implement=
ation would never
be chosen, but core kernel implementation will be used (via SW fallback int=
ernal to ECC Keem
Bay driver). =20

Another problem is that for a user of crypto API I don't see a way (and per=
haps I am wrong here)
to guarantee that all my calls to perform crypto operations will end up bei=
ng performed on a=20
security HW I want (maybe because this is the only thing I trust). It seems=
 to be possible in theory,
but in practice would require careful evaluation of a kernel setup and a sy=
nc between what=20
end user requests and what driver can provide. Let me try to explain a pote=
ntial scenario.=20
Lets say we had an end user that used to ask for both P-192 and P-384 curve=
-based ECC operations
and let's say we had a driver and security HW that implemented it. The end =
user made sure that
this driver implementation is always preferred vs. other existing implement=
ations. Now, time moves, a new=20
security HW comes instead that only supports P-384, and the driver now has =
been updated to
support P-192 via the SW fallback (like we are asked now).=20
Now, how does an end user notice that when it asks for a P-192 based operat=
ions, his operations
are not done in security HW anymore? The only way seems to be
is to know that driver and security HW has been updated, algorithms and siz=
es changed, etc.=20
It might take a while before the end user realizes this and for example sto=
ps using P-192 altogether,
but what if this silent redirect by the driver actually breaks some securit=
y assumptions (side-channel
resistance being one potential example) made by this end user? The conseque=
nces can be very bad.=20
You might say: "this is the end user problem to verify this", but shouldn't=
 we do smth to prevent or
at least indicate such potential issues to them?

Best Regards,
Elena.


