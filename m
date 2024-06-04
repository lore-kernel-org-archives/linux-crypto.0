Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8DD33F6;
	Tue,  4 Jun 2024 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717518298; cv=fail; b=iMP0M5rA/UJnlGFPKgfAbB7JhNZ+OaHGJEJGR90Oq159fbeQyZWFoFs13aA8OCmUN4pVM8LeXJDDlycxcBYuUfwXIzxHZkiY1eMQOPuoADAEX+qe49d1nEcB96xWaZRmFzta5wbBnY180j5dxv1BjsDxA7fRlR6xLC8VNCoCTTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717518298; c=relaxed/simple;
	bh=bBIrOSV/OzbMD8iPG6A79HN/c+rqZU3EGL66l6x7U0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HTo5HKEWbmJCFUyVKXs06KWQROsAj6hpar0Af2JODsJBAAkYS1aqTR6I9RBxsCry3lHU2G4XvDadXk66ORwsMd5onW+lChNYTz2hZGKtkQiS/MjOFqhac9aTR4Q3CZQyg6TlQ9xEOZcxoWiRUFQxnVyz0exhEpANsOiQgszfx6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LuJdnSSv; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LuJdnSSv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEt2B5T2MoqvSW1SieJW3LmcifnYslJ938g71NZE/+sFZAsU/jMK6Y6N2JflDXYlIV6J/TcexeJZxWAJmQqBQFyjPi1SDoF6KtZhWDConpDFcjvHnEsaVF0jel11nAFq0VtjlqI7CK3nga6lmNVG0hViNbjpdPlcAMqe95HZJD3FJT9Yz9bWBfSDJadYSBnrCqg6iKKPbTQFBBismapdPfx2v0TMxIfy5coI/IBh7VYpcideQWZ53d0vhhL/XVRVqAypj/Y1sTsmM+pjkL1fPiKroMvJR2cIl/LiMqzGnERzTUI1cuBlWPHIfYtieSs9mRFYw/Sf9Hei9pMXYVOeNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SY/nW9YXZxquM+p+YZ98syY2armdRQ52H+p0zuwZS6k=;
 b=kWhfcnV+zTezzEughW8gq59QxVWX+93UycoMO8DOCtYRONpdnJxrW2xGIYfm0jDz+gNghW48EqTLubqlxdy6Xpo/jfowBpNrpRJheXQ6vIkSF56dx/ZKF6N5oygwoe/KyAp5tZUCqujMVzr3NThxppmZ0WaRqAUrdRZRmj00Mi1JImr3Nr/6GpY1TBhgH4Faw1DmR1dE77bNo2u2pikdOq1dhYBYbaD73rY/B/vzV72npH+HVUbfJ/KSl44SUpk6eBcoso+GNtxOqOQq3mXkNVq1iBpGBgBiLMxN0sDFF8c34fyzQT6LFRZSBrrZSPNh44Mrd1EDIYxpAi3GhUB5PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SY/nW9YXZxquM+p+YZ98syY2armdRQ52H+p0zuwZS6k=;
 b=LuJdnSSvrrc2xAQzwaVE16XNfmYknk6xFdrdKp470+93FVS8KV0e0QeZNxBElp3vcuIIcGBnXJe+/adWCxCN9pj7qR+2NntrZuk+V4hPycvP/VTP8yBV5KegYlWK/g57Uu1Tbw1TejvROVpGpt/E8dcE5sfFWhJO7cviv4sW2S4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by SA1PR12MB6872.namprd12.prod.outlook.com (2603:10b6:806:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 16:24:46 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%4]) with mapi id 15.20.7633.018; Tue, 4 Jun 2024
 16:24:46 +0000
Date: Tue, 4 Jun 2024 11:24:38 -0500
From: John Allen <john.allen@amd.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Fix null pointer dereference in
 __sev_snp_shutdown_locked
Message-ID: <Zl8/xnv+euz3GLGC@AUS-L1-JOHALLEN.amd.com>
References: <20240603151212.18342-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603151212.18342-1-kim.phillips@amd.com>
X-ClientProxiedBy: SJ2PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:a03:505::16) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|SA1PR12MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fbcaf86-8e57-4f2c-fe0d-08dc84b2d966
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S++XYLS00WnGLLMnhms2gldhLNPoZUsJ1Cc+ecZa3CGeFuHOF3Xe7n5chF3t?=
 =?us-ascii?Q?N3qXXW/huKeyMHj1ZZGwzSSvStG7r68rBMCROfA4EHenph0kOixvsUIK9uy9?=
 =?us-ascii?Q?6Hl6Z7bE2Z83Db4SJk3J0ViOcsqZGkM7GQnfMLqJiUZlqvrb/ubwZmX0T22J?=
 =?us-ascii?Q?C7semNK0GEHZfr18Yg4DeAE73uqo4Z4jwXDMGJHI9CZB0YMqPBUWAYjByNkD?=
 =?us-ascii?Q?s9Fi27R4sbn6+00xnvCqj1iCYYuOGbZRxFsqb/NUn01N1mKZ5GcJAJl4lw4o?=
 =?us-ascii?Q?mXt6WC5190MfnSdU5P8e1rCltkWcHndg2b2sacYzlaT7ovLbBIp0uS+fsR+J?=
 =?us-ascii?Q?/2gziWiBr59WgxUWds0P1ooluEkuEeSyOJrTsFsuyDwCyjxW2UyXeqRW3B6u?=
 =?us-ascii?Q?U2pXLgNUPOys5hKmP5Dt+n3JMRYoZOE5u43h3NkmBCL1Tr2kVOjIXZmdSVoR?=
 =?us-ascii?Q?msApEYiViTblUfYCIbXdmay8AFXYsrz0dJz7Y/9mzfXYjvLIwL6KY3PuAXC7?=
 =?us-ascii?Q?dYum52LEX0rnWkvur6Wx8d6p4Iwj9vkcg+2lBjdePKkh6qWNY8sK3hH+iY2D?=
 =?us-ascii?Q?wIDjOzyQp3772qfUg6tWZHZS/BBUaTrqx+tSEgQGnvx5dmgNg1pZUSS2vMTJ?=
 =?us-ascii?Q?mr0kIpoRX0f3kT6fY/gUHOIJDRZx1IlCJGMrOnpmtZdknnRSZeZyl+h7AMPx?=
 =?us-ascii?Q?VI9DOwSaP49a07Sl5OvAuq+AXZIqCPWDFYmDu9tdKzuGllS9R2yC0dzH4kfM?=
 =?us-ascii?Q?uPx0EQjq4k/cUBG2bQSGU8FcVkpsOElRXIsY14e2xjDvLGIh02+BpxmplBZX?=
 =?us-ascii?Q?XjJ6S8OWanH5QzAPpqEuea3MjVM4BOdUmvESZHqa6r4EwsYFRaxoczOftdzb?=
 =?us-ascii?Q?sun2WSD6uI3OYcq0MjlN1LOcYsOUVtfadYcq7oqn8jYslWe7BXkizzNRHnAn?=
 =?us-ascii?Q?G4Lg/bCD9k0UH+SON9fQf0gIZaybTVVPvSKD7dbX+CQLxqIaW5cWkjxCWRxS?=
 =?us-ascii?Q?OdaWUzk7pwh8lgovVGYpRG8y0R1UPPJEItzmXX5NbAIFFHXyIVReDYIcLy8j?=
 =?us-ascii?Q?dZj9Butuh+yvJC4A0EA6tF8UX3/fcMsUJUs2iBw5K92EmK6xL5g8iu8R8Wpy?=
 =?us-ascii?Q?W6dCzqtUX3CyMh2t2cZfGhpa4O8n+yMkSq6IBnTHwfV5hAda0IQanwdYfnxs?=
 =?us-ascii?Q?KesjJhO7N6t0Wbw+sbjNiuoh9nX4tOqILwjxctFpnpbVGtUCd2cCkWJhP76Y?=
 =?us-ascii?Q?5KqJ5tvyJBpqLiul3vHQLJTvnh4PE/N8D5QMLPJ/gw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O12QXqZoXu97i+imo+o34W+oAZViXNarVxIvZcyWT9NbJ6vOuNRAQmAyrsR0?=
 =?us-ascii?Q?7AAaTRfUFdG77IL6yMI8B8fkquCOVPEpcNy96JneIW33PruFU/TbALQ9lftf?=
 =?us-ascii?Q?JbWYMuusLCARXcx/g6xPNipiRFFBzQnJXP3y2NOwrBsMjwVBEGHOXsB3yzIm?=
 =?us-ascii?Q?gPt39R4yv/3EFinKlj5+qGpBagGDajaQqrLxdBcGqgUs4j/dQWRFLUWp3GzB?=
 =?us-ascii?Q?R9S/t2BUox1p5InhQx6mdVs3vr5ajl05tc6pjug+XILJdFXaqqvOjeQgA4Qt?=
 =?us-ascii?Q?l73f5oxksXCIDZ55ekjjlEzKxx61bt1pwRxMyqu0eXmZRST07TnzqHO091Tz?=
 =?us-ascii?Q?JEB6wZzgyqvhaGe6/Id47X6hlmFN7MbkNA05pZ+PJ3xtgUQF491xmb5H9ZEs?=
 =?us-ascii?Q?lbH2frC43CUgF2ixLngiNrpJi3+r3FtBpKTtMjzQnzvEK/EbZb+slHVq9kvS?=
 =?us-ascii?Q?rmebRI5vqWOlxXtQFTmODYR6KYGK4VODfLvok67mRX1j/ENuU75nMRNsiATs?=
 =?us-ascii?Q?uNI42r8XZLG+UiFibCNMa8FkzLKldovkKiH2L10nELZ3inrSAf0Xj0H4ThAY?=
 =?us-ascii?Q?4xaQaIVeA3aODPNCu45gas8kPBkvKJlFOPltXgASRVQ46DasqseSm8jwktrZ?=
 =?us-ascii?Q?co63s6O0KRHfIb4kZESVMocgg9g/GCaE3lQW8HXdn4NXuFWjBYwGijZuc3fc?=
 =?us-ascii?Q?t1xEC9y4ZN36lL+0GStPwq4A/8m7JCnKgKJMJSswpRECvVRoll5/YV0j+pg0?=
 =?us-ascii?Q?XpRRsnVGEcOHyqWjtcss1D02lz3cJ+DIJ+kKI/b7/kG0BuyFVK9BIKQ8HnVM?=
 =?us-ascii?Q?o986Aiy6MJKuktOH/VPmLo3edyUMIchSnL70aEJE1lQfkGgXPyqTr8OwQYNZ?=
 =?us-ascii?Q?lRSpcc/nql5TyhUTz/JDzX7g5So+Lrw0g9wLFG4UsyAlo+Ny95/ta9dQ29fM?=
 =?us-ascii?Q?4A43oyd7zqVyAkJETUaUtKyuz9yBN4pOcaBKgk62zTU+qsxIos4A+SheL5MO?=
 =?us-ascii?Q?5qF2mC5+yNFfKiSTXBS1WKNnhoTZm1xj+U94VVdNU8418xYxK8jzj2OCtRqn?=
 =?us-ascii?Q?+ftgKr1LYE0cooS01hpuIb1Dy4buRGXYIFPEXPkHpH8t+8DSt1TWEg0pfPlV?=
 =?us-ascii?Q?SI7fqssoQFQNH4HLO5dR3wYWzDa2Nq5tnKPU9T/HQN1nhM26dcT4rBHp10Ga?=
 =?us-ascii?Q?PI+XrUb5IkdPwBLo4k9iBmAIvBLsU+nGU3HILw1oiKzCSC8sL5AziNPw+OTp?=
 =?us-ascii?Q?PcjpP7mKJu18gU6UEJWFeaOCZzhLIv76oK4XwWwPSpfdx/s+CmULLRKhe+KP?=
 =?us-ascii?Q?cCJjaWQ+u775h7LjH8esz6uCisqwEvc8cBYoflpiBlA6Rvu6N2dGbkSog8vy?=
 =?us-ascii?Q?d5XAu8bJdh0mnvXo2pwfRzxqqxZZaJEmukk+bXt3lnXT3D203/ykE1hRB5OM?=
 =?us-ascii?Q?epcij5PEs3j4/HUSpBiWtAzUugeODatBEwRaNI00tPycdmQayuryhxc03PV3?=
 =?us-ascii?Q?Hxo3UPCeGe7WonHgLVxW/d3Vuq8+8paSwKALUSFTvm+B0s1PeZ0A/4mB4aKA?=
 =?us-ascii?Q?gPm1uo+43TeCYflcMHG4NHtRSRoyaIJBfp51X753?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbcaf86-8e57-4f2c-fe0d-08dc84b2d966
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 16:24:46.8134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBqIVZYQ1Ani8kf0MiUedDNSqseYp09tw94h/iR4zvlgh+F+SD3zGzMN2uWXoYlJWTTCYLOmL+awXKhIgp/zEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6872

On Mon, Jun 03, 2024 at 10:12:12AM -0500, Kim Phillips wrote:
> Another DEBUG_TEST_DRIVER_REMOVE induced splat found, this time
> in __sev_snp_shutdown_locked().
> 
> [   38.625613] ccp 0000:55:00.5: enabling device (0000 -> 0002)
> [   38.633022] ccp 0000:55:00.5: sev enabled
> [   38.637498] ccp 0000:55:00.5: psp enabled
> [   38.642011] BUG: kernel NULL pointer dereference, address: 00000000000000f0
> [   38.645963] #PF: supervisor read access in kernel mode
> [   38.645963] #PF: error_code(0x0000) - not-present page
> [   38.645963] PGD 0 P4D 0
> [   38.645963] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
> [   38.645963] CPU: 262 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc1+ #29
> [   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
> [   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
> [   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
> [   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
> [   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
> [   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
> [   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
> [   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
> [   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
> [   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
> [   38.645963] PKRU: 55555554
> [   38.645963] Call Trace:
> [   38.645963]  <TASK>
> [   38.645963]  ? __die_body+0x6f/0xb0
> [   38.645963]  ? __die+0xcc/0xf0
> [   38.645963]  ? page_fault_oops+0x330/0x3a0
> [   38.645963]  ? save_trace+0x2a5/0x360
> [   38.645963]  ? do_user_addr_fault+0x583/0x630
> [   38.645963]  ? exc_page_fault+0x81/0x120
> [   38.645963]  ? asm_exc_page_fault+0x2b/0x30
> [   38.645963]  ? __sev_snp_shutdown_locked+0x2e/0x150
> [   38.645963]  __sev_firmware_shutdown+0x349/0x5b0
> [   38.645963]  ? pm_runtime_barrier+0x66/0xe0
> [   38.645963]  sev_dev_destroy+0x34/0xb0
> [   38.645963]  psp_dev_destroy+0x27/0x60
> [   38.645963]  sp_destroy+0x39/0x90
> [   38.645963]  sp_pci_remove+0x22/0x60
> [   38.645963]  pci_device_remove+0x4e/0x110
> [   38.645963]  really_probe+0x271/0x4e0
> [   38.645963]  __driver_probe_device+0x8f/0x160
> [   38.645963]  driver_probe_device+0x24/0x120
> [   38.645963]  __driver_attach+0xc7/0x280
> [   38.645963]  ? driver_attach+0x30/0x30
> [   38.645963]  bus_for_each_dev+0x10d/0x130
> [   38.645963]  driver_attach+0x22/0x30
> [   38.645963]  bus_add_driver+0x171/0x2b0
> [   38.645963]  ? unaccepted_memory_init_kdump+0x20/0x20
> [   38.645963]  driver_register+0x67/0x100
> [   38.645963]  __pci_register_driver+0x83/0x90
> [   38.645963]  sp_pci_init+0x22/0x30
> [   38.645963]  sp_mod_init+0x13/0x30
> [   38.645963]  do_one_initcall+0xb8/0x290
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100
> [   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0
> [   38.645963]  ? local_clock+0x1c/0x60
> [   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100
> [   38.645963]  ? __lock_acquire+0xd90/0xe30
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100
> [   38.645963]  ? __create_object+0x66/0x100
> [   38.645963]  ? local_clock+0x1c/0x60
> [   38.645963]  ? __create_object+0x66/0x100
> [   38.645963]  ? parameq+0x1b/0x90
> [   38.645963]  ? parse_one+0x6d/0x1d0
> [   38.645963]  ? parse_args+0xd7/0x1f0
> [   38.645963]  ? do_initcall_level+0x180/0x180
> [   38.645963]  do_initcall_level+0xb0/0x180
> [   38.645963]  do_initcalls+0x60/0xa0
> [   38.645963]  ? kernel_init+0x1f/0x1d0
> [   38.645963]  do_basic_setup+0x41/0x50
> [   38.645963]  kernel_init_freeable+0x1ac/0x230
> [   38.645963]  ? rest_init+0x1f0/0x1f0
> [   38.645963]  kernel_init+0x1f/0x1d0
> [   38.645963]  ? rest_init+0x1f0/0x1f0
> [   38.645963]  ret_from_fork+0x3d/0x50
> [   38.645963]  ? rest_init+0x1f0/0x1f0
> [   38.645963]  ret_from_fork_asm+0x11/0x20
> [   38.645963]  </TASK>
> [   38.645963] Modules linked in:
> [   38.645963] CR2: 00000000000000f0
> [   38.645963] ---[ end trace 0000000000000000 ]---
> [   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
> [   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
> [   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
> [   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
> [   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
> [   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
> [   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
> [   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
> [   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
> [   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
> [   38.645963] PKRU: 55555554
> [   38.645963] Kernel panic - not syncing: Fatal exception
> [   38.645963] Kernel Offset: 0x1fc00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> Fixes: ccb88e9549e7 ("crypto: ccp - Fix null pointer dereference in __sev_platform_shutdown_locked")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

I just have a couple of nits on the commit description. Please trim the
"[   38.645963]" from the beginning of the kernel trace. Also, a
description of the problem and the fix would be nice. Maybe something
along the lines of:

"Fix a null pointer dereference induced with DEBUG_TEST_DRIVER_REMOVE.
Return from __sev_snp_shutdown_locked if the sev_device or the
psp_device structs are not initialized. Without the fix, the driver will
produce the following splat:
..."

Otherwise, patch content looks good to me.

Reviewed-by: John Allen <john.allen@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2102377f727b..1912bee22dd4 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1642,10 +1642,16 @@ static int sev_update_firmware(struct device *dev)
>  
>  static int __sev_snp_shutdown_locked(int *error, bool panic)
>  {
> -	struct sev_device *sev = psp_master->sev_data;
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
>  	struct sev_data_snp_shutdown_ex data;
>  	int ret;
>  
> +	if (!psp || !psp->sev_data)
> +		return 0;
> +
> +	sev = psp->sev_data;
> +
>  	if (!sev->snp_initialized)
>  		return 0;
>  
> -- 
> 2.34.1
> 
