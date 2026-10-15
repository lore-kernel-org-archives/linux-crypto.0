Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011031.outbound.protection.outlook.com [52.101.65.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05CD54EEA7;
	Thu, 15 Oct 2026 19:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092182; cv=fail; b=l0V1IeY1fdYUVL9h9stUJS4qQrk3OICUma5f9o+PwG1znVNCs/r2od1g0kvIMYDg28yV3gJ+YXKxbntRbtDcxaXRi9IAdj8XJ7J4sNAU1XsSjw/9MqYmdm6XvCklGmYL7KKCQ6TLMCHoC6LSEh/oE811d67fMv0xJtDxZrb+XPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092182; c=relaxed/simple;
	bh=xo+yXU/MZ4gVguJrUjSOsJktVYSUgnYdbhlXfw7Zg3I=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=u09uOGz7WHzWSZrSVfDmi3eGNaQzh4cNd3vJMK8Ah5AcP/73bz5gYtzWAqcSfpmRJJfQi2JyIQOG6jSJZInvkQ42vlF/gH/CF9VOCKgPy3m6yM1Dy0MY6Nh1avCbgkQ9nu+kgEytfHJrE7ymQTmmXfn9fQXdMkh19iUY+cDQ1u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=JcOesouw; arc=fail smtp.client-ip=52.101.65.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="JcOesouw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQjzPereJPo1M7rahUK/ljEIbaLukdQBNasWYlc6CgSmjNws7hbs/aRGoR3J2nO73XWV1uf5vNdF53zkoipCUcCvsX597aDtPzayse3DMXsDzuz4pmLjCT/+7PpsdJ7h6a7jjRue9D74dhkXmzcQnNZodflblQSIyaaLJVIu5uu08unyQC6dai/ECDTrFPIHEXB+BtyHkeXlDE8am9NljBjkD4chPLaHpqByuGvAUye5ZpTgNZ/vgB7o2mfQ1RtmTcwnrPvq+rHl7NRzRmIn14C2W8PHyju+wYIqVB0OIOGqTE2Aq0OPbEGWdKohY1NoYQk+fdmW2ugpKiHTyuMGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBuCEGDrADUZj+PTA6oRH2iLGuSXTpAGZSnySlCXPDA=;
 b=utXUJw7F3jZJRez9ZgPTTrKIT45QSUu5cXgdjiLvkEkTEo7edgz8OVx5aPryIefh5hQEHt56Zt9Z/CowjqXuVQG+pHNAbdYkS+9GnoZo6LD98ClYGYGP+kbzEZKWR9Ps6R1n+Tjroz8btybUeA3n9iFLodLCQ0CsosILBerb2pIOULIzs8skcO0F/hURXbHsJ3m0fbE96w8fBoVHyXRHxdQmTodx0ox4WN+D7fiFP9whq99cuhOZY+NU0bezL2N5CvlFtNru5wvbpfNvmDDMSjwvs0WJNT1i3eWLaqOjEySuhHyJf2LmMRkXk9QB8Js0HGrBpSXBM1XRC9pOteIzPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBuCEGDrADUZj+PTA6oRH2iLGuSXTpAGZSnySlCXPDA=;
 b=JcOesouwH15Z6C7sPTuQRKkvje6PplZwLwZZdNY5aUn/WwDbCqsj+Xy9Bgm7Ao/i7tR7AfboSsZb/xIrCUsTPXqGK/WPx5YIhGH3bAHZOaA4dI/T9+6FHotXAIDDEuz4UXA0xKQaGpxebqwxnJdWtq37zAfRLQpCpN4Xsahr5kzQLNOyMsG0ZVo//WQrm6e0Xlefse5R8czeOZnH2ggdKbBVfj9dxKbDg6hYQLjL41wasR2dUiEu54mNeoxHvB/xLszshyhaqbRj1UPZcA0g1lEaSlrh/yo1dg0UGMkwuAe/cGhzjo5bq+oCqlP1+47mJWU3ikElDyEqJd+EZQyYog==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MIWPR04MB358405.eurprd04.prod.outlook.com (2603:10a6:290:ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 19:22:58 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 19:22:58 +0000
From: Frank.Li@oss.nxp.com
Date: Thu, 15 Oct 2026 15:22:25 -0400
Subject: [PATCH RFC 1/4] md/dm-integrity: replace async_tx with synchronous
 xor for journal
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-asycn_tx_remove-v1-1-056a7085e0a1@nxp.com>
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
In-Reply-To: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, 
 Xiao Ni <xiao@kernel.org>, Dan Williams <djbw@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-doc@vger.kernel.org, Anatolij Gustschin <agust@denx.de>, 
 Saeed Bishara <saeed@marvell.com>, Rameshwar Prasad Sahu <rsahu@apm.com>, 
 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, 
 Anup Patel <anup.patel@broadcom.com>, Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792092167; l=3225;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=NY3esA7XZDEYOgEWni8OOg5IrMcJg8vFNPTSvJltSBQ=;
 b=RXSmVSSuRfqxSqfmxpF123Z6vWkNtOjwWTQqge7bD0urOM5Ydl9U8F4M6Cnkoig4feIfkADhe
 RNy81kOv2/iDn1t4aZOepSJEtlBJONQTOP1bEk/Upp4HisJ3bAKdjk0
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::14) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MIWPR04MB358405:EE_
X-MS-Office365-Filtering-Correlation-Id: a06fd20a-8340-4cba-41da-08df2af1b84e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|19092799006|1800799024|23010399003|366016|18002099003|22082099003|10067099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	odtEsB9i/d/DjyMd9lZjmjnjfHW2h8yRj/vXe5aif5k/JVtebQDXRFwYwVT0mJ5ddEm2596zZC3IE1NiuNiyiOjLlmsID3jVhgzcNNDGYQNjc6A1rsW/QLqPGOgMX2PjCA/UYHv19NrDlfsczC2SfSMpGrD3lUeLXiAj3mon40MAkIkq9OcC6wVAOjevfuPZtLooQ/M+p/3/rkMD9RFZAewWKxhNJN0Ijd/ZZI2vbCnBB0k6wVOz57XEYaAFbqWEu6WLRGfc5I/GALTQLA10zYe8rJULxK44Dxg4NLVgYxwrJMZF6rOJblZgnqAY+xUf6B6MZgt3u4YhMHy9YwAcBlvF5+iMTsnu8pVQVlIzHTRGftvaVdTNr8dkDtci61xxmQZMQ6MpxWp20cbJqSLrsWSt1feOnxfuN3ZamEcZKyAVK8kBFWmFaqaQXBq6L4KDEM/KDLlD/F8caQ7gjVeXNzf8dRX7O9WcmIVRw5IelBTO2Rkzuhe70Jp18xyUAiQW1TY1KC0sJX3Ha4Zxg6G4JC1YRuX3cOAN5le5efXzTu8YKKKaysjVJPkCU0nvkICwVnSJiGcz8A/XZMbEbJg23Kvnlb92DgC995thKtbmkbzHMG5UzPWkTTcCbXKX3NG14Gk69QtKaq9luvfoTxX+WnHhSKaxzC7daJ0Oo4wQhMXk05jdmIRtFIa1qUK0iYOIrZfuLfwX9JitYSaY7VnQJA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTJsald3RGd0U2VnMXhVWW43eEEwc21IL0tDeWs2V2JtOVU4WDh0b0Exdmkz?=
 =?utf-8?B?YkNyelhPMllPK1Nwd2YyTytUNWo4aW1aS1gxSmdEYkViUW1SaWo1S3JkT2NN?=
 =?utf-8?B?ejlVUWkrNTBLdHNvdGpPQWd0M0FPM3Y0NHVQNU5PdCtUam1aWU4vaE1yT0VK?=
 =?utf-8?B?UXhEeHE4S24rcEYwTVp1blMzeHZHb3VpZFp6aDJKT1NqSGRFS0V4MFNoeS9w?=
 =?utf-8?B?TlhJQjdWekpET3h0d0VabFc0SjEvNWpGRGY4dXlLTXg0aTRCeHJFWWRwckhz?=
 =?utf-8?B?ZnYxWXB3bDVaaElCcUREZllsOWZNU3FESlJvVFpXRWliMkFqRXZMWU1FeDVu?=
 =?utf-8?B?UXJ4RGNlQlNDQ2hMaXM0Tkx1N0JWSEEybGF4MU1KMW82S29TenYvR2hjR3ZV?=
 =?utf-8?B?cjlUS0owRjlyRmRCVldmdUZMOGpHeHE2aDBTRkt3MHJybTRzR1IwdDNZRnd0?=
 =?utf-8?B?U1dTa0o4Z3JjMmYzNmpFWW10T3BkSHlNL005c01mS3VmeHBjdmFKTS8wcHVv?=
 =?utf-8?B?UDZjdGdqZDl1Z2V5bEVHR050UGRIQTAraUFLWFg5cjVtT0dYaDRlYWtFSGYv?=
 =?utf-8?B?OWRONUJWbGRxWnVHMng3am96ZWgrKzRZZ00wNXVjZHd4dktNNGF3SmRQS2JD?=
 =?utf-8?B?cWNCZG9PSmplOHF3bER4Y2RLdmlrZndWemkxQmxQRU9yZHVhVm5VY0dQWnQw?=
 =?utf-8?B?VW0vbzBqb0szQjFHVzR4OXhpc0JkN1VqNHlEWFNLYTEzUTg1MFY4UGY4ODdh?=
 =?utf-8?B?YWtmSXZvQmRkSTdQdzc0bnJpWlF2OHczNWR5aVBSWUdoYmFoZkwyeFdwdzRQ?=
 =?utf-8?B?aDJaRG0vQm14dXVRUllhY1BPSkNWeUtGOW03OUFGdmVuS0ZNMlF0SUd4d3VJ?=
 =?utf-8?B?aWFlUW1sZlJ0V2plc1E3aUtPRkU5M1B3K0lqNWNSaHREVnZyTEYrME42QVNs?=
 =?utf-8?B?YUFuYTM3eWowWDcrblFqaHRBS0MzNHNxa1Q5emg2Mk00cmZkRjAwblAzWFpm?=
 =?utf-8?B?ZlM0bmRST2VGQnQ1cU1HSHVTZlBwdUk1VWNOaCtHc2FoTE1EYTJGZS9BQ1Rm?=
 =?utf-8?B?MThwdGJzRG1YZC9QdDBWRnRTL2dnUjFWUTBJYjBNbjFHVkhCYWNTRFZQZ1Av?=
 =?utf-8?B?bXVtQmNFVXh3Rm82RmZHKzV3blo0R2ZDWXg3N0QyVEpNbmxwa0hLdmxrS2RY?=
 =?utf-8?B?Tnh1Q1BWMGV3ZmFVZUQ4SnVZRTRoWXRFckNmRGJZOFo0aktsN3ZsWnAwL1p4?=
 =?utf-8?B?T1AxZTA4L2l0aXE2dXBCNjk4c0FhS1haU0pxUWIxa0JRUE1uNEVheFhZNkwr?=
 =?utf-8?B?enV2eWxGOFpNa20vSk5VMDJDY2twbU5icnlZcmRQRzR5RlJCNFJxa0NBSktu?=
 =?utf-8?B?N3N3SFNwWGF6NWZvQnR5cUVIQS8wRm4rTW9hYW04czltZE5wM29rVXhKSnNF?=
 =?utf-8?B?bmNnOHhYUkhRRkdXQlc3VTNhK05DWi9nejZFZnZOZmJFaUZNOFo4ZlZWdTJ0?=
 =?utf-8?B?NC9qSkpvbTh0U0txN3dIL3hPbEN5dmZnK3A4MFZvcWpFNjE3VFNRTU1jeXlE?=
 =?utf-8?B?NjQ1U3B1SCtYb0lXRXQ1dWIzSmFjcFo1eDg3OENGREVKSEZpb1IrWHF4MkhB?=
 =?utf-8?B?NXkxSmlXa2x4b1lQdno5dWN5OXZmRVJtbVI3S2ZidzBTZHJ4N0V3WEZLUHZT?=
 =?utf-8?B?bk1JUGlkdUFlYTBQUEZCbFNIM0IwWXNJMjNubms1NmZTL3M1cDdSNlNiYzU1?=
 =?utf-8?B?Yk9nQWI0RTlVTVp0Ry9zZit3WkIwR1RVRWs0YnRMMGZneUhRaUh3NmRLSkQ0?=
 =?utf-8?B?eTByR0l0em90YkhHRFJndG5Md2FJWHdLODRGaUMveVhqZVJrL0VFYTArcW54?=
 =?utf-8?B?WVdONUdNMW1aeUZoNDlQQTJPbjl4eEh1c29kN04zTkk5c3RZcmhvdytkTGRC?=
 =?utf-8?B?VWlreUFpZkIzaTQvZHNuOFpUa29NRVRPaS94eVpTRzc5UFdTUXdEWVNTV2Iz?=
 =?utf-8?B?ZFRTNCs4SXFzZVZIS3U4clNhZFV6UmxGNkFDNzkwVVdqalV0VFp0allyclVO?=
 =?utf-8?B?NzMzRnJWcS96VDFTKzlZTGt2UzZUTVhJUTBVWWd2WEtKajJMTnAxYm4rMm9H?=
 =?utf-8?B?bWFJTGVZWTZxZmt0THJtT3I1ZFdTVjhJRkJMVWNBenE1UEhzOUNVTmRwZzcy?=
 =?utf-8?B?RzkwU2dPNDFVcEtsanlXQ00rY2YxR1FweWhCWHJDUWpUTHA5MkNKeGxsMGFJ?=
 =?utf-8?B?TGhkbG1KTE5KSWRDQWxoRFpQRzQwS3pWQXQ3WWNtQ3pzbVp2d2ZkUThlemtV?=
 =?utf-8?B?MDdibHpNRGI3RXR0a1NFZ0JrY0FLQVdYSU5IZjZaZkMzeTExWkxBYWFvYnJU?=
 =?utf-8?Q?RD8RpzoBb0sItsy03/uJsw1BF2Xyz6aOjJaWo?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06fd20a-8340-4cba-41da-08df2af1b84e
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 19:22:58.0606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7CmmH8UJsaJ0JmM2j6fwp+8smtF3RKUr+OcPR0KMn+SPdJQmRa1tshwV7e4CtoNACDbrh5b3YApExfm+wxQrT4O6fpN169Ctm2G9Wzg3rQB90StYEvnEX7xCdhO69dr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB358405

From: Frank Li <Frank.Li@nxp.com>

Remove the dependency on the async_tx framework from dm-integrity's
xor_journal() function.  The async_xor() + async_tx_issue_pending_all()
pattern is replaced with direct kmap_local_page() + memcpy() +
crypto_xor() + kunmap_local() per page, which is simpler and removes
the need for #include <linux/async_tx.h>.

async_tx adds significant complexity and maintenance overhead while
providing little practical benefit on modern systems, where RAID parity
computation is typically performed more efficiently by CPU-based XOR/PQ
implementations than by DMA engine offload.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/md/dm-integrity.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 802b377613b06..6bd0623b6402a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -23,7 +23,6 @@
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
 #include <crypto/utils.h>
-#include <linux/async_tx.h>
 #include <linux/dm-bufio.h>
 
 #include "dm-audit.h"
@@ -896,7 +895,6 @@ static void complete_journal_op(void *context)
 static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int section,
 			unsigned int n_sections, struct journal_completion *comp)
 {
-	struct async_submit_ctl submit;
 	size_t n_bytes = (size_t)(n_sections * ic->journal_section_sectors) << SECTOR_SHIFT;
 	unsigned int pl_index, pl_offset, section_index;
 	struct page_list *source_pl, *target_pl;
@@ -913,14 +911,11 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
 
 	atomic_add(roundup(pl_offset + n_bytes, PAGE_SIZE) >> PAGE_SHIFT, &comp->in_flight);
 
-	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL, complete_journal_op, comp, NULL);
-
 	section_index = pl_index;
 
 	do {
 		size_t this_step;
-		struct page *src_pages[2];
-		struct page *dst_page;
+		void *src0, *src1, *dst;
 
 		while (unlikely(pl_index == section_index)) {
 			unsigned int dummy;
@@ -935,11 +930,20 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
 		}
 
 		this_step = min(n_bytes, (size_t)PAGE_SIZE - pl_offset);
-		dst_page = target_pl[pl_index].page;
-		src_pages[0] = source_pl[pl_index].page;
-		src_pages[1] = ic->journal_xor[pl_index].page;
 
-		async_xor(dst_page, src_pages, pl_offset, 2, this_step, &submit);
+		src0 = kmap_local_page(source_pl[pl_index].page);
+		src1 = kmap_local_page(ic->journal_xor[pl_index].page);
+		dst  = kmap_local_page(target_pl[pl_index].page);
+
+		memcpy(dst + pl_offset, src0 + pl_offset, this_step);
+		crypto_xor(dst + pl_offset, src1 + pl_offset, this_step);
+
+		kunmap_local(dst);
+		kunmap_local(src1);
+		kunmap_local(src0);
+
+		/* mirror async_tx per-page completion accounting */
+		complete_journal_op(comp);
 
 		pl_index++;
 		pl_offset = 0;
@@ -947,8 +951,6 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
 	} while (n_bytes);
 
 	BUG_ON(n_sections);
-
-	async_tx_issue_pending_all();
 }
 
 static void complete_journal_encrypt(void *data, int err)

-- 
2.43.0

