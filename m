Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8951E5701;
	Fri, 25 Jul 2025 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753453784; cv=fail; b=RVpEoGg14Y9kfV/qQdndUhJAzUXNgDzGurcavdyAjxELPBxIH35ZPgRzpBk+aw0ZBb3dUcKkxQDYMjKVzt54pGAtMXo40kKECKyGspjLG2EH7BGreXB5rUFSpgkfZoXPW/ucqOnYeiCSzap57AWWa0i/sLGRM9uktKViiDG1mAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753453784; c=relaxed/simple;
	bh=wjA6P+X8uYedm+GopcwgcRkixoLexdFdnn+WH/VgaOI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S4uMtzrEXexJFh4Uhasr+QrI7ZbG7AZilLY2uriMLC/p7SuxizeOV/39TDhF7OQmet9gx/qO77CzRKlMakzNc31TLsc89K3OQTElsOwxxu65YBXBnu5jhnqqkSs3vEDkkSqPdZQbTEIHOuteqSL/H8uesKvLG5csIddx4XxNMLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M3sWAJge; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M3sWAJge"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ra+iqohrHD88graMZEJnY1shnM28h9GUM94YyY3UDPQVUvv3sN6VFlOcPoRcuKRlhOAuIDj6V43GdFgw3lSPDJ5OcT4Ls6+9iaADPqTftUYRD5i9gC9fGE+7VdNPTMH2vBDp/X2SJPHpGXxgmjFtSyXTZQdI+vPGMw7KAwfmewXVEgnJyid4sJKvSOJVSSUvup4EKwitMh9aLrFYrT3Y+Cw3lR5elEmo/MQUaaSTM1ZxdtV245kiwureNWD2zWUaJq8S3wMWn1yEuPOKkC+OgjO6LzFEnXBRtj7a4qVQQP5hOPJvYlLfUGTFzfoY/DWV0Z6pcG+DR/Tm8xeO3OI+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y47Ng+z6TONAwSmodDVzQhnc3KzVKdVdQUXCjDg79w8=;
 b=ayLjxBOdvKqevfsTO/kmXc+LcHq1SOLbykRN7smkZDfbwfNBN3iRKqCg70jPyedPCPuiPGPIozzAhbPWDsk3dSFU1p/RPr/7grq2YHC2fXY7B8q7OpzBejE5oLr1rSaUWmeFpDYyhEhgP8OGEm8cQlMeVq2Z+mX5riUd4IeXBO5Hs9+lCow5x5uADPVK6kV+jaF4zesMU3K4bdCnW2K/7Sko9Xd2rLojHK4Qcua/yzpFWNiRjeBjlvb+x1X9OZiNApdz+QLXBQ/7x3CGNaXOBTpJDNfDijBVANM0Nl2TJvavgcOLEln95ozDlgG7C8aOpZbQhO88wcRVYljj9iDDJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y47Ng+z6TONAwSmodDVzQhnc3KzVKdVdQUXCjDg79w8=;
 b=M3sWAJgehYlsxO3Nc2sGJjd8bp2JBnHLbxDouPJXkl6hKXWqeBtmIrzWchuToZXYES4kP8046gpGz3me9NGPb0qWyP0zfp1M3cIcEK38ia1Dxx5LYTZESycunqqhuTB24mSzr/ZwdCRrd3Fr9w/gBJpplzHn8vmKkhbqaHwSoEM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS5PPF5C5D42165.namprd12.prod.outlook.com (2603:10b6:f:fc00::64f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 14:29:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 14:29:40 +0000
Message-ID: <5d89e8a5-d8d2-7b39-24db-78c0f59d2f42@amd.com>
Date: Fri, 25 Jul 2025 09:29:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 2/2] crypto: ccp - Add AMD Seamless Firmware Servicing
 (SFS) driver
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1753389962.git.ashish.kalra@amd.com>
 <82acbf87e782c482ebd8d80092b5ad47d1f4b854.1753389962.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <82acbf87e782c482ebd8d80092b5ad47d1f4b854.1753389962.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:806:27::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS5PPF5C5D42165:EE_
X-MS-Office365-Filtering-Correlation-Id: 4812f114-e2f3-4a9b-22ff-08ddcb87b057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEN2MzBkMEVrMGcwS3pzYU9HZktIMDhlYmhpY0ZKdGExb0FUc1pJcVByOUdr?=
 =?utf-8?B?aFpVUGhncHhyRHJxN05walppKzdtR1BVZlRmY3VLYXNHT3BVNm5XVGtiWXJi?=
 =?utf-8?B?dFc1M0lTc040anczdjJ1c0JvZ0hMTkJHOHA2OWZMS1BGN3FadU5yVFI4elVn?=
 =?utf-8?B?ek95aUt0LzZpK0ozYzVSNEp5Vmx3TlhaWm5lVXgrYVlaRk1Hc0NqK2JNT2hY?=
 =?utf-8?B?eld6Um0za2xVTkE3amZiZVE3TXkvYXFsbUdkNEJDMEpiT09UUHNSeDhacW9k?=
 =?utf-8?B?dU94NnVMSWloM04vaFZjVXVobjZ4aXlubWk2RlM3aDUySlV0Z2xidDBiUGsy?=
 =?utf-8?B?U0tvTHc3YU56YWJzcW14OEdsM1F5R2JHaEdGcjdNdkJKT1JVaE1NS0pnYVox?=
 =?utf-8?B?aVdFM1hoU25iTVc1MjVOd3YvWUdHcEQ4SlU0emdGdnJLR24zZWNGay81ZzFn?=
 =?utf-8?B?U29tWnVTbVV6bWFpS3A1aVFxYlFjdG9ocS96WUl2Z0hvcHBHeVZZUXQzMzlv?=
 =?utf-8?B?OVBFYU53OXM3bHExZXE1NkVRWVB1NDVvdnBCYWRzaFJhNG1Qa1dEaWV2R1dH?=
 =?utf-8?B?YUlKR0lXWWlVa0czYzVtKzJFUFRaTVFiVkh3WVVPd3BPNUJOU3lSZzJEai9K?=
 =?utf-8?B?Qm5MZ2NFWUxaV0xVREhDaHp1aGRWTUhWaFRpMDVoalM5SzErUVFhSmZWbFRJ?=
 =?utf-8?B?YTB5TGFjbnhsZnpzWWNZZldkRjVLemtsdTcxc055bVNSN0dJeUNxWDAvUUJX?=
 =?utf-8?B?UU52Vml2ZkVzU2lsaXpwRlZXQmVwWVMrZ081RjZnQlZvNzg1cXgvMVo2c0pB?=
 =?utf-8?B?aE9lSVgyVFd5ZzRYUVpyYUV4V3o1TkQ2NG9KU3kybmd1VFQxRlZRcUtRcHc3?=
 =?utf-8?B?WVlYL1VPakxqOVF4WFNOQW85NThLNWFyUzJQcDhYWkdXcVdpbVg3WFRYUUd3?=
 =?utf-8?B?V3VIbks1T2tDSWJiYVhYbCtpRmM5NVR2bnRTMDFCcHcvQUhqaEFWR1BXN3lZ?=
 =?utf-8?B?b0tmUkhXbEFYZE02d05ubDl6NlNzTnJWZFVzcjl0aVZab1ozem9kTks4Vlcy?=
 =?utf-8?B?K3F2a0NuOWIwRVVnbHkrblpscU5RNVRWMXZURnUwbG9wT3VIVnZaeThoNkFD?=
 =?utf-8?B?MWE2WEpHaE4vc2d5YSs2dlVjblhQaDZMN3VhMHBna0Rlb2psT3R2RzQrblVK?=
 =?utf-8?B?ZE1Fa3RtUTV0YnVNQVV0TVVoVEthYW93V0thQ3MwT1ppaVRNbTJGZlVwWTNX?=
 =?utf-8?B?WWVoRG1mazhlcC9hN1lVVnVBd3Bkenl2b25GOUwzSTdiRjFRcXJWSWtWU29Y?=
 =?utf-8?B?eDhlRml5ZjJMcUMySWg4SURxdXNjTElXSmNETENiOEthRnJPT3FiTERNUXVX?=
 =?utf-8?B?UnU4T3VHOWpZcm9FVlczZ3ZEZjNrZ1phSFhIU2lvVk0rbWl0RExTOWdwMnFN?=
 =?utf-8?B?cW85M2tIZUJGWTZyRk5PUFovS3FmMituRERFMmovNlNJU0ZXR3A0ZHBHVGI2?=
 =?utf-8?B?Qm83MTRjdkdYa2pObVpRUXZsMHp5c2NBSnlieVdJR3B4VVNWQW1kVGtVNXlK?=
 =?utf-8?B?cWJITnVXdTJDcHg3L1ArWGx3bm5MeTlIc3kyaVlaVVpmdC9xbVNaQUtqK2px?=
 =?utf-8?B?MHBwSXFud01vYjVpUHFEcURHK1BScFAwOHFoM085dmMzRFJPcUJRVWo0YllL?=
 =?utf-8?B?RzFYTWZCd0xrbFFsOFBpbFV2aHRMaGdtNERHTTlzTS8wdm1sRlNjb1FGendk?=
 =?utf-8?B?VTJpWDVQVHozS09URFlDU1BTTUVCaFUwWWtya1BGZ2U0aW82VjRFUGlYNHBK?=
 =?utf-8?B?WURoMCt1OEFUQ2xjTEFMZTYzTGl5ZTU0eEZmTHFOSVlJalNFaFE0cCt3dDcz?=
 =?utf-8?B?bGgrL1pHSzcwNUV3cy9pZml6ejRtcVhyK3lsbi8rTTl6a2FBc1lLVHJYK2dM?=
 =?utf-8?Q?3AXT2aSPys0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjRlMThrSGcxUHljTTZjUkw2b2dmeFlaRUFaRlRtRDhzS0t2L1ZrTGRlNzRh?=
 =?utf-8?B?R0JqZytDdndmc1ozNmQ4aUM5aitPUDhEQjcyeUtqeGF4VkNpTVlGNFRlTDNJ?=
 =?utf-8?B?KytGNFNBWWZqbnFiOVM0WVhMMVdJUWgwRysrY3BsYnN2NzVnSkE1MUt1M05h?=
 =?utf-8?B?RHdNdURXNjJFbzBFclNmQy9SWkoyYWwwMWVKVENkSExGcUZ4MzIyZVRocE9F?=
 =?utf-8?B?NmJCRkV0NGhJcXhiOXBpVGxzYTRZVFNYS002SHZQOHphZExDZzlMbTVFRlh4?=
 =?utf-8?B?aW0wblVhS0ozbXlEQVJOZW1WUFVSWUkwSHdnSlVDQnRGclZpazFzaXluSjV6?=
 =?utf-8?B?K1VFK0d5UFhUbFV2K1FTcDFUbCt6MUJYamVhck91eTJ2MVdDNFY4WjIyaWda?=
 =?utf-8?B?MWt6Z3doTllQem91N2hWcjd2UUtvY204ZW8yVURKYUV3SjR1MHJVQUNvY1Fy?=
 =?utf-8?B?aWdzRHRQY3FKTDlpMGtvMUZJZVpFb0hRbTlQMjR5SUJyVXdDZ0Nwc1JrMU5B?=
 =?utf-8?B?d2lWQWVsNmpxUlBjdnNHK0NTSTlUVEQ4UnZndHpBd2lEclFKakx0OU9rWjFZ?=
 =?utf-8?B?TWRmSTY4bkUrYmpyRG55VStCOW5lbHhOOFhnZ0YvZURMSUpwaUxMVGsyR1h2?=
 =?utf-8?B?MUFnR29iOFJXbkNHYyt6aXFwOEo1RWoxVXlXSWpQVUR4QnNFb1kzK1NZeDd3?=
 =?utf-8?B?TWlMT0pDdURMN0N3REVqKzFhVnhhRlc1Q2FRVkVzUGRjTmlJbGRXclFMU1pH?=
 =?utf-8?B?VkM1WHcyNjlUYm9Pd3JJSUVDblZPYmNKVFpzL3dXNno5NjM2U2REem9ZRmkz?=
 =?utf-8?B?ckxQVzBseWhldldKSUE5aStUY1BDTnJISzQ1bGR0VWpKT2NpOFhYdTJUeXJn?=
 =?utf-8?B?M1Frbno0NFBPa1JrU1cvL2tnbzV2TUl1Ukk5WkYwRmJ6M25xREVOTE9nY2xl?=
 =?utf-8?B?TG1XTFlDd1RDR0JBREplSDgxTGQ2dUxsbm8vemJyN2EvYUR1QkhIekcvLzNM?=
 =?utf-8?B?U0ZjSHltbHM4TVdVbDNxU3ZWZ1BnUjE1ZnE0RTU3aEg4M2twaFdwNXQ3Rjd5?=
 =?utf-8?B?RU9FRGNCT0k2TTRSKzR1ZktxeFMramRBalpNd3lkMlJaRTMwNzdiVUI3bjF0?=
 =?utf-8?B?bGJwSUlCYnNDWW5OSDhialo0czF4UUZBU0FFWEI2aXdRZlArdmpqSk4ySVRU?=
 =?utf-8?B?T21pWEl4Q1RUbHJYZkpNZS9OTGNiUkoxM1U2K1dCUEZKQnNNVFdqcTBlWVlI?=
 =?utf-8?B?VTZ5TVJKS0J0VDVsUnNJTUxxU204UHNwS20yNHhYTUIvdGJIR0F4aXZPcy9B?=
 =?utf-8?B?cXdQNWV0NmUwY2VZSjJnUVBCRFhUNHp0S0JJTTVFbDhYZVowS0VhM0FxdnpC?=
 =?utf-8?B?d1IzSC9OcEdqcW04MEhrbnBjY3d3cmNXVDI5K2taa0QyaXUwT00zdHYrUlFk?=
 =?utf-8?B?RVRpQXNCaGNmV1ErejQ1SXlDZnJjTnR0TkRKOVEycmNYb09VSlFRekRtUmRx?=
 =?utf-8?B?V3VVaHVlRmpZV1hsVzdWRmE5V1ZzY2s3Sy9CbVEvNlowSGo2VmtyWmVuaUVv?=
 =?utf-8?B?aVpUeDRRM3lRK0NqSVBKVWMrVXhKaTY5aHd1VDBVYjZkQ0lkZGpoamt4NFNa?=
 =?utf-8?B?bk4vWEdhN0kzM2U2SGZnaDJSeFhRazlsb0liK3pSUElESFRCVTFLc2VOdjNy?=
 =?utf-8?B?Slp5Y1dnV3BvRy9oSmkwUFRYdUZnVERvVncvWU9Gd2JTMERZcVZ4bnB0eDJB?=
 =?utf-8?B?dEZKdjBaMEpUKzR3TGpGWjdDR0xRNFF6WkV5dXg4bFR1c3p5WjZ4aGxoRlU4?=
 =?utf-8?B?TjUrdXJXZ2NPaCtFMnV0MWJlN1F6UmF1QnpCL2g0VFM4LzVhdkJBd2RzdGhQ?=
 =?utf-8?B?dVFZTU9NaDVhUmNjRThEQ0gzWUlQcjQrL0dyaXRKRWxmeGNwVWIxTk83U3o0?=
 =?utf-8?B?SnlRUXJRKzNwOG9TS2VYV1FuSHI0a0NKTkF5V2d1R3A1RXViZThVbnNGYVZW?=
 =?utf-8?B?ZVpWTFZsNDF5bjhoRVQ1SXl6Vk9CVmo1aDQ3VWx6ZThScm1xakQ1UjJtSENH?=
 =?utf-8?B?WDgxRGJpQStNRTR5a0FWYitwQ0hDYjArN1ZyR0NuTUJxVkxTZEJnZ0FZVnJk?=
 =?utf-8?Q?aRTIE5iNkXw3O6BSsnfy9w818?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4812f114-e2f3-4a9b-22ff-08ddcb87b057
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 14:29:39.8033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWgEf76XaBQ6uhIqQB2FjV71HLRg2N4hCqIJAxnwoN7kqVBVivUM1FDV4VZKXobYKXsDilH3LzXOazlaRn9Pzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5C5D42165

On 7/24/25 16:16, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> AMD Seamless Firmware Servicing (SFS) is a secure method to allow
> non-persistent updates to running firmware and settings without
> requiring BIOS reflash and/or system reset.
> 
> SFS does not address anything that runs on the x86 processors and
> it can be used to update ASP firmware, modules, register settings
> and update firmware for other microprocessors like TMPM, etc.
> 
> SFS driver support adds ioctl support to communicate the SFS
> commands to the ASP/PSP by using the TEE mailbox interface.
> 
> The Seamless Firmware Servicing (SFS) driver is added as a
> PSP sub-device.
> 
> For detailed information, please look at the SFS specifications:
> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf

Based on your comments that this might not be the proper version, I'll
wait on reviewing this.

Thanks,
Tom

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
