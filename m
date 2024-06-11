Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48992CCB7;
	Tue, 11 Jun 2024 21:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718142073; cv=fail; b=JKRdXXVKY2EqSadPbz5RXf/8w4bidVP4YU04JPIGBrTj7hnShb1fszc+EQBf6zFR/0Ko3rEjiZSEmAVJbpAgfv3DE36t2/uwnaTkWCYOUXlUeHrbpvupnOsYd0MEGuU/eSRwUaA8QBKuNcBs7uuSvI2Vy/laY+i6on7qX2qRVFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718142073; c=relaxed/simple;
	bh=TOgy5TJSdrlD4hQl8rTM8VL2r0/WhNmlJ4SExJLZYCc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TC6fDzSF2YdBw4BtnLwf8uCRKncQgcidiV9Qo+o9OyvU4vK02/rrmU9RF48dggr/0j29yo/5cH0dQmSG958oseoeHWf6P1bqvYcIK+T+ZQ5FXOhlkynypMQVe8neVW7zIBj4+p3/zss2DNVa9wZERF2dkdoqHAQLyYr5fbb9PSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=chsqhaSj; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="chsqhaSj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718142072; x=1749678072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TOgy5TJSdrlD4hQl8rTM8VL2r0/WhNmlJ4SExJLZYCc=;
  b=chsqhaSjaO556qusoBkq/CQvwei9ub9I404ce9z3yQcPNrejBM8eoMnf
   acSCSeUgxuKKNeP5nqRFiy/ih3xj4gSTD/ulX4mz4kYo5+Q+HD6vF0frl
   Sukn6j03pastUG0haQLuSm0qcH6C9yziIU6+BpGfxiYvfYD4j4TMMzhDW
   iMYmiuGWFtnoC6+7GQOlQ4RZ6wOnnvlukCzl4qJyDdbXwY829KY0MUgZC
   wxTqCH24izxBsrmmuIYHwWEaXYHWsNh1/94k4D+vvVyY0f+ZI87rOGm+P
   y5Yc+X4KKcDD22dXCpQRWGvN78ykucPwJCIMLyQ2IrPL2rTV3X7ywRDs3
   g==;
X-CSE-ConnectionGUID: uqanmUWhTLycuMH9PMFxQA==
X-CSE-MsgGUID: CU1XxWHbSEWOsRl8s5tzlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14840966"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14840966"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 14:41:12 -0700
X-CSE-ConnectionGUID: GH9dLGSrQRKH0aDQtDyChw==
X-CSE-MsgGUID: RFfdkfoXQfmRSpX5J7CdMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="39630263"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 14:41:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 14:41:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 14:41:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 14:41:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BK2Kgh4yHtn9WHA9bKnTSHfO5uqqBPvDuiP4eWI0PQuQh/z5aRRtQ1KXM87s8LqcfMcdA85/+DVFHHnMl5jS1IqPLWioARx3i+askB+NTI7+QIq2DCFz29MZE4dfzodPbcF8cqS0cy0dVBkK4uB/n7MIAzzZX3n2WHYM6kuB0qxVyXuFrx8NTZhvcRjULfd8w1r9+cLwNB5J/lxLiHiGTNP/cbPMVcKk3+oDq6ZsM3ygptkCwDbexaEL2/swJq02wLndLVR8KIHsClmWoV7PgsJw3ZrzTNLyoM6PYJ4UV4VCEcknLMeExn3n3/FfmVIUAnFrtapvzKfu5WjitDM7gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+2J+CKIadg4Gfp4HzUW+q2RissSyW97KrB+BZCBIS8=;
 b=gcWlxdpqOj/Dadj0ItT0IaXOpsHWsOlUTvJeMlhUZe7+U6lax8A8rkDBxtUCZ0yp3PWoIlCXU6zi+UTc/QJbGFbsUxd04qhGRjgr8z/oXlCHGOrRPWplM4KWY5yHJiyUpaHPw1QOejxxEqNILFeLSCcmMPUKE7siEA1j+mopL5+Fmiax5FKqdF+Q2+ogEPhFx+DJFQhnuKWVIMNGW08H+mRcrvVGpbK6P6KPFVSClbRxON9Khl6tAFy52U2bb6JHkK9Rq0ED34fySxXRi8yhLxhthepmyZnGxc4sinZphthQ+tMled21uS+cz63fl17g6nWqGwJMEt/V08w4waTCnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB7164.namprd11.prod.outlook.com (2603:10b6:303:212::6)
 by DS0PR11MB6374.namprd11.prod.outlook.com (2603:10b6:8:ca::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.36; Tue, 11 Jun 2024 21:41:08 +0000
Received: from MW4PR11MB7164.namprd11.prod.outlook.com
 ([fe80::a972:1395:dd49:1dc5]) by MW4PR11MB7164.namprd11.prod.outlook.com
 ([fe80::a972:1395:dd49:1dc5%5]) with mapi id 15.20.7633.037; Tue, 11 Jun 2024
 21:41:08 +0000
Message-ID: <78767fce-6625-4760-9443-5779247ca2da@intel.com>
Date: Tue, 11 Jun 2024 14:41:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/14] crypto: x86/aes - Prepare for new AES-XTS
 implementation
To: <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, <bernie.keany@intel.com>
References: <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20240329015346.635933-1-chang.seok.bae@intel.com>
 <20240329015346.635933-14-chang.seok.bae@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20240329015346.635933-14-chang.seok.bae@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::38) To MW4PR11MB7164.namprd11.prod.outlook.com
 (2603:10b6:303:212::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB7164:EE_|DS0PR11MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: bf3bdc76-7366-4b81-e402-08dc8a5f33ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|376006|1800799016|366008;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VCtEVTlDRUNuWi8wL1J4UExUK2JaaWNSMVI3QWtTdlpLbHZPdE5LemNxT2dh?=
 =?utf-8?B?L0R4b1VrUWFiVjB3cDNJUEZ1M3lPODM4bFE0R3ZhUHBzVDFaMStYZkhxWERO?=
 =?utf-8?B?bGVMYTBGR3BibVFRTG5aWGhDb3dJajVZa2ZiU01pcTJ1RVVtMGtGbE1paVRs?=
 =?utf-8?B?K0tzOS9GTFM3RmVqV2grMlFXWW4zYWFrRE1GTU4rV0tEczFMUVhKWWtnOWpL?=
 =?utf-8?B?eElNQkRnV3Nud25BVEhBY2t6UkxKQUo1L0Z0dzF6cWs5VFIzRG5FZWhZWHhO?=
 =?utf-8?B?SVc5djlHT1J6c0Z5SWtWbGlMZGRGakFMOGl5ak4vbkVsb0FsenZnb0JsaVNm?=
 =?utf-8?B?RGtob0Y5TS9LNW1mVS9qTjZFT1FXcTdtQVZoclh3UjFpbmtzU0JMVjlneHNG?=
 =?utf-8?B?UDRnUVhHcDd0UGNGUGsxTUNMQVM0Ris2VXYrdUMwb0M4K3lsVElJUnNPWkNx?=
 =?utf-8?B?UFp6SmxNQlJ5ZCt2T1RxYWEreUpXbm1wWkFFWS9iTnRtalh2VEMvU0RuOTVW?=
 =?utf-8?B?ZSttbEw1WElnV3VVaDFpb2ROemxSS2RDd3JUampsVmVWT2trVjV4K3B2a2tZ?=
 =?utf-8?B?cVQyS3FIM0UzS0VoYmx0ZUdnOTdyOHlRSGFFU0JCbXV5U3FtMXVadW5KWUdn?=
 =?utf-8?B?R3BsRjE5UkpKZW43NjlxcWNlSGZRNDUyWHVqeUFheWlFeW82TDIyQ0oxc0xO?=
 =?utf-8?B?VHNTWEdhUytRQmRuRko1Q2FQR1p3Zm1ENWdSM203dCtBeWM3dmhPdVpObjJI?=
 =?utf-8?B?UWZDa1Z3ZVlhaTNFMU9ZMWVTVTl0djVXTXd1VVFKVEE0eVMzeHdpamJkZHd0?=
 =?utf-8?B?b1NyR1dQSGtoZkUrVmVwMHZMYjhhRG9pWStGM1FET3lUNW55NVdiL05nTkUr?=
 =?utf-8?B?QWFZVC91RGl3V0ZxQU5yMVBFaHZUdmM4anhOLy9FbzRDWkxOdFVaaTBiRjY1?=
 =?utf-8?B?ZmtWVmpvZGYxQkNmdElxWlZxZjJ2OG1sb3d6RkE1TnJNU0pRTFNLRzhwNGdD?=
 =?utf-8?B?eTVSK1dqSm1kMHF0Z2hUejhKWm5ralFWU0ZnV0U0ckc0MW13UmhBUzZNWUhW?=
 =?utf-8?B?cjd2WUFGUTRqWTdyMGdMbk8wWTF3TzA1d24xYklNMTBKT1RlWXJiZGlWTkt4?=
 =?utf-8?B?OXp5YVM0Mk9wdDg3cDNMejRERml5UE95TWJXMXQxaEtjQ3g0bjJ0SkxCdTZu?=
 =?utf-8?B?N1NCNEo1aGdxOUF3alhHcDhjVHJSTXJrbXBraEo3NDRDU3ZZQXRhN3ZSU2tQ?=
 =?utf-8?B?QzREclBXVnNXL2x3bEtsa2MrWEhVeUtuQzhTcmVqeVhUN2hnWjNHNlZRWFVP?=
 =?utf-8?B?Z1ZTTnRid2JvWFErYmQyMDd0anBhbnoxbTE3UStNMU8xWVVENW92QkpVMWFi?=
 =?utf-8?B?QVZleGxRUk01RW5ndVFQMmRzM0tvTHMvaUUvamYrVGRzdnlTdHZJM280ckx3?=
 =?utf-8?B?dDQxRTFYWldhM25wY2JaM2R2ZGV0NkYzbFNPVXh1UGh3SnRCWVhiYWRvYjZi?=
 =?utf-8?B?MjVxbmpkTHVja3p1SDM4enFpa2IzMGhqTkRXVmI0cVBLWkFZYTFFa21jcktP?=
 =?utf-8?B?YUl6b0R0K0tlRzFRMVBnRXJTTEQvWktoRFZJY1NjVDlPZEhsa0VPYTJIZGtt?=
 =?utf-8?B?WGo0UldOWUNraTkybWJ5KzNlSE02amlOM1hNdngrVExLUGE2bkZKR29FRE1T?=
 =?utf-8?B?UDU0M3lBUFlLbGxWLzZQSlJLUk0yOFZpSVhCMFFLSDdRdWxoTWRtbDl3VDNs?=
 =?utf-8?Q?qqtgzzHT4s2WOJ1guQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7164.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(1800799016)(366008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0tGY3BSVTZyS0hvZnlYb05CTzVLaUV4ZVloaDNmbDFZNUZ5RnJjVE4reExp?=
 =?utf-8?B?UVViN2FEZVJFelZ0bTRMQnIyZFhoNmk1ZVhpV1JYRDd2Tkh5eGcvVjJXN2Fs?=
 =?utf-8?B?eXlQQ1VtRnNvb1h2SGpPc1lNMTByNndPR2xWL0lpVkh1QU1YempuYXNvRGxI?=
 =?utf-8?B?T2hUQUttejhnVUJabTMzZkZ5VXhmd2J5T094OENGb3lXblJkUzg0RG9rZGZh?=
 =?utf-8?B?UWFMUnltbFhQeEhjWmpYUTR3WjlrQVpOTEdaNlV5clM0QkZ6dVpmZFdyakp6?=
 =?utf-8?B?SlZOaXhKcmVROThCOWV3QlZYSGROc2FLRG1GRzFrL1loMFM2cklJam8xZDZK?=
 =?utf-8?B?UTR6ZWNBUU4wR0Y2K0JaNkQ4VVRRR0F1Q2pDRTBqSURSbldURzFvVXBOLzk4?=
 =?utf-8?B?cE9pd3ZqN0kxWkRLUzVRbFgxaUVYRVhYdnNJSlh5MUx4QjBYeXc5YnFMTFEr?=
 =?utf-8?B?Q1pVY2RMR1MwNGpmeHR1bnp4bkNWWGNubXhLcVpTUngrdFZKK3pYUE1ISVhm?=
 =?utf-8?B?TTF5d0UrZTJRdmFIUW5Iczd0VVMzOExTb2F2ejEvdXRDR0wvRjBpUkdnZGZo?=
 =?utf-8?B?eDY1UFFkQWxUaHlVYm9FWmpBL2hETTVOZE01U2NBbUdWUjcrT0tJcnk3a0No?=
 =?utf-8?B?MENQejczTlNJVW0zeUN3b1BLV3B6SE9aQ0tSdCtmUXBzeU1qeDBxL21Yd0Zz?=
 =?utf-8?B?aEd4NHlEY3dTOHVXa0JYazVKQmlHTHpiTmVJOE9QdDdubmpJeVBRZ2dnUnpm?=
 =?utf-8?B?RjBqNk5rTmlndGhMeDJOZk5IaVc4d2RZY0dXQUhDOWVUaWswZm5EY1ZYUDc5?=
 =?utf-8?B?Y3VZaGl5Q0pjOFdKMmJqUGIzbkF4L3hjbkxlZGlpQUtZODRGT2NKTlg3amRI?=
 =?utf-8?B?alJiSEczSGhaWkxOWFZsSVBqbXlsNGJFVkNEeUgrS0pYNlhPNHpzZFVTdGt3?=
 =?utf-8?B?N01GdFp6WXV0aVRJSEJpR1ZDUWhXTHhhNjBjNmdmQ2xBS3AxTnptOG40eHRq?=
 =?utf-8?B?VFpIdHRRSi9YRWFiZDA0RE9uVFN5NkpqdHZrbkg3UVVzQkdOVEs0QWxXd2I1?=
 =?utf-8?B?bTM4NjA4ck9scmlsVXcxQzBCQk8rTG9aRmJpYW5CSVFLZXZkY1JGZ3JJT0NC?=
 =?utf-8?B?UmxDYy8xaEY5TllOVHRuN1h5TEtrMjVpbTdvbEkzdmFidUZocmxmWXQ4Yjdp?=
 =?utf-8?B?TU1YL3VGaFpuTzFta0pidnUrZkIyZVAzb2tydGVxS0pvbnY0TXRSR2VDa05J?=
 =?utf-8?B?aGR6S3pWUG9mNXdRRThBcTZHbjc0VjUwWjM2UEtiNGxQSjhVM1M5UXExTHQx?=
 =?utf-8?B?akdBM0YzZDBYN1dJWTRLRTBKZ0JnbXJuL0JDMFc0c2VIN3RSR3lOdFRXMmJ4?=
 =?utf-8?B?QVlrdkRNRjBPQXBEMDVxU1BxUGpnbTlKVXYzT0RQTXl6SnJEWElJNGp3OTFw?=
 =?utf-8?B?N01Qd3cvN2ZQdHVsVkkwOUVNenY0RnZ3RThkaUpXZ285UDJLaHdMbWpwSm8z?=
 =?utf-8?B?MmM2bXhTUFExd08wUllKWUtzOEhXQW1FSE5nMFM0Q1NaTUhoZlprbXNKWi9D?=
 =?utf-8?B?SzNldzU1bzRnbHQ2Yy92UjAyZjR5Rm93Y0hZQ0NBdTZCZE4vYWpEK1R0UTAr?=
 =?utf-8?B?SmRMdnl2bitSRExablJlSGVSOW45dnZiVm9WRVFKOUFkM3JSQjdrdk43NVI3?=
 =?utf-8?B?VE14VDRFWURqd3NwM1R1d2gwR1JwR1pMN3NrWnhwVkxaVGJZamtiRXg4YlA1?=
 =?utf-8?B?VlB2allJb1czTnRUYWNyOEFSVTVud3RORGk4MzB1VFNYb2x6T3lkV2NIMXB1?=
 =?utf-8?B?dXRoN2tRT0ZZbEs3bzlkcFc2Zm01R3JnbENydWY5Sk8vbEQ4SEU3RHVIdWlr?=
 =?utf-8?B?VERtSUNLS2xYMTEzNGNnRjJYMUFZcnBhcWRpamdhd0FPbGc2ek93aGcyN0dC?=
 =?utf-8?B?L2ltQmp0UGk5Zmk0UlAyamF6aUdLcEtUbHBDRUpuamsrVmR6T2NUdUVHNlVt?=
 =?utf-8?B?aWJIN20rdmxPcitwM2k2Z3dtQk5CVVkvMHNyWUZPZ3AyR0ROVkJodHdpTUpx?=
 =?utf-8?B?TXZQaUZlaWtIK1BMbXRTVmR0NEdTVklNQmJFejk4RVZUQmM2eDA2ckt4N0FD?=
 =?utf-8?B?QmdCK0hBS2JnYjQzd3dXN0hLNUxiZ0o1TUYwNXVjbEVxYTJqenZ3cVcveXB1?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3bdc76-7366-4b81-e402-08dc8a5f33ec
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7164.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 21:41:07.9819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkcCJsg/X1CWzfAvO7QKI5prqnTZe32lkye8YFSObPhjdZoLI9rekakdwTeDOoAKV2PVc9hDctCSImbk8oMoYB4r4/Uv6NdDsAw1eFP0H2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6374
X-OriginatorOrg: intel.com

This patch is no longer needed, as the rework leads more destructive 
code changes in the AES-NI side.

Thanks,
Chang
