Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE1C2D9EFA;
	Tue, 24 Jun 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750778463; cv=fail; b=Z3gR4uI7BTpDi8Z6W/pnmkHY6+TV1npotnoIvyz+RdSx1uTV8/WHXFCC03IGN7Re+Fefw+/E/kB+UQ3RCRSHL36BoGzNVE7NGUvZthF1Jay4CTGnAbPaCz5S/FR1uI5bwilGwJhQTtfjNG1/JE3JWMUDtsJ/rYS36ZqG4heVcog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750778463; c=relaxed/simple;
	bh=yjW4hf/f51KQqvpYX9VUfFjybu/CWt27z8r/LC4J7Ek=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uk2dfXKyZZahgRpOaxO6OHNm/P2HaqjufukHBARTxyJWRO3lIMXe0s86Yd3L5N2UT7JUyJ28CeJ5/UuGOuyrsu+ES6/ZftJIJibWrvWrvmySzeXKY7lsV4n7Nl/VuEqpnXLJhmkagYhr/PmvV4xlOjk4da4d00Om/wc5yFTDFV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XwrK0/yO; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XwrK0/yO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cky+gRcsPlUBpYrQ2yJNB6iHuvLGH6DpGaNGoTQGT66sZ/MCnbipfn1Tlva2ZmihfS0bkcCR8/xu5+2DdDC00wFBzDzu2+JNokkZCXIuna9He5Eh8LIlVaHWx/UX4JJL8NWtk/lcDr0EhHisw/FtT5LGVBqgPECAcsmhq46FpKzPnT9ErZwSFB32fqWQ1RdeqxK/codw1UZIH8H9j8ir1j9JqFn6da9QH0I2EuuQFpWyUQv2Z7dPH5cDQYzKlEeihP4psG90tXJ5ki/HkFNPlECWZvrkmA0TDSF6l4Pz4Xtqrsq4Q96BVNkg9b5JOfCrmbj64Kt+XTx6cf267UBadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QroMoyZrMmkDz9f4PQapFhY53j7cOmDdCR5Sffsj1DU=;
 b=IesZ8Nbce1oc2lSeSIBCVyblVmf0O5XeGMtxzwxL3GFW5mDvGFfbctLSuAQwT/ASlEHRnV3JjvlhjXxcKidYQ/W7kCGknNgOROrX2yK4pZW9sc1I7elwprzyAH5U43+ccVDfOH/SmvsGDA8Gw0wg6g9MPVO42B+tiB/eBXRn157jaeWB2lyoiiyH58+hUgXMJR2/EF4dntfYJycE7DL9pIwFJqSBzLN2csAZWPlPE5fTEZW4sz8f4DGg/IOFle1UATvdfwXywSsWsJjVBZQl7cnhxnJfyhPX7eiQSdRquSyb03nKmSBjTGMFv6+CHy1T1XGaxHTXQzvOCsuFBjpHmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QroMoyZrMmkDz9f4PQapFhY53j7cOmDdCR5Sffsj1DU=;
 b=XwrK0/yO2uq5mzxVhkA2Z3lWE/Fid9mSVlG0zgYRjV4H7gYI3iGdi8g7Lz1RuTe7bvb5eU/a3YG8yfA2vzZDdpVeiOBZRfvgQgatVvjGXbESV/60XOSBD24C1MjSZ6qGFD1nMCupS7yZ2cKuOf9eV2oB/m+PNoPvD3D60o66bjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB6115.namprd12.prod.outlook.com (2603:10b6:208:3e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Tue, 24 Jun
 2025 15:20:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8857.019; Tue, 24 Jun 2025
 15:20:58 +0000
Message-ID: <5d3d3bfe-d8c7-185b-8e48-6f032873c8b3@amd.com>
Date: Tue, 24 Jun 2025 10:20:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto/ccp: Fix locking on alloc failure handling
To: Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
References: <20250617094354.1357771-1-aik@amd.com>
 <a0ce9850-cde4-4e17-997b-ad06a76a23d6@amd.com>
 <7d4bde18-bbb7-4177-8577-b96c16f80d1d@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <7d4bde18-bbb7-4177-8577-b96c16f80d1d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0901.namprd03.prod.outlook.com
 (2603:10b6:408:107::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7f7193-2daa-45e7-4fa4-08ddb332b89e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1FRTWpKa0J0YjBJcDlYY2FqOVZGLzJ2OGpJQ3BKRnQyb3VKUXBIbm56Tnhk?=
 =?utf-8?B?QnVJSmVJMlRUbER2L3dOYm5XSkxIWGxRcCtBeGlZQWtFNG01Qng3QU13Ky81?=
 =?utf-8?B?RmVVNWR2SGlSOU15L2NPVC9jNUhsRXRNdURReUo0VVZSZFhremJYWkFzZXlO?=
 =?utf-8?B?TzM3Z2RNUzFnemx6dkZXYzBxR1NhN1lkZE9ydEJGRG1HR2Q0ejFnMU9yeUg5?=
 =?utf-8?B?QWF3bWRJMmVHb1YzVHh1bElMc2hjMm1kRk5aZE5OMkMzaTFvcG53dGd5amJl?=
 =?utf-8?B?Q2pBZENSMytoL1owSSs4N0NQMTBSdm9zc1pTYmg4bWZKWERqSHptRm5lRUxP?=
 =?utf-8?B?NnB0eFpnSVVFWEw2QkFsS2JSZEdYd3VtVXlRVFl6OURPVU54eldldXlvcHRx?=
 =?utf-8?B?MHVGcXNwSHI5QWF5NFErZElNOE4wVGFnMk5aa3BMenVYdzNpczkva2t6NWN3?=
 =?utf-8?B?RGhKMG00V1liYlh0NHhPUGtWYmdjUHRieEFENXlKc0JMZFNhS3ViN2VPRUdt?=
 =?utf-8?B?Nm9RTElCazVTdVROMG9Bd2RjYjRXL2N4SGhPN1pVWWFTNC9wU0dsdDFJejlo?=
 =?utf-8?B?YkhYa01POXFnUmlWc3NmRDF1eHZiUUxzRUdoaTJ0bCtBRGVmK1dPR2VBOXVE?=
 =?utf-8?B?U0FIc2NERnJ5L2tRRnJlUm9ZS2h0NUs5dnNLODNqakQrY1ZvRkJSdEY4VkJh?=
 =?utf-8?B?U3h3c28vZ1A3M3ozczRhdGpBYVRIeVd6TjI2dUEwWHhkOWgwQ09kZHlOajAw?=
 =?utf-8?B?VTdZUnV5NWhDVllCVnVEZmZORkhuVXplM0JPMXRqc2hjOWpoZzVnWStEcGtB?=
 =?utf-8?B?UmJFUzlNZ0EvdlRSRjBxMVlRbk9jTTM0MlRFVW5uSlZaTWdjWXpKbUZMWjZM?=
 =?utf-8?B?cEtZMnhoNUJXV1EwNzNKQTA2UHo3NC9WcUZhRldZb3FJRERqZDdBRlNMeU9q?=
 =?utf-8?B?KzRhaHBaSGhtS3Y4T0JDTXUwa1VJd1YyZGZlM2RjWnkxTW1ZQjlIUWx5YW9R?=
 =?utf-8?B?dit3Ti9QMjcrNWpVRlc3eHEvbzUrNWE5RFRtMUFwR3NESjFFcndZZElDYW5T?=
 =?utf-8?B?T3p1TGJ3TVBEYjdHYU9zbkZqU2oveG1oaUMwcjVsdzNJUTIyVWdyYXppeU9t?=
 =?utf-8?B?UU5RbDNVekg5WGxtdUZzN2ZGbExlYytYV0lQYzZXTFNtdk00UVNwZkptVjlJ?=
 =?utf-8?B?Vzg2ZFFoRkowVVZDaWFwbzZRbzJyeDlCZjFzVUoxanZRYXZyWmJPSHFqWXdE?=
 =?utf-8?B?Y2x1bEw1ODdqSGpuRlk3bjRtaEtZL2g2dUc1eDJEMkFhWldTbjVPTThtSWIx?=
 =?utf-8?B?RUZGWEdrWmVvczVqVkhCVHI1Mjg1NWZtYXNFQUp2SVo0eStNRGYzM0xQcWRi?=
 =?utf-8?B?VlFselJmZ1VKRnEwZ0pRZ3hZSHpCZGxQb3o4bFRBZ0dheHFmM0FNVEFGa3hs?=
 =?utf-8?B?dUhONVBMS0NLckE2U2s4YUJxeEUrbHhnQnRvRlQvUThrK1ZoTklRa0x3ZE1J?=
 =?utf-8?B?a1VHUFI3bWxrancxTkI2V1JJSFFxOW45OXVPSmx1NG50cUMyaFY3UjFVYmtl?=
 =?utf-8?B?WDNMK085M2wrSEdmZ0FEelh6d3UzWW96NFVvM0VsSDRSU3diWGhoRHA5MXpv?=
 =?utf-8?B?cGxtell4cm9rUVozQTRHVWRheUZuRXM2c1NtcWN6OWdmVHovUGhRRmRCRW8r?=
 =?utf-8?B?T1J0Mm42RDlaY3NZcC9qcTF4dUtRL3VSUC9mWGVKWjJuNEdDVTdWSE1ScXYv?=
 =?utf-8?B?SzNjY1h5cERsRzQxVk1zTENxR1FsRkNHL29jTXhYbHlUOXMwaDlhVldFL1Iy?=
 =?utf-8?B?YVRQZmF4b1JWMCtIYk5RUHZiaDgydW9yWDY0Q3NGVzdEZHpSQUh6N0pMNWZM?=
 =?utf-8?B?bFpxcWlKZTU2bS9xd3l1TXBLdnBsTTY1S2lDYzlnZ0FFSys2bGlGWVlXZW1r?=
 =?utf-8?Q?abWzN/fE89s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlEwV1BwMEkxUlM2UnUvRmZNOTlPWnRtTDVzSnh2T2QzTytCbURwSWRvbXNW?=
 =?utf-8?B?Z0FJS2FtOTZRUmJReEFRVzlqUWVHZktjQzh6NlVXai9TYWF5VHdpbXZaZnhM?=
 =?utf-8?B?WjlQMzBFWmpOWHN2dkdSMTVvQ2NtTURDbmR0ZS9FTWgrbERVMy9wUkVrUEtu?=
 =?utf-8?B?R3krOEt5emdBdWVOSGdOVFJZMm5CU2VwRksvL0dVYzlockhFdWRUSDc0T1li?=
 =?utf-8?B?WmhNelhmSWhhZGhlL1BkSzREVHAvNmFMSXYwRWRoK1RhUDQzZUlUNXgxTkVl?=
 =?utf-8?B?Q1ZMZ2RlY3AwOEdnWi82ZWNtcWdObXhJbGVXU3VyQmh5QUtQTHhTUjc0VnIz?=
 =?utf-8?B?VGFUcVlWN0wwVEV4RFdTYlk2anpmYU9ZaGVNNG8zZzhvSndYTkdNZnFvU1Fp?=
 =?utf-8?B?YTExN2wzVVBSN3hud2hkWEdBQ3BicHhjbWNwUHVITjBFZ3l5NGNiSDBxRUl0?=
 =?utf-8?B?ZXhTTHJEZDRFbTVhT3hhQkR1WXlFUzV3ODNGYXJxVWNJb1N1STBDak0rcWQx?=
 =?utf-8?B?WVdKeGlsV0YxOG1vbklXT2xkbDF5K2o5TERSVzU0aWk5a3pBV1hJbHBGOEpN?=
 =?utf-8?B?N2JjdzRwQkJQTlBiY3QwclUwMjlVUlZxUXZMY0MrdU5aTWtoOURJMndwNC9y?=
 =?utf-8?B?dzdsRys1dThXT1BKdFM0KzhiZ2NqV1dXMVNFUUppUGluVzVPcG1INDFpQTJo?=
 =?utf-8?B?alY2REJ3QjlmTkc3TVdCbllKY1dMbElveWRLYkRpSzhuZ3VnREF2QStIZGtT?=
 =?utf-8?B?bDdGSjFiOG5JUHVQQ2QxNnMwWURNK0d3VU05ZlBPc3ZMeG1tWkpZM1R5RWNo?=
 =?utf-8?B?Y3NJUk9PbWFvdGpPUTF1SFBGQS8yM2xZRUoyWVBsQ1YvdExkcURuYktUbXJK?=
 =?utf-8?B?TWNjaEFCTUxqOS9VWFJPUEFpUDJkNFZRTjNHeXR2Y0dUWVp1Tm9WWjJ1ckFW?=
 =?utf-8?B?WUFyejFhbHVJSGhkbm9VbW5OZlAzT2x4aG03M01SekdXSWdTdHNYaFU0eEJn?=
 =?utf-8?B?V2xhNUIwaVdQRXMzVVNWbVAvOHkzQTdVMHFqek4xMlBwaWpSOXFNdUlXci9I?=
 =?utf-8?B?K3VMRFBwa2dqV0FZYysxOTNJSDNJN1ppSmNXVE1qd3lJVS9QTmpRSVo1VllS?=
 =?utf-8?B?ZzZCd2tReXdnRDg1aEk1ak9tajQzcWdFRG5teGMzRVN0Q3FUSU1QTlV5OHJy?=
 =?utf-8?B?SUlXRk11MEp1dHAyRTlVWlZkak5KVWNvdjJzcUNBNWF6ZlpwUFp5VTlQeEd0?=
 =?utf-8?B?SWgzVHU2a3psN0Vja1RxbVZIc1FJUWhvakM4aDV6MHJ4T1dua2cwcVozTFVF?=
 =?utf-8?B?QzFYMURjTE5PTmZaWkdhQmpJckgwd3hXQ2kzSlJWdC9BRmdPTWJ2VHlubnY2?=
 =?utf-8?B?YTM1Qk5LN3BEU0pWTk9sMUFtREFKTjNqcTU3U01vNUxTSUIvREU5ejdGcDVU?=
 =?utf-8?B?YWt6cXYzYTlVSVBRVmQ1aS93dHVQczRUREdFNkVxS0twRThUTkZpRTduU1Ju?=
 =?utf-8?B?amp0YSt6c3FycW1wV05nOFVia1NBdmJOY3Evd1liajNlbEd6VXZFVU1OK0RH?=
 =?utf-8?B?d3laT0UvMUpkdUx0LzRqdGVqMUlWcktGK3ExNnBQU2ZaRm9rWUF6WHpydUNM?=
 =?utf-8?B?NWJmNllKN1NCdHFFdlB3UUloVkNlYVRZTmt3aWNyVENOTVZkM3F1aGRwN3JL?=
 =?utf-8?B?NDJWdTFsSmJ2Ui9haWpmZEU4eTFwY0FDZ0JJQWYyRElHNmlONThkV1JraU5P?=
 =?utf-8?B?cEs5U2FJamY3SktjcmkvMFNKSzV1VTBLOFg3c3hhb1NsVVJtaTFHNzhZWUVC?=
 =?utf-8?B?a3g5bzFnTWwyQ3NEaTFPUGxVY0tpTEhmUUJOdHljbUNuSHM5SEwycTVrcHJX?=
 =?utf-8?B?RERneUdpSFlDSUUvcnk5YWFhcUpwOHhKdWZWSVExZTF5Wnh3RVc4ZVZNZXV5?=
 =?utf-8?B?QXd6SEhRdmhHelY1b2JrR0pidjhXUjJTVHJFOHBYSFhVaStLQXgyY2hrQ2dn?=
 =?utf-8?B?bkxPODhadFMwM3BIcGZ5ZjRLL3NSNnB0RGszYVlTTTE4Y1htNFRCNWlHY0NM?=
 =?utf-8?B?WVJkVmRkOFlTSXkzSzNzREZXb0ExMjNObVdRRjJ0UDFKdWpzbVRUUDdiTGRo?=
 =?utf-8?Q?GSYXCWZ6VN2VVrOAG5+APG/19?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7f7193-2daa-45e7-4fa4-08ddb332b89e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 15:20:58.6334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nwRDGwXWCRTg7BVnZTHGg2kRKXHVQgwMp7oqBObdkQZ09HwknGIyTd2oJA91Z7MBx4YW3QiweuaH4tamfG3Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6115

On 6/23/25 20:41, Alexey Kardashevskiy wrote:
> On 21/6/25 05:20, Tom Lendacky wrote:
>> On 6/17/25 04:43, Alexey Kardashevskiy wrote:
>>> The __snp_alloc_firmware_pages() helper allocates pages in the firmware
>>> state (alloc + rmpupdate). In case of failed rmpupdate, it tries
>>> reclaiming pages with already changed state. This requires calling
>>> the PSP firmware and since there is sev_cmd_mutex to guard such calls,
>>> the helper takes a "locked" parameter so specify if the lock needs to
>>> be held.
>>>
>>> Most calls happen from snp_alloc_firmware_page() which executes without
>>> the lock. However
>>>
>>> commit 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation
>>> when SNP is enabled")
>>>
>>> switched sev_fw_alloc() from alloc_pages() (which does not call the
>>> PSP) to
>>> __snp_alloc_firmware_pages() (which does) but did not account for the fact
>>> that sev_fw_alloc() is called from __sev_platform_init_locked()
>>> (via __sev_platform_init_handle_tmr()) and executes with the lock held.
>>>
>>> Add a "locked" parameter to __snp_alloc_firmware_pages().
>>> Make sev_fw_alloc() use the new parameter to prevent potential deadlock in
>>> rmp_mark_pages_firmware() if rmpupdate() failed.
>>
>> Would it make sense to add the locked parameter to sev_fw_alloc(), too?
> 
> That would be another patch then, this one is a fix ;)
> 
> and I'd probably just ditch both snp_alloc_firmware_page() and
> sev_fw_alloc(), rename __snp_alloc_firmware_pages() to
> snp_alloc_firmware_page() and just use this one everywhere. Nobody needs
> page struct anyway, and the locking will be clear everywhere. Also do the
> same for snp_free_firmware_page().
> 
> It is just that snp_alloc_firmware_page() and snp_free_firmware_page() are
> EXPORT_SYMBOL_GPL,
> 
>> Right now there is only one caller of sev_fw_alloc(), but in the future,
>> if some other path should call sev_fw_alloc() and that path doesn't have
>> the lock, then we'll miss taking it.
> 
> I'd rather just ditch sev_fw_alloc(), does not look very useful. Thanks,

Ok, I'm good with this patch for the fix. Can you also provide a follow up
patch(es) to address what you've discussed?

For the fix:
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,
Tom

> 
> 
> 
>> Thanks,
>> Tom
>>
>>>
>>> Fixes: 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation
>>> when SNP is enabled")
>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>> ---
>>>   drivers/crypto/ccp/sev-dev.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index 3451bada884e..16a11d5efe46 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -434,7 +434,7 @@ static int rmp_mark_pages_firmware(unsigned long
>>> paddr, unsigned int npages, boo
>>>       return rc;
>>>   }
>>>   -static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int
>>> order)
>>> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int
>>> order, bool locked)
>>>   {
>>>       unsigned long npages = 1ul << order, paddr;
>>>       struct sev_device *sev;
>>> @@ -453,7 +453,7 @@ static struct page
>>> *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>>>           return page;
>>>         paddr = __pa((unsigned long)page_address(page));
>>> -    if (rmp_mark_pages_firmware(paddr, npages, false))
>>> +    if (rmp_mark_pages_firmware(paddr, npages, locked))
>>>           return NULL;
>>>         return page;
>>> @@ -463,7 +463,7 @@ void *snp_alloc_firmware_page(gfp_t gfp_mask)
>>>   {
>>>       struct page *page;
>>>   -    page = __snp_alloc_firmware_pages(gfp_mask, 0);
>>> +    page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
>>>         return page ? page_address(page) : NULL;
>>>   }
>>> @@ -498,7 +498,7 @@ static void *sev_fw_alloc(unsigned long len)
>>>   {
>>>       struct page *page;
>>>   -    page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
>>> +    page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), true);
>>>       if (!page)
>>>           return NULL;
>>>   
> 
