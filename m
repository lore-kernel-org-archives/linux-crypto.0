Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1DA1F8BCC;
	Tue,  4 Mar 2025 22:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741126136; cv=fail; b=p/qTVZEy6RSB5FwEG6QxWtA/bwkA2BmLCiu9qv2MXeFU829hxAwYWg4eFwCxp7v5PEd1LvWWPf2LWpmtpdDkIuyQ69IcSvzIBJKc10PHlwhpGd8QgS75Wed2WMajkKordZBNqhn6lvwDz5YwoY0KIcCUelYXFFDH+xPxQfbe+Mk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741126136; c=relaxed/simple;
	bh=3W0V8sjkJvd44N/SF8eCQ6g3ppKgZIoiHw2SXk7NnUo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=JV+GYnm6+2PdaKQGc5ac7hPUmTaLSDi8UbCNu2rUFj5kIrBuQ06nnWFyZ68mCFWaQFwZZbb6sH750vOl+d13u2DUsknDyP9LTC3brH406iDQVRWCX6Szy17wu1JzI36EUlkn/+FE1VZY/aQgs/leij2Sz9/5gSNjhl7umdHQ+lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=EtO5ycZD; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="EtO5ycZD"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524KliFu002396;
	Tue, 4 Mar 2025 14:08:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=3W0V8sjkJvd44N/SF8eCQ6g3ppKgZIoiHw2SXk7NnUo=; b=
	EtO5ycZDiLUo+rkpioR4Z4Lpj7K8kifOjbExBkaeHjX8T9T+uiWyGXXMJadLVQos
	/5AjdRhb1tJ/mmviRd20QlyV4vUvddwS/nYJmSJGIruNxUiX4Nlr9mud0Sb+qhCb
	xdHsH67h6C3vmKY9CEfmAQhXRFa87x7MOiiKh28rXXSH0AN2OMjcofAPqS6sY8lz
	O1L62/ziEaBIwBW01MHUzyLbtsvwnhh/ofiUIt8JJ9Hom/uCRpu1UYEleRLiFDW8
	/yj7w7AyKCkH5fMHar1iyHMLrXLxpXYLS3Jg2D37v01Yprsy6cO3AbuvQg8zOnos
	0szGbpvXWiae8XwmCUyvoQ==
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4561m54pmw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 14:08:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fwLE5oh3U8HuQ00LXZzNKFtv2TzY+vLL6tGppq4w8nzlF357HKRvaE81lx5+K561Pmok7SmMcj7SnKRwTZ3RVE3Bk+t+mEKA4MKcgy/xRJy9STa7ssjYtYZOf8cMjVIGs4IwOQ65UMIIvKvOketZJtLroMX5WuNum1ULGV1uBV9iqbybZhIhxBZbwzs/un208BEYzT4Bdxe3AqcDNsCpPaPVJwK5+thMux9yRtLy/AD+cVyZe/EkBHRvvJiMZk1+hB7QZPiR8w+HO9BV2goyNIPyXteloKUESEoEbCL0iU6qlWAnBjZs3rgwYA8L0ACFAxFWtXbFdkYMu3l7X1e6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ECa13q2K5k2ebZdoAOTiTbkh6153nPivhODE+V/hls=;
 b=HhT7yGxnAnNdjrUiU3YcKtP/GWT2+WBqVA8XHZhHQcE56hN7pzTVMwnZRTgFFPnCZ7mBTpqz8YTCSeS+wEG+mO2UZ9wbjhHEDgAUtircwec9XxjMdoFkyZzKNAlyl8bsxjoryE7ZMt0y9x01wgGXtkcFGH8IlySPdLNcqy7uqvmjvxlRvrDn0lIW0tpZF+irYaaczX52XJQ8Lqgq2J/Lgf8KEEdLbmkhCC25PBFf94Uhq/GEY3vlPoqltJ6RwDUj8M+IM6Pwk3lGSbCwUZRXQ/USR3N5ORLDObqfi46XbBTt0b48lQXroyuDA94EOZUDhqLfX9Blittfg/CkfiGAUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from MW4PR15MB4732.namprd15.prod.outlook.com (2603:10b6:303:10d::15)
 by SN7PR15MB6189.namprd15.prod.outlook.com (2603:10b6:806:2dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Tue, 4 Mar
 2025 22:08:51 +0000
Received: from MW4PR15MB4732.namprd15.prod.outlook.com
 ([fe80::f3ab:533:bb24:3981]) by MW4PR15MB4732.namprd15.prod.outlook.com
 ([fe80::f3ab:533:bb24:3981%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 22:08:51 +0000
From: Nick Terrell <terrelln@meta.com>
To: David Sterba <dsterba@suse.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Nick Terrell
	<terrelln@meta.com>
Subject: Re: [PATCH] MAINTAINERS: add myself to co-maintain ZSTD
Thread-Topic: [PATCH] MAINTAINERS: add myself to co-maintain ZSTD
Thread-Index: AQHbjQOPyEwVabz4xk29hHAOAewz87NjifEA
Date: Tue, 4 Mar 2025 22:08:51 +0000
Message-ID: <DEBEE872-D33B-48C7-91B4-3976F3F0419E@meta.com>
References: <20250304124700.24574-1-dsterba@suse.com>
In-Reply-To: <20250304124700.24574-1-dsterba@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR15MB4732:EE_|SN7PR15MB6189:EE_
x-ms-office365-filtering-correlation-id: 97fe65b0-9411-4e09-b9bd-08dd5b69253a
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OWxUNHlnMWMza2R4TE93UkYyb0l3cmErRXRIYWk4U0tRMnZqYkdDam0yb1VV?=
 =?utf-8?B?ZVFybngrT040UDBCWjVFZEpFNDF5Q1hhVHpxbVNvM0ZSUHU5SGVrSGs5dE5y?=
 =?utf-8?B?WG5lb2FrM1NIcFF0TklXRTNXWi92YWpZeTNGVkthNWwrYVFYR1c5bXI3aWJV?=
 =?utf-8?B?VnNJZzkweWxJbkNCbHd4VUJNU0llR0ZpY3Y1ekpocHhUbjM1WlNPUU9kTTZE?=
 =?utf-8?B?R2dnQnNKdnBWdFpudjE0SXoyU0hEc3FkVVM4UDNEaERsK0JKSFNKNlBYSkNQ?=
 =?utf-8?B?QkVJRGw4aWNiaUhlTWdyMEgrM1VZc2pqZW1vMWRZVjZ5b09ZaXZ6bHo2KzVk?=
 =?utf-8?B?cjl0K0FIN0lMclFML1ZUTmxnbzhnNVQ4a2xRSWNUTXdXUmhQSDFRL2FGamZ6?=
 =?utf-8?B?RFYvL0NjUmZFSVFJbXYyYmlRdjJtdEhjZVQvTUJiQzFjY3lQQWI3aTRZT3hh?=
 =?utf-8?B?ekQ2cmpMaU4wbml3SnpCczZyUTlBWUJQd1d2SnJUcUljVFNlbGZQWEIyOStN?=
 =?utf-8?B?Z01JR203bUk4RGJmNVR6SWZ5ZEFZRUFNTHhqczNJbnhOZzQ1VkN0aDJrUUVl?=
 =?utf-8?B?U21CVlJGMklFN2w1OXF1eDV5eFdtVFVpUmI0eDdEbnRobWhlYTB4anFBMExu?=
 =?utf-8?B?dmJuYWZRbTFNazBtQURyeVZiV3EyZU5nanU4TUEwUmdycFVkdStMTGlTTGpt?=
 =?utf-8?B?TGlJOGNLY3IvdGpXWkowcXNnVkFWdkNLQXhHSUE4TkxXTUVRT09sRlRadU5O?=
 =?utf-8?B?bzlIU0JFMjZTY1FSV0Y0WkJZbW1nSUFNcHRuRjBMdWNxc0hqd3pzcmdHVUtH?=
 =?utf-8?B?OWlFbHVlbEFDTGcvM0JuaHZLekpXeldnQ2NycW9uOVg5VFoyc0tMenRtL0Z6?=
 =?utf-8?B?SU5Xckk5MFFRNUxkQklHUGI5c2FjZzQxM2xnMm5mTzhIL21SeGJVelhjTGZT?=
 =?utf-8?B?ZGtvVC9rNU1CbWR6ZU5ROEdMczgvbklXQXR0MWU2K1VVdlp6WFZuMlBJNEFI?=
 =?utf-8?B?MEFHc3UrcWpnOEhLOXZ6WUxoY3hGc2FxQmtsYmZMYVRIZmFCUEkyZ2V4N000?=
 =?utf-8?B?N1pLTGdxTERjRUZueThsM095cWt5V2JvWHArazJlSEd4QWNhRTRtaUFJSkty?=
 =?utf-8?B?eXcra0lvT2RYNmdscUc4cVJLMXp3WjVlZVYxUXprWEZnRXVUTERybWU4MjlO?=
 =?utf-8?B?NGI5MWlOa3NDVzhHeVBIYlAyaHd0Y3BVbVI3NktQdDM3engzT1ZwUXVNWjJk?=
 =?utf-8?B?R2orVHRGN1h2Rk5MM3hhK0xFbFVOc3M2aHM4MHgydzc0R0tSY1VYY3huMnJn?=
 =?utf-8?B?VkN6RFNHSG1UOHFCRDlkWlAwVnBQQm1UZStXekplZUZha1BHc1VZM2dZWmJC?=
 =?utf-8?B?Wi9PL1UwbWhlTEFYak8zbDdJU0Rzd0pXV2NqbWpOT2QzN05WRjJZZFR2amM0?=
 =?utf-8?B?ZkQ2c1ZFMXVBZkgxOE5QNWlib3B1ZFBPdlFCMUt1QnhmVWZDTHB2VzNhRXkx?=
 =?utf-8?B?UTFGMm5SeGQ2SFlxemJ0NEtMdHNkeEtjT1VaVjd4ZmNKSStweXkyN0sxM0lz?=
 =?utf-8?B?My8wS09JZkZwQnREUUJBZ2MyVVZ2ejBHeEMxN2FWeTduMjR3TTJWOWg1MFNy?=
 =?utf-8?B?OEtHSnFPeHlWY3VDOEU4Qm1uMWt5ckJTTUpSQ1hwdFBNY053UEhkY3VxZ2kr?=
 =?utf-8?B?VWR4eHJhajE1VFFDUmZVVVdYOHVoY0lCWm12dE9WUHhJb0tkN3o0VkgvMUpp?=
 =?utf-8?B?T0Q0SG04MnBaQ2Z5cGwxaGxZL3loUG5yZGE3akptVlh4Skthc3NTcW9UUlJq?=
 =?utf-8?B?VHFXS3dIaWFlcGk3VnUrRVdrODQxZlpRNjZnOVVWUDdjODYyYUh4WU1WN2hm?=
 =?utf-8?B?TGF5Sk1hOFRZbUxVZ2ozbkFSRmlsaXArQ0M1NTZuR1NaZHRwZE12MW40cE54?=
 =?utf-8?Q?zzzh1/rgWAq6KVQn7/wDGIu8FQ99IuRI?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4732.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NXYwZ29XZG51b0dpTE4zRGNoUjM2anhBZlFpa2JCdjFXUFM1RnEvdkRwZjBG?=
 =?utf-8?B?NlF4d2lpRndFTXNwS1loUUxha1k2ZkkvcUs3SmFoV3F5ejFrMS9iUUh4TWRZ?=
 =?utf-8?B?U0tSVGdHajB5eTVBZXlETGt4QVAwQmc3RU5KNDJ2US9FbGVza01MVFlDWUxl?=
 =?utf-8?B?TVAvcDk1cDB4VGFrWlFNRmo2M21SU2x3MmxJa25KOXdqd1BTUUI2ekFRNE1y?=
 =?utf-8?B?OFo5cVRiM0RDODladWhNNGFNbTRRRll5Y1I2eGxyOGVXdGNuSm9FdDFLUVlX?=
 =?utf-8?B?SG1iOTczVUQ0SExFa1F5YnJndW52R2tpaW1sQTJ5eXhPUEFnWmliRUFhdUJo?=
 =?utf-8?B?a2FhOVAvUjZWcUdyajJSM0ZBYXRNSXpJL0VCZlI5cGc4aXlzSE9FdUs4WXUw?=
 =?utf-8?B?VkNGSkNRTGxFN3Ivd0tBdExVQk04ZHNIYUk5WEJ2TE5jR3Jra2owbjljMDIr?=
 =?utf-8?B?V1pIb05DUnhVbDFUOTI3SmdXSWhvWVlkbGdYRjJLTzZQZWtPUXB6eWUvQTVo?=
 =?utf-8?B?VkljQkhzZ3lzOTlockFDWFFrMXc0akdla1c1MkxEaHRoRjdUSk4zakN1Vzc0?=
 =?utf-8?B?cVlDNUVpM2lWVGJjdGtUQlQ1NjRvQ1A2dzBUSVJPamVxMGlrekhHdFVSYXQ3?=
 =?utf-8?B?dTRBVVVHbzhucjFhODZDeTJlWGZyejJwemxmQjBUbDhyZlI4aVRwZElhbUpZ?=
 =?utf-8?B?cGFxTWpFMkllaWk2cmhVWDE4b1Yvb1dwRVFZOUdYd0hEYzZkZFVtWXhqSTlS?=
 =?utf-8?B?d1EvbE1JMU1ZWlVxNjV3aFBJUkoxSjA2eEk1aWJrcG1XZGlIbFR5RXNLWUpT?=
 =?utf-8?B?RTB4RHV4a1JpVU5zRk5FYVlRMGlpQkhwVGFtUE1CTU9RR1FDTjhValNMeUFa?=
 =?utf-8?B?bW84ajU2cncrRkZKemJKalVhL1QzTEphaXR2dG1oNnM4Qnhkb1Q5YlhtQWIw?=
 =?utf-8?B?Q3hYRGdiNjdmRStQaEMycGlFZEc3S3FrS2NkNXBzNFB3YXhUaCtRUGo2MWxU?=
 =?utf-8?B?UTkyUEZyZnRGTG5McWtxV2w4aVZMRkZGcGwzbHYrSjJEclNVcDdKaTZZbG54?=
 =?utf-8?B?clh2MGVTeVFvTWFRTXBvdzF2L0tNVHJVVXFNVHRlTXlCQ2JKN0pob2QyRzR5?=
 =?utf-8?B?UEZuRHdaOWplVkhKUVlScEhEcGhSSzJFUE4zSThoUklBNWhvSDVSampQS1Jl?=
 =?utf-8?B?QnNlRnZSR2ZhYzYveTdxR21VTy9yUEhJbWhOYmZYTjEvRnZKeFZmWHIvclVx?=
 =?utf-8?B?N3lGZmRveUhVQkJ2dzkveEU3QVd1ejczK0lHclRmMFFKSHRCNUJRT1BWWk04?=
 =?utf-8?B?ZjhFRlhreG90TUhLMjRvZlpTRXV3NGk4UE9wZVMyZ2crNXdjR0tBd1Y5QU9r?=
 =?utf-8?B?QTI5dm91L21zTk1KT3VlbG9Gc3RIemxiMG55UEVyOW1vR2I5MGJudUpmejJS?=
 =?utf-8?B?aHhmZXN0bUZHcW5Ndzg0cHlUOVJ5WnBLVHJhTGltUGNlTWR1NGlxaytRM1FT?=
 =?utf-8?B?bFFqN05IbHJxdEVMWUY5UUJldmhkWll1SzU1cUJIY2JYVTNRcW5IMmI1WE1U?=
 =?utf-8?B?SGFTeFVNd28raHNVM3hpNHNMKzZvYmI0OVg5cVpQcjZNMnJPZ3V5RFhESndZ?=
 =?utf-8?B?Ukd2WVZCa0VYSi81ZTRBeDl1OWZZOFpEOUFPcUwvR245ZVFqS1lnMDhad3Np?=
 =?utf-8?B?c2ZlaEpFcm8wT05KdjloQkQvVzh2NkRWM051UW5WWGsrRzhEczJRZkN4ejQx?=
 =?utf-8?B?T0taSS91b0tEN1dGSHVWQVlocFd4RTdra3pXNWNmdytJbGJtT1FSUDdmZVgz?=
 =?utf-8?B?M2FmSThkVHhWMDV5NU5kblBLUEsyWG5EZFdtYTN3bVk0NEc5bzBoeEY1SlN4?=
 =?utf-8?B?dGgrQzdaQkNHdVNnTmYvdTY2bmtDRk82dmNXQXVadWNqS2JyU3IrL2h0ZUVI?=
 =?utf-8?B?MUpNMFB1TGxBKzkrSGZaQkNWK2NSakVoOERKanNaQy9sSGExRmxKbGk5amVG?=
 =?utf-8?B?YzFMK2MyY0wybTQ3TllURzR2b1VKaU9UdkppS2ZUMStnT0U4KzUzQXR4all1?=
 =?utf-8?B?N1RWK1NuMXJVdDdoY0dUazYrdlpZMzlBTXljb0tmNThJNndicFRKR0c0UFZ6?=
 =?utf-8?B?N0FOMHlaYytpVHRxdlM0MkJVYVN5QTVreEswUkJNUEZqdytZYkg0ZzJiTzc4?=
 =?utf-8?Q?bl3Q494/b1A6u8Fp9NDIIlc=3D?=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4732.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97fe65b0-9411-4e09-b9bd-08dd5b69253a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 22:08:51.0323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tzmdAZcWIZ7YNq2p0Oy2Q1rYUR2Faq/l68zKlp8SVU9Y9yo9n/7PULOGvnUOaMMJuP05EQrDbnytZNSHtu9RfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB6189
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <3341AF71B3AD304A885ADB530E3CE600@namprd15.prod.outlook.com>
X-Proofpoint-ORIG-GUID: 4kL8gfPJGy58pzs_MTwCVwzQDYLD9A4i
X-Proofpoint-GUID: 4kL8gfPJGy58pzs_MTwCVwzQDYLD9A4i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_09,2025-03-04_02,2024-11-22_01



> On Mar 4, 2025, at 7:46=E2=80=AFAM, David Sterba <dsterba@suse.com> wrote:
>=20
> >=20
> Recently the ZSTD tree has been removed from linux-next due to lack of
> updates for last year [1]. As there are several users of ZSTD in kernel
> we need to keep the code maintained and updated. I'll act as a backup to
> get the ZSTD upstream to linux, Nick is OK with that [2].
>=20
> [1] https://lore.kernel.org/all/20250216224200.50b9dd6a@canb.auug.org.au/
> [2] https://github.com/facebook/zstd/issues/4262#issuecomment-2691527952
>=20
> CC: Nick Terrell <terrelln@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>

Thanks David, I appreciate the support here!

Signed-off-by: Nick Terrell <terrelln@fb.com>

> ---
> MAINTAINERS | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8e0736dc2ee0..b50c0eff3606 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26274,6 +26274,7 @@ F: mm/zsmalloc.c
>=20
> ZSTD
> M: Nick Terrell <terrelln@fb.com>
> +M: David Sterba <dsterba@suse.com>
> S: Maintained
> B: https://github.com/facebook/zstd/issues
> T: git https://github.com/terrelln/linux.git
> --=20
> 2.47.1
>=20

