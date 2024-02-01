Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10AC8612F
	for <linux-crypto@vger.kernel.org>; Thu,  1 Feb 2024 06:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706768197; cv=fail; b=fnsXCchq1RIfFTSVQpsZCpG2g7sK3bS77uJLDEeSdsbM5F0oa1ii217ZaLAFmYn/MiuxyXCXjTo3FYMJsA5LXZUZrfLJyfGBkxVve2rzFLLJMeCzkFv/sMME8nm5Qeg5sRjEyLqSzml1qnigV8M5SvGGH15q91jTALbOmrSXx94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706768197; c=relaxed/simple;
	bh=ZF+d/777FUhYK+/WVqmhTDsr7hAX+OxKWytqoC/4R0A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=bRB9ygu72oM6ZT4fglLMAaS1NUgv/djZbS1Hz0/o5E1+6OWtsdw/uA3s5hXGYa9RpPYjtQr+6jJ/v5xC3X7ELfZnnkNjqBFFIQpGthifY8tp8/GcBzT24U3a6OJyZR+S9GOTw+sjnR0ziDQ7zv3rAFHTaM+9qVW8Atqid0QKFsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nj/lVd+N; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nj/lVd+N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706768196; x=1738304196;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=ZF+d/777FUhYK+/WVqmhTDsr7hAX+OxKWytqoC/4R0A=;
  b=Nj/lVd+NVvzdKS0LWUS0Hlpie7X5o0vOhi8z2lOoAPkRt4n+03e/5dc8
   1ElnVb9Fn/q7ySQS2PJr1mCnEG4v5VQ7SPk7nf1+co2dU1g2m9Ixhz0l0
   uB4n4tQ4H/0iJijyM2QIxo3u1ovOkUA7Fr6Pf5fArwrUbtTJire0i5iNC
   b/LSrJ88EBuHZmwmqJDIpAW2YNE+McsiUROr6MIxZ5OX9v9NW0j1RahA1
   BVcZbl8vAltmjmOIeuqKCWmPpLWHo7yn2nU4SglP1bO+wePMIHph1FsAG
   4GuL5GoRjC2c0NjB1vZd/aJHjdQtzWFglyMSJymcWTbRLcaU6rThAO39P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10575880"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="10575880"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 22:16:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="30778387"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Jan 2024 22:16:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 31 Jan 2024 22:16:33 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 31 Jan 2024 22:16:33 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 31 Jan 2024 22:16:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHXSUblR1n95E67fiHw7NUqy3jQ103Q2Q7EON98CAHjjaoJ/OHEqt59SiwCXY5jFQQnIaU0Fi6C7SUouSRvlLWmhaeooI9LOSQBodPo5+7ubAFtZ/S6qVoEMSd32mvHN35uOIIhsbdJ8bY3EO6btl7P0jlSPwxBmOKyUsGrVhREGFjKnYLOVNPZhMwJj/zPSi+fLOyh191lrb4bcWXK4aPQq9ggStetSv7qiD50aY0Kv+Zi7SwxhMMWuAAq4+MW/idxM+T0SFTZBofiTEgjq+ZDTLQ9s8irbxWjcPH9sIzuc97hmvnB5aycJfGO0g5UVcnHwlL04/IYGpDMsQqt9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLJVdeBTH6do4l8vOINzoX3ETqqtklSfJH7y8aUiF2w=;
 b=j7h1mAzWfL6OrodlWW2VJdfaSGgN5P6oQ3GlMkEOdHitwu64FqNUq0FXWrZN1yHwKeJoTe6x8ugiHl8/a2oVxRJ28fFh+mwJEfwVpzExnTKIir4CTKELMPotg1u4yi4ynWZUVWSyzg0rt0L+ag/SUpEl566o0Sh9VOe8r+iptxgXqQS3O+lrx2JYfxhgGgvd+IaAip+Lo2pk//C5Q4cuNdVPG2uO/ED+g20oQ/D4Zfi9+Hdva2l+345w4ROoFuuSj5O+khEOz3/J1Nzhvl5RKVVJVHWQ/7ILilIGhcjLNL77rXy/64nBMNx3JEKqG/7I0M+5X/h346Hff62lhbaIuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5906.namprd11.prod.outlook.com (2603:10b6:303:1a0::21)
 by DM8PR11MB5592.namprd11.prod.outlook.com (2603:10b6:8:35::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.29; Thu, 1 Feb 2024 06:16:31 +0000
Received: from MW5PR11MB5906.namprd11.prod.outlook.com
 ([fe80::295d:9865:fc32:12d1]) by MW5PR11MB5906.namprd11.prod.outlook.com
 ([fe80::295d:9865:fc32:12d1%7]) with mapi id 15.20.7249.025; Thu, 1 Feb 2024
 06:16:31 +0000
Message-ID: <ae7d2c3f-f09c-473c-9fa3-8a7c4773c0df@intel.com>
Date: Thu, 1 Feb 2024 08:16:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] crypto: qat - add heartbeat error simulator
Content-Language: en-US
To: "Yep, Mun Chun" <mun.chun.yep@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, qat-linux
	<qat-linux@intel.com>, "Muszynski, Damian" <damian.muszynski@intel.com>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, "Segarra Fernandez, Lucas"
	<lucas.segarra.fernandez@intel.com>, "Atta, Ahsan" <ahsan.atta@intel.com>,
	"Rapoportas, Markas" <markas.rapoportas@intel.com>
References: <20240103040722.14467-1-mun.chun.yep@intel.com>
 <e62cbd69b47543d18600920565b5dfa3@DM4PR11MB8129.namprd11.prod.outlook.com>
From: Tero Kristo <tero.kristo@intel.com>
In-Reply-To: <e62cbd69b47543d18600920565b5dfa3@DM4PR11MB8129.namprd11.prod.outlook.com>
X-ClientProxiedBy: FR3P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::21) To MW5PR11MB5906.namprd11.prod.outlook.com
 (2603:10b6:303:1a0::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5906:EE_|DM8PR11MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: 56d68d2f-ec7a-4c4d-d380-08dc22ed54fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMNg3BJGLxHLcWsz3zbgLTyqLahq2TLRb5St+wXedDjet6J0kO7XGfPTHVVoVOdnfORrLSzRZzsJYlTmUicApp+bdmP7XLupZ+sCNeNGoNn6qg0+xE5hAW+CcxKDpGMFl6qeshVDO/6oyLWWeZAhhuvomVYESqbwaek+EVQjfI6j1V1rFPlyXJov9s6NqydLTnOGWdJe17LM13HVU9rUL+Zu/rtindZRY0968f7ykVYWedQiN0fGycHJB18lLhnS5VjzEazWJNr5Fyheuyou8Io/JTdrQBU1miz2+zam3/N2ucwDhYSoNhZa6UgShowh2ygNYOt4kP+TEnhDlDBkhfIHfY7b830zoCLAfI2A8JWtlrAMa9sfA7IX/O5iZZLwYDBzBMi1NZcLOl2t3uJik/ek6nV3Jg8/zqTXZ6IO/zFSxXN/7VBNJANs885z0/XFIl0PeaODoNdS66WvrVIDKk4nAgFy16cUXyIXsBo33k5RsXA2zeV5ggYETB7pFsVCZAcOq86aeIh9YFDkWE4kNja6fCQFdUAaSVl3uN08ZRVtf1caQ0LJoOiRGmfrxLxhpDW98TPH52Aa3rNZKJkvrvca5iSahOdQaBBjzMDvCTpGN+p+z+sqKp0F5Q4HbaBQWOE4R0kXmJD6k5tY4NRdIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5906.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(376002)(136003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(6512007)(38100700002)(26005)(2616005)(107886003)(5660300002)(44832011)(8676002)(8936002)(4326008)(2906002)(4744005)(478600001)(6486002)(6506007)(53546011)(6666004)(54906003)(66946007)(110136005)(66476007)(316002)(66556008)(31696002)(82960400001)(86362001)(41300700001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmY3YlY0NGpmbUNNVThZbDBwWElybjFhTHpQZGNQWmRzSWJ3NkNBclA4VE15?=
 =?utf-8?B?Z0REcHQxOG1obmgyVkZFbklTZEpyV09LZHg5dlU4Ukp0UVNhUzFCQmR0bjd2?=
 =?utf-8?B?bGdnTmwxdHhadWF0VWVaVWplSjVIV0pHenJYbnoxRGVhUUJldENGVncxaXJ0?=
 =?utf-8?B?QkYyWktzNTdNaElFdm5oNTFPUEhVdE5GUlhSWlhJZCt2TFB4emFjQXB1M3BT?=
 =?utf-8?B?ZFBUSmVjSXkvSjNiamQ2MmY3ejVaUC9GRWx3VmZRclpBdGlDTjRUcHdEeVB5?=
 =?utf-8?B?U1hObHA2TGRoaTJ1VWg4bWE5a1VaUXorOCthUnVQckpNRCsyL2h3TWJnWkFM?=
 =?utf-8?B?RU5zMFYzc3ROTW1Lamk2SzRDd3dxbE5LQ3hHM2tWTGlidjRGVGZ1OVdRS0ta?=
 =?utf-8?B?dGFyeGFES2ZhY0h1WXZFUWtDeUREbldETnFTUFlmOFQ1NnJjR1g4T3NlZndF?=
 =?utf-8?B?a2lZL0h4cXM1aVEveHB2TzAvcUpXaUVteUl4MW9kVEpUREsvbTJ1K08va3li?=
 =?utf-8?B?ZWc4T0xmQ1BVNEVnR1I2WDh1ODh2RFE1MEgwVy9MRVpROUN5MHp0SDRQWTNH?=
 =?utf-8?B?SGJRQTBCaEdTQ04zOWIxT3ZoeERyQjVnWHg1My9hSk1XRERwUllvQkhPaEZz?=
 =?utf-8?B?cEVJQ3ZHQ3NUUVVBVGc1MWczRS9rVEJWNU1FeHV5ZFhLWmJicEJMaUxKR2xp?=
 =?utf-8?B?bFgxZVluY2treloydE90YlNMekVndURSak1EKzR4VC9VcmxvOE5mNUdMSTE0?=
 =?utf-8?B?bVdoMDljeWVvNXh4M1RsT29zR3RFdzRVVHZOSlEyQy9CQWx1Q2lOSms4aGZJ?=
 =?utf-8?B?bXFmOVFEVUVJY0RONlAwQzh6WGJOS2p1L3BLckZVSW1DL1hSU00wcGlPSkZL?=
 =?utf-8?B?Qm1iNFg4bEdqMXhBb1BWNldsVTB2YjZ2K2FlS3pIRklyMjlyVUZCUU9heWNR?=
 =?utf-8?B?U0EzVjE1emNuUTBzMjN2MUp0cTB2emtPQVM5Q0h3UUI4eHZyTUlmN2NBNnBu?=
 =?utf-8?B?MTRsZzBWejBIaDBneklOZ0tDdUsrQTZqbFlDS2VlUkdVSE1RQUFVYVJ2Tkt4?=
 =?utf-8?B?OGh0dGVVamxiaEM5QjFpQmF5R2xKTXVReHJOMmRqQVdJOTI5Tnl0QllTYkRp?=
 =?utf-8?B?RUZOWFZyN0x4ZkZlYlJ1QjlDb2p4STE3ckFIVWg3OENycTVRMURZM25STDFu?=
 =?utf-8?B?eStvTHNSR2NkbG9aNlR4OGppSlJPZG9WczV4YXBRU1lnZEx0eGN5ZmMwYWtr?=
 =?utf-8?B?RlJoUFFmamNOdUlvdTM3SFNLUXc4U2NUUXFNa05zM0h5VWtBOG9uaTMxU2Jk?=
 =?utf-8?B?Y2ZLVkFoOXFqMXBvQTBzYWxtT0pNNHVHTVBUV3NvU251bFFRRkVPa2hiOEZv?=
 =?utf-8?B?ekQxVEtCRzZZcnl0ckR2QW1LQXlxeGJNQ2RsVEE0UitrZGlIaG5Pa1NCSEQ4?=
 =?utf-8?B?QVloekNzeXphYXJtaER4WjJpR1ovaVJROEVDK2hrMUxhUUhDUUdWc1N4a2Vq?=
 =?utf-8?B?cE1UV0xnTGpwcWJ4YWVJU2k0NzVLK3lPWVROWnZpU1RFSHdGM2tNUjB1OHRV?=
 =?utf-8?B?RnBhdERoOVVhVjBUNmpZUFVOQTR0VEpWQU11Wm1wbWVXUzVoRzBVc2ZuQ3BD?=
 =?utf-8?B?Y3FKN3Nua0NEUEJuaDNwQ3NGMm9uV2w2RVNFajMzaFJENVhsS1dIb1FnNEd1?=
 =?utf-8?B?TzlyZzV0Ky8waDRFTHIzT2JSYVNGU3F5SWlJaUQ4aHVjaGJzZXI0akVFdnR4?=
 =?utf-8?B?eEtqeDdZdjgyQk1VYTluSXZoTyt6WnFCSnRWQThXNEQ5ZlQxbHVSaUlOSGZQ?=
 =?utf-8?B?alZPVVFsQnJoaXk2NGk5UFM2bU1wRk5iZHcwVUFFTzZZNUNvV1A2eCtIUU4z?=
 =?utf-8?B?N055WlhLU3gwMjdMa3B0YWNkMUNTeWJBOWxRV1JTcTgwbTNKblUvYUprcXZY?=
 =?utf-8?B?VmZWdmw1Ym5hUUJuejM3TE16VmNwZjQ3bUpVU1RCTXJLTkFkeUx1eXE3RDRJ?=
 =?utf-8?B?UU9vT1NVWk9VMzk0S3U4ZC9MZnJBNDN6Y2NvKzgvVHN2QUhRMytRaW5ub1Yr?=
 =?utf-8?B?ZFo5NUJocFRwb2VKQzlLdUx5bVV4SnFhTktnWmxTSnhPQkw5a1BsRkVBRmN1?=
 =?utf-8?B?U1Rha2ZkVlhrVEVReVlxaEdJV3hMRFh5dVZGN0xSZGhxdytyVmJKVndtV2ho?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d68d2f-ec7a-4c4d-d380-08dc22ed54fb
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5906.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 06:16:31.0519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxpUKofikyxILyQhGzTXO7Wum8AfY0Ct1lr0BUVmas6UBlH2s/v2sdKWXwmNsSVUTkfHNmsCnE02nuqPKTwOMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5592
X-OriginatorOrg: intel.com
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

PHNuaXA+CgpPbiAwMy8wMS8yMDI0IDA2OjA3LCBZZXAsIE11biBDaHVuIHdyb3RlOgo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2NyeXB0by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9NYWtlZmlsZSBiL2Ry
aXZlcnMvY3J5cHRvL2ludGVsL3FhdC9xYXRfY29tbW9uL01ha2VmaWxlCj4gaW5kZXggNjkwODcy
N2JmZjNiLi5lMzYzMTA2NjczMzUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaW50ZWwv
cWF0L3FhdF9jb21tb24vTWFrZWZpbGUKPiArKysgYi9kcml2ZXJzL2NyeXB0by9pbnRlbC9xYXQv
cWF0X2NvbW1vbi9NYWtlZmlsZQo+IEBAIC01MywzICs1Myw2IEBAIGludGVsX3FhdC0kKENPTkZJ
R19QQ0lfSU9WKSArPSBhZGZfc3Jpb3YubyBhZGZfdmZfaXNyLm8gYWRmX3BmdmZfdXRpbHMubyBc
Cj4gICAJCQkgICAgICAgYWRmX3BmdmZfcGZfbXNnLm8gYWRmX3BmdmZfcGZfcHJvdG8ubyBcCj4g
ICAJCQkgICAgICAgYWRmX3BmdmZfdmZfbXNnLm8gYWRmX3BmdmZfdmZfcHJvdG8ubyBcCj4gICAJ
CQkgICAgICAgYWRmX2dlbjJfcGZ2Zi5vIGFkZl9nZW40X3BmdmYubwo+ICsKPiAraW50ZWxfcWF0
LSQoQ09ORklHX0NSWVBUT19ERVZfUUFUX0VSUk9SX0lOSkVDVElPTikgKz0gYWRmX2hlYXJ0YmVh
dF9pbmplY3Qubwo+ICtjY2ZsYWdzLSQoQ09ORklHX0NSWVBUT19ERVZfUUFUX0VSUk9SX0lOSkVD
VElPTikgKz0gLURRQVRfSEJfRVJST1JfSU5KRUNUSU9OCgpUaGUgYWJvdmUgY2NmbGFncyBoYWNr
IHNlZW1zIHVubmVjZXNzYXJ5LCB3aHkgbm90IHVzZSB0aGUgQ09ORklHIG9wdGlvbiAKZGlyZWN0
bHkgaW4gdGhlIGNvZGU/CgotVGVybwoKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkludGVsIEZpbmxhbmQgT3kKUmVn
aXN0ZXJlZCBBZGRyZXNzOiBQTCAyODEsIDAwMTgxIEhlbHNpbmtpIApCdXNpbmVzcyBJZGVudGl0
eSBDb2RlOiAwMzU3NjA2IC0gNCAKRG9taWNpbGVkIGluIEhlbHNpbmtpIAoKVGhpcyBlLW1haWwg
YW5kIGFueSBhdHRhY2htZW50cyBtYXkgY29udGFpbiBjb25maWRlbnRpYWwgbWF0ZXJpYWwgZm9y
CnRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBBbnkgcmV2aWV3IG9y
IGRpc3RyaWJ1dGlvbgpieSBvdGhlcnMgaXMgc3RyaWN0bHkgcHJvaGliaXRlZC4gSWYgeW91IGFy
ZSBub3QgdGhlIGludGVuZGVkCnJlY2lwaWVudCwgcGxlYXNlIGNvbnRhY3QgdGhlIHNlbmRlciBh
bmQgZGVsZXRlIGFsbCBjb3BpZXMuCg==

