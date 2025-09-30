Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEAB175A5;
	Tue, 30 Sep 2025 18:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759256420; cv=fail; b=RbQ4RXIEU5M5r6JpTAd6NgtK9hEwx/Gr33g6ABvpqyXo39qi/I7ogOXWBtFs0PEPlQG/7b4ml4PIhsjL/r34mTrKVKbxQK1SI2nntMbp8Z/hYZnyi7vFdmX2uw82LCS7kJkKVzt9qdnfDP24hpLT3o63+jQ7s6m3biLUylt0KSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759256420; c=relaxed/simple;
	bh=/wEIHyQUcQE+6RMepl7TkTYgwNlZ0XBycnGqL7KPVkU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nbVPDnigg8BoRBEHG8W6G+uQvy/dgxFita91LZntA9mys5XoF+CSsxopND06epKZclrrh1ksimFJ3Q227gC245M7Fe6tYwCx57Q6kdQhGxz4xk+/eR5aQD/v/9UYUmSmUmymncPziQjK6oejVn4DASTlOj2bgkkKDnoJgk0eYxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oGHk9srW; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oGHk9srW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759256418; x=1790792418;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/wEIHyQUcQE+6RMepl7TkTYgwNlZ0XBycnGqL7KPVkU=;
  b=oGHk9srWmqqfEILQapalWAY4R8UhKzGME3jb/vye/XRp4L1LbAhmOICd
   /aix3hmKfrjuF1Ngv+ROjXdoQ4azRMhYP4PA4XiXvX8qCeEX2/PAUN3h6
   ikVeqyKZADFSMu3fOSrntVx4Wyoh9XJCwp/yhhjWVdgHia6pMQ+fkBSFK
   SDsZFSdpmFxqRzpaOiZ3KIq7EPB5LIq4YeKRgr4lW2jIm95WbLFSrpOZR
   nP1u8Rn6EdEeK9YKNFy9Yf+LNf3UyP8a7tCbnw1oQKVBMRWe+lsy3fApe
   etf06RfjCUBS8LXuhxb2nSktIeJEZpYyixFhnObn4h4wXvtsL7aY1A+9H
   w==;
X-CSE-ConnectionGUID: DVh0SHANRdq3bzPCFPq+Zw==
X-CSE-MsgGUID: zfciaXj/QVCIPvIPE/BOcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="86969013"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="86969013"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 11:20:16 -0700
X-CSE-ConnectionGUID: 0GySvHF6T0iTCRfa7VYdsg==
X-CSE-MsgGUID: yFaR2K6qTZ+HObUSRqN1fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="202275375"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 11:20:17 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 11:20:16 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 11:20:16 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 11:20:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gekZRol9sdrFGy5neSPSPfKvx60akf4lJ57YEmIcLsTrw9fOF5JNuHEt5feHc/dwJnmDfvQas31WssmAQxD3hQE46d0CGqO1hRGsZiOi3hBZJ10bGd/RnVM/va4wnHT16t7IEuppBzg5uCCwHIdfZEXa8AsIm4UTRk0KAOmvY5ZJ12jX1GZcCW6+qB8YEK45pga3en5mBdKHPYyNpVqwQuQvTJMooU4fJF47qYs5nI0aWXFiLkoaQrGxkuzN9EtmHJK/YWpZ8xWbjgNvF+Y4vRPnbCyqqhqqjdMuN67mjopu0D5D0oKOwzBJpDbyaStJfwncsxafMISB60dy0j+iNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EuSs+YG3gRy7Rfs6dCp6+cnDWF8TRgPAsOLn+iaMA3w=;
 b=q5KjvvHWU2MAH6eITmQ5POB1Eq8pv1gM/7B02CXekgvs6TGm9tHiKQHLLWrRDgLsb8iYyDvClb8Zs5iNsUgMFdZW0AUttmb/DaFa6rIZLItYddpejnWkgRMYVehwZNDA7MfKlKaGkIiLfNGnqIDcF6d65bRUZX6D/zwya6Kf/8Dg4UzvIPAMt5QdZM/ZsaSDQdVNDnMapAXAAc6JllwCmUzj6ls/0V97w85o2r2xR+dgE9uKzbG/3KIgC+6lVCk99Rc9V9sQGXkMYKmBqmP/L1M9YIQauVo7eGJH5Ea1yOd7j/s4jrhvdEHy54gi94KQCRb71abC/wg4QqIvvhjqQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by SN7PR11MB6703.namprd11.prod.outlook.com (2603:10b6:806:268::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 30 Sep
 2025 18:20:13 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%4]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 18:20:13 +0000
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
Subject: RE: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcLpaVftDjct+5Jkq/fUkbn0Rx3bSr5mcAgAAXwZA=
Date: Tue, 30 Sep 2025 18:20:13 +0000
Message-ID: <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
 <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
In-Reply-To: <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|SN7PR11MB6703:EE_
x-ms-office365-filtering-correlation-id: 17752ae5-1cf2-43f9-2b80-08de004dffa2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?Yxlv8ocev2L4jCZHnfhNK3jt9/tmseHjHUDYop8YczvXH/mGJOxg1fN4TJut?=
 =?us-ascii?Q?jm6PSE0LJ/XbEP2XZlToAWYVMjQkNKTystjXSwBemJzgiPQmQB6ZHdFGHT3v?=
 =?us-ascii?Q?75jzMbm4cFHtY7Xs8wBW+42ZZBX337R8CM91egwITXMZh2NZ1gu6ZQk4zMuK?=
 =?us-ascii?Q?bLtTAZRsElbwk65c5+mvpcGeFlqyEpaTXAtc/ffPHULcbn/79mE9jkt8zdcG?=
 =?us-ascii?Q?SNv6biMY7w+z1JA/cIwC40CXx2scIC1K+UaJb2kXHWKubgIQbVXWQUgHxd2R?=
 =?us-ascii?Q?UGISfQcb2GK3yvyxMsQ5BYjcXNcI/y9/l+OQM3YmlhcKmtwpj7dPOxgGtLr6?=
 =?us-ascii?Q?idKeEzNI6OUlgbNPqfSjInf+XSPm2f91HQVzqfj/hnLbAq9PSrYOF9TN08Cc?=
 =?us-ascii?Q?9gtSxPNWVnCSYCpDdSs4dezTJwU2n4trxZSUIZj1y2x+rFuzP3n1pjFg0o/L?=
 =?us-ascii?Q?RrpQTjOhE9tZ4oJRxKiCaudNbiqs66VG8LoYN3yYuU+vNP9Uij7+TpK9lpqg?=
 =?us-ascii?Q?rpE4g7fs/wqkVaFLiM0bhEYVnheqctdYPiZO3vrEMf/nond+eAohyWvOLqxk?=
 =?us-ascii?Q?+ECpFJ58q/lJGPkJc4T5ltT0211LNb5N//tTIP1hl9wfe5F5MqDmoHE68bGQ?=
 =?us-ascii?Q?ELf2IqEIitW0vTxo6WKNs9hpV+B40jsXumz8c+7+5XnmxT2/aABqSt9qLw/K?=
 =?us-ascii?Q?njMPLrMoyqno+CFgf7mzsqP7dZ18WA4k6rBjt41A6AFynA0Xvp19USo2Py6S?=
 =?us-ascii?Q?SoQ7yCMLyB73H7UwhPlqBMeMr+HpxeXRnJ67NHoQvWqi/sMndifvE4+IoZSt?=
 =?us-ascii?Q?Kf5dMzltjQjjQ7cAqPBdaO7wq5YgaEe1CLL7BW0D04SFck2jW0hkcH9SLZy9?=
 =?us-ascii?Q?zwHPYW6NrByh2QtbYjoWiZNXsxVd4Xd29LtK2CE6b/UzxZUIUzMP0ktcaS/M?=
 =?us-ascii?Q?dpl+/3WVjB1kn8JH3VY32mEpHxgDSSsVjt5nqOeEa1d8oycmWbCHZXKxv5Fr?=
 =?us-ascii?Q?j46m2eg34ZyRTnJSury076tpER00XCUJIPVMuHdfQj9hivHvLJxOtTH94G4y?=
 =?us-ascii?Q?N5iQmm5cNbSowt7IMFVlPwIaWuDwom6jEhsGbY1BnOAAqgFXm9LguxckMBx/?=
 =?us-ascii?Q?yAjwikDwzbC1Q5NQEheX7L9fAu0aMOgjpYa8Y2FBoFaj2uhQxCqRu7bK/Pa9?=
 =?us-ascii?Q?G1SNscZhx1F9HWs2wUX9n1Nk80yUj9j3H9Tyq3Tjnrgt8b1uqZY2lgi2sNq0?=
 =?us-ascii?Q?kd0xJvnQM67Lh9FPqnzv5fhMmZStVab6/uw8LM3X6xvjKqpOveEoL9qy4jYg?=
 =?us-ascii?Q?yccSLgfzBM6P4HG2s91dwptIJNfeIejzNffq13v2sKnLAKSJtodJFQbNRX4O?=
 =?us-ascii?Q?UUVvVz1F8LGmTZYdVuqxsNMPwd8JP4F+ZV20BlHBO7OvHu8c0KGOmPz8w8Ek?=
 =?us-ascii?Q?UEG6FU7gNHa1kufCjRRG9+X6hpr/0CQYc7Kiqs68nwQ/QJq48NG56iNpR3tN?=
 =?us-ascii?Q?fd+vAs2kAfCTvGh8bLFeVSNgoQHqqnW57gyG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z+4rTMymjqz9eYeGsWXCIxazFtgqLDMQbxsxot9+wIFqGWf1uZLFm/rgfWQv?=
 =?us-ascii?Q?svH6OmoNje8tJ3budrMSJAZgv0WB1xdSg52FbpWOMG9q5sWD0WT+C9F3nM/F?=
 =?us-ascii?Q?x2reZIT9+o2gj/5rhvR5RW4hVBntnfIzky9bmBZ7oZpxMnb9Ic8WVQct/Wjm?=
 =?us-ascii?Q?RzwhyjG2ghtNINnmeh1V2k8K61EuDK92gtPg/zdWB7/kMT4vp2XgIf0qdrm/?=
 =?us-ascii?Q?U112AkOccBtxNQAtk02rMZa/ZeWWNRbQH2foBFPKQ1VjivNI2kOFRvZaQZQj?=
 =?us-ascii?Q?Ec0NnJ61EBBse+cKVdc1PQ5H+LwgopLi86XULQowfaRC5zb8XgxcFsJysIA/?=
 =?us-ascii?Q?zvShGJEvTe598iW/mGsPasN/DGi7zQeMwtJvT7cWeTWkQndnjizvoiPquLDo?=
 =?us-ascii?Q?kByUIhtjecGz7Si/VLv5rbXS1xqOm9/PcRtooyM++JJ6m4UCESVtCwyhAzMz?=
 =?us-ascii?Q?YvlA/lNOFGLXadDRGU4YyZFzfQQFSe0knvUAJ8KdAMloWHxUzHBtK3QWHyPY?=
 =?us-ascii?Q?fpbhAuKVKRndunodL4LXm10fJwlZL5tCgFJRVmYyUrPEtN7hc7oqls81OuQY?=
 =?us-ascii?Q?pRlDay4G/+ofD6bOzm+NkzQzQ+KbKpchxTVC7Wre3gHxrcaE2n9x/XRzBv4c?=
 =?us-ascii?Q?APPtiBqbFXrsOj8fFQHvZmCt27BoLcefRHK9rpp5aNe/RaLOSDiE0C0jCmFC?=
 =?us-ascii?Q?B+eMsDV0+u/3DJ0bBFhQy1T1c9xR88b6BvnbSSDGL3xB80+AzUpg7C7WYDcv?=
 =?us-ascii?Q?6bdq6AQKELvVlAZcWj4nI/jT6UHr2VYXA/4tk+YfLB5bY6pHjiOrrY6sXp1U?=
 =?us-ascii?Q?fx2MdO1kfjiG3tWApZEMnSOjKh6uVMtqb7gcyZ+VkFZL6vw2skfHxU9ARpRd?=
 =?us-ascii?Q?h4Df3tPIiir3j77pt8NGB9X3/OCPzeFf7VEjMeMklp+0FzA2eUQvW91JyOeO?=
 =?us-ascii?Q?BNLlLYHhlw+nusWPLoQJ/5WmkHG1X8Xl9TQJp22lvKybPC/W2IKEDPzCrHUf?=
 =?us-ascii?Q?ClRtd9fCXxO46ppg3fqxSQ9H/OO2w/oEOFYYSUs2DSWi+RA4ZLlyz+1ISlZP?=
 =?us-ascii?Q?8mQvReXtsZY/BnIfcX20P9Sn+JjuRrcM/w9FAAyGdawhUyh0v7eKipGkz0xW?=
 =?us-ascii?Q?w48IuswrqXPPH60kyFLTEgYAGTADvZlo0R8PBHEEzk+Tk43M0U7XHsjS+BJo?=
 =?us-ascii?Q?2YaBxloK3D8WLehfQ+m3xIWAnB8lBAsiyQPcS/8BSDXLjrEXHr1x89ARW1zO?=
 =?us-ascii?Q?yIhT0bO5ctDSgg5kDkrFo2mq8ae89ce65h/qB4Hmne0abgppTwJEi55ElvNl?=
 =?us-ascii?Q?EvgoUfksIU38uM2jC9IPrDG6rJyt6dHzmc6Nlqa4+Th2dRTxRFHd/flyoU2l?=
 =?us-ascii?Q?enFS5Ivwn2eV6rKtQIsnWBoYqiFQZZp2tDx/3/q10slpkv/cm+K4VlndNIT9?=
 =?us-ascii?Q?cy5xxuARoolLvGd8cN7VO6niBeMXs/iKb1wMg7+zbNOnA+2aTSp/EUuVkC24?=
 =?us-ascii?Q?BQsI/cqNySo6aOhnqd0iDm3if1ZixgJXFvEiiatfsMbcO/rm6/mx1i1UwhE4?=
 =?us-ascii?Q?iHImrGOUuyan05sinSl6d53Q3ZW1HLS9OdUtf24cI1aSbi5cPMNuY9hiauau?=
 =?us-ascii?Q?Og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17752ae5-1cf2-43f9-2b80-08de004dffa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 18:20:13.4414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjDCfQHX1fQbR+49rf0MSiIWrdaTp8TNOB6DLwvyrnI79l5+gjSoskZ363+t2L7GBJuLW1/ZLdLhL4Y9NI4q11W9qW2mPXhPCBKwwxWwqlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6703
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, September 30, 2025 8:49 AM
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
> Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> On Thu, Sep 25, 2025 at 08:34:59PM -0700, Kanchana P Sridhar wrote:
> > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> > pool creation to pool deletion. These resources will persist through CP=
U
> > hotplug operations. The zswap_cpu_comp_dead() teardown callback has
> been
> > deleted from the call to
> > cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result,
> CPU
> > offline hotplug operations will be no-ops as far as the acomp_ctx
> > resources are concerned.
> >
> > This commit refactors the code from zswap_cpu_comp_dead() into a
> > new function acomp_ctx_dealloc() that preserves the IS_ERR_OR_NULL()
> > checks on acomp_ctx, req and acomp from the existing mainline
> > implementation of zswap_cpu_comp_dead(). acomp_ctx_dealloc() is called
> > to clean up acomp_ctx resources from all these procedures:
> >
> > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > 2) zswap_pool_create() when an error is encountered, and
> > 3) from zswap_pool_destroy().
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
> >     out. zswap_cpu_comp_prepare() will be executed on a control CPU,
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
> >     subsequent CPU hotplug online-offlines:
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
> >     To prevent possibility of race conditions between
> >     acomp_ctx_dealloc() freeing the acomp_ctx resources and the initial
> >     check for a valid acomp_ctx->acomp in zswap_cpu_comp_prepare(), we
> >     need to delete the multi state instance right after it is added, in
> >     zswap_pool_create().
> >
> >  Summary of changes based on the above:
> >  --------------------------------------
> >  1) Zero-initialization of pool->acomp_ctx in zswap_pool_create() to
> >     simplify and share common code for different error handling/cleanup
> >     related to the acomp_ctx.
> >
> >  2) Remove the node list instance right after node list add function
> >     call in zswap_pool_create(). This prevents race conditions between
> >     CPU onlining after initial pool creation, and acomp_ctx_dealloc()
> >     freeing the acomp_ctx resources.
> >
> >  3) zswap_pool_destroy() will call acomp_ctx_dealloc() to de-allocate
> >     the per-CPU acomp_ctx resources.
> >
> >  4) Changes to zswap_cpu_comp_prepare():
> >
> >     a) Check if acomp_ctx->acomp is valid at the beginning and return,
> >        because the acomp_ctx is already initialized.
> >     b) Move the mutex_init to happen in this procedure, before it
> >        returns.
> >     c) All error conditions handled by calling acomp_ctx_dealloc().
> >
> >  5) New procedure acomp_ctx_dealloc() for common error/cleanup code.
> >
> >  6) No more multi state instance teardown callback. CPU offlining is a
> >     no-op as far as acomp_ctx resources are concerned.
> >
> >  7) Delete acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock(). Directly
> >     call mutex_lock(&acomp_ctx->mutex)/mutex_unlock(&acomp_ctx-
> >mutex)
> >     in zswap_[de]compress().
> >
> > The per-CPU memory cost of not deleting the acomp_ctx resources upon
> CPU
> > offlining, and only deleting them when the pool is destroyed, is as
> > follows, on x86_64:
> >
> >     IAA with 8 dst buffers for batching:    64.34 KB
> >     Software compressors with 1 dst buffer:  8.28 KB
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
>=20
> Please try to make the commit logs a bit more summarized. Details are
> helpful, but it's easy to lose track of things when it gets too long.

Thanks Yosry, for the feedback.

>=20
> > ---
> >  mm/zswap.c | 194 +++++++++++++++++++++++++----------------------------
> >  1 file changed, 93 insertions(+), 101 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index c1af782e54ec..27665eaa3f89 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -242,6 +242,30 @@ static inline struct xarray
> *swap_zswap_tree(swp_entry_t swp)
> >  **********************************/
> >  static void __zswap_pool_empty(struct percpu_ref *ref);
> >
> > +/*
> > + * The per-cpu pool->acomp_ctx is zero-initialized on allocation. This
> makes
> > + * it easy for different error conditions/cleanup related to the acomp=
_ctx
> > + * to be handled by acomp_ctx_dealloc():
> > + * - Errors during zswap_cpu_comp_prepare().
> > + * - Partial success/error of cpuhp_state_add_instance() call in
> > + *   zswap_pool_create(). Only some cores could have executed
> > + *   zswap_cpu_comp_prepare(), not others.
> > + * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
> > + */
>=20
> Comments describing specific code paths go out of date really fast. The
> comment is probably unnecessary, it's easy to check the allocation path
> to figure out that these are zero-initialized.
>=20
> Also in general, please keep the comments as summarized as possible, and
> only when the logic is not clear from the code.

Sure. I have tried to explain the rationale for significant changes, but I =
can
look for opportunities to summarize. I was sort of hoping that v12 would
be it, but I can work on the comments being concise if this is crucial.

>=20
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
> > @@ -263,19 +287,43 @@ static struct zswap_pool
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
> >  	ret =3D
> cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> >  				       &pool->node);
> > +
> > +	/*
> > +	 * We only needed the multi state instance add operation to invoke
> the
> > +	 * startup callback for all cores without cores getting offlined. Sin=
ce
> > +	 * the acomp_ctx resources will now only be de-allocated when the
> pool
> > +	 * is destroyed, we can safely remove the multi state instance. This
> > +	 * minimizes (but does not eliminate) the possibility of
> > +	 * zswap_cpu_comp_prepare() being invoked again due to a CPU
> > +	 * offline-online transition. Removing the instance also prevents rac=
e
> > +	 * conditions between CPU onlining after initial pool creation, and
> > +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> > +	 * Note that we delete the instance before checking the error status
> of
> > +	 * the node list add operation because we want the instance removal
> even
> > +	 * in case of errors in the former.
> > +	 */
> > +	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> > +
>=20
> I don't understand what's wrong with the current flow? We call
> cpuhp_state_remove_instance() in pool deletion before freeing up the
> per-CPU resources. Why is this not enough?

This is because with the changes proposed in this commit, the multi state
add instance is used during pool creation as a way to create acomp_ctx
resources correctly with just the offline/online state transitions guarante=
ed
by CPU hotplug, without needing additional mutex locking as in the mainline=
.
In other words, the consistency wrt safely creating/deleting acomp_ctx
resources with the changes being proposed is accomplished by the hotplug
state transitions guarantee. Stated differently, the hotplug framework
helps enforce the new design during pool creation without relying on the
mutex and subsequent simplifications during zswap_[de]compress()
proposed in this commit.

Once this is done, deleting the CPU hotplug state seems cleaner, and reflec=
ts
the change in policy of the resources' lifetime. It also prevents race cond=
itions
between zswap_cpu_comp_prepare() and acomp_ctx_dealloc() called from
zswap_pool_destroy().

The only cleaner design I can think of is to not use CPU hotplug callbacks
at all, instead use a for_each_possible_cpu() to allocate acomp_ctx
resources. The one benefit of the current design is that it saves memory
if a considerable number of CPUs are offlined to begin with, for some
reason.

Thanks,
Kanchana
