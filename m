Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD7C1442E8;
	Thu, 18 Jul 2024 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721317434; cv=fail; b=IiLR5KpNxbZnTUXExi8aOGh9efd1zdji56b8JzxR6wBpuqA170DSpGL9QE3SurSyUpGaGuEPdSZkEpM6quL8B6txSz6YGi7//FcfNhfJOnGQBRflmHZbAkFFOoelGRe7H8Vb9dbo0ZnnnBeTSOnrsELHLSkI7eTNERQyD+snxK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721317434; c=relaxed/simple;
	bh=vxM2XtgqKeV+ffW5hdLucOJ1CPMzu6ge7YRx+ZtMjHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T702njtMHJHexLniVty1/K35GsKIQVe1BbE3GifmRcy8nfnvBwHcSo07YzkES0qVPVk9Cwc8S61aN20W5nk1tQ1zjw4aZvPMFsQa2jFLDsIlWGHF+3I+Hi1AEmxhgNIo0sHo+C3JiHwxfVjbiBT/9QrsyrGVX2XcjlgVK5oL2e0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RtBdZ/v5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YUZuYfaw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RtBdZ/v5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YUZuYfaw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46IFeMhh032511;
	Thu, 18 Jul 2024 15:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=/6R1uMd0FovZvj8
	4/gDtZYBdTv7+N49aEFRGouCsaTw=; b=RtBdZ/v5mkYjL1W0czr/muke/Go/GrX
	PbtdJnO/08CzVDUFrmGr5hAxJeUFVpM6eySfd85TPiV/bxBkJV0sE0IXQ1euKpJ2
	wL8/9cK/PdrTWbfHj2D2nOe26Cz/KMlJNA3LnqENbYZgMoKQ23sWJtFx3T6xeeA6
	80YAKIrZmEkoSvzZIJcTbdKZkZcN+f94ReeIXS22IKF1ddMoozAEOKgljmri9yyc
	tiByb2dwdoUeX9A9GcTH6NUVkhzzcAEN+i1tf74kiCtj8EMOPLsqiZ0S9VOqKaIX
	W81+USkZNKx11TbToqVpFXvyJqXPN5kR+GstbL6w+9XcvapxNNXTEeg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40f5w380sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 15:43:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46IENAia021621;
	Thu, 18 Jul 2024 15:43:30 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40dweuskyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 15:43:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=recs7bwT7ANWnBkl30ZW49MzX/aN4L60bWAxLR6e9EwIBjgK6/h8USL5+xN+aAhLFG0Wypar66/DexTeG/tc2G4Bp4ZQcIIPs+tHY+d58eHcvbBRmXESrS9iVLwGoucBVNegjWO4b/zPSr3k6hm0qFt5jJnNGKldJ2GcvuL4lw/MewyXOK6Uy617QUbW2jBCkhICGJr0Nf4N81JJAzbwWr7AWzA8/8uEzItOJAo8EOPB7dpLg6WAl6JsUxkmObDTD72YsisckT+S+a8TZScfn0e8/D3FyCmCzfnL+ur1VSo/Fb1AelBdZfRiss/X9SdRfLjgXTahlu4vVTAlv72OtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6R1uMd0FovZvj84/gDtZYBdTv7+N49aEFRGouCsaTw=;
 b=jY5PCrV/6JMpu1SWB5kvB2IkkNThhuzk0OCwTzhqGaYI1bLMhVMTi5HxpOp5EML+sG12xWyrwOhv9k2bjKl+bHnFXkTPw4Ld7X1prhJCwdSHHnMTpITuMugEXaEdQPeGpTlQjPe2KcpL6bgoalX/kdbqw6PADra1tSkJqjnnJ1LWD/9RykcsH/uTt6mqOTioFHR6HY+lMCyNb4ulJIV4AwRKKcLf8BgSfb03nRSfjyij7GntgNyYxlB7OZ4iznFtsJtrVTUAaFzDqr2fy4GFvdBPE+QQ5vT/YSy5qr8jTNSpvV4YK12PPh4YrcA6RVlo8AkHTb3C3l4achOnR5kDWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6R1uMd0FovZvj84/gDtZYBdTv7+N49aEFRGouCsaTw=;
 b=YUZuYfawPH1nWaDsX9hOUSYXAc/qCrTi889q3Y6WRJnNzDOCQPaLYKV5H141jSBh46ALAgTJNW/1dgfYfZDtcq84vsjK8hx4Bkub3qqs8t8lK2y0NcgfOf1c0KKlv+2NR91VnVGp+qwd7nr92h5ZCAIUHTRVtzHlzy7qazDDqYs=
Received: from DS0PR10MB7933.namprd10.prod.outlook.com (2603:10b6:8:1b8::15)
 by PH7PR10MB6483.namprd10.prod.outlook.com (2603:10b6:510:1ee::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Thu, 18 Jul
 2024 15:43:26 +0000
Received: from DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490]) by DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490%3]) with mapi id 15.20.7784.016; Thu, 18 Jul 2024
 15:43:26 +0000
Date: Thu, 18 Jul 2024 11:43:18 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-use-after-free Read in
 handle_mm_fault
Message-ID: <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <00000000000037cdb0061d5924b3@google.com>
 <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT4PR01CA0117.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::23) To DS0PR10MB7933.namprd10.prod.outlook.com
 (2603:10b6:8:1b8::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7933:EE_|PH7PR10MB6483:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd99975-7f7b-4d68-82ed-08dca7405d1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?D76PsGSLTccrOW8CleZrfGGWm5Whpb/PaQDuis5t5ltkFcZXgysu9rKt+IkJ?=
 =?us-ascii?Q?o0CD4otpQVfD0lVOTOf1qkg5Rgbr6t18W4lgcGanMo0QvBjIHs2DrTTqBfhT?=
 =?us-ascii?Q?5wQOD4xgnzYbxrupJpdOeqi0gyuyY1ISzXZ6E+58b+QnMGmjLY9KKVRK3YPF?=
 =?us-ascii?Q?SMT30OcfdXpITJWK3GJXQwB4v1RlVR2u7TRAwg+sR2qbuXXTTHr4AAnviF0o?=
 =?us-ascii?Q?a4VxrevQ445Mn/rfi1ZrISbwybyFHXCoa65DBORs+QCrx0Oq+GZ1MSdtiW2F?=
 =?us-ascii?Q?qXhbQHRcqmdyzDMGbh9+BdJPEfPxl7Y9ypKOa2ODBSfR3dZSSEVaibdf8gt/?=
 =?us-ascii?Q?QBqlCioAMAEXp17p4DjMUiM45MhvqQ2xvXbwL8B7/S/3aq035k+Pxuy3hXW+?=
 =?us-ascii?Q?JUhGiD08G5BNrV3XGwRUPfYfavTmDhGu0A151UQyXDKmm+YxP6adnEYPHpiA?=
 =?us-ascii?Q?eel7pAGE9dJsFFTseg/Z7+m5FjG026ri/aGASIOGtvcFAz6wLZjbXec7lwZl?=
 =?us-ascii?Q?7OkivG0mZoF2kdTExlO/QTbYEfKkZ+LPOUDtEYUQ2tfxkhMmXTa/qUkfk6Q1?=
 =?us-ascii?Q?umU8Di3L4+0nEYHWW+gRP1p0v8Px7LdEnHERIC4KVTXES4kTvRW2pU97THvk?=
 =?us-ascii?Q?He/NniEAJH9f3LUEzkYFaJxkxAnkoo19jdBxcbdg/mFJSOUKNJeW6Qv1cshy?=
 =?us-ascii?Q?zemhCUfcbBWiAF7Nh9CDPve2TA6K4s5me01C8mxsjDtATklvkvqHLUMzkTLC?=
 =?us-ascii?Q?7qRFcOhvzj8ZpGfHTmtvTFkIkO7t8xGNBY262dcmAU6VSW708NFrGxQjfOrG?=
 =?us-ascii?Q?K2O1vQbKy2OBsl2ZaQar8W7p/zI7q54H4/FIcLz1jnn2GBc/z+dqBVfleAGj?=
 =?us-ascii?Q?mndswwlsXLjzu+8pTpzhvcCN2Mg6ZS0PKFiprygTglk3gpCNyAYKF/JpSGKF?=
 =?us-ascii?Q?twqKTa+3zESEGUkeRUdYK7xQmaKPROgzX2xfxqGPoxUzfaJjErJRuIlmC0f9?=
 =?us-ascii?Q?hIISiqV9RFkHX/qe0L+HUF6sGtzkr+dTqSEyaJ5JoU3eE0z5rGaH/x+1AxCi?=
 =?us-ascii?Q?b4sL5UP/jb8ZNlwPeXYXwQnKwvK1FLPwjPGVAj68YhGxP6sP2oS0dyaBOdV4?=
 =?us-ascii?Q?oejxY9tI0xJ0VAjjMUM/kNvOAl1F8NH/Dn2qXS1SdClKFqdjCzExiDTxp0QZ?=
 =?us-ascii?Q?noG6u06aHP98ZdCpFsQI54xvFjeYbfOiqpjS2EEiTWg/T97Pxk8n+6QQLhR4?=
 =?us-ascii?Q?oibk7tWVTwNNESdtW8bdqBSo9rIK9/haWCURyAALBK1FE9oJZbOLAU2B2xQ4?=
 =?us-ascii?Q?oTk=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7933.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?k2zZHJz8vZp1ZPV4IcDM4HG/aOGARySUGLUByvstpHdCuL/l/e4rE/t2aZEY?=
 =?us-ascii?Q?8RgukTaBftEYaB+DjThhsGFzMmo4yGGEGpS6AdFNv1bCCFfVcKf8q7pZKzXQ?=
 =?us-ascii?Q?UQykEIGKxJiLQz4tfAY6k9DW/Xs2btKFRiEk72x/h+8I1q2ouWHGjJhahbc7?=
 =?us-ascii?Q?fwaSw1umxCpFGvD8PvOmEPIImGBbdHHgGGYW+A2/CQiV/d6hgLIoNEMqdcAd?=
 =?us-ascii?Q?NchcrL5E/H0NYfBygIdIIkgbpgfK2QFlHGDTEd311S2yUph03aYoZ1ly40Hs?=
 =?us-ascii?Q?xDAxjbmjVAimMrBxSO2zdEDeLlIWE7lCkng/82ZgSa4JxedR8EMMON42MCmR?=
 =?us-ascii?Q?9w2f9WEH1D5dBsXjROa0zZCoUAXPdgPDigvic6JV5S9J3SwWQ1jrBNxSEa4/?=
 =?us-ascii?Q?kqrXopUqt8/Wew/KoTaf7eMLNSCcthjLi7k9+Vn9aFCjmiirsASb+uJPNhHT?=
 =?us-ascii?Q?ChdjBLTOmYLMQ249A6qVBysxH8mdHwh7fiZK+10DpBurCUM7+nUEl1KB/ikm?=
 =?us-ascii?Q?yjSJhjdrTZUiwd5I720VjEZ1xOddN3I4At4xV+SnTxNcXb3WSsMWMVDqjkXR?=
 =?us-ascii?Q?As52opqv/ezhkyiQWLa0NnGA2b4k9yNjZl+rNF1xzz+UoH54D8xcJcpb82yF?=
 =?us-ascii?Q?WWXrGE4HDAatVQ911R/FcgaKkZUqSNQ0dtTOUTWPOtfDhivQZlh6wKw1rE6q?=
 =?us-ascii?Q?II0SBOju66nghOcSalJC+3Cz+gezrm065hNxgsvdK9B/wVbIj5P9DowPMtIu?=
 =?us-ascii?Q?4/U8V+RK1+1ky9vZybuA1xpCWDHkwmZsgum6IijYQpJxlXOo2UH/y6yppJgu?=
 =?us-ascii?Q?+4+aoYPHbk+2xxGUiddQNl/T3VRiSmh48Fex58QzEboAtGxEFW1VPy021nry?=
 =?us-ascii?Q?z4XBPnyeOMUXXtG0aLABKn+Ll5BbBwMGe6fxeAVOeO4gEEhwJWeIkampAZoR?=
 =?us-ascii?Q?zAa7JZnl65nQDYufZlvzFGsxrjuF4e5DwbRgFDMxa37DUtkpP84y8HNSQgb0?=
 =?us-ascii?Q?Ok9k5//RlDUKc07WOz2mSpQM8Q7OP553Xjcd4wK1wZ5/36LnLqgwc65t2R7b?=
 =?us-ascii?Q?Dki+GlJwMHLQ/W8hoRLHt3tiuYYSo6rVWgpV+lTwZmwgingO2tsSPY8tTUSP?=
 =?us-ascii?Q?m89jJ24MNCKvgGtat/kSYK8sirT9OQL1sWvN7G1Upvfg5A4uNojxBCkobZgN?=
 =?us-ascii?Q?fBOAAKJvrBcGoJ1Cjnjze8tRWUGbvoQ9YXJZTp2by2xuzqpYGpvONJbxLM91?=
 =?us-ascii?Q?glJL8CV/kO2+3sBsD+l0+TSPNBFgUuQJ1al7JrtKQWCPfsCZ2FhMhp/VL8ER?=
 =?us-ascii?Q?KaSHjv3S0xh7DnfnZuTG6IaWTdw3uU77dDuvHb1iYHhsvwT1DRfBdNJ/X4L2?=
 =?us-ascii?Q?K2VMUYF1Fq88zteF/gYisNew/BTChv72tmJj5zuyUQpDkpdrqq+PXdopB6P8?=
 =?us-ascii?Q?ne7QO5rwXNldUHfqmpP7Un+qjS3D2J6JI2ulCOAbWdrMzMuthTsCyW9zsgaA?=
 =?us-ascii?Q?k2xQ4SiNS4Li9NM1i068IbXbhWjJTZK3DcAlagX7jrASQrttbXBkhVOPVJDh?=
 =?us-ascii?Q?tDP04szgDyjGtYAXzwSunefPr8FU6w+0RMKX6kkMIrouE0nrXfY1Mmbv3NET?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MXnQjamuuTpe7yQXbSvgkSbW82rli7e1S8LsAHkQhZP4ZZRcVnH3WZAg5TJtXAznENPV4xFcupWhSFGGx5ssjeZapHMw4CXUGPqRtO8y4qVVgcmo5ZmuK/OPBtCZv/mf10+RhlEddMWw+kBoELpT2KMXmXtprizjGQ4XgKsdwTRzvtoVD/y1k2YC2tQsERUD9LpYxICMP9R4iFQnztM0VzKSuI0gPnXxP54rYJQVkaCR0rXVOFd7MmnKCKub+qhtVbNIiHHGnzHFfmdbQyXxIF3k9wlv5ZQ1iiR0LIiYEKRnaS3wGfNbRtsdqKcCjCN8AJSC54mEcVsz2i5P7+PCB2YYrA1nx02CVZvH2FNDH+TYMnRoU2P8N3vWVeGTRFi6iEQWwIBZYlLOagk6nbd7JU7A717bTklV2QmYwdJFCBkvDNLwHDBo7OMEJO/NvfZfLDUJ6EgjQVBaZWgFSb8kQy67mys+LHyRM5oO5JbPhv1/mHZyQnhkn7iSUCdL3cJPqlZ7W5qemPgJWfgtmIFRC+dMg1aBXO6qU774yE04hmp0c3CihJACG3e7tYlvy8JVkYtpXQb+5vvAQd9A48okjbZJ/4NAbWZw4/RmVeZTq6U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd99975-7f7b-4d68-82ed-08dca7405d1b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7933.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 15:43:26.3471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0wa8+C5tWU2su5f/NCMtJ8t2UTxv1jRihWiOUcPSzyn+HXefwRVwjO+BfRhHA2Uk20ilJxYrIFeDNTHLGeBwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6483
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_10,2024-07-18_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407180101
X-Proofpoint-GUID: QrHLNGN6Hi7024NrrV2BuJ6UkzMkP9km
X-Proofpoint-ORIG-GUID: QrHLNGN6Hi7024NrrV2BuJ6UkzMkP9km

* Vlastimil Babka (SUSE) <vbabka@kernel.org> [240718 07:00]:
> On 7/16/24 10:29 AM, syzbot wrote:
> > Hello,
> 
> dunno about the [crypto?] parts, sounds rather something for Suren or Liam
> or maybe it's due to some changes to gup?

Yes, that crypto part is very odd.

> 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    3fe121b62282 Add linux-next specific files for 20240712
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1097ebed980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=98dd8c4bab5cdce
> > dashboard link: https://syzkaller.appspot.com/bug?extid=4c882a4a0697c4a25364
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d611a5980000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ce3259980000
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/8c6fbf69718d/disk-3fe121b6.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/39fc7e43dfc1/vmlinux-3fe121b6.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/0a78e70e4b4e/bzImage-3fe121b6.xz
> > mounted in repro: https://storage.googleapis.com/syzbot-assets/66cfe5a679f2/mount_0.gz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com
> > 
> > ==================================================================
> > BUG: KASAN: slab-use-after-free in handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
> > Read of size 8 at addr ffff88802c4719d0 by task syz-executor125/5235
> > 
> > CPU: 1 UID: 0 PID: 5235 Comm: syz-executor125 Not tainted 6.10.0-rc7-next-20240712-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> >  print_address_description mm/kasan/report.c:377 [inline]
> >  print_report+0x169/0x550 mm/kasan/report.c:488
> >  kasan_report+0x143/0x180 mm/kasan/report.c:601
> >  handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842

/*
 * By the time we get here, we already hold the mm semaphore
 *
 * The mmap_lock may have been released depending on flags and our
 * return value.  See filemap_fault() and __folio_lock_or_retry().
 */

Somehow we are here without an RCU or mmap_lock held?

> >  faultin_page mm/gup.c:1194 [inline]

/*
 * mmap_lock must be held on entry.  If @flags has FOLL_UNLOCKABLE but not
 * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will be set
 * to 0 and -EBUSY returned.
 */

We should probably have a lockdep check there then?

> >  __get_user_pages+0x6ec/0x16a0 mm/gup.c:1493
> >  populate_vma_page_range+0x264/0x330 mm/gup.c:1932
> >  __mm_populate+0x27a/0x460 mm/gup.c:2035

/*
 * __mm_populate - populate and/or mlock pages within a range of address space.
 *
 * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED mmap
 * flags. VMAs must be already marked with the desired vm_flags, and
 * mmap_lock must not be held.
 */

What ensures the vma doesn't go away then? - I guess nothing, because it
went away.

I don't get it.. __mm_populate() must NOT have the mmap_lock, but
faultin_page() must hold the mmap_lock...

> >  mm_populate include/linux/mm.h:3429 [inline]
> >  vm_mmap_pgoff+0x2c3/0x3d0 mm/util.c:593
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f093ce17fe9
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 1d 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f093cd9e158 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> > RAX: ffffffffffffffda RBX: 00007f093ce9f4b8 RCX: 00007f093ce17fe9
> > RDX: 0000000000000002 RSI: 0000000000b36000 RDI: 0000000020000000
> > RBP: 00007f093ce9f4b0 R08: 00000000ffffffff R09: 0000000000000000
> > R10: 0000000000008031 R11: 0000000000000246 R12: 00007f093ce9f4bc
> > R13: 000000000000006e R14: 00007ffe8008cc30 R15: 00007ffe8008cd18
> >  </TASK>
> > 
> > Allocated by task 5235:
...

> > 
> > Freed by task 5237:
> >  kasan_save_stack mm/kasan/common.c:47 [inline]
> >  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
> >  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
> >  poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
> >  __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
> >  kasan_slab_free include/linux/kasan.h:184 [inline]
> >  slab_free_hook mm/slub.c:2252 [inline]
> >  slab_free mm/slub.c:4473 [inline]
> >  kmem_cache_free+0x145/0x350 mm/slub.c:4548
> >  rcu_do_batch kernel/rcu/tree.c:2569 [inline]
> >  rcu_core+0xafd/0x1830 kernel/rcu/tree.c:2843

This seems right.  RCU freeing of a vma here, so that's okay.

> >  handle_softirqs+0x2c4/0x970 kernel/softirq.c:554
> >  __do_softirq kernel/softirq.c:588 [inline]
> >  invoke_softirq kernel/softirq.c:428 [inline]
> >  __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637
> >  irq_exit_rcu+0x9/0x30 kernel/softirq.c:649
> >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
> >  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1043
> >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
> > 
> > Last potentially related work creation:

Also fine.

> >  kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
> >  __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
> >  __call_rcu_common kernel/rcu/tree.c:3106 [inline]
> >  call_rcu+0x167/0xa70 kernel/rcu/tree.c:3210
> >  remove_vma mm/mmap.c:189 [inline]
> >  remove_mt mm/mmap.c:2415 [inline]
> >  do_vmi_align_munmap+0x155c/0x18c0 mm/mmap.c:2758
> >  do_vmi_munmap+0x261/0x2f0 mm/mmap.c:2830
> >  mmap_region+0x72f/0x2090 mm/mmap.c:2881
> >  do_mmap+0x8f9/0x1010 mm/mmap.c:1468
> >  vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
> >  ksys_mmap_pgoff+0x544/0x720 mm/mmap.c:1514
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > The buggy address belongs to the object at ffff88802c4719b0
> >  which belongs to the cache vm_area_struct of size 184

...

