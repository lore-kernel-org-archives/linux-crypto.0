Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE46C07E94
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 09:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0E06140B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 09:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFDJ1b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 05:27:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:46002 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229936AbhFDJ1a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 05:27:30 -0400
IronPort-SDR: CPGg4WpqTUcWEP08JM32G60Q2nB/Bn7xggqtMqfeCWliUyKdO40Bwt9c3vLuAa5Z2EWAPfV5hh
 i39/I6PgdxFA==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="204237062"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="204237062"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 02:25:42 -0700
IronPort-SDR: 0bNmXvy+3wsCypK3US+PPrb+KMn5Ole/Kshch4WB08I3IJGy5WOC7ROg6fgUA7m86Tnj7n42YE
 8AoOk2C1N2eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="483851585"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jun 2021 02:25:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 02:25:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 02:25:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 02:25:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFnIcCJ3p0ck3Bxw5JE7LaM2Q2G1CJkKfAXMTUeBVrBN9jfvIsbQrJCvmoK/GKnfXGzrUlaHb2KEA2RBfZ9hK8mK6gxQkkEqRSMt+iLMr/YkEzRVukDbXGPd3elY1SyLyNLbqLp3Cq6NJtLVVmQwR9o+CTAvLsaj2H0eVrhsHQuA8P+E9Hhkj63fRIQpikQW6T0PU1ovaqjhVEvpX5l+llnOepRQc/fgg/mQjHCcIgCO4zL48kxVNmjC1+OxniBT4Do4kJ1xMhD1pLvnozyMljIgeqVHVx5TaxvFqKrJdOxnQx5m54cWGfDcBfnGB8LBaowWZ02Tds4IufTy5c4sPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TG1O0XlQYtvhGJJGfAFyVwo1ZLwQrX0Jim4Az6kSlm4=;
 b=aCsO9kqIsKzANP6nmyGoOG4ne+K5T/sOaIP2FJ/AFaoycpkf3ELklm/pAMp+g13f0bCr15bwc536N6bxgg8W4E5cZdMdL5lp5Qm92NWGKgHrYFUOt3mgHrIZyTNSyI474F3C1D31KFMrS9SB7Zu3n/7ptyN1j/PZLqv5onVrT4904JWywr45oWu+ZdS20jkuMsamCTSQFv8qX2u1o0blo0D2gCfjADAp8tlsNJIjMndvL3I50etilqDCYY9hnZQrS6yix+p414I5SsgyssP72/H90LQZz04gmHGdiMTFDz/tsBtr4D5Y4SoRPy1sGE/n/pR9x8GaVxP+v1DQeWMBhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TG1O0XlQYtvhGJJGfAFyVwo1ZLwQrX0Jim4Az6kSlm4=;
 b=S6nWswMCJcqoDULI7CaEqLHl/T6BIvk7nWqZs3SnG78kE1PgJZmrveawpOJ+ESaZmhoYyN08eQVT0JFdquHRv3xCCnlvpevYLBgM6/iHlorGYRK8ljI6dCWyZQFU9SksSW/5geekbQGN5xQ4yCzLowILkRYGPKiiDdWcvJOpOsM=
Received: from MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8)
 by MN2PR11MB4288.namprd11.prod.outlook.com (2603:10b6:208:18c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 09:25:34 +0000
Received: from MN2PR11MB4598.namprd11.prod.outlook.com
 ([fe80::9810:b8a7:e8f9:621b]) by MN2PR11MB4598.namprd11.prod.outlook.com
 ([fe80::9810:b8a7:e8f9:621b%9]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 09:25:34 +0000
From:   "Chiappero, Marco" <marco.chiappero@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Subject: RE: [PATCH 01/10] crypto: qat - use proper type for vf_mask
Thread-Topic: [PATCH 01/10] crypto: qat - use proper type for vf_mask
Thread-Index: AQHXUyxizwA/ExRIuEmtD+e94UxcQ6sCPhGAgAFiU2A=
Date:   Fri, 4 Jun 2021 09:25:33 +0000
Message-ID: <MN2PR11MB45984EF188CF5385A3BF65D5E83B9@MN2PR11MB4598.namprd11.prod.outlook.com>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
 <20210527191251.6317-2-marco.chiappero@intel.com>
 <20210603121557.GB2062@gondor.apana.org.au>
In-Reply-To: <20210603121557.GB2062@gondor.apana.org.au>
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
x-ms-office365-filtering-correlation-id: a1879a86-9f7e-4258-3363-08d9273ab48a
x-ms-traffictypediagnostic: MN2PR11MB4288:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4288C0530072551BFD000499E83B9@MN2PR11MB4288.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RxC5x6hclL+L/OFfb2DU4+FxVhdGgoWtHDOvtRntawi2+u2r5tiRn27gDRU5tVqDPhmcv/VuvvP2Zyl3J0m79EZlEMySQedeYoMTd3NrokU5z3+rbqZr1wZN+64Xj3DlWfAxd2aobUyI5PcNN9NBcbsB4viQnPXapx/+QgHpcWt0du+hFYZ5a9rxC+zW7vr7p9/6+uZ6hE2RodzEpxFym0rOL2EppBUq2eK1RSUt5Kilb0R30mG6vLe1bD6QFgKyQmtJcCIVrtg2t+4GvA6ERqqH2r9LvN4Nk4JL/SysQDmsiJxrxA0wB9PCIsvGeutGXgaH6KXrFL7jcxAocAgO2iqnWnXtZY36sgZKPS1fkQUklP1EOtzygKYsPivagvrbZXnwtO6Xi+CqM3HWIbu5H05MG7NSJYBrQHO7J9wrpo3cgX7/a4hvVnW+h7kGapTpsOb1f5ZbGMaJNt0m0TCgs1hwnu0aksYD8GR59UlHWSf3q2v1fd7nJrWcOqgkWWTMz/aamYc2SvsTuvXqvz5I70rntAIfhINBbgj+KHIoch5g7h2s3D+20HlwU5ivu9V9JV4IvjQscTR5unvLYWlsqmzvvI+waxxsorg6DavTOxI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4598.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(136003)(346002)(366004)(76116006)(66556008)(66946007)(66476007)(66446008)(64756008)(52536014)(5660300002)(86362001)(4744005)(55016002)(4326008)(33656002)(83380400001)(478600001)(107886003)(2906002)(8676002)(9686003)(6916009)(8936002)(38100700002)(122000001)(26005)(54906003)(316002)(7696005)(6506007)(53546011)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RNedtuBNlUHRhM1jbQGg9wmfTMrEQZAH7kpACYZKTmAwZDyg7Hw8J0BGd2k9?=
 =?us-ascii?Q?V7xQZvLgcyTWLjaf3DcjPIZAMsbHecLbIZ+lI5EOY4+7U2vBiXjH0NG9ldDP?=
 =?us-ascii?Q?JM+S3lK2cTMr2k/Waul+PwouwunHoH/W2E+U3MptMkbE+et9X65wRUdHKni2?=
 =?us-ascii?Q?wVCxqoeYt3sola/TBc0KmAL3Tc1SWvO1soO9evFbkusjXdnj8H02Tb330q1S?=
 =?us-ascii?Q?5K6IxzsL1m/AQT2uhbwfV6CRFiVr6385lbMwdWAm/ktJY39sICGlJ3uRGR3R?=
 =?us-ascii?Q?ZlIwbLEHpfdhTFokTPd3iQMdu/2PzzJfz9czfhYflkt6Za2catyhGjvQW6Wp?=
 =?us-ascii?Q?7ohv5U70UW6LoqCC8MEVQj8WtZBfXhn8fNdSTA9eIYsXctEmVgpUY2sJTzor?=
 =?us-ascii?Q?bnQxkezdzrl8CTujgWO2SHGpNKE8rIXIT6yj3Q1IahSuMvLThyH9hDdEifuG?=
 =?us-ascii?Q?cBuVu3EQuv+m+JH6PQRhgyKIWAJMQ+JR7l69T1ZMFu6VRWpzeBcQYKeI6JK1?=
 =?us-ascii?Q?BYhD3fTJa0UJATCG76wNqgX9hvvjyb6qvOEy+50Z4O5GQBgqjxenlBBxKNkt?=
 =?us-ascii?Q?2Kr4vCT2liCTi7YqkFsO7x6jaKi7CvtbvYqYWUwO8+ZOFqNyIBXwwO6STNmn?=
 =?us-ascii?Q?PPUuL3Nv8uFiatHY4PkXumPIor8SFQFUrmUBHHXWLhUxQp4dc1sVfy+SBhZA?=
 =?us-ascii?Q?XJe2IKmugjVgZiUiIKH5hUHL80hx3qcfQ/KSDTv3eqdoG0RFYDb83TN71oY9?=
 =?us-ascii?Q?Nsyp+0ypIgD8iJvwFrq3BoARSYIIucQGcosekLyk9eXRlFq24vEetYtDvMnJ?=
 =?us-ascii?Q?jiv6W3DDNJXmIfvfVmCr9REFI9T9mgQNv1h0ddXc2yR1q0e9Y9LufOnYZeeG?=
 =?us-ascii?Q?qOgAW8xs/QlYj5rmwajYGMw7NSgLS8bvPw7XvKKxz1NY5XCtrnlbcdm11X91?=
 =?us-ascii?Q?InSXo07/awuWkXXLo0z+XF0jIOOSJaR4iV4XEvvlHzRJ8TQ1KiKSJU63JTu4?=
 =?us-ascii?Q?s+1pVbmR9mTxPa5upcdD1t/zAHrFHeJJaVb4PEDkwn3T7lC6/i3OfxfnUJdW?=
 =?us-ascii?Q?hP2STf7xqefAI33kSIPo0n/hBYURvnKmwJYIZ4V6tvLSoMDDw4pACTa73rOu?=
 =?us-ascii?Q?qY2zQ/520qZY4a83n+vuz0rqK4lSLy1oE4ibqs66yZiwinazHIvOJscofLrO?=
 =?us-ascii?Q?jg1Ep6s0ZaG8B63B05jTe//JG7kqrL38c1RAVft8qsRzGZ49lNnV97i5jaVu?=
 =?us-ascii?Q?UUrClMcuwq2vqaB364aDM4dHI+48G3e81Aa4PaMNbMFThw4Bf+pkMn/Ny6S8?=
 =?us-ascii?Q?oDc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4598.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1879a86-9f7e-4258-3363-08d9273ab48a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 09:25:33.9073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GD2VF1a3zrbL8UZYN0HmaIRmk4JckF40HPMqIP8n728F62JPkt/qYcWptE47WOuN5jPq3qDDb0oX2lctDzxpH71jalzJDymkURTfQ5Kaf0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4288
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
> Subject: Re: [PATCH 01/10] crypto: qat - use proper type for vf_mask
>=20
> On Thu, May 27, 2021 at 08:12:42PM +0100, Marco Chiappero wrote:
> >
> > diff --git a/drivers/crypto/qat/qat_common/adf_isr.c
> > b/drivers/crypto/qat/qat_common/adf_isr.c
> > index e3ad5587be49..22f8ef5bfbc5 100644
> > --- a/drivers/crypto/qat/qat_common/adf_isr.c
> > +++ b/drivers/crypto/qat/qat_common/adf_isr.c
> > @@ -15,6 +15,10 @@
> >  #include "adf_transport_access_macros.h"
> >  #include "adf_transport_internal.h"
> >
> > +#ifdef CONFIG_PCI_IOV
> > +#define ADF_MAX_NUM_VFS	32
> > +#endif
>=20
> The #ifdef is not necessary.

Right, will resubmit soon.

Thank you,
Marco
