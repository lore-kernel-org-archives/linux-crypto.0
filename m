Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3377934B194;
	Fri,  5 Dec 2025 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764954919; cv=fail; b=bJL4UbC00kZ6/M3gAV8ytGYqfVFpsDYqY76Sa8dNKXuVGBDiHjXD4OT3LILxQrjkYEnF2zXPtOq2sZI60u3FKnOlRCVjsSwNJFRZgyg6uFxqE0uEKrfBoGRhyEWU9qvIopKeXMCVE80n8nJGU1U0DRXXkI+y9XbX1bDiXFjNWiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764954919; c=relaxed/simple;
	bh=vCSI74Le58DnHo2apCNViGMgVC0x/Ymz5Ly4hlat8t0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eNfAT3MM0mq6lzCL+Bt7oKwzX7gKiJob+zruoI7VtgBJBsjhi1rsRMQB6LXf8GeBqsa2EQwwV9E7LjKpqaFJVNx3y66fweigxo+ng8IuJL0SwEYd3k+BcZ5g+p9j/NR2UsInBazsE6G2MLand8a5BWsbs0N2Qr9dpG+zF+RGDoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eqJIRSV1; arc=fail smtp.client-ip=40.93.196.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eqJIRSV1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c1Y16cc962QddVC9VEQvvPtsC3qWIf+6NmshUOovkOlTels8V4dLJuKHjbGUMzrF0JdPGZ7r++XPt4a/zR66tDsR9WwGq6yoKauoIminWjZlgxdLDJGLnE4XlOL4pIiBSQAS8ONwV5bMEWHxcGyLC+PBxQGLhX1HScbCuCpVKjjRjPZnuxuVI/qRU0wcXnsqwR4b6G62SFRGUQEiPE6JLJzzW0MZe0yRu/cMzrt1t7ARPlCBhlNlZia1D0PFzSvqAR4RBYAmhj+zaNGUM65DcerIlWH0QQrHbmTJoVcAMPmjnW2oSnidGboArt3kKgs1NIkndfTn5hATtVuUS+Oypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCSI74Le58DnHo2apCNViGMgVC0x/Ymz5Ly4hlat8t0=;
 b=T1bCeBZL3TLvARA28cuM5N8S015xfCuFHt8m9d7JQ8zbT+FDQNRbkWFixqA6w+Q6UVWhXWg2JhnaKvEYAaZJ2Gi+3VWUeSHx4fAdhK/upPu9IpF8sBKcZ3fTqCG1odG8pbWUVqifulUlKuTxzKMUe7UlJYTKvTnQuT1LEGMmMlFAo+8g8QV+8ItXZatEmf6WSjwVPKyEsD2RNrICHbthGB3KQKutaru63pe4xj4ld/kff9CNMLD+c9zbV7PBF9JAmb5qcqzZeGwkrtEX95HX1vguPjNS7v5dyqknfY70/7rsH5ZywytBxrSd+dUqg31o/DRcIF+6vnlqf4pnqUFEYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCSI74Le58DnHo2apCNViGMgVC0x/Ymz5Ly4hlat8t0=;
 b=eqJIRSV166HghXzpQe4H0DHORTBXdkslwZAuohMijT7hDbOrdEssOTBi0IopITKdKExesXoZ4IL0du1m1cHQ+xYcZpoNGAT8CCLkUMdwMML5CWss4FNXY3EEMYmStquFGkKYUoV3P7vrnnFxStBeq1hp2IGXno+V+Xll02VkmxpXAXQ2YNNvQBSEfY3R14ii0fxqbWhfmSWT5wOtSsUA9cVZBreD18I893GbpVdlOVdR36IxtEgnE1epQPuFymhfnpp8clMFEzOUiFBddh01c8lnjL5t08SzYUIV84ZrwAVqke8JhKetv6YhXRT1CTY3pWOEgDADbrYQXyC/hCrfgg==
Received: from MN2PR12MB3022.namprd12.prod.outlook.com (2603:10b6:208:ce::32)
 by IA1PR12MB7711.namprd12.prod.outlook.com (2603:10b6:208:421::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Fri, 5 Dec
 2025 17:15:14 +0000
Received: from MN2PR12MB3022.namprd12.prod.outlook.com
 ([fe80::7074:6611:e437:bab9]) by MN2PR12MB3022.namprd12.prod.outlook.com
 ([fe80::7074:6611:e437:bab9%6]) with mapi id 15.20.9388.003; Fri, 5 Dec 2025
 17:15:14 +0000
From: Ron Li <xiangrongl@nvidia.com>
To: Hans de Goede <hansg@kernel.org>, "ilpo.jarvinen@linux.intel.com"
	<ilpo.jarvinen@linux.intel.com>, Vadim Pasternak <vadimp@nvidia.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>, Khalil Blaiech
	<kblaiech@nvidia.com>, David Thompson <davthompson@nvidia.com>
CC: "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] platform/mellanox/mlxbf_pka: Add userspace PKA
 ring device interface
Thread-Topic: [PATCH v3 2/3] platform/mellanox/mlxbf_pka: Add userspace PKA
 ring device interface
Thread-Index: AQHcKZ8NLdiowY6PpkewaQI9nVsWLrT6hYQAgBk7wBA=
Date: Fri, 5 Dec 2025 17:15:13 +0000
Message-ID:
 <MN2PR12MB30228850A78FCEE1FB3BF394A9A7A@MN2PR12MB3022.namprd12.prod.outlook.com>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
 <20250919195132.1088515-3-xiangrongl@nvidia.com>
 <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org>
In-Reply-To: <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB3022:EE_|IA1PR12MB7711:EE_
x-ms-office365-filtering-correlation-id: e45234d3-fda8-4814-05c5-08de3421dac4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WTFQaElUMEY5L1V1RVJHRW9KWDVCVk5ScENleWVMK2psdGg0emp4RzZGem8w?=
 =?utf-8?B?TGhueUFxdFlQS1QrUkpMd1JESVd3c08rd09ZU1pqUDlwamxtalZabVlJQXpV?=
 =?utf-8?B?N0IzRUMvS1p4T0V6amtSb3d5NVhWMUI4cS9ZN3lSQzVBZEhDTHRDZmhWQ0N5?=
 =?utf-8?B?RDRpSVNMNnVLMG93cDdqMVpEOW80WWQzQkpJN1lBeDROSFp5WjVXVkJ1cXls?=
 =?utf-8?B?Vzh3NDQ0M2ZJbC9aQmJUSU5LZU10akdPdFh5NVY3ekVSSEp4cUdZdFNmT3pN?=
 =?utf-8?B?VUFiRE9Nck5IUEVRTngxS29xRUZJcmFIcHROTUc2UUZveGIreU54VExFMzVo?=
 =?utf-8?B?NHV0OVNxbVkrRFl3ZHBNWkwxYTNVdHg2bDJWcGUyYml6Z3lwRjdRRk9JMzk1?=
 =?utf-8?B?ZG9sdkJJdXp2b3JUYlFYRUtPSG14UW8zOTVEN2Z4bFVCbUdzWnJQWXloNXcx?=
 =?utf-8?B?djliYXEwR1hxZ1FYY3NEMmZiL3EvekpyVjIrd0Nxb0ZQa2N4OTZzUGVQR1VQ?=
 =?utf-8?B?aGRsMDRSbCs3Y3J4K09RNHFPckRPMy9ab0dlQ0JveXBOd1NrZlhsTytLd3NB?=
 =?utf-8?B?VFdxMFhKK1R1NzRYZzh2a09MTlZzRUI0Q2QvMCsxem1VQWRIL2wvWU9zZkNj?=
 =?utf-8?B?dUxUL3BDUytCZ041Ym52cVE0MVUrQXJVWWdvTmZneXJnSmEyOGFDNTJjeXlv?=
 =?utf-8?B?QlZrWG1Fa3lwRVZsS3pVQzQzWWs5U1ZCcEVTSEVuc1VQU0pRTHdieGRmckV0?=
 =?utf-8?B?L3FtOURPT2N2MGd0aEUrVDF1clRuSmFoV3lzN1o1YVZGTXNXTnRSQlR6UFJW?=
 =?utf-8?B?dzlIMlhFbGhhTWdhZmNNeHZXYzZieFU5bFdBTllmL3BCSFcwVjlyRlU3N2Fi?=
 =?utf-8?B?SG01aVRLYlJOdjh6cXo3L3pzVnB3bHVtUEhvS1pHV2ZwbkhKci9DYjcwZ3hO?=
 =?utf-8?B?QTRzc3RuaVptd1RnMGtWM1IyQU5Bb0NoRGprZ1VRZG8xN053Vk5KdHg0Rkh2?=
 =?utf-8?B?dnlzWjBkTUNRbFZZZlBsZ1VHV1lzdGY5bmZHRytpK2hId2M3bUVlRjhQMFcr?=
 =?utf-8?B?MlVkcHp1RmdRR29QeE9xeGRDSDNFU0I2OXFXbXhDWlNCOXhZNWEyMk1OUW5a?=
 =?utf-8?B?c1pkZ2pDY2VqWVR5cU82Q2NxQmVrODJ6MGdFUjJRVlZZQWxmb2RzeituSktp?=
 =?utf-8?B?clM5YzZhZ3JmNG5hQUN1QmRWTklOVFcvZVV5a0I5RGxCZnBXTEJiTkNFTytO?=
 =?utf-8?B?b0lrWjU5N3A1eDB4OXZMOHp1Y0YvM2dCdW8vbWpUcC9CRGJFdWdvcnpYeDZQ?=
 =?utf-8?B?V3gyQXB3cnB2dTBzVmtmaDM1YVlwYW9kVnlUM3dyVFY4RUxPNXVMcW5LcGl4?=
 =?utf-8?B?b0lQWisrRlpLRldybC91WnorTytxSXpmNW5Jd1laU0dxQ1ZYRjA5YitnTVAz?=
 =?utf-8?B?ZWJMYm9rMjh6eUV0QzhFb3NjUVVaZnh6aVpkTDNqQUNFZkNwKzl1aUFrRStZ?=
 =?utf-8?B?VW81NXpyWEtoMjN0dCtad2VDd0hrNnhvOWl5YWZZUWMxT3hLR0dWSXJTTzNW?=
 =?utf-8?B?Y2c0Zm93TXlrQ2liTE1uT201NXlFYXlZM0tleUU2Nit4eFIvTVBJZHR1dDJX?=
 =?utf-8?B?NXhuQWJJSm1mNElxcGJvanRTaGdRUloxek01M3d2cEtxa1AyVFM1U3NNa3d5?=
 =?utf-8?B?bjFnVm8ydkZDZlgzWmttWm84ZDNWVzVwSEN4MmZhM25ZSG44bzVlSzNDS3dV?=
 =?utf-8?B?MzdtUGxhY3NnMmFKWUNRVlErZndmczV4R3ZzeW1YWW11T21yQVRhUmlRUTA0?=
 =?utf-8?B?aUZCQlpmZE9pRnlvdld4VWQwSTB3eEhiSHpDZDRadVp4TjZaMHlPbEVrcGFl?=
 =?utf-8?B?b2VCMVZxTTRhbXcwOFR5bWdlNnFHVWxXeDFVRE1oSk5aOHJZV3dVS0EzMld3?=
 =?utf-8?B?bkZ1WUFOa1VWVjlRdkFBVmFGRk9ybTZocWhuTStsZFkxejJad3gzLzEramVr?=
 =?utf-8?B?VURLWFIveHlNK25RRUFEaGczWE91VWRQSjRqbTlMRnVQZ2NhT1loQmErWitQ?=
 =?utf-8?Q?4tDKRO?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3022.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q3FvRzMzS3hpRDhoaWxNQXhpSUlOY3FQUGdHSDNaVVBIaisrckNXcjlsd2xp?=
 =?utf-8?B?M0xkRTliWTZLWGF0QnlPd2V6RDEyV2RHajA1MmI5bG5QME4wZmdsK0x2SWdk?=
 =?utf-8?B?cm1MemJYSGhsQ0QyWHNBallUSkc2eXZkdDM5ZlFRZkFQWmxqd2xGYkJHUWlZ?=
 =?utf-8?B?Vkt0YWF3eG9HUU9BUlgyZXZadE1vemVGZitWTTAwN0o5Y1ByWDJLVXpsbnZL?=
 =?utf-8?B?QzZZTEY0b3NsNEprZEtYbmZZN2tTOXRnZmJpQTM0RFZML1F6S3NUbDE5Wkd6?=
 =?utf-8?B?WnBLbDVqdWxiSnpqdXg4MHdXZ24wY2xhRHg0VUhBWXlsc1lOQWJDODU1ZFBZ?=
 =?utf-8?B?SWhlS2ZQVUdOZUdTbGdvZWMxa1ZkK0M4WkhodWtBdVZ5RFVYZTh3RHlKWkZq?=
 =?utf-8?B?cGxLTTV0V2swckk4TXNCbHlXeTZ3WFkwYU5GTkVTaEpVMm4rT1RHZmt4dFc4?=
 =?utf-8?B?aDdrZENpR2hnRzdiRlRrUUFXZGlJaU1aODBUT284Nkt0eWg0UWR0dDBNQjZ6?=
 =?utf-8?B?UlhoSWIyUlVBOFhBZGFJZ1FmTzZ3SFFxTE56YjBhbWM2akliaWhKczZxZi91?=
 =?utf-8?B?VkZHYnNnc0FycDl1bXF6NlcwVjRock1mT3N3WXZLTldJcEhyQWRLNmNUeFE2?=
 =?utf-8?B?WVdxRllWWm1OekZWa1p3N2tYMEJ2OERFekYvcitPZElUVzhuRzBpVVdvZFpw?=
 =?utf-8?B?cGFNbFR2WDA4Q2tpYjZlVG9EL3c3VzBTb2VtSXBQcjZiRm1YVjYvWlpndEUy?=
 =?utf-8?B?RGxUS3FlZThPY2NtQUEyU0FIWVdBamNmb3NhWTl1N3Y3M0d4TlNHNTlpUFk1?=
 =?utf-8?B?QTkwR200VXpDNnl4TW5Pb1VKdEF5VWRxOHN1T1JWbUZmcG8vSjZxR2ZuRlJh?=
 =?utf-8?B?cFVBbTM0NlRTT2ViY0xkYmJGTGpXRDBCZGxYQmp4a0ZQVjZKbFAvbXpmWGti?=
 =?utf-8?B?MTl5V3UvbHdIczFkVVNYWWZlUUdXaW1qNDBQb2l0MGdYb2dDMHVTL1VxQjQw?=
 =?utf-8?B?bXRZUW5LWnNPT1VXeHJjNTl2TnhZUitLcjcxR01IWlRjeUp0Ti9tZDd6TWt0?=
 =?utf-8?B?WGNtZlhFWG9jM2xQVWZVM0VKT05zSWIzOTN3S0M4LysxRUxXYnZ2bnVsNVA2?=
 =?utf-8?B?cnZNWGNCM3FGUUtKeis2NWwxT0N4d3JPTFFkanNoQ21meU5id0NOTFNIaldn?=
 =?utf-8?B?VXBnMFl6S09KWFNmNDBQejcvQTRHakR4c1Q0Nk5OWWVFaHVRZFBuVVV6YTBi?=
 =?utf-8?B?MG51dG5TbFd0ZHZWclJCWGd5YVVHamRXaHhkeWZTRW9WYklDZWhnUlNQTjgy?=
 =?utf-8?B?QjJIbFFPa3l5aFBIWnRweHhVREpkeFcrQ0U5NXhoaXZ6N1pocmxFTVNCRHVS?=
 =?utf-8?B?NUp4YXJ3YkNBd09ka3FFNG9NWVMwY1p1STI5S2ZsbUFUMm41U0NVT2pJZGc3?=
 =?utf-8?B?YUk3UFRYSFcvblBiSHBtSDBYNUYyWGhkY3d5ZFNLLzZhcmNUTDErT2ZhVzJY?=
 =?utf-8?B?KzY0YkM4amUxZDQ4amVMeisxWTk5T0tBcG5UbEMzazNRUXR6QW5CNWtPQjd5?=
 =?utf-8?B?eSt2M1p3VHNUYSt6UkdINk9KQUlreVBtb2NGbGQ3VDRkTXJVOUoxNFB6UC9V?=
 =?utf-8?B?VzNoNnJKV1BsRlZaOFVsTGJpc2N0UWxqbGkzU3FPaFdLaTBIM1hmeVBtUHNW?=
 =?utf-8?B?eVNXK3JQQXFsZVdLeTUvNjYrUWpOSDY4TXY1amt6QURTRVNWS2hEQ3RWN3pS?=
 =?utf-8?B?blFKSSt4S3FpRkxaVVg2WHVIK1Q1aXh0WTI4Y2psMHgxNGRrQ2tnMEYvY281?=
 =?utf-8?B?enpxUklFcThVZVJkMWhoZWFmVmdvMEF1VVM1MmlQR3RCTUw5a3R6MzMxdWE5?=
 =?utf-8?B?YlZibllvMWFwQkxiMis4RHFGY3kzcmNMSU5uR2ZNMWExazBDMU1CVTNnbm5t?=
 =?utf-8?B?R2FTa3MzSlM3OXdoc2pkZFYzUDVkcmpnSTdRa1JCajZGY0dsN0NOdGp2cVh0?=
 =?utf-8?B?ZS9Jb1VkZ016aSs4WkxoQ0FhRnVVQmZwQkV5N1hxSmlSeDE4d1R6UDAyM1lN?=
 =?utf-8?B?cnR3WVc2ZjV4dmd0ZGF2b29zQkZLenZuclNjSUF6WmJVNlBrcGdYbThUbUF1?=
 =?utf-8?Q?dpQ8fyQLcRG7DbAIiqBbOm+ep?=
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
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3022.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45234d3-fda8-4814-05c5-08de3421dac4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2025 17:15:14.1449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWQdpJ0TzlZHKwFi9bCxRr+HKun3gcGNQS+Ho6EIKsxQnw9HncCwKQ//meiP5WIhyxS7EKcx12boVKZECGWvZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7711

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGFucyBkZSBHb2VkZSA8
aGFuc2dAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBOb3ZlbWJlciAxOSwgMjAyNSAx
MDo1MiBBTQ0KPiBUbzogUm9uIExpIDx4aWFuZ3JvbmdsQG52aWRpYS5jb20+OyBpbHBvLmphcnZp
bmVuQGxpbnV4LmludGVsLmNvbTsgVmFkaW0NCj4gUGFzdGVybmFrIDx2YWRpbXBAbnZpZGlhLmNv
bT47IGFsb2suYS50aXdhcmlAb3JhY2xlLmNvbTsgS2hhbGlsIEJsYWllY2gNCj4gPGtibGFpZWNo
QG52aWRpYS5jb20+OyBEYXZpZCBUaG9tcHNvbiA8ZGF2dGhvbXBzb25AbnZpZGlhLmNvbT4NCj4g
Q2M6IHBsYXRmb3JtLWRyaXZlci14ODZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIHYzIDIvM10gcGxhdGZvcm0vbWVsbGFub3gvbWx4YmZfcGthOiBBZGQgdXNl
cnNwYWNlDQo+IFBLQSByaW5nIGRldmljZSBpbnRlcmZhY2UNCj4gDQo+IEV4dGVybmFsIGVtYWls
OiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gSGks
DQo+IA0KPiBPbiAxOS1TZXAtMjUgOTo1MSBQTSwgUm9uIExpIHdyb3RlOg0KPiA+IEV4cG9zZSBl
YWNoIEJsdWVGaWVsZCBQS0EgcmluZyBhcyBhIGNoYXJhY3RlciBkZXZpY2UgZm9yIHVzZXJzcGFj
ZSBvZmZsb2FkLg0KPiA+IFRoaXMgZm9jdXNlcyBvbiBwZXItcmluZyByZXNvdXJjZXMsIGxheW91
dCwgYW5kIGNvbnRyb2wsIHdpdGhvdXQgaW4ta2VybmVsDQo+ID4gY3J5cHRvIGFsZ29yaXRobXMu
DQo+ID4NCj4gPiAtIENyZWF0ZSByaW5nIGRldmljZSBub2RlcyBhbmQgbGlmZWN5Y2xlOiBvcGVu
L2Nsb3NlLCBtbWFwLCBpb2N0bA0KPiA+IC0gUGFydGl0aW9uIDE2S0IgV2luZG93IFJBTSBwZXIg
cmluZyAoMUtCIGNtZCwgMUtCIHJlc3VsdCwgMTRLQiB2ZWN0b3JzKQ0KPiA+IC0gUHJvZ3JhbSBy
aW5nIGluZm8gd29yZHMgKGNtZC9yc2x0IGJhc2VzLCBzaXplLCBob3N0X2Rlc2Nfc2l6ZSwgaW4t
b3JkZXIpDQo+ID4gLSBQcm92aWRlIFVBUEkgaW9jdGxzOg0KPiA+ICAgLSBNTFhCRl9QS0FfUklO
R19HRVRfUkVHSU9OX0lORk8NCj4gPiAgIC0gTUxYQkZfUEtBX0dFVF9SSU5HX0lORk8NCj4gPiAg
IC0gTUxYQkZfUEtBX0NMRUFSX1JJTkdfQ09VTlRFUlMNCj4gPiAtIEFDUEktYmFzZWQgcHJvYmUg
Zm9yIEJGMS9CRjIvQkYzIGFuZCBwZXItc2hpbSByaW5nIHNldHVwDQo+ID4gLSBEb2N1bWVudCBk
ZXZpY2UvcmluZyBpZGVudGlmaWVycyBhbmQgaW50ZXJmYWNlIGluIHN5c2ZzIEFCSQ0KPiANCj4g
SU1ITyB5b3UgcmVhbGx5IHNob3VsZCB1c2UgdGhlIHN0YW5kYXJkIGh3LWFjY2VsIGNyeXB0byBr
ZXJuZWwgQVBJcw0KPiBmb3IgdGhpcyBhbmQgbm90IGludHJvZHVjZSBhIHNldCBvZiBjdXN0b20g
aW9jdGxzLg0KPiANCj4gSSBndWVzcyBhbiBleGNlcHRpb24gY2FuIGJlIG1hZGUgaWY6DQo+IA0K
PiAxLiBZb3UgY2FuIG1vdGl2YXRlIHdoeSB1c2luZyB0aGUgc3RhbmRhcmQgaHctYWNjZWwgY3J5
cHRvIGtlcm5lbCBBUElzIHdpbGwNCj4gICAgbm90IHdvcmsgZm9yIHlvdXIgdXNlLWNhc2U7ICph
bmQqDQo+IDIuIFlvdSBjYW4gZ2V0IGFuIGFjayBmcm9tIG9uZSBvZiB0aGUgbGludXgtY3J5cHRv
IE1BSU5UQUlORVJzIGZvciBkb2luZyB0aGlzDQo+ICAgIG91dHNpZGUgb2YgdGhlIGNyeXB0byBz
dWJzeXN0ZW1zLg0KPiANCj4gU29ycnksIGJ1dCB3ZSBjYW5ub3QgbWVyZ2UgdGhlc2UgcGF0Y2hl
cyBhZGRpbmcgdGhpcyBjdXN0b20gY3J5cHRvIEFQSQ0KPiB1bmRlciBkcml2ZXJzL3BsYXRmb3Jt
L21lbGxhbm94IHdpdGhvdXQgZXhwbGljaXQgcGVybWlzc2lvbiB0byBkZXZpYXRlDQo+IGZyb20g
dGhlIHN0YW5kYXJkIGNyeXB0byBBUElzIGJ5IHRoZSBsaW51eC1jcnlwdG8gTUFJTlRBSU5FUnMu
DQo+IA0KPiBSZWdhcmRzLA0KPiANCj4gSGFucw0KDQpIZWxsbyBsaW51eC1jcnlwdG8gbWFpbnRh
aW5lcnMsDQpQbGVhc2UgcmV2aWV3IHRoZSBqdXN0aWZpY2F0aW9ucyBmb3IgYXZvaWRpbmcgdGhl
IENyeXB0byBBUEkgZm9yIHRoZSBQS0EgZHJpdmVyOg0KLSBPdXIgcHJpbWFyeSBjb25zdW1lcnMg
YXJlIHVzZXLigJFzcGFjZSBUTFMgc3RhY2tzIChPcGVuU1NML0JvcmluZ1NTTCkuIFRoZSB1c2Vy
4oCRc3BhY2UgQUZfQUxHIGludGVyZmFjZSBkb2VzIG5vdCBleHBvc2UgYXN5bW1ldHJpYyBhbGdv
cml0aG1zIChEb2N1bWVudGF0aW9uL2NyeXB0by91c2Vyc3BhY2UtaWYucnN0KSwgc28gaXQgd291
bGRu4oCZdCByZWFjaCB0aG9zZSBjb25zdW1lcnMuDQotIEFkZGl0aW9uYWxseSwgcm91dGluZyB0
aHJvdWdoIENyeXB0byBBUEkgYWRkcyBleHRyYSBjb3BpZXMvY29udGV4dCBob3BzIHRoYXQgcmVn
cmVzcyBvdXIgaGFuZHNoYWtlIGxhdGVuY3kgYW5kIGJhdGNoZWQgdGhyb3VnaHB1dCB0YXJnZXRz
IGNvbXBhcmVkIHRvIHRoZSBkaXJlY3QsIHplcm/igJFjb3B5IHF1ZXVlIFVBUEkuDQoNClBsZWFz
ZSBhZHZpc2UgaWYgdGhlIHJldmlldyBwcm9jZWR1cmUgY2FuIHByb2NlZWQuDQoNClRoYW5rcw0K
Um9uDQo=
