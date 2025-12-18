Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5F633064E;
	Thu, 18 Dec 2025 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766084349; cv=fail; b=jug7O3QY6FzpeOWamYAwURb0p3UlLiMKV8wZ3Wul97441BUB1YZuLk+aPyabnL/ddGHNZCcpWMzigRxHUUUWdf6FF/SIl0CUV7Pd9vQY7UBVvtFf8d6cT21vqHDJZe51a8LGllAZi+HgUVFiCtXu4OyyeOvmyhUMpnaTsNJYkdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766084349; c=relaxed/simple;
	bh=K+3tRcmkgOza233HnyZ/Aa+nDfUCfiyqv8YRHPaZsis=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ODv+e+OT4gokG+lzkEZX7G8tpKV1XqNTaCVaS7hUjlSseKXzkforPa9SAfpE0TaGF8Dqanf7isgTDz6V3cxL0Vhn59L2LrrlcuGohgONUIBzl+H7j6m8moMBtTwRjVYmqkLk/KvJyA+JSSM+fT1/Rx/N93CAlabAYF2egdolmog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dpcqf8Kf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aOdB7OP6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dpcqf8Kf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aOdB7OP6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIHfuan1393757;
	Thu, 18 Dec 2025 18:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mhm/sg7vUOT4xw9FYzaLycXG+Xqf1EMVclG8ivfdMWo=; b=
	Dpcqf8KfzNFwM5rmPlMYv6SfFwRAvADqwbiLiuIpYYqvKzd5b4b5TFolES3DaNDT
	RnN6kBRzN4+5MoF+dKfDGOq4b/KpMkriU1ODrGFvyP/i833GF7p7PLvsZMONjRMM
	nmsR0OsfPk1Tl2wt69vgAvLzGNHNtE+R8HP63LwA8Hm9Vn+JVhYgH5yVtjnjTRD/
	C/qkHl8Xmos1TyBQDOatYI0b0cOL2c9Yfbc5KyfR6L2KSot0vOvicNvD9qKon31+
	CsMi/KDglgGFOGsqPwS4E227mzte9Y9v8aGb9VUnUIgNBF1XMGrjClJXE1e4dRRX
	hzs24iyQ91HVT5jmTG0ThQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xja89rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 18:58:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIHVxOn025232;
	Thu, 18 Dec 2025 18:58:47 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012004.outbound.protection.outlook.com [52.101.53.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkdj30r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 18:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMfQ6sXmXOZZbCyApyrK5U5H6eW8XpP0HS9eJEoWONrmsx8esoLvb7l1KB7tG8cinN0+XilBl/gUHY5lF3JF4Y9PlGwULZjErNhmeutdOKk/R6QGk4FNPcHy+FAk+1zLefH+TPmtewZ+Jtx27AFXLAfl0YqndNDxLvjdjpcFRwKnNP1TGzRy5Za/9ywkqP/fzxSbkZeE7TKJfSExtCcqQP537WfFMXWVxSH40JJ2s1BTXpI4Z0naOGyZ5o395nqjwFQfi8ZPyoZ08KsZKIyS3Zdol2rOvNzvs/kB5S/Am+BJ+gVaiERAyvYbjgsQzorY7lgllGqL2IFcQcKyIcc8+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhm/sg7vUOT4xw9FYzaLycXG+Xqf1EMVclG8ivfdMWo=;
 b=ULyWwXgPhitbwJARjHlLp/ZIk5tIBFJfMUQcUjJEOeohd5GcXk9mXK0MrVE55OLmknk7LYpGq2e+OUQOq1JBrirPNgsW9q3nZR8R1DJmNPrHrDA3dzBs99yHzKTSp+wNE5/1GO8Zg2Do0JKi9QZnl4Q7EC7VjIU47ErK0PAIaQ0d3iSMXIXyUDfmxPBDMxluh372KfFwcMLYRHpOh/o5WDOPEr08nGI4whGlfi0m0NasN3uaICvj2gsMU/uNXv5qOW7GXvb48SRGtLcsSi6uVNg7MZZoXLix1SJ6l/UzyfmyGFqqzSNf32TSsOJ6vX5kcg+OW9RGq6T9H7+zVolmug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhm/sg7vUOT4xw9FYzaLycXG+Xqf1EMVclG8ivfdMWo=;
 b=aOdB7OP6joPcOkRb/CxByhXfByxgbhspn6OY1iBX2Io9zII3HDTm73DbytXmowgmMiCD02kq9e5qZUoVY8fu3RRcx2jnM+k8t3srOUPNxy1AxBI4mmmTIQa+rPRC+m/U0uG6Ou2ocBp2FIOxxi8hk/QLPXoFCElKJUmqs9kNWrk=
Received: from DS0PR10MB7224.namprd10.prod.outlook.com (2603:10b6:8:f5::14) by
 IA1PR10MB7447.namprd10.prod.outlook.com (2603:10b6:208:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 18:58:44 +0000
Received: from DS0PR10MB7224.namprd10.prod.outlook.com
 ([fe80::c57:383f:cfb2:47f8]) by DS0PR10MB7224.namprd10.prod.outlook.com
 ([fe80::c57:383f:cfb2:47f8%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 18:58:44 +0000
Message-ID: <68ae14eb-1d09-4d09-b771-c3af9539d7df@oracle.com>
Date: Thu, 18 Dec 2025 10:58:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: lib/sha1 - use __DISABLE_EXPORTS for SHA1 library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Jason@zx2c4.com, ardb@kernel.org, dpsmith@apertussolutions.com,
        kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com,
        trenchboot-devel@googlegroups.com
References: <20251217233826.1761939-1-ross.philipson@oracle.com>
 <20251217235745.GB89113@google.com>
 <e69b2b27-af03-41aa-a7ae-c4e9c6fe5e02@oracle.com>
 <20251218183517.GA21380@sol>
Content-Language: en-US
From: ross.philipson@oracle.com
In-Reply-To: <20251218183517.GA21380@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:510:2da::29) To DS0PR10MB7224.namprd10.prod.outlook.com
 (2603:10b6:8:f5::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7224:EE_|IA1PR10MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: 047a516a-1065-472a-8f5d-08de3e6777aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0VFYmZzM0hQdnRRTFNleHNzNkhEUlc1RmM1TGh2elBnUUVLNXlKWHBWU3FW?=
 =?utf-8?B?Um5uLzl2a0VzM3JXVWhxTWJQdjZ2SzFkRTZ4NHpUZXVRU3pNOS9LbHd0Wk5O?=
 =?utf-8?B?OWNZbWNzR3FCNHZnOU9EZUNHQU9OTU1RRVZvaW1IbHRRcjNkTm45WEVtNHdn?=
 =?utf-8?B?Zi9qbUsvWkU2OW9vWUNLZzRoSk10bFh2TUltdFUvdy9DVHRzTlE0WnJtL1RW?=
 =?utf-8?B?a2gyMk9BZC9WVzVUY2ZhbDcvZkdZVHZ2SmdMeXprUVU3RTVhVG5vTlFkU2hT?=
 =?utf-8?B?THVrV0oyMllWNnVhakQwREtLeDVlT3E0ZWtVNWdtaXJDMG9XblpZV21kOHNt?=
 =?utf-8?B?NGVjQXlWZTJaUjkwWnlFbnRGNXFRYlk1a1JWdWJWVTU2VkducWxvYk5Jby9N?=
 =?utf-8?B?aWdpVk15SjJaMWdpY0lEdHpiOVBTT1FKbEFaajhRNEJibVBTZ2NLdnFmeUVw?=
 =?utf-8?B?UTdqbGZHSk5EQ1NmYytDVk13K3pUM1llajhlOFltcmYrOVdDQ016cmJRcGlv?=
 =?utf-8?B?eE5maWd6eXM1aHJSK293TGNXM2Y4b3poaW5ZeDZlTWtxanRwWkJDbHNDYW56?=
 =?utf-8?B?bCs3UjVvSEsvVUk2K2FadWk5MEpkYXduRVhmYTMvN01jS2g2SDMyTGdrVWZU?=
 =?utf-8?B?ajJ6Sjd6eGt3K2w1dmlYdllzU09zRHU4Q09hVTM0Z3Z3T1FZZTRoKy9neEs3?=
 =?utf-8?B?QnNzajVucVovVlFZRFdvckRPZTdyMG9Ta25qdDRvbkpCeUJkTGxEQzB4M1g5?=
 =?utf-8?B?UDJVcUVhS1hLMERJU2J2bmhnbnFuUmdtVTlLM2RlRC9pb2JhTG1NcGVYdkhv?=
 =?utf-8?B?NWVXUnhSYjB4UWR6S3BuRmUra0dFNDFxeDhjYkxnUGNhdDMvZzhIc3ZMK3JI?=
 =?utf-8?B?djhjYjhQRjFRTXkvRUF4UGdzTEQvZzZsUkpabCs0QUZTRlZBdjd4Tk9kc0Fo?=
 =?utf-8?B?dXNrRFIzTnlZNVcydHB0dGhYQS9MVEloc05iSTlCSDlQUlhtZFdqQytTaCtD?=
 =?utf-8?B?ajViTXlCRDNjVTV3VWJYVWtURDJGMGVacjdCWWFJQkVUdm02Z0lFaFpkMWRS?=
 =?utf-8?B?M2JTTlV1Q2hLdEtiOVhZMzZMU1ROejdybFlkYlpXbXNya2FQWUlKMTdJdk9V?=
 =?utf-8?B?T3I1WWxPaGU2bkZyYmFHSGdpWGtaMXVJOWoveDNUU0NNVVZ6Y2VpVG9CTWxt?=
 =?utf-8?B?Tjk4ZnJMbUM3YVk3NWJ1ZExSRFByRkFmOVRqRVJlejBZZ1Irb2Q5RHZLYTRM?=
 =?utf-8?B?VEx0c1VXQmJoRG1Bem9WUHdOV0NlR01SVEdoSWt5MFN6WjJUa0NPNkYyK2Za?=
 =?utf-8?B?QVlLY2xEc3pNdGdTOWZ2UHdobFlkM3Y4UFk0bnUycnpDalFMcGs3NTlDcGRI?=
 =?utf-8?B?R3g3ZEsxNSt6RnJlZ1NjWURERHpXQmppaFBOV3JUcTFlZ1cyYkIwNytzeGtm?=
 =?utf-8?B?TGV0cE1YNW1WVVV5R2xIMmxadjljZ08zSTVjYzFXODFPY25UcWE3SUVjQlV0?=
 =?utf-8?B?OWlOTW9td3BnZHJaQ2ZTOEdibmZtYURZS1doVTE4RU5DVFRxTDJaVE1JQWZC?=
 =?utf-8?B?cmFUWkJmUzRHVE9BTjl3MTArdkRNc3JlRGczemdWcXV0ejBSK2lQeEpuRUhL?=
 =?utf-8?B?RzZVVHM1QWc5dW1YbjZtRWxNM2pFNkxVa3hwNlkvQ3lrUFBFZHhFcDFyaERw?=
 =?utf-8?B?MDF5SWFLOHhZd2piR1VaeDZLVk8rYTFNdS95amtudDgwU3VXOGJON3YzRFk4?=
 =?utf-8?B?NTFrb0g4K2RhbnBjbDZnNEFGMHVVVXVHcDNacngwMjlyNmRPWTJta09oOGJU?=
 =?utf-8?B?MDJCc2Q2WE5CL2VpUmlGbG9ML042Y1VBV1kweThvK1I3VGM5UU14UG1aSG91?=
 =?utf-8?B?VVlSc05rbklXNlUyYVd3NTNTajhtNERzZWQvTjkyZEp0ajQ4RlVLamo4TUEw?=
 =?utf-8?B?MlErVzhBbG1ScDdrL3BQWVJDL3BVWXlzMXYvMTIzeDNDRzJzQ04xY2tid0pu?=
 =?utf-8?B?VEdOWUNyLzBRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7224.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1Y3T3B2NytKeWZ0M1RqOWZUa2Z3Mm1tNXlEQUdCVURoNHVJT2lHRzg3UXJx?=
 =?utf-8?B?SC9NZDNWYloxRzFqaGV0WXFWTzluSjZoK2ZIZDdkZnUyMG9od1l0K0huOFBV?=
 =?utf-8?B?SnNNbjJ4Z3pNeTJBWnVzdnpvYVFYdzk3WnBYekJqVm9uQXdFbzJIZXNUYkE5?=
 =?utf-8?B?bHcwSG1rUEdsSWFreTlub1Nnb1Nib0ptcityRzV4aS9BQVRKd3VMbml6UDFw?=
 =?utf-8?B?OUV3Y2RKK0lQL0ZMSkV4QndKUnV5K2hubTFJZ014L1Uxa1hqV2l0aU9UbllQ?=
 =?utf-8?B?dVJmbDdYL09SS2phaHBleG1FVFlIVDZsbStEWHlnRkg3cE0vYm84VHNvTU5u?=
 =?utf-8?B?bVNUTEVJVHAwb1RWOUxubHRnSndWL0JxcE5Kc0IraHo3MEYxendKblR0ZE0v?=
 =?utf-8?B?VHBJMFUvckFhY1VmSWphSEhqV1BpTlhDMlRHRUxZanVuVTlpNE9yZ1NKcXVw?=
 =?utf-8?B?NFFXU09JaUpUWEZqbEFZdnJSVVJucHgyVDNwMU1tVjFrR0N1YytNTWNtbWNS?=
 =?utf-8?B?aTNYVkJRUGF3amFrQzhzS2FPWlNnUllNS2IrSlkwcitndVgrOU52YkUwYzhr?=
 =?utf-8?B?S2xuTTZQUzAzZGFuT2g5K3Exa0VsbEVtUG40Q2ZUR21zZW5OZGtFYWhiMTBr?=
 =?utf-8?B?RUk4ZXVWcEp6eTZ5VTQ4djIrTndReUdEc1YzUytIQjUrZ3p4WlZEUW1mbW9a?=
 =?utf-8?B?bWpScWpMblV1WlFPSmt4WDZPQUMxOEtXMUtPZFFoaGVmR3ZLeGpBQklMck5m?=
 =?utf-8?B?NlZJajYwdTBlNVYzUUJ3dXhrL2xoblE1NE0yelIrVHBhWmJ6VTF6eDhUNkJN?=
 =?utf-8?B?UGc3ZUR5VDdVWHBrRG4rOWJ4WWNCaWlyN21tcTN6WW9UeTFtNzFNb0J0dHRS?=
 =?utf-8?B?M1FUYnNCRnlYd2dhRFEydVBkSXFWMVpHaVZjOVFxc2R5azF6cm4yOHZySVNB?=
 =?utf-8?B?cHhxcElNOUNHTElnallwOXROclNYZ05QMEl0c0t0bGV2QUFFdVdaY2w2a1F4?=
 =?utf-8?B?cTdZYmhSbFZ0NnF2ajZOK2RPNW1zS0VodlJtYnpDbXlRSHVsWW5wWUFoRmxP?=
 =?utf-8?B?L0hFTHVwYkFKYVdIcnBXQ2IxUGdPUmxXdVA4c3J0Yk5EYllHK1NzMHhMWDcx?=
 =?utf-8?B?aDQ2ZFdDN09IdlR5SkZQdnc5Y3pGNWJVcWttVmdDVzhHa2hrd1BsSkFsY0dy?=
 =?utf-8?B?SnZmOGNVL3p1QUpyTnQzRmFKL3YwcVhJbkdxRjNIZGpBSzN5aWVnYm1ZQk1D?=
 =?utf-8?B?Njg0RThocmdYUjR3K2ZVTmo1WVY5R1kxY3N2Rnl1eGFaZGZ2Q1JkWXdSc013?=
 =?utf-8?B?K2ZlZFU5ci9Jci9KK2N1eU5jbW4zc0NzUW52eFBpZ2lVS3oxbk1VWmcrSFdX?=
 =?utf-8?B?RGhRZjlWTFN0UFZyR3IxTHVOSDI0aGRxZ0NYMEhhMVRKSVdWc3RuWGhtd0l4?=
 =?utf-8?B?V1R0czVGQ3dkK1ltdlZtTldYZGtoWDM5b25VUVl4ZFY1N0Y5QUh0dE93c2JM?=
 =?utf-8?B?enBZQmdDTldiOTd3VlpWa2o3bjVBTlFrY21wRE5iOFdZY1ltVEliRC9ENW9p?=
 =?utf-8?B?dU1RL2I5dlQ2aWpiL0VXRExSV0MyTGUvNGFCWjllWThpQXF2cGR1LzZaVDVM?=
 =?utf-8?B?OVgwa0JId2pNc1A3a3U3TU5WTWE2MTNhVkIrUnFSVmQ4TFM2dktSbjZ2ZmV4?=
 =?utf-8?B?Tk5aMGM4RnlGS3VuYU5iNDNMVSs5czhnMmVrZExsMm9PSXJZL3MvcW5lWG1E?=
 =?utf-8?B?dDJURzVya0VZVUVGakR5U1NHZzBNNzBxODJFRTNPNDhGRVFsWXlieEZKY0ty?=
 =?utf-8?B?THVDaHdsYWxYUFNkOW9DeFljcDNDYXNFWkxhVkdVMTRKZFBEeUFzTlZsbThE?=
 =?utf-8?B?RU5DR1E1TVlXTWFOVzhSbTRLZTAvdVFsNmhqNlVGajRUZzVuYnRyQ2k3SzVO?=
 =?utf-8?B?T1dNRU42bTYyOHFXL2l3RHZmWXdYNHRxZFFTTVUxbWRoVjlpZTNjOCtGZWhG?=
 =?utf-8?B?VzJjdXZ1MUVaeFhzdEtpWjJIWEk5TlJETGZMRVRCMXdGTko1U1JxZzduWE04?=
 =?utf-8?B?c0ROb0xabUsvVVd4RWhZZE11ZFRRdWdXSU1wdmpMMjBwM09LQ2JWbldad0d4?=
 =?utf-8?B?VTlaTjNGQTd5bVVDU3pxcFVHck5EZ3JSRjlYOUJXRFZtTlMwZFZsS3JmbVpv?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MJ572QKvLN5KG2ysL5ZyW/JTnbs/QIHtXhceKkkH/dAu4nXoC4iuemSOO8JvqN3oCwyewrtlPzV1gHAWrjwHTJ1grVsYqBuL36oXDn1okEtlVBKGv+0I2fF45usJ/aGtKCsl+8lPNU1qmNnhJ5gMBJ/Lz/PApPCcsCG/Gb+VNYBDbYoLpgZnWbZh+JSpOPshPhotFNGjaDX6ANaFaO9ZMo3hwXKtMtLSwoNprXwEj+wIn1GKfFg26xh6KLi9N9TT1SPwZ/9rsKW3bvAylr4XJNKbVsHhkJcTigFRB9JjvaZGmBqd1LfkP8nZSWwqoJnfePjtIE6iLq4Akjrh9Tn6sX+sx/20KdM+0YRX9JXElNodYYw02fT14rtCdmMRRFOuUzj13OLEKtalvVJxM6l9GnmwP7713atcVOrIY2F9QEDftxbAfVA/l64qzkiympV+zP9nCE6aVkO51BxV+2Usv/2cuU43WcJWn9FlKjq2dHx+h1k/tQTRDZRQBW4yB/RRuij63lvDek5M+kbw6fyxe5xQ6Mj+xyX1WkAdeo/EgB3ZEKh6uibwLZzaFhYHxR5yNd9dJ7w3A2faj0RtMpN2Eu4+cRB98qe0oDuBtHJHkNM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047a516a-1065-472a-8f5d-08de3e6777aa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7224.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 18:58:44.5757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrpPDHwVZARBaU4n78p3H5y8UUbhMCvWxi2Bo9YG614griHBKgpPFdM+ps8uiujYEgKMW2eN25c7qVqygtqKN+iFSpUr6Tc8xfIYM33cMNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7447
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512180157
X-Authority-Analysis: v=2.4 cv=TbWbdBQh c=1 sm=1 tr=0 ts=69444ee8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=9pCdQlG_IEXcpy3LLhAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE1NyBTYWx0ZWRfX5KeJqnbeePiB
 X4xLp5ij/+GS354Pc9L9mvTITJgHkdODwvuXsVHTVlgD0QkZ1vXc6o5pmuf88ighaPeJbpIOCV5
 nPQrZ1uxgl8kfDpTuu7JekKiI1HbjqlwVroNLh6P1IrdUZ863lKdRCBn20E2+9E+LGEl8/ZbhPi
 JHnYpGy+6uAUjIcVSBfa2yNOiglxO16R19/zUsF8fLkoAhgeJmT5nlNNs6f9dRIz13KX6x+oltp
 XFyd/sB1GYObAzYqFMhivM0jesvtmsIWFTlDY+gU0vAg7i9qUiQDNvqalCc+W/n0oL9AEynMcZr
 N1rB195Q4ff/SIyzVIg0zyVjBJV5KgehdyUATJ2CON6+cxXHLLQOJxjiUhf4mE29ia4PhLg/Nua
 u4/KHIlXUvTUrsq3Zkp8EdoYLlVCGg==
X-Proofpoint-ORIG-GUID: Eit29TQIsqXWIItx0nebwk8EQ9KTyDWz
X-Proofpoint-GUID: Eit29TQIsqXWIItx0nebwk8EQ9KTyDWz

On 12/18/25 10:35 AM, Eric Biggers wrote:
> On Thu, Dec 18, 2025 at 10:25:50AM -0800, ross.philipson@oracle.com wrote:
>> On 12/17/25 3:57 PM, 'Eric Biggers' via trenchboot-devel wrote:
>>> On Wed, Dec 17, 2025 at 03:38:26PM -0800, Ross Philipson wrote:
>>>> Allow the SHA1 library code in lib/crypto/sha1.c to be used in a pre-boot
>>>> environments. Use the __DISABLE_EXPORTS macro to disable function exports and
>>>> define the proper values for that environment as was done earlier for SHA256.
>>>>
>>>> This issue was brought up during the review of the Secure Launch v15 patches
>>>> that use SHA1 in a pre-boot environment (link in tags below). This is being
>>>> sent as a standalone patch to address this.
>>>>
>>>> Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20251216002150.GA11579@quark__;!!ACWV5N9M2RV99hQ!NYVuWrBT2adow7b4eijfE5vI_FKAu7wblBsmNDxouC58woEhQhR4m9sOXOpa9xBoUtLLinpXb3T_AUGlTF-nUG5IjA9SszJw7g8$
>>>> Cc: Eric Biggers <ebiggers@kernel.org>
>>>> Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
>>>> ---
>>>>    lib/crypto/sha1.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
>>>> index 52788278cd17..e5a9e1361058 100644
>>>> --- a/lib/crypto/sha1.c
>>>> +++ b/lib/crypto/sha1.c
>>>> @@ -154,7 +154,7 @@ static void __maybe_unused sha1_blocks_generic(struct sha1_block_state *state,
>>>>    	memzero_explicit(workspace, sizeof(workspace));
>>>>    }
>>>> -#ifdef CONFIG_CRYPTO_LIB_SHA1_ARCH
>>>> +#if defined(CONFIG_CRYPTO_LIB_SHA1_ARCH) && !defined(__DISABLE_EXPORTS)
>>>>    #include "sha1.h" /* $(SRCARCH)/sha1.h */
>>>>    #else
>>>>    #define sha1_blocks sha1_blocks_generic
>>>
>>> Shouldn't this be part of the patchset that needs this?
>>
>> The way we read your comments on the TrenchBoot SHA1 patch, it sounded like
>> you were saying to fix the issue directly in the crypto lib first. We
>> assumed this meant a standalone patch but if we misunderstood, we can
>> certainly pull this in our patch set.
> 
> I can take it through libcrypto-next *if* the code that needs this is
> coming soon, i.e. within the next cycle or two.
> 
> There have been many cases in the past where maintainers (including me)
> have taken something planned to be used elsewhere in the kernel, but
> then the code that used it never arrived.  That's just wasted effort,
> both in making the change and then reverting the unused change later.
> 
> The Secure Launch patches have been going on for over 6 years.  Given
> that, I think I'd prefer that you just add this to that series with my
> ack, so they go in together.

I understand what you are saying. We will take it through our set. Thank 
you for the clarification.

Ross

> 
> - Eric

