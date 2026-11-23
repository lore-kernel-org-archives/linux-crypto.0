Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795449116;
	b=cT+H1waOAVxQnXrPm0Ilg4Hcfg0OmIKj+CCQ++UtSVBIN1Is9fB3ae0gn64HCBUC27eV
	 AKbskdJY7yg+/9IdlazJ58rmIT3oJ3g/Q+evluOUC39Pxa6rxHzJQG/V2Yz/37IDUPnbE
	 JGd8VgVUOkurOcgxiz+6usE66dxF07QyHRlpufj7Lri5LqLDWe7rBUhHVOT/W8ZhaLLGz
	 A3+OT0Nt9/NSM5Qxk8hVKb4PJS+1WCsyinzlMekPfMZJ8LysjDqNCKJLfhnMetxsN4uCe
	 nHMjqEAcR5asLCnEkyr2yIS/zHZWH5Kq6ovjE+FiIjKca7I+D8YHR96nwnW24AqYc6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795449116;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=heuJXbWk3kR04Ew+EGU+vTffzTc4jXMJQv4F3kPI71o=;
	b=qK1GL1ktsK4+RJIHByEAJESK63b3ydYeZCt4yaMtPzvTehYy6N+W7/ndg4WRj32bCJxX
	 BL+pgtvdLZiwnx9qhjef1P4Fpf66+EhYfzgHeFOZFGi2H1ods+IwoJqFgRd8Wj5pJN5X/
	 KsbizJk3gErzRnSaMY1KWmuCRC6k6yY1rLlwUYovsA5u0jeIcMYHKA+GWIOfKoKcJjRMD
	 3/SuLa/KG5dixMUd3zMdz51NaDcEt36AWR5+A9aWxLVUExtjZ9KZRx73AdSswNFtZx9p0
	 NhlFFybig+oVCKsQ/BH5MP8fUr9tuPnPPfwjA5Vh88lQMEKnS/MSVCsHF84xifcWtrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=WFOpklO6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47150606A335;
	Mon, 23 Nov 2026 15:51:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47150606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=WFOpklO6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/EYwpn1gXzhpvmMiB0l6ChufJatUcCxT88aBW9hXoRYD+Sp1OoeqJnYkylPAfg6+Hy2eXt8jTHiWSA0Gk9uPIPzSU/5HPxmT+hSA3DAO0zey2aAPYzBt7dlnoFkPzGLP+JVYZGMERU46iw8PGuPP5IloYPe+fc91NjDtIoPQAcqOVwLW1Sxkx5kLNuUQiE059P3K+vfNWzGZ3fP81w7qi6C4bCbl/gE1CURWucJ3gn3msXY6nslMTGAZYJciS6KM86jxgXYBJz0+cP6H7dkt+6CgcO9V1Dl+FY+ZsQsS4VQ0Zhc0suHvh4XswL8OYzuX3DIYAt1N+MgzuDapIZA7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=heuJXbWk3kR04Ew+EGU+vTffzTc4jXMJQv4F3kPI71o=;
 b=G8wnajMVIncipvOx+NHjBrGBYVzWmPmtlVfO4cB+XJeMkfc8FfDl5xx5XVrNW1rpg06P/hzAwr2akqzoVmSk+VdZzaz3kjKhCHzJm7rLSqO2efQCed3pkeSXlOHQLLNU8fxT2p41CUaGHftNJ5cRGRX8rp7B2ivQ9COC0iSdZJTRPj836AoS+8dwbtvM5/nwUmrPVi9tWKwy+TcxjJAnDv4Uhgtq8oIwdbLnMl1yYh5TCbatdj6XGh6+co/3jB28Exha2KXc3k/Dt2chYIsQLkpXac0wWRM3FL49kWl7u6nYeR0M3w/KD4O7vjgcqmrxwADFeoltDMD5por/o+qnpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=heuJXbWk3kR04Ew+EGU+vTffzTc4jXMJQv4F3kPI71o=;
 b=WFOpklO6Q8FeASZki7uqqFaTdc0jhsYlC/8xMiAs6OgNQcEpAbLYe5jgDtjdGAJ0BcodI5uO751hveEMT/xriEovO1YGUNwySu9LgneC6yHJcpyLF1lAToTqz1iFUSIrVfbR3fO+4pXoVAK44ncAsaAk0pbKeTm1bah7zWg23U4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SA0PR12MB7478.namprd12.prod.outlook.com (2603:10b6:806:24b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 15:51:52 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 15:51:51 +0000
Message-ID: <b221201a-2e8d-427c-addf-91bccf05249b@amd.com>
Date: Mon, 23 Nov 2026 09:51:49 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Require a writable file for SNP_COMMIT
To: shyckless@gmail.com, ashish.kalra@amd.com
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261118-ccp-sev-v1-1-76894536031f@gmail.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261118-ccp-sev-v1-1-76894536031f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:610:b2::22) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SA0PR12MB7478:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a1c334a-e28b-4cf8-ce03-08df4979b0bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|6133799003|22082099003|18002099003|3023799007|11063799006|56012099006|261028144727099003|261026121527099003|261102123227099003|261026140227099003|261022105027099003|261021121427099003|261009223027099003|261021123027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ix3P+043d/z7UQpLayNXDyTsg92+1Pu203MC92/BWzrVJGnvMu8fOQWOvLLfaF85NaaJVxsNy0P8/Aevn/x4KKDxFlfkcyjcuAuO71RpBY7cUQFbyJJrEvmo+9SZrhtG/zQfk7dT9kirL1W1yClOjQxyeZ+qKnm14CbxM1SovG4IbDjsZh1SGJ9b0qLcRSTg91kx9fHG9eMKsr02PBYTLI4V9IZkppp7421Lvc6Wm5vrmK27gbN/4a3JoHzemCGHpmjzAU+ZhqPJITqtaK8m1vnStsxQanL+l7tn07fvdeu/aRHKjwuIVLchKQXBQYS2ZN4upi/BEGKD9O8ENzWWTHs54m6TL58gUkmB69z5p0PCySFEvQ05ZMVE6VLzh8X2cSyEcYepHW7ErIi3IF1jIqVPBQsuSA7792xa+Hb7LPqH+UTIMW+oI01s9tZqjeGS07nBf/ZYkkL+3ObivqDX+d9Lf4KTwxJ9DUMQz6EwpXrpX71yBHy+44booCPUllfGNT0rxkFGumRPUp/FPz8tRl6w2mCH+WssEltqvVTrEKyv/DeBh65PkOnU4pb6MMeKmDZ22yQZ7lw0qf9Noe5l8RagTFzsmCfL4SvvZ4e7yzfwRkCo7kHbusiJQaWlEAegcLBkep/ie0AssSB/acmoaHPGVJdPiZdKZpK24rvUDug=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(3023799007)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261102123227099003)(261026140227099003)(261022105027099003)(261021121427099003)(261009223027099003)(261021123027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R25Bek1EY3NXNStwNVRUdmN5RVp2MXBqYVZ2WkwwQzVIZzhFTVNhRVk2WmZ2?=
 =?utf-8?B?RHQzYUxnM2RWUmRJWCtJZE0vSUJIVCtFMFdtUjcwZ2ljSTJrY3dNcnNIMnB4?=
 =?utf-8?B?emJjOVBhSStQYmhJazhWTUU0bFNmM1RIY0toKzg2MUIxV2g3bE9EOEJxR2po?=
 =?utf-8?B?WWcwcC9jdmZFR2lLcDJyNEVmUXJBWm43Q3lncHB2WFA0MkMrUFhXVnVGK1l3?=
 =?utf-8?B?ZmJlZ0VPVVRHOFU3Q0g0Rk5xQ1dXSjJjVGNRTFZ6NEt5MUdhdFI3RVFQQkFS?=
 =?utf-8?B?TG5HZWljZVI5MEhIckFBU1ZlL3h2RVU3NHFNK2k4ckZ1aUM0ejVicmp0QVFX?=
 =?utf-8?B?UW9MQzhUUTl3OStXdFNBWER6TERRU2tMdTA2YVFsTmVXNHh2MTJaMlExS3VL?=
 =?utf-8?B?UnhIcWhuc3A1NVhXamt3Y1VtUU9YYk5xUG1VWlMvWmtDZzRHVlIyZGhyenNU?=
 =?utf-8?B?dDlJeGN4c1daNmI5bWlyWSttVGJFUm1SYUlQSGNBVEEwOS9PM3NtdDJ2QWJm?=
 =?utf-8?B?MGVHZGtQNjdPbklpb3FwNjg3SHJaZEF6UWVtUDI5MFM4cEU0MWFtejFwUU9T?=
 =?utf-8?B?M2RpZS9GcndEYlRlTU9xcXVFemRHM1REM1huTjhTRjJTZGF6UXFJT0dZMndt?=
 =?utf-8?B?azJLTXpQRmhwdzdtWVNHcW0vQzhDVVNVTHg2aEVOL3lETnA2ZmZlSWFTR3dR?=
 =?utf-8?B?bU5tSXRVUERrTFNvSjEweU5RZzVhTnlWN2xmM1dqUHBkQTMvZGtBVWdvVXlk?=
 =?utf-8?B?akhFYzh3d1pvL00wVnRuR1RRODYrR2daY05uaEhpd2VUSHZYbVQxajhHMHVC?=
 =?utf-8?B?dE83bmdmMlE4Y3REUzQxRDlhdXBJMEZadU9pM1lOdEl1YUJpMU00M0Uramln?=
 =?utf-8?B?dEZueThoQ1hDb0EvRENyeXVLL3QySE9DSWZHd0dSYy9KeFN2ZDZUdGhaSklX?=
 =?utf-8?B?VjlUSWVITU1ucXh1bC9ZUzNtNUc4aFIzMUxNYVMvblVpa29kSm9rKzZWZWJD?=
 =?utf-8?B?SmI2VnIvVWZuL0F1emlHMFpGaVVEWXdKL1pzc1FaRndURTR2Q0FKWnhSWVBP?=
 =?utf-8?B?R2N3MEszbXBNa2l4OWQ5RTJUdFgyaFV6aDBnQ1lzOS92czRud3RXK25EclJj?=
 =?utf-8?B?YXFwTm1DeUdIODFqYThwSTBxSS9GdS9Idzd2djRwYkN6VzBkOW1Udk1hakdH?=
 =?utf-8?B?MXJ0SkV1dFVFT1FGMGNMYldnMXNWOWwwUDFLb1gyeWxzSE9nYlI4VzdXYUZG?=
 =?utf-8?B?WExCYmZtMEdsUFJ2SHcyckZ4cW03N0N5Um5uZzRHSlNCay9BdXlVaU44QUtS?=
 =?utf-8?B?ekVXbEVZUWlpd3Y4WVM4WVhXZXlwVzJJdFo3amhBeEU0NGdURkRnVGh6TmR0?=
 =?utf-8?B?dVZuNDR6WjJGSjBGZG42Y010cGlZcTBCQ0UxcGlDejZmY3o1clNLZ2xRTXRk?=
 =?utf-8?B?M0h3b1RRY3oyOVhiQ3MrMmtEamRNTVVwMUpiWUtudGRwUWoyQ1NRZEJhdDBM?=
 =?utf-8?B?OVZ1YnhySm5yTEV5S3QvYVZpWVFXY09CTzh2ZHJEL0lWb1pXZEJ2My9yQWJj?=
 =?utf-8?B?NGU1WGtYQU5NeHdOb2liSmdYMFo3UFY4QktlZkhkeG1xUG1JOUpUak1BSFcx?=
 =?utf-8?B?Rmc3TnpWUCtxdmE2Qm8vYXp0dWlhVmNKV3ZMRmsvb1lQSDBsc2RRajF1VlF6?=
 =?utf-8?B?YmRUYkxnMlNRbEIwZUhOYUVoNUlvcDVWRGcwaEY2M3B6NjdDTU4yRkNNdVVT?=
 =?utf-8?B?SmdTRWo3YituRnFvZElPWHA3SWZ1cWd0eThKdWRmWHhpVmo1VHBYNXBxRUw4?=
 =?utf-8?B?ckl1NnJIY2F2ei9ManUrRmxSVWw1QVdIM3VGVTBJMXBaT2tVM0xSdFBzYnNY?=
 =?utf-8?B?THJsUHVQWTJIeUcwY2ZrelpNOGYzOUpCby9vS3Rna0dXWDBwa3d5NjFZc29X?=
 =?utf-8?B?VGp5L2VFRDdSUm91OHhiYWsvTmgwM1RQZTk2NjlpY2JMN1hpUWhhMHZ0UElL?=
 =?utf-8?B?UFhLaURaMTFYVlZiN1NyWldHdG81MjRYTE1leDNMbyt6YUxlaVdXeDBmVDRY?=
 =?utf-8?B?clNvcUtEaUQ4Y1EzN3ZkZGQvWGJzOGlNa1pHRVRROSthTkU3WVdEZGFpdldH?=
 =?utf-8?B?cXUrb2xtUDBGb1BGdEpzaDk3N3laTjJiRTFNVmtqbm4rbi83ZS9VWjhJS1pU?=
 =?utf-8?B?ZFdSamp0cXFxb0tXejUybnRieWhiNzNEc3BiL21qVFpVVmpGTWJheGl6ejEv?=
 =?utf-8?B?UVpxUWp0aFlqbDZObnNBR1JiQ0o0M1JpUkUrU2ErTEZrNW5XZ0UzTVVBYk85?=
 =?utf-8?Q?GJGqJvLFKuINiw4W5w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1c334a-e28b-4cf8-ce03-08df4979b0bf
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 15:51:51.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQAIg9LrxulzJBph29J7ejzpdE7QGKPe3IgRi6IbZ4jnJ+/uiHNyEpDHccLaGUdJbdtgyV+VHoZubcpNbsC+CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7478

On 11/18/26 08:21, Suyuan Wang via B4 Relay wrote:
> From: Suyuan Wang <stevewong@hust.edu.cn>
> 
> sev_ioctl() works out whether the file was opened for writing and passes
> that down to every command that changes platform state:
> 
> 	bool writable = file->f_mode & FMODE_WRITE;
> 	...
> 	case SNP_SET_CONFIG:
> 		ret = sev_ioctl_do_snp_set_config(&input, writable);
> 
> SNP_COMMIT is the exception. sev_ioctl_do_snp_commit() takes no writable
> argument and runs SEV_CMD_SNP_COMMIT unconditionally, so a process that
> opened /dev/sev read-only can still commit the SNP firmware version.
> Committing the current firmware updates the committed version and the
> reported TCB, and prevents rolling back to a previously committed
> firmware version -- the kind of state change the FMODE_WRITE check
> exists to gate.
> 
> Pass writable to sev_ioctl_do_snp_commit() and reject the command with
> -EPERM on a read-only file, like the other state-changing commands
> (reset, PEK/PDH gen, PEK import, SNP_SET_CONFIG, VLEK_LOAD).
> 
> Found with a static analysis tool and checked by hand.

This will change the ABI, but I don't believe anyone is truly using
SNP_COMMIT, yet. It is needed for the live firmware update support of SNP,
which is still being reviewed.

When loading the CCP/ASP driver, the firmware update that happens is
automatically committed, so SNP_COMMIT is not needed for that.

If there are no objections from anyone, them I'm ok with the change. Let's
wait a bit to see if there are any replies.

Thanks,
Tom

> 
> Fixes: fad133c79afa ("crypto: ccp: Add the SNP_COMMIT command")
> Cc: stable@vger.kernel.org
> Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
> ---
> Compile tested only (x86_64, W=1 and sparse show no new warnings). I
> don't have an SEV-SNP platform.
> ---
>  drivers/crypto/ccp/sev-dev.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 52fb208b71ab..9d1c40a371e3 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2666,11 +2666,14 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_data_snp_commit buf;
>  	int ret;
>  
> +	if (!writable)
> +		return -EPERM;
> +
>  	buf.len = sizeof(buf);
>  
>  	mutex_lock(&sev_cmd_mutex);
> @@ -2796,7 +2799,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  		ret = sev_ioctl_do_snp_platform_status(&input);
>  		break;
>  	case SNP_COMMIT:
> -		ret = sev_ioctl_do_snp_commit(&input);
> +		ret = sev_ioctl_do_snp_commit(&input, writable);
>  		break;
>  	case SNP_SET_CONFIG:
>  		ret = sev_ioctl_do_snp_set_config(&input, writable);
> 
> 
> 
> 

