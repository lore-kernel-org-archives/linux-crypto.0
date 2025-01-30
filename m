Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF7F1E98E8;
	Thu, 30 Jan 2025 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738251207; cv=fail; b=aYqdEC6fuIwNC1DfPMa6ClDb5+ZdkyUqy3d6GWYjXXTNgVK78NlffPo0e9cHhVkcAe/OA6WObMB/7xVvRdwC3iFul3DQhfsG9DXlfBoUp7sARkwgKk+6ca0fXf4Ez1aQ+pzYl4Ft/6DtDrWxQINhWMKhWnSroy+eDizOPYsEgqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738251207; c=relaxed/simple;
	bh=YGjK6SIpTKfpqH9klUd0+IjwGXh+NNtsmZAUkZ9+O2g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RHM9wfjeJX1O+LWoDmfLZIsGJebS/fUL3e1lc7/tW+g/wnCjG4p90FOGM/m2/kfWJI/Oqog63nm364DWDpNpbN832FL7i3nxNCcUatqDy69DXIEI9NivNEfBY+JmBy4vneYioTcAIq/CGx10k3oR2cjVHwnrA95H9R9OWRojrls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ki9Hgay+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wg7Jz9sA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ki9Hgay+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wg7Jz9sA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50UFLP6r025678;
	Thu, 30 Jan 2025 15:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=hgeeszasWN+3+kHMvO
	3YRuX4x1pniLe1ycm0vL4Fxns=; b=Ki9Hgay+H7Jwolhzp5VSQjhirOsVMywZpe
	pIwY2EhwqhROeHCAVNUgnmn8zYHoQZnp3vHrMRzqrW5scIxNWcIY+l5jw3OvKvv/
	GkkTTjxmHQDZx6G5nDE8/QL+sukrXzlPm4Zw6Ezjp158aXQaEqT+D1EwIBFTazdV
	Qn4fgJs2N/YaZrbrQlfskIal59PdJ3/uYpmvwsI/ZvfA8tQ233gxIM/bo3qNvq/l
	PdfVdRRzl4XShFl4IlsjFgrBBZPynIPJND9+LcGDgeKr4SwtvElts/fjC9ErZvMl
	KyW0TguM/sYY9Zwiqmba3QkxZKlpSmER6GQYxwceIP9qbMzY2lwg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44gbyy81ec-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 15:33:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50UEAUw3034111;
	Thu, 30 Jan 2025 15:20:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44cpdb73h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 15:20:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDXTu9f59ybLN2XlAbTBE9h3HlY25WgSYy5Wn5aP3oEekPxGumdwFXpD7frfYIRaP5jfNokaRKL1TCGlZX1kt1NIas5le9r4Gz4wu2YLzemoc184rXUd4bBW46skqlTHOtm5ldw5/3lJvyspWQUFQkWGVUtFsdLRP02E8ZoWsczmXG+Z+q4adrXgP/x/c9iOkeYovbaeiEXaBEEhXxaB/KJSuGEFPKiZIouJfkAuqenRV58Telt7jKZlWkS5zAuEUhuT0Z04WrsHAEG/zSEVL9caT8rfxGPMp1SFpFvLqehlvxwDC6S5XftHKEV7wqtobdwF/qXTovjIkuOzYWE/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgeeszasWN+3+kHMvO3YRuX4x1pniLe1ycm0vL4Fxns=;
 b=b27qddai8dDeCxWqAy0w3VK41LPv72aFhFKRg6aq8OKxe58BN8LX9z9kKhIDM2XF29BxpY5VT1ASfaIAY32XFw9qCadgidsoi0nfqziqOrEytF7nrE17aK3JbvLnkc4UI03i9jkc9VNWXNNx2OwgNAFZLurrlSVtJ9rEw9SXa8vNi5yD684qG5GkQjN50O2L6Nd6VTFmHqRsOhNxnarKohS35A3pkMAiDOW7Wc06hlLNtSK1jRa4pzHz0Qkesatv0sUj5LQ/NB1d2jd4rQBUxah/2ZLqlnBU8MdZg44zyzpYkJ78pm40XrQVW+VlfqOwTUQKSuzMGoNAK3aJ4Q8CHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgeeszasWN+3+kHMvO3YRuX4x1pniLe1ycm0vL4Fxns=;
 b=Wg7Jz9sAy4a4fOLn3oNERO1zlSbft0UPrYTTXgxVkOSPTxmgxrdyiRcfy0it36+Y4csmE/FdN57a+K5N4DGxzLLRCnYyUT31AS7RgzO3k7vFFb7pcqEifGjmFnXX5j3bp2CZBQVk/IHNpfhTfcKNGS35nRZa0/FKDtXdQRl4WXk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Thu, 30 Jan
 2025 15:20:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.020; Thu, 30 Jan 2025
 15:20:18 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-block@vger.kernel.org, Ard Biesheuvel
 <ardb@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Kent Overstreet
 <kent.overstreet@linux.dev>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/11] CRC64 library rework and x86 CRC optimization
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Wed, 29 Jan 2025 19:51:19 -0800")
Organization: Oracle Corporation
Message-ID: <yq1plk4pbvw.fsf@ca-mkp.ca.oracle.com>
References: <20250130035130.180676-1-ebiggers@kernel.org>
Date: Thu, 30 Jan 2025 10:20:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN2PR10MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a50cc5f-42c3-469d-a104-08dd41419ad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OxWkTrmkv1wMIIDncj0T7ODjbrH/hRizfJ78ErGjsBsJXFyfeeeAWw5rOF1h?=
 =?us-ascii?Q?SmFQ4Hy+tRawGPPjEz5bg7LftapELF5m9bM0RyMs3EvU0XHnhI/HyURXeIRM?=
 =?us-ascii?Q?4fjWyl6djOL4Gm4B/2YxX9Af/UAKXwivDM/dhkK9XCynFoiLcVLwv/FCjAzl?=
 =?us-ascii?Q?RL7totpLC3+8pGuqprXsBqmHc7qgDQjImrisxzbqwCbhQx10Qb4bgfflzGuV?=
 =?us-ascii?Q?IKeAzK8zNdMuX3HzS+zWAusIs8XGBoPINEwKk2xK9LTmned+BAWXOzSfv4lr?=
 =?us-ascii?Q?VbDjvVFvnQv8PxK+Ph/q0J7vxsNZq9TB4GggZeomBrD08afaVDhTcBGlIZOA?=
 =?us-ascii?Q?fBY/gbmUf4SRInwo5sdKgYmdDE2Y0XNGoxhLyTlw+vvjEOtjwPSrcm/sOm2H?=
 =?us-ascii?Q?JZBiV4xX9Qxt2/4J2TMH0yAURXJTlYDWysTnBzVclNyfQzkjw8jx/ij6st7O?=
 =?us-ascii?Q?zAiD5zU2JDS8jsXDvTnrWaV9+CkUly0MWJhFs6BQ2q7aioYlRXsoKt6h0+aJ?=
 =?us-ascii?Q?FMtknV9KUr9929HVKdToc00LEuHE20PfolsGkuDAyvKxDmfHDWrkwpqySKvk?=
 =?us-ascii?Q?3ovd9IUk5Kdl5RFc97UKdJDZAJyUKeuQpvapnB+ZYYAmqTfsVMBM+9sz4CIO?=
 =?us-ascii?Q?jlj16WNT79ne/C/wqsIGrbGCGDFeWfKoFKLeUBhOfmx0+zDB7Sq97sQ7HFVo?=
 =?us-ascii?Q?tnBvKPaa+KQ05eXtc7B/GKGI+8t3ltVsqpanZhEAEUguzDMb4ODwMvOIft+G?=
 =?us-ascii?Q?oYy8UbBzy7CC3pngp0dY0lV/bR4RYFuvmwyWi/o4dbg9TG9mBK7OckvbdYbW?=
 =?us-ascii?Q?kRL8BjYrf8fyuS3oBVoOGAYLRWuoOiicgNo8k6maFioVntS85b00A3c2559z?=
 =?us-ascii?Q?vUzJTP4coziOFPMElLLc6+hOkGhtjSgKYCPCA0KI0YiyEGRY2Z3WvtbiK6iQ?=
 =?us-ascii?Q?2XjVoT5N86UHZXbJ+2ME7DcqELz93j/MtjH8LBKz8pFH88+XYadRXTlj0ykl?=
 =?us-ascii?Q?NrRlAloBGcnb2cC/F0IuuZhb6dNj+yxDun9vc2KaFuvfgN+fyXFmto39ACww?=
 =?us-ascii?Q?TaP7e0nyEsDVIVswv/LXQ30YxNvUZ5xrzvyvzIEGyCM782vD7KaoaYzEvnMK?=
 =?us-ascii?Q?mJ/9YBRPLXDWtJYd1W7Al+nIAEOi+4JqGr/562qCXBAIwdlTYjlhaRiKK80N?=
 =?us-ascii?Q?/KhwOZnNWf30UXmgmNuuCWRRH8Mwhe+o0xrWSh4drFPlxv0ZeJGA2LOI8wzV?=
 =?us-ascii?Q?K+1Rc17akufBjP9Uo2fsO2TvXLzRt983X6piZW/qaCNyB8EbfDVaXxMgf/A+?=
 =?us-ascii?Q?N0Ph5i/Rwf6DGc9CRmfjcJC24s0pQunF6eUtiG+WsOUBtSVpNR2+DiMn6beV?=
 =?us-ascii?Q?r3bWr3gC/yt0ipLbm5c4Hygbaxb6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N25XH/cXQxEHiUMmZc/xBUPWKgZr8jVZQZ4uISYoLOAHH0fcZc+pfhA5q5in?=
 =?us-ascii?Q?Dyk9FeEz/gdspCCXiqCI6t9nkaNEfmHbcVAUYiOBL49UFss677v5sTRtekdK?=
 =?us-ascii?Q?cmx6VIGLMGnnvKGoE0uA/YT5PNhENQIZ8gIWsFPa30fL0WH626XTkGNHyLjb?=
 =?us-ascii?Q?5OJFFUm4WOBigG8qG/CfcWWZ+ARIWPKAMASyZ51xFA6TG7L7cvonup3/OaPz?=
 =?us-ascii?Q?x1tEWZykRZ3nMrUzOhL8Xz1Jh2LFR1IjCNZZk45UYh0FzY+hl9IS/7IWttiY?=
 =?us-ascii?Q?XM4fJqdxM3muveFhcIiaXLbgp2pqoQGGxvlpNXTBlhPRFCXMHYGN+ff+aM/c?=
 =?us-ascii?Q?lAm7r2yt8RmaYJL8Kt/oSqc1pNg+6EL17Yu4fDTlSwh0d6XK4zR7Ct/wIsu+?=
 =?us-ascii?Q?2WVGLdliGXdgx5CiGWEr1h4KzJcQlrHF0xRR3l7E0DGzPMFBjjp9lmHonyNW?=
 =?us-ascii?Q?Py39fjzaAo309VdooCjtj14T4Ko9UIFm31Li9sfAYSwkPtDOIQPVFBNzTPTx?=
 =?us-ascii?Q?puOwFsotI2tKp48njjrqR7SK6mXE47C4BtCfwHogVRoQ/yNWlEV1oLj3K1wQ?=
 =?us-ascii?Q?U5zeNm7KUW9bPTq6PrCztjtPEuIFYGZ6WaUnnlTB3SGEpLpNDdfA4TvFdjqD?=
 =?us-ascii?Q?UcNYJ2Z5tjx8u0wPrpsJaYtXdDWw+ARiYs+jBuJtYxGYf1rznnRKt6QfLQ6V?=
 =?us-ascii?Q?TY8LXvhUBsMQCVEE01tO5S7JaPF0LlPbWejESpFk/skSmM+gfjUiypUF9N81?=
 =?us-ascii?Q?15n+uSs9EnRDjh1AXV2Dpd/soMHRUXcmFQ4mnKzlfmAL6ABKS7p4jOtOw6Yv?=
 =?us-ascii?Q?C4VZWkhcuLgMviQHQhZ5weLZkebJDSpMCXx95EoRzqXHxFlw2HdsG/Z1aK7C?=
 =?us-ascii?Q?IUwJ6BwpCfpNIGbu0w8uWaZD/IoU2itanfKBrWbuYsG/+2cFA0Bw3zymCQTR?=
 =?us-ascii?Q?5yH0SyO73yYoN5p7reajTuRAX68glmxnNkRB+kyg/3/kjqLHsTNLmaJQwPJq?=
 =?us-ascii?Q?kTRfi/JvowlmKxE+shJ1+QZiyQQMJxnnTVX9mTVonoGt2u9QXc1wSXgF1MKc?=
 =?us-ascii?Q?reKFqhdCd/3fIP7uhabbenwQNryLEIuo1YgAoLOUTp91bgb/igvrFQgCux11?=
 =?us-ascii?Q?xVVv3YJNWINGxxZLHT2tMQ2HbAeh7XeYM7QIrTfOfWRVpMMV89T250oP34aG?=
 =?us-ascii?Q?AznMoCA60hcxmJPFIpZx7h+AIGRORGXeWHlN42HLRcjBsYq/3saCOH/zneCm?=
 =?us-ascii?Q?0bgTJE9960uHyYXsh68e2BzIr+zwoXMVcOF4BEE+3xlSgXgQ9L0GRQB/TN8o?=
 =?us-ascii?Q?nvqaEs1G+SFfChKwnBId3UzdFTqjU0CQz2n1VreqjtY5y42WrS0colXmeKlh?=
 =?us-ascii?Q?fTV6kbNo0K9gAN/OWIBtS4dgFKQBEGqyLKJjkv8w+VP6vZ55ESsBOI0huVpB?=
 =?us-ascii?Q?D0o37nCpJFekFpdadGieSepKaKWl73nBA65ujOayu00Qqpghx+iNVz0PSSu+?=
 =?us-ascii?Q?QTEQjobJeNp/H8dvLONBkxi1+BPmyfF/fK5nV+KFFNa+PP6e9N9UnBzPGJvh?=
 =?us-ascii?Q?euDg2Uxq09HbeBPDUfox/6GNmd9iyPY/AZFIk5A+QFMlu/Hb8CkgpRd+AhLe?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K4h6EAQWVYeW9el5CArXnaLjosnCLgUoYgopQYUnhBFlhaTaRfGXu7GhIxho66NCNuj1inPFtYJcbUDbm5j1F1wi85Fr/1kxXWoo5sv7DuV1huw3OWPcXGaJSgRjBcqjiMxQATyvHO3W7XMaI4W1/f34yQtOf6TRZRfHRXagEYOcqYktGpXgu7PkJicRttm0JcQt+pVDL8goMhpiUVSwcBhYhB8idvc24/wKT+52Smy1Hp+vC/TIMjcOuJVZegAq3FFYgRiv8/andb9GVDG4gLVXfXmPIhHD1j/H5NX9if2iNIXxSj7hfdErTEVXs2lvPsoI8wf4uxpbzQCZHOPpNSFlw7hMjX/DKZ0rk5J7CKV7Kg93lGlIEisgIScwVgQXBQYJtDxzuyCOgX+zRqJstox/J1KxdG9RuANm9NpCc/mnoR0ENgzd0vJu5pWUP/QMzE5ySxj0dOlDkTPa20zeYo0qVx16EqkozNo1cQltp2UHcZSnVIW6ADe8iOv1YOAVmSfPJ8OCmg7Pi+Ll2/NXdw6p53fhjhM+2Qc9/l/MHWA45A+zP4jjJcStFjWhjwQAA9p3VG8hPaTXuZujjiPnXLO8838aWLkHJG0iCo/Zt74=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a50cc5f-42c3-469d-a104-08dd41419ad1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2025 15:20:18.3864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpr3UphjI6p5s09vn03Y7mTc1nlchySjfeRxrTyyrsHuoDVktC42vG8xbGni9o/twdWvxR1CMF5JDfSaspkKk3zq8gENF2PoIBR1gbSMfSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_06,2025-01-30_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501300116
X-Proofpoint-ORIG-GUID: lU9Nx6grYwTxE1IMoywnBVVVegBcYVVX
X-Proofpoint-GUID: lU9Nx6grYwTxE1IMoywnBVVVegBcYVVX


Eric,

> Patches 1-5 rework the CRC64 library along the lines of what I did for
> CRC32 and CRC-T10DIF in 6.14. They add direct support for
> architecture-specific optimizations, fix the naming of the NVME CRC64
> variant, and eliminate a pointless use of the crypto API.
>
> Patches 6-10 replace the existing x86 PCLMULQDQ optimized CRC code
> with new code that is shared among the different CRC variants and also
> adds VPCLMULQDQ support, greatly improving performance on recent CPUs.
> Patch 11 wires up the same optimization to crc64_be() and crc64_nvme()
> (a.k.a. the old "crc64_rocksoft") which previously were unoptimized,
> improving the performance of those CRC functions by as much as 100x.
> crc64_be is used by bcachefs, and crc64_nvme is used by blk-integrity.

Very nice!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
