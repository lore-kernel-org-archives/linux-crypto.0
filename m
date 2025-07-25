Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9785F2B9A4;
	Fri, 25 Jul 2025 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458400; cv=fail; b=kj8pIc6K0J2A7rCZwj/x62kPBBDejfjDsRupEWeYwNr07v4lKMThCQXvkCXFZJMlJLVopDkhgTPrk7oBwIVR3gIRvhGpvTwLt2a4xP5LEW8an4TykDRdiNetYUlEG/9vgimajfLocuCP/v77iRyehUj8ryDHHp53fklCGawGceo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458400; c=relaxed/simple;
	bh=b5ymEhLlwvUaaJU0Ij9/fRRDm+axIhfeWaPCPbdI4Wg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GmUcqrNjKc7lg8o7G/e2Q3/j8VdI2NrkrdnXirXxjEdGC5qdodZoOattxCAfM2vHsmMNntnD6myTzxpUIVB2tpc7Tp0N9uBxErOmjEGI4utbymObD8pO7qOTxEoTY91Ch8SpsLu440yp7FXsLOn3u4JU3ntN9pga61Qv+xqCf90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cqObKlIK; arc=fail smtp.client-ip=40.107.220.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cqObKlIK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LyPjtLJd5MU4yDPVJNC48Ypzb9J3WnPDFjfFvuhWNwkGjX1BTjSnMfi0fje11JQpEoASAfTwPfs1RBJ/3R7VtMXKRxbQayaxaJFjhynxauUUBzDkDU4gntQdkCjruvmB5C73oFROPPCmfcwXZlYRnLNQBqwqgv0Gem0+BvHgzzdKuZQuCKGA/P0KQ2OByv6XCvMEvHjreesyUltHmB4aikZMBbgWIygolaoANs4pFD7/wAYYu4V3+jBbOlxUbCjHR9n+iS1Mhw8aoetO859yZs6rcBo0G5dA3vbZhmXxi9+dqkNbMyCCRo+NHQgzqpe4zkrJYDIhthvqpbwBshtPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcU5lnBnsvWUjpxzJ96nuW8pol3OcqekkNsvR73U3X0=;
 b=Wtkep5fPNPsgaH8rG7UIYKrKWfYcVhqemGTiT28EPqGnEjkjy5Mu7HU9c/T97rwsRxI/Rl7qePypsZ1/gZgvs5rFC5adZxCZl5uHiECpisJjSDx0TNQUKxRL0a5uhEbccCOPWoEPi3B9oU3/9nOsBrSrshitQzs3C42cRXLH5oQG1Q4pnWV+jB8S949qMoscpQik10is22Gyy0vKkSbWE2JvvRHrcyqUMv52A/Ju+khJdppST3x1AR8baJYXHjw25BIQW4NMjjBpChmu+7oNec3rW5nShn/P2kbRthtBVXAgXHtEpJ0qDFGjkhEkBWb0dMvTcYriNAAhMyt+IUuXGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcU5lnBnsvWUjpxzJ96nuW8pol3OcqekkNsvR73U3X0=;
 b=cqObKlIK1WNygeOY4o6+GmA+7VpAfxgfVZDzMIDCOXxDQua77G4XoYGa0/53Y1suoDil9RJIGC5hnGhiXTK/9Qq2BbrS9dAIULXtvfzkFnwipFetv/w9Yzx7ekGqzsg1dkKkSWxhFdEvl1mBekGPlFOi3Ff0jBjRpwcVWBlWNDQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8893.namprd12.prod.outlook.com (2603:10b6:208:484::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 15:46:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 15:46:34 +0000
Message-ID: <211b5ace-f23f-b7eb-83e3-90b0374d6286@amd.com>
Date: Fri, 25 Jul 2025 10:46:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] crypto: ccp - Add new API for extending HV_Fixed
 Pages
Content-Language: en-US
To: "Kalra, Ashish" <ashish.kalra@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1753389962.git.ashish.kalra@amd.com>
 <a5dfa1b5e73286c2d7a2d38422577aff9de48226.1753389962.git.ashish.kalra@amd.com>
 <ff83d1e4-5fbd-360a-22ea-10efd71ff2d9@amd.com>
 <ed5b4ee0-3827-4d9c-81eb-99f3ea219c93@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ed5b4ee0-3827-4d9c-81eb-99f3ea219c93@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0693.namprd03.prod.outlook.com
 (2603:10b6:408:ef::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8893:EE_
X-MS-Office365-Filtering-Correlation-Id: 075d395e-a745-4793-72f2-08ddcb926e9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2xaYWw0Vk1OWE1MTnBaN0cwb3lCY1FjRTNDOUxuT0tWY1c4MEYyc2RoZFhy?=
 =?utf-8?B?WnlWYTJRdXBBOGdDR1RNd2pjNCtZR1EzU0RScW5CQVRtKzdySXFkZ1BGQjN2?=
 =?utf-8?B?TWRKODhBZ3pwd2d5T1hFNU5EcDkwOE1SbzZOODdJaEt2Wlg4Zm5VQU53czFz?=
 =?utf-8?B?am1QMWtOQjFvQnVzV2RGamZiRnNQVXd5NGxxVXUzNUJNZzEvekNYOFJuOVVr?=
 =?utf-8?B?U0FLeVZ5ZWE5U0djYUUwSGc1YTg1SE8zMWdOQURTdXJodmUvOWhYeDJTYi94?=
 =?utf-8?B?dFVDWkxKeEUrd0hKRGVEekk1TVQxMjBNWlBqc3ZKRTZ0UU9xWnl2ZSt6MUNw?=
 =?utf-8?B?MXFOTUVlY3dBZVRCNm9RMmNLV0VUTWJRTWxpTDg4SzIyQ2ZTcUhicGJkampX?=
 =?utf-8?B?ZUhQWEphTWFuaUxydjJ0TzU4ZGxkenliQVZ4aWFrUW5lL3NNYStNYlBVWlA3?=
 =?utf-8?B?RHV2UWtQVm5aM1prSzBDWHh1b2c0QXJUcGNJYmdDMGtCVzhIb1VLdlpRU0FZ?=
 =?utf-8?B?bXA3QVV3aEgxU2p3SkFtQUYwRlE5aDVaR1V1bEVUK21mb2NYUjgrR3kwU1Jt?=
 =?utf-8?B?M0RNZ0J1RnNiYXRhU3RpK0o2b1hQMzh0a2t3QnVUSHJjcjVQUkU2bEJhM3Bl?=
 =?utf-8?B?eGZVTU5MRG1USFBSQ0hJYk9ES0g3NzkyWFBQczJtZVNXQ3BsWStwZHk5R3pS?=
 =?utf-8?B?M09BTVRSK0EwWEoydE1XVkRIdlFpYmhMUUhEWDNqaSszMEtDNzVyMGgrWGVU?=
 =?utf-8?B?dmRoeU9ZTWFrbHAzZ1N1di9TNGVuN0hDZ1BLQTlSNXpMdXoxQVpRZ3lmaFJi?=
 =?utf-8?B?ejFmSnUyU0ZIcisvRDcrNENGd3grYUJhaFIvRFBtRjdhVFN6ejZxb0xZL1hL?=
 =?utf-8?B?bC8vZlhaQlhyaUwwUjJ6dEdFZFgwdlR1RVMybnJEMnV4UDYvSk9ja3FTWVk2?=
 =?utf-8?B?b2Y2SGJjcWN0S3o1clQwRlZvRlVKQ21WdkhqRmVnek0vcCtEK2NXWGo1VTN5?=
 =?utf-8?B?cktOeVE3eFArNXhLaytzU0JDVGlhRGJwN1NYYVNnMkZPd3loWUl1NEkvRDNX?=
 =?utf-8?B?dkRKRDNOa2xPVW9DL3d4cnNsYVk2ZGJYRW0zZTJIb2FyV0JublZDSUpGUVpm?=
 =?utf-8?B?TlpnSFovWG0yRTRGamgxTU1pRWFFY1NRWnVab0tkSGRocnpOMlcwZk5BZjRo?=
 =?utf-8?B?eWtneTEwajA3WnVNRHFnYWU4emVmV3lva0w4NW03RzBwendrMi9KTWRmeVVs?=
 =?utf-8?B?d0V5S0U1QjJ3UXhwV2NGWGNQaW5Sai9sOGVmMTlXSmp1aFVOejBYSGlFeGt1?=
 =?utf-8?B?MlVObDRTcVFqdVIwWHNwVzhQRTRPemtERmNDVWxMSE5aeEZqUkY0eGR0djFt?=
 =?utf-8?B?eVRDSkFPd2IvZndhMDkyZGxFbTVRaHhPdVQ0Z0tHdUw1UFdxbGg3NTdKWEZ2?=
 =?utf-8?B?OUlCYWRMazRlT2o3VjRxT09IZEFSVE1Od2RaUm0vNlFjQ2NyVkU3My9QMFBJ?=
 =?utf-8?B?YWxyUzA4cVpreXFwdS9PMWo3TDFGbXBUN3VramNDMC9ubmR5WmtBMi8wUkR0?=
 =?utf-8?B?RVJVSWViZXRET1dnSEZvSFZyYzM5NjFpUHpER2k5d3F5QjdVWDBlUm9tZlJR?=
 =?utf-8?B?SDc3dUV4dXl3bEEvUnNrczZwWlg1NzV0cXJIRUxYU1diN2lxYSs4N2NLV3gv?=
 =?utf-8?B?czBrVGNUQXNjVTJxSTZGOGxYS0h6OFRlb0plMTRBTkxVUUNmbDZnelZEZEJ4?=
 =?utf-8?B?ajBLMFlkeUk0QlJ4TEpYY2lUMjhMMEpjci80ZnA0QTVZUFpNQVBRQk1rTVBT?=
 =?utf-8?B?VzJEaXd2bzhBcGZXOUNQcFZVeDRWaUU5bzBUN3Roci8xOFU1TkJsQ1lWbkhS?=
 =?utf-8?B?RkNQOFR5d1hRcXNWbDZla1oxbW1TT1VGclExQlo5TFlEYk5tcU9BYmZGTDBI?=
 =?utf-8?Q?MdPKjyzuD8M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1RubFZXMExsZ3JKN2g4dnIyN0diRnFvNUdGNU82TGFvTnYyYy9ySmtoNkps?=
 =?utf-8?B?WEsvU0huSGQvdUF6cWVJZE8rM3prbzdRMWNrcGprZWNHQ3VRTjlzVldBZHow?=
 =?utf-8?B?VEJJb2VLdmtWdDU1UE4xQWRiMGdDL1Z1YlFNTjlyQ0dlUEpvMndOVituOUVv?=
 =?utf-8?B?UWFnOFlPSUhLb3NwcnRLMGZsVndOZ1lkbWlGOFNBcDNvWVkxMERuQjRSYUw1?=
 =?utf-8?B?RFNGK3haNWtKb3RIaXVLanBFbVdJdnJCaEx0UURsOTB6M1FzcnNyNGlCYm1S?=
 =?utf-8?B?aXE3bDJxTGhzUkZBNkN2cU5jUXprUkNTaTVNTjdYL0VxM0JmTTd3M0dmZ2xW?=
 =?utf-8?B?cE9nbTRXbnVXYjNhMmNyK0JmcDZaWUljeXBMTHFtUzNURnhQalpkM3p5Nk5q?=
 =?utf-8?B?WnFKckFtdCtuU0Roandxd0x0U3hSNnhKK1RUNzloQytzVk5GZ01aT2F6dnFy?=
 =?utf-8?B?OFBiYVNyWktWcXlyRTZTVTFtQ0tJOW9XS1hjamJ1Zit6TmRFNmVMWG9rL2xi?=
 =?utf-8?B?RG5sbUtPOVRrUWxpVEdnQUJNZ3poUGlQd3JhRjQvZjNVYWFEOXprT2g2Yy9z?=
 =?utf-8?B?MkpjdE1yMlZDeGd6U1c3bld1c1NaUHlRTEZqUWxtYURvVmkxeWo3emZqR2pN?=
 =?utf-8?B?WDllb3d6SlNlcjRKN1NTSEU0bzNLN3lIa3A0dld1dlk0ai9iZzJUN1loS0Rh?=
 =?utf-8?B?c3JMN3pJZHlBK2svK3NJdy9XRUoyZUN6MHI0TDBjQ3A5SXFYNXBLQlRDejdt?=
 =?utf-8?B?Z1NmMTBBbWFsM0RzZ2JSUndBb0V1WUYzckJlQU5URm45Y1N1MGxPcVhGOXRD?=
 =?utf-8?B?Q2k1d2Q0YTJHaDRIbXdldk4wQ1QxQWU3bjhQaytyb1pBR1hyQnQxYnBBNWdL?=
 =?utf-8?B?dnNQZlUxa2hvY3B5Vjc2NzU0ZEpwNzZxWGZESUJMMFhiMWRhOVVoUWdqS3FZ?=
 =?utf-8?B?L3FuV2szRTFvNnBjUEZuUUVYY1A5WWpyUi9MNWdjTzBLL2hEaFFBajE3TGNL?=
 =?utf-8?B?bmo1bXFjSklMQk9DK0Njam5wTGRZb1hxT1NZMllhdFA1NDhCd0dud1lRNGtl?=
 =?utf-8?B?ZjgzeG5qZklZWXd6Q2lMQUNtRFNPTXNNV3E2Zkh5VWkzdm1NYzRuS21FejBi?=
 =?utf-8?B?aFEvWTBVSUhqSjZUV0lQZ2s4ZksyRWdOdmdtRWJMR1VmZXNiMTlXVUpwU21L?=
 =?utf-8?B?Rkw2U2F4M1EwMmdnN1JIeE9sMjRuTlFCdEZZY2R2WUlyMmYvdFE2cUp6ZHFt?=
 =?utf-8?B?cGcvWm1ublhNTStrMFRQUzZ2QXZyZXQxV1hpR1hpbVd0WWZWTEQ4ejJ5YzRU?=
 =?utf-8?B?Yk1XakNIeFRJd2VNVFFRQUJhMnlMaFF1dXdoVHZacmQvcW4ybHpUcjVvMDN0?=
 =?utf-8?B?WWVtdlFweXdQbzMvOTYybTlLN0thYTV2MU9QNEw5ZW5sRmhWcjZjN2FXdFdB?=
 =?utf-8?B?Q0pNbTd2bERiQTB3WEZCQ3FFQUQ4UGk4d0tWeGRhU3JQWlovSmpoN3FacXVR?=
 =?utf-8?B?SGhYV2NtWkhwTm1sSDUreGRLM1JSa2NsVFJ2K2FLcTllVVhOTHIrUWIyKytE?=
 =?utf-8?B?T0h0ZVl1dUVna0RSejRsYm5YRldLZ2QwcVZHR3RpUWZISjlhbFFWREFJcXVq?=
 =?utf-8?B?N1hqNm1EbDB4WVduRndNc0w1eGVzc29IbGY2bEhoeldFN2NLOXp5dG1xMXgw?=
 =?utf-8?B?UmprcGppVHRWSzZwSzZhNzkvVmhhYm44cURNelRCMWpIbUQzZ3FaU0hQcjVw?=
 =?utf-8?B?cmRmVUZaYjJ5ZGhmUmp3Wkd5MWcvMjNBWWRaTG5scmZzZlNyMDFuZHd4N3lU?=
 =?utf-8?B?bXA2aVUvZ3JINGVrZ1Fnby9NNXZONVI5R1JnUVQxMS9oa1crcmF2alE5d2g3?=
 =?utf-8?B?YXoyeGdKVmVTcElLYnBuSXR2QlczbmZHeVlBQ096ekljMVFHM2ozL3FiVC93?=
 =?utf-8?B?emFweWM3T3JsaVYwSnlBc1lQRHhVS2hBZ3IwRk9TbllGNDB0UWRwZ0d6M1Jo?=
 =?utf-8?B?Ukx4OEI5eXhuejBQRThLNTkrTitrTEdGbjRra1RtL1BHOXhYUmtHQXFWamt3?=
 =?utf-8?B?bVRpV0lRNzQ4YTdkZm9jcldUQWUvc3JnM3BXTk5OU3JBa3AyMDFFTEhHeWcy?=
 =?utf-8?Q?dCRM5qN8zXMwX0B0xk/xZkK9+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075d395e-a745-4793-72f2-08ddcb926e9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 15:46:34.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2NF4Br06EF3aAC5hGZJCTvFRItbdj0XQu8ryJYlSsrGYgRvN7qfI8c19h+OB+KQb+6qXyvEMceEcIQu0/c9Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8893

On 7/25/25 10:16, Kalra, Ashish wrote:
> Hello Tom,
> 
> On 7/25/2025 9:28 AM, Tom Lendacky wrote:
>> On 7/24/25 16:14, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>

>>> +void snp_delete_hypervisor_fixed_pages_list(u64 paddr)
>>> +{
>>
>> Not sure you can have this...  Once a page is marked HV_FIXED it can't be
>> changed unless SNP (SNPEn bit in SYS_CFG MSR) is disabled, which doesn't
>> happen until reboot.
>>
>> So users of this interface will have to leak pages since they can't be
>> released back to the general allocation pool for chance they get used for
>> an SNP guest.
>>
>> So this API should probably be deleted.
>>
>> Or you change this to a driver HV_FIXED allocation/free setup where this
>> performs the allocation and adds the memory to the list and the free API
>> leaks the page.
>>
> 
> Again, as you mentioned above this API interface is restricted to use till SNP is initialized,
> so i think we can still have this (to handle cases where a sub-device init failure path
> needs to remove it's HV_Fixed page from the list). So probably i can have this with a
> check for SNP being already initialized and returning an error if it is, allowing the
> user to leak the page ? 

I'd prefer to have the decision to leak the page being done in a single
place. If this ends up being used by more than just SFS, then there's
another place that needs to know to do that.

>  

>>> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
>>> +		range->base = entry->base;
>>> +		range->page_count = entry->npages;
>>
>> Will there be an issue if the size is not 2MB aligned? I think a PSMASH
>> will be done, but something to test if you are going to allow any page
>> alignment and page count.
>>
> 
> I believe that SNP_INIT_EX can add HV_Fixed pages which are not 2MB size aligned.
> 
> Here is a sub list of HV_Fixed pages being passed to SNP_INIT_EX: 
> 
> [   25.940837] base 0x0, count 1
> [   25.940838] base 0xa0000, count 96
> [   25.940839] base 0x75b60000, count 75
> [   25.940839] base 0x75c60000, count 928
> [   25.940840] base 0x88965000, count 83
> [   25.940841] base 0x8a40c000, count 1
> [   25.940841] base 0x8e14d000, count 48187
> [   25.940842] base 0x99d88000, count 235
> [   25.940842] base 0x99e73000, count 1153
> [   25.940843] base 0x9a2f4000, count 12043
> [   25.940844] base 0x9fffa000, count 5
> [   25.940844] base 0xa0000000, count 65536
> [   25.940845] base 0xb4000000, count 1
> [   25.940845] base 0xb5080000, count 1
> [   25.940846] base 0xbe100000, count 1
> [   25.940847] base 0xbf000000, count 1
> [   25.940847] base 0xd0080000, count 1
> [   25.940848] base 0xd1100000, count 1
> [   25.940848] base 0xec400000, count 1

Right, but those are resource-based items that I think result in 4K direct
map entries around them being 4K. I just want you to verify that a 2M
mapping will be split automatically by the SNP code (which I believe it
will, but we should verify).

Thanks,
Tom

> ...
