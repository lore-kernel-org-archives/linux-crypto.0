Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED300256C75;
	Fri,  7 Mar 2025 20:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741379347; cv=fail; b=A1Jc1eSfemX3rAkaNT1+xz0U3ieqIex+bUw/gDA9AQc5IAnt1ixEsl97IKTMLJflveXYgE/+lFm0a7a8QV/7R2uIxViflZmz+H2+Hp0vVvJ+XxUNa0lJwDBj31UXbJlm+y2eAKBdGcKA5kr6XPiIsZwPQaoe1IVmlHoMfiYzcno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741379347; c=relaxed/simple;
	bh=N6yUKhAzGcD10QLoizv+rOG6NCEvWN/0HkbD2oDe5l0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uYtcpwa+H/t2i7Q/ua9Za9M2+5BpYz+O6aan/Gl3L6VY84ZYfgFfJfBihAT2wr/YmJ/sWKMxpMcJiLx3uYA12L7do1SHnrfarx3tD+spAm5z0G3iEEByB867Se9UmAcx+ExYlKIjtO/3Fo0w8+5NEYAi1ljYzlxd5HAEjtcr2Oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TKYgJByg; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TKYgJByg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MqSqCdie6pnIbp7vFoAahuA4dUcf3dDqzq7QnF1sV/AffguWTEJIRcivNxvigwbiPvV+4hcNzTm0f4SkKf++YuDI41SFn+3gVMkpjGFsIOHyEonhMl9sqISR76+1gBZMdDHsxstlQQ5ZMDdvRwuJj8t8n6dQbhGmycGUkXZtKbs9yKjtzXN4RLLfxp6Jkrt3tVsLP9pHI17dK/s9teFLXC1q0WoA4YiQem4DTNDq50iL5sxPYVobvV3fbnbEKVDe+0jcrZ4wxFNtkiEyGq6JAg8gAMLyMfZ/KUNU2xURk/xiP4HezzUPMY5N/fFh7vZZ0P1VueUQpLIZKA2cTvepMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8pdV9qvlbAiORtGUTiw5QuOil4FE0L8XnAGhSDOEK8=;
 b=bLlhIP20Jr3LYxVL03L+gJw199hDJNG6LqtjztGOBEm3Ng9TpK2v/xNm9rEHhf7pDfURHbP7uklGEgZzb7pl1f7OvWLa93ufzvV2Uj8OEjnkxMt1QCXPKUdO54ooUNphqRgGTARyyXtqfoOSgbTfEApkqNiDCg79fz2dk40vZD/DPRlTrN5U69V1nZBKlk7iDOTeyngg0YtCTIH6j3n5Wl+vr501HfcxS1U9/x0ppvvQ6W4zo16m/IqNmNSx86ewTFxOOKjP7h/+9hSyjV952MmxK1ypaPJRb7JswYa83HH66/Gx7iURlhqhiQJqGEkyw1Fxgt2KRNpPA864/YsFug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8pdV9qvlbAiORtGUTiw5QuOil4FE0L8XnAGhSDOEK8=;
 b=TKYgJBygJlgV69BKH0Ivd7N7pRDAeGWrtqY3mZwQrqIvj4LY+X1hIHVDlStnLSWt2aExrMdiZDrCzoSp4EZf212mdfL/MxjdBFcKRQ5FAlVGIgX/jFyO6OVwA0Sc/Fp6n7hyDjlqYhO9pbAxDnYvAJz0jTLIyhC8uXf0eF9ZhaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB9048.namprd12.prod.outlook.com (2603:10b6:208:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.23; Fri, 7 Mar
 2025 20:29:02 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 20:29:02 +0000
Message-ID: <947722ae-f099-d08b-0811-a9f967134640@amd.com>
Date: Fri, 7 Mar 2025 14:28:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 4/8] crypto: ccp: Fix uapi definitions of PSP errors
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 Alexey Kardashevskiy <aik@amd.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 John Allen <john.allen@amd.com>, "David S. Miller" <davem@davemloft.net>,
 Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, stable@vger.kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>
References: <20241112232253.3379178-1-dionnaglaze@google.com>
 <20241112232253.3379178-5-dionnaglaze@google.com>
 <d6ad4239-eb8a-9618-5be4-226dcf3e946c@amd.com>
 <d72dbe54-2d50-9859-7004-03daf419be86@amd.com>
 <20250220164745.GGZ7dcsXRG2hFOphRz@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250220164745.GGZ7dcsXRG2hFOphRz@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0111.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB9048:EE_
X-MS-Office365-Filtering-Correlation-Id: d6b36971-65e1-4ed6-d5a4-08dd5db6b2af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TXBSVlNyZTV3WUEvbldYblFTNGhzVXVQdEw3dFhKU1B6ajlsWmhUc0RIbG9U?=
 =?utf-8?B?VHV5Wi9WandQTElaYWdwanpNVjJEUUpNKzdiTDhaQysrTG43ZmwxUjFCYmhq?=
 =?utf-8?B?d1BpbXBvMWlOMXpTTWIxNmxZSytUa1NqcGFmbUc2b1JIYlV3NnJQajRrclRZ?=
 =?utf-8?B?RUVrdWhDZU44QWJvcXN2YVA4TXY1cjlQWWZlWFdISnpGc0oybEZjNVY0NHpp?=
 =?utf-8?B?VEZJZnhhWEI5RFJFUXkvYzNydy9TYUlNNjVRUHY3ZkUzNjVnVE1wN1NGOXE4?=
 =?utf-8?B?aFU5K3ZUNHB0VVVTZTQ1azRtNDlBN1Y0bzcvSHZLdUpvM01RRGJIMmpRUWR5?=
 =?utf-8?B?L24xaWM1d3hZQ09MZVRzaytXcnNRSkRVTHcyZjh4T0g1NjJQNFdZbW9KSmNF?=
 =?utf-8?B?NVhkRnVabVc2RFhwckhad0ZKYnU0TzhJUTVnTy91TlAxZ0hEVEl2M05TaURU?=
 =?utf-8?B?aEJhUVF2MlllT1Q4VkI0QkZOZHVJY0FueHUvY0FnZjhHejYwbDhaaEFjZ1lx?=
 =?utf-8?B?cVFQNC9Wc2VFNkJJVldkN2F5d2pRVHFmRCtpR215RlRpa25QYit6TlhOZ25J?=
 =?utf-8?B?Mld1MGJSRThaZ2ZpQ3BSQkE3cGVIajh0MlArdVNxYU8yZmtlcVJUU1U4WDBT?=
 =?utf-8?B?VnNqa0NjL25PVzV2elVwSE5KQ2lMeElNQ2wxeHFyK3JwRmU0U2NjZWx2dUFY?=
 =?utf-8?B?REFhK1RYczVPdUFsbVRkS3NzZ3ZjM1dacW9qSnQ3SGZtSjdQSUJzVVJvL21y?=
 =?utf-8?B?WHljaGZGU0ViTFlUd0JKNjQ3YXZoVkNLWkEzVzV3Qlh5SVB1TlZldERiVTE3?=
 =?utf-8?B?S2h1cmFNMTBKOXRJR0QrUTE1VTVjUkF4ODE0UVorMGxUZHc1aVlMcDZjcjFz?=
 =?utf-8?B?NngxbDk4SFo2RmF6ZVFuODNPMWpyUjJlOWpoUTRUMGtkSUFTVWtBQmFlV1di?=
 =?utf-8?B?ZWNaWnV3YXUyWmJoS3FyK3hiSmk1dG1jRXVlQy9YZ2FHTDdIM0R4a1JmaFA3?=
 =?utf-8?B?cklsN3VHQUJTcXFlbC9IL2J2Y2kwT0t5d2xsM2lMNkF0NzVLNHhNTHRVQ0tT?=
 =?utf-8?B?eThMTkNWQnRyVmp1eTVrenFXdlhhcitNTVpmV3pLanIyam16aFdSRTZXZTVG?=
 =?utf-8?B?ZWV6S2Jkek5BVjVPQUtIYWsxbzd6TGErYmFnTWxkbU5iMTA4a2tPanV2S2tR?=
 =?utf-8?B?Rlc2NWtETGx2WSt2S3BTVk4wczA4alFQdmlzV2Z3eHcwbHBVMi9oZFBzUjBN?=
 =?utf-8?B?RmhKR2dZQXAwUWlPWDRiWEZ1MU9wKyt5czdkQXBkWGZkd04rYWJhQmhNcmdF?=
 =?utf-8?B?UHFUcmhxRnRKR3doT3V5L1B4T3dwbUFkcnB0RFBFSm1MS3JvMzV6aTRua1dt?=
 =?utf-8?B?eERnMnlQVTVvMW9sVW5VWW9NMHRzelNRYys3MHNsY0tLLzVIdXkwN0lNZFNI?=
 =?utf-8?B?eW5lQ0tUalRieHN6TjRPdDk0NlpxWkpOcUNNeEN6Rm1OWSsxU1Q3VHRtRGVk?=
 =?utf-8?B?emU0QzJwR0ZpMVBPOERRbnBvaHpGUCtQQ1IyVW9zdGNYOWNacUhtazU5MWo3?=
 =?utf-8?B?eTV0VGwxZ0ZYU0pqcWwydHRjTEtnMTE1ZlU2RHpTUXYvbXVSUVBEUkZ6Rk5W?=
 =?utf-8?B?WXBCQzZjQWtlQ2pSMEJvcU5EUmVjZTJ4YVBIOFNvUnZJcTFMOTE5OTBMVkpv?=
 =?utf-8?B?T2o1Q3JSMTltcm1aL3hzMk1BZmxILzdMUHhBcSsvKy84dXFldEVlaUxySTdU?=
 =?utf-8?B?aTJMTmNaUXp2YWdWUUt0RUN1TldJUXFPbnY4dlU5MjlLdWI1WEdxY0dDdVBr?=
 =?utf-8?B?VXdxa2VVRnkxMzl2UGtvUlQ3dmFXZTdTOEtTV2lQWC9hOWJIajFoY2dpRENX?=
 =?utf-8?Q?RoAvfUk4XVcWo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3BTVWhOUU5iSGpjZUtqOGJTaWZZVkVxSkkrUWJXQTFra3duaitMQ1NhUHh2?=
 =?utf-8?B?V2Q1V1ZvblFHVUJhQTRRSVQ1WmRaaFYzL2E3aTdjd2RMVW51dWhSQkZEbDhx?=
 =?utf-8?B?ZjVXUVRoelNLR3YzWnBYYUZ4QnhEKzVyYVRjcnFsNWVLWlp5OENWK0xKWDJu?=
 =?utf-8?B?Z21sTGtXS2w1NmRQT294MWJyVTd1SkxaYy9MMVVrOEpNQTJCWVE4N3d0ZnRI?=
 =?utf-8?B?SEp5dDFqdWUveFNGU2JKYXVudlFydm5UZGJLSTFmN1BybzdLQW1PbUNXaWF6?=
 =?utf-8?B?c3N0eWptWng4TTZyWERnaCtvUjNxR2RHZXNQSWxjNWZta2FITjJHVm1GRnRM?=
 =?utf-8?B?TWNOZGU1Z01qRElsdG5hRWhDSWMrUHZ0ZFJkbjRZdHpKY3V0b1R3NmgxcXhk?=
 =?utf-8?B?QjZNMjIrajRFcUF4RXhvdFVOcUV5RzlFb2dmREd6Z0EyNDFRZDJ2MS91a1dH?=
 =?utf-8?B?SE1hK0ZSV2dib0pHemZKWUI4MmJ3RzJXNXBxVW40Qld4TndZYlFnRmRNMjM0?=
 =?utf-8?B?b3VybnFzRElXNmUyYlFaaTFTNmMzRStqVlFQUjZ5YWtOS0Y3Rk1CYnRVeWt4?=
 =?utf-8?B?R1RIQy9TQ2xUV1VYNGxEK3BqUC9yOE9aTUVSa3J6eVR3MkxXVXVSQk0yY2tE?=
 =?utf-8?B?M2JsQ2VhOW01LzBpVUhPZis2Yk50c0NJN1ZXSnkyb0RpQ2JZcXVzbWl3dFFB?=
 =?utf-8?B?Uk94L2xIaHZLQWdsaFR0aXBiVkJNOE5JVHlvZEUzRFB5QlBLMkdJMWdrZ2tP?=
 =?utf-8?B?dzVSUGoxa3hJUTVHeDQyNlgwb2RTTG5tRzJvekNMc29ubW5GSWlyT0RNWnNM?=
 =?utf-8?B?akQ5SDFrNjhoV3JLTzF3bjNQUUQ3VDM5WSt0cldUcFdCZDZMcjBhVFdrT1Vm?=
 =?utf-8?B?eGlXRzNnR0lmdE42UEJ6SUE1d3JXQ0JkRFRYM09lOUdVWEZac1pEYktFMTJI?=
 =?utf-8?B?Mm5JdzVmWUFwR3k5Z3p4Q3libXhuRXAxelh3TlV0WW4yRnpPMWpmNnlPd1dV?=
 =?utf-8?B?czhhdmNOWXhrUHFScGFWb2JzRG5PL3lGWGFzTEtmZFVBdTVBdUlKR1ViU1Bu?=
 =?utf-8?B?TDhMalZad29zQ01TLytFdmlqaENJVDRhQWpjMEJ3eWVRV1VqSnZhdEdVNmJw?=
 =?utf-8?B?T2NSM3l4RVpjbStlT2p4VS9jczFRcEo3cktLUDNpOXRnWWVPTDJpVWZSd3BY?=
 =?utf-8?B?RFV5Ym5CSWZPaG43N0ZpVTU0MWhSditoMkVUTTE1dWptWUlnV3ZveW44U1Iw?=
 =?utf-8?B?bTVkOVdPY0ZDMlRDWU9EMnFKM294OFJ3WStmZlhmYXU4RVk1SFVTejROOWdO?=
 =?utf-8?B?VmE1RDNXenNlUkdmenVyY1B4WUNvL2NHQmwrVHpjM1p4Yjg5SHZZUTNtVENP?=
 =?utf-8?B?bXZ2dnczNDJUUHNjNDF0SDk2ekZMcUMxcEVaT2xZbTFUSkc0ZDBKU3lLQXBx?=
 =?utf-8?B?MmpDaHZiblhIOGdHR3llTFBpR1FiM3pPeTViWnVhVHNYZE1xdUxHU1gxK3Z0?=
 =?utf-8?B?b2lUTFU0YUJnVHZQb1htdG11aWFxSWNXNGdLVnhvTlFNNkdPM0h5cVVJUFJj?=
 =?utf-8?B?ajBHU3ZrVlVNT09JNkdvMjRnWG1vTlBJSHZFU0pDM3h2V1FZaVEzYWFMLzNT?=
 =?utf-8?B?Q3Fma3VIa3dtUFcvSFJJTHlHamdtNXE1eDlhVDQzUTkzeGZQMThVbFVFZzla?=
 =?utf-8?B?azRZNTIrM3BsV0JTTjFjTUNRc0tGRWN6dURDaUdZOHhHVWVRbU14eEJnU3Fr?=
 =?utf-8?B?L0I1Z21GREliSXBZR2R1anFCeEN3Q3BORWdJQUxrcWo0MWhmd2JpYUtjM3FG?=
 =?utf-8?B?REhTMnNWWVhhL0xLbTVKQUM4Vkp4U3lvMUUyd0FkNUpCOEZqTnV6M3hPcms1?=
 =?utf-8?B?Tm5FaDBMa2IydFFCckFCanNRY0VmV2dTYkkzbk15Rk5IUzl5djlNTDhVR2JT?=
 =?utf-8?B?bW9Va2xvenNUcGd5NHVDdmwweDZqa2tVbzVKQjNJZ2x6bGJTSWdMTTRLVnpj?=
 =?utf-8?B?U3E3WU52NDlWRkdiVm1KSE1Ua1BQYVJWcFkybFdidGhMS3VCcjFZZ3BySm05?=
 =?utf-8?B?ZStJeFI2WW5CdTEwTitpRWkxVSs4NEZCV1Q4TklSRTUwaTZRWTZySG43VEpZ?=
 =?utf-8?Q?cIxyCaz+4yURZi1deeg92oe+Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b36971-65e1-4ed6-d5a4-08dd5db6b2af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 20:29:02.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wjV1eFj7Kyd/7iFBw38vdSUpQqkcNIGj5iaiBOKGxmTddbR1WU9RZBbvlIbbCE8yGmuYNglKs5YY3osPtqbZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9048

On 2/20/25 10:47, Borislav Petkov wrote:
> On Thu, Feb 20, 2025 at 10:34:51AM -0600, Tom Lendacky wrote:
>> @Boris or @Herbert, can we pick up this fix separate from this series?
>> It can probably go through either the tip tree or crypto tree.
> 
> This usually goes through the crypto tree. Unless Herbert really wants me to
> pick it up...

Herbert, any concerns picking up this patch?

Thanks,
Tom

> 
