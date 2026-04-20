Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7998739768F
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 10:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776681484; cv=fail; b=RGPfFQE0//hEV4v2mEri1ZHwBZ2oMoqSIIe33HXr1oPxax7OnTp4wB5iTFloNJtsvPQcMznS5llFubjNbkFI8vbUWod+LvWumeDsF11zx1/hTuZlaVDTbad+N6L9V6x9yoevfbh+RxRVvih+nuT8gyXv2qH+O3bh7vzv3WIIDVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776681484; c=relaxed/simple;
	bh=lyUK9++RtPSIhCFQsgn3B6X9cGYzccsCXYLzozQOTb4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jgPCzJeE6Ys9tdY29+o8NWZBrjobkyvOWU8g9EMoA4gW9zknyqqddbQsaEx2g0T+fD+ao6OAeWduSH4MfgS0TZXKFzjmR/I8w9j3Yo+KXhyR6KxeHxwYnKKKRhXjDt+51isw6wuu/1dmtd2iNTO+JbDPJNoqN+9wU2ccVgvNnQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n/+1eX+e; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n/+1eX+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776681482; x=1808217482;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lyUK9++RtPSIhCFQsgn3B6X9cGYzccsCXYLzozQOTb4=;
  b=n/+1eX+eLXahVMoKMAxOJIyJvSHqhBQObzPTPqfr97mL31WaH9fx756V
   qWPsoSMqVBY+6GaZZbG3q0jS78hECOqaX9VffbW7akn45Mo9UG8QYiRsi
   lhbvTYdSKvjKrfYCRtOAK7RwrOJrTsIuu5E2Fw5/8PoZjAqWAPThglssR
   ocZ+0scjNXcMxHc2fHCnR9+ziPV1bejvA6ZtIBDFsqI8M9EuEluA0eGTx
   YpKuOeFPrA2AK7zyWhQd0R7yEVD3cGKO/7n6PPDQwXV1OrpA7f+lk2Cnj
   /oznBhCb621HbOt0/GsaN/mHpJRvFqjI1MPhsHgeYCHLbjKmDAd9HxMVI
   g==;
X-CSE-ConnectionGUID: RxyZxDU+Tl6FkQw4BXpbUQ==
X-CSE-MsgGUID: IL6xJ6U0QOyFPXF4RVEmaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="89060683"
X-IronPort-AV: E=Sophos;i="6.23,189,1770624000"; 
   d="scan'208";a="89060683"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 03:38:01 -0700
X-CSE-ConnectionGUID: PG3b2f+sTCidoHQes2s73Q==
X-CSE-MsgGUID: Hhwt4wT+T+GizrDYld5BQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,189,1770624000"; 
   d="scan'208";a="269727677"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 03:38:01 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 03:38:00 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 20 Apr 2026 03:38:00 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.13) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 03:37:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzAuAjC/hQC1IrZeF7Ykbi1W2xD6QB2miCaFC8+28l4L0K/zLzBvORPaPLfGg8oClTMOjNrNnY+V0MAlKipI8yD2falWUlW8t2XEO6uGzLAqoRG++h8LTxWtPL8+ojyGdtmQRkHVpslYO8YlocjVO0iuglp1XMbqr78pe3N0UVoIG/UzobPM+r+sgJYq6AxI5jtHHpHgexyHwGrlJZvgNXtPOW+8q5rWLuKmeQbtEjhacCEehiAsEGjSOJvjeEZJvqz1nygm/XP6EQLnUaJ2njA3jDP10sK7y8sZ+L11qL2eMDr4EbYNWr9O6Lkfw3jNHSSh/htWfdeyf4W8QF1m7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FT9B/Q8SIuCz23N3a2QdbbwGNAkMwhrDwyfuz5vqfLg=;
 b=X3sAK6C1zopv9UZxADsM0zMfGrJZ1tH4rhr1LN6AhEHoOPndpo6hC2xV0GmuT5++mRsILddcwI06t3RdAYqYXFJ+bthG9+F3MpEs/MieWucOQk8RBGzL0GK/4zHcJMw8oYCxvDIp3viDqyPaV++xx7mecWiO0HIXqloTBw/fSqS69IfZiLC07VviAD75N2xE0eqwsHOCbkYUbYbmpHpKt+C6WBCtdvFLf7Fvs7eixJ5w3C/2xOmXoLuRl/S2N+55h1U9Nkysgjd2d5SBcjjEbExkbbwehjlOJQplmmrRGpHwPSuxFq0FI7vMShdK1CL8TwfGlDTPoi9y3ZSyoq1BOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 20 Apr
 2026 10:37:55 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9846.014; Mon, 20 Apr 2026
 10:37:54 +0000
Date: Mon, 20 Apr 2026 11:37:48 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Laurent M Coquerel
	<laurent.m.coquerel@intel.com>, <senozhatsky@chromium.org>
Subject: Re: [PATCH v2] crypto: deflate - fix decompression window size
Message-ID: <aeYB/Jjb885fJ/mU@gcabiddu-mobl.ger.corp.intel.com>
References: <20260326100433.57324-1-giovanni.cabiddu@intel.com>
 <ac8I4mpkdn8uy8TE@gondor.apana.org.au>
 <aeEWf4j+VO0FziNj@gcabiddu-mobl.ger.corp.intel.com>
 <aeXo79eNiYnJ2ImV@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeXo79eNiYnJ2ImV@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P191CA0027.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::29) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|PH0PR11MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: bb1ffe76-cbbf-4f7d-b513-08de9ec8e175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: OHhWsBCV1IHSgKJ25Ew9N/lksRIU/xbVrCwH8wNfLAYose1AoVXbRz8DraN8GnjQ1lDhi5xqMNNLZgD9jRrgCw1QmCf+XyaX3cNMrs6hD1d221whNHbv+HLJSUE+tcA+JI+VOywg4OFygs7ZuJLPyey0ECkVA8JiNBhxZ818+77gpeXK3FBZ1CeOGaLRNRLkcw2IrkJ/PowhD84kQpg7IVKak9GkTcJ3q1W9xCCk8csmUmylFGU1aNTUETv77DDamMaztWGLDkmS5NUgddGez3hKHmlDyo1S4qEwt09iGZLUgIsYJT5qjKEzSR9O9hpHehQ05YkNYDy3mEh4ahJUD+DpxVs+BNMRzFrd6yT48If5hRvVXgranUSlv/1KrkltPecb/+2sDNqnJAqBll+Ix3HVtXV/8QReW8I9HSlrYvSxxECz8geQK1RuTAdZxZj9q9/jVZsR2yLsLRmv4wsUBopPj/eV332gs9jhcETIRbdwfqDZvDjZgfgiFaB6abyiII7KEMIeaKRvBbP1cn/BB6NfWO5Ng/C8y6NfVjvXdjWKl1z7JN830wgbFSuUkAXNi9ZyHM0qG7RMRNBLDthHh5IrQWdlkpXJRF698rh4aDMHARAd2FVms7j1QRtswZbx6/Uk1fJP25KQNg76dz9VJ6xDWPsvbloSq7e+LlyWVr/tePdUo9T3dvLPrrnEtiHmypp9PoZ4fcpRCNz1eo+++t19n8031mny8e0Y4kyJftg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEwyTzg3TDRYWkF4dG9OeE1jMWkreTlYQ1FIZnhueTdleGxwK0ROeWRZMmRh?=
 =?utf-8?B?UmgyaU5ncEt0L2lQdGgxNEwyVEJKTE5hc0NRUk5OK2RLeVRtNUdoTFNYUjVZ?=
 =?utf-8?B?VUlqZW9kdmVPam05a00wR3FBaFRVQ3IwY0NUa1lmaUZiV3Qwc3E4ZU5KUXpB?=
 =?utf-8?B?ZEZKOTlHeUJmK25FT09xejJBeWtsTDhKZlV0UXkwVlR6cCswUzJxYTFFUjNC?=
 =?utf-8?B?Z3E0amNsRGp2by9JWHJRQkFUSjRVK3VrekQwbW5ZWjRhT2xFVVhFdXFEUTZp?=
 =?utf-8?B?QlpzTTFVVGx0T2ovZlpuWkg0Qjk0RlJzU1l5ZUswejg2UGozNnFNL3ZCZ3JZ?=
 =?utf-8?B?cktEOGJrdEpjeWZxYi83OWRqeTBqT3FwUU1Db2c1dThOakw4UmRvbWlsYzU3?=
 =?utf-8?B?UVM2UjQ2dFJUQ2dvNStTTzE0SGt2Y21GNDJqeDBuRmJOdExBVFU4eGN6MFlV?=
 =?utf-8?B?djZ6YkxsK2FvMHN4Z1V5TllPZmFOSDluVm15TDZCUHpMY3RScEJHUGY3VklO?=
 =?utf-8?B?WFlIZTkzSG5rR1FPb2ZuRWRXV0c1UncycUVJYzQ2eHY3OW9RcTY0VjlwRVZp?=
 =?utf-8?B?ZVQxNzJndVpDSUdUb3dzOFFQZ3NMYm5Xd081S0xIa2J1YWQ1TnhYMGVLYUFW?=
 =?utf-8?B?Yjd0a2k3UkJXcjdUSHFiTStkK3dYNnpwaFd4VGJVUUl0TjlCWkNYR3dtc0JN?=
 =?utf-8?B?ZDZ1dCtncXErM3FEUVVPN1phbWZ2cXhZRFFRVjNjM00zMDhtNDBDVVl0YjRi?=
 =?utf-8?B?dTNpbyt3bVloZXdMTjM5Sk94K3FxWkFHVWZjK0RjdmdqV1FjeUROMWF6ZnZX?=
 =?utf-8?B?YWxPK2c5c0tsNS9OVXVURjFqa3hrK3d5bWd2UjVSVDBtVHg5OEhCa3lDVWw5?=
 =?utf-8?B?VlJPcTZ0MUk0YkQrK1c3SW9CemhRK1FXZ0ZWdEw5aEgrNnJYMWM4UytJTUJO?=
 =?utf-8?B?Y0dIVUFLRkJPYTd6V2xpZCtnZUNDelBZMVN5d2hWMHZ6cjlGczdSUkhCK2tS?=
 =?utf-8?B?U0FhZkdQN0ZrT05ISXRtZmI5bitYaEZCWXJqQ0prV2kxYUJLMitMZyttWHNy?=
 =?utf-8?B?bTdwTkd2VGhnQ24zOEVvMVFXTU9oUGNXZVFiS29YR0w2WFpIVkpIUVZiUXJE?=
 =?utf-8?B?NVdMeExEbytjTEpaWUtkNmF6Z3AwQXZ6TzF5NkkvZXNDSzJNVzZuZXIrZUxL?=
 =?utf-8?B?M0pXU0dZbitqTm5GNXE2V2RCQWE5M0VTUHBwTGZzVTBQYmYxa1ZTaEVEMjEw?=
 =?utf-8?B?ei9zMjlCYnNZLzYwMUQzRUxhNXYyaGJEOHhrOVVRSjJIT2xneEswdUhzM3pJ?=
 =?utf-8?B?cHBXMTZhQWI1RnRJODJVVUY1RHVXR0EzMjhQTk5keENJM2hrc2N5cng4b0pT?=
 =?utf-8?B?d2RtRlNJdUJvYTRUS0FaVkhFbzh0Z1RjZURJWktIRW9KWHdaK3luVzkveXlp?=
 =?utf-8?B?MG1VZllFNEF4aUNnOWZqSENLbUxSanFwVHZhc3BMR1g0UkhlZlNpc0gwRlRi?=
 =?utf-8?B?MXpJbVFLNzVwZlJGaC9WNWp5M3FHbVpDMkN6NFkzekEvSWh6Y0VMT2Q5cTNW?=
 =?utf-8?B?dDFKSFJ4SGtBd2RicjRGVW4zMmtjWEpqOEdtVHJOZHlhd3JtQU5RSXBhUVVJ?=
 =?utf-8?B?YThhVDRXVlYycExzTmtBTlRyWVRUVFk5eVJqd250QlluZzk2YU4yRTYyaVB2?=
 =?utf-8?B?LzF4cDg0clpjSit6elFNRHJUR0JFbnRlY2x2WTdrbFRKUGFwaS9ZSmR4RlYr?=
 =?utf-8?B?b202VkxNSlRoUXlLdytvNHVmZ04yNXE3NnJyWUtNTFBaVXhNRlR4UEFUR1Bx?=
 =?utf-8?B?cVdVcXdEUXlLQVptWXY4N0UyZjJNaDc1aVo2cVFXWDdZb1J5amRmTDNObEhT?=
 =?utf-8?B?TXVSZnYxSXQ5cFFjbUFuRmtNanplYWdTRVFLajVPaWZaVG5UY3FiSWRnUFVC?=
 =?utf-8?B?blN3NzFBQ2FIa1kwcEZuVVlHM2dYZ2VVOUJwTElOSnZINVk0UjJFbzBMYTYx?=
 =?utf-8?B?UVRFYjRUaTZaUzlzUTIzbnFaam5VQnByL2ZiMjVwNzJRL0ZUZHNpRW1sVWpj?=
 =?utf-8?B?b1Z5RWdoVDNGK0FYcUJEKy80LzlyNi9iQmhIWjZhZUFHMDE5WktCRUVjcGVt?=
 =?utf-8?B?RWk2Si91aTVyV2FVTGUzb21ZeGJYSG80Q3RTRzlWUWszRXhsbFZMWkJ4VTFZ?=
 =?utf-8?B?VHJ5c3lOd1lyZXNib2JBS3pLdld4OTNtTTFjRTdQbjUzT1lHQ2NKcVozbXlm?=
 =?utf-8?B?dGFCZlFwcmMyYWNtWjJONEwrNXJsT09xdlpwcEszZndIRVZTRXRoMzY5Q3dY?=
 =?utf-8?B?ZmZBellpTUhsYW5FRkdRY0lKeG5wNjIyNTF0eUQ0N0VqUEZyTlJ3MnZ2VlRF?=
 =?utf-8?Q?PPGe257gF5bR4E5w=3D?=
X-Exchange-RoutingPolicyChecked: pDZ5XP9y0oDLnBzG89a+8MG4RLJJ7/fyVQ5bSHFSjkBcOGd+KLSuegEGF+NoLznPEX9pftiamI2nfzwYD3WGOLqZwY5dWHkPVOVusOlwxiKsJuO2k/ld+IYp4mYpxYTTM8P/6tJ5HUrY4PPJ/BcX2TmQh48SZ/2uSO+KRCp0lfRM1ctbWhajclvagc8J9lfBy9Yd2dx9i0a6XBNSa/hazREwmvp5psD9ykt3pOg9WU3+N/2tJpXg6fAbY3ZEAOyPsWeevivvPnbZEp+Z7y+wY+7zE5/wAZdBZtH5NzYJtG30fTkzWn6mjusOzt2aqw4Y5EQ6WXXCnmwIYdUZT+sm1w==
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1ffe76-cbbf-4f7d-b513-08de9ec8e175
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 10:37:54.7975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8w1TGUhbM/v3aUvw9mJvGc6w1vlqhTwPjVtC4m7LdmCmF/+QPkcQg0RknRfyahS8Xl4vGoEywpeuF5wcf/CTAHEVcmsgVDJuZK18LMkU18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5880
X-OriginatorOrg: intel.com

Adding Sergey for zram.

On Mon, Apr 20, 2026 at 04:50:55PM +0800, Herbert Xu wrote:
> On Thu, Apr 16, 2026 at 06:03:59PM +0100, Giovanni Cabiddu wrote:
> >
> > I'm reworking the acomp/BTRFS set, and that will be included there.
> 
> I'd prefer a standalone parameters patch-set, with the first user
> being zram.
Sure, no problem.

I was already working in parallel on enabling zram to use acomp, so it
can leverage the compression accelerators. I'm also working on an
enhanced async version to better exploit the full parallelism of the
accelerators.
I have a preliminary patchset and can integrate the parameters work on
top of that.

One question on the design: my current implementation adds an
additional acomp‑based plugin to zcomp, allowing selection among all
implementations registered with acomp.
Do you think this is a reasonable initial approach, or were you instead
considering a full replacement of zcomp with acomp?

> 
> > I don't think this should be treated as a parameter. A decompressor must
> > be able to handle any valid DEFLATE stream. RFC1951 (section 3.3) [1]
> > states that while a compressor may restrict parameters such as window
> > size, a compliant decompressor must accept the full range defined by the
> > specification.
> 
> I thought this is the whole point of parameters.  Different parameters
> would generate compression output that may not be decompressed unless
> you used the same set of parameters.
Yes, I see your point, and I need to think this through some more.
Some hardware implementations may not allow configuring the window size.

I ran into this when falling back to deflate‑generic to decompress data
produced by one of the accelerators.

Thanks,

-- 
Giovanni
