Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4395C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 01:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD5523A59
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 01:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgLRBJB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 20:09:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:30045 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgLRBJA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 20:09:00 -0500
IronPort-SDR: kfNjCz2USmZModxaRi9rSzNhz7ju9Cu8EG335/VBimsvwbJyTZeJC/QIP8Sxrg/KBhT2efRBFF
 iXfYR78WeDcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="174588595"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="174588595"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 17:08:19 -0800
IronPort-SDR: 0XfWgrrLP41yHE5YixE8id3EQxzpCHFa6Ts2A+UhtaWcRU5pnCL6MPKw/rYuMrhHowHOL0euhq
 VRv5ldB9mc2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="380258807"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 17 Dec 2020 17:08:19 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Dec 2020 17:08:18 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Dec 2020 17:08:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Dec 2020 17:08:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 17 Dec 2020 17:08:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eujOX37qMjbvcpaj69H9M4WJNXTvtboo4jFR03888QLRpo5uniXAkx/CzJ3NKcnJtj0Q9kxjQv7cvZxgMXQHjjQBiibMk5BDSYXXQdW9qV+JUfW5SrJpn91Gpkh8gcBAlXZ2BzLkaaxyujGrRwG8ae8whTWrSHbP6ADjqmdOMVPtg9D6G7fK6Hkpy+PKJvFppPhEggSYb37+rd1oQO3l4sbvPE5iMdSDjkt2Z04NIn4bfo0U2ZwtkXMDu0FUgeY8ocU8RqejLWpL5qFVwkbl5QXpUNqNlC7BDOyffFHCt1EF2iP/03QQKSdfP4IXaKah0MJlBTqjOBq9uzwGyg8xTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGm00yJCOLhqC21lq9f6hIVl0x7feFz9yL4qtEaSyGk=;
 b=ZS+vlTR++bWk0J/P6MbbgMSjWBRsOhS7msnFpdYiGmcNOJv36HdtPEsukpzuC/dBglcXCDZuiqGki7vl0bXH5AqAHGQpIzM1tpeuAxqU7E9SYuFoRVKoHyztkeszyocOsGoifJVUyO6TWdWjHHKmtqi35Kc36efJdM5EXEAuFgxfBDAgebBlHt7o7c8cK61E+uYjNadJBOOcugS3P7p8k5uit6Yt3ghaAK4o8Lgnek1Smz9VUDy9lPoH+W7MIUnw8Nc0pnGjTKOxMZvpJVtnBJhhaXNsobdb9pXTbxh/1WIChSqO5HtNzb8CHV/UBik/kRQuptmD4u78wvfkr/yH9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGm00yJCOLhqC21lq9f6hIVl0x7feFz9yL4qtEaSyGk=;
 b=mt6B/DIpcOM4aGaRHP4aGUdgunMm1m2qcZ+BGEdveOD2VtdtYN7gfKm7kcZemx10JazfwGaHJ+p5Jmh0/4lXjLyh67/vlQfSRbgOvqY6wb/hmlWgztwxX4opYoZyVjVPMu5KTJS7+4RFD73Z8aNT2Un1x7Y7FrAh3Dh5b4NgnhA=
Received: from BY5PR11MB4056.namprd11.prod.outlook.com (2603:10b6:a03:18c::17)
 by BY5PR11MB4072.namprd11.prod.outlook.com (2603:10b6:a03:18f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 01:08:16 +0000
Received: from BY5PR11MB4056.namprd11.prod.outlook.com
 ([fe80::a556:7843:c77:936a]) by BY5PR11MB4056.namprd11.prod.outlook.com
 ([fe80::a556:7843:c77:936a%5]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 01:08:16 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>, "bp@suse.de" <bp@suse.de>,
        "luto@kernel.org" <luto@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Sun, Ning" <ning.sun@intel.com>,
        "Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/8] x86: Support Intel Key Locker
Thread-Topic: [RFC PATCH 0/8] x86: Support Intel Key Locker
Thread-Index: AQHW09NdTvKYqu53kUecoNyqJY7uyqn7qPiAgABj5gA=
Date:   Fri, 18 Dec 2020 01:08:16 +0000
Message-ID: <01BBB7F8-AE4D-420B-AA72-5E276A93B334@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <X9utMeDKfjdghy1M@sol.localdomain>
In-Reply-To: <X9utMeDKfjdghy1M@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [112.148.21.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fe2bb07-8f66-4ae9-c065-08d8a2f166db
x-ms-traffictypediagnostic: BY5PR11MB4072:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB40724D8AB806BAE20D4AA827D8C30@BY5PR11MB4072.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J3ZcFwFiu7uxHlM85q41bKDG18qgXl0hg65rsE5mq/75HPyGqxDvWIf5lRp+oO81WicfjwaiTPVKbtR4MlkqJyrmbFexVxDWNTPuChbe86RP1mRyU9J71TrkcjpCtkZIjeOaMJ6+qAsBtWN428xq7MT5SOiD6o1HFmuNjwyCMeepTbUKrmWAaevFgcRHP0CtX7hN+6exOs77dfVZuCeJ8xwlGR8B48pRj0pKjbgZI5yAZw6ghq5iazGdk4hT6h7Z51SrOvo5G8JxKwtP9YALohNzN7EhtAMH9ARaPHBQ6wR9eRxuLMticisie2GDZoElbojniKyuE/noufjlVX5rZbJpXvXyrH8dDr4sZI/HzgJ2Hu7iSTqzHRFmBd1Ma/Nepifv2Dr15KMdr5bH9Z8uc+SHMtSizzYCRp78GVHiGlnfJa0ISW8gtetJktcdy3rUYht5uBXH1UngHBughnshxRU9O7XCVNilzaZToG3zgg7l7c0JtH7wD7GelDnjk+TofG9l13+RbqGWyPxfJBAwPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4056.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(86362001)(478600001)(71200400001)(36756003)(2906002)(6916009)(6512007)(966005)(7416002)(8676002)(186003)(2616005)(53546011)(316002)(4326008)(6486002)(83380400001)(6506007)(4744005)(33656002)(66446008)(66476007)(64756008)(8936002)(5660300002)(66946007)(54906003)(66556008)(76116006)(26005)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?crvB/wVfJ9hEhDOfFzwLdD6isWFSsvIsetIs6Fuzi4uVixRZYo6qYULzFAkH?=
 =?us-ascii?Q?YenRfPy6HJW8kKdR+Zfc9stEffS7YG5mjrYO/umh4CgF+9sujbbQaSArdyqi?=
 =?us-ascii?Q?66LCwS5oeknLS8oVUq+OS6jPshLWcr8AxOOah4Kijc95353NQxaUvPvdntV1?=
 =?us-ascii?Q?7eIOoN+m1YMTlFX/S5ouXIJ8z/rPC7AjOLrR33KMMqXcTKBfnkgXvNRo8VVp?=
 =?us-ascii?Q?nTjhErvyv21qUA6LAATBS696CYhGIobrA+QAspJDjiu7RUtmv6x+h0GwNp9H?=
 =?us-ascii?Q?Ehwwck9skaD2yZxaW8cjs3wIdJFZbfIdib3ROKYgdPTYnZaoIXBEojfG3OyR?=
 =?us-ascii?Q?7HKcSEhpt6/KE1CewUdorlKqH/CtBAyPHrAF/FTI7Fap6wUgS/JHKjGsIUuH?=
 =?us-ascii?Q?OLifpPNObjSK0NWMgI5WkbN5bDh/1ylAK+uI5YyrYCD55Qhwt1MdKDiBM2ZX?=
 =?us-ascii?Q?sT0riXTbKRv7rLr6C/JYl//gl3pt45FN8QBNos+XwovSKCfKL/OB67YZXJqU?=
 =?us-ascii?Q?jOQF8X2GBOCUPXVYnCfBsE0DH5V2ygsRxVFizMgZ0iZMjPtvH86jInOByJ5J?=
 =?us-ascii?Q?7MDwnFsMCEYg1LwwYuT16CJhTxLG+OGZxxD8VxEfM0FgIndwLZ0xF7om2rFv?=
 =?us-ascii?Q?XP+K3BjycIa7sgLO+2f98wj8JDlg/lriPrO3gGQE8L+1bIwIe9JYIXoRQac2?=
 =?us-ascii?Q?spiqDREGvA2ursyDkoRhXcoIhF3KzVP3Q1+Z5uLkciqIP9E37j6WocbUtKhM?=
 =?us-ascii?Q?6g9WvIZFrWOQi4uMAsdbKCCRe7uQV+i4cSfm686VQaDTmhQ2TxX2M2fubj2W?=
 =?us-ascii?Q?PRhuwuMp93oujTk9a8IdcFGr8bXo5q60564guVqnqefWD6RpUe44xoUXqJlI?=
 =?us-ascii?Q?6eYacMJXJlpjKELktBypMovIGAmDsdQHjQuID/ELuy2tYI92xjk+fdRWRF5k?=
 =?us-ascii?Q?li6Q7ca8YXhtprq0Hg0i9uE+uEFZNw9nWHr7f6K1U82gMk+0TXWFAPEDU9MD?=
 =?us-ascii?Q?Si3C?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <509CB5DD2028A440A68D9C17601A898E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4056.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe2bb07-8f66-4ae9-c065-08d8a2f166db
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 01:08:16.8231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /MoGr7QUe1zu0NrD6cKaJFkZkajL81NSbraqqQ7C4x4oyN+fY8IS1qHCEpUydymgZ8+leApH+1kmsNzjq8dJKTqLoNq46de1jjROcypGwLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4072
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> On Dec 18, 2020, at 04:10, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Wed, Dec 16, 2020 at 09:41:38AM -0800, Chang S. Bae wrote:
>> [1] Intel Architecture Instruction Set Extensions Programming Reference:
>>    https://software.intel.com/content/dam/develop/external/us/en/documen=
ts/architecture-instruction-set-$
>> [2] Intel Key Locker Specification:
>>    https://software.intel.com/content/dam/develop/external/us/en/documen=
ts/343965-intel-key-locker-speci$
>=20
> Both of these links are broken.

Sorry, my bad -- my editor ate some strings with copy & paste.=20

Dan has provided the links already, thank you.

Chang=
