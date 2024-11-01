Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFC218953D;
	Fri,  1 Nov 2024 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730470171; cv=fail; b=gQFd2XIk9O697ugqNek1l8NSogYfexApl7mCopmBMavo0CTLNLO6CGtkgploPLCePHZTHb3LH//+6wztcWs5MtLlhnbaTETNuAUJ5RDRYY2wHXeydZKUSi9tIfgF0obdvEH5Y8LU4TMWN9L8ldBwe4OYXT+ERYSdZrL8JnkPZXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730470171; c=relaxed/simple;
	bh=9OjBPvM+hulcm/ozl7TxJvfMj7Qu+pQvqYkoRhm/Jfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iUQChUa1s04zyEGAqbCWBDgzJmzZaNVIwVSw+ed99OiJo68NzwyWOypnVwghcOSsfNX0adR/hQNShdxeDJ0q+UVufQ4cyxlZhfUO0ad4MjDVHdWVjvLVdjGXl0m2IgUOLGoqwvMBNwqdbFEAITd+d3hItzv61mRzq5cZA3ZfGKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EL0IoOPG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DmjNWG3V; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EL0IoOPG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DmjNWG3V"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1Dfj5r004019;
	Fri, 1 Nov 2024 14:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=KhotaWuESQfByf4fwG
	A2gkVDsjPV1eHK5ii8GwuNfpA=; b=EL0IoOPGTjHeLRKhWHUAoIVwWdubqaC2rZ
	+Th8XoBh5Q68Pee3swtZKOi55k3K3DcU25T8/negXMGXhstdXY/mNsGaNxeIIbCF
	e9UNNZGVld+84MNFuew9KsFnHp9+TuFCcxN558QltBhZ/hMp6XBcKt0QR3L+PG2b
	svZpUP/osRDiR8p0FqATeZMPHjpszzs9QgW2IusZKulyksxzQTn1JRU5G5bbSDDs
	KjwI/qyialKWwC8jYy0sNkF7DEyU9bxkf1r048XmAHpWbvM/Za9SiyUt1AdoW1HE
	LGbA97MQT1vwBjy6q176mFIdjd3qqHt0/C9H7PLyWXrPBvHyWV2g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgwm813-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:09:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1CqpXh004774;
	Fri, 1 Nov 2024 14:09:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42jb2y3ys2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIePdJVECmm9zeNectHZEksiRSzqhaE+/kNrQ4oBEHMDbI9hrkksOQKMitvL5wzDt6ZOTC8voITP1ZKxhz1+vAsHwJadfmHvEmKronHod8HQz2OvQuGRXUR2inQSuUGKgiMOftHKl9nqW34L4qlH/Et+PppQvLe3a0GTW5SlTH98RFyFENw2/IsL6AIgPTZzVgBgbemv563CD8K4V94nBzsnC2S8GScca/8agf2cUWmr5IRfpLL6jR90rRULoBYAAiTHUUN1GIg18IZN181PEQl5V0GtThbvhFamk8sdSuvUa1XIwsNRzYIeYyI4uMVfG6R+CPexHSgO2z1X9tevOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhotaWuESQfByf4fwGA2gkVDsjPV1eHK5ii8GwuNfpA=;
 b=X9UyyIHXULNofqewH+znR9sdjYbyd2x4dZBLvHak42rOkjg/6qopPrTarzNdqlqbFF78sRFDxcyk02tJmkn4oD/wUucoOL9iZXSDFjb41L6g2lx0ewnYbm5MXDnmfgjFLJf7vKD4xEmbgkyvkRL1MXjvFfHMXRCrPDlkQSUmXwtSjK7GNrkuXhx0UIItoQwA75OIKsNnKtlN9/QXStpJaFvkVlGSAdIEyoUwZa/hWNbN/02j3AnYY3P7DvoyIwSd9/gm9+KhKXD3U/4zFl5MyWag3rDhuI6WMBNpnzSPlB2jCG7tor/t89zlfMskDTl6rWGUm4XPZ5UviTPgEgP6ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhotaWuESQfByf4fwGA2gkVDsjPV1eHK5ii8GwuNfpA=;
 b=DmjNWG3VE5qQjgiIfWE2x2lrknA697/VByC/4jhjOK9IbjrdzBSq2hhB3olWfNAUim+EHfNspIb3UbjC+lcCjHWuWcbj1bK/B8ZE8cBS7s8Fc4KLAfjHziL7JvKiYR2qfPTBPwik3FRSvvUwcJxzGrymTPnT6HxTTVCqfLbH7Rg=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by CH2PR10MB4262.namprd10.prod.outlook.com (2603:10b6:610:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.23; Fri, 1 Nov
 2024 14:09:13 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%3]) with mapi id 15.20.8114.020; Fri, 1 Nov 2024
 14:09:13 +0000
Date: Fri, 1 Nov 2024 10:09:08 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Zicheng Qu <quzicheng@huawei.com>
Cc: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, tanghui20@huawei.com,
        zhangqiao22@huawei.com, judy.chenhui@huawei.com
Subject: Re: [PATCH] padata: Clean up in padata_do_multithreaded()
Message-ID: <epzq5olh6fyci4ymdgoih4ioek5beojhqslc3cwgd5wiwbszto@etyzta2gh7h3>
References: <20241101091324.2372626-1-quzicheng@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101091324.2372626-1-quzicheng@huawei.com>
X-ClientProxiedBy: MN0PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:208:530::31) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|CH2PR10MB4262:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc08434-4834-4009-5e78-08dcfa7ec359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C0D1E9CpIGfmgzztfrz4C+cXwSP9qVFeIlLwz0SWhVmHNr+e7BlLnTRMlPVJ?=
 =?us-ascii?Q?4Rmub0K9S5Jk+TV6c1PqjNl2TcgkByp+2uB1JrnE/M3o2yfto8gsovdubZnE?=
 =?us-ascii?Q?nV1nLwC17P2uhsM6Q3Fut23HRIVlCq0pbnjQYsHXwviGeWd/6WTnDTbplyZ0?=
 =?us-ascii?Q?IrRNUEPwpF1kMjRCrRRLJBFj9pyfylRywqYTqXGrSDXqqiv5o2KTQrhUHntl?=
 =?us-ascii?Q?PUBobDNKdXchfDeAV8E6bm+syv52bsLIPfXsClZYJtxDS6p/q82Xj3FfoAAq?=
 =?us-ascii?Q?hmAoui/LnIeAw7xilqFNcyykW4LjpcAIXj3U4MFiNoEDp+h6vL3C/WKNLpzH?=
 =?us-ascii?Q?HByLp58iiJRQbtNiBPoMS1K2HF+/b5xyzxNZgGIRXV6EqbL3yWtAXrDPmhuL?=
 =?us-ascii?Q?HL4TH8AprYk034qRUo3dFZ+WJIdoqYAWcj7LPSXk8poDjh+w6/uBufz7Kgcl?=
 =?us-ascii?Q?n3eGF4MKTf/6/F0fHVVkxZYmdUarU1iDv6VGhA3Re3pBUvpNKwoQB/sJi+3G?=
 =?us-ascii?Q?G0T/QbmXkwcdGgNe1vNfHrn6G6nkggHEIYEBzl5WzXss2fxng6dF9e09gZ1N?=
 =?us-ascii?Q?m/+61YYfg/pZvJO1w0jt2M59kTMZCnek1Uh1nPxh7B/gbPwlg58wnCJBRmkW?=
 =?us-ascii?Q?0vVHlwjw78MfTfBMperSuP0XAZgzGxoA7pIL9WCm15q3Px5RdCXfY47165/6?=
 =?us-ascii?Q?p/VLCIP5FmZ5MCEwpPElmEa3AVckrvSUxdROMlylmmGMJVIhUGT7Joxs/Mdf?=
 =?us-ascii?Q?zoY1+wyu6Yen6mhDHqft5S5HF45n+AwE/6D91j5PuxusdxNS1KviZNyl7gHn?=
 =?us-ascii?Q?AunIaeKbzYxauUffCFhEqn9EMscU4d0lEAbxvRH6LF0QDaGt+DVC7nVLfupS?=
 =?us-ascii?Q?5Gg3c+fBBOgin79rCLRCDKOkoF+k2rv+XJxVWxB5fULG1ThKrrDCCdyrBtec?=
 =?us-ascii?Q?aOoQfkUZhOFcPNGHyBCuiJXoamjsgYk2xxxOb+6SA85Q7HCP4rV55zlKsRKw?=
 =?us-ascii?Q?wxa0v83cLjpgExd14KAxuz0l2kf6srZrQPI42qhuKtcF53l8ODxsilFBjHVe?=
 =?us-ascii?Q?kMpXC69M0Qz7oCpiwugQ6U/CjWyEA8XpJtuwfkKv23dTQcAUiTVquhcoKiZ/?=
 =?us-ascii?Q?aLiPU5dHAGN02ex/YzO317KSlDbXfSCiYY48T6+siCrgbUTBSWRM6QIuvS2a?=
 =?us-ascii?Q?9tI4AFYzBvVhhBR/1n+W5PJ1h4ghLArPrepRN3eZdTB/5znM3b4c64ab2AnJ?=
 =?us-ascii?Q?mRvfwYxIxIjzo/4VXZabkzCxGJOyFjloH+69FCxeDmDbsPusyTPvB9mqwH2u?=
 =?us-ascii?Q?ShCLpjRvmFSZvh48UEm2CXIK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5ipilDxVHxtSH8X8WeOFBDp7g4EdJr80sWaB+gaRdpQqjjoedJdJ1H0wXatw?=
 =?us-ascii?Q?et4Ff//w3VmVgQ9pT+u/V9hgy1gDI1P7OLLnmzsI1jPH7+PZE5rCzScW67k8?=
 =?us-ascii?Q?eT3Tuy3zfjMPrbhVKeyaSUroqucovdc2jaSPJ/8tmL9DT8hgctaj0ZySMgAx?=
 =?us-ascii?Q?8HZQ1RDTETp1nuNII6qNDEXlpU5xYyG8Z02mil+km8i8ddfL/kG1P5LJZCGP?=
 =?us-ascii?Q?P1W2NJ+vbQTjZvuuTaWJdkdbPlDE5C26xg0wmk4emdA62mOtwKIkH4ZEL31P?=
 =?us-ascii?Q?IDqNu5Fnk+4CKyD2NHvOMYU46jfMsq6VxijB0nOO9Luoo1zvrxTMQA1JbvvD?=
 =?us-ascii?Q?5eOuhnxhnGBcMBMCQmwzsxqIKDX0sBuw78DojPpTK36Q4G1GlTGLI72DvQXE?=
 =?us-ascii?Q?fJYqgvDpPezO+ikncKOLeo0m3lmsHeEXKUdVvoJH3NJ6Y53z0bEesgr5Xtwz?=
 =?us-ascii?Q?mSVRRwBO8njh3bg1lnfuWbwTdU5KvzoMytg8GQUtPU45SgowS27bB7fcsfd4?=
 =?us-ascii?Q?YPSNoHXzRs4DrGQeBhjcAi3g7o/4bi4Y2D3upFkqcvmEzhFna26ko3chd5AA?=
 =?us-ascii?Q?rsLwVqvVFQiLWHNgmp9q90MjyX9i369tcp46LdXM78IyfEEHS07Skehdpw1Z?=
 =?us-ascii?Q?olA6VdMc3jjO21q6bz6Wk0UqLJOTYj6QZNwiGkFv5iVJfI/5bfaeUnvrEIWH?=
 =?us-ascii?Q?pD+i2Ewvq0pYdtbb5mHZztHxsuBVVjbNYQYzTFav1URnHgKM/9wMSxpHPKeP?=
 =?us-ascii?Q?geVe6OuZQKnsyzMKz5SI+m48iwEeCOqtNlmu9SUXA+GjxtPrqc4dcMGY3hQZ?=
 =?us-ascii?Q?KNaWvoRlRVhg5+kMUTIVAg66/9nbABVHv4i8OfybxLJxBN6cd8ec4sI3uWZm?=
 =?us-ascii?Q?bYMfg5Y6c/lZB6NsNDdrEckF2jBjbxx1YKXjjGTOVvHEgHDtqIRW7zcXVFA3?=
 =?us-ascii?Q?apgLp+9KXYPoGiSaYfk97yPjuTen/6y3kwlmWg6wJE8weOjUwwsK6vfJjQxR?=
 =?us-ascii?Q?Ky/D9KGeYSRC2scJw44k0K48T/DiVAtZDr/Kb0Bb74f+cMfJOuTRl0+hCae7?=
 =?us-ascii?Q?kAKKYx3hzOQp0BpZrox2S+nvuj/uXEdOmV7TuQ2IHHKCpCNZnkIl97i8kXuK?=
 =?us-ascii?Q?ksZGDrM2g8UoILM1Ba5vDIAPY9wax+B6s/pVseW0DSdkG+El0VlU8hJJVhFp?=
 =?us-ascii?Q?LMu2k0QJATrW4Vx0NVBTGb7XZbFRjC7ABHt3EpZ1E/yJW8KUYwzlghjlz42J?=
 =?us-ascii?Q?SDnsRdmNGCn6sCpRUqClhsELtGDxqE0PwdtyuhdwusiQx6MvZxEZ5mHEG14f?=
 =?us-ascii?Q?Osg4QWpsaT0Zx13uXAfwqrNE+aNMZs2cUB1FufqMVRc1OunwQy3gXFtUTaGA?=
 =?us-ascii?Q?YZUMgxd6FYsVa6+TiWnFjd6hFQHahMw5Q7ljJ92wAyJhRC89zBnlR6MsM+Fb?=
 =?us-ascii?Q?iA5YlhxrOnKdlqcODAt782JEDC3KeEhlu8X2CndZ2ITr/4IcG/mMY0VMtO9R?=
 =?us-ascii?Q?Xy5+iYLKilLMLgaoLeSHx1/Ca/1xTnM5UVhI9uSKvS31Ng+eeLlwJx7kcfNf?=
 =?us-ascii?Q?YWgeoTQXVzQf4aimBxYsaxZRRApD8C/otwstpbZSw0mYagd5x3j0K6RUmKFi?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	190LdKvo60KGTNmlbwskEUpxPsSxWnRQFu6XRyvuhU7YWS2ZPBqlIPbH19w1v6z7USDENjyf1hyDGBmHGysniAsO61e0TmMnpvO/qU8fxrfR4yjIkCzEmz9KgIZvv8AZ5uWtT0h82xp8kd1hSJcYvS4eGwttnG8D7fWioqbSriCrIETXduQzkI7Os68rWpa92U5BVaMVWydMDiEqhDupYxmu1Z8lBef+RXS1EQQvEfuh9YyXuwlQcSJyM0lCOo5DeWOAf1x2hysw3UkgaOlfy2tFSw68EplLlJSqYu/N/ROzx0Jqt6Tc/y+XHR+BHJ4MAJFKWClUfqG3Rz5KZX4pQfeBHIbTmP/nBe5ItA0c+W59Mk594wxPGEGLlgeOzoaCW0hsN648wWD2rKBiAdPOfnSA7fzuucrnIq5QldR8gq826nTnCjWrgy5ksrYmBQeDFYEjEuz+/Vccs5W619Hu/veRSU7mgIwlDfp6L94Q5nHGF6bIb+JA2m+E0TWCxutG/a92oZswrkU/+3gMkB1AICjeMo3WG/pGnFY0EHMh0wZIbqjmcyWK69exiJR19RHlziQHFtrxV1If09Gf+zAkCFnZEejZWZqbwhjPb9tv9ro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc08434-4834-4009-5e78-08dcfa7ec359
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 14:09:13.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2Nfs/nTPknMoGgIOAX+sh77w+aBln+336k6gIvnMTPvv39JLD6yH6xRIQitlH+hQU/KZCAEANMp8uHSjrvH1OKStzsoIBicGyO5NGacEk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4262
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-01_08,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411010102
X-Proofpoint-ORIG-GUID: 7zCiBC8oUuPUWrcKWLmBuZdha9MJJ7pf
X-Proofpoint-GUID: 7zCiBC8oUuPUWrcKWLmBuZdha9MJJ7pf

On Fri, Nov 01, 2024 at 09:13:24AM +0000, Zicheng Qu wrote:
> In commit 24cc57d8faaa ("padata: Honor the caller's alignment in case of
> chunk_size 0"), the line 'ps.chunk_size = max(ps.chunk_size, 1ul)' was
> added, making 'ps.chunk_size = 1U' redundant and never executed.

...yep!  That's true.

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
