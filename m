Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E5254707F;
	Fri, 16 Oct 2026 12:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154793; cv=fail; b=alkXVBpqJSvHFvq0PbhVFyAaiGwc2s6D8yjwG9qQw5/sBkJqReKd65BVwIeQiTA+EbmmnCbgYqZNqZHDhkwFUnL8CNrXIGF7AnsImuAsLDH2xmwo/RegiYY8Xda6Yxl5vbnyut5uPpq3HyH/4+bsgnVF1+fjRkvE7QVqeSFErUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154793; c=relaxed/simple;
	bh=YC/A7S75qv+4+3WlQfVYWpfOLT28k6/ecphUxP7SPDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GuDeyuItTR8hFWjMrQRS2vT/nqAxUt9l18refkQOD6ymiDGq1VFNHLbaQD6PqFxeY7k/E4a/Np+1p4oeRkrnlQf2GFUaE/R2TUXg5zecmu1U2qow+f7+ss7b+HRibhmg/ChiqYRYXi8DzzXj0OXhws/gt61yKsVSYUyve2+mSlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=agbYUNp+; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=rl3XlaO5; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="agbYUNp+";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="rl3XlaO5"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACkhh559681;
	Fri, 16 Oct 2026 07:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+
	WQ=; b=agbYUNp+a2IvbUGil5Q+58c8H9yWs/XSR3uUTI2DniFJCstVc9wF1RXg1
	jifBIlsMx2t7xfPigYBfvjXOnpofYsaaeDa6M2LV09IEnJbGZWtnUE+boocD0bhd
	ON5q5362arJCeYRsp27q4TSXye71kQM2aonqI36x0a/G00+7WTXXNSipLmprgP0b
	73hYzAClrkJeiVXHksZHr7perE0VQVgwKOYQJHsT6zS7c7QrxdZv9jvhZ3bVAG/h
	rOcYEZX/Et/0qW64P3Eu5ZgXGq3+IbN/P6ADiBhAzL5ceqEe/kRQitoOBUmaOKul
	xFzwWZSnVojyw011VqISsv6XYM0FA==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8sje-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:26 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1QVSBJJUgR33sGaLB5IImxoemRMSaiXrC/IXNaBjZPBjZEjKCtZfT77cmSNY/X8jAMpUPwcLERI6QLvHc6KM2j61bztQT7/V2J1tRlReC3KfXZGxZFQUD8zZyIzIX6fSmQd4qCV+MrmlQNwMVyh1DCd5WOl6Ra+bB7PB1vQMHeiEWCdIpnNtvttEVWz9iaacA2228XoybuAcOZ/MrAftYCTCUHBMe2XJM+lUfZ/2mN9pBb20TyHJHONd5wAL++6Aajaol3soa4ZtPjtUszkm/oFd1JBBAX1uUv2fC4gV8JvyysJvOykPpKt0IJClGM7jTtI2b5EbZyzjs61GkybBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=bIDztyoR5UP24PORXvk5DSE4SpsdN0SBcJDwVoRxl5iMa/rXr7/9/tyzievlMdNoI+KshJGz+J7p+N7UZ0htebNkD1QL/JL3hhwVQQs0RVGn/2snFGbcwSn9vzKQs+NGf97Lb/y2vksuxCfjWolaH5vj9cvFZ9VJwMQLeE+MqDEgGpZziSRvTS5Hi7dGhbYdsz8ALrOZzC0j04eIIOuVwfJRjssYe1leDfV0AjMQRmfFkrSbKNUw0s9QO22vN+PCdZtakC3NNKfITyWGjrW89spZsh187H20WMK1nc66HlAF0MOdCnLUdvjrJhvUl9K2KDd+J97BqvoLvLfX9Tslag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=rl3XlaO59rdmIYbP8J1BKwBEchYuEky6bxc/ZGYR9YQyth82NoijdcoCXrJluMtJJ4qUr36tv+lM082SZfKg1LEafJaDHrqUUFSHnrRcRKJaag4Vnp3UppW6tVRYGrJKMzMXhhX9BJC8E0UP3bd52D+8X5gs9HslZ8pgZyGX4pQ=
Received: from PH0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::11)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.9; Fri, 16 Oct
 2026 12:46:24 +0000
Received: from CY4PEPF000392D8.namprd03.prod.outlook.com
 (2603:10b6:510:d3:cafe::22) by PH0P220CA0013.outlook.office365.com
 (2603:10b6:510:d3::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 12:46:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CY4PEPF000392D8.mail.protection.outlook.com (10.167.247.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:22 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:41 -0500
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:41 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:41 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjeHI2531670;
	Fri, 16 Oct 2026 07:45:40 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Fri, 16 Oct 2026 18:14:51 +0530
Message-ID: <20261016124456.1802080-11-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D8:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fcdf541-fe35-40f4-9404-08df2b837bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|36860700016|1800799024|18002099003|10067099003|22082099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VYS8tee/shjWirve1TiSymBiCKRyCqT+ZbtGwFzJRE0xXJ/BSZl+XjOjNSHSbaT0oNO3hYdT2B3kfW5Ee20xJCD1HELT6lvkzzgQime/CLPfXffR9FS1x0Y4Ll8UP7HFv/7ldsgR2rhlOob4Socp8nM0LE5YFpakhqDj8r5rmgpg2G9qjx5RJc/f4Z8dOeq31bLuVOd690bqzPFKM2+yeI3n78WePxxWbebOfFmSjfXqDYo/D5moA3E3kOxnxFBKA8rQ6TcnHgKXkSmwziWcsMY/GDMvE68ABn+oVbQSS6wnznWg3p1y4XeDRk0Zf5Wod5ZNQ2ssGKy3M7D/XgoZaUe58Yi6T7olg6VQzjZM3zRkH+DvbKWuVyeQyIH+GjjbM7HSxvT/vDwetHJwglJ3aZoqgMqnIlLZmQ4k6q/5/06TMGiuY61vHTvV16vGQMI8iWNBBF1AYn2XaaTbKEh8JlDY/232fXMEG4ZVvh5ZAYLX0PLJfcVBL5l+cl4NKciGVJh8V6fNFzlFWsey3cgQUeWcLkIUe+FEYzrQjP3lRqGOBafaSPDjGOfVdPPopjy2wIK2pYkccf5LyNCkluhXq/g7MeNDI2AYyaQAmsmohpqgqL1hUJ+J7S1kCGuGeQ5xSxFM/nXIdW3Jp9G6XPjV1KIVYx61kO0Z69vsyQbOsIjXKKAiGqL6ni/ZgFIn1iYG0I5dBzs/jeIAtBuxsLifcg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(36860700016)(1800799024)(18002099003)(10067099003)(22082099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H1Sj6Vq7WxpFi0KJ5rNj2Fc283LjMQUEgNzwbrh/vhRKjKEiCpyyGTw4EvHxRyZ7aspDcv+OTSRRKw2XX9Mxgaewq0qgSkjNGH++7T4dwCvhSTBcGC0EiY30+T684K5juwa7qyPXLvFh64/2sP+O8PY+/RBBBghd1cpvey8T9EZQrr3Bxddsn8DeqjhtozXAAuExPWZuy92FIJozqB9ESA9+OSMi/bgGSs/uivLSpj3lPY7JXhhnvLmcxtob0CCwGKOfeOr60MRNP8S3HS74ojMifEcdknoCJUcgM0BYniEB46pcJ27lPoClXjlkTAfhYDsNISAb3op7msBUrVe+wllssfpSfSwACRSxNp2bJyhWWEZbStj5MWRH0SGhVh+taYvSK6lPEPKqbkWNDFOmaQArdHcBBfheGkPJx5/4PxxFpygP4DCin79fr7qxMBxS
X-Exchange-RoutingPolicyChecked:
	ZsiR5oqXJaUWX1o20jMpogHOnZD9VzX9UGFg2hPf7pzUuFRZDz0PLPkkZfNOqqj+SQKOmB15Ho1u7JEGwsP4wOOlDX53RAMqUniPg9op6jj/8te23ew15qMatRta1C5Xd+l1CWfW50+0vLrmAZF7zzdPfMVCylFoSoxVGrFTS0X90pkrbEruzl4GUEDgLjtp6b1WMYdRRfdseQYBWosoVeh587RVYd+/s9S7JomfjH9tKm06m39C3nbKuKTIX4vmkxZI1jX0wRtd/0NR0+scGQtIFNm+5wYUU0lDxhDkZfgQw8pgQ3zLp7GUkBaTeIcISuH8I0eRKWbT4EafxLeaxQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:22.9701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcdf541-fe35-40f4-9404-08df2b837bf9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX6Qvkc95GWOIy
 damze8+iUFTrFKBq1C63lmKDdnMJLGr6aRaxdS1hpDuZ+ybZ/wWzc907rA7IKLsXh86En6tQAIb
 h+16VNWhwcW9FmWvM+AC0ILUhFgQBic=
X-Proofpoint-ORIG-GUID: rnV_TjRPeoLH4_X3VfyRmLqNidMXA4oR
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad21ca2 cx=c_pps
 a=jJEkL6Umpl9hNhu6gfQ4Mg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfXxC0iG3L1SIso
 KsF5nZJbV18YePagJghcnsk4wjSZKOfLJC9h+Dj6AyoyAQuv3jj4T2mmvCxklC8ck+MGwVDKiR8
 9gPtkphFb033PQ7ozmAUlfgKGbK6pTxh9kub6Q7siWiguP1BZ3rOz8treMxsEiVLX/SBQHbLDKX
 Ffg6gsdCK4iVsP0JuX5TPlecCVRV62BQJHGj9DB6H3u5YE3Dzfd5CTEr1r7kBOP8ejFtJpkJzoh
 AO0zbdVnOPZQeR7ZnlY8Q4yqyBVCYBXsUNSkKbWlI1hcUbr0519AYtUmzWaD6DVsTP9IMLC5XGJ
 0t6WEipmjCJ4t2EXofnuB4ejhM0wuKTK0Y171fUyFtWSlu7gDvSc75plVoP1Gm5GIpATCn78x2L
 IDcOREZtWCUt4CkOAea04UQgHCNR/B9wXP6qByyMx5UVtQpbLHwF6n02vfOLC6KSfxRniEl1lGp
 RrKSHIROz3xUqYD42Ug==
X-Proofpoint-GUID: rnV_TjRPeoLH4_X3VfyRmLqNidMXA4oR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index d75b074ca1e39..ccee60800a664 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

