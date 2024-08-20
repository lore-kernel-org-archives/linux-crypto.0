Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE6219478;
	Tue, 20 Aug 2024 21:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724189392; cv=fail; b=E0GG0spDlXM8CFmooDiMGddewDFJ235d5a3OCEvjMwnJ9vwkpjqbw5awoQhgwYaWHxfUiF5bucTu12ikaisNicRSc+epGUEndOnrqmYAT6Mx4o8A7MrlrHq2ne9Zl1e7sPl+oLlY8KFASZgBYvIl9sfLdz4STNtIBh4XpKKRxMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724189392; c=relaxed/simple;
	bh=GGVA3ZYOd6w5kyZGIsfK0hSbLnuMotiB2sPNaRIkktk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hi9/aO0u8r8UdcJ35dmU46p4oTBq7a8Htm2mZnTp9k01Osny9d7lI146OeapGG9ph7SdeedTcD10coSqTcigD3lodf2GxvFMSeSV45sJj6R2z0WoBeDZV7BHnmj/r31POC8pSAbwOLXBzDnpHxqmhewWIgO6EI3TQTEnDJWK8Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UKM0N0Sv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qeiZE/3Q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UKM0N0Sv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qeiZE/3Q"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47KLC6Gp028076;
	Tue, 20 Aug 2024 21:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=VsGKC6SiiqYfpXz
	XZgLAUrfH6hcAWBOWuIkGJ6lu2Dc=; b=UKM0N0SvSCx8Uff4XKManBSiQ5eBnnu
	n+iXObjK0iG306ammoZNbZJ0laOzIKCN0WMbojiGHpRIfmdjyDLOBS/2MnwqZs3i
	pO/u3D4Vvbf4BqRHfom61WJmWsKOgbgOCx1FIzW9G1adMNF72HdYflqu9oMNVTXH
	5Gwp0+xLxhmISulkk/iq7//iso0OxOej7QDbi37xvYGjrt6Ejv8Ftkj4TUHROWHV
	MaqQ6zj8ughZt8p+EhKUOKaqeeXy4llraW8IMvtKPn9A7yLQEDKteCI6AVx1JKeB
	bexUx64TqpnHAh1XGqFSCL/C4iLpLk033kyGDwx4qF2EmTw5nYCnHUQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m3dpc2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Aug 2024 21:24:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47KLO4Se014691;
	Tue, 20 Aug 2024 21:24:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41531b80p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Aug 2024 21:24:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVFF208zyOI7gd/0zREAVySt9up4U3rm4Cyy3MJUahElGFnZJWp8fTvGz5z5Jtal4RX5Ot/Gq0+tdRwl8eJwqypnEJmkQbBYbnkdBp6SwaOmdeRckJpYx4tgItaKkp/1if3Hr27NTud0QL4tYZ0tyqA+CP3zE0Zg4mahK0Jl1vv4kPiCQ2Rs/C8y5p4FLvOHy2SWhCrdormuACzyirFe783w7KtAhs20BWPywYE1re93mhUL6JLm3J3G8b0hEQKvty2m+RqgAy4vSx3Ng/ZMIpVSDLUyKWvNfryz5GQSsTUEihExTIaDg44vGe6lc2A/MNK+zlBcQMFNUKXXAj+rXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsGKC6SiiqYfpXzXZgLAUrfH6hcAWBOWuIkGJ6lu2Dc=;
 b=jF4qisJVzWgA2BU5YDygtOk9d1sP9dpP51Kwi8oiwwc6H5h9T9J1rrkeUUTZZyWO+pQtIpCpe+JAvzjA8bCPrU/yDhkOl5OB2qfKvunX4uzTB4b5Ek+cQbvVbXkJklsT+EgTpiW+kgPfV9l7nG+AHp0cJnI+vEqdE6aMaJQd6Doe3+pe3g87jZsV/D7cnGdrcov5DpwECtJf7Cc4cTRjp/c8C3T2o/7gHDSr8tX1yhVqnPMqzzO+PubPDosOgrgBXJ9pXjfoiR/4Lv1j18uF7iQPQBUArx7pZhZsZfhnWTayxClh7EDfF898fj3hgd8sZZlmM94bAEiyT8T+jZtg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsGKC6SiiqYfpXzXZgLAUrfH6hcAWBOWuIkGJ6lu2Dc=;
 b=qeiZE/3Q2Sy5I108BBKKPdD+1lOBRTXBAW8VcAwc4olCmhUNMK7yddVp1vJ7rnjMFK0jfT5FyGEk1JTmsW2o/pZX9Msfm6NVYuyPV7QJ9b+7nyLZ1FfjbPtYz6kSiktvc1QGJY20VviP/YyTZ5MCn2I+fGI773838te/4ejCssc=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by MW4PR10MB5864.namprd10.prod.outlook.com (2603:10b6:303:18f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Tue, 20 Aug
 2024 21:24:33 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%4]) with mapi id 15.20.7897.014; Tue, 20 Aug 2024
 21:24:33 +0000
Date: Tue, 20 Aug 2024 17:24:30 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Waiman Long <longman@redhat.com>, steffen.klassert@secunet.com,
        akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kamlesh Gurudasani <kamlesh@ti.com>
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
Message-ID: <3kexyvcrc5pxp4cqlgt7tvdbo3hbt225w76kczjdlzwitpeuto@addhycc4evbe>
References: <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
 <ZrgXtLI1R5zJ9GFG@gondor.apana.org.au>
 <91d29649-ca88-4f6c-bf1d-19e49c9555df@redhat.com>
 <ZrgsU-1PdxvUVMOW@gondor.apana.org.au>
 <88c188dc-3664-45db-b54a-11feca59d7d2@redhat.com>
 <Zrgy1TDikPSkzaYP@gondor.apana.org.au>
 <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>
 <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
 <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>
 <ZsQWV_j5zMuYWqvH@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsQWV_j5zMuYWqvH@gondor.apana.org.au>
X-ClientProxiedBy: BL1P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::32) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|MW4PR10MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: cc3a13f0-e269-4efd-dd2b-08dcc15e7c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dVMU0KIg4PLE88EuNx2vTtLvrF9bZoy9FfrPugmrk3c/ojNAvmr71sZiZBfQ?=
 =?us-ascii?Q?dfwSPfi5SPIBLU3VSi7RtgByneaEI8+wUUtzTv0fqExvFEwFknsSpyA8Kl07?=
 =?us-ascii?Q?HYlN5k3bNHjT109Rw4ZtFvIRX5my+vSzlPzif3ggjeQZKCtR7ugQ21htWw+U?=
 =?us-ascii?Q?Lyh4rwuSa4pq0j32P7PgpKyR2ROPJh72KBvuFLbO0mSfdzxOEmO6i85A045r?=
 =?us-ascii?Q?iOHCBP7Iuny/NKC7uvFoCRKL7RGRgmyG8/m/PFDaAWsABamsAFmYeRlcyg6a?=
 =?us-ascii?Q?lsg3CtSTq4VC8ZLTo9IRJYYz4vJq9krv4G++bvaLj8JOWlIC2zBPz2CYxZo+?=
 =?us-ascii?Q?khedLOeW7IXn34T+uUtm2rC4AdEaacLIPQdPPUydXtPpPt46kxw6+DZp5l1R?=
 =?us-ascii?Q?O7abKHNGQGQbN3OU365g9M7lm3Jaja6FxRwkDfZWCjnClgdBAY3s3vIdCB2H?=
 =?us-ascii?Q?EO0BJlGAnGzn2t3rBpUdV7A8RmvEwkL7s4yjEkG0kv+wy4E6nPm8W6JyzpMk?=
 =?us-ascii?Q?CZoDl6tXSStnAz/O8PpYYmDOaP5HB6765VXWpbBgOuLl9pcT7glVKiI6nWDD?=
 =?us-ascii?Q?GQ+stmUbMxoWGwroh1UiGUecnEmdf1/vYNupA3obdFeq6u1RXysfEabkn0DY?=
 =?us-ascii?Q?WjZGs+gxYkFrz3tBB+D1yG2/uOK9h3gW6gp+nuHfE8w3z1VfNxn5pC/6Y+iy?=
 =?us-ascii?Q?tBjG2AI0dTP6F1Q5RueJjT0Q8XXWC2XH02AUvE+ZmoiRwWBAP8pQtaTVIPA1?=
 =?us-ascii?Q?/WGR+Keh74htsxVkvQt9DqNwUco2x5JCGWNgud3QEG5Lo0D1/ORuloX/VyYo?=
 =?us-ascii?Q?tejCos8mcXHuOGQqs/3T9XkUA10QbUF5tRX/X7yJzsj2DBDqMrET4o6vUJ1C?=
 =?us-ascii?Q?0e2FcoWF6SjEdtbcEPs87lshodhcEDhzDYb+KHHiKz4s/sO5HR/b5+x2L4bv?=
 =?us-ascii?Q?mul7u7fWy0mnXiOtt+ofuPRP1j/NOjOmFBZ5XjnFJl/wIBg1WtFwSbXafqyD?=
 =?us-ascii?Q?p8YNpcEvRnR3HG5nV+4ddl3XHyhQhMnNSmC4ryZ0ht/tLBOQ6/92edIiS+0L?=
 =?us-ascii?Q?W4YwmlmepT7gryzdECbZLXEYOQEg3AUxOPwP7m3YcbBJbnj1WS/a3P7E8tTk?=
 =?us-ascii?Q?iOIS+8JqlP1REAIukKLxBnQpDNbmnliPpQjEj/J0uzaHIDgPhInUV4A70SCN?=
 =?us-ascii?Q?+ksnb0fdFfm1EutxGCIfEDhJU2iJ9jKGoeT6aE7iaePfJ/KVeFINy78RY8k4?=
 =?us-ascii?Q?plK1ckEwvpfP5m5rLq286Wm8Q4o0x2m5O+wLVwEON4fj8woBu3NJa6mJPFZP?=
 =?us-ascii?Q?UXo5ANVIw4Fkh/x8cdeWr1xpx4Hq4t1qbsKFH7qe++76+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CIrNoHfuLeSwQZHCDkYKPzUKk3L4mh/fXqEbRVQp3KFHqtoUB8Hm9WEhJOux?=
 =?us-ascii?Q?hKUxCpV9pL18DihOME8j0e3KPZ1MQYu7IBm81e3LqkJd9GS2RIigfZFd8LzI?=
 =?us-ascii?Q?esJYA5DqQKbxG9D+aTLVlYyJ54FtE83vG28xHnJY2J8gfTUmI3BPxGV3dQvp?=
 =?us-ascii?Q?kOoNLZ8ZJimuQNTRTSKkZ+MvZsUr9LHqXLuAEonU+QY87RgvUyPg/P3PuDhH?=
 =?us-ascii?Q?XtnDsUQgiWCc5HVDTH5b95A5nYo2veGTKcHvknGz7rIw42SVlMTK84Ailtbr?=
 =?us-ascii?Q?X0exAnwRuQcJOnSaIkvBUGJ5hk9e6UNxlaSNgjY3TgajdISMcGNoSomhwZeC?=
 =?us-ascii?Q?33b50oorOqU+ykdg3lk9oCAA0+CjqFfmWzX3Qy7EOOQH0QmaesE5Ignbv6Lr?=
 =?us-ascii?Q?wb6zwkfgQt1VGMnpBvfvqKYbaQimIDbBITbU/UR1IFgIO6qZKiFo+CasgTew?=
 =?us-ascii?Q?juWyEmqOkPDfbySHJS3kLvdwJoA6rLNVu3O6p8Mxo6f6qHToJ1ATf+LiT8PV?=
 =?us-ascii?Q?fnrx6mV0hAKIdN5KKBWgZuxPY2OkBzFKPQ502LBV0xdj0XJNzRKt3K5UcZBX?=
 =?us-ascii?Q?ZpuREI7U0XzwzKEEutd31L05LzPwJ0nHm4wR9bEDxgcZ1nm3/DfHWayY/p0E?=
 =?us-ascii?Q?J4gEuNqMeDA1BFoiPlkDKNz5Ml2GVm2YF/hh8iX0AJYGE35nDcmEHJqXUlm/?=
 =?us-ascii?Q?7wu/YsK0vdMfdXsSrbOrxbkFEJVbhbhBA9ITWqIYRK+J+37OWZYRcwbMb//k?=
 =?us-ascii?Q?i1VTC6MqIAJEkP8PQxtKvRIiy5SxT6LmyuGy9QVH6LPNTTs6FF88J0ZoD00v?=
 =?us-ascii?Q?E/STmKZ03ARtfwiZDnJU+FoxFfafwgXiY6j7aQr62oL9c45WeJq+Z/aTmzHm?=
 =?us-ascii?Q?60TN+D0WJKSyieFonFvt7KHfOl+UviT3rQf/xDmtuKJDmHF9zOoHEqWN0Unf?=
 =?us-ascii?Q?x0pPjQmfKxq5bd2wRkGSpBWC7qXGzgk7M0/BRBG0n+n1J3RkV3FUCnLDVCKP?=
 =?us-ascii?Q?jgQdfsU0wlqiegUaGnOa6W5vlZTNsSppMXJbIcnmwG1xiBDsKqXpMdVLDoBL?=
 =?us-ascii?Q?0TOni/ZVOw+t9Xitqtf4iQZoHdm+HoYPxwrttjwzmX7KnvODjOeajkZkm9Bx?=
 =?us-ascii?Q?/5/I7/4VNR9RtqaT9xwJaldcAqkyVkiW1vBi7pWzdQA0fODUSZR62KKKNjEz?=
 =?us-ascii?Q?dAGNXbvaSV4bUWAJJyeDVjoF4f1MQxT/nzb3U/e4eBQKf3UK0bHGTbBv0aLs?=
 =?us-ascii?Q?c9j2dAe3bW2VupnyxgO9L4qiW1QXpbYDDirL3zq26k9U6Av3poB8Kyopc3DG?=
 =?us-ascii?Q?M43hIMq6LtsdHqVJ10cVikyJBSowfH8Q1UJSGbBHHnTbNCC39yp+2AOxUELr?=
 =?us-ascii?Q?fJLWtHkICzkstY3M9EhuW7j1F+vtesXPMZhnBonA1oCDA3jfxdba3idKfeFc?=
 =?us-ascii?Q?+VVYqgcfihwFqu4NFDp5Ue3TSd2toKtroI8ElFsO0V9hInw5d2DOBc10XhM1?=
 =?us-ascii?Q?/jOXHC8gMphx8BjDlWHl3CrY2x0LTHioDHPtpvBLQO3Mzc4O7ok3tIEbXokK?=
 =?us-ascii?Q?bq/4YVI1THy7aDbGdICumWzbTCKpsmaBo1K69wb5WhCfy7jjTT0Iy3bMeqO4?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e4bOMmobRODEDnZ7638ZURb3DFHh0ddfCMf+FE6yuY50xqhddi7HupyWHhPJHXXY7xKgIjbLhVWrMHIW59T0EokxoH52YewddcRxcXZkqQ0ce8E0ZTuC/Clq6AValeXTpkzM94SljIPY8x8YJn/g3DGzEmWf70b+6xI7IwX7njbm5/pU/rN8tgO8RuxuMxxajYIUbSLYyCyQW+JLZB/SIx92WvbZxKnb1lVh7Y0Cz/FKs22QjyXtoNgylz81HgJOEaiBQxtWEvDKCLt6J7CmiCv9D9ZNylm92ohFxO86PvZZOlg2jR6ZEgufRLMY5xO3gkZyrmbQFuLjVTVm1HPfk1gxx4b/8VD4Y7q27G7XgAFjU06m1+h6YjOcdz1VBizQUDZHS0SCxzfAASmPniDylrxQ4/7slURJgDyiC+oas7GXlJakvNW3dH/EX/EF8kPvAS2BEZm0IKKZOsRkLJ0D0UFI/wEqTTBZw5426j4yOMibvHC5FFppjtV4M0uO2nm4gnhkPYzz85Yb6Z0cQm1372Je5KhetTpI7+sCZejs0zPAtBrm2WOrweZnvnAKuH11N5K9QJ71/2hjDqGebDSoQaSreY21QHHhOtK7Mlt/voI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3a13f0-e269-4efd-dd2b-08dcc15e7c1d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 21:24:33.5520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nK5IUZZmlu0/SZ/6BpdOqL/55k6g/lOaTP7PssB+XoR06UAmi11YCrL+XhNn7dq9AH1wbAN2JaY9d9+fAC0/uYhy3iOi9Gsgw6COLtNYiOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-20_17,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=689 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408200157
X-Proofpoint-ORIG-GUID: H7T6n2Lnf3_fPEL7jO1i9Eh-sMMUX_5A
X-Proofpoint-GUID: H7T6n2Lnf3_fPEL7jO1i9Eh-sMMUX_5A

On Tue, Aug 20, 2024 at 12:06:47PM GMT, Herbert Xu wrote:
> On Mon, Aug 19, 2024 at 06:29:52PM -0400, Daniel Jordan wrote:
> >
> > The DIV_ROUND_UP approach reads a bit nicer to me, but I can imagine
> > oddball cases where rounding up is undesirable (say, near-zero values
> > for size, min_chunk, and align; padata_work_alloc_mt returns many fewer
> > works than requested; and a single unit of work is very expensive) so
> > that rounding up makes a bigger difference.  So, the way it now is seems
> > ok.
> 
> In that case let's do the max ahead of the align check:
> 
> 	ps.chunk_size = max(ps.chunk_size, 1ul);
> 	ps.chunk_size = roundup(ps.chunk_size, job->align);
> 
> If we do it after then it may come out unaligned (e.g., job->align = 8
> and ps.chunk_size = 1).

Sure, I think Kamlesh was the first to suggest max, so maybe Kamlesh
would like to make the change.  I'll send a patch otherwise.
