Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D1D1A2567;
	Tue, 13 Aug 2024 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723568453; cv=fail; b=m64uURuRXYc0T1yznXSw/C8/sSMRGNof51dUSTEWOXEjFDxWxeG9lVoWVygyleZIoH7/uUtYOxiaYlUQT7eOCWwP7XBbtiLwGrd1trvLq5FwmYLou5Mvtws7kI549kassd7z13DYdmWNf0e5a2yxFJIzktjMrD1wbc8PMVxWxaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723568453; c=relaxed/simple;
	bh=c7dQrtnHHIxvy0zlF4TEEogKQoyZcZfWcrxN5gw7GyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r2VLlv9I1abh84VRpdaQvp3TliedXarsb1JQtIlqI65E3daY6yReEYdsp2CEmheU2T19QCj0yq4zyBhOpTgE1/okbtXgjyTTtGoB7lQ4PHuIOcig+QHpdhb0EGtCSBmQo1GN0m7blPdli+PLHyxH/x887WWIGQyxxG4XS1LiErQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TgYUlmoC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zo4Rx24e; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TgYUlmoC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zo4Rx24e"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47DGBUtS021492;
	Tue, 13 Aug 2024 17:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=DWoVuFmc4LLQM0M
	h9Ngjx7VjSUdX8daERQ681JX2oFc=; b=TgYUlmoC8yFydkyQYa/2y5xV6FQySx+
	ALDs0B0QetoDDhTMLt14YLz+DJF4PXlqvLz2mDM7uku6A79yHUk1kkb+JR7Bgqsx
	F77LcRFH6Yth3PMN9ei/wV7bGV1YOSQDN9jxdE65ZwYVP+dqdhzaeLDM9WRUquF1
	Kt17ck9XQ78yyydmu6AjrPsGl+yVcslAiMO6A5QIdTrhtbfPdEOHkQXBORjgoLwf
	cPIZ9B5cyz9QjOAATUuzZWrSQDpBsZJJ+YtfgpUCL01wU8tofcBneml/xYf41mLQ
	DE7oxcRe49LVksga+T6mVzIaxh+yP9f2fY29WhLkBdegNcEwv32n+FA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wyttegjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 17:00:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47DGWA1N000921;
	Tue, 13 Aug 2024 17:00:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn8rg8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 17:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jeII0GRYYl3f0AoEhiY4sQEbBCQy/kw1lHsI526f5a3tXYrvFtWaO1AYH4zZh68Uzqts2bPke4OUhk2hAL83hhpHXUO/Q63rnVxNk1uBirCR6vdtXWSEHYLu7LtI940p528/ANi8cl3GV0vhAl8K2f2hhKAp9SzDHBLe7/iySeHoeBrcsuX1HOIZE/ifanNQKrnaqqA9VINY4dfE0zWTGwey64m8sgHev73u2+jaJMRykRMd8iQKov4UJcBknl27s8n+ftUsNB4En3FAKDNGP9Sk1pF1cl8wZn5Sxyenl8o1XIOqoAPZ7Ov2xa9WCwaU0tAoDEHeSEJzxjtiVCEDVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWoVuFmc4LLQM0Mh9Ngjx7VjSUdX8daERQ681JX2oFc=;
 b=eOfTmjGOKf9lItEpMabbgLj+qUjVkFySfGSFnIFeiva1uW00WAUGAVE5C8Qd5x4S0YJ8WtBm+9sweSI2qQAGRfWXxU/zhl0eDlCq2uI/sJT/1h8W/BspEnB/JEjUncnvj2+UYWikPfyeNLOiGBVgqXIl0IRtuVxd3WkNWQ+4CfOiHi1AqJRoRGbrnSRv7zBKJafiCaQaLNRcVyd071QVDVVLgaQAxY9U+dWisxlU7I7jtwXQZFTufvTftQ/xaNJgIqwcnHcGdP4YKnsx0CCQz+QoBCGwCc6pkW7YxXUG9lKDhJTH4EjXbN7UyjzxVA3dQXTyomRnX90Ish16e21O8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWoVuFmc4LLQM0Mh9Ngjx7VjSUdX8daERQ681JX2oFc=;
 b=Zo4Rx24erjSttZjFhu6QH+22FpFRZA1Zjh9+iToucNIBVPP+lZ6s2HBiDBk+7hNlpIYffu+8t472e7vRE6kVUwDkIdDsuUc/no28/OE6FjXci3NkxjBBjseVX34q/nbKXDlBflzzKVk6oIHxtYuV3ATiRzPfBDXgaV8oBGIJNas=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by LV8PR10MB7968.namprd10.prod.outlook.com (2603:10b6:408:200::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Tue, 13 Aug
 2024 17:00:29 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%6]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 17:00:26 +0000
Date: Tue, 13 Aug 2024 13:00:22 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com>
Cc: "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: use integer wrap around to prevent deadlock on
 seq_nr overflow
Message-ID: <ims5ek6cttmbhosgo2cnv4jswwjdsfpjfzuyjmhnxy6ecdvmml@2dse43bcth6x>
References: <a16995232eda4d39812f4bd94d9fb846@rohde-schwarz.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a16995232eda4d39812f4bd94d9fb846@rohde-schwarz.com>
X-ClientProxiedBy: MN2PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:208:15e::17) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|LV8PR10MB7968:EE_
X-MS-Office365-Filtering-Correlation-Id: 48a43d97-ffd4-4e86-d89c-08dcbbb96d9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0zAko0NOFeMTov4dI43aCRLpI8zqwZjDDfrcJ/VaBM97IRv9D4aZIqT4BZn+?=
 =?us-ascii?Q?hDKujsmz20QqIxbokcnKKHI2MFAKF89/rN2PfzqhMRZtNEUfhyK0e5PX3wfN?=
 =?us-ascii?Q?epAr372Wa3slpJnI8BfsApQVmFiyJ8NKgw4d5RdWYXPoGdOIwzN3Nbp5JN2M?=
 =?us-ascii?Q?O6KWcpqlQabPRrJo7W4b53gQsBuzO0EDqc4C8Sgvtsg0gpREzDAloycRFJfo?=
 =?us-ascii?Q?e+0MWk/pttp3NP+B7gi9cCYet7RiyPomGzEtDVzQd7ozsd7j3O0FH2u3KboL?=
 =?us-ascii?Q?+8u71JzU4mQcUldTdolbU1FP4iP+WNT63uHqzD/73Q9/jNApizN1WtdS9/uo?=
 =?us-ascii?Q?uRquaIa3NkOoIS8/irAGlimZLopAL+t9pQhdCTih2vOvlwZrVCFZj2b/Dc78?=
 =?us-ascii?Q?t3e4eSrYc7N1hzY01yU0cIJL/oQ7bfGBT6Wd1WasMpHsA8TjJOTvR6LUR+39?=
 =?us-ascii?Q?JLO7bNShWt9Vh1BQ2CrYTwuvJkmYdt2JxR3RKbtieldeh3mZSTh+pZhxXoZt?=
 =?us-ascii?Q?qREH1Jcmjj7NynP8oMKShVqYhxiKWPo/jKnOex8XS5zXrhcB1oey3gWCkMF7?=
 =?us-ascii?Q?Y9IA8orVmg+ayAcX9gf8TrQZpHBchcaDAFdhPQK645A2+Ya72vOa4Nz12mp+?=
 =?us-ascii?Q?DwP+KlSnU/h1/7+/YenFnguf/VIyIB/GnIzBwK0xK3Vw5JVdmE6z95r2hJCk?=
 =?us-ascii?Q?SvR19NaWZB9NMTdv27yWsJQFsPIz7Yby6c3+6wpWHIXvpfii0argfkoqxpbl?=
 =?us-ascii?Q?wTlaqmCibdTI5uSz4wupswPFCtRrw6DrPRrnjM1t2z1npj9fmfqQbO87pFvL?=
 =?us-ascii?Q?y8wEX4D7e99KaDyo/73imxVoCTmUuPImkjp0n7xzm8rnvniArL2sgRcm9gmO?=
 =?us-ascii?Q?hLa3WZCwZPNmFZ1AIQImJAKqCWZ+C87QYoaqyClcOoageBZrr7JPcm6dCFBq?=
 =?us-ascii?Q?it//+ZeQwlevyfQlzvg+yougfiXxfaTUz37/5lM6RaqgrBzQN+7peRc1i5x/?=
 =?us-ascii?Q?E4cjf39QsDci+wUeRy53zIihOQLbuOEp6NRclJIviG5/wPbNJPsdPqS1sGAx?=
 =?us-ascii?Q?CZbResQdKFglaunOsA1uGZ4tRVUsEwedy5gUKhzIoGlwiQwO340qWjhvgKsJ?=
 =?us-ascii?Q?wUrOrEYYftsP51LgqqPJ7cVS6KAIpM6zAq+zl990vM0YvXDCWwbYWbAyobr1?=
 =?us-ascii?Q?5ZVUevQ8oJOVzqZAjKO3J1QHbQ5OekfsTIo5H4qSZb4bDUJlGht0Sad+NbH9?=
 =?us-ascii?Q?jUrr1KyOEM6Mfh0hDsV0lYF7QMs3rntk2IKdCXWsUlACENEwAPHAbRPvXEgy?=
 =?us-ascii?Q?jxb8Eqgi/kGykH2PPJEU2evsVhFtv+UwQeWUyw8V7It4XA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6qy9sR34FqF1YBoF+Hj75iX53RA6z346Zngn+ZYvvoRJzn60p/M8CGiTWpKc?=
 =?us-ascii?Q?IUrA6R2jfbc63pOlGWlJ+xeOxqxrwFPoDOdDFhBTbbGGOYWP0px3Ez23mKtU?=
 =?us-ascii?Q?mOFl7bE0UXeXi2RKDDj10ILvoZoSsR5TEQg0d+DyNj3UXeUAzNo8X87lb/Y3?=
 =?us-ascii?Q?YYrHeFB1EXs/YKCuhWHraW1OoLvNnOzpN/3q5Uo1nHWbYYkOhssA0j500N9e?=
 =?us-ascii?Q?iAWFyW8Iioo/CgnQ75PYooYDmURmsLLRF7C1vKlsLQTCDxSCr+YpAT6nAmFH?=
 =?us-ascii?Q?sz8RByyCy5jSIuxWFllvg1GV1ruUWOu2iLFzEfbiga+44zhO4MVHlsWPdjV4?=
 =?us-ascii?Q?r9zY7jtgyAeXW2nrztdkYf9M4xxOntyBmyUEQgbTispKp0UNI25GDCsMUiWl?=
 =?us-ascii?Q?nJNhUXLjV3wCYGuP/MGDKeKjymjLqzpJnj0Lj47pm5YTefrTRwuOUZ7c4uo0?=
 =?us-ascii?Q?4JlK6ZsEExBe2qxRHwhJZoKcNfwiEV+U/YjNVT+0PXDzQPLMA/ErTRchfY2V?=
 =?us-ascii?Q?VogocdSyRnNAXloNycG0/Y/ti7Ob+76jo61SMediOoJMe2jhUNlnT52T2sih?=
 =?us-ascii?Q?rhQTGWCYXcCqQtLkSw7crcpdxn2OP2ADuQJ5B+vULNl51y+j062FVagS6gAM?=
 =?us-ascii?Q?OctfnUqfjnGrch5SgOUEojRxiRHvbSWah4FVdbQkIQRZ5VFfncpzzfxaUk8I?=
 =?us-ascii?Q?JtqXXWDuEpMEvUjGmDbhbIJCYo1MpE98bS0SDpNn7vOzMxWddPmOZ7oGUhst?=
 =?us-ascii?Q?rPfpnNnc2c3RzJ9+hQoSnG06N0Q3Bp5m00wvJJF8f+R0OHCzgnqX+kCG+QHR?=
 =?us-ascii?Q?Dqu6GHZHT+0ERljlqn1OGbWcsYUqIlMNy5aArjfS+ANFWBA+pstHUuhU7uvG?=
 =?us-ascii?Q?HM7GGkoPhHsxa11pzTiEIaFuhvxUu35omrneBRxRJSgCqGGVN85bW0qypbRc?=
 =?us-ascii?Q?PMuJ+hy06V7aHGNWX1CRlEPl+kPMGBPJNNGJiE7RP5FfYh5cbpyFbW1g2Zoc?=
 =?us-ascii?Q?brouJHt4wIUa2Oudr5DIL7sx22Glz6BYTS2hiSHZjnWUlRGalr/YI/dCzhCl?=
 =?us-ascii?Q?sZm5cPR7VJp/WBORfuNAsOB4vvd92KFDUbmSruNw1Nb7PeADZS8Xc/ZFNhNB?=
 =?us-ascii?Q?s5RYn9sSQ9tuykXVeJBXqlt5Nr9TDMQKF3HLXAFdW4QyR7V7fgkUQjxZ64dt?=
 =?us-ascii?Q?2+iulCi2nE+vzjeDRbTti7fQfOQBaUjMlUKMUpiBRScRpHpY8FAbmG+zGeaK?=
 =?us-ascii?Q?wHHi2I9HaaEfwahbF+KyvL5wRypIB5JDmSZI6/vYmhg9BY4SY7nmc3sYbzGD?=
 =?us-ascii?Q?Y8WKpJ6kC95EAE2TAlGTQZbSEJRfl3HOsVa0iXtO8tzL3AtKFKo5OL3aYjtq?=
 =?us-ascii?Q?zhml+2tbAHaDta282oyJcBiL8jXEhAcGmn1s3OC8tJyWyoOgVmOR13SPD+40?=
 =?us-ascii?Q?5rEfOA4tOHvqW3U07soQVWCYs+bBUlilpq4+dPxpT2VTKBhNlYl1f86b+C2u?=
 =?us-ascii?Q?Em7kH9ovsrB/jJ0DIFur6nPNJ9HNPRNG2jPhr8wYz+wMT0z6OR5eQzwnQD9w?=
 =?us-ascii?Q?MSVIWulzr0MWKvop11CCgUJdg8VVUfOBIIU9nEMtR77WHQaIaFoPWot4+gRn?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a8H9bUe3PpOZ8ZH+jHOCulN9Dcr2QY9E/oTngDLIMlCsnr8p2MyOdBm4+t80nTQK6yNcdZyBTwOoS8U3Dm+BkOvsYYFe6RMP76Zw79/A8rV3bIBynRNKNtSTEZUf5XIwlBxLJzeZuYaNryRNKXM/LYIi0wUISk9g3bDBeBM75UxjQK+vVCVYs8B182CU6sHEJ8HqcS2FP6+YzYAAU+7PR7QqZI1P49ESRXh4oOJmRDK73Lnt1/9EGGlouod40sWGN9WF7kW//gJMbu/DUn1HTlDGpMeIvzlCwfNGQJF3mAoVa+45qriX5yZTjDrjmYebP+leT7yS4rPs46eSw0QZcMnLHnwffnT1mSNlbvrMWURcEJ/DvUx8PCUTCh/S00krCMXu2uifRsiW4oGKu1dIxvs5AcAnV6kob4T0Tx/aCheSkf+IdHfqEzTQpzP3euCv4+hLghYDQEmDhgQJjgCvwowPTjUbUXA2w2+t4+gUifInza7q76HXL0A4OODWZ8SIeXsKXrV4fSMNBbrBovURKWe/Bkp1nP9/8YzutyrBNORGA2ghuOv5lpG+5oTBy1U05KnY1BCPQLqGpedV39EgpqoGy/om1dUD+wgwtxkO1R4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a43d97-ffd4-4e86-d89c-08dcbbb96d9e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 17:00:26.5887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBCdHZDJ6yoXydKtGZawmyOHrmIdErSM6GPv0UKWNaFsPpxDjOhzBA83CHISpxwXLq/T3RxL1Ri3pEYaqDyZ3rvRXpYGdsEUJnqUeTDDmBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7968
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-13_07,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408130123
X-Proofpoint-ORIG-GUID: WydwDdgLrjybojfJHelXjUMqkijkPzbE
X-Proofpoint-GUID: WydwDdgLrjybojfJHelXjUMqkijkPzbE

Hello Van Giang,

On Fri, Aug 09, 2024 at 06:21:42AM GMT, VanGiang Nguyen wrote:
> When submitting more than 2^32 padata objects to padata_do_serial, the
> current sorting implementation incorrectly sorts padata objects with
> overflowed seq_nr, causing them to be placed before existing objects in
> the reorder list. This leads to a deadlock in the serialization process
> as padata_find_next cannot match padata->seq_nr and pd->processed
> because the padata instance with overflowed seq_nr will be selected
> next.
> 
> To fix this, we use an unsigned integer wrap around to correctly sort
> padata objects in scenarios with integer overflow.
> 

Could use a Fixes tag like this one:

Fixes: bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")

Otherwise looks good, thanks.

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>

> Co-developed-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
> Signed-off-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
> Co-developed-by: Max Ferger <max.ferger@rohde-schwarz.com>
> Signed-off-by: Max Ferger <max.ferger@rohde-schwarz.com>
> Signed-off-by: Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>
> ---
>  kernel/padata.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 53f4bc912712..222bccd0c96b 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -404,7 +404,8 @@ void padata_do_serial(struct padata_priv *padata)
>  	/* Sort in ascending order of sequence number. */
>  	list_for_each_prev(pos, &reorder->list) {
>  		cur = list_entry(pos, struct padata_priv, list);
> -		if (cur->seq_nr < padata->seq_nr)
> +		/* Compare by difference to consider integer wrap around */
> +		if ((signed int)(cur->seq_nr - padata->seq_nr) < 0)
>  			break;
>  	}
>  	list_add(&padata->list, pos);
> -- 
> 2.34.1
> 
