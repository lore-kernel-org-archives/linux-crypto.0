Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9582296BDC;
	Mon, 13 Oct 2025 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378311; cv=fail; b=Hj3TxX9kWdpxMpdaZONH2l5quDiC39+znpfsabpX5bR/4YsF7zkWfdGka6X2Co3XnvlivhsuwFUHDViVZqN7eicyRUiGKPtRc1lKNO4OHvagF1zfnSNkOSSekXWq3LATjX7K2zjxVTt7wvbvSk/CFmEPTp+tJUS8doC4GCR9MjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378311; c=relaxed/simple;
	bh=7de9qCIlzhZ2Imo5/7nZhuhxUEjJeJ4fwUNnuBQDY28=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XTLr4N8dvDQ9mir7RHbH/EcRztB8/CNKCZzvyqrPkf3izohP+yTgTmQfskL/fjUq+4QjNBFnq/MPICyKER7yU9dM3lo93fiy5IqFUkiJXb1+BUbj19xfW08ftlSnEzLYiVG7ssHkB+YzKheYNvpRAl+IGtyQ+lCeSOlmETuwMN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q78l9e1Q; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q78l9e1Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760378310; x=1791914310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7de9qCIlzhZ2Imo5/7nZhuhxUEjJeJ4fwUNnuBQDY28=;
  b=Q78l9e1QbLgFmzqqKvrmho8Zxh8D6S9fcwskMBK+wwHZ1TcfRLefh4QF
   jDWPBdXqfbJvIw75mn+cZDClH309ReDOxOl0mCajVqPQZAkepvyIki06V
   Y0ehU4jae0aaOu3avLFf98+LaCgMVCvZuxWzQolXaVyGnwHPTI4ME5vHN
   bEXC6oiXdb2BMtkyPxcTQ9oq5t2yvifixH1hf5+NyUonzz/ZgoicZw3Kf
   fQjUlD+YfyxDXAtgk0jKfgmbArZbUWchjEud16wfI8/zrVjTIDIwaT9Y5
   f2opSyg6yssRGMtDRH2G+vhddPnn+jcNuvujEOGZzPq6eKxJcAR7TFC5u
   w==;
X-CSE-ConnectionGUID: H+u6o4YERxWzOMYeylPYrg==
X-CSE-MsgGUID: 4vqlrcD3T/WNm1ycs1EHWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62459546"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62459546"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 10:58:23 -0700
X-CSE-ConnectionGUID: Vg09ttkVTD+zTl9y9xgVzQ==
X-CSE-MsgGUID: iBNPTEa5QJ6ElyPnLoQEMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="218788078"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 10:58:17 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 10:58:14 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 10:58:14 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 10:58:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuEKz4Xk8NC/NoMSS8o21Dq+G+iWQvH1IdjazDiIX5RTH7Zevp9+Q7TwMEdcXLWw6Su9ffIoU+Xd4zWW8ZNRW4wLE6WYpgPx1DZcSOLwQgFPUmkYPIOCjwA3BICSr6lG4HWFfw2A35+jeQ/OJavPTp3tchPOMpG0t+i40Td7Bq2Aw8ORkim3ZHxe4iCr5kDFw+dDGpLA3HYsxKNQ5cN4aRsiG72GCTLBS5q/A9AGscCYYzF4BelwW+4p54wyjbRERfYHMhgV/lyn/idvqMBoAgibyXY0lfV3F6+jRhJSD8d+6HJsARv6BQsAYrQnAHz0xt11tue5a4qD5hKexKt+sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfUDq0pDteVWV5bXAXOV5tIxD700LJZ6G+6ZJ4dkt1w=;
 b=D2oUsP1OCSUBcIH+oydyt5lwRBWoTJxEyRmUnIK+UHUnluYpUBjFYat07zP7uD96m3jdIpg2WmP7yZetn8PzymDgRMvBO9VAsMhEVxiQhNA4Bl+Gj+nvmiJ/46NTA+AzNRNuFLN72koxFt3rqw20n3e2iXBbFeO7vkoFGu9qg14twWnXzn68vZl6Rxtp5lH0Jld5jNrE+FGsUuOTGC97OHmJV4JJNtIfeQb5NgP+0VAnT3Ivjc6YDMg5driSpBzXfrpqAF2BuhHOjGOmcQY8AKUbvRXgCTOgbdL+frkk+5TzZI1Bjw2PGrL/tTkJSDO88ZIUb9nwg63mrErMmjonTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ5PPF6E07EBAE7.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::832) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 17:58:11 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 17:58:11 +0000
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
Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcLpaY70ekQ7dio0CIg97nnm1fBLStgQgAgAAW5fCAEt3R0A==
Date: Mon, 13 Oct 2025 17:58:11 +0000
Message-ID: <PH7PR11MB8121A8735058103B02EBCDBDC9EAA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ5PPF6E07EBAE7:EE_
x-ms-office365-filtering-correlation-id: e22ece43-b19d-4acf-609d-08de0a82132f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?wLsJrwZ/XMbCn39VN43jpateYGlAsOTxf7+TLQg+8/NpzvfMASWdhrrAYUw5?=
 =?us-ascii?Q?in1tNCrTpZ30usbEXkKT6R8Rv7RBPqpXiDfz4Uj+sYJdv/1nGzRb4v8Dft98?=
 =?us-ascii?Q?7vMA1YOdGUtYZzw5pmLxrvndbsBxULIz0FuvJKJpqWsjglY+HOeaHf7sdFvB?=
 =?us-ascii?Q?vi+e50RbM6DA6GByLe741BS4hGJq4C/gY2VrC1KEEU5JXVIXFR6VdOL1EBXh?=
 =?us-ascii?Q?0LFkjXMh7Bice4mnDTzGwwSEJOL0Q0HH4J6GmzcizMv+l9mSMeDAt0HZ/BN5?=
 =?us-ascii?Q?aB8P7UIjw8YMLCmCHyi9/kMoXOAh8IgClXiz2n+DRkqo7qqZzzKn0hU9REXb?=
 =?us-ascii?Q?l1ZGz0W6Zzbok9+Tt20flMr/eKqH66U2e3pdySAdDOyQ67kzVO4apB6AAQ9G?=
 =?us-ascii?Q?lZNei+2gSAmLOr6jo7jMsUlBGJBOspzi44w4lg9BKobirImOF8c5oBwR91QX?=
 =?us-ascii?Q?zdHOjNGwMXstZ0kJC8FIO25B4/DfFkUivOOfkp+WE1IZnL1UG9/SqeWoC//O?=
 =?us-ascii?Q?t2jPun+DlQKmoPjhiX2WKn6XnEnAI6jl4iBqWI624UAguv++MdCuHeseAHeU?=
 =?us-ascii?Q?2zI02kCvDB1n6DC1xvawD/R/cG9OYikP9v6228e0zJ0l8u0zLtUJeezmWAMJ?=
 =?us-ascii?Q?BEe6nHMesl8AnY6jY1Ho3P905uFCruplOpM3l4Eoz+t36EegJuLnmEeXUlkc?=
 =?us-ascii?Q?yiKbavh6z0H5IKMGThAXLt1bujoQh/XCXViRmRFZTgP0nv7i/ee/+ia9mShj?=
 =?us-ascii?Q?ejTRXQnzBoIRk4hs+eNFnl3lbWzp1YCFTg1aO++6dlDnCDA2pPxUPciYeq+K?=
 =?us-ascii?Q?Yr+troiylYYt4R2jrmy/MVeqVOkr8UfmkEc1nDaIlFDUVjdNybliZervB3QT?=
 =?us-ascii?Q?fMHXxEydLZv7kS5QRdpNf5DY1hWSB5+tUE56eVWZzfotmRn8ys/sjL25Geyc?=
 =?us-ascii?Q?HfnFq04nLG4C1oYx19rEnjYOoopfmcDTIHlCntFmzNMvRqtgpM+WI+uX+wb0?=
 =?us-ascii?Q?/s+nNKPZKM9m4QiPLqSoIKnAqPIr4fRYUzq3irHJ0jH94Hqsetl2nnfEIbGI?=
 =?us-ascii?Q?WIDMy9PBcbTDVTU7p9J6ZNhwzBQd455ki8/YAcJ7RaNLPPSfy0QOyUzVJlc1?=
 =?us-ascii?Q?YJUdEipH4VCWHRcvfHdZsw+KEFC/YzyHNTbVZt0pCjC0RtQWbmCxLG5vwjH1?=
 =?us-ascii?Q?gwZDk2b/GkzdKg8ZxsAUT3E4tYuU8E7f9wssvab3NajCQdVyw+CT5SoaatFr?=
 =?us-ascii?Q?LTvaFpnWSY8UmW6YHgqGGunIVspF3pB7z3W+uVb77AGTS84KHhqDtNejAfUl?=
 =?us-ascii?Q?YnN1VsQFOG8wOmnOn8TXmANbv7hnHkZsZQSme+qynOtPGzbckMjbwhLsn9Yw?=
 =?us-ascii?Q?NG5cGoUeTIl96DT3TcLeFC/Ca95m4cY3lL1WwMxa2YCkyp2yf2iySwhz2l5w?=
 =?us-ascii?Q?fv3tZ3ekrS3aMynjJrIXP9ACICw/gJHfLPpkSvUvVTl8Vmi+hJBoIopCyjWj?=
 =?us-ascii?Q?A+t+c5DaWCULmlXo7UztI6ZCKF7AP1yZJg3N?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ehmb6x5JinRQSYvt+syGnjNyXds8dp8dGPhSc9bdn6PdakSwGBMD8U7Lib5c?=
 =?us-ascii?Q?Aw3NHtaZu/vlbkQrVmradu7xPA6IzIjkhNs6HiNbup8CpSGSIciPXCr+VKOq?=
 =?us-ascii?Q?WTVI5tR7OoqE6JeUg79mOBC57ly7Jasgq3MkHSoDD9bnLStsFeHiNMNKjCUF?=
 =?us-ascii?Q?7dsfF+vxK5UCRHevN5nioUtag5UDoJeWdtqOnGPTPl/QNm8pN41/tEkY/PnB?=
 =?us-ascii?Q?IrHV1cE/nT/mlPNcFv6hWU/1vM1yU28/zisdcDExwZW6FFV8Fu58fI534a1U?=
 =?us-ascii?Q?YYjzRrMW0YWeQ5ik4+b2QUTbLkvCzd8YCNpyJ+/IM9rlIEqYg6EALkDDqktV?=
 =?us-ascii?Q?TzBM6WldrGH2Gn2aHEj0gLNgH7M6HhdN2nSC2AgB079uKLNh4cX0Q3xSX220?=
 =?us-ascii?Q?6qUnhEWHCbyRlUpxlH8ovrSfhPYD9JLeuxLQ21GvWr3OGIbyoP9zVqhdc5wP?=
 =?us-ascii?Q?gzWj9whkSb3PWknvOnGth1vh9FPUlm85vTguUqKoLf3LTGDAoSHY1MoZ0ORf?=
 =?us-ascii?Q?09e4i8gkNyUaMO7t2v693PDvBWkN1+wCrG8AjDA08xLLLV2qkbOed/y8xDbV?=
 =?us-ascii?Q?05d0eXzyn8cd3goRqDug7PcLgw4hEWfxn9/3uP08xSE097gmmvBJUFws3Qjy?=
 =?us-ascii?Q?lFRaZY+LBdCtWW66bvtg2sTvcjuI8iS14+Jvq1cOwST1zuAvvLxGKorG5xe9?=
 =?us-ascii?Q?iotj3DctyyktAMC4anDFUda22g4OO5NuH4sqECqUBG8vBuMhle4h+yh4hU0Z?=
 =?us-ascii?Q?kQPwGcMNtWp2a5UsCbGNZEDDlm/VRd3S+g7zghRkTAaQ+c6hihTuJz4mfqmU?=
 =?us-ascii?Q?clMVKm4aMYhxz6SWn0ZAkXLpWkHqAyyH5ltu26LF8lz3Grjcb1IvkuMBalJB?=
 =?us-ascii?Q?DoZsK1bCqUHUh5hAxdKZ328J5IafVhdOdLJSy+Cad18dK6c9NYhLmlAddiVd?=
 =?us-ascii?Q?5+eQ7DUpKJcRCXuzb1ryFO0afnU0TO+x40qwD9KeHf3xEipKjXDKnFeF94Qi?=
 =?us-ascii?Q?gcC6F+mPjPpuxzd+oaCVHz6S9NY33RLXNbEgUihJNLd0DY2N/NQf3Y2/6Kxn?=
 =?us-ascii?Q?UFOqUliIL9zBSYYjOEKxQUDoOe8jk3cUuFbbTfJ2u/WoIzMZyKQe/hwffkXZ?=
 =?us-ascii?Q?FhdbRARQporqjDhznRd6SfFooGgObCPNBbL6OcklWtMgwpbYsjnKqtTgj4lB?=
 =?us-ascii?Q?+euzwyb1gx+jeAlpC1UByhyIlv5DhbyOLBpABUhDGWtN7vWvu/tdzURj9Sie?=
 =?us-ascii?Q?ic82xIZ4luUhxoBUTw+5wJ8i3V+loUmpU9KAOxBraJIzJD3JrbV6I/fSBUuW?=
 =?us-ascii?Q?zf+K4JW3J/qA7R7cUiIhBzA5FjijoYwfqBWZ7Yg5+yG2HgiisKkdllIdiIou?=
 =?us-ascii?Q?vfR5ZUKvJLrfhfRaF2gPfXRqhhz1MdmCnaMbq+WJ09dwVa1/5Yj70QSBXn1F?=
 =?us-ascii?Q?g3gVDGjhFvtwMqH0EmEfSuHmcQZMSE+6uLAVi6W7+PSCTSwrEJMluvA8uUP9?=
 =?us-ascii?Q?jjggiqJm4rC98kqNcZ8SKbRJRJR8iwQ5luzfb9YAhXAnSvGJqz6/l6GurMng?=
 =?us-ascii?Q?wTFTmJ16tZR/dfSMwNlN7qgDtoHDbacS0L82JIW4rTX/h1SXBz6PcLtoty/S?=
 =?us-ascii?Q?RSHRHvLWCmzwqwoIV3Jm/+HmdY2sYiB2RzF7t8MdLCA0hHpx5+mBetLHYC0u?=
 =?us-ascii?Q?NDDtSQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e22ece43-b19d-4acf-609d-08de0a82132f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 17:58:11.6679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dR5x5EwDvQBCBVRdtYO+vtmzIl3U2YRKqGxCJmysggnYlovHkHaS1YbJC8tHh/x6wOoUMzFieS2x6334Sakb1nlqddvPprq2BuoL8qetWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6E07EBAE7
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Wednesday, October 1, 2025 2:21 PM
> To: Yosry Ahmed <yosry.ahmed@linux.dev>
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
> <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> large folio in batches.
>=20
>=20
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Wednesday, October 1, 2025 9:19 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> > large folio in batches.
> >
> > On Thu, Sep 25, 2025 at 08:35:01PM -0700, Kanchana P Sridhar wrote:

[...]

> > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > >  	struct work_struct release_work;
> > >  	struct hlist_node node;
> > >  	char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > +	u8 compr_batch_size;
> > > +	u8 store_batch_size;
> >
> > I don't think we need to store store_batch_size, seems trivial to
> > calculate at store time (perhaps in a helper).
> >
> > Taking a step back, is there any benefit to limiting store_batch_size t=
o
> > compr_batch_size? Is there a disadvantage to using
> > ZSWAP_MAX_BATCH_SIZE
> > even if it's higher than the HW compression batch size?
>=20
> Thanks Yosry, for the code review comments. I had a discussion with
> Barry earlier on these very same topics as follow up to his review commen=
ts
> for v11, starting with [1]. Can you please go through the rationale for
> these design choices, and let me know if you have any questions:
>=20
> [1]: https://patchwork.kernel.org/comment/26530319/
>=20

[...]

> >
> > Does it actually matter if we do the initializations here vs. right
> > before inserting to the LRU (current behavior)?
>=20
> Yes, it impacts batching performance with software quite a bit.

[...]

> > Seems like if xa_store() fails we do not cleanup previously charged
> > objects, pool references, zswap_stored_pages, etc. Instead of rolling
> > all this back on failure, can we do all the xarray stores first and onl=
y
> > do the rest when we're at a point where no failure can happen? Would
> > that cause a performance regression?
>=20
> It would make the code more complicated and thus cause a performance
> regression. I have tried to balance code simplicity (which impacts
> performance)
> with correctness here. The "store_failed_idx" ensures that all partial wo=
rk
> done
> in zswap_store_pages() for this batch, is cleaned up.
>=20
> The rest is handled in zswap_store() when it sees an error returned by
> zswap_store_pages().
>=20

Hi Yosry,

I was wondering if my explanations to the above comments answer
your questions? Please let me know.

The bulk entries alloc/free comments' follow-up is covered in the other
email.

Thanks,
Kanchana
