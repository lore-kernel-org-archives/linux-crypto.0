Received: from mx0b-001ae601.pphosted.com (mx0b-001ae601.pphosted.com [67.231.152.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC46433BCA;
	Wed,  8 Jul 2026 12:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.152.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783512482; cv=fail; b=P+HQGUY15NDZx6YlOCXTbD3yJFqXaS4DHNkkM/64JGz1429WzYuNc6wn+P3bvuyxLF7suoC7LXBU9IEdYlAqfcAiwl250fLVbQbWZSXg6T2E1lm2XTSZ3x+Mrk2shGkDAn/CrROec5Aqvx6H+jwPj0MnIrxI1z+/+ekSqhfrKW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783512482; c=relaxed/simple;
	bh=yOg2s7X4d6dJCDi4FTYkNRrtRJOi2DD0Ml1fOplB370=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YceEy7pI8LMgJHVFzrZ/Xj8LY/MzdauIg+mkAiigxK36RcVaZivxn48Zr6fXJfsbb9IUWHOQNpEHym0pc8HB9U0xMwAnC42sKGGuKZLQhQB1aGdwsWSaO7eGbsyw2ntesJsWr2q9c/D2TH8FyT5kYgEwswgySReuSGO5J7xFExA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=EiqEYPoh; dkim=fail (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=AHjH9fwK reason="signature verification failed"; arc=fail smtp.client-ip=67.231.152.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="EiqEYPoh";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="AHjH9fwK"
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6683v2oi1543079;
	Wed, 8 Jul 2026 07:07:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=6ccdm1YDNcespNeVb2kQcObvB7smQJg73d8bgCk2blk=; b=
	EiqEYPohh/hWqKsniz8daa5+Fdn/33GnaJfKInRKaap0swhWoay92JZDriCyZs6U
	+xbf/fpmvf3jm1/G1CGbsnCv9DU2V1S0z5JR+94N8gfBPo12EL2JppcoaiM8J1zL
	Vo28+9fqP4FMgo0WIARp3krftienIF717EUnbKK60I1+6o1pn1gH4EZOjTMV9Wxu
	M04kD9GDmc/oDFXjmolzY0EMMDR+xav3GPCh854Lu1oP2JtzrjeT0O5SWfVO94Gj
	xSOBDw/VC0FgvfrafVaauImzqndhVf6pJSA2gqM1hfM0W6wM3pjqCJ4Uq5vueCjp
	jhnpRt9z0l5OwIJqKk4rXA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023124.outbound.protection.outlook.com [40.93.201.124])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 4f6xkjp649-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 07:07:32 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GW76LlC1qe5THWzTqxcaw9qe5JqwShRpiY1DdbfZ24sPZsAIVGle/gCG25OeT3jkU/TOvjeSQlaUH8DhR7LSIqLygtFAr4o2dKEEkCCYmy2zeJI7Tm9n63pUcL0qoAPspxb1gJtDQquoXQJ3LQJbnTnX1bcKOSwB22JLFXSLgtsngLr5Kl08r/wMlUekjUxVaFFJlTPUf6wiUHYuPCBWXidhGasZBdtm5WdCdOk2WclXkrDhADMe4oOwlA5swSZO0BydJD6N3fd2bmfZsAq8REpsXxKGn9h5mHd+Ep9wPtw5nZKuMSky9NnzY6eg6HdScP+ti+ubI/wSRXIuCvuz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPSKBAoTdHt4QbJ2ucgvcyvRIer1qdoXPvlPKPR88n0=;
 b=a0kxeIx4NLh2dCmyr3HAFVi+nd6kb6bigUU2ww+m42/XSYfJD6/KMtn5MWJO/lI7sLYnmTLODDsdBbnZb0OyK/o+wrFyX+lvkF9xreZbOk4zSuDirE7axdJ4BwjB3LxU1t4PxRAeXHGikpgtCAfp6GgoN2wGcVv85bki120JGyzEfcHOuzVuUIbCUFtpTzc9g5kVa+y+NjWZVl7ShRLcoPeauDYsxnDwHdCKL7BViDLXptZMDg2wthoRkjVbGDB1mfq10Sn4ejOhfwld7N8mh6pmcpXulzgXOjthgX1H2e3th097j+h2dGs4GQ907tJ9vyeWmnRzEkwznc+kKHQUww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=baylibre.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPSKBAoTdHt4QbJ2ucgvcyvRIer1qdoXPvlPKPR88n0=;
 b=AHjH9fwKhPNobiju/SqkLoSCUksMmCn9glUc323P9roHmF/dQ218KUxQ4q1vA+VBqSGh8Ztq4tFQJRA+SdKVlLdqySMKdtFqd80+ikFUiI5YbDNshksn7JhAjNrNM6Ypa3cD0eP2nGk5bK5JNwwGMnfjfiqBh1m0MXdLRyz6BUg=
Received: from PH8P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:345::15)
 by CH8PR19MB200841.namprd19.prod.outlook.com (2603:10b6:610:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 12:07:28 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:510:345:cafe::e) by PH8P220CA0009.outlook.office365.com
 (2603:10b6:510:345::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Wed, 8
 Jul 2026 12:07:28 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 84.19.233.75)
 smtp.mailfrom=opensource.cirrus.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Wed, 8 Jul 2026 12:07:27 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 754EF406541;
	Wed,  8 Jul 2026 12:07:25 +0000 (UTC)
Received: from opensource.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 5A7B082025A;
	Wed,  8 Jul 2026 12:07:25 +0000 (UTC)
Date: Wed, 8 Jul 2026 13:07:24 +0100
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Lee Jones <lee@kernel.org>, David Rhodes <david.rhodes@cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Qunqin Zhao <zhaoqunqin@loongson.cn>,
        Thomas Richard <thomas.richard@bootlin.com>,
        linux-sound@vger.kernel.org, patches@opensource.cirrus.com,
        mfd@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 11/23] mfd: Use named initializers for acpi_device_id
 arrays
Message-ID: <ak49fJVODX01wgYs@opensource.cirrus.com>
References: <cover.1783507945.git.u.kleine-koenig@baylibre.com>
 <8c8ffcd41b59446ebac377341971d6572f79c842.1783507945.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c8ffcd41b59446ebac377341971d6572f79c842.1783507945.git.u.kleine-koenig@baylibre.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|CH8PR19MB200841:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae62544-e2d2-4449-4a22-08dedce97a74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|61400799027|23010399003|7416014|376014|36860700016|4143699003|11063799006|18002099003|5023799004|22082099003|56012099006|16102099003;
X-Microsoft-Antispam-Message-Info:
	GqIB5tMI4a8O449tcn7MtGSytJxayFYAhsSCpHFza7xkuL3tgICDSq89jSyPL5U2tq60u5EDe4fyPKaHAedUpvlFRd9Vv3z2sIS3MFLD9PfqCdUEfxgjfml9daBRghSzgHE1opLQHyXNnScPb3DhSU1PuUhamtWm9J/cy7AEL/mSNiPrp5gJEfoCrxqHoJghIyz8BmCKeknPw8DVAF8aTw5XOcKoNVpYbKB0xsu+diMqhBD6yVhgqZ9RbbQeizHC1zGfz6Dy2FDjhbS+ezzpIQKeWgtHcYBwIJoxaDx3evpBE7QQGGWsv5YV4mMqc2WYlaHIUxKArFICuI3QHgWr5T4VhEZzpbRu5Df3iajkznd5WvnGCXUXD9kjjwHTtpVmF8V7pWB3SbcN5jjG8WlkkQ/y+/k0wHctFomLXN1FqLNrDKuxTEfZFOX2SpKNoJYbjbSHt+bCEi6ddzV6DJbD1dkgs09qHJEQID5AA/3kSIF88FyWTk6BYW7o20/CufFkARxNGykBZ1vCkhc+KuG2O/nS41s/ZhLcnIjYbAaIoG3BNDLyX3lolXvgR5JZVbt5oppCFbPcNK/utmoqyNVxWhV6JjRQZi0pL7mwgLli9iYHQkm4hz+6a9BP+GBdhrS36WM/4Sf+oZLJVENlCURokNa7gXNFnKHipRF1N5iYiNMaTOtmDLyidsCqzeHuvUzSEyim8mt6rzQhTqKZ7/YzRA==
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(61400799027)(23010399003)(7416014)(376014)(36860700016)(4143699003)(11063799006)(18002099003)(5023799004)(22082099003)(56012099006)(16102099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HrR1QQKsrNyCwSLr2aWhmdQjL70MotCEntQ0hsUTKAWSPd3aHggTJmf7AwD+XIrDn9rLIfUkBnGXDVDv0nuW7LGpG+jlEloXYAjhpjGavdmLe2W0SFaywESzzPug1BFfqVXkkCrNe+kyI+79ZJN0/9GFjS8fU59hsSLx83xod+maBbGUU08llbxD7sXFEkkXlwT7wqNn/whqaNpdhRSXPQLLaqCbqgaC/TMdQlLWpzNkO7w6vBOILDrY4ZyQUsOzmvgZQbsXcerdDlR1FLogDuIoex+zeCaAKPes2FP5RNbLi/mIU7UGP3zULVB9MnyKaxa2A1O86uiFm32ldpbe4S3IQ72/rb+oiW4z2VMXcRJs38638N7v19S3tzOUNB4dkRDMn/El0aIy7m6enk9cYWUmhik4d57xryIF9fTNyyV4l2YcUP2bGvaQhAYeyHu2
X-Exchange-RoutingPolicyChecked:
	eqVnHs3y5xDgk4oCTbIjjqXvJN1ldjDl3eICNnPlLrWUjRlMxD4gPNpDurGB8mZ3f8dIb8LdbE57hn3GsZqURm2Hxv+XmbofYnyTz7oAnXVYjL5//6ZcTI6gEzgXYxoDvdwU/SFGw8UKHzErKBYpcRZ/UIdWg8X5JnPqHQyLRDSp8h4HdTjeaWS4QF06czykaAObC7sXvy1mKS6fecCYdn1ehzrKjuee3vnGlhR2jZtfpoN7B0P+prYmD8OhRJCkOcttC8eOzkVQifsPYcXca0FoA/WRSmmzy0p0yJu38Rl+oZ4Jqq7yk49d+zzRb62NXpIUr/JqDrvMYy0eldVHVw==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 12:07:27.0368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae62544-e2d2-4449-4a22-08dedce97a74
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR19MB200841
X-Proofpoint-ORIG-GUID: WNc0zRNJwd7YkTz_cb-_c7b3aeRPm-FQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDExNyBTYWx0ZWRfX4PL5ZNDGw0IE
 JsNY8mebnARLUQtfl/slMzWbvzA7aNBr3hdA51Wm47AVsIkN4sLgBbp9D64ZqthgnlMIZnLLK64
 jZ8h8ypoP676w/xEZMeCv6d+Oy73HnE=
X-Authority-Analysis: v=2.4 cv=YYiNIQRf c=1 sm=1 tr=0 ts=6a4e3d84 cx=c_pps
 a=3zFA2TB6y+4Z7TVRdmCe4w==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=8nJEP1OIZ-IA:10 a=RAioF0-LDSMA:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=KfkQE9S9VqCBgivYGm0O:22
 a=IpJZQVW2AAAA:8 a=w1d2syhTAAAA:8 a=V9wza0oogtZu883x4ccA:9 a=3ZKOabzyN94A:10
 a=wPNLvfGTeEIA:10 a=IawgGOuG5U0WyFbmm1f5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDExNyBTYWx0ZWRfX00Nc+w9+6EZJ
 xFgTs6Fy3gU6aHbKVkZ7ggmR146dQhnKNBKEh5GcGsQT0ZcHLjeRnOF/dZUpn4FTbrBqGW/IAM4
 c8QiCzQrgJ9enDPDpSyWujRTyez+KtIsF31gx8JHCCjX7mfjYDuYhmPCEsZ++GmMT9xGhtvd84w
 XNaiB4fmMqd/uvYguxoOugQPk6FNjHK3NaAy8VMBKf5yfhRSetNifVI3UkKe+gucgI3donfjmG5
 zokVGkUFB32T1pSS2oKaYU2cpEoOlJ439DDpW8LcklDEfhL1fi+b8P/vyatKdhdLU77CkMBavJa
 K3F9IigrIW2+agbBJnGxUwiZLQUtsxNDMElIC6Re20YnO/3zNTRJY2lGCuN5HmOnqGtNkm7LDmi
 sfyAuhmihNeXm5wXbm+GQBAOETvEDXyW6DhpSb0qim6c0zGDbYoj1yPG4cFswVf+V7936obTu/4
 tPupsRPUKIH55obOiWA==
X-Proofpoint-GUID: WNc0zRNJwd7YkTz_cb-_c7b3aeRPm-FQ
X-Proofpoint-Spam-Reason: safe

On Wed, Jul 08, 2026 at 01:15:18PM +0200, Uwe Kleine-König (The Capable Hub) wrote:
> While being less compact, using named initializers allows to more easily
> see which members of the structs are assigned which value without having
> to lookup the declaration of the struct. And it's also more robust
> against changes to the struct definition.
> 
> The mentioned robustness is relevant for a planned change to struct
> acpi_device_id that replaces .driver_data by an anonymous union.
> 
> This patch doesn't modify the compiled arrays, only their representation
> in source form benefits.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
> ---
>  drivers/mfd/cs42l43-i2c.c             |  4 +-

Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Thanks,
Charles
