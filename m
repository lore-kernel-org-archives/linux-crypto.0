Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534C7C07E94
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 09:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 310A4610A2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 09:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFDJZn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 05:25:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:64269 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhFDJZm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 05:25:42 -0400
IronPort-SDR: pTu0ukoWtJVcVuSMX8IJFOAzPeXbOshByG39Zv2U+WQl6G9CdL2aVdgmkvVNxsU2eagUPV1dtT
 /REH+gy+5WIg==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="201237467"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="201237467"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 02:23:49 -0700
IronPort-SDR: 0K1zRFw7Kvnci8FIIPpPntvf+KhEq1euNVVcNii6lQQYXuvUN4qZXybAQbdmMZ9Nt12gxz9u+p
 d7f+SAtKzazQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="483851150"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jun 2021 02:23:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 02:23:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 02:23:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 02:23:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofWc7aQv3wpPrHJBd6Ccl7n+cNtWJiIissxDsv5gtNQX/eBCCqV3yDNPX+H0uinTmZXiUyP+g5MMfO1COseBGZ2/PAwl1yRhyUyAHN01+1HoRmad/ylx4cNky3Py5UGoPUvRkHBzvK/7d8PX1qZuBjjLq5w3UkIVd1iHaf0GeZ9tj1sadF+N6We7uNIbrmK4mrlexcCW3B9MS6e0oMN+CiYu+5N0OU3YZjXIeD0jy6FHjLqPTcdANEr7OKv5YeZp006JhuQNa2hRA/3ioPzRSudfYCMWvGHCsbf3aCq9JVDzqlN5DrRtNrvapSU4kO9H7i9s/XF092sokRTneD4qgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+B64yx5JRNd6WBubTkEm6j/IbWA35zbjbUSjOY/q7vU=;
 b=eLjVAL/B/qsflGD4WxI0L3Vrxy3zcJm2wTQp18oUI69n64MNoOTAVDBRqC3p91pPRAnOk1COhXGMp+oNLT7+2og2AoyHzzRLcbhl6eiiRETugKzd1LO+bA+2whJy33xGhw4ojYGkrOstx1Y+3KYrUSW+/hVMYYG5lECOMzSg1o1QvDBX/aQrK9CTDrM9JVHAZtRkN1PDOH9/DW0kD06OX/LJo9fqb85FmMqBPxGzrSZKXr5HStpND0XtUhAcTKrJ58AIsWVDD0TBF6JO1JSOqcQsSMYzRyhFvy3ZWpYMp4v84gW4MS1uUSPAhyBwC7kq8p0K9Nt9p0V/fdX8Rjopeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+B64yx5JRNd6WBubTkEm6j/IbWA35zbjbUSjOY/q7vU=;
 b=OBgFNNPeSTR9pzzOe2NmIqd5Nb4kemdP4wFEts9kplZTzAPT8zyW78MBUxlZM/QjGAKZ8yDhWTl5RdfTKvl64RmZ6HPbsCrI2tvnORR1m5GDJsrgY7lEeyFGj4AGuGod3Wf2E75TM+Pj+oN/jZDjluo33/iT8RrZAwJ0wnehnfk=
Received: from MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8)
 by BL0PR11MB2962.namprd11.prod.outlook.com (2603:10b6:208:78::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 09:23:31 +0000
Received: from MN2PR11MB4598.namprd11.prod.outlook.com
 ([fe80::9810:b8a7:e8f9:621b]) by MN2PR11MB4598.namprd11.prod.outlook.com
 ([fe80::9810:b8a7:e8f9:621b%9]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 09:23:28 +0000
From:   "Chiappero, Marco" <marco.chiappero@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Subject: RE: [PATCH 02/10] crypto: qat - remove empty sriov_configure()
Thread-Topic: [PATCH 02/10] crypto: qat - remove empty sriov_configure()
Thread-Index: AQHXUyxkPjTVKfPMokqNd4aL6CTqDqsCPfmAgAFa9VA=
Date:   Fri, 4 Jun 2021 09:23:28 +0000
Message-ID: <MN2PR11MB4598B0D816F3C31B1C45595FE83B9@MN2PR11MB4598.namprd11.prod.outlook.com>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
 <20210527191251.6317-3-marco.chiappero@intel.com>
 <20210603121537.GA2062@gondor.apana.org.au>
In-Reply-To: <20210603121537.GA2062@gondor.apana.org.au>
Accept-Language: en-IE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [87.13.7.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5146612-5e82-4dff-5834-08d9273a6989
x-ms-traffictypediagnostic: BL0PR11MB2962:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB2962F1283C9906F275F29388E83B9@BL0PR11MB2962.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t0xj1154kaG6IHJiCMUOHyjaCnbmLkMs9zrnWDrvHmMyyMEOUuq8IwHesZM2go0EGHANBHKwiNvnUFPHFZEFdSjCv4sn+FohbEnryaaAN8+Ac00qzHdLSdRHoE33HACGeOtnGKLvbFSQ3W5Pyefz8fEKMLW3aJUppHeAdBbdVf60xcTqe/ofAm6EQEkMkOHlf0o9/i2KT7hZzg+EKXJvT3sEEjnngZ3BddF0pSWp27QmfZXZpvvVB6MKkw5rveIyDq6hOcWG7L6mzaRkwWV0/A8Y+2RmJ5PeCkKKgzEVauw5BEDl9K0vtBK8F0BhOvJZ7SpASQgPjqi2mSDW8OaYCd92/PSs3/KHFyaenyPBugMOfAoLKf11nEtFSNEcFHUk40L695OzHlKoJD2vA6u2Iil2PbAQd3eqIITPr+vigRXBTXWjS9ABXvRIXrlkzPWdqv1hAaaHp/4+NbU1Q8Xuc3b2PTqc6PHTwRkaOO6x6P8BOorAbjEl809Rf9O960+XSr82tmVzoKL9Bmi5RFJOmzGdIGCoU72Utm4o93gjhu0JX9wFWUgjDLz05Q96ePVSl1HB+8M0a/wdSvch8r10DQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4598.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(186003)(4326008)(2906002)(76116006)(71200400001)(86362001)(316002)(55016002)(478600001)(83380400001)(9686003)(52536014)(6916009)(7696005)(54906003)(6506007)(53546011)(8936002)(107886003)(8676002)(33656002)(38100700002)(122000001)(66946007)(66446008)(64756008)(66556008)(66476007)(5660300002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0mXDOrFCgO14iF3NWQnEfpTwL4UW5o91swcgr7v8VOUJWy+UW79qJ2Bg40Lf?=
 =?us-ascii?Q?mLlxcNjp2hZgCNAqF/UuGKs+lYpVFcPUc2zKE3CzOLV1fYqUEUcxMBGtlMgf?=
 =?us-ascii?Q?AD8qAFe2LBHl61wF3QF8JGBfpZiqdy+0G1oa3U16ZEfXZ28Qb58v2GlPyqsG?=
 =?us-ascii?Q?9fbnqQkuKldrfz9LoUh4rtstP3rfHUPB26DkrTpSIIlfduw/AAVVTrvPKUwE?=
 =?us-ascii?Q?qkP7WMPMLJs6SjlIZLepjPEqEY/skpczkghFbBe16r3YFaIA418VwiyjoZWO?=
 =?us-ascii?Q?eMwu1WCT1YcXnHcN2dV44syDkV7qhJRS6x4lctA4ENLKz9sXVueE8wL6ELUy?=
 =?us-ascii?Q?ks7q4CeCU8QAixSu4mnjPD0qoVSlzONglPOACSDNqh2f6QeSTsYULK3soDxn?=
 =?us-ascii?Q?MJtMowqGoVUa9aR9YgKnkquqRkgrDKr3aro4ExcdqnMcfVuk6XYv2VUQe6M9?=
 =?us-ascii?Q?dik0ZP20RA6tzqN8v3RFrJWy9gF4o+2FIIo+3Dw6/gZ5xfRhZaX99VnsI2Nx?=
 =?us-ascii?Q?+3tLdvpvtRpZ5KfoTAuvQYzfIGv+R1zw5K5YgP59dwYhHEKroXQxsIryOu0E?=
 =?us-ascii?Q?rIvFgNfesYcynAw5kKQMdLJF3SG6UkkiI6PAHnNW89Tgc+1lz0AD6dEHfOHd?=
 =?us-ascii?Q?8X8GPry8pbb1cv7+ANJLtsK1QQgWQTfcmqpTled6ALjCtCZmjEnWBsqC8LFG?=
 =?us-ascii?Q?Z06oMWUw7EIspnkqA4u7D9W7pFb0F3YZ25T1Pk0cvaKfRTmNH7ffpePYYA15?=
 =?us-ascii?Q?onKhXE/5c6myTzVMAJGepAow9EDx6/vTIvZ5MX6FK/Go7cVn2TMs5ZxYYe1X?=
 =?us-ascii?Q?mU803EswuxAWTia048O+FOf0fysa/aacbwyn6uH2coMzOrTXZ/CzQ482Q2hb?=
 =?us-ascii?Q?XaBJPcUwE1ukuJGW/koWozzf82JMvhh7VYTljcA8hKFppNNV0BxR/FDLtThQ?=
 =?us-ascii?Q?wcQhR8U/rguJfGMWx61el2MMowKMksA9blE9Rk9+uF4l7eiNj3M9/4+AG7u5?=
 =?us-ascii?Q?h+RKgeNDu8q+h6ByMPX4b/TrtXygjGACF49qjlx4HgkSwQqAuaV71stHdATr?=
 =?us-ascii?Q?e1jUcPPNQVT8TX9vy+fFGzwOCydVvviBBdvMO8+WqWnsG/fGjytYkhUMolY9?=
 =?us-ascii?Q?d1/OplloyzAKWs7jid/75eUSkdg1cNpnTK6YH+Ax+k/KGIlcqge3mWByyEMy?=
 =?us-ascii?Q?vvokIq1DtCOyfY6OjCLXobB+KKCWCONWLmFyuZuG0aMQJvuscpJg/99L+NPT?=
 =?us-ascii?Q?5eASvfr5o72XhAzfFFxFbHc22WmlwqIkJ2rBJup69TGZrcyUK14VeUwTp66L?=
 =?us-ascii?Q?V9E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4598.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5146612-5e82-4dff-5834-08d9273a6989
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 09:23:28.0686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W5GRbbYRP2v5IFmoaLRweoS6GgZykb6StRu8R1oG0drjUo7G9KP/A4QdBgmtpmZkNvjpD59yGDF/AINTQY68l0+LDpnMr0sVvdtWJbsk5Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2962
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, June 3, 2021 1:16 PM
> To: Chiappero, Marco <marco.chiappero@intel.com>
> Cc: linux-crypto@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cabidd=
u,
> Giovanni <giovanni.cabiddu@intel.com>
> Subject: Re: [PATCH 02/10] crypto: qat - remove empty sriov_configure()
>=20
> On Thu, May 27, 2021 at 08:12:43PM +0100, Marco Chiappero wrote:
> > Remove the empty implementation of sriov_configure() and set the
> > sriov_configure member of the pci_driver structure to NULL.
> > This way, if a user tries to enable VFs on a device, when kernel and
> > driver are built with CONFIG_PCI_IOV=3Dn, the kernel reports an error
> > message saying that the driver does not support SRIOV configuration
> > via sysfs.
> >
> > Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
> > Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > ---
> >  drivers/crypto/qat/qat_4xxx/adf_drv.c          | 2 ++
> >  drivers/crypto/qat/qat_c3xxx/adf_drv.c         | 2 ++
> >  drivers/crypto/qat/qat_c62x/adf_drv.c          | 2 ++
> >  drivers/crypto/qat/qat_common/adf_common_drv.h | 5 -----
> >  drivers/crypto/qat/qat_dh895xcc/adf_drv.c      | 2 ++
> >  5 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c
> > b/drivers/crypto/qat/qat_4xxx/adf_drv.c
> > index a8805c815d16..b77290d3da10 100644
> > --- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
> > +++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
> > @@ -309,7 +309,9 @@ static struct pci_driver adf_driver =3D {
> >  	.name =3D ADF_4XXX_DEVICE_NAME,
> >  	.probe =3D adf_probe,
> >  	.remove =3D adf_remove,
> > +#ifdef CONFIG_PCI_IOV
> >  	.sriov_configure =3D adf_sriov_configure,
> > +#endif
>=20
> How about #defining adf_sriov_configure to NULL?
=20
OK, looks good to me.

Best regards,
Marco
