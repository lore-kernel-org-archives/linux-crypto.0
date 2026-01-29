Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011029.outbound.protection.outlook.com [40.107.208.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08022D0600;
	Thu, 29 Jan 2026 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725810; cv=fail; b=iPNBm3XaaNQ5y1iQIR+Gxc6NEesT3ddMUnQKiXPsbQ67JlZonuBTCHemv4qiIRzUyqrLo0Q53kwchqUz0QUGQKBT8H4AI7cPildpo321fF/2dtK3t+vU+Jy13HAfOxwb8XqZ4gcJNXeYA0zwyPHaOuOlBJ8rFaspzOcCzpubkrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725810; c=relaxed/simple;
	bh=Crx0c/Tii8oZf477rEhEkHZ+uqq1IK7iMowwZwLrIlI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Bzd1l4lbeJ1YkzvhrkBgwarw4zGHHZFF+CnrcN0D44YLG5EWGRwRhtzYav+Du+oteQaMTeC1IyMD1UXs6qIpGzqJhhoDdNcTBaBXgsqrZzopu0bdyqpoKqbBASyxluM6XDN9Alw37VMtjvChkP/wOlpn3i7+A26daUz1LP7/DZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fZfexuEq; arc=fail smtp.client-ip=40.107.208.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fZfexuEq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NOxpQZ9NBKQOzVsYI/uVFZqRXOyThjfKrci5oh1cwc0Qk7dSuzORJiFDwr+2ycBsG+fZ0YvAHTX/YAFznTCYDAsASgGkqOJGoVMEqq3rQBpyAs78L5nJirMvjRo5lTZSAU6Z47fBVZ/ONZskrB4yos5nsZ5GGUdiuxOPMAWC9V7SR0JB3R7sTeM7klh6evY5QSJInTvV25lmjqjHWRZrYta+kkMnRk3oweICte6h9/SNlGS4nzXi5OcYtHv+kt/fgckd87aYcZjiYxxwFWS05h8CxCVO4dfJ3Aph14sncwPndGq8i6G94UqO4bBkA+0JTW/7AhJD3T65mMUEpRcfPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10OKLNsmE07Q6pmQ0kwr10UsKmGEFc9sxo5nZA9X3SA=;
 b=U/C+cJTZMC6idCRHRbUPH3mpSAEOg2tCXPxLFhGIQuIasULN5/IqMr9iAKdjCI5ulMTR8cuuraF/PQD0VAh+k7Us3sbV2OjhfpUtL2muWxRC64ITYRWi4GCK3hizVnegQK7K0nin3utvBORHn7QBsclQX3/NWp3E0gIRffFxoMTXj6eWyfdQ+Hi9FqoCqn6zO2zta7eUp19tnDuemMf04oQ3MhPsSVmFwbdHKM9wgM++XyROuhYxTpPfIsZYF/uQCn7CdkLWOViWSwWrZ5RJKhTpnS1D7OwPfKydNRgrGdnJNYcI+fwH71O1ADqxoLdbwlNPxEKZeHGDdHSebc8bAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10OKLNsmE07Q6pmQ0kwr10UsKmGEFc9sxo5nZA9X3SA=;
 b=fZfexuEqD6/ujETU445WJxYLFLvmY9B43eJ8sZ4yQOnuHWUlrL7HZYGXylLCWqCMPZLgogUZ5D2dhksb4mRDI5NOA/2SMDhj+5Ee2anzfsdlVUoF8Exe2lgiGyowGQWQDcB4VsZiKTfH2sYD1FzwOwqMZUU9Ur1nhHcaHNxnUjU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ5PPFD5E8DE351.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 29 Jan
 2026 22:30:06 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.010; Thu, 29 Jan 2026
 22:30:05 +0000
Message-ID: <ae86149a-8590-46cb-bdbb-726963f39455@amd.com>
Date: Fri, 30 Jan 2026 09:29:51 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 2/2] crypto/ccp: Allow multiple streams on the same
 root bridge
To: dan.j.williams@intel.com, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, x86@kernel.org,
 linux-coco@lists.linux.dev, "Pratik R . Sampat" <prsampat@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
 <20260123053057.1350569-3-aik@amd.com>
 <6973fd402a74a_309510049@dwillia2-mobl4.notmuch>
 <196ef0d2-93ac-4872-831b-e803e02b5d95@amd.com>
 <6978626886a50_1d33100c1@dwillia2-mobl4.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <6978626886a50_1d33100c1@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P300CA0019.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::27) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ5PPFD5E8DE351:EE_
X-MS-Office365-Filtering-Correlation-Id: c9991e6e-1f7f-4fe9-da39-08de5f85f380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDdKSnFjQ3FkZnVrLzZQNUJjaFdmdlZTZ3ViZWNJOHYyd21ybFQ5a1JiQWt4?=
 =?utf-8?B?ZVRJQzBqUlJZR2JsSWNEeGhCM2RKWkEwQThEV3RaUVprUW44ZXFBRXhFWnNM?=
 =?utf-8?B?NkZSQ3FLSnEwZTFQRTUzNXRhZ3gwZEt2alNRRkJrY2Z0QUVpS3Y4bEhqZkZ1?=
 =?utf-8?B?bVpXaktGTlI3SDhBeVZreStJbzAwYjMxUWF3T0U1STVndDdQaVRFMTIzQ3hX?=
 =?utf-8?B?TmZJQzYweW5mdWFzajVuTE41ZG9MMDFpQURGNU5IU1E0SWR6b2dQcFFwTVp6?=
 =?utf-8?B?WFRiM3hwSDZXY25DSmZ1Ynl0amFDMkJBZlAySXdZa2NxTnFOTzBFeUx6ak5x?=
 =?utf-8?B?M0FLKzFYWVp5akZtb3BxTHRSSms0Z0p6QWpubEZZbDY2NXlKWGtIOGdaOG5q?=
 =?utf-8?B?OExQMTVYZWJJTTVTcGs3dnhOdUFEUnJ0VHpiUVVqbURFVGJZQ2xHbUhDU2pQ?=
 =?utf-8?B?b2ZROE9pU0p2VnJsd3Y4NWlYQ0VtbmxBOUZKelhIQ24xY0dMMjFEdWRoZllr?=
 =?utf-8?B?WEM1Y2lHd0l0SG9QNyswTzFZWlFUdHlhdVZmU2drSWpkWTA3anJWUUpoYVEz?=
 =?utf-8?B?NDNUekdyQktkMGs4Qk4zK2ZFcUFsaFZFQ3c3RDZ4ODRUYjhlZUhOSFFsaExB?=
 =?utf-8?B?TStpK1I2UVplc0J2WERaaWoyZ3JGRGVFbkltUEVUZXNZYzFKYkpJaUplck1w?=
 =?utf-8?B?MW1MVU1DTlVLSE5FYlFZUnRTWFB0b0V5ZHRvdXlENFgwNWgyY0RPOXh4RHBa?=
 =?utf-8?B?alo0eUNVbkkzWlVnak1lYjViMHQxUGFDRm02RmNnU0VLTzZVTkRMZDJFaWFR?=
 =?utf-8?B?bS9qbWd6TXRoMmhUZEU5WUJwQnJQb0s3cmw5Tzk5WnViRTh4QklLRzIxZ3dQ?=
 =?utf-8?B?NEdQOVd3MEprS3JkWmFXRW53SWd0c1F4ZW5obzBuUndiVkh3b0VTaEhUMDN2?=
 =?utf-8?B?b21GT3U3WGRIVTFNaDBtR3g1NmdENjVmMDZtSFpCN095bzMwNHYzc21aNHdC?=
 =?utf-8?B?YjF0MStxTmVZU1VuTHFQVk91WE9lWWxYclZXMHpWUThQazNwN3N1TjR4NVcz?=
 =?utf-8?B?eDBOL2trWllrYUZIRkQ5bmtzc0pGcEdNSUFBK2lmK3pHc2xLNUJQNERkc0o3?=
 =?utf-8?B?SE1VcUZBdU1wU28zcHNFbGRJQTVZZlRxQVN4a3VNb0JtNUR5ZU1TUDFmYVRL?=
 =?utf-8?B?SmRRR0c4Njlib0xtaklhM3FHT1hsc3hxd2YxUFRMRlNmbmFLS2h5TExiaXly?=
 =?utf-8?B?d0hhZVZ5eWFJL01ydXdjalRUQlR5TUNxcWtxZFBFcjBtcG5mRXBZRGtTVTNk?=
 =?utf-8?B?SDBMNThYNUdPRDBPTWRGUUZrbXRQQ21TbDhYSmw2dzJKdTZqamdObFR0Ukpx?=
 =?utf-8?B?cmNSOHp4RE5NYUthWW85UTMrTEpjZWdadkh2VnNBR2F3MUE3ZThkOTIzWTFh?=
 =?utf-8?B?aEdVYVdXbnI3VUNld1lYKy9VNlEyWUZUaVQzQ0FBbG1yY1FsWk1IRDRaZHIr?=
 =?utf-8?B?KzRrKzh3SnY5S3ROaUxOUUVuN0x0emZmam5EbXFEbE1OWXRyRVVweXhaY2lt?=
 =?utf-8?B?bktja0Z4MHVlU2VZd0p5OFJHMUY0TUJVN2cwd28yNmN0bmNYYjNJalJPa1Ri?=
 =?utf-8?B?b3k5WVp3TS9oNk44VmlSQ2dyRGxNcVNoa2pYY0pNdDZKWVQ1UStRQm03eHU2?=
 =?utf-8?B?L2U2MkQ3WloyMHRUZ2RJSHJWTlFKVHI3aHR6SW4yTnptUmdDUisyVWpnWHc5?=
 =?utf-8?B?ak5LbFZVNUY0VlZ2TDJzeWZGZVRqbDdpWERSZGxGQ2NOZnUyakk5NWZJY2Jt?=
 =?utf-8?B?YmtkdEYyRDNHUmdXZEludERrOW1MRzd4USt6Vk94WS82ZVhCcDM2S2VhME1r?=
 =?utf-8?B?ZytuQVAxc293ZzRnZlBOWStnZFk2eFR1VkNiMER4Ynd3dG56Umw1MThoNkkz?=
 =?utf-8?B?Y0J2SnVZbCtBQmtQS2x6azJidkg4eXV0TWxmQ3pqN1Y0SjlWbnNEd2J1NzdL?=
 =?utf-8?B?M2oyTDE5ZlQ4bm5XV1FZRmphUjhYYUZNRk5lVnVIQjdidlhaQVFxMFMxdUUy?=
 =?utf-8?B?WFJpazB0RXpNM2RlVjV5TmhXSC9HVGlzeXpvKzQxdGxpVWxzb2hvRW1Tdmd4?=
 =?utf-8?Q?DuYo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2xlTUFsd1c3ZE1XckRwSnJSNmVLenZZV0Z6amFyV3I0clNnL1lTNWswaUVm?=
 =?utf-8?B?SWlGWG9CNEI3Qld6Rm1DN0hsUHBxR2RsczY1NGJVZFRMcXNud3hMMlBzSmg2?=
 =?utf-8?B?cUQ0ZFVOTHdENzZtZWhjeFZNZ3ROV2xZb050VnFncDM2REJDSjRGbTFqZUNk?=
 =?utf-8?B?bituR29sbDUrMkFRV1RmWVlLd0xpTHFYdUY4ZlJPVjd5WXM1Ykp3akNJNkQy?=
 =?utf-8?B?MXh3RnU5VVNqRlVmczhLZk0ycVA1M3pnZjE2dE5XekQ2V2pEZWg0aUR5eFgr?=
 =?utf-8?B?LzV3L2cwYXFqRnppSDdENDVmd2ZCbEJxMmRwRjR1N3hhUXFFWlpmQXdXOFk4?=
 =?utf-8?B?ejJHcjlnQnNmc0Zoa3ZvQmV2anJIWllmTG5zNTRXbDBPUDMyWXh3d3k1ZSth?=
 =?utf-8?B?b1BUNlZ3Rmc2ZFZkaGZtY2oyQXM5bTR4eFByL2VRUGhMSXpKOWZhbHIrUnhS?=
 =?utf-8?B?aWxKcEpLdlJPQnpKdlJWdUR2bnpiVUhYeTlDRUg3WkFSc2JTTWZnZGlWQnJV?=
 =?utf-8?B?QWlPTWZ1bjlMM2pYNFJYOGs3cVN5UitBKzJvSEpCbzB3djFIVXAyUmVIT3Nn?=
 =?utf-8?B?R3orN2VCV3JTS2xpcU8ra2YvQzhQd1RSOG4rWW1hdFBGbkVFRjFiUWRrNmZa?=
 =?utf-8?B?MDVicXNmYmJhMVhIVmwyOXc3bUhOSDU2TlBBUlhLV21RNXQxaXBBTEtlV3Zu?=
 =?utf-8?B?Y3BKd2FGaFNnNVNoUlRSRURkT1MrQkg0aitiZlBGdG1jSkVTekZZOE5PQXpp?=
 =?utf-8?B?ZzZZM0RYZERFd2NiVW05R1hhM0F3bDhyWUYwUFNzb1pOQkJnYTdvcFVQQUVD?=
 =?utf-8?B?WmFLVnpFYlJBaE1sL2M2QVZXU0pBSEZaN1NYOUx2bUxuTCtia3VHWTByT2o3?=
 =?utf-8?B?eklOM2hXQndzVGFDamxySjdRVjhJSEtrSk92ODZxWlZwbG1uZE9aUFhBQUty?=
 =?utf-8?B?SmFyZHJuTUM4S0NGQnQvblhLYlhCMVhZSlhwdTFQQy9TeGhhbFp1NS9tYW44?=
 =?utf-8?B?K0lIN2VpbTQ2VXoyenp4MDJVYllkcFZvMUR2NzRHOUpiRE04QStPclNZcE43?=
 =?utf-8?B?cW9COEV2RVZmQzF1U00yMTZFekZXK0dKOFNQSjJ4S29UZXhZa1BUNEJaNURO?=
 =?utf-8?B?ZFQwc1d1T0haTXU4MzEyK0UxOHdpbVVHTDlFRHZhOTRkY1dHZTNma2VNajhw?=
 =?utf-8?B?TzNLUjl0RlFLZnFOVjZZb1JLZUlCRWE4NGVCR01WTVZWZUpwem1SQ3NLNDNE?=
 =?utf-8?B?Qm9hWHM5VUVOVGVVRWwvQ2hXVWRybmRqL0FhaDI3N0hLaFR3TlZnNWVVbVpx?=
 =?utf-8?B?TGhDZ3BvN0kyOE12WXMwUDBkcWhWSXJJVmc0VGFXb3oxZ2tVWlErYVllNzV2?=
 =?utf-8?B?bEZqY0gyRW16Z3lGanhSQlo2T2I2MVNRZG5KUExCZFlucVpXWXFBcWpwV3J3?=
 =?utf-8?B?NHpRVkVINlBScnRKRjNPQXVyR1RGdmlWanlxMGdTeWkvNXQzRzYzd3pqRGli?=
 =?utf-8?B?Uyt5NDgxSGZxZ2NTL00xUUNXTGI0ais3ODRsQkdBUE5zVVlxbFY0QUw5VFF3?=
 =?utf-8?B?SnRHaGVWZHI4UWZyU3IyL3ZoZVdlZTFXWTkxU0Jjd0VYWmxMS3BOZHV5YytT?=
 =?utf-8?B?ZFB3d3lPUXRiQzFOY21Tc3ZCVEowUTg4aFgwRnEvd0dJR3BaTWYzSDZHUkpS?=
 =?utf-8?B?OXl5dmNUamlTWTJSR0NrUCtXUXgreS9GU2NsT3BlQWtPN25tWGo1bndxbmxN?=
 =?utf-8?B?Q1o4MFBtYjdkK2VGYkpOL2hhOC9OblpGb2tjRGhCWkpWU1lTTWNGaU9ZdWNm?=
 =?utf-8?B?ZXpNZXFqRDRWZjFwZU50TzlNRDJwREhUanZ2S1NsbnFheERiYWpmK3pTdWZw?=
 =?utf-8?B?MXRaUlB2VjUyV25nWXJER24xYTRwV0NkWGt6bm04aHNBUVJjUWxaZkdqQzRp?=
 =?utf-8?B?TDVvOXgvbkFDZzBRUklHQXRqNXBJK28rN3YydUFSay9kWnRFZWw2N2UrRktm?=
 =?utf-8?B?elZYbTNvUytsSjhnTXZaUmtGbW5QZ3lYYnJ4VFU2Zkp4dHBHMzF3bmNVSkl6?=
 =?utf-8?B?blU5eVV1b1lMT1dsZEI3cWh2K0hTSkRuN3g3T1czSFVJWlVCenNFUVJGL0hQ?=
 =?utf-8?B?QkxFM3pCRURzN1NBNWpKZm5EV29SMjgwcHJDZ0hZMXJGc3BNMHlYaHNxMkhi?=
 =?utf-8?B?NzZsOWZ1MG02YjR4dUZiRHRON09tNkNtUGJxalMrWEhMRFE1cFp6NS9kY1VH?=
 =?utf-8?B?VWo5dEtHd3BITG5CSmdTa1hya3drMm9qdGRwT2tCNFpKRW82d0V0c3dXZjRQ?=
 =?utf-8?Q?wDb7ZT1vK+hFlrcIsd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9991e6e-1f7f-4fe9-da39-08de5f85f380
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 22:30:05.7656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdzVkCFEQyJRfRtgKYzuQJ7rhbH82NuZ2KARKzHMdpE2ma0B/hSYmeVBkIo7J6JKIo+8febM13z/HG2bb21O1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD5E8DE351



On 27/1/26 17:59, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
>> On 24/1/26 09:59, dan.j.williams@intel.com wrote:
>>> Alexey Kardashevskiy wrote:
>>>> IDE stream IDs are responsibility of a platform and in some cases
>>>> TSM allocates the numbers. AMD SEV TIO though leaves it to the host
>>>> OS.  Mistakenly stream ID is hard coded to be the same as a traffic
>>>> class.
>>>
>>> I scratched my head at this comment, but now realize that you are
>>> saying the existing code used the local @tc, not that the hardware
>>> stream ID is in any way related to traffic class, right?
>>
>> When I did that in the first place, I also wanted to try different
>> traffic classes so I just took a shortcut here.
>>
>>> It would help to detail what the end user visible effects of this
>>> bug are. The TSM framework does not allow for multiple streams per
>>> PF, so I wonder what scenario is being fixed?
>>
>> There is no way in the current upstream code to specify this TC so the
>> only visible effect is that 2 devices under the same bridge can work
>> now, previously the second device would fail to allocate a stream.
>>
>>> Lastly, are you expecting tsm.git#fixes to pick this up? I am
>>> assuming that this goes through crypto.git and tsm.git can just stay
>>> focused on core fixes.
>>
>> I was kinda hoping that Tom acks these (as he did) and you could take
>> them. Thanks,
> 
> Ok, so can you refresh the changelog to call out the user visible
> effects?  Something like:
> 
> ---
> With SEV-TIO the low-level TSM driver is responsible for allocating a
> Stream ID. The Stream ID needs to be unique within each IDE partner
> port. Fix the Stream ID selection to reuse the host bridge stream
> resource id which is a pool of 256 ids per host bridge on AMD platforms.
> Otherwise, only one device per-host bridge can establish Selective
> Stream IDE.
> ---
> 
> Send a v2, and I will pick it up.

Please squash it in the v1, if possible.

Acked-by: Alexey Kardashevskiy <aik@amd.com>

thanks!

ps sorry missed that on time, I do suck at multitasking :(


-- 
Alexey

