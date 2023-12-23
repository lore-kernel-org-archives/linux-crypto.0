Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29A812B76
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="l8ZFtGUE"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNI1QFo023723;
	Sat, 23 Dec 2023 18:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=0rAUeiAqaYdpfPLlrzzDCDA2SPU31o8AUYxcDRcy5fI=; b=
	l8ZFtGUEgpJHF54wy/xWePBNoHcLMfV1POgWItI+R7Ig6GM4FTlcN36LrLSY+fEs
	Abuxdne9NMUQleCo4jCIiAMyVPQGYtyh3o2itbWh4Vyf0+q8JzoF26/0tKtFHr9C
	KAOTYekeNYma+IAeShgzyn1LlcYDYvRo1LLag6nA+Pa2HScFmYk+QnABTUpQbqbt
	aqW0OKMSzEy54HRANfPG8gRZkEeSRECyj14ibheyJ7V28MscMmOd6J84RrKpWwlh
	o039l+ktmd8vav9JNGm+bwFu5SCxkONKjsHKsPeyOBeUoa+OlCFHc2aavCdFYDRy
	/YcLqKlybpghng9aDP2kIg==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5mrxrfj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 18:10:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByejB2ffiZF+BuaLgyLgMbb2RkDwd0zRmCnrovpPJLpYX+jACpcoBFEHnvwEu/kVYJgHvQ838fm1mFF4O1xZHSQ+tF6WM64Azq9YWOFHTd6GNFK5dqBeU6TtHatpvPJ00G9K/kASyup9iCFIY5mzP+ehGf45migP1wf3S4rzoj2G+UB7vCLW60ZzJo3KVuVJ4kMXD6GJ3gAB7zvQ/1SmJTL78NF2J4VLf4+u9LXLfIdDYZ61SIYy2SrM3gwXo+EKrgun/GVAWyCljRevsXgcmmLV95F6w/hn2FjoT09tdYkp05l/g3vX/2ZSTj8p+NKmbjvTZRgorF4qGureQ74Xeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rAUeiAqaYdpfPLlrzzDCDA2SPU31o8AUYxcDRcy5fI=;
 b=CKvvbcA12UMx96UenKdtZmmwmn2UXnXNPg97kSH+HI4QaLqtxKwBDKLtakCqd6X6186Z7QF9IA2PTEp6AcYx9Uw6rBccpHdRBQ0xnkl5jU4j9a4gStsvFEgNVdlg9cXhbozdEbZ4HSqitAQoyc/Zu/DYSKWUWaJl0V/kJutT1N5McScghHUkdOuWBXR/aNJ/tWyTZJWhyEmSexEOM5noPASHckFx6TkNe6JSANpohAFalE8q1aQereQAqxLz6HJGR8ntpxAVMI01B6XP34GB3f3B49wMLK1WA6/6YSaEBUCbU0V7U0IyL8kMYcdy8i5D5ch+WclxikTKHI/kpGxtag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:37 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:36 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 02/14] crypto: sahara - fix ahash reqsize
Date: Sat, 23 Dec 2023 20:10:56 +0200
Message-Id: <20231223181108.3819741-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
References: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA0PR11MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: caf43d2a-801a-42d4-14ed-08dc03e2768d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9zYJATfNaAUEwy5ur5sT6ee7xFhuuXKxX4PV6l8xmipQ7ERBzahYhFY3oIVS5I962QewIitIBE9Y5ZL/VYrfDu/qAkrhGPoU/yl7ye28FY3jRa1ITLVT2Zu2VmD9absZUhSeCmQeY965CwlrgwqN03BPVIoGaHkrYvDKriJoU0iqRx5JXCvlAbJg6G7jgE0AQaFPS9VwYbLRjKx804dM459UPMzesiMSagQ9Jyni5iUWIeGNsVJ4fsFKhksSIT82U+q8/OKnWDqKfEELEzmmUUhebmxS/sMlbDxjyzfLnjoX68ivbpRLDUFsZ9Vn/0I4BDWUrr7+WT8UFy7z8LJaje5p4t1U88WFpZV0eNImJ1PcoeE1AP1l3il/we9GeI4HMjDijjv5VRU//O5dJVR4DOxg0rLT/kJ/oowZurzRJcN3/hYAq/wd72Z0DWmgLexbVXq9zkTBi3lDxRwM82z209VnBWorO7E4ODtJc1YrW91cyNCmOTXE6dVh1qSQMsurNLakcgLJSwnxKPejRKvRIktaXekfP3BIl9/R+/5GwFx/7nHUyPbPHlmCHkHXRs2E3ZXUNI0FysPW0482PGaJP5ImV6hQOeNqT0tXRnL5ZbE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(4744005)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FzF64BAJIRlwqL5QoyyOfPh/m2Dzl0UAnGyeGCPZRC0o4Spdskyron7JDuWC?=
 =?us-ascii?Q?GuFNGbXxD7QuvMWfXcftNaBq+T0inscDGsQfrIr10biSHY/YTDKJPLGYR6Aq?=
 =?us-ascii?Q?SE/dH0HHisQiuFeh+ay6aGir5eo9+fPrvZlgbNHNjztOpn3pX2HYEI8LQH7D?=
 =?us-ascii?Q?H5P7Etehe8EuVGglTw8LE4mFmjKzne25MrRfE3Q7gxXP1yEQPlCgUfhfslgb?=
 =?us-ascii?Q?MjorZddWB5OqD4YLKBMVKFE4Ql1nbCaeiwTCDnneMu8f7ImsB40yZJgoR6SN?=
 =?us-ascii?Q?jrRUvKAOmlIqh1HPBtgJ7GaTbBXFU+bRCvJo868t9ekwJeC8Oj7A+DjTKcML?=
 =?us-ascii?Q?voiLK4//CRIiyLJOZDoqoDsLfGNQMoYSNNMnM5yJgKvjoRyKdodeXXtjbd1u?=
 =?us-ascii?Q?xssUHpDn+XRdm9QJ5EUsjx5Nf25KMSTN8TpKOvRp9iAIef+fI+Qd//76hyLL?=
 =?us-ascii?Q?tEJGNIRzW0tEM8M+CptXZQ9YoEVG9MBopDHWA20whJ960KTLiF8XnjWsq/29?=
 =?us-ascii?Q?YRJ4ArED51VDmHCEXnXb9oHRnLypYLS3e3i7CeLklnBAhZyEMWWElhdiCQ/Y?=
 =?us-ascii?Q?ZeiN1nsYHisOrxLNs2ETd3RvufhHT662ANSqoPBcLd8DjJAnhbzKUy6ILHh7?=
 =?us-ascii?Q?yHZTjqFW1Z6lAF8lrNITiz7oOK1BRor8eIMOA5LrU94Uh8lgqwF9+N8MkXj1?=
 =?us-ascii?Q?4jyugjqYTEkVTpfRTEmG0uHpUaRKbJuE02RimpTHI9FjNtajgRRPiakZtB1m?=
 =?us-ascii?Q?4zvlKuiW5tPDOPZ5pHVv5T7W9FzmAXTjYdoKavsmIw77xVkXvIdNqlGzoSaw?=
 =?us-ascii?Q?UI3wOWmka0n35uC6jdf3+1dW5G09sghcm2Rpm4cR94OX8fEcqVeo5XpYpVXj?=
 =?us-ascii?Q?OsaBBiJrk1o4HG16PbfQgEBRNNah7hLcsOymfr8udUDjgNwqvuHvUauj5jVc?=
 =?us-ascii?Q?2eUT46uojlnoTd+YPkTKtz4zaoEtSyAKQSmAh0lenMAJGGgYULU3eveDL0Da?=
 =?us-ascii?Q?ZPLE7u2MKnyEx9SdPv+AmNpiXCahhH0k9+QV0ptWsXJRnmxkDjHX5cEH1UpU?=
 =?us-ascii?Q?jhrLP6q1ZPlmEbUiWb/WVdJZdooPQ8K2xM79UmT9GvWiUi/86zyngWR+9fSA?=
 =?us-ascii?Q?2CfB0ERbeNWfhlfbG78ptlSZ70nLTGVn5HdXJQc8q7xnJLK+CJi6YdOWfFQf?=
 =?us-ascii?Q?3tr9Wf1k/0B6A5GxR3Sj9XFHl8EEi2c0ZCCNYsPDAeVw/s+uiqWgJfOd1Tyg?=
 =?us-ascii?Q?lGXboe/sMkOipPhD9uyh6g0T72lR7+QdlWwBTP4dZPZmr5O87ymQc6wBVNyj?=
 =?us-ascii?Q?d1b1t3eKaBIbfvnIMDCkRZD64eRCV1i0X1YKnmujxJEB3HIspJ6P6DVOQUBQ?=
 =?us-ascii?Q?PBrXOBJIHDGv0gHV9F1M4Dquy1fy8kq/qvuFng9pReVhZA78uPJZcXeLCr2/?=
 =?us-ascii?Q?T2LYdFdx+wMEk8xj3dz+kixcsnXLwFjzI/0pha+KXKmKzYu7sFwWnRytSozi?=
 =?us-ascii?Q?RpOKfQm31jTCKq0RVy9hpBo+wHzARKfkMnR7ZzOK2rBxtlMqdN2hzPdHT8vq?=
 =?us-ascii?Q?CboaPaG3ugg8/cuHs1ixvbWEaXa4GjmXLSTpSZ30JqQ2FsxserMH5oBa4ebb?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf43d2a-801a-42d4-14ed-08dc03e2768d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:36.8858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTCDgVZYRLVPQU5yOjg90sVruR8dVgOpQ/4gPhdvgeM++wGC2DjNSEZcjIQRgtoMgj5JYSvUlYQwK1Hbyoo0uGY6vciiLJ3FOQftE+EnW1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-ORIG-GUID: E0866p7h0UG1rMWE17hcFBjO7HqohMWg
X-Proofpoint-GUID: E0866p7h0UG1rMWE17hcFBjO7HqohMWg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Set the reqsize for sha algorithms to sizeof(struct sahara_sha_reqctx), the
extra space is not needed.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 1f78dfe84c51..82c3f41ea476 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1160,8 +1160,7 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
 static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct sahara_sha_reqctx) +
-				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
+				 sizeof(struct sahara_sha_reqctx));
 
 	return 0;
 }
-- 
2.34.1

