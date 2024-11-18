Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BED8C2F2
	for <linux-crypto@vger.kernel.org>; Mon, 18 Nov 2024 01:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731892831; cv=fail; b=XV8R2cGJtAuvHRpNwwTmoL5i14p+LJVKa8RGLDzuR8uIWwhDS4oxYqH81p/uAxW8GELREQudhZibxHtQiC4Y0F0yF1/XZTBm2oSywV9CG26YqEM999Y+pAlRoutgQzZ+hJN2NctVjuXEOSoRcCZX1E1M7AMn7bLuJ/iG9Tk+npU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731892831; c=relaxed/simple;
	bh=bvJ2v1CelXThuxOyBTC7PvBj2dBkyID6N2p9mQWFKkg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GRIEdlENRCTnzjCNrLQFO5CMxKiFeEt6JSs2UpRIj2MF0i3xUdsyTKnFv5oMrsxSflwU4FYDetHHw2g3lztFxVVAEsY8Ioj6+5TugU9VGdFZEVDLr7ewq7zFi0BVdKgCdsvxAm3UbaEkpF9NkD4jt+02mhh6omsdwhronxUr6UY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eRB7e1Kw; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eRB7e1Kw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THLeyfiGB3bRrOZ/dozdEZtadwgQhqloIJV+yWNa1SZDl5qsuOBPjRB+uHbU5Ixt3VPAkpoR2l/81i8BKIuYoZRlkCxirED5hGTTi72YCxhI3xOTharsPVevFBdNLiC+5sytdQY5ckSrcnJI137z0hZr/mzd/S19vm0dZdmhi/biR3CEWy6uwFEk1e4aRZzaMR/6r3tZlnUFIZg1vgnctJiooBlw/uZWPph07KBoS/1mlvBFhBUDIlhpDCCPRgQhSgI+ofhZ0sy/+anmbyrudPJ047UgRzbJlrnanOIbog7xexK9/qQtqYmTiTGT5R98bbX4sTspEMXkNUl3/nGj0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lF8xpnIAp5/nCzRZnyd0B8/6WRk2d7KocQMCpoMQpus=;
 b=iMXMw9GUP76e7qaiPOjNwJHH3qQGmMFBwB87ei0FxiQri9Er+pW4atXRH24F5kxpJ8oK8WXlbp9YqkZS5gyE9VFE6l107U7E1pjbEkBTeUJUNEYV3Uz/0EUYbKJvm6goB+Y20Q5vRbd87GezS42gXWrTLYhzlOvEe4j66t2O4DnynKKfg2qN6UJRwNoZ5RoDLlhMhEkB/SRTfflA0Qr4BZ4FvPohXNByOE5f5DFrLeNBCzEI+BhURwQcNTq+BW8rdZXRrox8AEE/X/UOmAKV/ZIvGDxI6YTUbd3trIND2zQwnpDfmWc9G8H43shSyjLkyPjaJAB7+dMjsBYPIfy32w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lF8xpnIAp5/nCzRZnyd0B8/6WRk2d7KocQMCpoMQpus=;
 b=eRB7e1Kwv0m0JhLfibJ06MF7BYsd8HSItM8CN18HW/oDP6h7w8ML4XbjQRceHhZVilA/mjE6pvEncmJ+GDQxQG7u28uk93qaovlmwrA+QBnfqjLurYep43j4Ja0Hx8c8hEIZ8pSLtsjN6VmRkiRjimBaT60rhymLgHumq470koI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN0PR12MB6198.namprd12.prod.outlook.com (2603:10b6:208:3c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 01:20:27 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%4]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 01:20:27 +0000
Message-ID: <ba984939-ab50-4450-a3c6-7b8845de1ad8@amd.com>
Date: Sun, 17 Nov 2024 19:20:24 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: CCP issue related to GPU pass-through?
To: Jacobo Pantoja <jacobopantoja@gmail.com>
Cc: linux-crypto@vger.kernel.org
References: <CAO18KQgWZ5ChFf3c+AgO9fneoaHhBEAOcfUmRFw80xLnE68qWg@mail.gmail.com>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <CAO18KQgWZ5ChFf3c+AgO9fneoaHhBEAOcfUmRFw80xLnE68qWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::7) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|MN0PR12MB6198:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c87cee8-cd64-4c09-bfb5-08dd076f2f0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3JVQW1QQm9jZFI2OXhLRC9Hc0x2VDhnT0NvcmNaYzhLQWt3bnhUNU9wdE01?=
 =?utf-8?B?QktoQ00zUVZFV2VxdTlEZHF6Z3RBOURKcXJvN2tsdXE1a2hzSlFTV2R2dkFV?=
 =?utf-8?B?aXA2ajBGVE1YeTdTN2tVbGZzblJwUWFUZmQySWlac2NQT3c2aHRXdVV0VEhk?=
 =?utf-8?B?ZFovcWREVi83cWtZZlNnOTdiV1AydkxiYk5laFFEalBOeUZHajdBdDFucysy?=
 =?utf-8?B?aWlEMnIyQjBSZUcwc1cxNXFMNXUrbC9IbjV5eHNMelBQL1RxUmhaOENOM3BL?=
 =?utf-8?B?Wm56cVQxK3NkVThQWHhMZ2l6djJ5SlRIV2k5d3YxQm1aWXczaXJjYTNxanFq?=
 =?utf-8?B?dmM2TWxqWCtIOXJQWGZ6dWFOYkhDMUZtbWpvNFNyK29xSjNQeUZLNFVIRC9s?=
 =?utf-8?B?UzB5Smdzdk8zL3QyNklHcWo1bmNzNGpLaUJ6N2taVzNuUTNTaVkvSmUxL2xv?=
 =?utf-8?B?c24wbXpyd0dLM0hBeGpzNFJoUTdWYnJHYWxFelM0cURibjR6aUR0NXFYRHZL?=
 =?utf-8?B?dzBPVEs4NHEzU0JmRFBMT1l6S0R0aXlLTmFLM0FLZzRCVnBxcmRQaVhGcysx?=
 =?utf-8?B?UW9VaUlDWURrcElWTzY1cy9UdDZVazhMZ2swZ1dRekpDTUN2clBWeHBtV0M5?=
 =?utf-8?B?aTVDYlhlZVVMR2Z1blVjZU85alBPV2NySHAramptSWNQeHBqNW5jVHU0eDZD?=
 =?utf-8?B?aStDcGt0cUQ1WURxMHBjWThzanZoRCttT3ZMSDNhSld6VFpvUUd4Z1dRQTND?=
 =?utf-8?B?RXgreXBJQ0JtNWFWaGJ5OVB2UW1EaFByZDNoNE93Qm8wVVdRVGNNcUhtSll0?=
 =?utf-8?B?NHR4dmZRcUxBMmJ0NXRMNXBmYVhKMy85c29sZXhPcnk1UlBGcy9XOFBjTmwr?=
 =?utf-8?B?UkFab0wyNVlQUjd3bWNrSHJuTFZ4UEVvRGUwTDY2ZVpkTEZaMG9HQ0hKK0N6?=
 =?utf-8?B?WGo1cUpzTUxaenRQVWhXdWRITmp0OE9wbVFja1BDbDR2aGpqMlFuRWplb05j?=
 =?utf-8?B?UlVSOUw5ODNNaENlU2dMQWlNQXBPRml4ZlI1aG5kWGRRRXk4NE9oREQycTFY?=
 =?utf-8?B?RURCcXRZbjFlcm5pNFViT3dERHdnSlRqZmkyS3M3Z0RtUWdJREd6L0FlbGt1?=
 =?utf-8?B?dW9uUUhrZ1YveEdCN2xoNlpCRTh2VG8wQlRTTm9sVkhVZGs4dzlZeUR5T3NL?=
 =?utf-8?B?UVI4ZXdjdDh6a3JKL1hRbFdYbmJvWHVqMzFGelVHQmgzMkhkS2Y0V0dJT2RC?=
 =?utf-8?B?SXVhdEZiblloYklHbnVnNERWNkxLd29zSTA4b0d4ZWxVVkgwam1TcGRiQ1Fx?=
 =?utf-8?B?TW43SGRLa3BIVmRzOHlCdWE1K214V3VGQ0grTmIzc0xMVG5PNk13amhxUmtX?=
 =?utf-8?B?Q0xrZnhOWi9MeGZzb1UrY2JCRXpkbWU4SHpuM1hOZWxmcFNKdjlLU1lPcGdS?=
 =?utf-8?B?eFJaOFRTS0Nid1FJeTdNZm0xTkplU2xKeVJsSFZUN1NHT2FqSVk2S2ZPL09p?=
 =?utf-8?B?QWZFaFZhN2l1YjVtempadEFBR3NNQ2FSR0xWUER1N1YwbTVkd2UzcFg0a1VF?=
 =?utf-8?B?ZlBldm52OE9tSDZ5OHhycWUzZFRSdWtlL0NtbzN0blcrNFprdmhCSUJ3SFpY?=
 =?utf-8?B?TmI2U1pLTXRSRzJoODN0WVlzUndBMGtCOWFVRkJlZlV5YlVFZUVieExuWitk?=
 =?utf-8?B?M0hGLy83UmRUOG9IUi83bDFRMnpvOHdkc0l3RkpRQmlCR0FsYmhDNW5YenV4?=
 =?utf-8?Q?E5qEp5zx4uB/au7SzrE/U1czzn1jKnnDozxKhkV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGlvbUNrZGZ1czhtZURpS2hpc3FzK2ZoRWI0ZzNpWlB0dlpidjJyU2FSOVIv?=
 =?utf-8?B?QkVMR1JmRWNXRCt0QzhqVFF3TEE3eFlnSWFGYk93K0Fjc2JhaEQyTWJSdlNW?=
 =?utf-8?B?Q0p0MVRlVy9WbHRFL3ZwSytWM3ZDMkxPamQwKzJmblNhTXJQSngxWUhrUHZa?=
 =?utf-8?B?TG4xOFFkTDFTa0hjQ3B0cmhMVzFwdjgrdmpGMW12cG0vWjZCNEtrMnQ0OHBX?=
 =?utf-8?B?dzdTRnRWUFdMSVpLWFFxTGN3M0wxY2l6Rm5BZVE2QmRnaFU5Q2RUV0NvV3o5?=
 =?utf-8?B?RGpkMnArTkw2NXVmVmdyUnJPajEyWTlsbjUvNUdyRXVpejFoTXB0TU9GdU5Z?=
 =?utf-8?B?THprSHg1WDVHbkFUb0ozMHZrbTZySGRRQnREeE8wRzcyYTlCNzBTRWdZN0Rq?=
 =?utf-8?B?SkorcjRNZy9EOGc3VE96MDVjSHU2cCttTWRTWmdYY0VnWEZQTUIzK0h3Vm5G?=
 =?utf-8?B?bG40TVpySVBTeTVud1NRZ2IwM2tSNGpSV3ViZ2U4SHJzdE9UOEoyclU4cHc2?=
 =?utf-8?B?TTI5bEtaQk9VSkt5V0NkaWdLQnhqWUJGbDBmVWFsNmVpWXo0WDJZeWY5UnNh?=
 =?utf-8?B?TXBCL0Z5YXpMSUVXSFNnN1M4T3pZbUhKN2FKV2t4bXpGaGdNQnY4WkFydFJa?=
 =?utf-8?B?Qkw4R2xIazhSUWVUY3pzQ2pXRnQxTzdmTlRvdnRCbFM4NmJ3WVpDUjN2Mkpu?=
 =?utf-8?B?NDhpdklXSzZ1MG5pSTdoSnFGbXdROFpKeWxFR0tXUjlsU05kNE9TN3BrSjZn?=
 =?utf-8?B?WEhpSm44KzN5OGZJZlMwUHVHZlJHWjNXMUR1ZnhYQTR3SVNUMHpDMGlZUDlJ?=
 =?utf-8?B?UGlYYWhBUWV4aGR6RnFybWVTbDR1NjZKL25sS1VnNjFxb1pZam14SC9EQVc3?=
 =?utf-8?B?SmpIbEJNajArMnZxeDEwa0JDT044RW13cFQvb3FzMXZQSndMR0I2QnVoaW5E?=
 =?utf-8?B?dm43bGxvTXk0NjQxZDUzNVNQdXZmYmZGQUJReFgxN1gwb2twYWNKMWlJdUF3?=
 =?utf-8?B?alRqNk9jd0o4VmlsTGE5bFZKNVFRNkFwTkltZzhKeHBvY3FLbGE4UGNmWDJP?=
 =?utf-8?B?S2lpSC9zSmtqYWJCZmFQclJyM3NQa3RhbTdoclFwakpaeXphelhNcUZQZ01K?=
 =?utf-8?B?S0tLVUY1ejBVM1Azd0l5dWtLMytvNVdYd0cvSWl5RTZTY1VFd2tZbkQzcHU0?=
 =?utf-8?B?Nk1mNHpDK1J0LzBobW1sb3JhSVZBZXFTZUg1WUVBN29DUTVtNnpjZFMwVktG?=
 =?utf-8?B?dDR4OWxwYVJaSG5rMGp3WCtSVTBJTVNpenVBSHByZFNyY0NxQVZ4dzFWRFJy?=
 =?utf-8?B?Q2RXM1NhNkszSCtiU2ExdkdTOVFoV3BMa2JmRWVLVG9SajlGS3UyS2NveXBj?=
 =?utf-8?B?dnNaR2loKzRUdGMyNEJPYUtmV2dKWFJVVHpsR3k5K2hzMW8zRTRpV0tEdStj?=
 =?utf-8?B?Z1NJaXA3WENBMVVzT2o1bXRFdkxNdHZjT2svcklSVGk4ZVRiM2x2OVp3aTBG?=
 =?utf-8?B?NWRlRUR5dUQrVHhtS0F1Snh3dlFEcC93dld0bTFvMkMxSkd6a2svMHJtY255?=
 =?utf-8?B?OTd2V3hZdTlQOU1HL0U5TlRMMjA1S1R2cVg3bnRneGpxaDlvbUVsUlRNMHVH?=
 =?utf-8?B?akhJMGR0NVFwYWJwZWdyM09FZEpIN1c5L1R1RzgrY3dCWHE4YmZNVCtnT3pm?=
 =?utf-8?B?Q0V0VXJETW5haFM2Z0hOTUVTcXFDdWFRS29FanRhYU1oT1UzQzNnY1dOM1I5?=
 =?utf-8?B?TWRTMnJzQ3VreG02SGJ0RlBwRml0dFRJWG50TXFnclpDaUIzUGorMk9uSndM?=
 =?utf-8?B?YUU5aEJMQkRUS0lvTUp1RFV5cWsrN3J4U3hHT2pMSVNqUEc2OUVRNk51QmZj?=
 =?utf-8?B?czZySmllOWZYblZuV3JLekpmNitXVVlkUFgxYis1NGl2dnBuUGtwOVp1ajla?=
 =?utf-8?B?QVI3a3ZtWit4MnIzL3lBMW1KSVQ1MXFUVlFBVkFMV2RyNDVEbHJmNkpRVzJF?=
 =?utf-8?B?akNHb2RZT2ZISUsyWmJuTkovdXBKTFNOcW0xR2tYUk95QkpSZmR4ZjRPZGQ2?=
 =?utf-8?B?OTJRbTBUSWtwY2xSa1pGNjZ1ZVJvcEd1dTZCd0tsRE5wU2JqSXdnUS9ETENG?=
 =?utf-8?Q?G/TZO/CT1sA31a3wht4O/6JJA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c87cee8-cd64-4c09-bfb5-08dd076f2f0b
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 01:20:27.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHkJqqSqkP2Ncezrrqo3MBarbRLXQO5yq53SdeM8pwGpUcFqpzVBp7rfa9g+pzu8E5/MQujPsJixjz+z8ILhRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6198

Hi Jacobo,

On 11/17/2024 11:42, Jacobo Pantoja wrote:
> Hi Mario / crypto mailing list:
> 
> I'm trying to pass-through my AMD 5600G's integrated CPU; I can do it
> easily with Linux guest, but I'm being unable to do so with a Windows
> 11 guest (which is my end goal)

What do you mean "pass through the CPU"?  What exactly is "working" with 
Linux guests and what exactly is "failing" with Windows ones?

Is this related to passing through the graphics PCI device from the APU 
and having problems with that perhaps?

> 
> I've noted in my dmesg the following line:
> "ccp: unable to access the device: you might be running a broken BIOS"
> 

Are you trying to pass through the PCI device for the PSP to a guest?
What is your goal with it?

> Tracing it a bit on the internet, I found a couple of fwupd commits
> done by you stating that in some platforms this is expected (e.g.
> 0x1649) [1]
> Comparing, in my motherboard I see that the Platform Security
> Processor is 1022:15DF, being that last number in the same code you
> applied the patch... but I cannot understand whether the ccp message
> is expected on this platform (chipset is B450, if it adds info) or
> not; and if this could be related to the pass-through problems.
> 
> Any hints would be more than welcome
> 

Those messages are referring to some cryptographic acceleration IP 
offered by the PSP on some SoCs.

Not all BIOSes all access to it and it really is a case by case basis if 
it's expected behavior or not.  When it's not accessible that "just" 
means that you can't use that acceleration feature.  There are other 
features the PCI PSP driver exports such as TEE, security attributes, 
dynamic boost control, SEV etc.  Not all platforms support all features.

If you're just shooting in the dark for your issue based on the warning 
about the BIOS not offering CCP this is probably the wrong tree to bark 
up.  If it's actually related it would be good at least for me to 
understand what that message has to do with a Windows guest.
