Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AEF61FFE;
	Thu, 24 Jul 2025 16:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753374192; cv=fail; b=nBSPfKV9lImmT8s67NLwodv+ZP6jxbD7aBAbMU3cXRP4hbycPuQbibDaQE3HwHVZzrtRzTU7Nn4XndxFabZuRs6WkVBJreV5CZ7zeBboK3at1AO50XJGw3UXOBwkD11cx2Nw+F++w9i3U7NAmwWtGW7LAIBelLBM9Rc1e2pl5bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753374192; c=relaxed/simple;
	bh=dCBku5i+NDqy6RuCdSXFGImER60MwE/YP+hEtqOm6fo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mWnmxgLdNljOxcug3ipnmrSyNM2NPYXxTr2oLK57BN3GOFbIG1PRLdXkaBKVLxUcV4Xcx/0DuK+o5Y/5dOaDPIyO1vv9wBxXNWWC8rbuThpHBpqg2vMiCiCZGTOOrA653xnz198R16NdU89witnJ1OAADt+UQXnvcxsKRv95lZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DjDbSe7l; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DjDbSe7l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qV9ZmIC3WfZ4yiP7JhRhjMB93/RYbcQFOvZmbI+e2tuo0nKibCjPjZ0VTVtIrOpvNtAxBScmoR9kg916LJkaZmQ9FCLJxZStlzKN3tjdTnS1cEowXtUttN7BAIVi74pxJCQqI54sVSUmqZbv2Zd5YlugnDvF6RK1e21d3ShQFZOc3RrkpIqlPqbA9ZJGPtJ6yz12iB1GUJAZ71+IaH2oQSYCJ1nnkX5YXstzlE3vwRCbJi3hBLJ3UW3EyEdQtILq360gfa35T2fJVr3b2phvt33e3Yv/5Wn4vlpgnQYcg2zy6iWqHZWWWF6RA98uLHPjwzrL8I3CwtmGW3cWTVp5hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5kEq9FNwPGsszyOZVy06Me6ONqyB1vZnA6TOJrvxTo=;
 b=mXInx3WSiUd558K5wYDYKwKLFeUjb/pacP/2JhDcEUKXjF5HAWC8Tf3M9AoVD16+VKKQIO5lwqepOUTY43QQm4A772KaGkFQrNPS8Yqas8rHiy+J1vhN7bC4d03hKzqmQxJj0vRN57rLQhR1yWqzugoqJJFYM0U3sK2fRaa2cegmj0IOz+HMBex91i8Ku8hxr88+Jsf0/FYfr4HQWttO8X7D0gkoFVODWs47lllVsS3R82w1mGk0kf9jeXRRpzs6+qGWcVf9T/gzInBdOsH+qPPhq9nXzGHysiWdL4MuK0RvZle0wUTufsrvf2dpfB3r8znXH0YDeBbdAlguwpBktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5kEq9FNwPGsszyOZVy06Me6ONqyB1vZnA6TOJrvxTo=;
 b=DjDbSe7lrnnwAfdM5uXIkmLwPgPGkWPCvNfgtSrYae9wHCOUHPhD4VVPl8uqHEpBhfvdqUbjtttuB3/a2ausUDmXMaasKdZRyb90riQycmFWenxTawoXyPAMBvpSc17FqWWmZiyV9K3BZSAuP/gxXP0y6GuiVFRhrrgqnJsmd7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by CY8PR12MB7217.namprd12.prod.outlook.com (2603:10b6:930:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Thu, 24 Jul
 2025 16:23:08 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.8922.037; Thu, 24 Jul 2025
 16:23:07 +0000
Message-ID: <d257eaab-88f1-4091-b0cf-bf508d3e0e36@amd.com>
Date: Thu, 24 Jul 2025 11:23:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] crypto: ccp - Add the SNP_VERIFY_MITIGATION command
To: Sean Christopherson <seanjc@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, bp@alien8.de, michael.roth@amd.com,
 aik@amd.com, pbonzini@redhat.com
References: <20250630202319.56331-1-prsampat@amd.com>
 <20250630202319.56331-2-prsampat@amd.com> <aG0jxWk1eor1A_Gd@google.com>
 <a5dbf066-a999-42d4-8d0f-6dae66ef0b98@amd.com> <aHBCosztx8QWC4G0@google.com>
 <c502a550-3856-4c21-8546-b4b1abbd0abf@amd.com> <aHppQWM5TKPD7JpD@google.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <aHppQWM5TKPD7JpD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0080.namprd04.prod.outlook.com
 (2603:10b6:805:f2::21) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: 363023d2-fde0-4ae1-9a13-08ddcace5f68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ym5sdDYzd3dvRWUvTjlyeXR6eDdWaDdVeWZyR0lMNlBWZnVZdFh5K2RlSi9I?=
 =?utf-8?B?Ny9oTG9pZ3RiaWU3VkNCV1BvaUQzQ3BZdU1Zd01YVTNTOUU5OXJQT0V5YnZ4?=
 =?utf-8?B?dUdMc1d0YTNHc1cxeThwUjU5SzJBUTI2SzhCSU1maXlHZlBpUFdHYU55L1Ew?=
 =?utf-8?B?aFRKUnhmYlNwQTJZblgxWDdrdmFUbTZlY1plRzZSTzhCSFo4aStyWWsySVE0?=
 =?utf-8?B?TkRwMTRISVM5dkhKaVJrZnVYTEtUZlNYQlF1YllHL2prY1NMQjBDc1ZZWnho?=
 =?utf-8?B?dHlYeDlYMkk1VHV3S0FTVDlYMUNmTWNSeWIyRWE1VGVMRFBKNzZHYWNSUGU2?=
 =?utf-8?B?UW1NdWNOTGMyYk5vekd5Zmc5Q011bnV3Y1BBWDB6WHNyU0pOcUZZY3FCVFpt?=
 =?utf-8?B?czI4akVwbWg3Qmt4QWVBTTAxVHVBdFBpdTFRRGhwajNBdC9qckxoRXBZWTRo?=
 =?utf-8?B?cjRxY1JmQ0tvdmZLRHdvY3ExQ045eHlXMnBxS3FSQUZlaFRNTWpTY3J3WTI0?=
 =?utf-8?B?VGpiRGNYQ1NWK1FJcjhtR1NJcE0yWkJMWEZqdU02eVRmRnZ5RE9rdHhFVUsv?=
 =?utf-8?B?WUFXQnpLQVMwYUhXTHVodGtTVTh1N0N5OVpRUkgxeFA1TFVwZXd3VU5lRTE3?=
 =?utf-8?B?SzdSMFRxdkY5aGUyZklMeU1sSlNNeEV0ckFrd2lEUlcwV3lidnpwalhobHM4?=
 =?utf-8?B?a0RlY2NRNVhMWlRzK053TFQ0b01NTEp4cml6cHJFUUNNRWlRaCtzbTJjMXNw?=
 =?utf-8?B?V2s2ZFYrVStzWFY3bzljbjFFOTdidzlhNURLRXpNY3FuMlBLZDIxOFMvRkNC?=
 =?utf-8?B?am5XUEZzOG9QdFFvUjVUakFVeGMzMFQxek9XdUZ3aDVLeHVUa1UyUHc4cW9G?=
 =?utf-8?B?T0lLK2paNnFJZG1NTS91TEpEYk5PNTVTTmZOR0d5a283RnRSNUd6bThSSFhz?=
 =?utf-8?B?c3BjMUhnVld0ZzloeVpjdkZQbDBOcTNSWk54ano4elprU2JhcldLeFNYeml1?=
 =?utf-8?B?MFlvbUVPT042NnRwTFVKaDRNQzluRTQ2YThBdUVua0ZWY0FDelc3aEpqcjNt?=
 =?utf-8?B?bWVGOXJ6UUJQUWdqOHlaUXBmdEpJM2Fkdnl2dlhHTlRkTFp1a0pXcjNPVGV0?=
 =?utf-8?B?U2tlN1lIZGU5VlI5MlFaSzJRd3NLeXU0eFZNWFBXc0tseFowMVVpV2JnRVRV?=
 =?utf-8?B?aElEQy9KaGM1MlF3RG9qbTFQOXE4T0Q0em5RS21OckJRc3JuTlUvQndlQ2Rt?=
 =?utf-8?B?YktpcTNoRm9zSUVLZXIvYk5JVWtqQ2xORHF0WjZ2dDRhckFNQU1JV3MrK2Jn?=
 =?utf-8?B?SFdyeTVjYUljSG45SVZmdUdyNi95ZGdBeGVRaEUrOGwySVlLaVg5ZlVFc1Zz?=
 =?utf-8?B?YUNZby9JTmRkSlJia2lwNWFOSUJVeStPckU5Ym5LNFR1Z0pzL3JVNFVTWW9z?=
 =?utf-8?B?eWFFKzJieEtpZmpLMFdPWWh6VlJFUk9lMzI2aWRHMnRKTEp1QW9RYTZ0MGdF?=
 =?utf-8?B?RHZxZFVkUS8rWEVjWHdlN0kvampGeWpyV2VaakRtZ2ZubDJOL2tnc0htanpk?=
 =?utf-8?B?TS9VcFZNUGFGZStxbzJ1MlRJYWVCdEZYaWVicmQzWE1IWGxsdnhTMDNqS2FT?=
 =?utf-8?B?TTZJalM2ejczTXlJMlZDL3VJcEdDSElRd2hMczdKeWNoenErZ2Mwc29KSWF1?=
 =?utf-8?B?NllVS2dKTHJRYWd5NFZXTzFEcEpGSm42K2hicFNrY2JPNmNZcFhVS1l0N2hj?=
 =?utf-8?B?ODMybEZGamJSM0o3SXF0TDFQaVdweVZidE5Vd3VWMXg0dlRjTFhxWEhZU0Rs?=
 =?utf-8?B?Nk4yY1l5aE5QNWpocVptc2c2WWpqYkZKVitNNHR2dHd6VjdQMWZxNzRlTkhn?=
 =?utf-8?B?eTdkM21palg0QWFmQktIRWQvNWNjOThaMkVQaGJsREg3LzFVazRJZEd2SE8r?=
 =?utf-8?Q?viElceIRYUg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUJ5dThhZklLSTQ1TWZtNUhVU05EQ0pja25lYTV4WXgzaDBUUkdsUSszUGFJ?=
 =?utf-8?B?YnFWZlJiaUNzajZkK05mRjE4R0htV3I3NHJPeDFqemY2NXdTa0pMSGZyOGtM?=
 =?utf-8?B?UlhNWG5OWUt1eHRhdEpLRHlDRkppODhUSkdPRGJibXNMaWt5VHVUc2hZemht?=
 =?utf-8?B?LzRQOEw3L1hhVjNFTDh4T3k5YUlkbWpSMEdIVmg4OS8xUUVSMG5wUk1jMEpF?=
 =?utf-8?B?NU8yc3JyYnpyK3hPYUZ0b1dsQjBVV3lkM3NjQ1RtZFJsdTNubURrSGRHYWtn?=
 =?utf-8?B?WGUxMVRzUTA1MFI1UHg3SjlGaE8xWmZRa01xZGZtKzZ4bVo2blR4QU4vWG55?=
 =?utf-8?B?aXEwbG45UGY2Z1VQNHlkQ1dmSURCNldSdU9TZDZDUXpZNEZSOUlXcEdyb0xz?=
 =?utf-8?B?NllSZEdOalBEdHg2dHBac3pVZWhhS3RZOWh1WGxSRW10Y3Z2YXlORVZ2bncw?=
 =?utf-8?B?WXVkUWQreXo1Q1FWR0NReTNzTzZlWFdIWmJIcXdFU3JNVHFsN3VnclR1NmRP?=
 =?utf-8?B?ZWlqSEQ0d3NyOGpJM1Q1bXRsckZnOGlGT0JwNW12K3lWYytCSk1nQjAzam1o?=
 =?utf-8?B?VUUxdDBod2hXYzdzcUlWd3greHVFeks0SHZYeUZlZzB2a3Nic0RtbFlOQkRE?=
 =?utf-8?B?OVl0SXp6MzgvakFlUmFlNHRJQldqcnMzbjYvMnppb1BSUlB5eVZQMnB6bjJ4?=
 =?utf-8?B?c1JDLzdHSGNCYjdNb0lYNk0vdVlCSUtUV2YrUld0TlBHMU9hR2hEa2tHSFRL?=
 =?utf-8?B?OHZCYjNjWTJMb3NiZFROS1NJOEJXNXlaUkFZUitjR3dXcnZLRmpkVlJTQXht?=
 =?utf-8?B?QXRlK3BLbEZSSG5SZ0tYRzFUWmJacFRaUEN3ZUtQOGdITmVxUWN6SmhPa2RX?=
 =?utf-8?B?V2dUdEJ4QlRZTzZ3cWtsZjMxRUIrSlZBTUI4Mlh3M0RLaXpqckZCMzFRZWx3?=
 =?utf-8?B?SkM3MjZVd0U1Y0h5eFhJckJpc256dW9jZlRxdzFBNklHM0diNjNRRzBIbDNP?=
 =?utf-8?B?RisvajRrUGlnTC81WFcwMlA2ajlCWExHRXpCUTRhUFF6eVozNHMwOVZCNTZ6?=
 =?utf-8?B?SEtvcFA4OW5BYUJtTkZmUlY3OFNmZDdLRjYrMTJjdmhBbmxlZlVyaUV1S1Jk?=
 =?utf-8?B?bkVBVTdtT1pUaDI0d0xpT1k5bDVJLzBYbE9JR0pORkF4YnUvT2c1K05rWTRJ?=
 =?utf-8?B?L2JJV1JwaDlrVVFBRURTVGRHdXVIVjBCd3FVZFhhOUxOTVNqRVZYUHA0OEp0?=
 =?utf-8?B?TmRiMitIR1BqeUpJeTZ0ajcrVTRQamZzTFQ4RHViZWRSWDgxMDIvb1lQOFZX?=
 =?utf-8?B?eit5TTRoYkJpV3lCdCtDdXNFNkFCaUQ4Wm9CaHRKZlpiQmtkNWUzWjlLaVBm?=
 =?utf-8?B?RHR5cmgrVVFCNFdWWE1BWUxibUQxR2FVV1ZseEx5eTl3WnFnZGdOTG1jUUkv?=
 =?utf-8?B?L3dZdkNHcVBUU0N2OE1saFQ0d01nWkRlU0xEa0lEd2crTGl0aDZsWU1mWGVj?=
 =?utf-8?B?WnI3cmFTNG5BSWxLZGZOdk0yMy9FTVNQdWVZTWpxeFplZk1MMmdFVnB6MGF3?=
 =?utf-8?B?M1E4ZE0vd0VhaElRWEdlN0VVZWFtU2FSbzltdGZ1TlVHQSsvd1ZVVDBnNHlS?=
 =?utf-8?B?bUpPZDdQK2dGT2ZMQUhkYW5wZUh4RHZpb3RYbVROTytsb0xFeGN5dHorK245?=
 =?utf-8?B?WEhVTG9BT1VJRTNYWU96KzRXVXRzRXN3bGpRUEVTWEh1bFd1OE1KMHFRZUtN?=
 =?utf-8?B?TDA2eWc5dFk4OGlTeE9uRkJPUnlENkJKRmdVNDc5cGRLdlBlQXI1Rkp3ZXZM?=
 =?utf-8?B?M3FWSjBrVlhPM2xVUXIyNEdBck1qakJEbG8wQjU3ZVdGVjZYT0t1Skovc3o5?=
 =?utf-8?B?Z2RJb2FoVVhoeURnK3hlR1BOZkxjeVQyYU1JNzhHUktUdmVsT255Y0tQRlVN?=
 =?utf-8?B?ZXVrd2d1Z1RCcWh4K0pLZ3IrSjdhS3JzUjFwRmY1cENiK2Q3dG1uMkk5VUN0?=
 =?utf-8?B?QkhscWMySzd0bVdtcU4vbFFlV1phZzBVYU1ramNYcUZTenhVQU8zYUFuaWxM?=
 =?utf-8?B?a0NsTkVKNittT3RvZm83WjlzYi9aSVYxM2NRaTNyZjBKa3lSODVvYitrNzN5?=
 =?utf-8?Q?fpSlkQBBBg4vndfgo6y4vr5tB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 363023d2-fde0-4ae1-9a13-08ddcace5f68
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 16:23:07.2250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aw9lt+UCnAL8KnPpn8EuBYeEUckydMYawiub9+iPvSnm5kFzDNgmy+rCkpsnb+AJ2bVNzOJo6lFxsdJtMJWRig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217



On 7/18/25 10:33 AM, Sean Christopherson wrote:
> On Wed, Jul 16, 2025, Pratik R. Sampat wrote:
>>
>>
>> On 7/10/25 5:45 PM, Sean Christopherson wrote:
>>> On Wed, Jul 09, 2025, Pratik R. Sampat wrote:
>>>> Hi Sean,
>>>>
>>>> On 7/8/25 8:57 AM, Sean Christopherson wrote:
>>>>> On Mon, Jun 30, 2025, Pratik R. Sampat wrote:
>>>>>> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
>>>>>> can be used to query the status of currently supported vulnerability
>>>>>> mitigations and to initiate mitigations within the firmware.
>>>>>>
>>>>>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
>>>>>> more details.
>>>>>
>>>>> Nothing here explains why this needs to be exposed directly to userspace.
>>>>
>>>> The general idea is that not all mitigations may/can be applied
>>>> immediately, for ex: some mitigations may require all the guest to be
>>>> shutdown before they can be applied. So a host userspace interface to
>>>> query+apply mitigations can be useful for that coordination before
>>>> attempting to apply the mitigation.
>>>
>>> But why expose ioctls to effectively give userspace direct access to firmware?
>>> E.g. why not configure firmware mitigations via the kernel's upcoming
>>> Attack Vector Controls.
>>>
>>> https://lore.kernel.org/all/20250707183316.1349127-1-david.kaplan@amd.com
>>
>> Something like Attack Vector Controls may not work in our case, since
>> those are designed to protect the kernel from userspace and guests,
>> whereas SEV firmware mitigations are focused on protecting guests from
>> the hypervisor. Additionally, Attack Vector Controls are managed via
>> boot command-line parameters, but maybe we could potentially change
>> that by introducing RW interfaces for our case within
>> /sys/devices/system/cpu/vector_vulnerabilities (or what the final form
>> of this interface ends up being).
>>
>> Another option could be to expose this functionality in a subdirectory
>> under /sys/firmware/?
>>
>> However, with any of these approaches, we would still be giving
>> userspace the ability to access and alter the firmware, similar to
>> the interfaces that expose features such as Download Firmware EX
>> also allow, right?
> 
> Not all userspace is created equal, e.g. init_ex_path is a module param, and
> (un)loading modules requires CAP_SYS_MODULE.  The expected/desired use cases also
> matter, e.g. if there's no use case for toggling mitigations after initial setup,
> then the interface presented to userspace could likely be much different than if
> there's a "need" to make mitigations fully runtime configurable.

That’s certainly true.
I believe in our case, runtime configurability may be necessary when we support
live firmware updates. These updates can introduce new supported mitigations,
some of which may require guests to be shut down before they can be applied.

With the ioctl approach, we use the writable flag to check if we can apply
mitigations, rather than just reading those that are supported. Alternatively,
we could create a /sys/firmware/vulnerabilities/ directory containing a
read-only supported_mitigations file and a read-write verified_mitigations
interface.

Thanks!
Pratik


