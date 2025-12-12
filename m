Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D56A23FC41;
	Fri, 12 Dec 2025 00:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765500918; cv=fail; b=DzYlbcf6vamO7X+DBe76X4LkbT7hDpaFuNQjAZIhX7wPfKL2b5pJcux8aHU/uxDrrJJ3o77SzYTMFfQndZVumK+qS/nL6psqDNmIqv7BTEx7WpOeVSUZGXRsqFfQ/Uf2BJ06rD6QVweWgHMg8XDXLFNEvzR+4h2vwR/61lwfWZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765500918; c=relaxed/simple;
	bh=zUl9ayH+za18F/N6VfOf2pOlN3lqy2IvmLHSs+36GGE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HdAg0e8xJe7yR13621Jfx2WlAfTzs10ojx8FsRKgXUeQWYPEtDkQo6jGUwdZec36CzGhd62rXeYqGnXJ+Frb3tHOTT2WomHyAdp3Awu9Fee5RroGTuPD0B1wEZ85U7igvbO1UoTEUQv7X+qjRqTqx+Y+7TiSTD4LyRhT2YN4KEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gj5wa3jL; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gj5wa3jL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765500915; x=1797036915;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zUl9ayH+za18F/N6VfOf2pOlN3lqy2IvmLHSs+36GGE=;
  b=gj5wa3jLkheLoSsRgtHDmzaF57m1YaIgKFzmMb8P9mhUr6zr8qpyz3Ai
   POW7bhpaHtHZZWTDP30C1ZwkTupS0ULGyMb8xT1eCzTtIh47Zo4juMWiN
   lY+hNb8mgdiRYTkplXdAsS5vR1Dy+7ay77f2lDI2AxEdyY3P9uU6f7gmm
   mgrmFzFsKa/NpUI90F6F0ZzN9LSC2YnQu3+3m8GMmxmxb49urmbw4EMql
   c7l8L9GTjKyp1HvnjWw+RfYZTIVKlhrTo3vfN4L47WYwyhq3xYtJP+D5v
   aMjLtbZuFyw/LRfz7jMtcMRjpln9Abs9bAuqXAQCEqlrd5JlcXqbYZnB7
   Q==;
X-CSE-ConnectionGUID: qSmZ7anHR6WCspbfuH9LXw==
X-CSE-MsgGUID: WvpwK+MCTPOS5IsomF9MPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="71116933"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="71116933"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 16:55:14 -0800
X-CSE-ConnectionGUID: 8cpZ4/S5T/mOQlj4hozp+Q==
X-CSE-MsgGUID: ohpFeEvHT1yJuo6Mq5+37w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196028232"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 16:55:14 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 16:55:13 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 16:55:13 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.21) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 16:55:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pm5EGWmOuH1MUNwM9833XBcGxYsluA2wsYnuBbae2ahXe9keJXtXxOBYk5uWxrv45R4ZEKt0mUwQuzQjy0nvRaCl2PCMmk9hJ9n2i9YvnUpOwZyvISWkcoCi3owgTNt//z9guQIra68sIm7vNe1L3NL+OqPTdVKe+sFkQybgCDPFx55iA9aEwy7moDjx0qbysMO7V+KYBrtlHMaC+WJ5cBE1i4Rj0bqnqEyMApSxDs93U+RsPjT9I910mfxezRKyDxD1sTf4egVcaYHa/ksAkcMjLkh4uR2T2evZ9a09rIvKRcp/GgZHWoa0NaQ5HweDmGTC6Us2JDs/FgnB8ec75A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+RR13g8LnHwSu3tvEqt+Rq1V7mCHniE2TbcE35ivvE=;
 b=dat1/4hLCm2kbOfJXjCzCz2rt+jIiyeuXI7b3nKLbRad6PBHHO0Lvgu+ct73gzYm7XgjG8Ehfq8+NkuLMe4KT2xfJajBBUIPAC8Gl7YPykoNUhNRa2VFEoI68xD3zGvWIDlns9VHA0BnUlbZVOzHJedXlck8MhjHOJIJsR3+C1pyh7JhbHLNHnir5lYwvuexL1Vz24xlMY+mzw/NCHNvqGufZ8fB8CWu4sauWJec0ZMVmzdnHojmJ9xBWIlPJMCVqs4qL62aSCizYh+qqH/vSnHSshQyG9iP388f3mrxEmNexqt13SD9TKmLUaOTA8Yd5PsMFS/dMaCi9lrYEqDo+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by SA1PR11MB6664.namprd11.prod.outlook.com (2603:10b6:806:258::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 00:55:11 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 00:55:11 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcTWsygycgPn5uUUWANDAP/laxYLTxHCiAgCxKvnA=
Date: Fri, 12 Dec 2025 00:55:10 +0000
Message-ID: <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
In-Reply-To: <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|SA1PR11MB6664:EE_
x-ms-office365-filtering-correlation-id: 8f725302-32d4-4c23-615c-08de39191a32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?6Sf66qoRjnYvi3hoGwHWl+XYc6WSBAh6msllELyjasC8GuDcboklQYpbZ1/Y?=
 =?us-ascii?Q?G3yHqOno0DqeUligZz/kDVldQ3/WWv17386V4LHD2+gOBDrtHtcUi8Gg1T6R?=
 =?us-ascii?Q?tMLEKSOhrAbOfSrbEzHL6ptgKij0Aghb0uKIM8RwHSQRih0mfD627vLhc46u?=
 =?us-ascii?Q?5GifSJSecP/C2Whg4QQVIItd69ZVMZOWqRaILh9NQVHnhJQDim371Ot8yq0g?=
 =?us-ascii?Q?6s6NuGMHG53fDpT3ujVmZ6Vz4B1XZrWXiMmmSJac+Cie/Ws7r5xKOcYsxvQE?=
 =?us-ascii?Q?MuEK8BOM+P6c7xpL+tMZzI24VwVwCM6ku69Sg6Msy/7TLapLRga8fA1gPNe+?=
 =?us-ascii?Q?07+DpHKx2KlJCy+mxOcSG2egOWcCiOj8wJsUyqph8nkh7SsK1i+b1bo8sRC+?=
 =?us-ascii?Q?SpWeZHvu+AvpSTwNgoAPGgf3RfLFrxtalBQP1m/whu9WYY90KbBQo5SFVpk3?=
 =?us-ascii?Q?Civ6ckTUBOF3IVohyWFglv9eCd5vHaWBVMG/39YUswkB+hxyC/Y9kd4k8MGN?=
 =?us-ascii?Q?9FyZRLM2VxwOChTHjuyl2W3tyxWdIyunsQJ1NmX2l7Y6EDfU2E+d2RtAle/Y?=
 =?us-ascii?Q?+O3i0Xw29XgpnpZ3shmzlaHG0z/d1C/DVmd+YmP1xVsZyUMtuIqxdGa7KH8W?=
 =?us-ascii?Q?rNviUStaX4FK7rUojTN6p7U/6BkjT190XsTM9ToMN631suohgHt0Fbm15Yvc?=
 =?us-ascii?Q?jHoNxumWOEnHp9iqY7BGmVvY8wQvLdWFbacbrwaGnxl00qnWtHgdCIYelWyI?=
 =?us-ascii?Q?cLFbaEpsOP7cvt43l/16oIQxkeWQ7YCg5KpgnZtGNKD4/aM2UFdO6Jnu+0jB?=
 =?us-ascii?Q?6V9J0iIJfbAGuEGL47/hxo54SJPRbZ+D7IR9o0WoAVsLYn4gSggh8Prpde4h?=
 =?us-ascii?Q?uwPBmSsjO5krskk0v4pe2WL/+7kkoAngFYzNQhWp6n2AEFhkKhblfRjKVyp/?=
 =?us-ascii?Q?ecLluojtoIJGNxjog18OC8hHVE65N4F6PVYbmHWLN6+kaMRhmHTrwfV50OAh?=
 =?us-ascii?Q?son4HosP2CVWZSDDbjuzlVMoWDvGCszpUPl+tBxqNWEjYmvdT5+jh6tAsCg0?=
 =?us-ascii?Q?ZBlQdgOCWo6KGwGZlzmMJ8uuWC4e82wUKRva12fmn8juvBFDZD5sIvpGSXgp?=
 =?us-ascii?Q?A5Yn3hiKY4kAP501nx16IHk+BAF/izMBCA1E/rmhPvvqH6wDSMbv3toU+jVO?=
 =?us-ascii?Q?CDxa6lz3/hVrOmgpoyBDD2LHoSDBeFBVFtZ9jcegnIt7aaQfO8FB0v37Mzey?=
 =?us-ascii?Q?S7FYIIyvBJUr8GxjtLyhvJWahHvk4l7N3Qd99v6oWWu1uJAibKvpBicOrKN9?=
 =?us-ascii?Q?O3PZ7oXOU2fQfv9ljeeyOjc2KSQ6Aqj8U4ILhLQpwtBHSuSn6+WKJUz+HRCm?=
 =?us-ascii?Q?k8u5UGakxGykrf8U6aVlUuPuvnN2srXAyfqB5sfsoC2351pbgFxE39i1b5Cr?=
 =?us-ascii?Q?QS3Nvi93JEb9Nh0T6PzAuizTbXU6I/q6d35d05o0WJgtqbmhhREwD1ATdIfm?=
 =?us-ascii?Q?OTyFqv7Q7oaCaF6BLhQ9JoJUfrzzuFMs+O25?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EWbbqjH/l9W3OLQ3lHaUOs0mnI9uE2wMNncrujabw9rGthbVff8DY6IzOur0?=
 =?us-ascii?Q?/IYN6tsCeBPOjslEVzQWgHDPihX/7FyCQrhrXXGd9Xvli2r4SbzGDfgLS7ZG?=
 =?us-ascii?Q?Lz+JvUQ+6j5lYRXJwXbWBySiVmfLeDn9+WCA5qiMX9Ybh+QyB+6daR8uBw4M?=
 =?us-ascii?Q?L36fYJvp0+QvUhgAaZa5AChFW/43drQCa7sdl8mXdKjezcpsBlh3+nFGUk3Y?=
 =?us-ascii?Q?85vCnlR6CFUZ14vjzv6Zz4ufZrMiSX841Ehtyg/ZI7zDs/Ke2ultnNJB/9ZP?=
 =?us-ascii?Q?INJhzTny25qkjmv1SZ3NwLHoWceqZgoqU1ruVrQrXWPSMLi+v4uufnkEcUAo?=
 =?us-ascii?Q?z2uhk5aSHDBp1hDwKYL0Wyj1DafNlGryMEzWTvb5MmlJV7CE7kUOxSeLEw4D?=
 =?us-ascii?Q?z02iBClN/+ZoJdoSAjkO8GH1uxUH7r2ks7EXCIvbkyHdnt2OnmdVldDwXamJ?=
 =?us-ascii?Q?u2aUx7x8I8xSOvFZP0INQRzwpN8JwMaziqPUhY5lmcF+orWEQBAVdoR6UfoA?=
 =?us-ascii?Q?tsFyLA/lqjuvK9IGeSrl/c8S08WdDMu0bWB7npcc35m171Sy7Zosd0rcAyTy?=
 =?us-ascii?Q?h8I86k+6YjaMz7HXdwvtjo/C0EkJ8VITejdPilw94iJg1b4Ds7GCbP312w0j?=
 =?us-ascii?Q?ZkgRa3+p+WMhEigZVCpqIWT599GQQhjY364wbX0/5ofcB/RQT2pZGHIAm0T0?=
 =?us-ascii?Q?Y9vGucpBjlW1cB8JEr7C9yKSQTocxhj1pfI473Q0i/22leIj+MQa4J4GaAuf?=
 =?us-ascii?Q?vktRXoRnWqEKkSz+Li5ChQSZFKG1XX/NzkGG4fYZVxEgJOfmNvskw11xcW5G?=
 =?us-ascii?Q?C+798oGs5pXWnOuKp9Y3xpP6RqPYdjpnDfSlAOSzwX665eecoduMRmVjW/My?=
 =?us-ascii?Q?woa0FJZ0LYRbUTZr9lfWV1eVGgNlOwOfGE7pf3572KDmektmciDxJs07rxKf?=
 =?us-ascii?Q?qceQq4dNR8dZZxxJucw750pIpgVF9sZ9E8Tc04GSoe8hmiOGa7cIxYETYj1J?=
 =?us-ascii?Q?9tjFR/SnZFwpvwCFN9wLhJq2bhxxdJOAj1qW3ue2DxZvxnpkFWOFPfKgjfeU?=
 =?us-ascii?Q?NIg7GRCGsDOfHTCyqfYVtI/kER1AOyv5/+GQSqY846lyCIO4SdN6s3d+ipLM?=
 =?us-ascii?Q?EHxTZNjBHyKNYwXgTwohTJx+axHK2HgQcMDdehpfO8RgqUP2kV9+qugGWlOK?=
 =?us-ascii?Q?Nsqfx/6PIlri/3DzAYfDtMUnWvUdO8dh+Wm3Bzm6VrsIjZJ518twZDp9DSS7?=
 =?us-ascii?Q?InCExB7Z+fhZzn/SVF+0SYlmXavIB+cEN1aUu1fTSMaHcmCHXcgpxavUC4fN?=
 =?us-ascii?Q?aFMqjblgbAVBf0tJRMEG8+EofTSauDcyj7Ipzi5HNZ6Q3q4C+MHe2ml6fBRs?=
 =?us-ascii?Q?/3XaS9ow9LVQ1p6T9+mhXwIF3hEc9JPFM5iFcX0GSHCWPkiczVBhc5F0iOUr?=
 =?us-ascii?Q?/yG74gu1HAgapbfIe3dX+qnQCHmCcXALZvMDFAMAZk+Ac2+mey0kGB8hY5lj?=
 =?us-ascii?Q?Ue9fnsKxn7oBB8T/eqJEH1a2SBgVvFN/UahTMTrnKcG1u0xmvb/AaxR+glWQ?=
 =?us-ascii?Q?OGJYWMia9o3/zd6YVDtQoLJ/4Ihhi6T83X3avy9Ugf5RI3GbaUFUK0TzM9fB?=
 =?us-ascii?Q?tL7EpPvnvOdHgLmfNpU583iEiVfoz75Tw4fMixOZrXE3MslddoqfZz/9hkvf?=
 =?us-ascii?Q?Wamp+w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f725302-32d4-4c23-615c-08de39191a32
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 00:55:10.9361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKmwfxeRrH/BM6Wj9GotRo8ZiblJ6sBKWVfVzrQtHB96zL4eB5uUjN2/KSKVPHdkQk3dGo9ecoPHifKgem2/PkPO2qOcvAYgNZysEid/6Uw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6664
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 12:24 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:
>=20
> The subject can be shortened to:
>=20
> "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"
>=20
> > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> > pool creation to pool deletion. These resources will persist through CP=
U
> > hotplug operations instead of being destroyed/recreated. The
> > zswap_cpu_comp_dead() teardown callback has been deleted from the call
> > to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a
> result, CPU
> > offline hotplug operations will be no-ops as far as the acomp_ctx
> > resources are concerned.
>=20
> Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> hotplug, and destroyed on pool destruction or CPU hotunplug. This
> complicates the lifetime management to save memory while a CPU is
> offlined, which is not very common.
>=20
> Simplify lifetime management by allocating per-CPU acomp_ctx once on
> pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> allocated until the pool is destroyed.
>=20
> >
> > This commit refactors the code from zswap_cpu_comp_dead() into a
> > new function acomp_ctx_dealloc() that is called to clean up acomp_ctx
> > resources from:
> >
> > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > 2) zswap_pool_create() when an error is encountered, and
> > 3) from zswap_pool_destroy().
>=20
>=20
> Refactor cleanup code from zswap_cpu_comp_dead() into
> acomp_ctx_dealloc() to be used elsewhere.
>=20
> >
> > The main benefit of using the CPU hotplug multi state instance startup
> > callback to allocate the acomp_ctx resources is that it prevents the
> > cores from being offlined until the multi state instance addition call
> > returns.
> >
> >   From Documentation/core-api/cpu_hotplug.rst:
> >
> >     "The node list add/remove operations and the callback invocations a=
re
> >      serialized against CPU hotplug operations."
> >
> > Furthermore, zswap_[de]compress() cannot contend with
> > zswap_cpu_comp_prepare() because:
> >
> >   - During pool creation/deletion, the pool is not in the zswap_pools
> >     list.
> >
> >   - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
> >     out. zswap_cpu_comp_prepare() will be run on a control CPU,
> >     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of
> "enum
> >     cpuhp_state". Thanks Yosry for sharing this observation!
> >
> >   In both these cases, any recursions into zswap reclaim from
> >   zswap_cpu_comp_prepare() will be handled by the old pool.
> >
> > The above two observations enable the following simplifications:
> >
> >  1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim cannot
> use
> >     the pool. Considerations for mutex init/locking and handling
> >     subsequent CPU hotplug online-offline-online:
> >
> >     Should we lock the mutex of current CPU's acomp_ctx from start to
> >     end? It doesn't seem like this is required. The CPU hotplug
> >     operations acquire a "cpuhp_state_mutex" before proceeding, hence
> >     they are serialized against CPU hotplug operations.
> >
> >     If the process gets migrated while zswap_cpu_comp_prepare() is
> >     running, it will complete on the new CPU. In case of failures, we
> >     pass the acomp_ctx pointer obtained at the start of
> >     zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
> >     only undergo migration. There appear to be no contention scenarios
> >     that might cause inconsistent values of acomp_ctx's members. Hence,
> >     it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
> >     zswap_cpu_comp_prepare().
> >
> >     Since the pool is not yet on zswap_pools list, we don't need to
> >     initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). This
> >     has been restored to occur in zswap_cpu_comp_prepare().
> >
> >     zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
> >     valid. If so, it returns success. This should handle any CPU
> >     hotplug online-offline transitions after pool creation is done.
> >
> >  2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
> >     migrated to another CPU before the current CPU is dysfunctional. If
> >     zswap_[de]compress() holds the acomp_ctx->mutex lock of the offline=
d
> >     CPU, that mutex will be released once it completes on the new
> >     CPU. Since there is no teardown callback, there is no possibility o=
f
> >     UAF.
> >
> >  3) Pool creation/deletion and process migration to another CPU:
> >
> >     - During pool creation/deletion, the pool is not in the zswap_pools
> >       list. Hence it cannot contend with zswap ops on that CPU. However=
,
> >       the process can get migrated.
> >
> >       Pool creation --> zswap_cpu_comp_prepare()
> >                                 --> process migrated:
> >                                     * CPU offline: no-op.
> >                                     * zswap_cpu_comp_prepare() continue=
s
> >                                       to run on the new CPU to finish
> >                                       allocating acomp_ctx resources fo=
r
> >                                       the offlined CPU.
> >
> >       Pool deletion --> acomp_ctx_dealloc()
> >                                 --> process migrated:
> >                                     * CPU offline: no-op.
> >                                     * acomp_ctx_dealloc() continues
> >                                       to run on the new CPU to finish
> >                                       de-allocating acomp_ctx resources
> >                                       for the offlined CPU.
> >
> >  4) Pool deletion vis-a-vis CPU onlining:
> >     The call to cpuhp_state_remove_instance() cannot race with
> >     zswap_cpu_comp_prepare() because of hotplug synchronization.
> >
> > This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
> > Instead, zswap_[de]compress() directly call
> > mutex_[un]lock(&acomp_ctx->mutex).
>=20
> I am not sure why all of this is needed. We should just describe why
> it's safe to drop holding the mutex while initializing per-CPU
> acomp_ctx:
>=20
> It is no longer possible for CPU hotplug to race against allocation or
> usage of per-CPU acomp_ctx, as they are only allocated once before the
> pool can be used, and remain allocated as long as the pool is used.
> Hence, stop holding the lock during acomp_ctx initialization, and drop
> acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().

Hi Yosry,

Thanks for these comments. IIRC, there was quite a bit of technical
discussion analyzing various what-ifs, that we were able to answer
adequately. The above is a nice summary of the outcome, however,
I think it would help the next time this topic is re-visited to have a log
of the "why" and how races/UAF scenarios are being considered and
addressed by the solution. Does this sound Ok?

Thanks,
Kanchana


=20

>=20
> >
> > The per-CPU memory cost of not deleting the acomp_ctx resources upon
> CPU
> > offlining, and only deleting them when the pool is destroyed, is as
> > follows, on x86_64:
> >
> >     IAA with 8 dst buffers for batching:    64.34 KB
> >     Software compressors with 1 dst buffer:  8.28 KB
>=20
> This cost is only paid when a CPU is offlined, until it is onlined
> again.
>=20
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 164 +++++++++++++++++++++--------------------------------
> >  1 file changed, 64 insertions(+), 100 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 4897ed689b9f..87d50786f61f 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -242,6 +242,20 @@ static inline struct xarray
> *swap_zswap_tree(swp_entry_t swp)
> >  **********************************/
> >  static void __zswap_pool_empty(struct percpu_ref *ref);
> >
> > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > +{
> > +	if (IS_ERR_OR_NULL(acomp_ctx))
> > +		return;
> > +
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > +		acomp_request_free(acomp_ctx->req);
> > +
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > +		crypto_free_acomp(acomp_ctx->acomp);
> > +
> > +	kfree(acomp_ctx->buffer);
> > +}
> > +
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> >  {
> >  	struct zswap_pool *pool;
> > @@ -263,19 +277,26 @@ static struct zswap_pool
> *zswap_pool_create(char *compressor)
> >
> >  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> >
> > -	pool->acomp_ctx =3D alloc_percpu(*pool->acomp_ctx);
> > +	/* Many things rely on the zero-initialization. */
> > +	pool->acomp_ctx =3D alloc_percpu_gfp(*pool->acomp_ctx,
> > +					   GFP_KERNEL | __GFP_ZERO);
> >  	if (!pool->acomp_ctx) {
> >  		pr_err("percpu alloc failed\n");
> >  		goto error;
> >  	}
> >
> > -	for_each_possible_cpu(cpu)
> > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > -
> > +	/*
> > +	 * This is serialized against CPU hotplug operations. Hence, cores
> > +	 * cannot be offlined until this finishes.
> > +	 * In case of errors, we need to goto "ref_fail" instead of "error"
> > +	 * because there is no teardown callback registered anymore, for
> > +	 * cpuhp_state_add_instance() to de-allocate resources as it rolls
> back
> > +	 * state on cores before the CPU on which error was encountered.
> > +	 */
>=20
> Do we need to manually call acomp_ctx_dealloc() on each CPU on failure
> because cpuhp_state_add_instance() relies on the hotunplug callback for
> cleanup, and we don't have any?
>=20
> If that's the case:
>=20
> 	/*
> 	 * cpuhp_state_add_instance() will not cleanup on failure since
> 	 * we don't register a hotunplug callback.
> 	 */
>=20
> Describing what the code does is not helpful, and things like "anymore"
> do not make sense once the code is merged.
>=20
> >  	ret =3D
> cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> >  				       &pool->node);
> >  	if (ret)
> > -		goto error;
> > +		goto ref_fail;
>=20
> IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
> probably should add a new label.
>=20
> >
> >  	/* being the current pool takes 1 ref; this func expects the
> >  	 * caller to always add the new pool as the current pool
> > @@ -292,6 +313,9 @@ static struct zswap_pool *zswap_pool_create(char
> *compressor)
> >
> >  ref_fail:
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> > +
> > +	for_each_possible_cpu(cpu)
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> >  error:
> >  	if (pool->acomp_ctx)
> >  		free_percpu(pool->acomp_ctx);
> > @@ -322,9 +346,15 @@ static struct zswap_pool
> *__zswap_pool_create_fallback(void)
> >
> >  static void zswap_pool_destroy(struct zswap_pool *pool)
> >  {
> > +	int cpu;
> > +
> >  	zswap_pool_debug("destroying", pool);
> >
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> > +
> > +	for_each_possible_cpu(cpu)
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +
> >  	free_percpu(pool->acomp_ctx);
> >
> >  	zs_destroy_pool(pool->zs_pool);
> > @@ -736,39 +766,35 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  {
> >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > -	struct crypto_acomp *acomp =3D NULL;
> > -	struct acomp_req *req =3D NULL;
> > -	u8 *buffer =3D NULL;
> > -	int ret;
> > +	int ret =3D -ENOMEM;
> >
> > -	buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > -	if (!buffer) {
> > -		ret =3D -ENOMEM;
> > -		goto fail;
> > -	}
> > +	/*
> > +	 * To handle cases where the CPU goes through online-offline-online
> > +	 * transitions, we return if the acomp_ctx has already been initializ=
ed.
> > +	 */
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > +		return 0;
>=20
> Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
> then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
> that case?
>=20
> >
> > -	acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0,
> cpu_to_node(cpu));
> > -	if (IS_ERR(acomp)) {
> > +	acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL,
> cpu_to_node(cpu));
> > +	if (!acomp_ctx->buffer)
> > +		return ret;
> > +
> > +	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_to_node(cpu));
> > +	if (IS_ERR(acomp_ctx->acomp)) {
> >  		pr_err("could not alloc crypto acomp %s : %ld\n",
> > -				pool->tfm_name, PTR_ERR(acomp));
> > -		ret =3D PTR_ERR(acomp);
> > +				pool->tfm_name, PTR_ERR(acomp_ctx-
> >acomp));
> > +		ret =3D PTR_ERR(acomp_ctx->acomp);
> >  		goto fail;
> >  	}
> > +	acomp_ctx->is_sleepable =3D acomp_is_async(acomp_ctx->acomp);
> >
> > -	req =3D acomp_request_alloc(acomp);
> > -	if (!req) {
> > +	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > +	if (!acomp_ctx->req) {
> >  		pr_err("could not alloc crypto acomp_request %s\n",
> >  		       pool->tfm_name);
> > -		ret =3D -ENOMEM;
> >  		goto fail;
> >  	}
> >
> > -	/*
> > -	 * Only hold the mutex after completing allocations, otherwise we
> may
> > -	 * recurse into zswap through reclaim and attempt to hold the mutex
> > -	 * again resulting in a deadlock.
> > -	 */
> > -	mutex_lock(&acomp_ctx->mutex);
> >  	crypto_init_wait(&acomp_ctx->wait);
> >
> >  	/*
> [..]
