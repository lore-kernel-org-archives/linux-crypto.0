Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31E42F2E
	for <linux-crypto@vger.kernel.org>; Sat,  4 Oct 2025 03:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759546860; cv=fail; b=mK1DKcIqkooldpQOnGDJvQ0FGaC0Xd3zU+du2mE1T53LCfbYh/jsueKRiVOFwB7f6gOd/jYu0J5a+3/1JYEUxyuXwke0CNh0F2nrJgCi3R6kNaGWzjLIoBhGtJIWKzKBbNUZ1m8eO8CAyA6Zcpk/qAjbaGTIdIvUhW7fUvDgpq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759546860; c=relaxed/simple;
	bh=FE4Tmss75QRREgQBtYRm+AU14TcQO5TTQY80ArZUG5o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tmPH7PMiksRCail9p1cIuI5EV5yW37yBjVJPyE89hFa5VOpsj498jf2M2IAdZ8Tvhw1EOXxxohtnMxxK5+GnDPjZxNwB8JOgPRRnka86qV0pqo9P6dHsPnwu1qQFx9MUUc0aJGWPU8hWfXBJ5Asv3e2lRpf1WLufcSMfLqsnK10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TtJSBuah; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=adkJQKYh; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TtJSBuah";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="adkJQKYh"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 593MoDJQ1948143;
	Fri, 3 Oct 2025 20:00:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=FE4Tmss75QRREgQBtYRm+AU14TcQO5TTQY80ArZUG
	5o=; b=TtJSBuah5WVXrutxBjt9Ay/DEp7Wr3YKcZpVEDR+lx3wN9EPP9xV0Cpon
	N9s9pZEwVekd1tv1AXTeG7YIq+uKhiHirUMyJPHNN3mRbO7bG2fmuRwq/I18qm4a
	vlc6sUWNn1K/ptGEBZS+mBJhIYR0Z9hM4F+aIGbmBqH0ML3bpt6Imf6XouoMruGO
	R+xBWKFYgqjFVQsNX95Le1/+8PcFgFg3VEsjn0jjVtVTYrzeVb7qL7uYNFS99A9q
	+nak+Y4Y5CS78y8I7ARaxAw2Sy6whvNRjSnzfoxfONXzwnbtWihHHP1O+wSpcbfH
	0OO4gKLULpi73jjjBNC92TDWh7oow==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023105.outbound.protection.outlook.com [40.107.201.105])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 49jq61r940-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 03 Oct 2025 20:00:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eh30Q9f5BMP2IgPwhAOF9NjzRrnaBi81cZuJ7ChpaGQt4oBupxrIDs/ra/7kHO41HNR2AhcNr+L6pFVA7ZDCj3XVXW21Ns48sJEshRcHSFMU5lyAA/82ui5eh+At1mgoq1DiyH9oQDfRm5lQSyU5RsiDybMMcWI37nrI1jDXhlpv9+qqgktzxf59ZkbZ4C0p78BCaJqJG2NzpmQzwPTDDpknN1wzsLPYH6/99Sujmwj7hDGehy55NBzSkXapIIgbq9s4MXkPfcTgSSW7zzvpDo0kBY51n6JmW1EdKnQFjUKCT9+gtogZ5/HxU4O7msbxNInNVtQiMFjMELs0zx7Xsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FE4Tmss75QRREgQBtYRm+AU14TcQO5TTQY80ArZUG5o=;
 b=Y5v1hu6YZ18WnJiCV3C5pAGIItSuGI84wnhFqkKXT/rRd0j2XVWpdJxhxwiMIi/RON2xHtls5ZAyphTVuLErdiFBn/t7qd1Wl+LsqNbfs83BtW3vTn/GA7DJsZZualmmU028HYuqLQo1JcyUGJRgdlFVMeO8nJ6DDJoatRaUTYLPlnkMhJagbQAwEKy8SbyCybDQ2l1+6Loa6v5soF3/899oZBbhOivuqYoy4TYrtrSO/Oqz15Ou7Cwz2M95qhlbFFM0eJwFgptJKE4o24OPMrSQqFj2y55AbmhNXOGhVNagU8WIVPmlfVeYF4yUu/NQb3hr5untQ/Iay3aOCL1Xww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE4Tmss75QRREgQBtYRm+AU14TcQO5TTQY80ArZUG5o=;
 b=adkJQKYhBZ31FvanIEo6dIzQXle6HFuuZJE3fVRJv8nONbsh8rubpRDuFsuJORWpf7RD2oB5eQ8744Y2QiYxeapGOxBjvDPDRqxf2cLSKuH8cykVQjwHTm5SNHNnTjxrrlt/q1JG5EoXgKw+oyho8dzGslMBqsRtXGhSNXG5oL1QXwsWT+kF72KTdMGMn7LlZUllug0yDNjzL00NfIKuMPLNDIsDvloqBvgoapEkjY3DP7pySfAJmVBs94KlbU6pk1AaeAnFj2+Oim9yW2zQVTlptwfnXd2hSSf0PC9RiTJYTP/xgU6Goop7I1DnTy0G5EaUcKu2WxsimxM4uYznKw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CH2PR02MB6855.namprd02.prod.outlook.com
 (2603:10b6:610:af::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.19; Sat, 4 Oct
 2025 03:00:03 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 03:00:03 +0000
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
Subject: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Thread-Topic: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Thread-Index: AQHcNNr7bUolJ69ASk+aENeZD9QcTg==
Date: Sat, 4 Oct 2025 03:00:03 +0000
Message-ID: <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
In-Reply-To: <20250521125519.2839581-1-vegard.nossum@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|CH2PR02MB6855:EE_
x-ms-office365-filtering-correlation-id: 693635a3-4f82-4457-79cc-08de02f21d98
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SW44d3plY1QrVUlUQWl6eUxiNHk1VVZTc0p5ek1CUHpibEtSbDJETGxLMGF5?=
 =?utf-8?B?VGxCSXVkOVlESDJnWVZ2RUhNWGt1NkdoNHNEemc3WGdGZmVMRXRmT0tEcUlz?=
 =?utf-8?B?b3h0MUM1NDVGZXhFTElpNDl4N3BNRjErLzA3aVZjck1zUHJRZUVqOHA5clZx?=
 =?utf-8?B?azdHcVlTYzh1SWM5UEVCVjNCVFNpYWw1aFI4QWNqN3YyZWRTNkxERGptOFNz?=
 =?utf-8?B?bnoydUJOUmdNWm5qa0ErZ0Q0NWczNTZObmZRUjk3NGkxQjRIZXhDaGwvTXho?=
 =?utf-8?B?S0psdTU3K1I3dDN1K05OWmtXSmgya2VneVFlS2JHakZqRnM4dkV3c1hXazU2?=
 =?utf-8?B?QlBBYnRpa0Fna1dhaW1MLzNuQ0lFeXZjRjZrNjZhR1dwcDZZWmFhVFNoOXJ3?=
 =?utf-8?B?RlFWbFNMcmN6aW04RWFabmRKNTBCTlFhc3BQOXYzU1RLbkJYTEZuWGhGZ1BZ?=
 =?utf-8?B?OTlqSWw0ZFZTMkc0UXhVMUNmMVVwYzNiKzhmMVh6eTNWOG9sUnZuMGZqZEh4?=
 =?utf-8?B?YTF0eXo5Q3RDTXlKVWJveGdYRVdmei96RkNYZWNYMnNxelk2WHdWZnM2M0VP?=
 =?utf-8?B?MFNRQjdnWTVYVzMvTithd3R1R0RuZ3h2WWYwOFUwQ2tHMWw1Mjg4UlVRV1Ur?=
 =?utf-8?B?MTAvOXFXUzFJVU5YT3kwOFJSSHRJZWdmRFhmNlBDKzdDaU43NmE5cFNvT0tz?=
 =?utf-8?B?dEpLOVVHaVBhS1RZM1I3TU9la0hhT21QY0FrWkJaMjI5di9hVW5oM2l2ZkFS?=
 =?utf-8?B?LzRDd1lPTVBIRTEvZ3d6N01iWVBGNU1FRzBVdHd1WFNzVGFIVFQrVmJuTURH?=
 =?utf-8?B?UTM5WnJwZkd5UVNBcFN1d0svZWJ5Z3oxa1pxV1RJdFA5Tk1wLzhSK0MveTFL?=
 =?utf-8?B?bzQwblpSbFlBV050TUswYS8vZTJqSjJZbi8zK3E4U3lWamxHOFFnVWwxdkZa?=
 =?utf-8?B?WXdYS2lJYzFHRDduT3VUcnlzNU5NSmhDRTBvQXRJWGErTDMzK3crOEZCRUZy?=
 =?utf-8?B?WEwyajVkdFdOMXdMc282SkRIM3V1ZGZNMU1jc2FUcDVGejM5ckFpVTRqaUdu?=
 =?utf-8?B?Skk0VGNXczRCd09Gd1h6UldzQ3ZpMU5kQS9rZFVuS28vUTdYUStlTUYvNUJM?=
 =?utf-8?B?OGp3K1VWQnhjbHdubXBObzNUWXlxVEZSa0IxTVBMeXVxRHpPSlZFeXBzQUsx?=
 =?utf-8?B?UkgxR2szaHVLaGhmVmpMczdSSHg2YWRKbWlydnNLRjhoNTZ4UEhjN0c5ME9O?=
 =?utf-8?B?cG1IR3FWTU9LZmNSWnZ2NDZjZFpIM3UzMTAvR2JzUmwvRTJiUGlqd2gzM29j?=
 =?utf-8?B?bFNTZWVkUXNlblArNkZyU3lNSFZtN2Rla0pVaGE0MVk3VGdKaTVleHRnaXdy?=
 =?utf-8?B?bzBDOVptVGdVZW8zVyt1aWIxMVg1eVhPVGtBNWZjdzNzeXhVN003ZkYxYkh1?=
 =?utf-8?B?RVhrU3VxMm4zd0lKUDAyWDVueDBNZDcxY01QNXFNVE1wdlBZbGx5WGpLMUto?=
 =?utf-8?B?c0dLUEY5bVU3Qnhwc3NTSnpDRC9PWjZ2SklLSmpmaFJVblhhYVoza2Znczc3?=
 =?utf-8?B?U0xDWlY2NXgyaFRqY0wwZUJRbjlmWGl4eU9WbXAzOW9DeHRuVkNESEpNb1Yr?=
 =?utf-8?B?VnRTeGU1N3dtSmhtRTRlUjdHZVdKaEQxL0VoN2F6cFovNFB4MXNHTThaTjh2?=
 =?utf-8?B?Rm55OFlsV25lVGRISVg5SDRHdmVOeFY4VDB2dXEzdFdRbFArbTBxU0psQjVr?=
 =?utf-8?B?Rm9GVHpMcWxHVW1NQUF0K01kS01XTWJ0QkJ1MDhkTThnMzhCcmtPQVAxdk5W?=
 =?utf-8?B?QlUvSkJSWTZRdkx4QVlLckhKV0RRUHVZbzQvNXpXREp6SjFMWThpQUNHUEhT?=
 =?utf-8?B?U29oSTdEOEMva1dqOGZwOExsSnBZMmJqZHFmdEUrRTZiL3ZDRERPVk5QUERW?=
 =?utf-8?B?QW4zQVJOZXFXcjlneHV5cWFncmtIbFNENllzYTVIczAra2x2ZmgrVXNUanBx?=
 =?utf-8?B?VzBHeC9kaEZucE5XeWlVOWgyL2hwRHYxVXZZVDIvME5rMy82bEk3Wjk5QUh4?=
 =?utf-8?Q?MZXcJQ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzlFeW5qK25VMTBDS3oyS3lSWm5MUElGQWVNalpyNTFpdHJNUW5EVzR0anEz?=
 =?utf-8?B?bVVsa0prQldER1A3RW1oZzNnTTF0UlNKNE5PNzVHUXhOQnJ0Q0Z6bzQ3ZUdS?=
 =?utf-8?B?ZFEwc3JaTGZuOHlRMG42QkYrYStkS2k0ZjV1aFJMTUdVdFE5a1hiUEVocDZV?=
 =?utf-8?B?OVkyUm5FeUtnQ1poNkI3TFJHUzM2WHVlSVVhV0xieDlwTlBIcFhqZEhlNnV1?=
 =?utf-8?B?dTcvY3Y0cHNEZVFvMHdCUTFYM1FiU1RYUzdVVUh6eEtzVWZnV1FKQ3N1T3h1?=
 =?utf-8?B?MHhGRDc5YVBUcDd0N1o0RUFqTHdZRk5HT0RRWEVlczdhRi8yU2hyNytqenA2?=
 =?utf-8?B?WlBIdCtGY1dHLzREeW52OWxxcDliNFFpR3pPZmFvMkJUSmNHSnlOT2ZIZ252?=
 =?utf-8?B?WEhkaFdmTHRvbHk1Sy9HMlU5M2NoRDd0b2JRMEM4VnprNGo4dC9zUjNvTTAz?=
 =?utf-8?B?b21qcjRyL2ZsY1BRVjhhZVRaRkNpRFlUeWdmS2xUYnFTR29vQml1bGZoM3hC?=
 =?utf-8?B?R0pkUTBNV1Y1SHpLNDdRYTlBSWxPRGp1TkZpdkNhQU5JOTlFSVQvcXVWQmsw?=
 =?utf-8?B?dGxYbzE0b0RNdGMrNnFxTW1OdG1UTTN4bGUzQWc4aTR1WGc5Z0Q1SlN6dFlR?=
 =?utf-8?B?V1Q3QXkwNlc0cmhhNU00WThQdkNUbWc5WUxiZ2ZKUHB3YWowVG5TdTUxZ0Vx?=
 =?utf-8?B?VjhBUXE2djBwUmVGSWhFT2hXZWZNcUlkZWdYZTlVYVZNeVl0V0hrTm5ETElr?=
 =?utf-8?B?YXh0K1k4RFlNWW1zQ043bStlQnFwTUpLTFNhTHdkZGVaTTF3RTVHWlMxdk1i?=
 =?utf-8?B?OTQ3YlVaTXJ2dWdKTmZBU0gyYXc0cXo0VVdKZU5lOW80WFBZN0hkWHR6UEN1?=
 =?utf-8?B?UzhQVitHL1pTM29lUEFLM05ENzlkcWl2QXZmTDdUU1VHbXByUGxQR1NqSjda?=
 =?utf-8?B?UjdpWWF4bGdpM2NMM0R1SlZjTkllczl2bk1VNXIxb1BxdndFbXpwL1lWZXdy?=
 =?utf-8?B?dWg5RzhIdk45Wi9Cd1hNUWp1cWx6QUVQenBlZ2xLUjdLdldqbEVYY1RlVURT?=
 =?utf-8?B?bWIwaXRYVjJQMmt0ajlwZVUraEhRTjJ5VVcwdnlhclJnOG9NT0NZRU5YdnZB?=
 =?utf-8?B?VVNSNzdhRDFKL0xrVk94aThwTUhGZ2x1dHVYdjF5NThvNCtWZTZWU1BuZkoz?=
 =?utf-8?B?L2k4T1puRjFhelR6bW1pU2tsOFkyaHFZWHRWcGtJeEk2R2RNT2RENTVRUzVX?=
 =?utf-8?B?NzVkS3RDaGdoY3pTVldZbldKTGFWczBTR21hc1dsbVVybUNnYnZIVmI5cUFp?=
 =?utf-8?B?M05GalVmTExZRk4zakVSS3NvS2xuaHpEY0xRamc1WnhDbzE4Q2NnTWlGa0lM?=
 =?utf-8?B?M29mU1doRFluRlpiamFtMEZBSWpWRTV0SXBvek1pQ3NOUVVEYjd3cm9TbkxF?=
 =?utf-8?B?Z1FCZWx1N3J0dXJvaEZMcGo2NlkvK003SWRFT2tGZzZUY1hiUEoyRnNoWXZ3?=
 =?utf-8?B?V2xaaVNrdklZb0NSY0ZtSXBEcmNlY1RDdjJHVkkzTlg0Qk1EOHFRYmtVcFVF?=
 =?utf-8?B?bUdHWlExcnp2TldZcEZFZnQyZ2l1SjhHVitna1loZjhNUU5XZU5tK0h2b0hj?=
 =?utf-8?B?VjR3SC8yMHJ6OEFUNlZ5TUkzdHd4VHBiMWVLOHpveWdEYTdOWWlYZXpnYUtZ?=
 =?utf-8?B?V09nOUhiSjNBUitjV1BkMnI0STc3ZHBaT0RqeldKUEtMZTlWUFFMTktIV2Yy?=
 =?utf-8?B?M001VGxNaUFWTUhabmVKTnBUbllWWU9LZlYrMVVrdld4ZDltTUtXaSt3dE1J?=
 =?utf-8?B?bU8vNENNbmVoSWJHWWt0R2sxN1Z6Tnk0c0wxam1naWoxWVhpTktqdS9BbTA1?=
 =?utf-8?B?REdOUWc3M2lpMWpSSFd4SWNsZndTLzFkcWlVSHRoUGptd3JtRGRlRTF6aHBC?=
 =?utf-8?B?M1ZXbVpadFU4QzdEL3cvN3k0TWZESW0xWTNNemFXMVoyQk1iOHB6MnNLbTRk?=
 =?utf-8?B?azdEZTZBQVFzTUdsaXpwTlpmQzgwTGRyaU0vUEl3a3RhRGdVbWRIVURMbStC?=
 =?utf-8?B?NW8vU3pReGR1WllwMVo0WDFMbUxvSFNGWlNCVFF3ZjREbXpYdXBjSkpMQVpN?=
 =?utf-8?B?NVFSTnpjTTZTWEhiYXFid3FpalBwOHpCQnRrQk4zamlvUzhTK0g2Y0ZzTVA4?=
 =?utf-8?B?VFBUNlFvSHpqR09WTTJka0gySyt3YkhQNW5xNmpPNEZlU2pUUEZBc3ZKNVF0?=
 =?utf-8?B?SGZLZ1Azb2J4azlEZFRCK3RBd0lnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAFD8B138E8B8345A13BD34C7F844432@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 693635a3-4f82-4457-79cc-08de02f21d98
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2025 03:00:03.4622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kzGLx95LSqa9nmem1jmPyYRlH9+SrbOYEvQXXcJCHVmrmEX0sLGcjINK5sSQmjpX3f8+CzwrLMb2OGVBrS3L5L7EuY+z3NUAtN2qoVa/wGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6855
X-Proofpoint-ORIG-GUID: U8CETFhR0QWMmBTyVJcGu5MHw3zQ03y8
X-Proofpoint-GUID: U8CETFhR0QWMmBTyVJcGu5MHw3zQ03y8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAyMyBTYWx0ZWRfX+nmDypCK7MFJ
 7Byv2d0KU1opRNnW7MYCH3FDYI0KoXwm1J9qc47hy2oDpPmZ5DxO6TAjNnCeDUphHm1Fw8nlulE
 uOZDk+Fde2U3oxDaOZfpLgEtPdZj1p5aY+I0i1Gg1fb3WKnuN8aPE9Xy/jkLyMkzH9RMR6HRLrQ
 6FzcNZf8cU6Au/JCPrQynJIdxoGIkmkQuz//hnxpATEZqLRLteGrYyzX3jiAhef04Dl6Kt3S9zV
 WTgpoPFIG8XhlPU+qoNG1x5zpnRD2GT+AMyHYhLiS9Gz+rHM0ul7fp5BTPyVaQEpWhaKsRHyknU
 EsU6iI60LvrtDlUYKkpdla+3bzqs3lqh1TcwJXhUY7HL8kXJ/Wkd30GNGHvn4Yq5oW/YvHAGFYF
 NxGE93WuJh13/N70jjeVQNlXfetZIg==
X-Authority-Analysis: v=2.4 cv=Be3VE7t2 c=1 sm=1 tr=0 ts=68e08dbc cx=c_pps
 a=mXWPUgXNGD4LDRIkHGcDmw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=PYnjg3YJAAAA:8 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=vmLDa1wCAAAA:8 a=HMmi1H4ijJ5H2p8nFNoA:9 a=QEXdDO2ut3YA:10
 a=h8Bt5HTj68qkN2fS7gvA:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-03_07,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDIxLCAyMDI1LCBhdCA4OjU14oCvQU0sIFZlZ2FyZCBOb3NzdW0gPHZlZ2Fy
ZC5ub3NzdW1Ab3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBUaGUgc3Vuc2V0IHBlcmlvZCBvZiBT
SEEtMSBpcyBhcHByb2FjaGluZyBbMV0gYW5kIEZJUFMgMTQwIGNlcnRpZmljYXRlcw0KPiBoYXZl
IGEgdmFsaWRpdHkgb2YgNSB5ZWFycy4gQW55IGRpc3Ryb3Mgc3RhcnRpbmcgRklQUyBjZXJ0aWZp
Y2F0aW9uIGZvcg0KPiB0aGVpciBrZXJuZWxzIG5vdyB3b3VsZCB0aGVyZWZvcmUgbW9zdCBsaWtl
bHkgZW5kIHVwIG9uIHRoZSBOSVNUDQo+IENyeXB0b2dyYXBoaWMgTW9kdWxlIFZhbGlkYXRpb24g
UHJvZ3JhbSAiaGlzdG9yaWNhbCIgbGlzdCBiZWZvcmUgdGhlaXINCj4gY2VydGlmaWNhdGlvbiBl
eHBpcmVzLg0KPiANCj4gV2hpbGUgU0hBLTEgaXMgdGVjaG5pY2FsbHkgc3RpbGwgYWxsb3dlZCB1
bnRpbCBEZWMuIDMxLCAyMDMwLCBpdCBpcw0KPiBoZWF2aWx5IGRpc2NvdXJhZ2VkIGJ5IE5JU1Qg
YW5kIGl0IG1ha2VzIHNlbnNlIHRvIHNldCAuZmlwc19hbGxvd2VkIHRvDQo+IDAgbm93IGZvciBh
bnkgY3J5cHRvIGFsZ29yaXRobXMgdGhhdCByZWZlcmVuY2UgaXQgaW4gb3JkZXIgdG8gYXZvaWQg
YW55DQo+IGNvc3RseSBzdXJwcmlzZXMgZG93biB0aGUgbGluZS4NCj4gDQo+IFsxXTogaHR0cHM6
Ly93d3cubmlzdC5nb3YvbmV3cy1ldmVudHMvbmV3cy8yMDIyLzEyL25pc3QtcmV0aXJlcy1zaGEt
MS1jcnlwdG9ncmFwaGljLWFsZ29yaXRobQ0KPiANCj4gQWNrZWQtYnk6IFN0ZXBoYW4gTXVlbGxl
ciA8c211ZWxsZXJAY2hyb25veC5kZT4NCj4gQ2M6IE1hcmN1cyBNZWlzc25lciA8bWVpc3NuZXJA
c3VzZS5kZT4NCj4gQ2M6IEphcm9kIFdpbHNvbiA8amFyb2RAcmVkaGF0LmNvbT4NCj4gQ2M6IE5l
aWwgSG9ybWFuIDxuaG9ybWFuQHR1eGRyaXZlci5jb20+DQo+IENjOiBKb2huIEhheGJ5IDxqb2hu
LmhheGJ5QG9yYWNsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFZlZ2FyZCBOb3NzdW0gPHZlZ2Fy
ZC5ub3NzdW1Ab3JhY2xlLmNvbT4NCj4gLS0tDQo+IGNyeXB0by90ZXN0bWdyLmMgfCA1IC0tLS0t
DQo+IDEgZmlsZSBjaGFuZ2VkLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ny
eXB0by90ZXN0bWdyLmMgYi9jcnlwdG8vdGVzdG1nci5jDQo+IGluZGV4IDgyOTc3ZWEyNWRiMzku
Ljc5NzYxM2RhZjdlMzMgMTAwNjQ0DQo+IC0tLSBhL2NyeXB0by90ZXN0bWdyLmMNCj4gKysrIGIv
Y3J5cHRvL3Rlc3RtZ3IuYw0KPiBAQCAtNDI4NSw3ICs0Mjg1LDYgQEAgc3RhdGljIGNvbnN0IHN0
cnVjdCBhbGdfdGVzdF9kZXNjIGFsZ190ZXN0X2Rlc2NzW10gPSB7DQo+IH0sIHsNCj4gLmFsZyA9
ICJhdXRoZW5jKGhtYWMoc2hhMSksY2JjKGFlcykpIiwNCj4gLnRlc3QgPSBhbGdfdGVzdF9hZWFk
LA0KPiAtIC5maXBzX2FsbG93ZWQgPSAxLA0KPiAuc3VpdGUgPSB7DQo+IC5hZWFkID0gX19WRUNT
KGhtYWNfc2hhMV9hZXNfY2JjX3R2X3RlbXApDQo+IH0NCj4gQEAgLTQzMDQsNyArNDMwMyw2IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgYWxnX3Rlc3RfZGVzYyBhbGdfdGVzdF9kZXNjc1tdID0gew0K
PiB9LCB7DQo+IC5hbGcgPSAiYXV0aGVuYyhobWFjKHNoYTEpLGN0cihhZXMpKSIsDQo+IC50ZXN0
ID0gYWxnX3Rlc3RfbnVsbCwNCj4gLSAuZmlwc19hbGxvd2VkID0gMSwNCj4gfSwgew0KPiAuYWxn
ID0gImF1dGhlbmMoaG1hYyhzaGExKSxlY2IoY2lwaGVyX251bGwpKSIsDQo+IC50ZXN0ID0gYWxn
X3Rlc3RfYWVhZCwNCj4gQEAgLTQzMTQsNyArNDMxMiw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
YWxnX3Rlc3RfZGVzYyBhbGdfdGVzdF9kZXNjc1tdID0gew0KPiB9LCB7DQo+IC5hbGcgPSAiYXV0
aGVuYyhobWFjKHNoYTEpLHJmYzM2ODYoY3RyKGFlcykpKSIsDQo+IC50ZXN0ID0gYWxnX3Rlc3Rf
bnVsbCwNCj4gLSAuZmlwc19hbGxvd2VkID0gMSwNCj4gfSwgew0KPiAuYWxnID0gImF1dGhlbmMo
aG1hYyhzaGEyMjQpLGNiYyhkZXMpKSIsDQo+IC50ZXN0ID0gYWxnX3Rlc3RfYWVhZCwNCj4gQEAg
LTUxNTYsNyArNTE1Myw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYWxnX3Rlc3RfZGVzYyBhbGdf
dGVzdF9kZXNjc1tdID0gew0KPiB9LCB7DQo+IC5hbGcgPSAiaG1hYyhzaGExKSIsDQo+IC50ZXN0
ID0gYWxnX3Rlc3RfaGFzaCwNCj4gLSAuZmlwc19hbGxvd2VkID0gMSwNCj4gLnN1aXRlID0gew0K
PiAuaGFzaCA9IF9fVkVDUyhobWFjX3NoYTFfdHZfdGVtcGxhdGUpDQo+IH0NCj4gQEAgLTU0OTgs
NyArNTQ5NCw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYWxnX3Rlc3RfZGVzYyBhbGdfdGVzdF9k
ZXNjc1tdID0gew0KPiB9LCB7DQo+IC5hbGcgPSAic2hhMSIsDQo+IC50ZXN0ID0gYWxnX3Rlc3Rf
aGFzaCwNCj4gLSAuZmlwc19hbGxvd2VkID0gMSwNCj4gLnN1aXRlID0gew0KPiAuaGFzaCA9IF9f
VkVDUyhzaGExX3R2X3RlbXBsYXRlKQ0KPiB9DQoNCkhlbGxvIGNyeXB0byBsaXN0LA0KV29ya2lu
ZyB0aHJvdWdoIHRlc3RpbmcgNi4xNyBvbiBvdXIgcGxhdGZvcm0sIHdoaWNoIHVzZXMgZmlwcz0x
LCBhbmQNCm5vdGljZWQgdGhhdCB3ZeKAmXJlIGhhdmluZyB0cm91YmxlIG1vZHByb2JlIGRtX2Ny
eXB0LCB3aGVyZSBkbWVzZyBiYXJrcw0Kd2l0aCB0aGUgZm9sbG93aW5nIGVudHJpZXM6DQoNClsx
ODk5My4zOTQ4MDhdIHRydXN0ZWRfa2V5OiBjb3VsZCBub3QgYWxsb2NhdGUgY3J5cHRvIGhtYWMo
c2hhMSkNClsxODk5My40Nzk5NDJdIGRldmljZS1tYXBwZXI6IHRhYmxlOiAyNTQ6NjogY3J5cHQ6
IHVua25vd24gdGFyZ2V0IHR5cGUNClsxODk5My40ODI5NjddIGRldmljZS1tYXBwZXI6IGlvY3Rs
OiBlcnJvciBhZGRpbmcgdGFyZ2V0IHRvIHRhYmxlDQoNCkxvb2tpbmcgYXQgbW9kcHJvYmUgZG1f
Y3J5cHQgd2l0aCBzdHJhY2UsIGl0IGxvb2tzIHRvIGJlIHRyeWluZyB0bw0KbG9hZCB0cnVzdGVk
LmtvIGZpcnN0LCBhbmQgaW5kZWVkIHdoZW4gZG9pbmcgJ21vZHByb2JlIHRydXN0ZWQnLCB3ZQ0K
c2VlIHRoZSBzYW1lIGxvZyBlbnRyaWVzIGZyb20gdHJ1c3RlZF9rZXkgb3ZlciBhbmQgb3ZlciBh
Z2Fpbi4NCg0KVGhlIHRlc3QgY2FzZSBvbiBvdXIgc2lkZSB0aGF0IGhpdCB0aGlzIGlzIGEgdHJp
dmlhbCBzYW5pdHkgY2FzZSwgd2hlcmUNCmEgdXNlcnNwYWNlIGFwcCB0cmllcyB0byBkbyB0aGUg
Zm9sbG93aW5nIG9uIGEgdGhyb3cgYXdheSB2b2x1bWU6DQogIGNyeXB0c2V0dXAgb3BlbiAtLXR5
cGUgcGxhaW4gLS1jaXBoZXIgYWVzLXh0cy1wbGFpbjY0IFwNCiAgICAgICAgICAgICAgICAgIC0t
a2V5LWZpbGUgL2Rldi91cmFuZG9tIC9kZXYvc2RYWFggc2RYWFhfY3J5cHQNCg0KVGhpcyB1c2Vy
IHNwYWNlIGNyeXB0c2V0dXAgY2FsbCBmYWlscywgYW5kIHdlIHRoZW4gc2VlIHRoZSBkbWVzZyBs
b2dzDQphcyBub3RlZC4NCg0KV2UgY29tcGlsZSBDT05GSUdfVFJVU1RFRF9LRVlTICYmIENPTkZJ
R19UUlVTVEVEX0tFWVNfVFBNLCBhbmQgaXQgbG9va3MNCmxpa2Ugd2UncmUgaGl0dGluZyB0cnVz
dGVkX3RwbTEuYydzIGhtYWNfYWxnW10gPSAiaG1hYyhzaGExKSIuDQoNCkluIG15IHRyZWUsIEkg
cmV2ZXJ0ZWQgdGhpcyBwYXRjaCBbMV0gYW5kIG1vZHByb2JlIGRtLWNyeXB0IGlzIGhhcHB5DQph
Z2FpbiwgYW5kIHRoZSBjcnlwdHNldHVwLWJhc2VkIHRlc3QgY2FzZSBwYXNzZXMgbm93Lg0KDQpJ
J20gc2NyYXRjaGluZyBteSBoZWFkIGFzIHRvIHRoZSByaWdodCB0aGluZyB0byBkbyBoZXJlLCBh
cyBvbiBvbmUgaGFuZA0KSSBhZ3JlZSB3aXRoIHRoZSBwYXRjaCBub3Rpb24gdGhhdCB3ZSB3YW50
IHRvIHN0YXJ0IHRoZSBkZXByZWNhdGlvbg0KY3ljbGUgZm9yIFNIQTEsIGJ1dCBvbiB0aGUgb3Ro
ZXIgaGFuZCwgaWYgQ09ORklHX1RSVVNURURfS0VZU19UUE0gaXMNCmVuYWJsZWQsIHdlJ3JlIGdv
aW5nIHRvIHJ1biBzdHJhaWdodCBpbnRvIHRoaXMgYWxsIHRoZSB0aW1lIGFzIGl0DQpkb2Vzbid0
IGxvb2sgbGlrZSB0aGVyZXMgYSB3YXkgdG8gb3ZlcnJpZGUgdGhpcyB0byB1c2Ugc29tZSBoaWdo
ZXIgYWxnbw0KDQpIYXBweSB0byBkaXNjdXNzIGFuZCB0cnkgb3V0IGlkZWFzLg0KDQpUaGFua3Ms
DQpKb24NCg0KWzFdIDlkNTBhMjVlZWIwICgiY3J5cHRvL3Rlc3RtZ3IuYzogZGVzdXBwb3J0IFNI
QS0xIGZvciBGSVBTIDE0MCIpIGFuZA0KDQo=
