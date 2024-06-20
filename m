Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410201B0100;
	Thu, 20 Jun 2024 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718897847; cv=fail; b=rcSXcBIOaquWn3tafnUdZExZnkoDm7HO9FPtiTsd53gYps73KziMdFJSNj02FrnkxYIgxl6WLVURiylHPrBszoio/53Z3hfiGLoR8WNvbLRJeIiYRRA/Hty/NPtiRlYQwRhl178xl9SeSnLpVU/sSec2VfI6nrTB/5ZKNWadsFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718897847; c=relaxed/simple;
	bh=M2hBsP/VNApI1Nx4VKVVFovJHfV4pgnGbgjrJAy90vA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K/O5gj9g9wCuWILjyqxrqwhwgLebeM/gF6qsCjVAW1g5OW2P2Vo7qwsxkOPn4Fh0k2lZiZuD4/OXSp8hm5Y7qkH2MbZoVyWoMgLuHyMyQviw7RYZDFnfa6HIF2EfllcqmgHhXR+3iORhuBckdZfuRC1PKqRJ9UNiJ+ry4Ea/KRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bG1s9jZx; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bG1s9jZx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718897847; x=1750433847;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=M2hBsP/VNApI1Nx4VKVVFovJHfV4pgnGbgjrJAy90vA=;
  b=bG1s9jZxQB7j6nt5LGSx1frdGS9JHs8XM+Q2wrnFhHuHLCoD9vL01pzR
   Kdjo3lXdWsv7NYZnjNXF6d8DKklkWxvW2N+94+Bj0PlxIVosWO8e/8SFp
   xtw5Bw4lIo1C9SvTaeUxjhVVbI0VejOVbFknPXZYIdAGE1V5JKhkau0ej
   MByq6Xijvz5eFEjEh5wkbIHtvfrxCKlRTg4cxXve7xsOakHM3T7FjR5fb
   QalPmFCRaGkKzCqz3S8EccObsM/QDU76s/vDNZl9ZFV1wjxUXqNAeRUDe
   lGRwO0yOHvbZqK8m5Hvg04JsIuWZXYIK4h1WU3vnGkimMqjP6LbaE3Apn
   w==;
X-CSE-ConnectionGUID: 4sQTf/FmQLGX2XZeQN3gcg==
X-CSE-MsgGUID: eBa5FnQXRMmw6DvR4qpwfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="33346478"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="33346478"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 08:31:34 -0700
X-CSE-ConnectionGUID: 7ibJx7O5Q5ST0bG5X+URyw==
X-CSE-MsgGUID: AlCNkh+PSwe0N7WH5lCACw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="73020623"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 08:31:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 08:31:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 08:31:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 08:31:32 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 08:31:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+da9japABnBIUEK3DXXJLg6Z/S39NJfsMhURUEdzVH1t7hVgG+BggOtyAuCNoA6BguohmoWaMkZiAveVyTxEMeL/lAXvURqs/7KQm8C7HQC4cKAKTP+mQg0oq/vgQKNkw8Th0jKGE+lsfNCpPGzBQ29HpSL/LXvi6CyMWrvl/hByafOL5vIsBfCmRM9eo8RsClvpisQI4hHf0jSLLfKHckUW7apG8673M5qi6ttnYc1hjfd6G3/SOrNLRu/espaO2DsJdpFx6R1QMYDff9azxYAYyWdVn6aHtyKCzppdOyv6+kcheJcXfqXrWEueu9GvmoaWJ7Z7mGR8/cA+yUqUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpwAAfzPp9vtjI+vFSM2bTPovg5wUMoCEPSBIFL/tK4=;
 b=Qpl61Dt44w3U13SnrG7xFwX8CAV6KSFZldK5HOzD1FzfbZcIIRyXoLXDniZCRxyHfvWVGzqkuQCnQB4KKWy+ZstIxsaCLfD1gH1tJ2ZNhDp9tZkc3r2JZ9zK2h/Uqevxwqm/LEXxAK5uhg+2Ep3W4WCtyrTBu61aItFt8QImL2g0KHJjgab38oz6t8/6MfXZ0qwiGD/dA22ifr0iXATBgA9IfWzUIJg/AXS0sOayHaUrP3T+QO7YiwyZKhtPjKdFLGLs4fztbllAzkbwWUVtGJjR7LXmwPvw87tyV4Ncne6XMsSS9M7fKKgAMaFxV7RHLS5XkdPGceG6SmPxWeKatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB6309.namprd11.prod.outlook.com (2603:10b6:8:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 15:31:23 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%7]) with mapi id 15.20.7677.030; Thu, 20 Jun 2024
 15:31:23 +0000
Date: Thu, 20 Jun 2024 16:31:07 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Adam Guerin <adam.guerin@intel.com>, "Benjamin
 Tissoires" <benjamin.tissoires@redhat.com>, Tom Zanussi
	<tom.zanussi@linux.intel.com>, Shashank Gupta <shashank.gupta@intel.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat: make adf_ctl_class constant
Message-ID: <ZnRLOxh2/v8uypig@gcabiddu-mobl.ger.corp.intel.com>
References: <2024061050-scale-presume-f311@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2024061050-scale-presume-f311@gregkh>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: MI1P293CA0020.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::18) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: f96d514f-6c3a-4fb8-2538-08dc913e0ad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fhxpI75OaEz5azqBm+ZgxQv2z8RoP1iipGGhX4+f/+vHaKK7iu/roM6IV8kG?=
 =?us-ascii?Q?fQsgdZQ113jTLjWCk8rHwwo1h3g5WVVxzo+DJwcyqgsCTEcKmZZBW/eErqyQ?=
 =?us-ascii?Q?O5IS5zVedEAEJFg9OLxpK6n5tdwylBi5ldxKd8YDD7a/7FpRXrKhIKZRYyYX?=
 =?us-ascii?Q?/fDMjRYuo/ELTiCvqSrbHC0qkXnMAJedVtZLP4Ix+8ADdwt9MDQSUbVcxXr6?=
 =?us-ascii?Q?1hXPESlLpss/812PwpIWLpV7ZryvWvcXxKXKbg9ACVlr1828fnwyn7le0Ibh?=
 =?us-ascii?Q?x+7afWBPS3LUqbrmM05DOnBi/lnxJP2WIFLqbNl1Cef99QtcuDwE4Cltkr56?=
 =?us-ascii?Q?jLPuY9kNI2PlfOMna/n3DbGGCOBWtugpq51pv3jPbayYBMviWW7dq0o5+5LP?=
 =?us-ascii?Q?qc1IbPeCXmOtwz/C6BPggPNxJ0Mtbl0jIJXerG84/l4lCVgLY5EBQvrpThv2?=
 =?us-ascii?Q?U37iVadVnjmHR76ex5MiL6VwGlL4F+rs6e/DPRCLRQc45kqYFVHdwPo2t82d?=
 =?us-ascii?Q?CwaLJY62VECGVKy4eCd9xnAE+/WevCHn7w4hRRsEi9ZNWqPPEJ6lAdru7OJz?=
 =?us-ascii?Q?pFS0MicsxdNmz2uGyAJp5sQQW8sl0ilR38Mnb34vPoa+KMLpy9tZW4uC2hD9?=
 =?us-ascii?Q?63BTo3ypS7oMEeDWAo/IRb6iV4O9glFGQXR1D8aFndMDWu3KASs3ZhIJ2wTd?=
 =?us-ascii?Q?z7rM1D12OjdRYH3p1Sz7WWVBvmDKMFutNaa/z3B/bjwetRVIDz3/L94Ghkrp?=
 =?us-ascii?Q?m0owChCVhB2kQVhkLbRg1w9xBaXSIlcKuHgkgTXAVthk7m0dfkjmLntXgS1v?=
 =?us-ascii?Q?uACeUfVMPD3Ki0wL9z/nfollvWWqbRvcV2FetbeZwymuWCCvpqg21mc6sn4Z?=
 =?us-ascii?Q?Vta5XwZdHLJIUBArLmaZ+oIDLUGfe1iwvV4f+oPPC/pXFVLH6OtaALSphskw?=
 =?us-ascii?Q?qMgmQeoQK4Ttz0zs8e9tczBKkp3b720haormsWrWbefRJ5jv4srdtuT8ylUk?=
 =?us-ascii?Q?+JZPfugGbypAPtrUKNhZAI0az5LgcYlGZJYuo38jrbCfPSDD1m6Kghj5Bt/J?=
 =?us-ascii?Q?sybsVLYeHbhc3IdYws0EOjObYhgM3/zctXRDALLWpniDw/fNqRva5JaeuMTQ?=
 =?us-ascii?Q?6kxtuHgHAr2thIO3BpM8PCf51If8Jlma0jQUN/5+15/RJl8oN8nP448/Rkw8?=
 =?us-ascii?Q?h2f/+rjnJIYrT0HOHf9+TeH/hjuFUGTrpphskpN51DWchxWGKNYNBXdBQRj5?=
 =?us-ascii?Q?XvvisH8D4+BoP5PmF7tXkPMbhcqUrW9SovQLPonKUnh1X50/iR6dYajOOUq0?=
 =?us-ascii?Q?iVrX9cNnh7bBSODp3LYZmCL/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FhQkxe1/yB4aUKbnc2x7E2ifgqIe17VAyarHQIIR/DMNtxeZonQKvUJeMZ4q?=
 =?us-ascii?Q?gwYO516LMrDucQvWatD4V3cX/yfWC9Rw1qEVapnORYGb7aXxeiLplnwdkLZQ?=
 =?us-ascii?Q?0S2cXp9oxoM9Kv+ufSN9LBpVzJiOLfASS3DroIB5J6/2Px4Ndcwp6iwQfvEd?=
 =?us-ascii?Q?koRSDCUIAIw+AII6zehwvMmQMdXTmGQ87jV/ZHrH6QtkmKke6zJujtEo1jMo?=
 =?us-ascii?Q?XEpGq05vCCixAPC50wMozlMfHg/oACqddh/99ip8cF9OrGZw70UEk/MeQuuy?=
 =?us-ascii?Q?z9lv4UlJlj8sAqqlRjKO+Q+k1QPWNfxjfOnp3gpUQkKxlOxmEjI1Bcb+ZOUf?=
 =?us-ascii?Q?l1CF8U35R9S9sNKQ+yl/9kkTln72BUHEGdELxvDSrHhOAswV1kpRUYJLVI23?=
 =?us-ascii?Q?h4Nz67pqmyJOouSjNAId6zAeCc9QQD6p7H30lPqCNkOf3s+9KSndwI71o+jH?=
 =?us-ascii?Q?FQdYjJ4M7eNqaEotss2OSFoH43cXd6joaniAVYUsx1cacTRcVePEbLwkAJgu?=
 =?us-ascii?Q?DQPsg1P++pjWxqOa+RWmwXuqQ+wJs1W0Vckmo/FS960eFo57oMBOWAvx6X9k?=
 =?us-ascii?Q?b3fH+gjnh2jarzRAqKXpo1JES6FV8aJOrhbxbv6UccobnLgyUj7lBdfvmRoT?=
 =?us-ascii?Q?Rr593suXvXRjpc2RYQPy21r2axlSZk3i0SyTi2Zsisdgkck5GGEn0+r9l19i?=
 =?us-ascii?Q?mJksrb9/mpGCI+Rfivg+iVFus+Q8VSLrDQzYfxO8AfKGfhcEOKn+PpDP7dzp?=
 =?us-ascii?Q?OpZ13c7ZugfW0TrqNRgPFKxwcoqfYGKBQvvqVVAcpBvHjTOQFwKP6Pf+OOKE?=
 =?us-ascii?Q?V5593aetp5xvknKQ/Pi729cqeDXy8+I/fKW/yPU98cfUoFqoUdwU/g8DACds?=
 =?us-ascii?Q?b/igo7xgdyHQdLskZtNuE8v9omDiX9/FbnRcwtWsy1nonCqms0eD0GASCoez?=
 =?us-ascii?Q?3nemd4Lf7zUat1emcaV14guQZ3j8XP+jS/D2HWtmQzv1uOem+jGjglz7xXGa?=
 =?us-ascii?Q?3yVpiP8tTUmXvalVX5py0ecd38zpQr0pKd935u/ywH84IcCwP4SIy0OcDf8B?=
 =?us-ascii?Q?YXZr22FuO5bO8oeAPvxTul3ANQf6qN1Sz5r8OYM8ZCvg2ldAdlq1kmkvfhu5?=
 =?us-ascii?Q?n/3dg4CI2NG8waiiuitREOSp/ZxYJdKeZiUFjOLT2qSDxTQHPJgGJef8h2gS?=
 =?us-ascii?Q?XkQZppUaLQAc6Rq/o0212e8z39LYEd5P3APDrgT81qebAB0V1oPv/RS4pqan?=
 =?us-ascii?Q?3YZSAnlXrWlWadz2KzXHLcvqlzSB3f5AT/F5IDbPGDi9amnKKi/xMZVp7rE4?=
 =?us-ascii?Q?hESbgPdTO18VqwT88holFz644SN9Wzl/Jw2+WnriQBe6UrOagDsUl0KcDlyi?=
 =?us-ascii?Q?0m4IRfJ/UH+CtjXGtf80ozHswSEQi+nT5J4Ujj+Nfd0IAmdcpTTi5a2094/j?=
 =?us-ascii?Q?20lLnQGrXM+G1bZu/yOTr9q7gKbWXAaykdQ0pcaTui1o1xP9XLanqu8+bIX2?=
 =?us-ascii?Q?OCz1gx8eb5VW+YjEwIDKKqYC9opVAuT81d4z4Uqs/Jf9vMQmxDHomGfWZEfu?=
 =?us-ascii?Q?mCcJGfESYhs1qd9kwBXpT4+AFDtFPq3g1Sh2OAkbKGSIMV1rgN1nug+0N5xM?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f96d514f-6c3a-4fb8-2538-08dc913e0ad1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 15:31:23.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +RtXOm/88FGVik3b3F8SKCF78yDFhNXbYsvXLg90ij0ef+Ad93DX4qtVx6HWv/Sy517xCn1aIy0mYMGbTivLbM3V3R3G9u/dXM+XEcRmoWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6309
X-OriginatorOrg: intel.com

On Mon, Jun 10, 2024 at 10:18:51AM +0200, Greg Kroah-Hartman wrote:
> Now that the driver core allows for struct class to be in read-only
> memory, we should make all 'class' structures declared at build time
> placing them into read-only memory, instead of having to be dynamically
> allocated at runtime.
> 
> Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Adam Guerin <adam.guerin@intel.com>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> Cc: Shashank Gupta <shashank.gupta@intel.com>
> Cc: qat-linux@intel.com
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
