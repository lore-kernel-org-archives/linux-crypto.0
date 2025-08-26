Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0652D3A74;
	Tue, 26 Aug 2025 04:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756183333; cv=fail; b=B5ntmWzbrVGyueJS9fCJZfYMkxK783X9n+GpXAbLK/YROY+eAocngt+i6vz4SP0hDLBZnfA4v89vcHdk71i2uupU7mOiGbY08EWAiBBsLtpvOcYWqMVu1aO32fSC2bTIHP7l4IFEpWg+I7+rFUdl9c9J4hiIwamaRYBq7YRNrns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756183333; c=relaxed/simple;
	bh=cVntlBN9vvajU/WLhBRUBE2G7KbKJq9PexZX9qP+EAg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NUBW3/9EnNMKmaUSB5r5CVEmTAwoWIZlHT7hw7MXkjo//56bUavbAnS63qSqy2qBWu3/ydRDKEsbu1fiKcjQjAPxrTrH4Uy7Iv2bhkEGOVQPkiopA8AqXRBHqyt/uY3kQqgAAr22bNHhRMk54AiDJFogDiAe3vesIi1YDbkhdEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RugVQqR0; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RugVQqR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756183331; x=1787719331;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cVntlBN9vvajU/WLhBRUBE2G7KbKJq9PexZX9qP+EAg=;
  b=RugVQqR0NU+wtc4pDyl/REJwiV4y73sH8U4gOwmWlMv87d1LtUMebYyU
   lZe1C4isHLMXg4ZsmvzHpQCndGMBDkzOWrHbpcrdHyR4vdJT0Avv6MqHq
   almoVozJT3kaEU/SaqyJGXmcJ0r5khyLwGliAHOR5zT6WE7Z7ZbYZXIkt
   PPpChC2JHehl7blZCLG4j5JxDXLDLjnfHdD4lQ+mRvKYVYtgt1rJEdBG9
   NptHCGM4b+lq8yJ8hjM5kWYQgBhwubxYsqkETc+NTLssyud7PRhPYMkba
   5FgGXgBa8xdQmUQZOc/p8Nv3jxuMj/VLw1JHvRKIDHy/MGVDXL0IRudc2
   w==;
X-CSE-ConnectionGUID: m8VCgMXOQD2vPCWGTws7sQ==
X-CSE-MsgGUID: Q61EnzTKSbe56RFjSbt/Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="57608538"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="57608538"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:42:10 -0700
X-CSE-ConnectionGUID: H1ououUZTaakZcq3QCzB1w==
X-CSE-MsgGUID: JOwiUvcTRf6YdrEkR9Otyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="206632233"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:42:09 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:42:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 21:42:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.65)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:42:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IxB1yYvOcREjJJ1D19yPNygV2KD7ynY21RskF0Wys7ZvP4WySreuWQo0exjw6Q8ihDtV3BcSTPuA4Dv8sA/B1AYWqzRSKyhLUqsZDzMtQH8/aMFw/MDPpmhWB0n4c0kbMFKPGaFQMldYcnQ6wgDux4cEabi+ARLAyIrDFHd1K90mF7MIBKoEe0q7Djgz3iICrX4IPw1UBDFekjtj0/CDhMDHCbeq6KuRTP4eBJ0zsvRv7F3K97sWFMOxliAZHqY4nILR+OD6rx22w87r5GS61IlzL5sBF6i1ZLrBrnuxVr/fNuZmZsJaUSRn0RcNrGemDe0fnTap6eqVOacs4cOJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J02x/HgCuwtrJ+zb2sjSynU9LTCKaXxVKoRNG4Kd7rY=;
 b=F58LZ+j9sKdKj2XJAvvznMGJ3MSWXiaq5n69bwMWYkVxoQNf+PXYGfCbvlvBoDqSdE/ggy84UDCStgrdmgIWEsd5WFajY7tvelh81DPo8fT16FpzKTrssDLnLZsUJkQbW5J2WRVyfH7oq7pMe1nY6OiYDCyeb9nbrXTsRqpMYpLjv96ochEMSJPWHEZ8VfB+KDJ8XwKHDdUudmfApoFQjrqytHVnH/NhIfNuav8E6Og63r8XuKr7MDmsl0bMkUiwB78pfUtDkriDWDuchVy92tq8MmdykAsqUk6OsMRru9v0WEitf3VfdEy21LX/oZnC5gh+9MGXjsvt6lyTpgfpBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ0PR11MB5769.namprd11.prod.outlook.com (2603:10b6:a03:420::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Tue, 26 Aug
 2025 04:42:06 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 04:42:06 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Nhat Pham <nphamcs@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcAp3n35LtSdVMgUSnKQGImY3Y0LRZeWoAgAnL+YCAC+jI8IAD0bOAgADL1oCAAHxNAIAAJ5EggAALHICAAAZtEA==
Date: Tue, 26 Aug 2025 04:42:06 +0000
Message-ID: <PH7PR11MB81210C3555CBD57EE10DCD61C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
 <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aK0KNAmQh_JVgnML@gondor.apana.org.au>
 <PH7PR11MB8121473792ACC3AD50D5F129C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aK00t9ld3YOWJo1I@gondor.apana.org.au>
In-Reply-To: <aK00t9ld3YOWJo1I@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ0PR11MB5769:EE_
x-ms-office365-filtering-correlation-id: b0b73dd4-6f8c-4346-671a-08dde45ae8f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?6r5AX9kSCPY5T/BSuMQ9KNtNTnE/TFTrnWIanDjJVekRDP85LwXbR9AxEXWk?=
 =?us-ascii?Q?YXugMf9cIO74Zz4O8U3PmlB0WeK+CBA1A0NqPE8+pOa7TvOivn4mPhisnsWC?=
 =?us-ascii?Q?amdo+QYNhwhlqwqIKcsuUAZBce94dlRIiB4M1Uan/iyywphmVOvokWIY9dNk?=
 =?us-ascii?Q?LcuZd5t9NtwQO7CKpEPEaSWoCgrNSWRkNRTlM7h9oM2oaGkRmU9jM43ORKFU?=
 =?us-ascii?Q?lEhngsXF9BaFADsw8vjXUBz9dmE4LHKN4Am84lhvhCWzfuEGqnKPp44XGZI/?=
 =?us-ascii?Q?AFIrfqqnauaR+wKfK2M1LtNsWMa3GEXNOk6+M5kZByMO5Kj3VggrtyKY32sG?=
 =?us-ascii?Q?BniJn9ZvL1NADK+6zMOZwjsOhhRhFWYkeKMoUtosjFD9IQE7QF0Jrs+QzAC6?=
 =?us-ascii?Q?dgF7ZfAQEZGrVCIZwTIlOF4afksQT/oVI8IXmIRmdr7WRrqP+9Yf/XMOSf9w?=
 =?us-ascii?Q?BIPObHp+EkLw7JzFas2Fc/JIji3jGuBRIdytDab1rAAcfb3jDAixjz89ePFl?=
 =?us-ascii?Q?zogxPC/IOez6aE/ccgzCmEeZXzPjNfulo4m2LbEwjDBSg6KyzYoCVgrukFJ0?=
 =?us-ascii?Q?HeNdB7cM+oWhxxy+ajIOq6C1PSvxLH6MuefDV7h5B/b5t82LGnKFQyg24rOh?=
 =?us-ascii?Q?D5qZJN4iQgLNBeylfEE9h3k63rvLmYEBa5E93rPn3SuplCX4QVrWSQhqFCEq?=
 =?us-ascii?Q?oIbsVS+f7D9waMaqdRGc/SY9x1SCkrk+o3VApC/cdbCKDZzVLF709p8KBA7o?=
 =?us-ascii?Q?rlnXJUjY2q7wx9ln/l2nHgRUDtYylIctiWxAMDWhoF6ElXMhlhfQv/Z0BhlX?=
 =?us-ascii?Q?rx15CdmnY6hI7a9vPWGz5FgP1PxtZdaC/ubGBgvQyLp0tA9K6jHLgq/hhrDP?=
 =?us-ascii?Q?jHsRfPcsd9kZqDYVH2WVV1WwL0ABqtFXU6VK/tDkr2WJIzwVM1mZqXCoVYUP?=
 =?us-ascii?Q?+wpYzvPfNvkM7nFozQYRBBjBf7o37P32azo65YOhtKLJYTjtjLltxpgrv2EX?=
 =?us-ascii?Q?d6+9CYexlOLlBPnnsPwj5pBpV4C5NzrBY2DcAVHW8krOfVFxPIdJP4Kr5UgS?=
 =?us-ascii?Q?0vnX6nE/xLl6bm8FcjNZVReDzSeF18/kQZd6B7741U0ceYk+v7c0uRIorUPo?=
 =?us-ascii?Q?c3iK+fMMvCB/okIkCRlWxmHvPmuZKBx5l2p9fg8TV9zsqJT3B+TytXvDz+Xu?=
 =?us-ascii?Q?QG5yvm1VMyKYSEL80r5sosrY8B2QGIyl1KpnOeckbjPZPwzSd1qolz2z1V69?=
 =?us-ascii?Q?gODWLuKEq1F/OaylVqp4r0pkosYcJVjP4uhs80j4UrxoM9VVejW8bb0Hq8s9?=
 =?us-ascii?Q?4GBRVZktTL4ZUBh7kN6X0BNzCf35Vu77SUnpfzT+K0S3zrL55/+DZOP63WSp?=
 =?us-ascii?Q?frsuPjT15HmwlPSA3naUpGgB6lnvARazQb7zQHxJ8TB72mURu6GQ+t3TiJ1q?=
 =?us-ascii?Q?SMWNgu6dqpQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IVLA8Mdz+sxs/2TZXh4OvyvBgJpviBOc3QKB1ke5joPioLW4QLTUqkkvq+yO?=
 =?us-ascii?Q?fHZuUYP1IiJyQj7TDejWLtp6Yb0mhiWcOAD88+63C2DfGlepHQNL2KTCJRu5?=
 =?us-ascii?Q?3G+sT5rM+/Zx7dy4xwqf8V4pVxKIqDW+63VMHV42Z95GQl6aPNVx7/HdLpoT?=
 =?us-ascii?Q?pBVvY4QxRt6lmX0K90x9rnotqn67dCPw259GAGhCHS8TOykjnb2cOZuicDy3?=
 =?us-ascii?Q?I762mBwNmv7/2WnN7w05to7PbUHQf5hf7dnkvOAANgjk0lf/Rn1mRYZ7VR5T?=
 =?us-ascii?Q?x4CiFutpRtMqQs7BX+usqI11cnl1YrztICWlP4Q1U8tVppo4S03mriHTejDN?=
 =?us-ascii?Q?CXzSPlQiVoqHO0GmC0OSL6QF517HIhN5F39QgW+j2jNEmYkZ/LJuoDO79tC6?=
 =?us-ascii?Q?T9r6ft4Lvuxhh1483e0/9QFEUN96gtX272VgzjdK9b+JuufTqz5aTKAYYNJ+?=
 =?us-ascii?Q?t/tDcpfaroDlj156ktPPRkWPNU/kY9eEGz6nCBlo9oHzvkqQbjytWHe4WVkw?=
 =?us-ascii?Q?5IlasO+49kE/2JK7Ly3+1b/aIcVpETD9xQ7Hdjg/EcoijNOJfkMF6MHyCXst?=
 =?us-ascii?Q?fCQtmvTXfkXE0I3098wEbDF+Ftr9o6dZHXqmESqp8qg5rscd3eEXKO7ggHAe?=
 =?us-ascii?Q?tsLrvvmFf9R3HCD+Ai8vPkCzSl+Vh3A/Md06OHj2hRtQ66/v3l1TFIt3d+P9?=
 =?us-ascii?Q?tcfm9iJoAFjrpIblgbdnlZiD7w4ObGlpIi297MZPcMjmOLy4MwvZjInNg5Ym?=
 =?us-ascii?Q?bugShzc+yQJvPkCDD1VXg+o+OzKkQBU3uJbYCRgIVBbJ26k4DQalqsit1aY7?=
 =?us-ascii?Q?ywP/7e2LN7k8Xlhk24fwOjT+jAYLUOAiR4FoxbSIEbigziTgsSUSQ2P4p1sg?=
 =?us-ascii?Q?poW4krZLykT4UG9fTbFgZKRhhAmbhnyhB0hQwY4yk1jpnIGjg9mIoOpQG7l/?=
 =?us-ascii?Q?nMlMfbUgrG/esuz03f0Y86FtZQlzr1SICdBLJXRPNTwymQ2NNkDHH1pcJDJ9?=
 =?us-ascii?Q?0QD8vkgtnfiXaUnyB5qpAQUivcwxMG8NTKbUBPjpvId2VMcmuryMlI7V4QGh?=
 =?us-ascii?Q?tGg3r9wnE8X0Q1lW7QpxCVOGKMJ0U7kjid1iTnVKeGmoGRUM0Jrh8QRE1YW/?=
 =?us-ascii?Q?LiMKZ0/wD9mvmz9StO48l/oX0LDSocAOfkLJCV20FpaGu1YHjcJubOagU4Hp?=
 =?us-ascii?Q?AuJeI6N5vFZXpSnAjt7XjE7RhkjytXF5QdkB9qyzlbby6Yd8BZH+7/Y9QM/U?=
 =?us-ascii?Q?U4C+kKZrKVQ1dLUnOD2YcIntGN3BSwQhaBuncxP/1rBZC5ASlZgdXOKZ6z+W?=
 =?us-ascii?Q?4eoi9Mei/GQWweEYmx8+Aw2isEKYn7jPPpJjSeyYFo9wu+CA3Mhqq0uIkWvJ?=
 =?us-ascii?Q?LQboeHq/Sr8OP+uNJ6GE/nmNGbGhYISHJKa+NzVlckleLH56nzVq0zxQgPfJ?=
 =?us-ascii?Q?4S11jKOjYtj1q3RFi/q3EbBiUv4MOghXtyeNl/AtJJyvEs5+2fJPVdzhPVCz?=
 =?us-ascii?Q?VFEqTHQGaa7gOsBliiil72f6/8JVDyfnVtDU9cbRbjjblIe2cBTj48AzyaU8?=
 =?us-ascii?Q?oxr3nNsQjJ5oMxYWRO2AH09ulamrOAjTwHCgQHg7slacpIWQ0/D8W9w9LnEG?=
 =?us-ascii?Q?Qg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b73dd4-6f8c-4346-671a-08dde45ae8f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 04:42:06.2655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5348XVOYqEIVBRLi0JwkqjVJVFDv+lxHEphgYSvVABPwvv5oRiz3wJzZ8KmBVvkFzhqaDuXWgyMJDr2SHbWshf0ZH7LD9DtXVYVWlaiuZTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5769
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, August 25, 2025 9:15 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Nhat Pham <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; yosry.ahmed@linux.dev;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
> iaa_crypto driver
>=20
> On Tue, Aug 26, 2025 at 04:09:45AM +0000, Sridhar, Kanchana P wrote:
> >
> > Thanks Herbert. Just want to make sure I understand this. Are you
> > referring to replacing sg_set_page() for the input with sg_set_folio()?
> > We have to pass in a scatterlist for the acomp_req->src..
>=20
> I'm talking about acomp_request_set_src_folio.  You can pass just
> a portion of a folio by specifying an offset and a length.
>=20
> >         for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
> >                 for_each_sg(acomp_ctx->sg_inputs->sgl, sg, nr_comps, k)
> >                         sg_set_folio(sg, folio, PAGE_SIZE, (start + k +=
 i) * PAGE_SIZE);
> >
> >                 /*
> >                  * We need PAGE_SIZE * 2 here since there maybe over-
> compression case,
> >                  * and hardware-accelerators may won't check the dst bu=
ffer size,
> so
> >                  * giving the dst buffer with enough length to avoid bu=
ffer overflow.
> >                  */
> >                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k=
)
> >                         sg_set_buf(sg, acomp_ctx->buffers[k], PAGE_SIZE=
 * 2);
> >
> >                 acomp_request_set_params(acomp_ctx->req,
> >                                          acomp_ctx->sg_inputs->sgl,
> >                                          acomp_ctx->sg_outputs->sgl,
> >                                          nr_comps * PAGE_SIZE,
> >                                          nr_comps * PAGE_SIZE);
>=20
> I meant something more like:
>=20
> 		acomp_request_set_src_folio(req, folio, start_offset,
> 					    nr_comps * PAGE_SIZE);
> 		acomp_request_set_dst_sg(req, acomp_ctx_sg_outputs->sgl,
> 					 nr_comps * PAGE_SIZE);
> 		acomp_request_set_unit_size(req, PAGE_SIZE);

Ok, I get it now :) Thanks. I will try this out, and pending any issues
that may arise from testing, I might be all set for putting together v12.

Thanks again Herbert, I appreciate it.

Best regards,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
