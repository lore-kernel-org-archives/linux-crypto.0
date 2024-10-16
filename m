Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5CC522A;
	Wed, 16 Oct 2024 12:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729083041; cv=fail; b=oqJjLljGNXzr7eLcELnOGZLajBoI5jsGRNzx1OZjhzr0ZVMbOxA1HibNjunCymckNrdpHRp4jgKntTVS4E+41hykhOYNlwCc2nZsc2GKRyun2kNCIRYRpIPOL1iW2mre+UlkW95337eThRhaX+t0yVXgaaQdCcogrxoPjQYL+sM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729083041; c=relaxed/simple;
	bh=9KgO/QnyZFqVrtWZ6TDwrzR6zs2TPfYoBtncan7A23w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ehj9+bknh+viy+hrfMyXRMERnDRwofamlazoIFjpPt2q80Hg6Ksvx5B45Mc81qJNQ88genkDuHsH5WLCujlG7AKk/K0BSRtvhu9FrC91/D9UxbJ/AuTezPa8G4V12tOIHG5dDzO6U2JEEaTlE8NrYmSdryi7gL/UflPgJfHDz6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dj5LiD/o; arc=fail smtp.client-ip=40.107.95.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dj5LiD/o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sp0Ur+aKsLFSZal42/whUNRHQmV+Fk8a1gYw75pZlP1N2DbgysJAS0CgFT296vPAwgksTngZhZR2Sfp2D5K4052Ra6yLSRkyrwP59KEoUbLtNYqfhpqDK0SIsXf9td4ZnCOBm3vsRrpYuUVo/j3vLIHrw4tLJfmDuw+XM/8rWTRe2g+VrBRbi1GfD1AAnYGjFiHMQb+h+sKQQZixjLf+aaycHiBEWBY31bIpXAqWeaqjT/N49FE1Y3BbHa+ZZYuUOh7smOD9tjwwicFhWIG6zpNyVcK5uThRqVzbCwYjV2x9L1l8z54hBhKcfWKdlMqXiZCLyN19psM6YaLGCDFfkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KgO/QnyZFqVrtWZ6TDwrzR6zs2TPfYoBtncan7A23w=;
 b=hqdy97+bcGq1jd7Vq9ZICt3JRybi+mLb5nVQx8hEaRsfbyxt5rVUydVgZTdKT1c6tKvkXC9HQC+gqwJIpmbtpe0WYegr41+bA3SL6da4tFnk3NKnVrEjqo13LNbYeyF2/zfrY2rEap+hmrF3yIcrlCLHz5DcLjy40LU9vsbYghz8DrfkzBXjVBUk/kCLFxH6Pgh4NYnt9S1d0WrIZ6kVZ2G8e+kParV8NqgfT3pKJAKkQPzKAAe23e7fw5ihqII5rVbFQEUm9c2C6kJ7C5WSa58Amq/jwPnmWhMU+gGGX/E+RFR68nGkwn0XKwhoVeCxNIFuYkQ/wjV9c13X+sheVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KgO/QnyZFqVrtWZ6TDwrzR6zs2TPfYoBtncan7A23w=;
 b=Dj5LiD/olDqchddCU7mlpWXetD/D0DZyiKAWlMeTrkqSmEBtKOo8nkhWkb1b0XrNU+awOYeDtDLibp/HfJCHqPjhmQmGa2oDQUii3d3YAGDBJ0ODlr8v3ODZ490mnKa6fvE1JfAtNsSq3I9ZL9cosgAjlFZh/W6+QbJ2tJJjmKHG/kvyRlMNAjq6oXSBXpv76X06EypsFedduEfjVsLBItaYs/cBjqDTKEdmAkuPocDdR+oNI5UtSH8PAPiQuQEVCQg/8iTS0wrwXdz5saPOD5qWSiYoOU1L8KO0TDquAlpBqlHNJCAGiFoXMJDw+YYSqFxB5FHYb180s3CT1IapJQ==
Received: from PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19)
 by PH7PR12MB5831.namprd12.prod.outlook.com (2603:10b6:510:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 12:50:36 +0000
Received: from PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530]) by PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530%2]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 12:50:36 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Colin Ian King <colin.i.king@gmail.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>, Jon Hunter <jonathanh@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] crypto: tegra: remove redundant error check on ret
Thread-Topic: [PATCH][next] crypto: tegra: remove redundant error check on ret
Thread-Index: AQHbHwO/M2MdfKx+RkCsL86dgTDkpLKJTmDw
Date: Wed, 16 Oct 2024 12:50:36 +0000
Message-ID:
 <PH7PR12MB817831120ABC8F0C44DCAD7BC0462@PH7PR12MB8178.namprd12.prod.outlook.com>
References: <20241015131122.152046-1-colin.i.king@gmail.com>
In-Reply-To: <20241015131122.152046-1-colin.i.king@gmail.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB8178:EE_|PH7PR12MB5831:EE_
x-ms-office365-filtering-correlation-id: 05eda14a-4457-407a-795d-08dcede1215b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NnRwQytUa2tkdWJ3SWtxbUpCQkpwNjJvWWVrTk96aFpPOVlRck1tOHJoU2s3?=
 =?utf-8?B?K0U3R3pTdUwyQnVuWURjcDhFakczcWJDN2hpZGx6eEM0Q0oyNVVLQndWa0dk?=
 =?utf-8?B?enpOTnM5enoxdnExZTVmQW1tZ3d5ZWxaMUxPaWtNTkZKZ0R1V3NVVUJONXhV?=
 =?utf-8?B?MXZwbXZsQzNBRG55alhNT0tKWklhcUtFYmhnVUJ3RmVLYzAwUDg1RmdRaW5Q?=
 =?utf-8?B?OXpDWndObFlvYUNULzlCUzRQTGt0T1RaemUxUW5PaElGRDdvZUQybDRHdmMz?=
 =?utf-8?B?NndERUpzM2RpQXNsa2RVbDA2SWJVT3hrVHJZanlpQjd0QldNbGhUWlpCY3Vz?=
 =?utf-8?B?ckZiOWpCSlEydWJORkFZajJYUGYvNmpoRFNONDhoRENKREx5OE03SDdzdlVa?=
 =?utf-8?B?S2tvVTQxRzVlSFVmeUE1aW1zbWlielpXUHl6cFBCTGQvRFBRQXNsQnd6Mzky?=
 =?utf-8?B?bThkYUNaclB4SGlXUjBpSG1DdnVESzJ1ai9NV256VEtqdDBCdldmb01wLzVY?=
 =?utf-8?B?dXJvR2hqaHlMcnd0ZTFqd24vYU1sNVg0NW5yTFl4ZHNZUExYTzdXTm54QVUv?=
 =?utf-8?B?bm1TWkFpTExPS3BjQys4NmJLV3hDdjhRT01PdTRScWk3S3k3Q3FBMzBEYmpo?=
 =?utf-8?B?NUJ1am5RaHZaMlZkV2dsZHJreEVseUpwRWljY3M2OXZOTUh4QkE0ZzVLQklk?=
 =?utf-8?B?eU1saHlVVkRRdkEyampCV2lleDZMdjlmYnErNEZFano0NVVtMHhtRnRmQjNI?=
 =?utf-8?B?dWNXR3ZndmNIL1d3RmY0YUNqTUNQL256S3U4WXgrM0hLRE1iaDlLak5DaGZX?=
 =?utf-8?B?MTB0U1c3eFJTSHczcGRvZ3lOaUtwclExRHFRMXdXVk41aFNpRys1ekxOck42?=
 =?utf-8?B?eVYxY1NMeFl2TzM4aEhDeDBSMnVmNHJaUnNLR1QzcnRocjR2dXVISGEyUHky?=
 =?utf-8?B?a1ZLNkdSeExrMlh5L1YxcTdqRm5rRGg0d2NSdlNoa0FXeUxNYkovTmVRMGtG?=
 =?utf-8?B?TVZtZnI3K2hQeHlreGlsMWl1V2NZVUxPY3BvUGU3TkZaQ1RBT3d6bUNRa2RO?=
 =?utf-8?B?aHl1L2N5YTFaQTd2bTUyb0V3SS8wT1lKY0dqLzVaTElTdlVxZFptK0NZc0t1?=
 =?utf-8?B?c0NoVEhXVkthUE1XQ0ZDY1l5TGk3Ni9MKzVyaUhVdWlIT2Jrak9EMzNtemxG?=
 =?utf-8?B?NTJJTTJpSXpIdzVzM2x0VlB4bUVQTThFWVBySHBRcTZPRXpaaW9UZnJ0emhR?=
 =?utf-8?B?VUFtcTVkSjRKR21PNUpScFZwL1J4TVFTcldLaktuMDlsa2hXcWk1cSt4QWZ0?=
 =?utf-8?B?VnN6b3VCQWtySGhtVTVjM3Zld3pTMlNqMGhrTXFrWkdWaXRRdlZpV3ROYWZP?=
 =?utf-8?B?MUFOM3VBZzQvZkV2SHE1ZGJ5Tm41b2ptOU1vdnd3ZXN2cUUyTHkrR2RSdHI5?=
 =?utf-8?B?WFZLZks1aE1ZWGVQVGlDZ0hBQitNMmpkV0pWMmZSR3JqTHNyL3BEZ0hHSk4y?=
 =?utf-8?B?Wnk1bDdpMDE3WUZMNWlJdUZWc29KUlpHOVZHMXpOdFkwUzVLaVlOSEFXM0NJ?=
 =?utf-8?B?bDdqbVFKWlhNOEZxWFR5UVhsTmNKWXhPM0NIeGRrMGlPYTF0UUNpSmdqVHRV?=
 =?utf-8?B?c2hRcEkveVJiaWU4M3E3ZmNxUHNDTno4V2VZenFYdjBvUmNaeVd0eS9jK1Fi?=
 =?utf-8?B?SWxSVjQyMzE1c2hIQVFhOGJvdE1PYVJGUFR1RERZczRydlEzKzVvb0F1bHZL?=
 =?utf-8?B?bGRES3J6QzhRSlFJMDFyWGw4WHlTN1ExN3NnWDBFSmNVNkhTdStQbWlIMUlK?=
 =?utf-8?B?WWw4a2puS3JSUHYybVAvZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB8178.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a29EQ1hMS2dNZDBJNzhkUnYrNzQ5WkdZTnlBWkVIL2F2eXp1UG1ycmljRlll?=
 =?utf-8?B?MjlSNytxazdkYUNpdjVjR0tld1FWZUl0all5T2VsTUQzVkFGeHdmRlR2bTVx?=
 =?utf-8?B?WnNwWENELyszUG5oVTNLRUFWNG8rV1FwekhrVkF6UE9jb2wvVXhCMmx3M2NQ?=
 =?utf-8?B?b0tvU2gvTnVVcGZCb2w4RFAzSzRFeGJhbDhzMzh2VEQ3V3BTSDhTTS9UYXBs?=
 =?utf-8?B?alZHVWF0bGFud0tXb1JZc2hjOXloMzdQWGJQeWhTZlVpUUxYRklnNDBwTFpt?=
 =?utf-8?B?S2wvL3VsY2F3OXVVNDNsa1VmenJvcEFTZU9CS2Z6WmNuV3lITHJNdHVXRFJr?=
 =?utf-8?B?a0dua1BpNnNYMlNPUG1KSGphWGhNM0lDRUxwM0o5d01tWHZrSzNNRWgyUHEr?=
 =?utf-8?B?bHhxTkJ0VnUxc1lBbnpDUnpYQ1RrSVRINXBOQlZhMFFlUDNtVDgyK2xFSXIx?=
 =?utf-8?B?blUvNUZxS21HVE9KSWpweXM1UW1PZEFaT0QzTWlaOTZSMFBicjJrRU4wMVp5?=
 =?utf-8?B?b2pJdjEwM1ZpSDdOVFhidncvbGx4Ui8vdjN2KzBZSmtZS3QzWERydSsra0NB?=
 =?utf-8?B?bXVsVVNDcnFuQmJFcHFmcW1UWGpKbHJ5bERBL01aTFZiMk4zRUZVV2QzL1d3?=
 =?utf-8?B?a3pOaGMySHIrQWsyQnNQOWlLbVpJdVViOTl4TnpEQnU3ZWNKUTVtNWJ2VCtq?=
 =?utf-8?B?ODVwamloWGdhU3NhOElPOTJGNjlsZlJRQklCWkhUcnpIeUNhWkhIZ2JPRC9Z?=
 =?utf-8?B?aVJUVDZ4QUVnR0ZEakJ6eWtPcGJsVm1qY0orNXVJUTZTRlAzZ1RtNjJXRHp0?=
 =?utf-8?B?bmREdWsrdFhHdGxTYUpmTDFOREF0eVJ3Rm9ENlBnS3VkN1dtcWhuQUNXZTZz?=
 =?utf-8?B?Y0RvK01DQ3NNUXU1cVNmc1FKVC80N2haY1VlbVBwR29tNWkxTnJ5bjZlWTBo?=
 =?utf-8?B?L3RNRUVYU3h5Q3BQSC9zKzJIRk9ZVTlMV09SckF0NzN5MUpRQnhSendQNHEx?=
 =?utf-8?B?eGNBcnBRTkVjVlFmTW5rVmlZTmRnTno0OWdEeE5jcWJFaVJrdC9kTVhXMWlP?=
 =?utf-8?B?ZTZ3akhNNDArZzdZTFBzYmxKZUpTTlJRNmNva3ZCK0owNjJqQ01YN3BQNDhV?=
 =?utf-8?B?RGUraHZzVzdBTGtqZWJQN3J5VVVaNFE3c2xhN0ZXQXJhNmdOM3MzdXlUQzNI?=
 =?utf-8?B?MnBSeUNwSXVsd0tmY2htK3ZMc1FFOHRhd09YanZpbGxqT08wR0MwZEZPQjFo?=
 =?utf-8?B?dGd2NXpudVVYUmpvTFFTN1U5WlB5MXdtb3oxY2o1RkFDTDVGSkJqWjN3VXEx?=
 =?utf-8?B?YzdCQkpuZ2E1dzRVRWk1aHJneFk1WnFkL3dpNlRWamVtRDd2cU93bkY0S0ZX?=
 =?utf-8?B?SFZpS3pzRkpoMFZocnFJU1FBbldYZjk4U1N3OEhVQk5mNGJWOEZhaGp3N3VT?=
 =?utf-8?B?N1NUc2NFRVJNb0VwTHlmcXVUa2lVS2dpRU1GcVk3S09ucjdDTTJXd0NSN3g4?=
 =?utf-8?B?Q2U0RXZYUFFmMWZqaWhxRDE4OG9GWjBZZHVZQXNIbnJGUUF2cjV1R1FCK0pv?=
 =?utf-8?B?MWJ0YlhybWdRN3ZmZE52NGk0YTRteDdCSFUyQ0d1dHZFT0grMzM0M1BCcTAr?=
 =?utf-8?B?S253SGZ6WnhjOG80QjNQL1N3VFV5V0lRUE96cURSMlM5TVJWTEkwQnVRSldM?=
 =?utf-8?B?bUUwWk9jc1lsZUtUR2VmYlNVUHJxRkRNSTZuNE4wMmtsS0JWbjY3SHhVN09v?=
 =?utf-8?B?TDJlcjVTdWJqWXNjMVRhOSt5Y0ZZdklTZGt4OUF1QXZlYkhWUTBIdTBHc3FJ?=
 =?utf-8?B?Nzg0T2ZnbzY3a1U5UXFxRTRGSDhZYmJMSmhrMXhkK3ZsdXVuTTA0UUVFMnpp?=
 =?utf-8?B?L3RtRk9SRGlBc3FiN29yRytTYTRCbWhYb1h5dUlTR0ZEeWloNU42WGFBaStI?=
 =?utf-8?B?WEdIQ2xwWVAwTHBFQlhBZ3ZrczI1ZEpXTkgrZGEzTXFXTTI1OFNPUFpiMUNL?=
 =?utf-8?B?Um5NTGtUNXpiWTR2bmJvbS9VamFBZDZKYVZEam8xcmxYN3paNnVoQjhuaGhp?=
 =?utf-8?B?TmJUSXlOMXhyTUxGZ3FFc0xtRE1maENmRGh5SW1uMTJWd2N1OGpzZ2NDWVZI?=
 =?utf-8?B?bVYwZlpxN0htV3NFcEM0NWw5ZktrdndsMWI3Zi9pYkN6emZGZDdGMENJWVB1?=
 =?utf-8?Q?Gg/fMOEWAZaccgvwiwdGqeFnyfXm4K6lbfrpN/qz+OJv?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB8178.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05eda14a-4457-407a-795d-08dcede1215b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2024 12:50:36.2655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e8WyTS22iK2jwKsjsvHQ5j6pE33AFyGcUYThhXh/ABxfTjZN5s4WCsM6WXCkzQliyE1dEgMhMhPIIcK0jA6E9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5831

PiBDdXJyZW50bHkgdGhlcmUgaXMgYW4gdW5uZWNlc3NhcnkgZXJyb3IgY2hlY2sgb24gcmV0IHdp
dGhvdXQgYSBwcm9jZWVkaW5nDQo+IGFzc2lnbm1lbnQgdG8gcmV0IHRoYXQgbmVlZHMgY2hlY2tp
bmcuIFRoZSBjaGVjayBpcyByZWR1bmRhbnQgYW5kIGNhbiBiZQ0KPiByZW1vdmVkLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmkua2luZ0BnbWFpbC5jb20+DQo+
IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vdGVncmEvdGVncmEtc2UtYWVzLmMgfCAyIC0tDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2NyeXB0by90ZWdyYS90ZWdyYS1zZS1hZXMuYyBiL2RyaXZlcnMvY3J5cHRvL3RlZ3JhL3RlZ3Jh
LXNlLQ0KPiBhZXMuYw0KPiBpbmRleCBhZTdhMGY4NDM1ZmMuLjlkMTMwNTkyY2MwYSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vdGVncmEvdGVncmEtc2UtYWVzLmMNCj4gKysrIGIvZHJp
dmVycy9jcnlwdG8vdGVncmEvdGVncmEtc2UtYWVzLmMNCj4gQEAgLTExODAsOCArMTE4MCw2IEBA
IHN0YXRpYyBpbnQgdGVncmFfY2NtX2RvX29uZV9yZXEoc3RydWN0IGNyeXB0b19lbmdpbmUNCj4g
KmVuZ2luZSwgdm9pZCAqYXJlcSkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7
DQo+ICAgICAgICAgfSBlbHNlIHsNCj4gICAgICAgICAgICAgICAgIHJjdHgtPmNyeXB0bGVuID0g
cmVxLT5jcnlwdGxlbiAtIGN0eC0+YXV0aHNpemU7DQo+IC0gICAgICAgICAgICAgICBpZiAocmV0
KQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gDQo+ICAgICAgICAgICAg
ICAgICAvKiBDVFIgb3BlcmF0aW9uICovDQo+ICAgICAgICAgICAgICAgICByZXQgPSB0ZWdyYV9j
Y21fZG9fY3RyKGN0eCwgcmN0eCk7DQo+IC0tDQoNCkFncmVlZC4gVGhhbmtzIGZvciBwb2ludGlu
Zy4NCg0KQWNrZWQtYnk6IEFraGlsIFIgPGFraGlscmFqZWV2QG52aWRpYS5jb20+DQoNClJlZ2Fy
ZHMsDQpBa2hpbA0K
