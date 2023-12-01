Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="m+S5nHXx"
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5EB9A
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 09:05:33 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B18o2dD004589;
	Fri, 1 Dec 2023 17:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=EMNwhREwIo0qG0ds6HPK6BNCxOSA+02o5lgwM0TLT/w=; b=
	m+S5nHXxv7qjhb0I4hWggOY6ucuoP+cJoPEpO04XcdxYIivhFA47NP6Swn5SKolv
	9K2eowcExB5d7HjlmthgL37tanq40G/7c/lGPBo2CHU5mZHO9G2akq2KvkYePGcd
	yAuOLGie4ZbIONkKlQfJLQEDRmbUgFGU44L4iH+whc67k/FZRjgWsPiRQVX9nzbz
	jVSZ5RVJxHNTwU+GjwTfb85TVTNYT9FGJB0stuRCpA3RRYLTG3MaEKfgnw7yxfJJ
	ura7f1QqFY1kCkXnGStB5rzVmm6TgLDEKH5MIGn5Y6UiPWA6VorgTjc3rHUatoaU
	F7HUrKliNKsI7aXPU2upug==
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3uph0w9xg2-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 17:05:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7h6iHqq0oNpTY0cSkpZj8ELm7CI3B7mJsCbkSbQX6vtWla9f2dlAOmgfWqr9tv4bbJ0u3n0am0StSfXJlqGiUOE75KjLdCT9xfnoOstbILsn7AgsZxoXUGn1++4V0fDj/vg2SWjiYbwQe+qM2hxBIXrkhHOOfQAxP6iQTn+9HjPP0XI006rOGnnXYMEKpfBxiZSvsdNX6vTNFpeiUO1A3nN/RppoGQ36VefCXHU1khDGFKBDbzcrZoElnMz56OWQDFTz9RCvjgwnRKZZvHBBvCr8dcNKfpZW7b4uw10uyIh91OIymiD/i1sgrQEi/x3S9ENyfQacrgj3kmPHW1VTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EMNwhREwIo0qG0ds6HPK6BNCxOSA+02o5lgwM0TLT/w=;
 b=fKTKGFTgAnX9dHv+vKwjhyTf3Hg1rEfaXAI+Gdn9jRql6ZU3ak3EUj9HMtqJLUu7+J8wxqlv2M24BxB8MxwIifAnSn1a1yfgGqVDBirJiGMsSJfOcAg5T0RrvHsx0j8hdNx/G7I1RE+EC7jh94t3U9Rx/mED7Hf/z4IKS9fXWBOa35GQG4bmH1Vat3k2zI0n0zOLTCzzox+DV/LsBVAXnWyJa+d26W0JtcqS8mz00jGuejVDLpYVJZGbngCEWaC1DjgqqUbjaAWjgCRasr9AmaI+wcxysbnUElFsFob8njtAfC113XgS5O+lolqf5QnF2L5vocobx6Fs04t/09O20w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 17:05:28 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 17:05:28 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, festevam@gmail.com
Subject: [PATCH 3/7] crypto: sahara - fix ahash selftest failure
Date: Fri,  1 Dec 2023 19:06:21 +0200
Message-Id: <20231201170625.713368-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231201170625.713368-1-ovidiu.panait@windriver.com>
References: <20231201170625.713368-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0244.eurprd07.prod.outlook.com
 (2603:10a6:802:58::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CY5PR11MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: 15974be4-1a4d-48c0-641f-08dbf28fb802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AbaCCKdLm/uetg0I6f92r2yBrKExsFzeHDOeORxBxmK6Huwga1nTgKwTt2EInKbgA6xFVJ/Mkz4NmhFZSxYKgnBYUun3wRIK4CH4V5zQOYTj5pVz110sRnsbu9bihg9ECoVTwB7iiyUcjLePKQx3S1GX2ocPYoD7ta3wueoHc1tVKSAQKREIdeHmkUyrn6rM7u46XNoOi8NUJY8dO2QKRWdJg7K9rd+3RrSqbFVPYrd8D4he1bPhtO6j09Bef90BDlX1mVy6huQUSQd0J7W190jao/BwYdfd/mn7YQSflLToeoJdZEzh3/CGRfRFImbJu1NsaJhY/ELyQhAHD+E5t7GssouKKGCRJPFfE6AAkQ/few6RVYHTwSC+mEDLAQJOsJcM7y75PetZlEvU86x/Mc3/xJI9WivFHXqCC0DKClh5k+xpUjVn9Rc/BqxGCB/0fnB1m07SRcIHHrS57xbN0lxee/ohagzlZ/ONfTDRnfon0X1RV9+McrFgYr4knyabWZhZXM0HHigLrwBvJ47N1Z3csbCQR69wJ2vKwuD+p26ywLa8QmZybYl6NltbAcR0W8W6rH6xVFPZMvIE83SrtF5+p+jgPkHqNfg0mZeh+labI+vN6vaO4jqSV/70jB1f
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(83380400001)(86362001)(6506007)(26005)(9686003)(1076003)(6666004)(52116002)(6512007)(2616005)(41300700001)(8936002)(8676002)(6486002)(478600001)(5660300002)(2906002)(4326008)(316002)(66556008)(66476007)(6916009)(36756003)(38100700002)(66946007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?y8I5BpOIUVVugnI68PNaVbYAfBsWO+blyExcKFHri90wOIrCZ/MM900Q2kQN?=
 =?us-ascii?Q?PwFEzwjcl/nQEiS/zHSORKWSQ/aWc/OdsssG1H5QwbpvYxuDlH2xIdzpV44Q?=
 =?us-ascii?Q?CXK/mftg+qrVqrAW/NQU7/Or4kEdfkOnVOgARv9ZZOzPZ7R3mVVSlHN/tF4Y?=
 =?us-ascii?Q?G3NcD3+R/XHQRqgCcXkpbltF7j1C/9jFZ0vcAGxOywKx1/pjMeOwtN7rh3Dg?=
 =?us-ascii?Q?UJz/DWD0zteQPHFV7Cf0cFOpVDJc9Pl+vWbYNeaL26LsF3nQ+Nb+fsXqPWwC?=
 =?us-ascii?Q?D5IzpwWPJamIQzVlypEEABONGZJtVqigSR/9UW5ylhcwM2jvRINn3kdk8Iqq?=
 =?us-ascii?Q?jrA+cSdFzr3M70oN9ANEkEG4v+BL37ER8J1afp00nJO/WqhWj50UPHhcLkpq?=
 =?us-ascii?Q?9P4LyhKoCJLRLC+dZeJhuRTzYzFhEsqe1hwXKKCXTvaVR7VKpLvYnwl0ufra?=
 =?us-ascii?Q?53HLxMKsiUa1nbA0tjIhAFzTzxl1c1XyN6w3/PcWuYoF+es7m7Mvj+aLEDnL?=
 =?us-ascii?Q?ajHwYl06vbZBhsDNYF94Xd0vMSqjQqwGxc29GN4omo5turyInTZive1EKjb1?=
 =?us-ascii?Q?CaYPcMzihh8Y0Ic62pzWikry3NfBPaXI6j39WeR1UvkEgrgUwd8fba81wkva?=
 =?us-ascii?Q?2VOzCr+aGiJDZfJf9bjdoFcu+XZPmBcBfZb7EenGgEzy30I95Ohq7ZmNkwR9?=
 =?us-ascii?Q?DU6VVmDuWXFsRoWycBwQJHS2Zz6ppITOtzara0BR/eLL4MUR8yLw4Cjq1xvj?=
 =?us-ascii?Q?6F9z2rXCaORv75dkdbc/qZGl+ldASuQYtZkzh6X4ZRCeJJKH7rgqCnakmFIq?=
 =?us-ascii?Q?3BQcu2dbQ3kj+maKzdGaMCKbZWrTwUjPcu1LClxJXzUeZbUpew27ih8yQjQw?=
 =?us-ascii?Q?yHzgBLo7vfFj+2RPVV4nSXmHldRLYU25qwsQCgH9nXDWxp22GJEvBYpexT7B?=
 =?us-ascii?Q?pIpBVxn8+DNJTe7KExCzz9F/qH2P0IpnutaL4XyOTvmvl2Lu3xe2YxGz+0TX?=
 =?us-ascii?Q?DMGzOcwAMBFeupFHzQWcjB6ksFxQPlzFEIW+2LEUOULqPrBNFUx7QgZrfat5?=
 =?us-ascii?Q?UnSknGoTXhl+rvG17ouBvs7I5gFfTmXURE3IyQvZa4Ay/NCo+TTKUCT1ZIu3?=
 =?us-ascii?Q?e0V3/aSAfHAb3oTwp0uDaLmcZ+oxZ8P82pS76HEK3BAP1x6MABRfLl720WRa?=
 =?us-ascii?Q?TLAXiNSE2S2U5wY1wAiegJLt26kSy60oPYp834AwHZ7VGzb9bwbjvsHqkVhf?=
 =?us-ascii?Q?bnHVhg9o8Azh25nJpZDXthI0QIFLJVRJ21OyIubpKG5cpi9HnCq/q5WSdZlk?=
 =?us-ascii?Q?WU0f4hm7mIG7vqvsW5Z6+o1R4gm1DeszJZwlmRggWeZRuWES7sAqEanOWcr4?=
 =?us-ascii?Q?N50XXQWQHgAsmI/xaV8IxC4tyY3DniWTDVy3qaCSn+dkeve6lFe+QqGV9Ls2?=
 =?us-ascii?Q?bAhLyjoPEv64ZiUhmMlxiKFm5GduOlF14jcKC4X1Vj0yMWFoqmwu6KA/BVU2?=
 =?us-ascii?Q?orVUpQspD7ndz8sC4noWqNeXe4ACnnuTLHnZzAWWs+/bDQf5j/4fT35alETI?=
 =?us-ascii?Q?7dvkLHfWIuuJuX9bfrp9a/3SkiJajeBDAuPbYsigFGLaklEYSuHKqeE+LsOC?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15974be4-1a4d-48c0-641f-08dbf28fb802
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:05:28.7321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvfybubGw0sAdJ9siitK+BGritBnJPkzk9MPxHr6rsWr2tZfigezjHOni0H9Veblc9OcM1GdTu9chyuJQr78u/ZcBdxzMcC2h9YxMESX3Eo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-Proofpoint-ORIG-GUID: JDGTmlwLmtGOtECNSKr_pdA0uYCvjk_4
X-Proofpoint-GUID: JDGTmlwLmtGOtECNSKr_pdA0uYCvjk_4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxlogscore=990 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1015 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311060001 definitions=main-2312010115

From: Ovidiu Panait <ovidiu.panait@windriver.com>

update() calls should not modify the result buffer, so add an additional
check for "rctx->last" to make sure that only the final hash value is
copied into the buffer.

Fixes the following selftest failure:
alg: ahash: sahara-sha256 update() used result buffer on test vector 3,
cfg="init+update+final aligned buffer"

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 888e5e5157bb..863171b44cda 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1047,7 +1047,7 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
-	if (req->result)
+	if (req->result && rctx->last)
 		memcpy(req->result, rctx->context, rctx->digest_size);
 
 	return 0;
-- 
2.34.1

