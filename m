Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDFAC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6742361401
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhENUtv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:49:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:22953 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhENUtu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:49:50 -0400
IronPort-SDR: +fG6CL4xojaXl1Ao5rhzQGrbb4iOxQaNf8EoVMXiUcp47RsGvgKdQPfi4duqA2BibqzFzMYE8f
 c6Y67F22+PJg==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="200287443"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="200287443"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:48:38 -0700
IronPort-SDR: N+qR1S8b1hzigcgqfrjAK+eLTM+HxkqFsY8XalqBS1sPZ0GMkgRwKZl0KJrogaOSNjfWAQ8uoy
 aTuyZqAYWVjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="436656568"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 14 May 2021 13:48:36 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 14 May 2021 13:48:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 14 May 2021 13:48:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 14 May 2021 13:48:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzKg0x6nj7T2uLWpO4E9J9SAQgT5gqla9IkkUYUSVytgSHOp+RjXdz8UgBMvBX1yYJIf8xMYFSYYsPjLuBl9xaZU1SjzDEVcH4u7KdSVnmtdlLeHSqhKQkrbt8ZBdqGh1XeVF6qENIdoxe/vimSG2+lJgnP2TbTFAA2pJfRcqLWdxyYiiFzkggqamr2GYAJqcuP0vmHLUJ4vXK29RgFDPqD/iafxrM2p9uwZ+nJf/uFD47tqgMzn8FICd943ITuPnE/QrfTWtniJq4s2IKpv4TpsSkNVf1vgkhQhc9ZmsHIXkuAIEfW1osDbHDYVi32DU3Cemwh7j735mqgX8M93hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hC+eAbXji52uf0h2hf9nomj7j4sv+IGfeHz582YpBps=;
 b=UBqgrvKVcF6/K3ccebDs2IAFk7u+MLf+4DpGzHmft8R6XpeYV5ZXqkaSOMNbuJSJiyuoFwGyzjATNWj/AwvZqw1aiURn0ezokso8ANyKqLjWSRbZzZcTZtDD5U/+NPP/sAv4UXmMomNFWgVAEwGT4cz0/oi35TrltG/XNz2oVOUj0r9DT8Qgy+yNaox18SjhVKNJEOx+B2YBTFCGU/L39PvxgzC/t5H+VdPtAj+jdOBdGNgOItoKYlyFQ5VjPLKzwKTd6Z1FrK7hrrvjFiaPWiqGyGLsJ1uS0/cBGipNfTdJSGVsESf0mPTZbHdVyx1DBT4DMgHIvDYOI2J2Fq1gqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hC+eAbXji52uf0h2hf9nomj7j4sv+IGfeHz582YpBps=;
 b=VL51LxtpBR9ORrjBuBPt0rDuVUE0OhTnZqXiv2i2kTm5DxZ1sn3ACtgsK41+TUlVctYGNRd3eFqLPm+ZwvFtEcJbj018LDIwjcQJNWzqDizUWtlwuiZNaLbxE26o3XO0vix6ewytDrO2quQNfr08bI86qf4XT0Q0mnXh9DiOKwQ=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5158.namprd11.prod.outlook.com (2603:10b6:510:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 14 May
 2021 20:48:34 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673%5]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 20:48:34 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Sun, Ning" <ning.sun@intel.com>,
        "Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Thread-Topic: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Thread-Index: AQHW09NkgKbOTl1SG0GiKIj8N4sTZA==
Date:   Fri, 14 May 2021 20:48:34 +0000
Message-ID: <53AC005F-DA02-4648-9CA9-64C9A1E6C9BA@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <20201216174146.10446-8-chang.seok.bae@intel.com>
 <CALCETrWbuf6jJU_wfKwuCL97SZhXd9Vqfd8RhdO1uwLZKMM=Fw@mail.gmail.com>
In-Reply-To: <CALCETrWbuf6jJU_wfKwuCL97SZhXd9Vqfd8RhdO1uwLZKMM=Fw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d21ff535-170c-46ea-66c0-08d91719a462
x-ms-traffictypediagnostic: PH0PR11MB5158:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB51582E9C3CB58DEE10DBF0DBD8509@PH0PR11MB5158.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pdycq1DgJCDfvhLfDl7Qz1ZLsdkH6XS7/fxz2TT8Dx1hFqqDzC0lAIV66ifOKPaMA06oE6TnH28u3F9nZTb7a4SPi5nMtpPhFs51ubo8Vdy8IzyQj9NulXXVt91oEqH3N8rsex/eoJPNswH9JwevKy33N2ZP3wwQYyEyt5b71NaRAt/2xNbFz5dROtDt570x2Hh+p503DcAn+wMp9udTVbcpOY7qvm5Ch+Jyr5EDGIjcBV8qhkASIbwixC1NyQs1Rdfq2TdRaYQEKP0r+7iRORsjfObItw3AxtTC77QB2QQMFWQpbL+V7WdmuSrw9iNZDwPvbitB4tLyQsTgP3GLVx85cn5auDF1pF3/DRR8+KmaFnZNW56WCqtBn8nrGwsx3rOhXLMoPSehDTOa/ael2DFLKY88ukqsrAtD4+pz+BXyf+j4tBvEM7uEdICZoc/kmehSTbiDqYAY9rW8l4zvTtsC+bTwxL08FaVCejkYAND4uflhLzHL3+9muYdX7Ycv8Ugc6K+ynzvCrmfejkSs4ibYqWnxZMbqlJiS2x0kjuvvGuTi3rt5EBq2C/gBc3xuBoTLDDDez9azKkWtRFqy04J7LVWgrEVn6IqSqThfLCrJjjTaBtJwkJU4h8gi71w/eqyca19jau6uAKFiJeJAf9m4OSdKdxtca69xSvqjX+3byEQNjI7SPg7SmmQzZ7VNDIssNp0wTUBiw4yRtBJ2po+LFf0WxPumM0Bx7hl3wBcUYHNJr2ugMZ8fDGbdt6VPysa2H1PTQknO8facC8J5ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(136003)(396003)(6486002)(5660300002)(186003)(53546011)(6506007)(8676002)(64756008)(66446008)(2906002)(4326008)(2616005)(86362001)(6512007)(66476007)(66946007)(71200400001)(6916009)(122000001)(966005)(33656002)(54906003)(316002)(66556008)(478600001)(26005)(8936002)(38100700002)(36756003)(83380400001)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RWJIeTRTRGg1V3RzOHVsa3hKN2loS0VjZzdMbEFRSjY3REZsTDJvVUlaTEVR?=
 =?utf-8?B?aURtNDRwdGZFVFRrZlBVM0ErR1BaMXowMm9tMTRDNjBkR0xDWUF3RGNkSTdo?=
 =?utf-8?B?M3I3dWZXMmVtYlgzZFkyazFDOU00U0FoZUF2bmhkZUo2elJDaUl2b2t1ZGxo?=
 =?utf-8?B?YjBtcXpadTFCTTFlOWNCbmxjdFpXZC93SG4wVmtMbkRLbVI0UXl1THV0cUhD?=
 =?utf-8?B?UGlyYUJXNVkybkRIcEhPWDV6bE1IQ283TkZIS0YxTWJZakNTbWgxK0NOY3dv?=
 =?utf-8?B?L0RsWnlJa1NrR2NpK1FNb2JwTkUxM3BSUUZRT0RYQlo3UDUzYjgremgybWZN?=
 =?utf-8?B?d0pHdkh3Mnowc01zdnBHWGIzMkloK1VOK2hvd0VuZ1hsSkxaUTEvOWNMMm10?=
 =?utf-8?B?UzIzUE93ZWVNL1liMTJ5STVLSGpRbUFIZFY0UGFhQXZpckUrcUVmSC9tV3dU?=
 =?utf-8?B?UmRyNzNiZDZ6QjkrQ01qVXhic2VEcDVySENidzFzcWUxVjdrc0FtZ3dnTGhF?=
 =?utf-8?B?OG9UV3ZUVkluYTVTa0xIS3J4dGxxSWt1MmFmZ3VDeGk0cDNVd0hSMUZYdWdF?=
 =?utf-8?B?YW42cWlycWVhSnhMSTR1S2VPeWk5UUExcy9wakFTVDhUc0tuaWxFOFZmQkN6?=
 =?utf-8?B?V0p1VjBBMEptSDhLSmg0WDY0ZGlWY0ZXV0wzNU9yeWR1M1JPTTltV1Bjb2FU?=
 =?utf-8?B?blJHSzZWUzRmQzVDVEN2VEdGR2JHY2NucDZEMVEvYThqenJYWlUvbkg5K3Bv?=
 =?utf-8?B?SnZCbEtGa2ZTL1hHM1o4OWdyMHR3ZHA4RnFPbmx4Q1RmOUYyRnhkRStoZnZC?=
 =?utf-8?B?a1drdWk2bTRJelMrTU5GbTEvUjlhK2pmSWYxMGVhd0NDMkJQNDVsdEIrUDdV?=
 =?utf-8?B?YzM1OVlYQ3JDRlFyU0xUNzBLMFE0cHc3bXR5ZDNSUW1YaDRtUytJdVNPVmtn?=
 =?utf-8?B?N2VRbTdyN1FkV05qZ0xXVjVuYnJmeFNlRjVRMUNYZGRCd1k3WWthVEJiYnFD?=
 =?utf-8?B?emdKMDVXdm1tNk92akd5enc1NXUwQmhhNWZoQndSM056S1J4Wm02TU11bHdQ?=
 =?utf-8?B?TU5zbXMzRlA1K2VQN0pucm9Ecm9hdmlrMHVSeVVwQVpoY09HZVJDc01vRXVw?=
 =?utf-8?B?YWt4cXU3TE1Hc1p3eGRqMitFWGIwcGtHZ3FVVjYvZ1dhNlZQRCtCclg4UG5Q?=
 =?utf-8?B?MGhyMWNNNXJDaE44SnY3Z3lteDN1MW5ha0huYnF2Z3c3L3Jac2sxaWRJL3Bk?=
 =?utf-8?B?d0h4MXhta1pES3dNeHRPd01SRFJ2RzZ1Rzl5NVZMVTlCNDVpRENwUkE0aWNk?=
 =?utf-8?B?UEljREY1alVNUXYxUXppRTVEMVpNSDVXN0xyVzhDeTkvWEM5bFNzcWRqQThE?=
 =?utf-8?B?bHcxelBKcCt4WDhoalk3aG5TRDhIR0wxL0RocDhucmVEWkJ1aDFxY2NKNWhV?=
 =?utf-8?B?Z09ZYlpGQldKR0hnR0lHRkh4SFVLM3FtSm16WUI4REZEQVB2TkowNFdOSE9H?=
 =?utf-8?B?RytXY080YUt5Z2RUYXFkZFc0cnYrRnlnMHhrWVNQTENiQ3hEV3UzaFYrOTBY?=
 =?utf-8?B?S2tDaHJ4K0F1cmNMOXpHcnQ0SnpWVWFVR1N1SHliNkhrczM5OFIzc2xFN0d5?=
 =?utf-8?B?QXd0U1VxTjllZVJoQ3VoMkN5TXROVGt2UlYzK21lWGg0NGxBdExVL3haSWpO?=
 =?utf-8?B?eFg5ZHgrMjhXWVhyZkJBMlVFNWs1SXlIb3ByVnlxY0l5VDlOOWZnbk9LQ2NB?=
 =?utf-8?Q?96/MgtGDxz6GdRGbvQYC3Uj3G0UjErDL+d8icWy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4521F4DC49143B41B2DD0B8AF3952A9A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21ff535-170c-46ea-66c0-08d91719a462
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 20:48:34.7108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XgxcmdTsBQJeyFq52YkGVvV9qM8XfxFeEBq9npBZat3hHAcFdki7/JKlJyOSG8U683Mt3TC1CasAQYTjcuA6R336l6RC5q8j85H4E1ygTsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5158
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rmlyc3Qgb2YgYWxsLCBteSBhcG9sb2dpZXMgZm9yIHRoZSBkZWxheS4gSSB3aXNoIG5vdyB3aXRo
IHYyIFsxXSBpcyBhDQptb21lbnR1bS4gDQoNCk9uIERlYyAxNywgMjAyMCwgYXQgMTI6NTQsIEFu
ZHkgTHV0b21pcnNraSA8bHV0b0BrZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IFdoYXQgZG9lcyB0
aGlzIHBhdGNoICpkbyo/DQoNCkl0IGFkZHMgYSBuZXcgQUVTIGltcGxlbWVudGF0aW9uIHRoYXQg
Y2FuIGJlIGEgcmVwbGFjZW1lbnQgZm9yIHRoZSBBRVMtTkkNCnZlcnNpb24uDQoNCj4gSUtMIGdp
dmVzIGEgZmV3IHNwZWNpYWwga2V5IHNsb3RzIHRoYXQgaGF2ZSBjZXJ0YWluIHJlc3RyaWN0aW9u
cyBhbmQNCj4gY2VydGFpbiBzZWN1cml0eSBwcm9wZXJ0aWVzLiAgDQoNCkkgdGhpbmsgdGhpcyBj
YW4gYmUgdmlld2VkIGFzIG9uZSBpbXBsZW1lbnRhdGlvbiBvZiBFbnZlbG9wZSBFbmNyeXB0aW9u
Lg0KSW50ZXJuYWwgV3JhcHBpbmcgS2V5IChJV0tleSkgb24gdGhlIHNwZWMgaXMgcHJhY3RpY2Fs
bHkgS2V5LUVuY3J5cHRpb24gS2V5Lg0KRWFjaCBDUFUgaGFzIG9uZSBrZXkgc3RhdGUgYW5kIGl0
IGlzIHVzZWQgdG8gZW5jb2RlIEFFUyBrZXlzIChvciBEYXRhDQpFbmNyeXB0aW9uIEtleSkgYXMg
bWFueSBhcyBhIHVzZXIgd2FudHMuIEFuIGVuY29kZWQgZm9ybSBtYXkgY29udmV5IGFjY2Vzcw0K
cmVzdHJpY3Rpb25zLg0KDQo+IFdoYXQgY2FuIHlvdSB1c2UgdGhlbSBmb3I/ICBXaXRoIHRoaXMg
c2VyaWVzIGluc3RhbGxlZCwgd2hhdCBpcyB0aGUNCj4gdXNlci12aXNpYmxlIGVmZmVjdD8gIElz
IHRoZXJlIGEgbmV3IEFQST8gIERvIHlvdSB1c2UgdGhlbSB3aXRoIHRoZSBuZXRsaW5rDQo+IHVz
ZXIgY3J5cHRvIGludGVyZmFjZT8gIERvIHlvdSB1c2UgdGhlbSBmb3IgZW5jcnlwdGluZyBkaXNr
cz8gIFN3YXA/ICANCg0KTm8gbmV3IEFQSSBpcyBhZGRlZCBoZXJlLg0KDQpObyBvYnNlcnZhYmxl
IGVmZmVjdCBpcyBleHBlY3RlZCB0byBlbmQtdXNlcnMuIEFFUyBLZXkgTG9ja2VyIHByb3ZpZGVz
IHRoZQ0Kc2FtZSBmdW5jdGlvbiBvZiB0cmFuc2Zvcm1pbmcgZGF0YSBhbmQgZG9lcyB0aGlzIGZv
ciB0aGUgY2hhaW5pbmcgbW9kZXMgYXQgdGhlDQpzYW1lIHNwZWVkIChvciBhIGJpdCBmYXN0ZXIp
Lg0KDQpBcyBhIHJlcGxhY2VtZW50IGZvciBBRVMtTkksIHRoZSB1c2FnZSB3aWxsIGJlIHByZXR0
eSBtdWNoIHRoZSBzYW1lIGFzDQpBRVMtTknigJlzLiBBZG1pdHRlZGx5LCB0aGlzIGluc3RydWN0
aW9uIHNldCBoYXMgc29tZSBsaW1pdGF0aW9ucywgZS5nLiwgd2l0aCBubw0KMTkyLWJpdCBrZXkg
c3VwcG9ydC4NCg0KU2luY2UgaXQgY2FuIHByb3RlY3QgQUVTIGtleXMgZHVyaW5nIHRoZSB0cmFu
c2Zvcm1hdGlvbiwgSSB0aGluayBvbmUgbWF5DQpjb25zaWRlciB1c2luZyBpdCBmb3IgaHVnZSBk
YXRhLiBTbywgeWVzLCBibG9jayBkaXNrIGVuY3J5cHRpb24gZm9yIGluc3RhbmNlLg0KRm9yIHRl
c3RpbmcgcHVycG9zZXMgdGhvdWdoLCBJIHdhcyBhYmxlIHRvIHJ1biBpdCB3aXRoIGRtLWNyeXB0
IFsyXS4NCg0KPiBIb3c/ICBIb3cgZG8geW91IGFsbG9jYXRlLCByZXNldCwgYW5kIGZyZWUga2V5
cz8gIFdobyBoYXMgcGVybWlzc2lvbnMgdG8gdXNlDQo+IHRoZW0/DQoNCklXS2V5IChvciBLRUsp
IGlzIGxvYWRlZCBvbmx5IGluIGtlcm5lbCBtb2RlLiBUaGUgdmFsdWUgaXMgcmFuZG9taXplZC4N
Cg0KRldJVywgdGhlIGNvZGUgaW50ZW50aW9uYWxseSBzZXRzIGEgcmVzdHJpY3Rpb24gdG8gdGhl
IGVuY29kZWQgZm9ybS4gT25jZQ0KZW5jb2RlZCBmcm9tIGFuIEFFUyBrZXksIEFFUyBpbnN0cnVj
dGlvbnMgdGhhdCByZWZlcmVuY2luZyBpdCBoYXZlIHRvIGJlDQpleGVjdXRlZCBpbiBrZXJuZWwg
bW9kZS4NCg0KVGhhbmtzLA0KQ2hhbmcNCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xr
bWwvMjAyMTA1MTQyMDE1MDguMjc5NjctMS1jaGFuZy5zZW9rLmJhZUBpbnRlbC5jb20vDQpbMl0g
aHR0cHM6Ly9naXRsYWIuY29tL2NyeXB0c2V0dXAvY3J5cHRzZXR1cC8tL3dpa2lzL0RNQ3J5cHQN
Cg0K
