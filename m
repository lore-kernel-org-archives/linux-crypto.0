Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC2D8F5B;
	Mon,  1 Dec 2025 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764610171; cv=fail; b=XIX4L+sabjFhLWB+8ctHT2OmgDQPvSaYPvSAmhfmzdWnrLo7l6P0nucbwfeA/I5DX2PudW2I/+/I6RYwoIQZIG12U+b8zV3l4tivqgukN/FO58ecc7HnvdVis3uw/btw+KvVpS8kVpMWTjRrQVrwcKk93xo/Hxf7gJltUKOssh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764610171; c=relaxed/simple;
	bh=pPIdQheRZJDH1fisQvGMngnKI+L3WnP9xJHCT480jvo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JQKI5SF4CcFPx3j13I7aiFA8WYcKA1zE4GoMXXI/tpNwI5KZ9/87bHFefqXn10ndMVE/hOAZzx3UNUE3FRI0sW19FYk5B7YreeIiR5OeVWrlQ8AaDnY2Adfati+jdIgr+uU7Q7GU0mllTLks3D6NQyB8uCb9WZ5pEWsP5L3LPA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eee76BQl; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eee76BQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764610170; x=1796146170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pPIdQheRZJDH1fisQvGMngnKI+L3WnP9xJHCT480jvo=;
  b=eee76BQl7NunPnpcizD+fUjONumF+TQ0lg6ra6Z7rFLZ4WVQdsWDFYdF
   yPcMaLZ+4WKNGi3mLyi+fHQ1Cue8XHhTBIk3RgqRYO/ThcSA564Vr409U
   PAf9UNJqCPAESbju01mtT7hnaWoKnezTkCdf9ezoqA+RVgiZv2XK588IF
   RpAtleLpzO4xMO4U1uIDKsTU/kk8FJB5cqyehsNmqh9tpt2uTvR3Vgwm2
   IjusWoF869iqZwDzJmV2yXZqRuqG4lVJM8VLeXXTSyl54HJuMxluOFoqh
   5j0ozoNxGZx+j/DAI8kRaX60vGiUQj9iqmc5v8csRQrFGvSMCIPkfWlG/
   g==;
X-CSE-ConnectionGUID: 6aVyzLBaTGaxGJh3orbyRQ==
X-CSE-MsgGUID: Xifw+aFpSbOELF1CDvxiLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66589985"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="66589985"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 09:29:29 -0800
X-CSE-ConnectionGUID: ly/D3ZpZRlWKFKhY2G1OoQ==
X-CSE-MsgGUID: WDZ0Tl/jQyWChimTHE132A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="194561491"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 09:29:29 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 09:29:28 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 09:29:28 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.9) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 09:29:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kl428E+CfheSLu79YjqEuUAwHlxDzGAPOUlSgXDjuOWYJl3nC4y/J1Wr3/6qR9N6Pcis2zVq/yWdP47a8Ne0AtnDw8FrzmkAjGQ2uDqOxIYSiRIVwo98SrQnT/tYiDc0DXN4qvXRmGAwe7BYaF3alRk5lDAsc7VqYsUHUUtlkYyhncSNMvS7Hhq5fGqc1gfztZKaSBYQYtaoQ2kVMTdEG3hAAljtA9mV1MGQJGTZKFD+25nfW18GShEC9vX6HX5cBhcOE+oM73p7O8ai7lNuo0zw8CiTMdVLlLfr8a8agIqj7/CvSNFMZ8c94lWatmxpoQh6ldnDNd62EtSi7mz+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asFRSUnvdPOKiicRTTQysOIkZ9QbT30BLngqyfrrnvc=;
 b=JBLNSXBZI7h96f8wKthU0tk8a0V8w/jpoppzTAKuY6iKG8Gd8FRSkwXUrY7wYCEl7Gyvi0z0ylU79k2jNM4qO5/+4QZ1i9yLMGXRxnbNIwXftX4oO8DhW0yeC23muvJl/mIR1OwUO4Nb516BHeBkTzrs5QPHsUZMOYUo9qopJC9FWbNiYox3pG9j5HeFX/v0kjZQsuTZwxjpUNp8QXT/ZhO5rnFMOjgz97C/75e1gvqN296cURzFZpgaIPl573HgBYHMm95H4q3Ib3b1m4PAN82daB+t0MsibhtVw6lHbv8W8q0LgG0EGQa9ri/tn9NAfW1dP4gLPUCHoDdSz3efqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by BL3PR11MB6409.namprd11.prod.outlook.com (2603:10b6:208:3b8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 17:29:25 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 17:29:24 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Sridhar,
 Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH] crypto: iaa - Remove unreachable pr_debug from
 iaa_crypto_cleanup_module
Thread-Topic: [PATCH] crypto: iaa - Remove unreachable pr_debug from
 iaa_crypto_cleanup_module
Thread-Index: AQHcYG6m6Vm3izo2u0Sedreb2L5NQ7UNDwwA
Date: Mon, 1 Dec 2025 17:29:24 +0000
Message-ID: <SJ2PR11MB847269A9409782A3012695BEC9DBA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251128135413.2291-1-thorsten.blum@linux.dev>
In-Reply-To: <20251128135413.2291-1-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|BL3PR11MB6409:EE_
x-ms-office365-filtering-correlation-id: 94f0b28b-aa45-4747-5ca4-08de30ff2c24
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?anMeBB7tKMh6m0NJocug1tHILCVaZko+Nxm3Sfv9m+CrRKvn5KdBb3+kDzA4?=
 =?us-ascii?Q?A4ZEIo3Pvh14T++m05J+cgMQPsuDtCdU7ZdFymWRN+/IFh45gMP2RRq0Ku7b?=
 =?us-ascii?Q?t4sPnP1PA29xgLiTwVBmvibVHVgG6zqjVWMYgQXKKDUn9zeAfRUCONTkBOAn?=
 =?us-ascii?Q?gb9Xm4KeHJRPopsAtpVGi2J0ztTWHXJHFabtkGkZPHQBZrnW6anwiDMRwVcc?=
 =?us-ascii?Q?NDg10+wkm9Qx7cQmwyjEybYetzFUVhvug9cq/GP4r7c7MHi+FYhFq6SrGet6?=
 =?us-ascii?Q?ShtIMisIAfhd4rUL0BoAJ5elqsyk3scE367DVGMcykO4eUfaMzXpmtHrHdMi?=
 =?us-ascii?Q?4qyGL8SDLRZglIBGp8TypVL18am7AeOK6MNQoOTEFs6/SSHoZiV4u4NiLdWm?=
 =?us-ascii?Q?0Crsyb6cjots/dbUCDefj7Ycz7ov7e3amz80sKipPR9onYeQtliL32dbXqU+?=
 =?us-ascii?Q?NFIecZyQDIHf6VPBHRh+Olj6I37pQKs1gxv4khZIEeL6NVI7a8I3qE2MsH96?=
 =?us-ascii?Q?uP16FQxv3do4RovSKB+HnOKmmH2Bme0bjBjKVquE/5OrrFftwCiJq5d72w4U?=
 =?us-ascii?Q?XKB3mcfZz3V69cn9nTfwD+fGWt3eDFVg7ymu2uA1pk9X28dmJUhQnygOEDn0?=
 =?us-ascii?Q?pRqICR/S0PpU5TqRqISuadq2ba0H+MursMbJCB481XA0vAI4TbPUYRv0My/K?=
 =?us-ascii?Q?kYb2lxAw0lDD1d5spOjQqfZkJsaKxj7fKR0iI1ttBIZUkQ4UFstxSqoSVKIn?=
 =?us-ascii?Q?vHF7AKNKogjk9usFjbUIr7L5PzOPqpV1pBPwTX6cX9Zkd4NNONiMiMWQjcvu?=
 =?us-ascii?Q?OE0fV9ZuGimH2JD3OLHknT/nqVoKCdZBuNy6KK234n7TyA2x1Bj0je9CIY3S?=
 =?us-ascii?Q?oNXAAhAn/yOknf3FTyRceJeZKqQl/7C6nyJ6g+3yQXkHLSgSm+TuWR1qJwJW?=
 =?us-ascii?Q?Mfe6hDkVQsFK4u6jASU8iHocisqbpZWN5lsR98NHfn7V77CjC06S+SqaN+Rj?=
 =?us-ascii?Q?+vV8dh2th5RvePAi4uAxmm+gB22EmZMNnrm2nVRt1JeyB+04UDziyDo+jt0W?=
 =?us-ascii?Q?bl0ThA7NEfiMnBz7l98ph2t4LX5PYR4tDsyEDL90Xs+stBj5nAm+IJkI5elS?=
 =?us-ascii?Q?Wgd1vBuK9ZQ7Hs6i4HShTjPiy5fgnl4RMXd6F5HxieoYvH5VxTZgXVSVGU6H?=
 =?us-ascii?Q?koMeqc8VEdIdJZvqHlyB5v6CMDe28PmiLoaYeESwxI+wuiOijTnS2+VcynYx?=
 =?us-ascii?Q?3q1wtlPiGwSaVVc28opIUmbzMSTL457FrSkbC8W1FpWionh/qv3ZN6dP5gR0?=
 =?us-ascii?Q?oldnD5uNL6P04s5dcLh0puR2dpvidqsbA2tfJ+yyI47E0Yz4cl55pSCzcA/o?=
 =?us-ascii?Q?yrSK84TpKGFawCzNH2oYGnSX7Ct7PyC7rqlBGhzr7PZJ15KT12cjq+OnPMx6?=
 =?us-ascii?Q?MWMYSYmEMZv5yvKaVQs+Ws4kNMyR+7t54JL5OFfvE/aG6cTMHAocXavqSTEb?=
 =?us-ascii?Q?LgCJw1LeVg73RppwTLCKxnQ3wuMW9mrRQHRe?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J2E3xwT/57FKoaXXJOYwDm5ubk+WCHkh9l1rweD7TJVXmnfgWVEuOLr2k2xa?=
 =?us-ascii?Q?YPiiY0CaIHFfE1GdCtv8wDapMMIfX2QkEm14sucCUo4cUWIWi5PazJGSjL4W?=
 =?us-ascii?Q?2ZZmnITLVQBSoFz45tajItNyvGF257E6AzM3IxAVne0IIM4NK3V3FaJkfX0R?=
 =?us-ascii?Q?Dl7EjgUj/7Z7Ndu9JnrSR+CyWMmBBpaSZ0AuqrhxcOyGwm/QEVHT0jXGPRqv?=
 =?us-ascii?Q?6UGoiOK5SZyPsxcJ8Ze3uAXVbRF1Bk7wg3nfQGAlyAgTolQx0hrutQg8vndF?=
 =?us-ascii?Q?eVpy5CzfUINdFh60kDLT8ME7ODObkCjuhqaGaTtSl3ISWeuw4Is0EDdRbJf9?=
 =?us-ascii?Q?TOOwnqoQ7uiEsPp2cUTmmfOhkaSKLErP9Bt1Nf9Bg5eVetC9T6FOs5RUb03r?=
 =?us-ascii?Q?udDJ5arMXHinpL0mLK8Sb+88I2xmKaDuq0sPpp+pDNlXYiD8Ac6FVxH5T53+?=
 =?us-ascii?Q?6dOjU5QesUVLdyGNS1LIChNFB1KWsKGxeXsBOq1WQmjeZR1t5A17Dnnvd3cT?=
 =?us-ascii?Q?s6cO/RBWquq+oGxt2X08eY/hjK2hIX62/olXtw0gpR3gvqkcM6XGvVfR27P7?=
 =?us-ascii?Q?XzXzfaA7bQFD4U3xvhYkMIGY1H2986XxuWl6EzZpSZCZZ4xhG/+ouCRj8G1k?=
 =?us-ascii?Q?GO2/g2tiPF/ppc0vQRdMGiSXXPbfOAmv3q2PXQcXfDq+4B8PgbtB9qmSDuFN?=
 =?us-ascii?Q?knBv0YqYDx5h8+pCOHILVN6qy9EKrdQ2v8cAwknt5YNWMJOhHddCcARpy0qc?=
 =?us-ascii?Q?fs2QQ8NEccMAikEKrk37zBQBCLeOp+arcBjGB1E6fAemkgmbIzSxvJpoQsox?=
 =?us-ascii?Q?nxMEle01MnI7zC34MoqcEO0WYvBq1Zwhk+HrANKDsH0W87JjvMd0Q/nBZ/J+?=
 =?us-ascii?Q?p0Fm2ciOUgqI/u5UOhYlfl+dKxGpvtS1JO7WWds2M694KMEP5C3pNYwge/Gr?=
 =?us-ascii?Q?1uWRaV0/9Q8wLQ2ge5wNdok7NbkeNEn/4f9USC4hbNlY5em7lTDgfs8E4zAl?=
 =?us-ascii?Q?5PYAxgsRB8Is9X9sbyxlsV/yjuIq7gvJLtmW0+z+7Z3fSPAZEPe27a5ANioq?=
 =?us-ascii?Q?BwBIRHouQdoePNKcB+oLUWYHBE3GofJkKYvkX1/vh9gdbOes3ATyFahbPpVk?=
 =?us-ascii?Q?M2iN8XoSbglwYGcO+nuSc1nE+ne1zh4/waeAXmaIUUMcGC5ImeOMxdbwdgy+?=
 =?us-ascii?Q?2YrZJ4B3AKIq9YEdwNfUkKk/mRPzKdHeXtlAubygScQxKvMw4zmkWvx87AeB?=
 =?us-ascii?Q?QLV3+EatSqDv2tuf6s1VPN7ObwMSPcOac/NiZRA0J3eFaFrv64jIJ2OhXDaf?=
 =?us-ascii?Q?p80T27R59ISDvXwFg4cxrIj5IDThKSs6aKItTZJ0ihMYnA+U8Hm+tNs4dGFP?=
 =?us-ascii?Q?7gM7qiYwu+gAcvFk8/fy8u9xCBor9nysJAQfINkd/aXgqpoyyCS3bl2pX9sW?=
 =?us-ascii?Q?XHdDheDE1qioroogix0AGCS8c7FGuMG7F5X5V+cLwxIXEuopGpaS3PbN0bWz?=
 =?us-ascii?Q?6HbG3sxBwTMy7qVFQ+orn54vFrnVh9nhU6CUETe5oqDs3xSYhY/cpEUUd5b9?=
 =?us-ascii?Q?PQwblsBrJWGkbk5Ol6CZuR0QQ8oQrCxbSNUcmSKFU6cM0By76UfGmhj+XMds?=
 =?us-ascii?Q?9w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f0b28b-aa45-4747-5ca4-08de30ff2c24
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 17:29:24.7947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QTec3ur5HGhziUSTj1rPEvC4ztVturdngfP0B/AN79m/jicMCQlg2sWjgj5y/4zD2PHvXPaUvErEyZuYWawmuC+oRphfbu0MWwG+MqzEQgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6409
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Thorsten Blum <thorsten.blum@linux.dev>
> Sent: Friday, November 28, 2025 5:54 AM
> To: Accardi, Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>
> Cc: Thorsten Blum <thorsten.blum@linux.dev>; linux-crypto@vger.kernel.org=
;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] crypto: iaa - Remove unreachable pr_debug from
> iaa_crypto_cleanup_module
>=20
> iaa_unregister_compression_device() always returns 0, making the debug
> log message unreachable. Remove the log statement and convert
> iaa_unregister_compression_device() to a void function.
>=20
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>


> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> index a91d8cb83d57..83d0ff1fc7c7 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -1698,12 +1698,10 @@ static int iaa_register_compression_device(void)
>  	return ret;
>  }
>=20
> -static int iaa_unregister_compression_device(void)
> +static void iaa_unregister_compression_device(void)
>  {
>  	if (iaa_crypto_registered)
>  		crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
> -
> -	return 0;
>  }
>=20
>  static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
> @@ -1919,8 +1917,7 @@ static int __init iaa_crypto_init_module(void)
>=20
>  static void __exit iaa_crypto_cleanup_module(void)
>  {
> -	if (iaa_unregister_compression_device())
> -		pr_debug("IAA compression device unregister failed\n");
> +	iaa_unregister_compression_device();
>=20
>  	iaa_crypto_debugfs_cleanup();
>  	driver_remove_file(&iaa_crypto_driver.drv,
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

