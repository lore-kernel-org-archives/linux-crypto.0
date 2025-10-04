Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF7C2BB1D
	for <linux-crypto@vger.kernel.org>; Sat,  4 Oct 2025 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759589967; cv=fail; b=CisHYRcoTcankjjfmQ2CXkVTjAjTvBr56uPEuL4nl43Myc/caH4SSi1y+rZzN04bG/Zf6jNrhX1RkaO7FP2sQTg48DlYtX2qD/Oi9HRA9xNp1IEZYEWrnXyV74hchIbCIEiee1ww/KiO1aLFutZCt095OBC7X89ucIwvkgj7Xi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759589967; c=relaxed/simple;
	bh=irpyMg142sfynEJfXmTt6Zg4am2bvOQDimafnFkIQwI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BGAKZc1aV7Rp/xkUqrfyeWvMlCJNvYJCweSkhYUmba9YT6uhlWuaSjfKvwfd1fXEcdSrTmsQAyGOlt2H4vd3tlQ2RFL4VEVItyjSRVUwxgGsk9ELqcYESJ7hFHDqAS1PbodYDjAb7Gdoxfz4xseXAgci/9q6xnvI2ydWaOaZS9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=EC6qqR1c; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wJEj+Cz2; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="EC6qqR1c";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wJEj+Cz2"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 594Be16h3525804;
	Sat, 4 Oct 2025 07:58:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=irpyMg142sfynEJfXmTt6Zg4am2bvOQDimafnFkIQ
	wI=; b=EC6qqR1cMl3H6/ZXdGUdVUW6rQDHHw8BLk3cd5s1w71HvQzatzSVYMvAI
	rEVa9DpCO/eBEFA5Nv4CTcJXH2uiTFFyaX+oJc13P1ifs/qxglOxHTTE65tsScqV
	DQnPdYQqMTkoTT4sZmVoXb0bVkVIgGCbIBV81Mf85ReyKmXNb9EDgxzwffkKDpeF
	2Jd7CQM/Q8Aj4lzhxupAprtt/aBlKWVWzAbUzPmNPDJI++9813OFgN4XTaSUChnu
	JygvRwGo4AWA9cmQJpssu+JGNKkPSD1NK5n8Lc7CW5hGNiMvmHR2EQUJhd3q5jty
	hQP0Dk/jK2UdrBJevWqP4t5tr5SwQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020116.outbound.protection.outlook.com [52.101.193.116])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 49k2wb84th-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 04 Oct 2025 07:58:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/A2VH4Gq/Es0pRejtRgYzjOyrTcTp+dfmHWJLQ1XRCyglTZBsDgFGYY1WkaYlygIRryyVZOvlY2xu9EkE6kDiuxtz0CLd0K6Nv4QlKITi43gwlBP08h2xkuS78jwLiNjgw3DAZ0+fD0bBvOV8wlaXelTTs99AKDbGwAyERp3mKRrYvC4dk+yQfMAcuexkaQbtY9PoPKaJzLz6DM/zF16GrEJQ4I8YqI1KbQ8BgVyqw8c6gfJJWMnVeXGSGLaifeRUb4pM4J+q4NWNEDPZwfAj1DetY2ekHwf4pi905Kjt6LnvfgvAdLyRh68cf22m4BmrC1dTV6Ngl+XUNVXmb2zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irpyMg142sfynEJfXmTt6Zg4am2bvOQDimafnFkIQwI=;
 b=WTeCvqNZ5kjxTA2tVObP5HkUqqMuftzyqiw/nyw3VlO6ayxUZJNqJ5RVt8Y5KTefruytXI3miObnnhybAOUR3mHzDd7VwXgehOQiZmcgHl4LV71BqI6QFBMKChWTVKn2v6Ww/F2z553niXuktQUWCSew0Rj2GMAO+my9kjshfCjG03AoKx0T6rgSsSwDxnGs2Rwn5DJjqws1mj+HTdzGRzEXlqJZd1UtSje8PT9OsiMBq4trnM6L+HmBveTmVTO+ifPbx24EcWaMYG/JDByuyzAqP0TcBZKa0uHMrUZkF+G1FznEUtIlc3L62q3ccPdM2VCI/sLTWdTWCRDPHPA40A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irpyMg142sfynEJfXmTt6Zg4am2bvOQDimafnFkIQwI=;
 b=wJEj+Cz2bpVfL0MAczRYwHJHtEq6LGd7wKSEKf+3lsGKFFutPAyERVp5mMtlg+KRhb/30uzOD7NzOfmAFm9P6i7QqUATMU/pgjHURFBPwbJFltnYqkqltf5p784bwFg9nrvxdz4fFvKrnKpfAvvYosS4V7J8bwkcANKirfGm68i2lKe69POOGjBBb1zaousACVwjbQujEGwa7wwr/15bJ0Tn8QoAhRu5cuXcoFB08wUqCPxXXXwNx74D1uk65jIGfBpULZ00OxNV1Coxdp2wBp8QvDJ/IUe70L5RrzTP9fmdlEZr1RHZiBtCZn5i2q67/pdJf63qehf+b70s/WyasQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS1PR02MB10385.namprd02.prod.outlook.com
 (2603:10b6:8:218::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Sat, 4 Oct
 2025 14:58:43 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 14:58:43 +0000
From: Jon Kohler <jon@nutanix.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Marcus
 Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Neil Horman
	<nhorman@tuxdriver.com>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Thread-Topic: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Thread-Index: AQHcNNr7kq8u0VeiFkOsoQGnAQ00jbSxio8AgACKb4A=
Date: Sat, 4 Oct 2025 14:58:43 +0000
Message-ID: <C9119E6C-64C8-47D7-9197-594CC35814CB@nutanix.com>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
 <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
 <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
In-Reply-To: <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|DS1PR02MB10385:EE_
x-ms-office365-filtering-correlation-id: 95dedddb-d9ac-4f59-eaba-08de03568324
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eVBCSzVTazVLc0xLQTFxc3FudTUwVmRUSy9GUHJLTmxWMVlwZENGbUc3TDhB?=
 =?utf-8?B?ekE2VTJCN0pFazgrNExjaDNqQ1pTTm5EQW5PVHljbW14R05ZNURSUTV4cTBs?=
 =?utf-8?B?VGszREsvWmFvaThGREFLakZoODZrQlA2WGEyOUVKaUVNK3pjMHFCOUJHL0Ur?=
 =?utf-8?B?bGptWXAxUkFKdGU3TmZ6ZWZoUWhoTXlleXN2c1NnMllrUVR2N3VMNjVpdUor?=
 =?utf-8?B?RWJwMnE4Y2dnczBPd09selVUdFRnemV4bzRnTnFZb2ZXeWFvMlFEdVZGeTJZ?=
 =?utf-8?B?d0JZNmJNRXRoaWg3UHk3dHc4N1hTZXpteEs5ZlNTdkFZMXovcVlwNjJkUnpM?=
 =?utf-8?B?b1VDbmpUV0lPcXRxZjdqNC94dVQ1RDFvUHhPZGQrZHJiUVZ0QVJRaEE2WEcw?=
 =?utf-8?B?ZFVqcWF1UTA1VlJFVlNYYkEwaDZ3MlcvblZIbFBFbUEvcnYyR3ZNb1U1ZndF?=
 =?utf-8?B?WFRINFh4Z0pISFlxaWpQTnBIVmZmTit6d1NhU3JIRWdqb2ZtYkFTdUdEaldM?=
 =?utf-8?B?TXZlN25mL2FodnZ2cFkxM1BKWkI4SDFnNGdEdUdnQ2dWbWthZndWNXRRWjlF?=
 =?utf-8?B?ZkFpL3BiZzVDT05yT3dhMzdBMm9TNkdTL2wyQk15OTBOTkY5VTd3R0pUU295?=
 =?utf-8?B?RTV0NmJTRGROWHl0SThDSlkvZWZwemtacnY1T1FtWGdNQVpHTFRUWmkwTEJY?=
 =?utf-8?B?ZHpaT2Jna2JPSUsxWDErWTB1OEpXQW81eVJqRUJveFdOd1BaYXozWnZoYTVQ?=
 =?utf-8?B?V0UwQjU2TkF4TEhyMHExeHNneTcxVjdCOTJCZzd6aGVPenk5blNpMjFZOUVC?=
 =?utf-8?B?NENSUXlKbWhuNWE5OWRxeFc0c3lBTExoRjBWajczek1OQlloNTFoamI4eHNa?=
 =?utf-8?B?THpPY01LYldSbDdjS2l0VXRsNEdESTJMTmxJZW9iaDZCU0NLTThVVUFTSzlD?=
 =?utf-8?B?NjM2S2h5VmtldHdhMzVkQUFvaFAzVHZKbE03QTF3QkEzQWdhUHJycVRRSGVG?=
 =?utf-8?B?TzhYZmJLNi80MUZjZWpPQUpROFZFZy9XQ3M3QjdEdWdJTHBVS0c3eFJTMnlB?=
 =?utf-8?B?V3luWVUxaHl4c0V3YWU0em1nenZ6NEtJRmxUbC9aYWV0SmdVM3pHeW9pNEQ0?=
 =?utf-8?B?cThhQ2Y3aEJUUkxRR3ppUjcwOFRPNTRyd2JHSlpCV0JINmlDV1E2RTJHdG5n?=
 =?utf-8?B?NjdVbVBpcE9UMGpERkRtUTN3Z25Makt6ckUvcisvc1V2Umc5dkFEeFFpQXBI?=
 =?utf-8?B?dVBiZllua2xaZ2VGRXdQeEM4eWpUUmtxWFVYcm95bzRCUmZoZm1DbDZ1bmdE?=
 =?utf-8?B?S1J4VnZoRDRHVUN2Zzh1VG80Tk5peFp2cTR1Nkg0UWh6TGZBeUdOMmdCa3Iz?=
 =?utf-8?B?V2xkOXhmcHpFMDhBTTdFMUwzS2srQzlPdTlacWZTQVJqOWs4WDJyNDdQZmxn?=
 =?utf-8?B?RVNURU95aDl2dDZXQ29vRnRjeGJtTVRPeU5iSzV2bHROSUl6Z0dCY3hmRmNj?=
 =?utf-8?B?c2QxVTJ4NmUxb3lHRnhpeG84Y1RPVms5Kzh1cy9EbjErcVZ6N3dPMlNGdng2?=
 =?utf-8?B?eVNIR09tNU5jUlFoeU4zdFAvdERSLy84UFgzOEJ4RkRhS1ZqY0VpQjlzUVRW?=
 =?utf-8?B?TVBXVFMydzNhQ05Sa1NsaXoyajRkTGlCYXBLY0hwRDV2TzJvOWtSQkdMUjlF?=
 =?utf-8?B?WVFPVTVkcC9TbXdOQ2RIUjhlTHdjRmFvMHNPS251NWgzdWtaVjNHcEJMa2J2?=
 =?utf-8?B?aHBONURPNEIwbFQvbCtCOXhYNHY1TTFFaVluNkJxMTRCc2xhOVNsWnNFWXRH?=
 =?utf-8?B?UXpOdENiUHI5aFdXaTVCN2wzdThaWGpoU2VYWWJoU0oxTTVrZFZYL1lsRkUv?=
 =?utf-8?B?SGtrLzZSV2IvUWpMUm0xYU9YaDJCS0NteFZZNi9VMEpMeFNtSmZtd2U2TmU4?=
 =?utf-8?B?cEZ0UDdGQXBHTFIzcHVBSW5rQWhTejFEaU9XM1dZbGYwSTY1UmF1QzVzOGhz?=
 =?utf-8?B?eWdOOHg3dkJRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZmV4UWNXYjZiTEg5c0JxVTZ5MWk5RzIxQUNJN0dBVFo2TURXZ0o2Q2VyMURn?=
 =?utf-8?B?VTVKbVNpVG43ZEdMKzBIMW5OdlpVWmY4RmpCdFlwZWo2QStmRytsYVBGb1M3?=
 =?utf-8?B?bHVZWml1Z2pocE5iaFF0cjF2dndOMEFERG91NysvNGhOLzFLY0RuMjM1aDQv?=
 =?utf-8?B?a2pOaUNHK3kyN2dSSGRVSXlYODcrK1d2VzlmQVhMQVBubGM4UGF1TVhIZmdw?=
 =?utf-8?B?Y2pwc21hb1B5djVZN0paMzA1bmFValo0bUNGZWFpOFlIUU9UeVdoUC9hOXdV?=
 =?utf-8?B?RFAzR3dkUmRqQzFXMjh0WEx4STVKQm4zamp6c09VYzhnZ0JyN016UTZJaVVS?=
 =?utf-8?B?NW1ZL04xYmNRT1dob0xTQzNjdTVHRFI1M1djODRuKzEvNEhoYjlvYmk1ODVy?=
 =?utf-8?B?VUlGS2JTeDFRak9xNllsT1lnN0l0QlhnTUJyS3lLVjNXN3NSd0N1d1NCR0Za?=
 =?utf-8?B?dXJ2U0owOERaYWEzMVA5WGIwUmFjQW8xVXVHeDdNRG5xYTcrS2tXVjJSVTFB?=
 =?utf-8?B?MENvVXpJR3UyMlhqek5QY01Pb21IQ0E5Y2NEQXpMUERwckN0TVZIL2gxUDJ0?=
 =?utf-8?B?MFJJRDVkUC8vUEhVVmQ0QjB4cmZseXFFRk5nMXAydTU4RDhmMnozelViTGpZ?=
 =?utf-8?B?UUw2WmhrcWlETVN2Zm1KbnN6MmIwYlU3aDl6UzlzeUl4WitzaGZ1ZVJxYitO?=
 =?utf-8?B?L1ZwbTVRekR5a084WXF4V25hcHpvdWQ5eUtzWnhNVnlNcEp4OU1KWjhVMUUz?=
 =?utf-8?B?cFJpRUJsSnNSSkNHY2FuOUtBV0xrT2dwS1drV0hSNmhGZjZhc1FGSGhXVmxK?=
 =?utf-8?B?L1p1aGI5UFlQaEdMbHdOT3BBSjJUbTUwV0VMcDUrbytqa0tCbHZWem9SMFcw?=
 =?utf-8?B?SCtteDNCRFFpZVJ4MjdZNkMwbi9XR0dBMzBBaGNtQzltcWhzaElJb3JiT0pT?=
 =?utf-8?B?dFlCa0J0SGpyTDBwaDh2RVluczVqRUJ0RlBFbjJ4WWRzVkRJZXBmN01JWFJn?=
 =?utf-8?B?TUtxRExMWmYxaTZxTlpCaXZLdUtpd0YxNExuMXlGdnVHc1NjWlFYQ3FRNzY1?=
 =?utf-8?B?QktPdy91eW9vQm9jUmRmWHRqdUJXWis0VWs0U1o1aHRxOWg1TjRxQ29SbGw3?=
 =?utf-8?B?RDdFQWppZ1ZnUEdhbUZxWjJLZ3Q2Qktja00rSnJwQ1VUVUFFREd4UnZmS2lt?=
 =?utf-8?B?QTJhVXFnTFpIRUE5WFJ3OU4wZUtLdWNIRUNnZmlxaXZtNFhOWHdEVHNJbm9Z?=
 =?utf-8?B?Qms3N1hpVUJPWkxkN3BFMitQbFF0Qm41UnB3ZWEwUW5TYjY3QWp3WWhITGRD?=
 =?utf-8?B?R2NFU2NUa0pUMUVveHgyUitEcnNnbXpSZHJWUjV2MjRGaG1MMWJHby9LeHhR?=
 =?utf-8?B?R1ByMVM0cUNEV1pkOHpEdk1KbisvWTN3YkdSYjBRN3pzZGI3ejhyMDIrcmNx?=
 =?utf-8?B?TWtsMnNxNUZqUXBrS01tU2t4MksvR0tHNTJTWkFLc1RTcHlrU0sybHkxOTZI?=
 =?utf-8?B?c0RPSll2eURraDdrK2Vmc2s1ejBEYTZOaWNMcVFvK0VJOWVWOEludjZ6MHZj?=
 =?utf-8?B?c25NaUgxeEpTNnAzM3Q1Y3JtVUtSTVVkdUliaTJkVjI5SE1BUnV2dndhRmtL?=
 =?utf-8?B?Y1cyM0NSckFacmdRN2dVOW5jZHcwRzhnaXlMNXJDL2dyZEFCWXZ4eXpuTG5K?=
 =?utf-8?B?OWdsbkNvb01hbnhURjhma01oZFdkeHdJbDdCU281RnQxaEl5Yk1MVmpXaGY0?=
 =?utf-8?B?SVpSbzdRcWtXaTBObERIRjRxN1VEUU1DdkxFYVNGS2g3amdFZHdUQk1ac3dW?=
 =?utf-8?B?cWU2amNwYzRxZllGTG1XeGI1OXdYN3crOHhWYkVBdGVQZndTUXZIbkkybVVz?=
 =?utf-8?B?MWVMMnk3cmNJL1BLTFJDS0JHQ0xDRXM5eU9mTjlBblMrNGF0S1Z0d1dGQ1My?=
 =?utf-8?B?SjE3Si9pUXAzOW5rcVBCQWU2c0RRODhoaHdQaG9VTEc1bGdITnB4TUxzUzFk?=
 =?utf-8?B?QnVmV01QUFBTUmpya0NJdGhyaDZORzk2eVNKcGtKU2lYdFl0VmhraTdPbi9D?=
 =?utf-8?B?eHh2S2lVU3VzbFRyb0JjRjd0TmozOGgrNWVYU0lKbHYxenFyMjJzQmVpb2dt?=
 =?utf-8?B?c05uSVNMYVd6cXYyU1c0Q2FEbmhnWVJPUGgzSWpwamV4M09GZU96Z01xUnB2?=
 =?utf-8?B?bmhibUdNZjAySWpjQTlNV0luSUswam5DTG1UZGNHaXVBNDl5RTczTndsTnkv?=
 =?utf-8?Q?Our1MfMi/zynJjTZt85VePlnCUPL85MY4WPdg7nge4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <735B82E48B52A341B2B565049F24B6CA@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dedddb-d9ac-4f59-eaba-08de03568324
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2025 14:58:43.4935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dh8bMKfzaKueoEcNyZxdLPQ3pHm2ANV3RzRpjhz73AtRmXAJX9TWTARjAnk74kyX+5v3RWb68tDVzOERSUo1Dc/ztzp++sT7roV/o4n93fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR02MB10385
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=68e1362a cx=c_pps
 a=ncti5ugMhgZX8XAjOw9fkA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=uWu0Y-Ucg4-im58p6L8A:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=HhbK4dLum7pmb74im6QT:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-ORIG-GUID: Ut3PCrN9jD1Wx49jrDtsoV7hYlUDYUni
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDEzMSBTYWx0ZWRfX98bIQXieeA5x
 nlWc2sM0hXErLajVj0CVuMzKbLhUmR0efSmIkABNj3VsYJzP9ZArDQJpAQcSi7nNsCs9d7c2h5q
 wtz3MySdikgBjyIbbI9bz/8OplCOrBKDccz1IXSsMeWdoOLFxP+ic2JDtQ6hHQXBWKEeuxQukZR
 0Gp9l9q6rvaBEekB7YsA4cp3vH7F/YdwUgpGNtMiie8DxPk0HXkzn1veaaBs0qN3i12lB+FTRLM
 Y25Xm5WJy2BtKaSLqartb4LamG0nO09LMmo5cAhs4MvAEIH/dyi8H2awSDGdXPPliRJBMI031a4
 Pb0rYNcnggb1y9xrOxvICCeivHSPN5Hh8w+kepxinfiHryh1l6tpfdhI0dxK+njPKYyPiixEAaL
 JrLbnp+qZbeNEeL1zIHaEJL5xoO8AA==
X-Proofpoint-GUID: Ut3PCrN9jD1Wx49jrDtsoV7hYlUDYUni
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-03_07,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gT2N0IDQsIDIwMjUsIGF0IDI6NDPigK9BTSwgVmVnYXJkIE5vc3N1bSA8dmVnYXJk
Lm5vc3N1bUBvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiBDQVVUSU9O
OiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiAwNC8xMC8yMDI1
IDA1OjAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gSGVsbG8gY3J5cHRvIGxpc3QsDQo+PiBXb3Jr
aW5nIHRocm91Z2ggdGVzdGluZyA2LjE3IG9uIG91ciBwbGF0Zm9ybSwgd2hpY2ggdXNlcyBmaXBz
PTEsIGFuZA0KPj4gbm90aWNlZCB0aGF0IHdl4oCZcmUgaGF2aW5nIHRyb3VibGUgbW9kcHJvYmUg
ZG1fY3J5cHQsIHdoZXJlIGRtZXNnIGJhcmtzDQo+PiB3aXRoIHRoZSBmb2xsb3dpbmcgZW50cmll
czoNCj4+IFsxODk5My4zOTQ4MDhdIHRydXN0ZWRfa2V5OiBjb3VsZCBub3QgYWxsb2NhdGUgY3J5
cHRvIGhtYWMoc2hhMSkNCj4+IFsxODk5My40Nzk5NDJdIGRldmljZS1tYXBwZXI6IHRhYmxlOiAy
NTQ6NjogY3J5cHQ6IHVua25vd24gdGFyZ2V0IHR5cGUNCj4+IFsxODk5My40ODI5NjddIGRldmlj
ZS1tYXBwZXI6IGlvY3RsOiBlcnJvciBhZGRpbmcgdGFyZ2V0IHRvIHRhYmxlDQo+PiBMb29raW5n
IGF0IG1vZHByb2JlIGRtX2NyeXB0IHdpdGggc3RyYWNlLCBpdCBsb29rcyB0byBiZSB0cnlpbmcg
dG8NCj4+IGxvYWQgdHJ1c3RlZC5rbyBmaXJzdCwgYW5kIGluZGVlZCB3aGVuIGRvaW5nICdtb2Rw
cm9iZSB0cnVzdGVkJywgd2UNCj4+IHNlZSB0aGUgc2FtZSBsb2cgZW50cmllcyBmcm9tIHRydXN0
ZWRfa2V5IG92ZXIgYW5kIG92ZXIgYWdhaW4uDQo+PiBUaGUgdGVzdCBjYXNlIG9uIG91ciBzaWRl
IHRoYXQgaGl0IHRoaXMgaXMgYSB0cml2aWFsIHNhbml0eSBjYXNlLCB3aGVyZQ0KPj4gYSB1c2Vy
c3BhY2UgYXBwIHRyaWVzIHRvIGRvIHRoZSBmb2xsb3dpbmcgb24gYSB0aHJvdyBhd2F5IHZvbHVt
ZToNCj4+ICAgY3J5cHRzZXR1cCBvcGVuIC0tdHlwZSBwbGFpbiAtLWNpcGhlciBhZXMteHRzLXBs
YWluNjQgXA0KPj4gICAgICAgICAgICAgICAgICAgLS1rZXktZmlsZSAvZGV2L3VyYW5kb20gL2Rl
di9zZFhYWCBzZFhYWF9jcnlwdA0KPj4gVGhpcyB1c2VyIHNwYWNlIGNyeXB0c2V0dXAgY2FsbCBm
YWlscywgYW5kIHdlIHRoZW4gc2VlIHRoZSBkbWVzZyBsb2dzDQo+PiBhcyBub3RlZC4NCj4+IFdl
IGNvbXBpbGUgQ09ORklHX1RSVVNURURfS0VZUyAmJiBDT05GSUdfVFJVU1RFRF9LRVlTX1RQTSwg
YW5kIGl0IGxvb2tzDQo+PiBsaWtlIHdlJ3JlIGhpdHRpbmcgdHJ1c3RlZF90cG0xLmMncyBobWFj
X2FsZ1tdID0gImhtYWMoc2hhMSkiLg0KPj4gSW4gbXkgdHJlZSwgSSByZXZlcnRlZCB0aGlzIHBh
dGNoIFsxXSBhbmQgbW9kcHJvYmUgZG0tY3J5cHQgaXMgaGFwcHkNCj4+IGFnYWluLCBhbmQgdGhl
IGNyeXB0c2V0dXAtYmFzZWQgdGVzdCBjYXNlIHBhc3NlcyBub3cuDQo+PiBJJ20gc2NyYXRjaGlu
ZyBteSBoZWFkIGFzIHRvIHRoZSByaWdodCB0aGluZyB0byBkbyBoZXJlLCBhcyBvbiBvbmUgaGFu
ZA0KPj4gSSBhZ3JlZSB3aXRoIHRoZSBwYXRjaCBub3Rpb24gdGhhdCB3ZSB3YW50IHRvIHN0YXJ0
IHRoZSBkZXByZWNhdGlvbg0KPj4gY3ljbGUgZm9yIFNIQTEsIGJ1dCBvbiB0aGUgb3RoZXIgaGFu
ZCwgaWYgQ09ORklHX1RSVVNURURfS0VZU19UUE0gaXMNCj4+IGVuYWJsZWQsIHdlJ3JlIGdvaW5n
IHRvIHJ1biBzdHJhaWdodCBpbnRvIHRoaXMgYWxsIHRoZSB0aW1lIGFzIGl0DQo+PiBkb2Vzbid0
IGxvb2sgbGlrZSB0aGVyZXMgYSB3YXkgdG8gb3ZlcnJpZGUgdGhpcyB0byB1c2Ugc29tZSBoaWdo
ZXIgYWxnbw0KPj4gSGFwcHkgdG8gZGlzY3VzcyBhbmQgdHJ5IG91dCBpZGVhcy4NCj4+IFRoYW5r
cywNCj4+IEpvbg0KPj4gWzFdIDlkNTBhMjVlZWIwICgiY3J5cHRvL3Rlc3RtZ3IuYzogZGVzdXBw
b3J0IFNIQS0xIGZvciBGSVBTIDE0MCIpIGFuZA0KPiANCj4gSGksDQo+IA0KPiBUaGFua3MgZm9y
IHRoZSByZXBvcnQuDQo+IA0KPiBJIHRoaW5rIHRoaXMgcGF0Y2ggYWRkcmVzc2VzIHRoZSBpc3N1
ZSB5b3UncmUgc2VlaW5nOg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUw
OTA0MTU1MjE2LjQ2MDk2Mi03LXZlZ2FyZC5ub3NzdW1Ab3JhY2xlLmNvbS8NCj4gKEluIHNob3J0
LCBpdCdzIG5vdCB0aGF0IHdlIHJlYWxseSBuZWVkIHRvIHVzZSBzaGExLCBpdCBqdXN0IG1lYW5z
IHRoZQ0KPiBoYXJkd2FyZSBpc24ndCBhdmFpbGFibGUgZm9yIHVzZSB3aXRoIHRob3NlIGJvb3Qg
cGFyYW1ldGVycy4pDQoNClRoYW5rcyBmb3IgdGhlIHBvaW50ZXIhIEkgdGVzdGVkIHRoaXMgb3V0
IGp1c3Qgbm93LCBhbmQgd2l0aCB0aGUgb3JpZ2luYWwgZGVzdXBwb3J0DQpwYXRjaCArIHRoaXMg
b25lLCB0cnVzdGVkLmtvL2RtLWNyeXB0IHdvcmsganVzdCBmaW5lIGFuZCB0aGUgY3J5cHRzZXR1
cCB0ZXN0DQpjYXNlIG5vdyBwYXNzZXMuDQoNCkluIGdlbmVyYWwsIHRoaXMgc2VlbXMgbGlrZSBh
IGdvb2QgcGF0Y2guIA0KDQpDb3VsZCB3ZSBwdWxsIHRoaXMgb3V0IG9mIHRoZSBSRkMgYW5kIGFw
cGx5IGl0IGFzIGEgRml4ZXMgZm9yIHRoaXMgaXNzdWUgcGVyaGFwcz8NCg0KPiBUaGVyZSB3YXMg
YWxzbyBhIG1vcmUgcmVjZW50IGRpc2N1c3Npb24gYXJvdW5kIHRoZSBwYXRjaCBoZXJlOg0KPiAN
Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2YzMWRiYjIyLTBhZGQtNDgxYy1hZWUwLWUz
MzdhNzczMWY4ZUBvcmFjbGUuY29tLw0KPiBJJ20gZ3Vlc3NpbmcgdGhlIHNoYTEgZGVwcmVjYXRp
b24gY29tbWl0IHNob3VsZCBiZSByZXZlcnRlZCBpZiBpdCB3YXNuJ3QNCj4gYWxyZWFkeS4gTWF5
YmUgd2Ugc2hvdWxkIGp1c3QgYWRkIGEgYmlnIGRlcHJlY2F0aW9uIHdhcm5pbmcgZHVyaW5nIGJv
b3QNCj4gaWYgc2hhMSBpcyB1c2VkIHdpdGggZmlwcz0xIHVudGlsIDIwMzA/DQoNCllvdSBrbm93
IGhvdyBkZXByZWNhdGlvbiB3YXJuaW5ncyBnby4gTGFyZ2VseSBpZ25vcmVkLCB0aGVuIGEgNSBh
bGFybSBmaXJlIA0KMTAgbWludXRlcyBiZWZvcmUgdGhleSBleHBpcmUgOikgDQoNCklNSE8sIEni
gJlkIHJhdGhlciBrZWVwIHRoZSBjb21taXQgYW5kIHVzZSBpdCBhcyBhIGZvcmNpbmcgZnVuY3Rp
b24gdG8ga25vY2sNCm91dCB0aGluZ3MgbGlrZSB0aGUgZGlzY3Vzc2lvbiB3ZeKAmXJlIGhhdmlu
ZyByaWdodCBub3cuIEJlc3QgdG8gZG8gdGhpcyB5ZWFycyBpbg0KYWR2YW5jZSwgc28gSSB0aGlu
ayB0aGUgc3RyYXRlZ3kgaXMgdGhlIHJpZ2h0IG9uZSBhc3N1bWluZyBub3RoaW5nIGVsc2UgZ29l
cw0KYm9vbS4NCg0KSSBzYXkgdGhhdCBhbGwgYXMgYSBiYWNrc2VhdCBkcml2ZXIgaGVyZSwgc28g
dGhhdOKAmXMganVzdCBteSAyIGNlbnRzISANCg0KVGhhbmtzIGFnYWluLA0KSm9u
