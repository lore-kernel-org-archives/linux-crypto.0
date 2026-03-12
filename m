Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AD4242D97;
	Thu, 12 Mar 2026 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773336616; cv=fail; b=k7b3n0B62iYbOIt1OGH8TIMJebgnnkxMchxoO5SJ5bx8ZA5bOSSdQmfEDQenQeAEpErPgBgzOSl/yOXRCFyIKiOSechcEUlndNaPGXnqVnvNV3FeqQgL+4PcpV/1tYF6+yWd1e9ppBB9NK1LRGzMQECtGIXF5wWFPs1+HUGgEbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773336616; c=relaxed/simple;
	bh=dsLFAuYt+l6faNEXKUjN/9hSht9P8s8XsBMH2JIc9LA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=d33Jq0/S/YIJvbbEaOtomZIbVyD5IUvcDQHH9kI+2mxt543x1EmQphaPP+DX4mL12KuHdptj4mSc8/f7yPOM6hKGwa30KLfY20tzG/0Urjldku3UCcgpSXvZpeeoq8wO4wA9LtUoFeX+RVcQ3uZMvViIyC8aCR1laijyPftye8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EBs7vZRj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u4ByhCAC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBs7vZRj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u4ByhCAC"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62C9H55r682308;
	Thu, 12 Mar 2026 17:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=z+EWWbrnIZLLsv+V
	DLubn4JDt+fMMEBseB+lVelAUKc=; b=EBs7vZRjFDJGR7/Yuo8rmSYPzjifdGIa
	3U56vYU7sEGiPO3+1VRemYUgmhEdRhqyP910UgXezfsfNbl6YcNVy1oBL4KWeOPL
	I5vrV3wNNfw3tDTIjLHGu64yeHr5dp1lFVFdXT613FnEkgsB2CqQj1B6kHrwHJZs
	Rd2pB+Sqfqi8fkba7KpgMg4iStqEdVXb7rtexRy90sXl4DGYxqiYMUF3GUA9p3HZ
	zgu5QHB0dCrnqfmh4VbQtPB2eBK4DxNUywYu3FninbX1xJvAiCkigBYkcpbUON+L
	QyrX69fKZsuh/wka7WITPwMzcXvIAwqKywQZuL72MZQ0M3Y8Q9pgLA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4fhfpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 17:30:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62CHAtjF022202;
	Thu, 12 Mar 2026 17:30:07 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010010.outbound.protection.outlook.com [52.101.85.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5km9q4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 17:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hxD3jEB9Rzo8Yc9Wls68R2hwWtPf5a7Cl5scvK+SKmhqWPpagoqr91AmXMOmU2x0ow+wghL4y4fbVQAwZy8cV/MHIMib59wWFsAYQN7EvgA27ccqXAEaGqHtsoDApQCNFEhJ04qJS/SJIoTqsEXlLY8Vdmk37vXMMHxMcDIf1k9BjP5iOONiuMm5vkgi+jXy89vyI9L6YFM/3TD9I3xL6Wwxrw303JZuD0O6OTCX8/n1WLTY3Q+ZQxT8yIwmKbunX3KZ5+HjcxMDJGC4Voq72StJVjfZCWfuaGmrsfr0LG8E+Y/kcSGHjLFrq7EMc6C1Odv7+QRaG092qHdW6VLWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+EWWbrnIZLLsv+VDLubn4JDt+fMMEBseB+lVelAUKc=;
 b=OW7+lVs6nj0C62fnRxYHaRNqMmiAUi/e0lNcTsGhd86vfx/KSpZWUlSOtrvFJOgmEAaYthFRxBszSTJ/w6efXleF77+jx+G88YQU/V484PNMhJ0197wOCuJiPidrINoZKQQfquMArmUV24SpOQ7ntvo4xwFF9QvAEmJezML25zw84wltXP92r1mS4P1m6fqKuNRNC0TNFEHxkRNAsazF2thu+CXujo1H3IZ+HLgPeOYQHGPNkgkMu4eRZkT01zQXW8WiddqN4DSVlx1+g9CPUC6KYnn/+BuKCP+K7oS4JoC0P+VCOhQ5lgDeaIW9ZTACK3vurpHLTSkpVHfWV+Ze7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+EWWbrnIZLLsv+VDLubn4JDt+fMMEBseB+lVelAUKc=;
 b=u4ByhCACj6NqHakwAd4Hx2/r99Z9nHW6pOTRUVGWNoZJfwFUGHDqYruE9Z/q3VSUBKkfgnyBrjPuudXReoDn5cErqWTyeVAu8EHHcqGVUCzzf5m9lB2V1d6cAubjONzV1hIzi5DPq3Q94pg8R1W6j+RnV85ZVZqXMOXSGZqfuR4=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by SJ0PR10MB6431.namprd10.prod.outlook.com (2603:10b6:a03:486::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Thu, 12 Mar
 2026 17:30:02 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%4]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 17:30:00 +0000
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH] padata: Put CPU offline callback in ONLINE section to allow failure
Date: Thu, 12 Mar 2026 13:29:59 -0400
Message-ID: <20260312172959.471272-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:a03:331::14) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|SJ0PR10MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 30631c9c-c361-4059-9fac-08de805cfce2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qCEPQ4/bOmlCvc/+T8H/HkrUy+7umHb/FOo9Uye+vNud5XQP3WI2LkQo7Ml+iy/lQE5a6f3AXKHUGHsci+xbQgZ2KEK8MPyCHTgCgSLx5/XT93aljFIEDiVs9AV5naEfElTmIURVNCIz77XLg20yZsGLYAlTkMc7OvfZsC5QXIye73jxLQw9ro456TYnhdJWl4bk48zg3kalbM+kwK+3cI0wPd9Np0RnJDGagVKwYBzU4zyVmARfZ4sEwcNHUWfYZWJbtjyJLv8nTxD5YM83V0m0bGYSxISWjHxePvdm2EwVG3A7wt4sGjqzOlRYAftpKDw5jz1QFimTGr5sobXTykZNxLDA93QBUzOyRTzItQYw7xjs9OmZryZba+w6LGpDZ+wTHtFcHxofRiPqYaHF9fYhKtJiey7GFxKd3SLJ+3941NgvJex96XV3Qcckc2ffjCSNRScMGRKRKqH2/s+UTIvCkvwdjnFdcX9cLuSToe8Ub+pwtk/VJ51ID3XFZ0D4K/armHVykn1scd1/v523FIZu9bHxyAvhhNHZN8z3fN1Oufyx+vOn43ECOyHVr0woQMSI+sLDiupFCT3QB8bTQp2Te6iafeSeIT6Vw2BkahXjJ5uS/y/iM5rizahNQtxk90GhkSBtWpDQAa3qfc+kvq5+3poDYNqCTuhjDBEoKck/mzrFys5Y9NZIEqJC7PKqEt9MOaFdgqKr9g75z1lk/KwnvdJEFX57R2t4VYbGpTBOpzIXM7s2XFOCO+f6cvY9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P1GS4z7+NBDl3VA3FJOOAaBFu0Ba5cCIFrN+zHUbYqjwb7XyltP9jTLgvlVZ?=
 =?us-ascii?Q?CE/UGp5/Y9Hx6AS+0/EKiWX6Mlem7DpyGBOEB3SU15OcY6alIEyoUARA218T?=
 =?us-ascii?Q?noDkbBVLV3jtEKZUKnoSPQn6Vw3dddWwefk9h3rVC0z0LbwMAF5li3e/oisd?=
 =?us-ascii?Q?jwiRwMf7ebwi6sM05yB6VvNcrhS/DvKuWXwJ9G5rc+oCmEp2rDtrInktDcNT?=
 =?us-ascii?Q?5fIkWrPybU4zEPTHGrRoe4O/pyThW7pi8sBH3P8OjtKuUf9/4727VhLQK3Iu?=
 =?us-ascii?Q?vK040+tXrsWWMvfaCqOmR66LoNnvueRPKKfOQkf2H0zfO2l870jLsEaTfjXX?=
 =?us-ascii?Q?dk/olqDArR/qg6VU6k6cnpziIpMU0PkMn/TrHqTGieCfT9caTOm0eZZ+4iu5?=
 =?us-ascii?Q?bJLOsyMp2MMrEe+I2kXnVLlwuFvVivovhyj5Gkp6TPUdIWnjeUNIRsCDEaSH?=
 =?us-ascii?Q?JaFCPPLVIi7v3VLHvbk9ES9vONSgrEcr9XbSrAlN+q6QnEqMaaDS5iadfk6b?=
 =?us-ascii?Q?1n5ZuHMAOLLls6k8BfZljBbG8SSujWgXQN3dDDYEWj76+whTqeGuW+R2qFY3?=
 =?us-ascii?Q?R3YHGAcKenjiP1LiBcbY78crdsvdVlIgcSTw4Kbzzp7L+wWbwyggApBjDX0f?=
 =?us-ascii?Q?h+t21AaxLjo/q2jc3KlJDAo3xUgbvStyHDu11z/QrNah/PaV5x48rjfIIAlD?=
 =?us-ascii?Q?IdrHUtYnL3edBHZWwblPNkqoIiRwONe1IIBS7R1wnDbbTnFr94C3hGX/HXd1?=
 =?us-ascii?Q?3tmwAFtzi/eW+cobabsdc4fi5soCiCjfMN0FgtFSNK1s8nkw/67TqpbPAEHG?=
 =?us-ascii?Q?UGpYiFLOib9eqcoNO74/+xAXPnZQUw4Q7E9zbpOn1pJQ0kDuFFb2No0C1ee0?=
 =?us-ascii?Q?tobWSTy2fQr4bN3hX+dN7HcqSF7I2ARdGNIw8KDhd52OVIIaw0XIvvIO1MlQ?=
 =?us-ascii?Q?PSIVZKwhLpXUg37ElSrOuHYec+rHQxgmH1S7xD3w7l7nbM78GK3rbQV5TA85?=
 =?us-ascii?Q?KEgEnYLSC3T96SqJMoVhUAhHzOu4IpL+mvkJjZiWKhRbrr+qhGg1+vOYrfVo?=
 =?us-ascii?Q?PiFc9B6zHuJbq1Szj7nRZ6BQgqOErwlYzEnO2txN5G+Dc5oObXie1fnpJ1MZ?=
 =?us-ascii?Q?435+Ox8KIf80j9vCzPd839QOcxeyWD02/jTpbLU6h3SijN9Smwg34gxUs7b4?=
 =?us-ascii?Q?0XlYiB9Hwtq2oej8FpWt5yGS/BoQNTR1Lk29CzhK5HdAVZjTtv+UZPgOQjvb?=
 =?us-ascii?Q?rRFipFj8+ZktuKfJg4ItWgWdm6b9eio1CFc2IvCF/suhPw+iW+MB58xLl5Y0?=
 =?us-ascii?Q?AgrxoukZVHhAs5MRZK597/dkuqFu4oqQF6fQzVIMqAQyFLZCP6BdvERoEVVs?=
 =?us-ascii?Q?xjpD/hUnjfJyWY1syJougc59KcXqYV5ZV7wloNx1n9hjJfHnpmArDTLzlI0/?=
 =?us-ascii?Q?RUMSgBZ7MGFwNlOB5EjtmZN4PGLYildOT1swWF9ID4FjJwbCaf8MpaWo2G84?=
 =?us-ascii?Q?3qywgczhtWZ69LpRyXuf5x7afjvDJJzoMk3V9IYASVKperFLB83f5DmZBRiS?=
 =?us-ascii?Q?Q8FdszD+4/gMOSKv/KMXQTdItCjurfvr7aUPi6sZf/4xVyB9HrjSNqTn7+nm?=
 =?us-ascii?Q?TjBD5FydhmoMohEDkseMU3VHKzwlEec5ZhKjzoBGislsmroPRYalxix6aqmj?=
 =?us-ascii?Q?yb0SEgaimgrBaOVoC71PdGmoIRbt+tz6QXvk1/uT3FqMzXLJITviG7n4OYEC?=
 =?us-ascii?Q?Ns1DO0qsggEC7ibTnhbuH9oSBmln4Ps=3D?=
X-Exchange-RoutingPolicyChecked:
	ayfUK/HxI6RkekHFXWR3LB2Hl0FUqs/jTj1DmVi6mszJaCHjgDdeZzLD4h+zI/s7I7fXOWv9VYyVbZca3kfEXGbVUxy4ePqw4FlVYHKsTsmpsANY5sdvwuDFGfRRJFEzkGXo7xGCte9gxHP++wtnJqZcP9JxvA9RTE8lRrPJcrYhwa1HFVAhLo63EVjypFWElbeMTmTvS1sYK4sZCLSGwKGFNvdyEoiHR5CsRGDpSGy9/7GNOENXDvcPWq56MZk2BRmmyEzkGChkwfvLn+oWhAg0/3v1gXqsPVPOX8zFheSDopFjYkGBiKZ0TE+g440MSVofsTPFhJpyoaK3vmKHmw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rZcrYNVIJnwoaG339Ix5MFerKHdU0hOlFotH+3im0SmrzReOWgXJbuq/sU0LxcwGhAJQ2J/zgHvatda+3Z9x7UW5rJcxcFbc9Ydkt/+tT9rZN9ZHq6r+vLPMEqYt7YTrZQYlM1ajuhhSrmduoWGv9Xd7a8EMUIkqOguqYRU758s9sCfEh1yxw+1W0kwzwz98N5oHu444skqegw5g9j0OopHhXTH7e+MVGaXmmpOgnmRJo7QzNEUYC23JK4RAazrRfTi4Ou3D4rlqd8KDVmfPAkqT9Yrw+tPjHYXCmW7pivu8kFk7grQW/TZOafGamqU/YOFdAEusLP2j2iHGcqs8AWWvmU7qRthsGe2vs0NUiFZcpIVjX+wmkG1ceUNpkCz9s3FqlC9nsXAyBn7OmMLiKIyceuc0fvtzG2Uidkmt8+Uesli1clRztiPsVIFB0+i1fncvLUmVBq93ysFRJoCoxB+0Mf4evKm9W218itgpPQO8Zz/UUP/04zpzsry0yKEjqQEUCUFtGUOoNm3LY+UtsZkamWcss2okYPrng4drB517ArkqWdEpD7Q6h+z73hiYtQ3vdNEN+xNkhfZUDaLAg/rOni8Hw/nOyiumWhjvlPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30631c9c-c361-4059-9fac-08de805cfce2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 17:30:00.4034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26VLVNKhHGFxjAqSEsV81C3ONfpangewqGebEJGF1H1wbA7EZV6K8ZQgchitERJN22TnYEacky1fJkpDfpf8xo2ujvCQpUv6/K3slEPinfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6431
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603120141
X-Authority-Analysis: v=2.4 cv=c/qmgB9l c=1 sm=1 tr=0 ts=69b2f820 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=968KyxNXAAAA:8
 a=hSkVLCK3AAAA:8 a=yPCof4ZbAAAA:8 a=1tYWnPZmJMzzLI3MGvsA:9
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12272
X-Proofpoint-GUID: hePZDgij28VXSny3Z8utrPRZqgNqiB3Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE0MSBTYWx0ZWRfXya0rbdPUqe8/
 pILv29BMqevT1tbF53j/+JNiXhbZXrEThqp/5Mc9B+G8blP7eRJlr1bn2jvM3UzEMfJKN0rYn7D
 RLl9PWfDX9UJlCprzNC0HT4YG929mnx8TZg8Ht2emy9rQ1dydNQFWthaxYv45P0WIuDqw7pEnoc
 B8TLr2/9Tk3ZNfLtpWIQsugzRDOEcz8ZG1+D+ryWJ6IfwzYFguWCrmWRrDeIaJ5TkUypt6P8rBS
 xEZdNbAVyGOTNBgw/txCqB5udvZy//sRVzFVg2UqFfaexddg1qQ/NXEnyRS3QimWsxSQs70/CR6
 MnD5LtbjH0KqeJP/fMPkoGHUPwB5XZktzw/EQ1LfebIvYKcoMLTeZo4yx7W3lojbrf/kwMyYFKb
 ReesAYCfaq3kIviu6Rs9zuaQ0Cjcx91ZR4nwvI0IDPXRCvKKkBxj7vu1S3ZI3xa9JM2AnizIUMX
 KAifsBYEkY3RLdl/SW6ERplpWRZYUOVOhANnglLw=
X-Proofpoint-ORIG-GUID: hePZDgij28VXSny3Z8utrPRZqgNqiB3Z

syzbot reported the following warning:

    DEAD callback error for CPU1
    WARNING: kernel/cpu.c:1463 at _cpu_down+0x759/0x1020 kernel/cpu.c:1463, CPU#0: syz.0.1960/14614

at commit 4ae12d8bd9a8 ("Merge tag 'kbuild-fixes-7.0-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux")
which tglx traced to padata_cpu_dead() given it's the only
sub-CPUHP_TEARDOWN_CPU callback that returns an error.

Failure isn't allowed in hotplug states before CPUHP_TEARDOWN_CPU
so move the CPU offline callback to the ONLINE section where failure is
possible.

Fixes: 894c9ef9780c ("padata: validate cpumask without removed CPU during offline")
Reported-by: syzbot+123e1b70473ce213f3af@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69af0a05.050a0220.310d8.002f.GAE@google.com/
Debugged-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

Applies to cryptodev-2.6 but not mainline since it requires
    https://lore.kernel.org/all/20260226080703.3157990-1-zhouchuyi@bytedance.com/

 include/linux/cpuhotplug.h |   1 -
 include/linux/padata.h     |   8 +--
 kernel/padata.c            | 120 +++++++++++++++++++------------------
 3 files changed, 65 insertions(+), 64 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 62cd7b35a29c9..22ba327ec2278 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -92,7 +92,6 @@ enum cpuhp_state {
 	CPUHP_NET_DEV_DEAD,
 	CPUHP_IOMMU_IOVA_DEAD,
 	CPUHP_AP_ARM_CACHE_B15_RAC_DEAD,
-	CPUHP_PADATA_DEAD,
 	CPUHP_AP_DTPM_CPU_DEAD,
 	CPUHP_RANDOM_PREPARE,
 	CPUHP_WORKQUEUE_PREP,
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 765f2778e264a..b6232bea6edf5 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -149,23 +149,23 @@ struct padata_mt_job {
 /**
  * struct padata_instance - The overall control structure.
  *
- * @cpu_online_node: Linkage for CPU online callback.
- * @cpu_dead_node: Linkage for CPU offline callback.
+ * @cpuhp_node: Linkage for CPU hotplug callbacks.
  * @parallel_wq: The workqueue used for parallel work.
  * @serial_wq: The workqueue used for serial work.
  * @pslist: List of padata_shell objects attached to this instance.
  * @cpumask: User supplied cpumasks for parallel and serial works.
+ * @validate_cpumask: Internal cpumask used to validate @cpumask during hotplug.
  * @kobj: padata instance kernel object.
  * @lock: padata instance lock.
  * @flags: padata flags.
  */
 struct padata_instance {
-	struct hlist_node		cpu_online_node;
-	struct hlist_node		cpu_dead_node;
+	struct hlist_node		cpuhp_node;
 	struct workqueue_struct		*parallel_wq;
 	struct workqueue_struct		*serial_wq;
 	struct list_head		pslist;
 	struct padata_cpumask		cpumask;
+	cpumask_var_t			validate_cpumask;
 	struct kobject                   kobj;
 	struct mutex			 lock;
 	u8				 flags;
diff --git a/kernel/padata.c b/kernel/padata.c
index 9e7cfa5ed55bc..a6c5848686737 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -535,7 +535,8 @@ static void padata_init_reorder_list(struct parallel_data *pd)
 }
 
 /* Allocate and initialize the internal cpumask dependend resources. */
-static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
+static struct parallel_data *padata_alloc_pd(struct padata_shell *ps,
+					     int offlining_cpu)
 {
 	struct padata_instance *pinst = ps->pinst;
 	struct parallel_data *pd;
@@ -561,6 +562,10 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 
 	cpumask_and(pd->cpumask.pcpu, pinst->cpumask.pcpu, cpu_online_mask);
 	cpumask_and(pd->cpumask.cbcpu, pinst->cpumask.cbcpu, cpu_online_mask);
+	if (offlining_cpu >= 0) {
+		cpumask_clear_cpu(offlining_cpu, pd->cpumask.pcpu);
+		cpumask_clear_cpu(offlining_cpu, pd->cpumask.cbcpu);
+	}
 
 	padata_init_reorder_list(pd);
 	padata_init_squeues(pd);
@@ -607,11 +612,11 @@ static void __padata_stop(struct padata_instance *pinst)
 }
 
 /* Replace the internal control structure with a new one. */
-static int padata_replace_one(struct padata_shell *ps)
+static int padata_replace_one(struct padata_shell *ps, int offlining_cpu)
 {
 	struct parallel_data *pd_new;
 
-	pd_new = padata_alloc_pd(ps);
+	pd_new = padata_alloc_pd(ps, offlining_cpu);
 	if (!pd_new)
 		return -ENOMEM;
 
@@ -621,7 +626,7 @@ static int padata_replace_one(struct padata_shell *ps)
 	return 0;
 }
 
-static int padata_replace(struct padata_instance *pinst)
+static int padata_replace(struct padata_instance *pinst, int offlining_cpu)
 {
 	struct padata_shell *ps;
 	int err = 0;
@@ -629,7 +634,7 @@ static int padata_replace(struct padata_instance *pinst)
 	pinst->flags |= PADATA_RESET;
 
 	list_for_each_entry(ps, &pinst->pslist, list) {
-		err = padata_replace_one(ps);
+		err = padata_replace_one(ps, offlining_cpu);
 		if (err)
 			break;
 	}
@@ -646,9 +651,21 @@ static int padata_replace(struct padata_instance *pinst)
 
 /* If cpumask contains no active cpu, we mark the instance as invalid. */
 static bool padata_validate_cpumask(struct padata_instance *pinst,
-				    const struct cpumask *cpumask)
+				    const struct cpumask *cpumask,
+				    int offlining_cpu)
 {
-	if (!cpumask_intersects(cpumask, cpu_online_mask)) {
+	cpumask_copy(pinst->validate_cpumask, cpu_online_mask);
+
+	/*
+	 * @offlining_cpu is still in cpu_online_mask, so remove it here for
+	 * validation.  Using a sub-CPUHP_TEARDOWN_CPU hotplug state where
+	 * @offlining_cpu wouldn't be in the online mask doesn't work because
+	 * padata_cpu_offline() can fail but such a state doesn't allow failure.
+	 */
+	if (offlining_cpu >= 0)
+		cpumask_clear_cpu(offlining_cpu, pinst->validate_cpumask);
+
+	if (!cpumask_intersects(cpumask, pinst->validate_cpumask)) {
 		pinst->flags |= PADATA_INVALID;
 		return false;
 	}
@@ -664,13 +681,13 @@ static int __padata_set_cpumasks(struct padata_instance *pinst,
 	int valid;
 	int err;
 
-	valid = padata_validate_cpumask(pinst, pcpumask);
+	valid = padata_validate_cpumask(pinst, pcpumask, -1);
 	if (!valid) {
 		__padata_stop(pinst);
 		goto out_replace;
 	}
 
-	valid = padata_validate_cpumask(pinst, cbcpumask);
+	valid = padata_validate_cpumask(pinst, cbcpumask, -1);
 	if (!valid)
 		__padata_stop(pinst);
 
@@ -678,7 +695,7 @@ static int __padata_set_cpumasks(struct padata_instance *pinst,
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
-	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst);
+	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst, -1);
 
 	if (valid)
 		__padata_start(pinst);
@@ -730,26 +747,6 @@ EXPORT_SYMBOL(padata_set_cpumask);
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
-{
-	int err = padata_replace(pinst);
-
-	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
-	    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-		__padata_start(pinst);
-
-	return err;
-}
-
-static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
-{
-	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
-	    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-		__padata_stop(pinst);
-
-	return padata_replace(pinst);
-}
-
 static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
 {
 	return cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
@@ -761,27 +758,39 @@ static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, cpu_online_node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpuhp_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
 	mutex_lock(&pinst->lock);
-	ret = __padata_add_cpu(pinst, cpu);
+
+	ret = padata_replace(pinst, -1);
+
+	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu, -1) &&
+	    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu, -1))
+		__padata_start(pinst);
+
 	mutex_unlock(&pinst->lock);
 	return ret;
 }
 
-static int padata_cpu_dead(unsigned int cpu, struct hlist_node *node)
+static int padata_cpu_offline(unsigned int cpu, struct hlist_node *node)
 {
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, cpu_dead_node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpuhp_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
 	mutex_lock(&pinst->lock);
-	ret = __padata_remove_cpu(pinst, cpu);
+
+	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu, cpu) ||
+	    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu, cpu))
+		__padata_stop(pinst);
+
+	ret = padata_replace(pinst, cpu);
+
 	mutex_unlock(&pinst->lock);
 	return ret;
 }
@@ -792,15 +801,14 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD,
-					    &pinst->cpu_dead_node);
-	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->cpu_online_node);
+	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->cpuhp_node);
 #endif
 
 	WARN_ON(!list_empty(&pinst->pslist));
 
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
+	free_cpumask_var(pinst->validate_cpumask);
 	destroy_workqueue(pinst->serial_wq);
 	destroy_workqueue(pinst->parallel_wq);
 	kfree(pinst);
@@ -961,10 +969,10 @@ struct padata_instance *padata_alloc(const char *name)
 
 	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
 		goto err_free_serial_wq;
-	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
-		free_cpumask_var(pinst->cpumask.pcpu);
-		goto err_free_serial_wq;
-	}
+	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL))
+		goto err_free_p_mask;
+	if (!alloc_cpumask_var(&pinst->validate_cpumask, GFP_KERNEL))
+		goto err_free_cb_mask;
 
 	INIT_LIST_HEAD(&pinst->pslist);
 
@@ -972,7 +980,7 @@ struct padata_instance *padata_alloc(const char *name)
 	cpumask_copy(pinst->cpumask.cbcpu, cpu_possible_mask);
 
 	if (padata_setup_cpumasks(pinst))
-		goto err_free_masks;
+		goto err_free_v_mask;
 
 	__padata_start(pinst);
 
@@ -981,18 +989,19 @@ struct padata_instance *padata_alloc(const char *name)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online,
-						    &pinst->cpu_online_node);
-	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
-						    &pinst->cpu_dead_node);
+						    &pinst->cpuhp_node);
 #endif
 
 	cpus_read_unlock();
 
 	return pinst;
 
-err_free_masks:
-	free_cpumask_var(pinst->cpumask.pcpu);
+err_free_v_mask:
+	free_cpumask_var(pinst->validate_cpumask);
+err_free_cb_mask:
 	free_cpumask_var(pinst->cpumask.cbcpu);
+err_free_p_mask:
+	free_cpumask_var(pinst->cpumask.pcpu);
 err_free_serial_wq:
 	destroy_workqueue(pinst->serial_wq);
 err_put_cpus:
@@ -1035,7 +1044,7 @@ struct padata_shell *padata_alloc_shell(struct padata_instance *pinst)
 	ps->pinst = pinst;
 
 	cpus_read_lock();
-	pd = padata_alloc_pd(ps);
+	pd = padata_alloc_pd(ps, -1);
 	cpus_read_unlock();
 
 	if (!pd)
@@ -1084,31 +1093,24 @@ void __init padata_init(void)
 	int ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
-				      padata_cpu_online, NULL);
+				      padata_cpu_online, padata_cpu_offline);
 	if (ret < 0)
 		goto err;
 	hp_online = ret;
-
-	ret = cpuhp_setup_state_multi(CPUHP_PADATA_DEAD, "padata:dead",
-				      NULL, padata_cpu_dead);
-	if (ret < 0)
-		goto remove_online_state;
 #endif
 
 	possible_cpus = num_possible_cpus();
 	padata_works = kmalloc_objs(struct padata_work, possible_cpus);
 	if (!padata_works)
-		goto remove_dead_state;
+		goto remove_online_state;
 
 	for (i = 0; i < possible_cpus; ++i)
 		list_add(&padata_works[i].pw_list, &padata_free_works);
 
 	return;
 
-remove_dead_state:
-#ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_remove_multi_state(CPUHP_PADATA_DEAD);
 remove_online_state:
+#ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_remove_multi_state(hp_online);
 err:
 #endif
-- 
2.47.3

