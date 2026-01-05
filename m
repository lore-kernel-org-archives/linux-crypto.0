Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA212DECBF
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 14:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767622581; cv=fail; b=TLoAxloDZK+mNzR3+KEpI/4rCNqzOyP4eGEtzQJ0kfjDywqJD+5pdnQ6Xzz23TO4IgWYiqOfikxAQQe6u3P/xNSva4hNj264zrvxRI1WJrQr/n1DC80yFNJx+HkgaiRzJdAQdAZitZkeRn9vgMAFUCR25wkI+bKNPEDx2O5sOxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767622581; c=relaxed/simple;
	bh=WE0HY7b7dyKcJsh3KebvcLe00WGhFFTKB+TbUkPHRks=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VlnEvoI8QYUqOz4LE1GX1Y10ca4P7Kf3IOrJ5NBJXx59RMQTqOPMvNsZI1+0PEG3rfR/6gzYd0tPkg6+4Ekm0MBAr3VcHDDtvNbxS8GnqQSyHsfh6KUaUJPHi+7oyRZ76ZYpq1WIuRJIynC+Ola4o6DLzM0HVrzf9TyE64ClgVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZNOhDnps; arc=fail smtp.client-ip=52.101.43.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZNOhDnps"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGHDFv/RQFJA+WEOI36kE5xuVVJBYM1r01W8inTlhv/8T3EWSxBUMm1Xs9SJlGcNuW4/iclKe4QNG29hCjrZj9yfC/8ja+4X59G0VWA/6r4qJUp8chOqqU2kYZEVY1Ish+av8lyimzCm5c+5fE35pNdbXLxURnOGLOCeGnBR6UtQeXSB2Js5LWUmnc9wUWO3jR0t1r2ek72EtrT5rWng8gSBjroTyVYY19/IVwvtZ6Iw0YyLkKkjTOuWTxnYWJ67BKEVG4blKnbY57Z6PHGVHQ8yx+Q4eyfaN16cpzHZbFLR+q4DOLLrYSvh2r+H9Fdv/fzA62peXjfgX5xxWbannA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxG3ZeHegnHphR5RAxOnYFZgO5VKzyfvZS84921R5ZE=;
 b=nxawX6i67qJSKD53VcLt8bclatHAx7/kM7xscHA+kEqB1lh/wsiIg6eKCNszSJ4fh/O3R+eppOkDrONTKktXc10Ejrzm3B5M9HKe1wzdGgrzjD2a9jWn+3Kaxsnp/CuIcrITY5jPpD1YcQtLiu2wh9Lh6hWA1MzBZYKh6rLhF65d4MJj1TJUYXBpPMIqDNcQQovdcPn3WVryP8R6LrHaur6zvgjNV1QzGvtz3dDobURz+WRlrvbF+9TRZSNLE0wwmBdVbMuVhBwxqUA2Ik6bX8Wh+ZGBd0qLt8N12GNEG9tg64x/K0F+cfaoEiJpdd2gC+PWMsSTlrdW+UqFHyv4fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxG3ZeHegnHphR5RAxOnYFZgO5VKzyfvZS84921R5ZE=;
 b=ZNOhDnpsBS77m0zwG1+B/kephTcs+MUrPcZ14lfejJNufh82HuTyLubLD+8EAL6QmaQxqnQbsxI04+HVbaSld0qssLBX2d/pAtZ4xzu3QyGTdpwghLmDaOfh3WLJNCZB24LkJgj8YN7O989Bdfl+QTI0Jsw+MR+4f6ZMRWt7wUg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ5PPF01781787B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::986) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 14:16:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 14:16:16 +0000
Message-ID: <59bf1c49-2b11-4b0c-901a-93b4abca603f@amd.com>
Date: Mon, 5 Jan 2026 08:15:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: crypto: ccp - Use NULL instead of plain 0
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Alexey Kardashevskiy <aik@amd.com>
References: <aVHPyZIUZFLMdNYU@gondor.apana.org.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <aVHPyZIUZFLMdNYU@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:5:80::42) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ5PPF01781787B:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cc1cbad-4f60-415a-7994-08de4c64fcff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFVHTzJsVW1ia3dJK1dGdURPUFRwdnE0bDVaWmNMUkNCWFBrakFxWmwyL1M4?=
 =?utf-8?B?cWgvQjMxNFJUUmhZdVZjb0NCQ3N3YWtVNHp0UlA4aFMwVDFlbVFER2NXb3E4?=
 =?utf-8?B?Q0FnSEVWU0hDWFlYL3RHYzVKQm1qTC9lMy9JQzE5aFFyUlp5ejJ4V1JEOUVp?=
 =?utf-8?B?OGxwcEdneExkOVhKMWh4TnNqZHBGT2ZPelZ2RXVXd3VVbUhBVHZBbDlQYXdF?=
 =?utf-8?B?NFVyenJXUTcydTJISE1mYmFVODZKcWZIR25tcGJ5aXBoaUlnRzROcm9MTWUz?=
 =?utf-8?B?SnpCMEY4UGJSWnpFMzZwbTJOdDFCK1ZLV3FwcDVHYmg0ekx0eEZLeEk2WUIv?=
 =?utf-8?B?QnNhY3IyZHBVanhUYU13TmprWmNQTmNINDR2Y1JmTjNPd0dYWVZUbTMwWmtU?=
 =?utf-8?B?a0htUVNpVkk1dCszZmU5cmRnZU1KQWRpTXkvdmNzV0VxN0pFdmlrZVkrc2Ra?=
 =?utf-8?B?Y1ZicEFqRWd2MUR5SkFNWUIxUGU1UkExVzdtSGxrMG1CN2hPUmhMT3lNRnVl?=
 =?utf-8?B?TjFaTXdYb2dJb1dRWTJEbXpxbE81WDNGNDhDcXVmMnZOUGd4Q0lTYlpLN2Qr?=
 =?utf-8?B?VzdzVXdhODM4ZnpMRlR2Z0pxL2tHVktYUW56c0o0K29tcUtaTnVRUkhNUzRi?=
 =?utf-8?B?dUg5dVVwWncwQ0FhaWYyeWdsaFFwcUxVcjUxK2kvVnFBZHF2RnN6eGVnR3U1?=
 =?utf-8?B?YU1jU2x6VTRWUlFFUGdyVmdzZWoxZmlBMlk3WVZudEpmRGpTS3c3bEdYcXNC?=
 =?utf-8?B?Z0N4MkI4RksxMkwwYXhwRnZ0L1dGeW1YR3VDV3pIWm9lZ21ndkV6U3VKcCt1?=
 =?utf-8?B?RDJaZHdBSFljUWFhK0h0L29WL1BEUlFSYTUwZzFWditueWFMR2g1akwrakFh?=
 =?utf-8?B?d1gvV21La3piTkxyei9ObXpmNTNUZ0hhRlNSeGdDelZmWDlQUWYvOCt2ZFJS?=
 =?utf-8?B?clg1eGRxZmlwa3paUDVuZitzOTliVk5kRnhBdkRkTXptV09lTmRsUzVPV2JC?=
 =?utf-8?B?Y2pPRUdvdUNnc0xmSk1wcm5rdytQR0JZdzFnMGlxUjRnVmJPSGpmeTVtaFJJ?=
 =?utf-8?B?eXc5TWtOREJodGV0RFJMZWtxTlkxbWE3bFZIY2ZiV3BTK3FBS1U3a2FxcnRP?=
 =?utf-8?B?LzkySitFbUwydlFCczdIOVdIYlZJditNbEo0MTdWcWpMZEdRRXJPcmJ0MHhE?=
 =?utf-8?B?eWVDSFN5bk9lLzYxNE9ZYnpJMTFrN1pSR01SWk8yRGNTcnVwbTRjRjJneWF1?=
 =?utf-8?B?c1pvQ2t0TVp0Zkk5SUFXaksvQnczRUdtRnZaNVZ4N1BpMTRhZFlVUFJicXda?=
 =?utf-8?B?WmZPRXNtYUs0bldXSllBa05EKzZDVXhlS2prYS9DS3UyZXBPZS9lc2cwM3A4?=
 =?utf-8?B?VTk4V3htbDhIUFF5cUhwS2FiYmVmTUNEaGl6aFBhNWRTcUxPZklxcHRBelk4?=
 =?utf-8?B?TnVCVGxCUVJjbzFNM0hqcjVpQlpCd0RobS81UzRucTFRVUNpV1pLTmg0SU5W?=
 =?utf-8?B?WGxaSjNxQ1EzZW9HK0NRdzRTTWVpNXJxYkJCOEFidUQxNUJXUlVaYVNTOWw5?=
 =?utf-8?B?MXBwZXZReXJKOXpUU3RYa0l6VzlzSEZ3Z2dQTmVwOVgyUFc5RDRjMzJNWlpY?=
 =?utf-8?B?cWp6RVEwaWpuNmJ1alZMNXFMMjgzSmk1VEJtTU93VjIyUmhCOXRLdlRKMkJj?=
 =?utf-8?B?YSt4OW5sa3dwNHBhNnZVRkVlU2IyUGRGQnkyaElGd1N0UzF4emEzOGFtZVRD?=
 =?utf-8?B?NkpMWHh5elpoTzhiM0JveGROUU1qOFhmUlZ3QXdZSnhuRnV2VDJkVU1laGJK?=
 =?utf-8?B?bHQyY0U4TGhNM1V1bHg2ZS9zaG5KSGFhdG82S0dzNWlqeDZnOGRjeXp3QlJ3?=
 =?utf-8?B?YnYxR2VBTUdJNDcwWkpMcEY5M3JacHhTRkpSNXk4Ry9YV0E0Z0hLNzVFTGlM?=
 =?utf-8?Q?6UrFj2YvBhl8Ry2LEZG4qHiAlqWjZ0q/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkhRa3Y3QTdlMzJYZVB4dktVK01pRjZVOG9iaE0yTVFlUHZTc2dOb055K2FZ?=
 =?utf-8?B?ZGJBdTg0NGp4TXRtWDUyQlhyWmpycUNtSE1LdDVKVGdXV25PTmorTXR6ZDNa?=
 =?utf-8?B?Ylp0OGFiOUZZUDh2bW03T25SeXdoSmQzeE5mTERQeU81V214ZzlyNDc5SGdp?=
 =?utf-8?B?WUxEbmpBZ0s0NGMycFFvZUFiKzFsMmxvdFY5cklDVHByMjNBSTB3ZnZNYi9x?=
 =?utf-8?B?TnRsNHg2Si85ZXVBRDNpek1QU2hOR2xkRFg5b3ZrL1ZlOUxlRUQ4Q0MvdEt4?=
 =?utf-8?B?ZEp0SXo5YlZQUExhQmtRMktNT3MwQnpzbHpKNnZsZktWN0p6YW43S1dOWldB?=
 =?utf-8?B?TENadnVFR1VxbkZuU3ZVRyttU1c5NDJRTndQbXV3T3hkTEZIRk80WkJxZlVv?=
 =?utf-8?B?dHRqYis2TmdkamJ5aG4zN3B3TmM2MjlDaWVvM3lWOC9XMC9SUytTU3dXeGpp?=
 =?utf-8?B?Zk9aNVM3Ni9yOTRqM3pRRW03OEdTbisvdnZvd3VCSEttSzNKY3ZFZG1oR2Nk?=
 =?utf-8?B?NmJ2NGFmSlRUVFhXV0RhV283NjFsdnR1U2FRZzN5QWx6RG5WNnBWR1dWczZM?=
 =?utf-8?B?eEpKZWhyU0RTZzZJVGZLMmNtNTREdVhGd0pUUlN0d3JBU0VJSHp3Ump5Y0RN?=
 =?utf-8?B?VmpaYTRrNTRBUERpNUdoVVd4TkpMUFBNT05qb2JLRUJ3K2hGL1lnb3pDZXFS?=
 =?utf-8?B?cmRaaDRFY2xMZjF1SXhiNW5ON21leWRoanYveHEyWmZaaVh0dXMxVlAxdjZQ?=
 =?utf-8?B?SkpxRXRFakNNOGNOcXRNditMUTF2UncwWFp6THdTWld5UzNnb0p2dExuWUdE?=
 =?utf-8?B?SHUzV1pRNW5jZ21oNjZTd2E5SkNaRGlYOHQrR1Flek9iemw2TVo3NW1CQy9h?=
 =?utf-8?B?dDRXTEVUVncwckJCOXpaUUtQekZFU2Y5RU1kMERtZG5lV3JDYWN2cUplZm12?=
 =?utf-8?B?bUN0MFpJc3Q1YzVzYkIvKzUwUExnRkZOMmIzbXpEaFIveWFXZUs2dzh5UWp0?=
 =?utf-8?B?b2ZUMVpBejk1aWVzTG1IaExkeG5ibmpyWnRKRVFSSVZqazB6UFRMRjFxMmJR?=
 =?utf-8?B?TnA4Yzh0d21KYXZFY2NWU3NTZkd4Ny9iTldhT3FoL0ZlRmhzNE5QcmwraVhZ?=
 =?utf-8?B?THNZZk5vOW9nV2pSTW5KdUswcWRhNENDaStTN3lSRGdyNmF4SUh0RXFkemxO?=
 =?utf-8?B?WkJTdXNJamkwbnhjV04zd0VFdGZxNFVickxtRm5MNlNyMHZtWkZ5dWNsbURI?=
 =?utf-8?B?Uk94WTY0alBLa25TSzRmWW5xM0RDT3lYUWIzS2hDVFR3SUY5TXpNbGcxT3B3?=
 =?utf-8?B?R3REN1pTWjU3d29TUmxhZVdwUWwreHdiaFZ3cjA0QXlGRG96emFLN0d0Yk5H?=
 =?utf-8?B?a0gzbVFvM0FmcElIcXViNUJBMGJSYVo3cDNlUnJDc1FSc1B6elEzbkJPbXdF?=
 =?utf-8?B?QlpXRzJoNk90Yk5sUW1GaGErZHlkcmk3dDR0anhlR3QxVTBNTytsaGlaVm9o?=
 =?utf-8?B?aUFNL21UVWlkWTVTOWJkT0JtZzZFRTA4MkF2b0tKRmZxR1ZRSG82N1NyNEdj?=
 =?utf-8?B?c3lmeWxLc1VRT1hTVDkrYXl6NG5FNkFGMGpMMSsyY3dsbVRKMmlRYmxrYjgw?=
 =?utf-8?B?dUZsdkZDZFRzVUhxS3U2VUs4V1Jpa2htNzlVWGZHU0dFMmU4VkxGeU9zc000?=
 =?utf-8?B?OG9TWmJJU2lEZHZsbmJIRGg0dmV6U25nNFRqcDF3RUY2ak9ZTi9UK2l4UmpV?=
 =?utf-8?B?elJGb0dmRUlWeXVVM0ZPbkZTbVN2UzZGZFpvREdtejM2ZThLSTNIVU5ZVjhU?=
 =?utf-8?B?dTNyY3ZEU0VlZ3hvWHAyMTNMWnl6bGs3dHZobDN3NmIwMktYc1RyTkpaMHV1?=
 =?utf-8?B?QndGUEErRUJTMnh1QkdnTUNuV0cyRDlCYkp4NGlzdDBobGhleW4xTlpKQ0Nu?=
 =?utf-8?B?dVBwUW04Q2t5ZEw3aWU3emVkamNCRmxKT3BTNHNDOVUxWiswMGc3ekNIWHM3?=
 =?utf-8?B?cVNqR2h3a3V4UUh3QVdERmRuYzkzb1NCb05wYnprVnVDYmJoV2JDU3FpbkJt?=
 =?utf-8?B?MkRjQ3VTRTFyUGk2ejZlRFdES1l0bVJxcEllL0xYeWk5N0pXUFhUcGx4YWVU?=
 =?utf-8?B?VVV5ajlnM3NucmlQZTRTNWFBTVJ2djEzYXlhSG1QM1lROEJVamx2NHB5N3Uz?=
 =?utf-8?B?OUcwRUVSdWRaQ0xkNUdJQ0tVa2NHelozelNkNGpUNmxRUmdvWFlNVEd5Sk0w?=
 =?utf-8?B?b0hzVUNFbllrMW9FTEY4bEk4U3BBdUZVMFJtakhpVGc1KzBMeXpkU0tHSGlO?=
 =?utf-8?Q?/gNFCknkefRYHu7Na6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc1cbad-4f60-415a-7994-08de4c64fcff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 14:16:16.0071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: behHlX4q32QD0oLUdYNSGNsiktJfQPvjiYx61cxgvGBp+PCHTnm7A9WHfAb1XaI9SJnFZycwZwX+31A5jPLX5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF01781787B

On 12/28/25 18:48, Herbert Xu wrote:
> Use NULL instead of 0 as the null pointer.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index ea29cd5d0ff9..5fd5a8fc60ed 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -241,7 +241,7 @@ static struct pci_tsm *dsm_probe(struct tsm_dev *tsmdev, struct pci_dev *pdev)
>  
>  	if (is_pci_tsm_pf0(pdev))
>  		return tio_pf0_probe(pdev, sev);
> -	return 0;
> +	return NULL;
>  }
>  
>  static void dsm_remove(struct pci_tsm *tsm)

