Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DC1C433E9
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 14:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC79207BC
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 14:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbhADOl1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 09:41:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:26364 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbhADOl1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 09:41:27 -0500
IronPort-SDR: A9c2mIycfKXDDuefbfshRH/Maa52vH4cr6yx9VnvaM/q9F4fW4J1qnMedQ6k/Vfr6zZ5Ty3mj2
 9sGo6UuiwC5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="156748658"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="156748658"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 06:40:46 -0800
IronPort-SDR: j8VPIfLP3oKZ/eXDnN+v+BuK3KtONSBYnZnfm+9UoXod+nazx5O8NT1CcIeaahm9IpGe9ZZG/c
 zN9iytjfgnpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="421391082"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2021 06:40:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Jan 2021 06:40:45 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Jan 2021 06:40:44 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 4 Jan 2021 06:40:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 4 Jan 2021 06:40:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFxX1WBCPOyCVRxCbqD5VDu879UM6KB+r0CBLVcV7k6/Jv4V4GD/fS17O08muC0D8iOwk+dgsvq9OjMksmSneYD3+u300GVcAYxYLA9lPRE7LGAkc8IEZq4Gu2euqgeqtt1z3PtkCoDtGBVdzjqsIAx+odr3rmc8JBiO82+oI3kjRm50r2N7+8EQY5mcSPZ6HAzdzepSl3JVTN2uzFokEb5tceIhtEEtpUya2Z6DpWIhJASLhzEsE5ZatAPcn2V++pJ7baZJGzYTPv5lyLC96JIMfcDpQUssTueKW6CfRyW3fEodWjXJnCheUDcd8pnQ/pM1ZxlCt5JntV7TsZfZ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8E26ROC4R4Hr2Kl9ZzOsFEpuQ9GQXXDYYG91rLxYbC4=;
 b=TdnrwnHauB85om7MdlKBaRCR/Dag3rizI9lhEHk0xq1kpOdMoMRGNSvqdXAcl/fG06YfIM4IyvMt3bXx4PfN0hqNEjy/e94SVt5cIJdtIRIj7pk0m1pssKOJ36hBrPhR3aPPeKVeP/220ppkCo6dxV/uXG8/zKDYQcbxBbaYPS+Xvcf7OL/QD1GYfXAMu48l5J1r4MYANLj4eu+dNiYFyBsOYpd/VzjxZ8Mq6UIIkXV/CvhYNYNUF4OPZM3JPvBpo2x73q7oF9asLmzA2I3xw5gz2all3IfJ3QhKOxdlH+Mp6TGO9xANpH1zoBZsYOk1AIkWsNA4tFySfhUqXcWEdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8E26ROC4R4Hr2Kl9ZzOsFEpuQ9GQXXDYYG91rLxYbC4=;
 b=qmN9jlX+F/DGZit0V0QyRIqkouWXii+YbjQEQouALW9PIBd6gDfQwkd4luoxf5U9iZS/0GWqmsq7gk3Z1JNhVBOtRcjLV3iTR5QXbfXfOkyCFxNhcc2j+KVED8yD432pGvJP3Nnjug0aDQe7V/Y8ikBVhFzcZtxBenjTS22Q7HE=
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 (2603:10b6:903:b3::23) by CY4PR11MB0054.namprd11.prod.outlook.com
 (2603:10b6:910:79::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.24; Mon, 4 Jan
 2021 14:40:43 +0000
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::b127:6209:1930:3b93]) by CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::b127:6209:1930:3b93%3]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 14:40:43 +0000
From:   "Reshetova, Elena" <elena.reshetova@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
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
Thread-Index: AQHW1JkZ8lMRowq1QUyYZqNdBK9VvaoXNMxwgAA8YgCAADFl8A==
Date:   Mon, 4 Jan 2021 14:40:43 +0000
Message-ID: <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
 <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <20210104113148.GA20575@gondor.apana.org.au>
In-Reply-To: <20210104113148.GA20575@gondor.apana.org.au>
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
x-ms-office365-filtering-correlation-id: 72a044f1-7a59-47e9-5ad9-08d8b0beb705
x-ms-traffictypediagnostic: CY4PR11MB0054:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB0054F758E9550B427D63C270E7D20@CY4PR11MB0054.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JUBJOhDkDm446TVle9kbd1bp1hdsMaIlayk/3VZrPZKuw7RFmNqNThxaR7V9R33Hp7fPzwQf+auDGSeM0SAo8D4ykeVtUw+p8N/2jqTE9WWgSFuHnmiSO6uamL/ce3EcECA8YOUYe9TJYuoKuvUmM0ySUy3boSdAaz0Czs2wMbus+5RFiXOTPndNTSSVXPS7ayAvn8TCH2wK7DIYYkTbKcsePgSD984Zr+H7MXr+zk/2H5dmqDGnaBA+91P/86feSnpqKMtrWcyBHXugAZiFp8bDPRM/QvhIXO8vyTv987KRpTtH3KYsex5bgpTLYVNYAjRcPvFxv5a3d1fNJdDaCD3blzMyoaGi/H36WUUT5PP5U43BC5hfdSUgJBrvNiH7iY0XqV8ESm6spBKRF4ypxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(316002)(6916009)(9686003)(83380400001)(4326008)(33656002)(7696005)(71200400001)(86362001)(5660300002)(52536014)(54906003)(8936002)(186003)(66946007)(26005)(8676002)(66476007)(66556008)(64756008)(478600001)(66446008)(55016002)(76116006)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VhpJjcdaWxiE3p9VQm8Jw9vhsfHGRBmYSEarwMehmmFH3rBNftIcRwIM9e43?=
 =?us-ascii?Q?+kCALJs0nG+RVRZt1OgZe2ZMzCV1PpnYGcRL+PUruk6Kn1NIDlSkyNAlC+ZA?=
 =?us-ascii?Q?oQwNOPiXMty9c099bLrxyxjcMPwsQyhENRBT/A3HrzTFavHSHhQsvXMtBLgX?=
 =?us-ascii?Q?y9YDojnzCJ1Id/sFo6YyzaGePKuc76P+Mrm248Hid+KlHhWQh8f0EUQzh37F?=
 =?us-ascii?Q?ewdUNNNpLd4sNe9oYHWQU3DV9048gonak+A/Ne4IHnponcBs3dP2JFoCaUpG?=
 =?us-ascii?Q?zFFpnFDIV8AmTUVOyKYlNgGAtsJM1xFyup4TB5WiPHuPlMFZpnu6oX6XxiRP?=
 =?us-ascii?Q?01YesZlU2uX10Fr8dwMhC3UjXjgkpa6EQDunRL23iIIPs0vzag/uNxffO/sg?=
 =?us-ascii?Q?r0ox3DEgeQwe9CSpe3ROZak9Gvbu31c4AJoHgDleX5gq8/Ol/7jVoW6Hh/Iw?=
 =?us-ascii?Q?uc9eyIftxCimqUBBO3iXfyvolfWyNrbIhcdrv1IcA2GWkuWYI20IR6HEUjm7?=
 =?us-ascii?Q?lYMH//3YXy7jiHLSBRYN7Uq4uISpr5Cbc7htyr4nnPKlhY3OLEVCRvHr/4KQ?=
 =?us-ascii?Q?y3MpcCla0dAbzStkYQesTw7ec5pBFfa5R0K9egetn2Rzcmt0TALlQYUnpkyF?=
 =?us-ascii?Q?Omkt45/BNAPODo90s4Ig61N+dd2Uyz46pGDDDvvkneBAq+6/FF3jJyU1wg8C?=
 =?us-ascii?Q?OAAQy5nraAKgMOkdGXizuomsVongmk7rihuvgJuPlh+LWfCdkL2pwqVX1wrv?=
 =?us-ascii?Q?BF0fahqR4skVxtJSSPSh69zQeZnAB4HpL7nhvAzYflqtt3Dcb0nkfJ++q4Co?=
 =?us-ascii?Q?JTH2bUCXtbZB778kQjPVH1TrfpDBxZGINpcHx8c+In+AZ57xZFzVBFaGXYWz?=
 =?us-ascii?Q?o7OxPWrbYwDFV1v5QCXf4kmjkC3NumuXxNYFAFydrjwXCk2d1U5TFBUFIv4S?=
 =?us-ascii?Q?KH/AdmpSN5uZhDCJhLFBVyGE/st/+UU8WQtgVZogKTM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a044f1-7a59-47e9-5ad9-08d8b0beb705
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 14:40:43.2911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s8fZf2WCZEMrdDmlPP+di44CGiThBIFC79rs376jVyszusDHgqRbwQWZ3i1O22iCrzypzPCjtJv9Fg5R7jtVKDCXciI7c6pDwf/oWvHYE0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0054
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> On Mon, Jan 04, 2021 at 08:04:15AM +0000, Reshetova, Elena wrote:
> > > 2. The OCS ECC HW does not support the NIST P-192 curve. We were plan=
ning to
> > >    add SW fallback for P-192 in the driver, but the Intel Crypto team
> > >    (which, internally, has to approve any code involving cryptography=
)
> > >    advised against it, because they consider P-192 weak. As a result,=
 the
> > >    driver is not passing crypto self-tests. Is there any possible sol=
ution
> > >    to this? Is it reasonable to change the self-tests to only test th=
e
> > >    curves actually supported by the tested driver? (not fully sure ho=
w to do
> > >    that).
> >
> > An additional reason against the P-192 SW fallback is the fact that it =
can
> > potentially trigger unsafe behavior which is not even "visible" to the =
end user
> > of the ECC functionality. If I request (by my developer mistake) a P-19=
2
> > weaker curve from ECC Keem Bay HW driver, it is much safer to return a
> > "not supported" error that proceed behind my back with a SW code
> > implementation making me believe that I am actually getting a HW-backed=
 up
> > functionality (since I don't think there is a way for me to check that =
I am using
> > SW fallback).
>=20
> Sorry, but if you break the Crypto API requirement then your driver
> isn't getting merged.

But should not we think what behavior would make sense for good crypto driv=
ers in future?
As cryptography moves forward (especially for the post quantum era), we wil=
l have
lengths for all existing algorithms increased (in addition to having a bunc=
h of new ones),=20
and we surely should not expect the new generation of HW drivers to impleme=
nt
the old/weaker lengths, so why there the requirement to support them? It is=
 not a
part of crypto API definition on what bit lengths should be supported, beca=
use it
cannot be part of API to begin with since it is always changing parameter (=
algorithms and attacks
develop all the time).=20

Best Regards,
Elena.
