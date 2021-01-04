Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88997C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 08:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51DE920784
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 08:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhADIFE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 03:05:04 -0500
Received: from mga06.intel.com ([134.134.136.31]:4637 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbhADIFE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 03:05:04 -0500
IronPort-SDR: f0wMwpFiyLGs/1f6T3oB59Ylz7ckoOPz6f1zhY1h98ZXICDjeYpxRZ4LmNcJoXq2YPigx0FRn3
 XD20cT22bMRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="238474407"
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="238474407"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 00:04:21 -0800
IronPort-SDR: BQL9JcsWXMeCYIF4OOE6YtIUf/9eZn9LkOgt3rCihTPCOVYyOhMQXjsv0zmkGUkR7qica5y0ix
 ygG9205LNWsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="461854161"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 00:04:21 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Jan 2021 00:04:20 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 4 Jan 2021 00:04:17 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 4 Jan 2021 00:04:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaotO5nSQdnS0j1uP0u3E83I/NyWq78vcPFdYxeegZlJcFUEiS6vwt7nChebm0t9sDtb0Zg5IQ7GJs7mmyq3UnyVQSzwOzb3Sf4I5s8FCmJhPawON54Uae2xNAUV9notUMf2CGyis77sdTpO9m2y0Opc/52GrlrO9KTgg/cA30MMDC6/u/4Sp1/ildfNF30nFf6QBfrpBmsoaVG0iUe+S+ziT9jOV/QKkOo+M6Swx+1jilPWz/yuDZd7biK4jerUD+EjMfb51+3UDRqxEjnZwnPTXlvzF5ovy3F1XCvzhlXRiPJt0lR4vtcrCeHUQ2zwBkuaM55vPNkUUrTPeryk6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ah9r3NDeTZWjpFvkO6zLT8ZqYNLseZE++V9l1CZ2sw=;
 b=HDQcH4Di1Ob7qpFsxQmWNO8VWyot6pwZMUm42qosuIQXGWHq31fpm3TkHXotaaNzj5a7toRe4r/M7ANHV1kQiAQNLlFu3lxsJPZXqftxvvUQaB3TKSfIwuyuZvyCa5VHoQjMJKlngtQ6cFZXsZ8FEVXPDV1wymMQsOODhZo9KBazPxQ9qQGggDUmPPQnLWe/sACcZ4qJnaGCgtFKiPRU9AGxoMF7WmJMrZ3+nqnnyhS54c3Wv9L5bZBzbQradFuy3QcfS3PobNQ9laDWypt5Qm6SsXz7NfMqZUNXwUoi5YWHI4YylPdcWuSoMIFAKbMa1D7zuf/i9k0+Wc3/DsMkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ah9r3NDeTZWjpFvkO6zLT8ZqYNLseZE++V9l1CZ2sw=;
 b=MjYAkrP/ZeODSQPZ6HePVgSpfxUo57v+Ct8D7OOT+4DbXBVRiXSzxzs4B/qoR01xm3v5i38xFM7FypaBu5i8jqLjDiKh3DxZdS/Er5pdjc2vngIMF99Ap3gQunCAft78DFhN+4jd5lUGX2X/sDqRWkmu9cuW/T5TG8/tn1bGZck=
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 (2603:10b6:903:b3::23) by CY4PR11MB0008.namprd11.prod.outlook.com
 (2603:10b6:910:76::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Mon, 4 Jan
 2021 08:04:15 +0000
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::b127:6209:1930:3b93]) by CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::b127:6209:1930:3b93%3]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 08:04:15 +0000
From:   "Reshetova, Elena" <elena.reshetova@intel.com>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>
Subject: RE: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Topic: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Index: AQHW1JkZ8lMRowq1QUyYZqNdBK9VvaoXNMxw
Date:   Mon, 4 Jan 2021 08:04:15 +0000
Message-ID: <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
In-Reply-To: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [82.203.237.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51eff534-fa24-4b6b-4988-08d8b0875482
x-ms-traffictypediagnostic: CY4PR11MB0008:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB00085AF340D61A507D4D6937E7D20@CY4PR11MB0008.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RczXEE8Pg3AeJsRiBxt+95EaatNDSiuWx3EYMbSmt8fk28l2Gj9DER15ttnWhClZXC9aWuVe/U3ZZ12X2C+NqGIzOhAhIlIaSYBYQUHVfiP5BrDGGYjU9P22TRv7YbHtt/A7fqsQLJ26cLM5NgYFCH4IHJ0iAXNf8f2PORuQ5wYZIDcL7jtuyWHfQp+XWPo6EbXBZUa7xIVzrbFFsfnWsh974+bM4FzrnSmrizDkDQt9WcCeiAZCWcUE6nhmQS6xTztdKtxV+e/09a52Wd4kYngPrUJtkRuK0J/pzHbUuaIcaqClvG2KrECIvQhiohLA1wOO4crn8isXUBlOfce3uxo15/AMaO/MhH5GMOuKqrQA0QiGe9BjMHQTSvEFVDNNq0+mohTflhMGAuS2sdetww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(8936002)(186003)(9686003)(7696005)(316002)(55016002)(52536014)(66556008)(5660300002)(66476007)(76116006)(66946007)(64756008)(66446008)(33656002)(86362001)(6506007)(2906002)(4326008)(83380400001)(71200400001)(26005)(8676002)(110136005)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?g/P4becq3uVQYas2DDva8lQ7T4MQ90wNnYfHzqVcmeRxSTJjtPuDHhSF1ZiM?=
 =?us-ascii?Q?0Za9pu9doGMXG5vVxXwnnx9ZTOl97xy0Q+bQHg13fu5i5x1tZGTnCO6MWtRi?=
 =?us-ascii?Q?1yVzMhzrwfpNLi4R128YnG9IxggkgGWMeyd7PAvg76o8mB5cohYBLVqcoe2+?=
 =?us-ascii?Q?GVZWkZmuVboEGH9vXkSYIVE+b0+2jHN0LbQ7QfvJUjYCRfsR0uuM3v1d4dYd?=
 =?us-ascii?Q?OlLGhOqVSlUO2Uk72xNgfdV+6c9xlotStb2k6+t7jG9WJkGqHqGAc/ZHms03?=
 =?us-ascii?Q?oPOVCee3KytELbAfcp8xA1Hqfi9SQot4Z0cOpOR7hhX+rYKEpdxEsILPWT09?=
 =?us-ascii?Q?SyiCbMsk02H506nbgRuXzfMUazssRRk5RwrWvPHw+hmC8NeV3BNE0lhKninX?=
 =?us-ascii?Q?1G7rL4tl576F3401Myn86KO6jDji6Wp5n6xUNi8wtP4iODR3kPS6FvrxvrBi?=
 =?us-ascii?Q?eWHHCzUdLSGInGo6oKNbuuKY5rh+Zmsw3jEm0hIFd9hbSAsEZJ5IxZaKDzJv?=
 =?us-ascii?Q?lN5jQ9xu/8GCiCA00f9ejDC/GbYu+/R4p+cDUY/1bOfwXHC1LvzhzrCSQXMa?=
 =?us-ascii?Q?SMm1glV5n5LlY2tAeRXrUEXkYRzh8U8+uKG+bkmj8ScWbEVwIERsqRVAx/Ip?=
 =?us-ascii?Q?4NlhGgPVKgL5Tu3xWXXPCHYghdgnlQDyxwP+78feJ/eZCKis0ttrrFFrYgOq?=
 =?us-ascii?Q?2TldRrB3XCmIZHR7pbHslhLubDgDYKkQhPyiHUC5DD1aQAhpl7uKEKK0v7JP?=
 =?us-ascii?Q?cX/p8/OW0HF6YuZm51uj96x/NEPrCbyLyOLmxyRSle7u2pTJTGta1hwcuwEf?=
 =?us-ascii?Q?H6U/9ix6ldpYXvMErjvjmHJ2KwRS2YZFFc254LnEICyAfLpnnmTLw5gCNuGa?=
 =?us-ascii?Q?0YCGyEQ0I1M7nl3k4VlcWRYqtLmQde/kmOnRF90wyKWI+fDsaSYhQB1AoZyI?=
 =?us-ascii?Q?hzAAA0LPc3UpEsxpVuGJRtXZzr4ZNWCnCHJgp9N6UEM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51eff534-fa24-4b6b-4988-08d8b0875482
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 08:04:15.6483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSPcbf4CqIteC8SScgNdFudD181oDLOiMLTzEswR9pcZJxEcPlE5cBjJODyGeZ9BDpA2+ld6keIwK/tcIkcE3sLK7QhmLOVs1WAB809sct8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0008
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> 2. The OCS ECC HW does not support the NIST P-192 curve. We were planning=
 to
>    add SW fallback for P-192 in the driver, but the Intel Crypto team
>    (which, internally, has to approve any code involving cryptography)
>    advised against it, because they consider P-192 weak. As a result, the
>    driver is not passing crypto self-tests. Is there any possible solutio=
n
>    to this? Is it reasonable to change the self-tests to only test the
>    curves actually supported by the tested driver? (not fully sure how to=
 do
>    that).

An additional reason against the P-192 SW fallback is the fact that it can=
=20
potentially trigger unsafe behavior which is not even "visible" to the end =
user
of the ECC functionality. If I request (by my developer mistake) a P-192=20
weaker curve from ECC Keem Bay HW driver, it is much safer to return a
"not supported" error that proceed behind my back with a SW code
implementation making me believe that I am actually getting a HW-backed up
functionality (since I don't think there is a way for me to check that I am=
 using
SW fallback).=20

Best Regards,
Elena=20



