Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B999224B14;
	Wed, 12 Nov 2025 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762961446; cv=fail; b=RbXvTRmoEgSUoe/r7n6QBt8E7F9ENiSV7VdAwvW0mKxyXjHo5k4sfkiYDP7NCRaBYIf5iGmjyIM51HurYwEPdfhnnDrur8hn1HIZi5ob6e+tWgYK91c/MZc3aZO+j2StP4gh0thKs0Pq71W0JKXnoDtsaw4X1FP+rWn1gr5eeRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762961446; c=relaxed/simple;
	bh=4I+AQ4wSh6bxCEfqB23jdjx+KC4GUcTOI3FGat0rJ7g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ok6AOH9+jCto46oZBZQEMju5dlksQACCG+wE5SrHQMqUH3DJzyB2Vj0ka+ot618Wuq0oNqLgANQXvXeYACu1iPzydp8GoGWCwaK5zmPqxKyfl4rLgDrJt1cdkFiWYQ/5oBPjExGca+95vMkEK2PYxES6S0wIVLBZaoBgO0p4bHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qEqNJ7XS; arc=fail smtp.client-ip=52.101.56.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qEqNJ7XS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6+Vd15SYDxPHC8WxHGFRs5mUbIMzyxNV0h8cIMYNlAfTyy2CYR1vfaGwSnSBYHML3+Ge4QsHEdznU+jwG1DF/nH1GGqPIU12+z/EmkesgAzVQXhbVnYDDnSgHz+8Gf4RAhPKqxaZaZRd87EWpwjA56HRFJDu9cf8ANi4K6K4jRUkbh8mwxyBOA/nQCBtQuKFEmDZI25HBqPPUeiFFAJdo4k0aGX9L6yh40AwdrBRM726mIbJvPo7gspMqhfDhxJJH9MHO4CVe3GZJ/1dy9IPo+RqrViSMEv/qMy9Z3mFC6guQ7DNHRc3Dir6D7Zm35rY/nFuGVkLHchcQ6k238mbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I+AQ4wSh6bxCEfqB23jdjx+KC4GUcTOI3FGat0rJ7g=;
 b=K0hV3CabFKtug9YgZrh6mTaulWJDv0dIxynF0iKdnlR4Eu2Dzsu7HsRc3RjwhR8CTRbe3jL055/WbNfn13r91FcyBalFby1XbUA5zFkp5mODPibdba76sEV205Xrm2yfv8rCfMUUGa5ANNX0J9ndScSZ/cuypYCH+VGo4nWV1oliFgpGYW4vH+VCAJ3zEtayCIMNRxCBvT42HFMWqP0x/MNUxW7q3KDSmyeb4XVJdcISAA3xEIXu4B/UKMHCbkxssSXmJqXjsQ+RRHtliL06Uh35KWVcS6MGXcpqU/tdnyNLRtTzCV7tJL8BpdvXsL46XXS7y5yH5EEG+4pI/NNkCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4I+AQ4wSh6bxCEfqB23jdjx+KC4GUcTOI3FGat0rJ7g=;
 b=qEqNJ7XSlrUpD6vddx7JyFgGTvEQisJWxmjqVLKoIPUTJm8pZcNtHspTpxXWkbBoK0bcTIwMDUg77qRI8pjpuK0YyVk0svBSg8uXcb0DRnwo3f1RmkoWaS3uGu3XiCRDJoSDrUfds+WfOObvR2b5xVv2vhJRYCqmuZSvnHIl2vSypR4V1zgUK0/vMOUdNPASbqD7FsBjiSfSPxhPcwfK0nnxQcWuX5ujH17G6YtNqdMzcMm3jr8rj8eD7N+GQHkXa1s+T9q37SeZQls0AcTF8i9VplI+M0dkqwZAnw7b17mth82aUgyNbxDftjEgw47JXss3dfnjVQ7KTWomwc9lMg==
Received: from BYAPR12MB3015.namprd12.prod.outlook.com (2603:10b6:a03:df::14)
 by DS7PR12MB6022.namprd12.prod.outlook.com (2603:10b6:8:86::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.16; Wed, 12 Nov 2025 15:30:40 +0000
Received: from BYAPR12MB3015.namprd12.prod.outlook.com
 ([fe80::db88:47e8:4619:e06b]) by BYAPR12MB3015.namprd12.prod.outlook.com
 ([fe80::db88:47e8:4619:e06b%5]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 15:30:40 +0000
From: Ron Li <xiangrongl@nvidia.com>
To: =?utf-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@linux.intel.com>, Herbert
 Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>, Vadim Pasternak
	<vadimp@nvidia.com>, "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	Khalil Blaiech <kblaiech@nvidia.com>, David Thompson
	<davthompson@nvidia.com>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] platform/mellanox/mlxbf_pka: Add core BlueField
 PKA platform driver
Thread-Topic: [PATCH v3 1/3] platform/mellanox/mlxbf_pka: Add core BlueField
 PKA platform driver
Thread-Index: AQHcKZ8JrLb+krs/kEux0eOlorFjd7Tl/PIAgAmBe3A=
Date: Wed, 12 Nov 2025 15:30:40 +0000
Message-ID:
 <BYAPR12MB30157EDAC502D14D7E0E5546A9CCA@BYAPR12MB3015.namprd12.prod.outlook.com>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
 <20250919195132.1088515-2-xiangrongl@nvidia.com>
 <8abccdcc-ad40-8f08-457b-d5567aee7083@linux.intel.com>
In-Reply-To: <8abccdcc-ad40-8f08-457b-d5567aee7083@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB3015:EE_|DS7PR12MB6022:EE_
x-ms-office365-filtering-correlation-id: cf7e8621-b61f-4d43-21ac-08de22006fad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eXZYZjBEOVY3cVVjcmhPQU1vSVRoTEVWdGdGNnF0RkFZZzg2bC83dUlQT2FT?=
 =?utf-8?B?Y3pHbHc0Y0ZZUWY4emw4UW4xbmFKMkRoTkZwL1owN3JtOFNvblJad3VQSzh4?=
 =?utf-8?B?TWwrUmZpLzZwcnZiTVl6VFp0aU9lQ0Z4Qlk1WHl3aVhDK3plQXRUTy93L0Yr?=
 =?utf-8?B?dWNaaEx0WTdTK003bEY5dWptL1pWZXlWSDB2T2d5cWtCQ0N3L05vOVBsN1J1?=
 =?utf-8?B?WDZYT3gxc1lqWWtacDZpdDcweFgwdFE1Q0tRZHh2bDhzT1JKUmYwbHhNUkZq?=
 =?utf-8?B?ZTRTRnNMbm4wamtNR1dNcHJlU0NXbVkxVHU4RXRZV3JsNnZ1L2ZvOFVBaDdl?=
 =?utf-8?B?TWFjRUxxbCtuUXNTUDZFaC9qWlVsS2xOOENpVTIvdUJCT2laZ2QySnZVR3ZK?=
 =?utf-8?B?aWpDbTMrYVhlZmRjNnZNTGZTMlhudDlZZ01TUHJid0twdk0wVndkUk5heldQ?=
 =?utf-8?B?dzFiS1dsK1RGZ2tNYm5iQkdNRmcwWUNURmlsYmlkN1Y5QXU1RG95RGhoeEE3?=
 =?utf-8?B?QTZqVEszckhyMzFxNXNMRlE1TE5Jb01kdlA4WUt5TDRzZ3FtUmlOcWg3ODVj?=
 =?utf-8?B?ZCtQUmYxTmpOMWgzZTNLdld0VVhwbm4wd2tKdVdWQlVsNC9PN1Njdlc2Vkpj?=
 =?utf-8?B?cXYrTDZKU3Nlck42R25ZbFR6L3FVOHZXdHNYVzArRjlxc2ZyV3dHV3pMMjQ4?=
 =?utf-8?B?MmdSR3l0S0pobER2N2szbW9ZVXhPbDh2M1lobmJING9yb25qeFcvMFl6TkVO?=
 =?utf-8?B?OWhISDlpbEFQQ2poWDU0VWZtNUtocHNrWEl1SVJNbHE0RmY0UldDaEpDY2tw?=
 =?utf-8?B?d1NadlY1alQvN2piNFJHOEo3UkdZYUhqZ1FDMElvV1lKZHlPZXBqbGtPMVdY?=
 =?utf-8?B?Rytodkk4Y2EwTmN1dHhPZ1cxWjYyODBTWWFyT3lQWEd4SDR1eUxkUTJzeTIz?=
 =?utf-8?B?ZklGdE5INWtpMHhUcDlrZ01XZE5LakpFbkhoZTJwZjNnWVlPN0VRNlBIVGxE?=
 =?utf-8?B?dmVBTXd2MndqUjc5Rmc1THFKdXY1MEdDaHpjeEdINDhmUzRxN2grZFVGMW45?=
 =?utf-8?B?MXlmR01lcjNDdHFxYUlmSWhkZEp6ZzhCdVZuQkxkUHAzYllmSldvTDQ3TktV?=
 =?utf-8?B?eEE5MkJPWWFkdUppNlUrbzBmbzM5bUIrc2xvaHlWVFhoa094VG9hcndDdnFJ?=
 =?utf-8?B?WmpDN1JMS1RseXlWbVJJbWpqbWo3eW8xcVlYUUVJNzNZVG1ocHBoWVVTUFUy?=
 =?utf-8?B?Y0crVUZkWXp3Z2hnTG1hR1AxRVlQK2hPOGtXdEpsNzcwelJ5L0VKMnVidzJi?=
 =?utf-8?B?dVBMMEYrajF3TmtXaCtrbTAweWVVQ2xLL2xiZjQzSFhvcDNvUW8wczVhbmJQ?=
 =?utf-8?B?cUI1NWhyMWo3S3dDcXlQc1hobFFxZ0lQc1pVSGRnNmlIazBpSXhtbFkwaHpn?=
 =?utf-8?B?bWMwMkVlUHRCNUU0L3JESzlGbnA3OUtTRFZmY1FPRHAyTjZGN2VQQTRiVlZ6?=
 =?utf-8?B?dlVpdUVKNkVuZkdhbEJHdzF4N2JRU00rczhGdlFSMTlVYmhXSVNHQ09EMEt5?=
 =?utf-8?B?VmFXdE5lZGtpSW9nR01UbVpPYkl6eHdKTjlhKytVeU9KdEFUWHFxRDZUR3cy?=
 =?utf-8?B?ekR0b1RTdytoZUx2bWtRbWZjRnp0TUZIcklFTVAwSmlCMm92bkE0ZDFYcnNm?=
 =?utf-8?B?NFZ0a3NQNFlLTUttV20vK09DUG1BVjRHZnB0OC8wRmRMSlRPTUtMaU11U1RM?=
 =?utf-8?B?WWUzcVZPSXBkcURGNTl0YTZDU0V2UkRnSG5zNWRVM2w5YkN1UGZsVW44U3ZK?=
 =?utf-8?B?WThWc0hVa2RaNjlORFNod1VaZ3ZHM0hOSWtXNm1sM2RUV1psdUI0NzBtN1VD?=
 =?utf-8?B?UUxwUVVKMkFaV3ZtQnBmTjVoVSthMk8zYnNjQTlvSHVCTmk5ZVYxZGFEQldx?=
 =?utf-8?B?R0E4N1ZHaVBibDRnaFlQbUZIbHVjV3JhT3loOHVaUVNuN3BFT3BvRFhRMy9P?=
 =?utf-8?B?NnZzejlNamNnZjhVaGVnVzR4cmVGRHpuck91SmZHV25mM2lHS3ltRlZQNTNB?=
 =?utf-8?Q?MgqhZn?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3015.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RVVUUnNTMTJ1Ym5LUUlEbEJhc2h2M3BTTUVkZEd4NktjMHJUZEYzQzVFVDNK?=
 =?utf-8?B?UDBUdHFoRDBjRUs0ZHdjS1FUc0NpR0tPejVUenN1NFlpZFNEOE0xdURKQ0pO?=
 =?utf-8?B?amFLQXVyVEszNjFNSVBQZ0RGbkNpbHY0V1c4T01yR0JGbitjR213ZHpaREc1?=
 =?utf-8?B?VENuTk9EQWlSOFV1ckxHNE9GN21HSlF4M0l6eWduRFdDNHliOGpQMGhuQzZk?=
 =?utf-8?B?aW1kaHBkQ2NVSmtYZ1pqSW1QQ2RISmNHOGY0dnY4ZGZhamVUVjBhbzZzbFpZ?=
 =?utf-8?B?RExaNEhvZjJhL1NIcm0yZW11WTUyTzNPNnVWTHZvQithS0grVXhOdE5Ya0x5?=
 =?utf-8?B?YmR3bXp0Q3g2K1hhNFVFVXlDZEpLQWw5N1VJYm9QUklrbzl3ZjNja2V2dERU?=
 =?utf-8?B?UldUSTFaOW1rMmNxQ3Z4V2h2c016QWp1YkZhU0psUjV3UFpjWU8vRnVvVDJX?=
 =?utf-8?B?N091eHJySWFUNzJNNG5qK1h6cjdKc2lBVjZWT1dwYmNacnQ4bmJUVytKOXg3?=
 =?utf-8?B?RCtZNWFjTzhPV0FOZDk4ck9tMkc1TkI0MmJsVmMrd2dxek45ZFpvVEVxNkhX?=
 =?utf-8?B?WGUxSXNqaXdZYVQ2VXc0eVhnZEsySnZHdGxsTkdPY3RsZ2JaRGdOaHNKNlJZ?=
 =?utf-8?B?Y1FlWmlFbldYVWRvcHNMMWludnhWUkdZcWdvanFJNmNPcmg5N1JyYUx3NDNL?=
 =?utf-8?B?Q0piWld3dis2WGhwbUtONS9WTXFNdURSazNEeGNKR3pxU0tOa3pqdWVqdUdo?=
 =?utf-8?B?RzlGMkI4YzFCUjM3ZVV4MS8yOXZrZHphRitlWjk0Q09vc0RjZEZKVnhSSkpa?=
 =?utf-8?B?Q1h3QUxqSFI1ZFpMUXRMZHVMNHphN1VyQkpkVTRJaCtvZmZuL0tDdGVZUVpV?=
 =?utf-8?B?eTY5WUtwSVZxeS9SWUR2dTlHL3Z1cFUrY2tSVmNDRmsrSmNSWjlpRUdDRkhr?=
 =?utf-8?B?OXhOd0ZSenRJR3Y1V0owV1pCeTJBYlRqdDR1ZTVEVEJuMFlHaHl1NHBIZmIz?=
 =?utf-8?B?NGc1TWsrdEdBdUttcEtPS09ydE5yeFJCOXM2TGI5REZBWEFmaWtpT3V4ZGpJ?=
 =?utf-8?B?MUdnZnlFaFZ3Qk1GWlIwVnFGWE82M2p3SVI2cnpLdjRGTWUzaWFESi9FVFcv?=
 =?utf-8?B?V251b0F1MGRnSmpjaHI0OTZJeTF3azAwY2hETDA5V21wNVA3dExHd3lNbzRs?=
 =?utf-8?B?YWpwQ2oyVjhVS1NYZ1RTQ3BWS08rNTBpcVd1ZkI2UVFkY0pxd3M2YW5XVWpQ?=
 =?utf-8?B?d09raWptS0J2N0R6OHZyZXZtY0cxclZKck1hT01UcUxBTEFXdmFOSVNQcjB0?=
 =?utf-8?B?bHRpUkJiR2pqSnhleER4Q1h2QWwwdEFtVWN1bWdvY2NZMDJYbFVueFlEenQ2?=
 =?utf-8?B?dk1qT0VHNEdvSnFpQ2xBK2tSYWNrckdHejBHa1UrRERvZUNiUlFaY1lpZ1RU?=
 =?utf-8?B?WUlMbFd2dmhQb2wzRlRnbHA2V1EzRTVhdEpFMWd0SHFrV0Z5RVg5VjlnaUZV?=
 =?utf-8?B?Wk1KZEpabjNpOTVYQmx4bVBIYjcyaDdhVmN2VjRndUVzVVNIQUNKUGsxc2JY?=
 =?utf-8?B?U2F1U05DNFhpbGViSkFGaDNrQ2xDeXdHY3lSZFdEYXRLQlBlMWRvRXhtYjFm?=
 =?utf-8?B?Z3dTd3Z0NmZRNzJCRGdnL3oxckR2czhmKzlOa29TMGVwWEsrdVk1MzcybFFF?=
 =?utf-8?B?b3BwYnRROUVBVkV1Z0lvdm9YMHFDY2kvb1dzcGtNMzc3cFZDa1FYM24zNEwv?=
 =?utf-8?B?NW41MHBVNHk5SmFGaDVmSXl0cC8yNGs2ems2U2VGVlFNWVNjU0J0Ulhib2o1?=
 =?utf-8?B?MHZtZ3ZMWHRWRmFyelhLL3lLcWdBZWlmU0pBeEdUdVlreHdsZ0hDVUlnbWw4?=
 =?utf-8?B?N3RuUlNxaHFEZGlOM215M2hVZ0x5OTIrU3U4ZmdEY29qckcxT2VCRVoxLzRP?=
 =?utf-8?B?cndFcjJpZjNER0ZIbE9oZU1PK3M2cmp2VDRYQzJnZ2VlYWo2TGZoSWJHVGxz?=
 =?utf-8?B?eW5vYjZFOU9oMUN5R3k3MHE0b2J4dVRxUUFmMzNHZnJRYlBLSk1Td2ZsclBS?=
 =?utf-8?B?V3V2SFJpRWtSQklXT2htZUErTUVHWWY3WnNaNG5MMEdJUmpiL0ljWUwzQmNv?=
 =?utf-8?Q?ggtUgx9J+wKq8pchQYygptrmT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3015.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7e8621-b61f-4d43-21ac-08de22006fad
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 15:30:40.1990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbUL5D2ynS952T7rQOXnXjMGjSAeLDsi/0ggCY0q+3h9ZhUetkpp4zV4VGzxC66XuYnQQpmC+hiAja6GwTneJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6022

SGkgSWxwbywNClRoZSBQS0EgZHJpdmVyIGlzIGltcGxlbWVudGVkIGFzIGEga2VybmVsIG1vZHVs
ZSB0aGF0IHByb3ZpZGVzIGZpbGUgb3BlcmF0aW9ucyAob3BlbiwgY2xvc2UsIG1tYXApLiBQS0Eg
ZGV2aWNlcyBhcmUgZXhwb3NlZCBhcyBkZXZpY2UgZmlsZXMsIGFuZCBhIHN1YnNldCBvZiByZWdp
c3RlcnMgY2FuIGJlIG1hcHBlZCB0byB1c2VyIHNwYWNlLiBJbiB1c2VyIHNwYWNlLCBhIHVzZXLi
gJFtb2RlIGRyaXZlciBhY2Nlc3NlcyB0aGUgaGFyZHdhcmUgdmlhIG1tYXAgKGJ5cGFzc2luZyB0
aGUga2VybmVsKSBhbmQgaW1wbGVtZW50cyBhbGwgbG9naWMgcmVxdWlyZWQgZm9yIFBLQSBvcGVy
YXRpb25zLCBpbmNsdWRpbmcgcmVnaXN0ZXIgYWNjZXNzLg0KIA0KRm9yIHRoZSBQS0EgZGV2aWNl
IHdl4oCZcmUgYXZvaWRpbmcgdGhlIENyeXB0byBBUEkgZm9yIGFzeW1tZXRyaWMgb3BzIGJlY2F1
c2U6DQotIE91ciBwcmltYXJ5IGNvbnN1bWVycyBhcmUgdXNlcuKAkXNwYWNlIFRMUyBzdGFja3Mg
KE9wZW5TU0wvQm9yaW5nU1NMKS4gVGhlIHVzZXLigJFzcGFjZSBBRl9BTEcgaW50ZXJmYWNlIGRv
ZXMgbm90IGV4cG9zZSBhc3ltbWV0cmljIGFsZ29yaXRobXMgKERvY3VtZW50YXRpb24vY3J5cHRv
L3VzZXJzcGFjZS1pZi5yc3QpLCBzbyBpdCB3b3VsZG7igJl0IHJlYWNoIHRob3NlIGNvbnN1bWVy
cy4NCi0gQWRkaXRpb25hbGx5LCByb3V0aW5nIHRocm91Z2ggQ3J5cHRvIEFQSSBhZGRzIGV4dHJh
IGNvcGllcy9jb250ZXh0IGhvcHMgdGhhdCByZWdyZXNzIG91ciBoYW5kc2hha2UgbGF0ZW5jeSBh
bmQgYmF0Y2hlZCB0aHJvdWdocHV0IHRhcmdldHMgY29tcGFyZWQgdG8gdGhlIGRpcmVjdCwgemVy
b+KAkWNvcHkgcXVldWUgVUFQSS4NCg0KUm9uDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gRnJvbTogSWxwbyBKw6RydmluZW4gPGlscG8uamFydmluZW5AbGludXguaW50ZWwuY29t
Pg0KPiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgNiwgMjAyNSA5OjE4IEFNDQo+IFRvOiBSb24g
TGkgPHhpYW5ncm9uZ2xAbnZpZGlhLmNvbT47IEhlcmJlcnQgWHUNCj4gPGhlcmJlcnRAZ29uZG9y
LmFwYW5hLm9yZy5hdT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+
IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGhkZWdvZWRlQHJlZGhhdC5jb207
IFZhZGltIFBhc3Rlcm5hayA8dmFkaW1wQG52aWRpYS5jb20+Ow0KPiBhbG9rLmEudGl3YXJpQG9y
YWNsZS5jb207IEtoYWxpbCBCbGFpZWNoIDxrYmxhaWVjaEBudmlkaWEuY29tPjsgRGF2aWQNCj4g
VGhvbXBzb24gPGRhdnRob21wc29uQG52aWRpYS5jb20+OyBwbGF0Zm9ybS1kcml2ZXItDQo+IHg4
NkB2Z2VyLmtlcm5lbC5vcmc7IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+DQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgMS8zXSBwbGF0Zm9ybS9tZWxsYW5veC9tbHhiZl9wa2E6
IEFkZCBjb3JlIEJsdWVGaWVsZA0KPiBQS0EgcGxhdGZvcm0gZHJpdmVyDQo+IA0KPiBFeHRlcm5h
bCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4g
DQo+IE9uIEZyaSwgMTkgU2VwIDIwMjUsIFJvbiBMaSB3cm90ZToNCj4gDQo+ID4gQWRkIHRoZSBp
bml0aWFsIG1seGJmX3BrYSBkcml2ZXIgdG8gc3VwcG9ydCB0aGUgQmx1ZUZpZWxkIERQVSBQdWJs
aWMNCj4gPiBLZXkgQWNjZWxlcmF0aW9uIChQS0EpIGhhcmR3YXJlLiBUaGUgUEtBIHByb3ZpZGVz
IGEgc2ltcGxlLCBjb21wbGV0ZQ0KPiA+IGZyYW1ld29yayBmb3IgY3J5cHRvIHB1YmxpYyBrZXkg
aGFyZHdhcmUgb2ZmbG9hZC4gSXQgc3VwcG9ydHMgZGlyZWN0DQo+ID4gYWNjZXNzIHRvIHRoZSBw
dWJsaWMga2V5IGhhcmR3YXJlIHJlc291cmNlcyBmcm9tIHRoZSB1c2VyIHNwYWNlLCBhbmQNCj4g
PiBtYWtlcyBhdmFpbGFibGUgc2V2ZXJhbCBhcml0aG1ldGljIG9wZXJhdGlvbnM6IHNvbWUgYmFz
aWMgb3BlcmF0aW9ucw0KPiA+IChlLmcuLCBhZGRpdGlvbiBhbmQgbXVsdGlwbGljYXRpb24pLCBz
b21lIGNvbXBsZXggb3BlcmF0aW9ucyAoZS5nLiwNCj4gPiBtb2R1bGFyIGV4cG9uZW50aWF0aW9u
IGFuZCBtb2R1bGFyIGludmVyc2lvbiksIGFuZCBoaWdoLWxldmVsDQo+ID4gb3BlcmF0aW9ucyBz
dWNoIGFzIFJTQSwgRGlmZmllLUhlbGxtYW4sIEVsbGlwdGljIEN1cnZlIENyeXB0b2dyYXBoeSwN
Cj4gPiBhbmQgdGhlIEZlZGVyYWwgRGlnaXRhbCBTaWduYXR1cmUgQWxnb3JpdGhtIChEU0EgYXMg
ZG9jdW1lbnRlZCBpbiBGSVBTLQ0KPiAxODYpIHB1YmxpYy1wcml2YXRlIGtleSBzeXN0ZW1zLg0K
PiANCj4gSGksDQo+IA0KPiBCZWZvcmUgSSBzcGVuZCBtb3JlIHRpbWUgb24gdGhpcywgSSBkdWcg
dXAgeW91ciBlYXJsaWVyIHJlcGx5Og0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
L0RTN1BSMTJNQjU3MTkxRTVDQ0MyMzlBNDMzNzBCODcyOUE5OTkNCj4gQUBEUzdQUjEyTUI1NzE5
Lm5hbXByZDEyLnByb2Qub3V0bG9vay5jb20vDQo+IA0KPiBZb3Ugc3RhdGVkIHRoZXJlOg0KPiAN
Cj4gIlRoaXMgUEtBIG1vZHVsZSBpcyBhIHBsYXRmb3JtLXNwZWNpZmljIGltcGxlbWVudGF0aW9u
IHRoYXQgYWxsb3dzIHVzZXIgc3BhY2UNCj4gZHJpdmVycyB0byByZWFkL3dyaXRlIHRoZSBCbHVl
RmllbGQgUEtBIGhhcmR3YXJlIHJlZ2lzdGVycy4gSXQgZG9lc27igJl0IG9mZmVyIGFueQ0KPiBj
cnlwdG8gc2VydmljZSB0byB0aGUga2VybmVsIG9yIGltcGxlbWVudCBhbnkgY3J5cHRvIEFQSS4i
DQo+IA0KPiBZZXQsIGNyeXB0byBvcGVyYXRpb25zIEFSRSBwcm92aWRlZCAodG8gdXNlciBzcGFj
ZSksIGlzIHRoYXQgY29ycmVjdD8NCj4gDQo+IENyeXB0byBBUEkgYWxzbyBoYXMgYW4gdXNlciBz
cGFjIGludGVyZmFjZSBbMV0gc28gdG8gbWUgaXQgbG9va3MgaGVyZSB5b3UncmUNCj4gdHJ5aW5n
IHRvIGJ1aWxkIGFub3RoZXIgaW50ZXJmYWNlIHRoYXQgcHJvdmlkZXMgdXNlciBzcGFjZSBjcnlw
dG8gc2VydmljZXMgYnV0IGlzDQo+IGluZGVwZW5kZW50IG9mIGNyeXB0byBBUEk/DQo+IA0KPiBb
MV0gRG9jdW1lbnRhdGlvbi9jcnlwdG8vdXNlcnNwYWNlLWlmLnJzdA0KPiANCj4gLS0NCg==
