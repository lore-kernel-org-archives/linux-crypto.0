Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3487481736;
	Mon,  3 Jun 2024 23:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717458548; cv=fail; b=Yt6p2z2Ifg/9oLHec0RZBEiGpWMrA5CGTM0nzMaqcNqLvB2itpaWOjapBXWbTv1Xi3echICaz5wumjuEWUz+ueSQ2naR3eSkAaEU6zOzF4GBkz02U2h9vSnJF23oSk+LWYdnkzdF9Gk8wVPekBKr/JENDqx2hG24Aj1cIu9oJtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717458548; c=relaxed/simple;
	bh=qoH06AfPaRH1/1LXaEVfTmzAjUIBuZSg/J0fcwtZvPM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oIGCkqE8P+odqmjw10SpUxpSbGkVFaOoA05HBSlkfUK5sL26xE7LOhk/iM22+ObnovGnZ0cmP235six1EpLz7aYb0ODGYB+XxaH32/8U8CSdys6M1oTkjbdvPUbMJA8tLHqV9blvwAMUZWsTeOO5W2Pzdo5+UbNjrSHp4FpVId4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453KqZVI022461;
	Mon, 3 Jun 2024 23:49:00 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DyX6+NigSKWFqBgekWuIA2zXQe699xpLHhyxP7Z?=
 =?UTF-8?Q?EONKM=3D;_b=3DOU/GYhDC2taIxV6mBk2FZUWMXf9yHJEscRAh+DcJNwSbbihCP?=
 =?UTF-8?Q?BnCASd/xUpGgj/ZpnID_Y4hWWmtLwPOv1ushHUkIfMZIWNPQaM90hYG+EsbbNNK?=
 =?UTF-8?Q?B0rNnKi1bfw2X898/Vop4yIs+_48tXSMBKOujkwrErT7CR6zD+0O/ZoTkSdEcbe?=
 =?UTF-8?Q?eMpum2y3+dhBiINKJdNj8npA9XkEqv7_66CNVFGBjVWs+i/YBJuer89EuPMkYBj?=
 =?UTF-8?Q?keuma+ndbFfCY7btNuzlBhDsRMePgpb4THgeg_/OOLzRxhfeR/s93P7hYOIuRBW?=
 =?UTF-8?Q?yJcb/+FxgqaeD0DdDz0z4PNoIn7+klPGOO02IJ5OFRx_oA=3D=3D_?=
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv58burt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 23:49:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 453M6Rb8020592;
	Mon, 3 Jun 2024 23:48:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrj17684-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 23:48:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qzfe0SDXG9SlDypOg+T2iWyxocWmUMk5QSaShGD/d+9dJdNX2Lxz9IJaPLbf8NLhbGSXr6yzgCD1wnlGUCKGjM4V6arYG/nHUbTYa6p1hFRw8er6gHa8BQM7YO9wmfXE34OiVbH5t2ukhJ5fc//S2FdPOSBWfZXpBrGcBM2G4mzrlqbLgsetdaXZ148OGzTWMElsafcOePA+s3rGXespj0ujhApHj+3Ec+wFXlcFFr62BmEWORqfwxpK+kqDdBCq64yiPfE8qJdZHPh5elSuk+fpgZMfHZeObJIvZwQ334x1dssbxGjs+VH3U4yW/4mnT7pG7gS6GfpgZibyzysInA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yX6+NigSKWFqBgekWuIA2zXQe699xpLHhyxP7ZEONKM=;
 b=DWq2YABeFXOWixeo/sdS3acqwUZTi2IpKf3DLDiXjcfzLHwyGTUBLAPAao7qN6o95I0jxk2Gso0EpTDM5kb4xalYOrKMAuhra21ZrkIeR9SndHYFoSV/bEMxyxRrpuQ5srI63lTRk2bBJuXSLHDThiQxMPe+/IdMtxnPfaTYhw+8KIxVVuOOxJPLn5ie8ERQwCXOx5tMUzKoF1o2Ryml3/wCwWM1YzI3KnGsoZaP7rLLIoWXIebWc8creDao2oe43GBi7BYaZcIRXuz51v5L+IXDU7UTkUAJnSgE2u/nDmeLJvfJWw7IwieGyztzkiJWQyMiJ8FdfcIAWSEjg00OOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yX6+NigSKWFqBgekWuIA2zXQe699xpLHhyxP7ZEONKM=;
 b=N8SCoBb/IDH2jJ/6rG+lauomS+uP2jgjqSIcBwWrNHvdZNlPTyheKy5kqn4zKEWDAC+0ztdf7guR1a6jF0H/El0WRWC1YNDb48qsi2dTGmwvj/hSw5V41gZkqdEIi2sV8O8H/3Yvpt4Wm+GqGCB+z2T14ALy+M/v4VMM/jKW8Xg=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CO1PR10MB4404.namprd10.prod.outlook.com (2603:10b6:303:90::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Mon, 3 Jun
 2024 23:48:56 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7633.018; Mon, 3 Jun 2024
 23:48:56 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Kim Phillips <kim.phillips@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>
CC: Mario Limonciello <mario.limonciello@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Fix null pointer dereference in
 __sev_snp_shutdown_locked
Thread-Topic: [PATCH] crypto: ccp - Fix null pointer dereference in
 __sev_snp_shutdown_locked
Thread-Index: AQHatciECq3jCs/qE0un7SwS5Rr94rG2xhUA
Date: Mon, 3 Jun 2024 23:48:56 +0000
Message-ID: <fa41f7b4-a7b8-4515-b267-703fa34162b6@oracle.com>
References: <20240603151212.18342-1-kim.phillips@amd.com>
In-Reply-To: <20240603151212.18342-1-kim.phillips@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7633.017)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|CO1PR10MB4404:EE_
x-ms-office365-filtering-correlation-id: 85b952db-ba65-4bfb-402b-08dc8427bbb5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|376005|366007|1800799015|7416005|38070700009;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?r/CKcMZGCzE3K+tP/W+3qAxsmBbImgSrCMhgUkkxdjQkJfAAXpxR7HA6LG?=
 =?iso-8859-1?Q?KHR/ZIaM8mgpMGpFC1dBMx1JY4plx0bk8BKfMEa1iFGTU0WH4giGv32D/T?=
 =?iso-8859-1?Q?DC0C2bFlcIzIIxZ7SpET3SOeaRj9r2Dmv6g5XGJG6Tl+XOBo1aghbWVAUh?=
 =?iso-8859-1?Q?qeOMderurcKx/prn69boI0D9SZD4OMlzSK3P9gCynbhz+A6T3Y9CXGH96m?=
 =?iso-8859-1?Q?eWv4rxkbraFHUqKCSJiZwjeGT54EDJz5tGobXPfKIRTuUp19vVyPL/HiOG?=
 =?iso-8859-1?Q?/56r2knoxTZyx2/PBoOxVHwAqZTmacQ/46LbA/52ZRhG2HdVL8o9kgcx54?=
 =?iso-8859-1?Q?siP7N8LRvGa2jSxD0oJciFXbMAFYxdBGrIl+7K7gZZWdGxP/HHwLniRE4N?=
 =?iso-8859-1?Q?bJtbliMBCqiYCtY7Qn1NtDj1pyDDzESzvdh/UzM60Y08yumerFkNX2BZ+k?=
 =?iso-8859-1?Q?ZKwyTcm1QjsNaGVEkvnrd4KthhE1KjAjQ3GJYmZNBSqm7Ujo4WFkoHAR9u?=
 =?iso-8859-1?Q?k+3h90BhZb8fibKVMf2fhToEVBYqgV6cGn+4VSlyyYYhV4FwtRCQCqizCa?=
 =?iso-8859-1?Q?s5nxd70v/rnmHc8JZ9TaAWwI0d0SHF3r3QsYKmpC518S6xBEpkh7HpOIBu?=
 =?iso-8859-1?Q?MyBYmYp6JOU2990z9ejkNVDKgUYFGBzMyhkqND3ZGJti/JGq6NXNktQezf?=
 =?iso-8859-1?Q?9M5ZjOn/WR0BIj8O2Jj8pOZncFMuUNzBMDJX4z0OLwj9KA/F8GNeYUMpTB?=
 =?iso-8859-1?Q?0hKjhmJawVV5i1x4Psk9iVP7TY+KmuLW549HI2+5YU25sb9s/AIzsirVDb?=
 =?iso-8859-1?Q?GzJDq1MJg5PRQL1PgLlcam8XOLl//WNxJrm69yKj3xQdqeAlsv8x4WkQmt?=
 =?iso-8859-1?Q?RaenW0SC1BbyRqNbKi3QwgoERDPr1UMFdpoBqGJReq0uAA+GMN0MPNRBiQ?=
 =?iso-8859-1?Q?Fb6m6y3Mz5yn7yQNfLhm+sIWe8TjvSy0fYbru9iknopOdYVC/GLS8leH4g?=
 =?iso-8859-1?Q?DJ7xzEvoaMj2rKirUzuEyCWBuBebW4Yfe4cFN3Eo3EaNckUhQk6QiQmPyR?=
 =?iso-8859-1?Q?xgTZSf+AiFbYNZ/MeMjzV9zWFl5YghwGXy0Ub80ZmYHvzMctbKDFkujwi/?=
 =?iso-8859-1?Q?Qq7QGy9UisH0t0tJfG8M8VTzcqxnXiHY4lAs/QQ9L/b2MZeBJEopx++3cC?=
 =?iso-8859-1?Q?7FTq3f/nhT1zP+AY9yrEI6td05QMZQzpEqGok1iWFZwLRRzWuvSUiHT1PC?=
 =?iso-8859-1?Q?/2/1TIhLENmvmpYabHs+1wKIfWkXM4M9w0Fxlf4NSmLxIV9Y8vgKQI5qv8?=
 =?iso-8859-1?Q?JAtPQG8P814Bh73d92DM5rO/ARf4iuRKuAcVtIC5GLcGC1iiiL2TWepY7J?=
 =?iso-8859-1?Q?+EbbioM8cRSfdps5hnYFUxHIqtjhTz1w=3D=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?qjxrCfEw/XkkA/x5+Bp78od73ckX2ytMUor8zjX4bJGlgLdOApidEq5hkQ?=
 =?iso-8859-1?Q?V7KA46EMgL5q6cjAGUstnBGjWv9BnpKpgUXkqGY3lMKUnbNWfaiuMeuaw2?=
 =?iso-8859-1?Q?2ZoHEhk/edd8bdlVhu5dlj607FBy18qQK0jy7WkmzFNoaIhdIkP4HsCWQJ?=
 =?iso-8859-1?Q?dsRgfOh8R7cpYthTfEo5w2Mj9hPWpGG94DKpaIg7EVGrkZz/j74PESzt5R?=
 =?iso-8859-1?Q?0tS3Ao+8m+aVh1oqoeZk7+Zi75mSaSgI/J45lVsfMOgqWRv+6fZJICoMHI?=
 =?iso-8859-1?Q?ve12q4YNxr4tTjXKOyw5xiZOF+clnw8ID1R89+rCCfA4a/0kzoi2dFWdgU?=
 =?iso-8859-1?Q?+yp87edVxMyiPchWkcx7OJ597UO5tI6hfQhXZZ06xTm+p3Dtnfr35+1HWN?=
 =?iso-8859-1?Q?3FfTTEwcOujwPQ87gfID1hT7/oE6Oju4KBdnWBSlEwx+nRbVUFD1JakFqn?=
 =?iso-8859-1?Q?BBtzLDXKi+zGkOTLuOPcPSPvH1StuX/e/3/dGlQWvG/5uXExdx4MlnNxbI?=
 =?iso-8859-1?Q?NEBlhb4/iAt8jDga1MW7Ylm+OKzC0KNzMDKx97oLIWqy8TdPbXsTxSWiDG?=
 =?iso-8859-1?Q?dXx/YNfts7pQ0sv7GOB4fZZ4/fGq18mkFASKFlTVNGEfrOg298LLUXn8dj?=
 =?iso-8859-1?Q?+PKxdejCBDqKuGUeiOYPvKG6E3tQHD5YX9rCs2krHom/MGGTj0tjYghS0W?=
 =?iso-8859-1?Q?nDWDetzwHqeYCXja9Rd7RT4NQ1WVVe23+yTSW+gXQhn6trIgP0RCcTPnwo?=
 =?iso-8859-1?Q?aBRQOJ8kiQr0+bJvE7eof+XHqyxJsStJyRVF3udy2ChoBlFQqEAb2KC0ou?=
 =?iso-8859-1?Q?uFVNLB06ZZA/VmrRK8eBlWESrOPtEY9xaXxeqGJWGLIir5alNvX9yrlAHU?=
 =?iso-8859-1?Q?5zjVEXWL7cZisthTu253Fs8ZVE9qYy8cJRIVCfGIL6WjPskAsMM2UO7n4a?=
 =?iso-8859-1?Q?z6Y0chlUTWX8yLjCndiB7rajr6ibjKfu5CnFjKZ55AdS6jYgetgOCsq896?=
 =?iso-8859-1?Q?i+F6ifUFGkHfIRFRdz63D3marVuyJVD+dbYz4F8ZfYhgUy14HYLKuoUmJB?=
 =?iso-8859-1?Q?QhrXPExPOyQMgEF0xtaHuHsLPPmGSqCJshNn8iJGQoIJ9NSmNdotXCiUKz?=
 =?iso-8859-1?Q?4MWgvzVQ657tjz4KprNLpoM5qkC5QzoCWvlbi+uBHuSU7mws0SICPm+fWc?=
 =?iso-8859-1?Q?n+lXbFtN+282HpiusVx6vQRNCCXsM92OdyUJ3zkWqqz0gf1XA/QQmm9fBI?=
 =?iso-8859-1?Q?cwvVnkqUuZ6Ck2id3iJ8kgSTLfijOrjPIHBqHu6JvPqnuJS9BEPF8UAuYG?=
 =?iso-8859-1?Q?P2DK0YYGrzwvZRvYSTEYGKKIFW1Gen9LxFWCwd9BESbKHvFILP7+327uaI?=
 =?iso-8859-1?Q?Wn/d1RIQSWrzEBUauN1+duc6VpwlyR3umlzi2qZMDPKY39SGdXj4+LoHiI?=
 =?iso-8859-1?Q?kJ/azb0a+Sh5QdjWBd872wU8iFIbnKJnUAO7Fw3llVbdRKQI/lQnyxdjaK?=
 =?iso-8859-1?Q?EMvT3BUFXLXFqKZlzOyqjG3UtAkvdYstx8Ynk4KxuweLfW0A8xoc0lpDSU?=
 =?iso-8859-1?Q?oXZ/FgGvUY2+xjKbLxkYcablZYVsPXKIsZkmjbMtgCkKPw78lJBQtgVHgh?=
 =?iso-8859-1?Q?HFQoH71vyG6x3c2lG51K80PnZ+7KQFohyu3hKGXA+M7vn+twCKbUvueQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <AE02F40227C4CC41BDDC4F8CEC742D49@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ij2nxyHW6JhB1znl1bfJK0Zc7Ke2OLUGbsqzZXZgLF/TtGjm9g+BAHLZGvNc4ZfNGmbjHwcNPjoG4/1mkbOC7cI+eiD++XgC4OeoPGORvpoaV2LyJRZ754IM8gWBhRNXv26JyuevTLD4zkWexgFuvB0gSv5ru52aFnoiKoC95PtbOH9D/0p/qbpBiGSmcXxz9B6U9HVhOiGfhTX9sDMRbeTupK2bF76FtR5vBykTXNj6iQi+mIUnl0BYz8r6grOXQUdGzm8s+LYCEvoSZIhOiynSbxKMqbNOOIHegy2nI/cizjOUz+iPbTKPOCHKe0tT7t3k9Tg4hFj69ITwgsK5mN4sJX0iFLtMIitjtfU3D8pDgBDYeGhraPkDuSuIjjeLTpNBAHlMwr14RhdE3J122lMu2q1WDdc5EJELZYuGMrPrpCrAFgSR3cPz9xrmUVXPN9uCJWDz5aDzBSIGx84XZj43xMe9zfvYt32dTzbsmsXtmzzBc3ofzn/9Fb4D9uE7XhfJh/Na3v+7B6Px4GxjY6lL0KyV81zzzF/s61Hl2bvpZ2rndTi8VkPfHcCEDVyrZlyM6U5SCrKwPUGeYP3r3/aRGzXtQpUqiS2kyTPVkoI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b952db-ba65-4bfb-402b-08dc8427bbb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2024 23:48:56.7047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wae0i/Nx9sHIF4y44Ci1awal7b4DQT+lAscit9G5xcKID4P+om5q91qKK5gWlzzAJiInNucZImDkknfNYE4+hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4404
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_17,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406030193
X-Proofpoint-ORIG-GUID: hQAuVche_efAEap5c9ZrmDLWE04srcL_
X-Proofpoint-GUID: hQAuVche_efAEap5c9ZrmDLWE04srcL_

On 03/06/2024 16:12, Kim Phillips wrote:=0A=
> Another DEBUG_TEST_DRIVER_REMOVE induced splat found, this time=0A=
> in __sev_snp_shutdown_locked().=0A=
> =0A=
> [   38.625613] ccp 0000:55:00.5: enabling device (0000 -> 0002)=0A=
> [   38.633022] ccp 0000:55:00.5: sev enabled=0A=
> [   38.637498] ccp 0000:55:00.5: psp enabled=0A=
> [   38.642011] BUG: kernel NULL pointer dereference, address: 00000000000=
000f0=0A=
> [   38.645963] #PF: supervisor read access in kernel mode=0A=
> [   38.645963] #PF: error_code(0x0000) - not-present page=0A=
> [   38.645963] PGD 0 P4D 0=0A=
> [   38.645963] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI=0A=
> [   38.645963] CPU: 262 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc1+ #29=
=0A=
> [   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150=0A=
> [   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 8=
9 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <=
4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83=0A=
> [   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286=0A=
> [   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 000000000=
0000000=0A=
> [   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4=
014b808=0A=
> [   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000=
003d9c0=0A=
> [   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d=
40590c8=0A=
> [   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 000000000=
0000000=0A=
> [   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlG=
S:0000000000000000=0A=
> [   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
> [   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 000000000=
0770ef0=0A=
> [   38.645963] PKRU: 55555554=0A=
> [   38.645963] Call Trace:=0A=
> [   38.645963]  <TASK>=0A=
> [   38.645963]  ? __die_body+0x6f/0xb0=0A=
> [   38.645963]  ? __die+0xcc/0xf0=0A=
> [   38.645963]  ? page_fault_oops+0x330/0x3a0=0A=
> [   38.645963]  ? save_trace+0x2a5/0x360=0A=
> [   38.645963]  ? do_user_addr_fault+0x583/0x630=0A=
> [   38.645963]  ? exc_page_fault+0x81/0x120=0A=
> [   38.645963]  ? asm_exc_page_fault+0x2b/0x30=0A=
> [   38.645963]  ? __sev_snp_shutdown_locked+0x2e/0x150=0A=
> [   38.645963]  __sev_firmware_shutdown+0x349/0x5b0=0A=
> [   38.645963]  ? pm_runtime_barrier+0x66/0xe0=0A=
> [   38.645963]  sev_dev_destroy+0x34/0xb0=0A=
> [   38.645963]  psp_dev_destroy+0x27/0x60=0A=
> [   38.645963]  sp_destroy+0x39/0x90=0A=
> [   38.645963]  sp_pci_remove+0x22/0x60=0A=
> [   38.645963]  pci_device_remove+0x4e/0x110=0A=
> [   38.645963]  really_probe+0x271/0x4e0=0A=
> [   38.645963]  __driver_probe_device+0x8f/0x160=0A=
> [   38.645963]  driver_probe_device+0x24/0x120=0A=
> [   38.645963]  __driver_attach+0xc7/0x280=0A=
> [   38.645963]  ? driver_attach+0x30/0x30=0A=
> [   38.645963]  bus_for_each_dev+0x10d/0x130=0A=
> [   38.645963]  driver_attach+0x22/0x30=0A=
> [   38.645963]  bus_add_driver+0x171/0x2b0=0A=
> [   38.645963]  ? unaccepted_memory_init_kdump+0x20/0x20=0A=
> [   38.645963]  driver_register+0x67/0x100=0A=
> [   38.645963]  __pci_register_driver+0x83/0x90=0A=
> [   38.645963]  sp_pci_init+0x22/0x30=0A=
> [   38.645963]  sp_mod_init+0x13/0x30=0A=
> [   38.645963]  do_one_initcall+0xb8/0x290=0A=
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10=0A=
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100=0A=
> [   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0=0A=
> [   38.645963]  ? local_clock+0x1c/0x60=0A=
> [   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0=0A=
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10=0A=
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100=0A=
> [   38.645963]  ? __lock_acquire+0xd90/0xe30=0A=
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10=0A=
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100=0A=
> [   38.645963]  ? __create_object+0x66/0x100=0A=
> [   38.645963]  ? local_clock+0x1c/0x60=0A=
> [   38.645963]  ? __create_object+0x66/0x100=0A=
> [   38.645963]  ? parameq+0x1b/0x90=0A=
> [   38.645963]  ? parse_one+0x6d/0x1d0=0A=
> [   38.645963]  ? parse_args+0xd7/0x1f0=0A=
> [   38.645963]  ? do_initcall_level+0x180/0x180=0A=
> [   38.645963]  do_initcall_level+0xb0/0x180=0A=
> [   38.645963]  do_initcalls+0x60/0xa0=0A=
> [   38.645963]  ? kernel_init+0x1f/0x1d0=0A=
> [   38.645963]  do_basic_setup+0x41/0x50=0A=
> [   38.645963]  kernel_init_freeable+0x1ac/0x230=0A=
> [   38.645963]  ? rest_init+0x1f0/0x1f0=0A=
> [   38.645963]  kernel_init+0x1f/0x1d0=0A=
> [   38.645963]  ? rest_init+0x1f0/0x1f0=0A=
> [   38.645963]  ret_from_fork+0x3d/0x50=0A=
> [   38.645963]  ? rest_init+0x1f0/0x1f0=0A=
> [   38.645963]  ret_from_fork_asm+0x11/0x20=0A=
> [   38.645963]  </TASK>=0A=
> [   38.645963] Modules linked in:=0A=
> [   38.645963] CR2: 00000000000000f0=0A=
> [   38.645963] ---[ end trace 0000000000000000 ]---=0A=
> [   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150=0A=
> [   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 8=
9 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <=
4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83=0A=
> [   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286=0A=
> [   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 000000000=
0000000=0A=
> [   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4=
014b808=0A=
> [   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000=
003d9c0=0A=
> [   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d=
40590c8=0A=
> [   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 000000000=
0000000=0A=
> [   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlG=
S:0000000000000000=0A=
> [   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
> [   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 000000000=
0770ef0=0A=
> [   38.645963] PKRU: 55555554=0A=
> [   38.645963] Kernel panic - not syncing: Fatal exception=0A=
> [   38.645963] Kernel Offset: 0x1fc00000 from 0xffffffff81000000 (relocat=
ion range: 0xffffffff80000000-0xffffffffbfffffff)=0A=
> =0A=
> Fixes: ccb88e9549e7 ("crypto: ccp - Fix null pointer dereference in __sev=
_platform_shutdown_locked")=0A=
> Cc: stable@vger.kernel.org=0A=
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>=0A=
=0A=
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>=0A=
=0A=
=0A=
> ---=0A=
>   drivers/crypto/ccp/sev-dev.c | 8 +++++++-=0A=
>   1 file changed, 7 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c=
=0A=
> index 2102377f727b..1912bee22dd4 100644=0A=
> --- a/drivers/crypto/ccp/sev-dev.c=0A=
> +++ b/drivers/crypto/ccp/sev-dev.c=0A=
> @@ -1642,10 +1642,16 @@ static int sev_update_firmware(struct device *dev=
)=0A=
>   =0A=
>   static int __sev_snp_shutdown_locked(int *error, bool panic)=0A=
>   {=0A=
> -	struct sev_device *sev =3D psp_master->sev_data;=0A=
> +	struct psp_device *psp =3D psp_master;=0A=
> +	struct sev_device *sev;=0A=
>   	struct sev_data_snp_shutdown_ex data;=0A=
>   	int ret;=0A=
>   =0A=
> +	if (!psp || !psp->sev_data)=0A=
> +		return 0;=0A=
> +=0A=
> +	sev =3D psp->sev_data;=0A=
> +=0A=
>   	if (!sev->snp_initialized)=0A=
>   		return 0;=0A=
>   =0A=
=0A=
