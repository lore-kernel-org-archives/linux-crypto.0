Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010024.outbound.protection.outlook.com [52.101.69.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776D55616CF;
	Thu, 15 Oct 2026 19:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092195; cv=fail; b=B1XefjEV9PKwzw+mUirWMYZCbnMacgOIMl4GPahRjFozfpnTOq0KMa+rYYj6K9KYOM9jrDZFkKpSUhWbGBNbV+1n3EwjP7dOcb3jEVq0IHH79QoQRKNKSCBNAL3HfoHI2DHeU56Ur7l5QrgHdDKVklrliNJH66bCC2f4R4j2nw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092195; c=relaxed/simple;
	bh=hz0ZP6bofOK+iTst0k2E2CwWKaGhTh5Xr8h+r4GDADE=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=aIARxoimLq6J0ZxQh1X8DkLTHDa4qjfUCtopIaJjw7jtH67/iswxNXWL2DS+S4sFmUTJ5Sk9zUOz5Vmjss81nx8Sn0u/sfTr/96RVAOMXYzJwEQYAIBu9VLcydU9ulQ+mKiO0bUZfe1sW8M1h7714HaMHfYQ1rgBjtOb/2KJLLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=uz3omGZD; arc=fail smtp.client-ip=52.101.69.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="uz3omGZD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X3RIs5kHrTFTTr/IZUsY9Zr2ftlFKSLgv0o1u99BhOOwTwyujkywulhSDzASrSTNrWYlGKl3ntgsDoFH0iW2V8OxUKsvTK10v6EV2/L32KahNcGZFiZOefqEzadk7FHrm0LO36KP0tAuVGeYBXo6QUXM8N0B3lypnipFLYEAnJje/1uGT5gRVS9cEynC21IdLKfGMQwG9OlUlzLE4pBik0h4JWr+BWfWl71XiAZ7wg/Nu0qybXnHd9VP8edX7UhuGGvXhYvvinJhhE+pwutOJL3Ep5l29kiUhDDItAKLHJTHv4xh3azG/KRPLcE3/Fot/OI7bnOp0kGvnz+y+BgYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDnlCzKBCk7g9Bdio+Li1q3osbS9MmPbV97SeJPxX9Y=;
 b=mL8VNjpcYYze0nu3E3lRfRwG6qRzrGHs1umgQqp27YiagLUqxXst1YeiF6CsbDaJKcrnSyWBBM6HF0fs1T+FWkaS+4h2+vXxV14jceX7a9HIcOZDImJtw1nZji9MqVB+6HjUbJjTKCgzcuboC27MYV1SIWnTsDNlHOscHWNh9fxdWvnGOPWBzJjVSDPseZhCRP3vBTlIjMetuNIUReaNAtDlf5m3ld76+xq1DqDYT+CHhg9045bipBQgRGMj0XArj+1xHV+sexWE/h0+Dw3mmZIUx2ubg3ot+54g7O/2t1Ghpj8gD6rrLJLQ7IXVKtIphm80Yl/dSS2KEL5v2ao6vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDnlCzKBCk7g9Bdio+Li1q3osbS9MmPbV97SeJPxX9Y=;
 b=uz3omGZDzhLq6aW59lEzW+wpyN36fl8h1YZkZrMAWFZzPxDhv+e6ExHl0A5BlXDPqUg3cAtiP4H2rFJVxw5EmbMK4Hf3wNuCLeY4HKgJYgqdpRPr0aHyi20bhBL2pxu8ubf47hfkffn5HvRG+hvKJxoLRokwXD2Joohu7oZjWsHQYmTanUPSQAn2Z5bmFXF5p/QPOsbYUICL4NeB1EvWn6gMsY1+BENFrfsW9h0u7ye6LcxZDO4TjpJCk6D5si9rThp1mizKFTaA951eohUgusEMo5ye5dOC7Aj8kr/5+zNnfXqn3CU3myr403hsqWOkcDUaOBYT19NkRNu8DxOXwQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MIWPR04MB358405.eurprd04.prod.outlook.com (2603:10a6:290:ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 19:23:08 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 19:23:08 +0000
From: Frank.Li@oss.nxp.com
Date: Thu, 15 Oct 2026 15:22:27 -0400
Subject: [PATCH RFC 3/4] md/raid5: replace async_tx with synchronous xor/pq
 operations
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-asycn_tx_remove-v1-3-056a7085e0a1@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792092167; l=32431;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=b4XhVlEH+imRIJgU0u9khMc4yfRtfaHpzFEsq8xIJJU=;
 b=qtQcIJ0soLqAOiFJKAJPQvvP34WEI0Hd9Y1+Xi6CH+vV4xzTS9rkzG+iHtIZ7owZr2kV00PcV
 laXnBJPNqOEAHN2b8ql/+UDQ7P4nmA/CYY8GD7rsyXtRf8S40CudBYH
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: SJ0PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::11) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MIWPR04MB358405:EE_
X-MS-Office365-Filtering-Correlation-Id: d2819a72-d0fe-48c7-bdf9-08df2af1be9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|19092799006|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|921020|11063799006|260925021311599003|260925021911599003|260925022911599003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	3lQv7cTrppg8iVudd071gH5T0TbxZgwIIR5hi8f2IwFeLZ7ZjP7NGn1EPY1wYQly73nOop9XtRfXf/p+gkdBIf5nSkVnrN2vOGTDXGGJ7QM89fzviauTls7IXFcU78l0XSD5pcr9kk9qilQQsibMLIjE61HfMNyvZvbujnjMnJFlBTq+ZkjwM93qnG1uprYYKLSGP/TVSAFDqoLzzphugExXU/Y+vz/00a0DPtOUOMLBbvSWXzEzVWj8c9gyg3+Fibybj+zUf8T4qcAiRX4rWpAb4gMNCd+CpdXNpUcl9zx0GzYaGFc5GsoVwJY8gosGV4JxdRNd3nIsbJ5tzPXCb2/D6FKQQmCkRbTuoD1weS0VYDhwmfKKKxX+Gu5Ybd8XWhKR2dRpPZbSPUYi3ree1RfOq3M5CzRlgyFhqvmufrKLqxmN6ipUhUcqRTTttRTg34CFxmj38VQeI5EZBBNY8Bt9EFEkdnmmM33zvf6ytxBZiHBz2NP6fVqtFFXlXJTS943nZpy9OoyWtytJDEd7y4l7DpB49vSydyBnPiIfb7a9cWYOwghZQsVqMoM68nmFWfq1VdTH8JNcbhgcXe/aK2bKKEs1d+byWjKZ4GqRZXk3ceRvIsXCEDxjrb9v8GsDTn2CBvQ16zqHEmhEiW4YFW74NurPC3F6Qa94WvbcTtqz2rtulBYoQ1+60GbyUqSd9M4SiT6JH04hXTxFmdKvMw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(921020)(11063799006)(260925021311599003)(260925021911599003)(260925022911599003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dU1KdFJQNERFUllGNUFSOVFuT0tZaEc1MW1RRitpOXg0dTI5ditGYmhvdHhH?=
 =?utf-8?B?NDkrVVNHZFFFNUR4U0Z5OUJtZWVvdFlIM2NwZWVMRnVqdFI2aXB2bTFjYWFi?=
 =?utf-8?B?MHM2VXhmMXV0YUc2WHI5dmhxSG9ucTZJaEg0emRDM3dzMzZiNU1EV2toZkxY?=
 =?utf-8?B?OTVyZ2xaenNXbDllMlNVTStOOUJzMjNDNFhwZi90KzEwSTRMajJYRHVZb2I0?=
 =?utf-8?B?aXowZC8rbUJCUENDTDVrRjA2cW5jVmtOSmYvZjhhbmhpeXF3b3NMdHJHczhh?=
 =?utf-8?B?aEtIQzhHU0lLTGtVd0FFZW9TUDBETmVLRWN3cnE4NlYrMFU0K0NLT29DVUI3?=
 =?utf-8?B?Mm5EdS9zS0M2YzVaL2xvcWJqZko1YktrVW9JZmhkSkVwYWhPNS9NWm8vaUVn?=
 =?utf-8?B?aVdDSSszT2NiWXljS0VFNjlyelRaQk5NVTZXdXBhNk9mU1U1b1dYd0w4cU0y?=
 =?utf-8?B?dEdPOGVuWWMxc2NpMkppRFJsdkVwWklscFoyU25aOFBaY3g3eWtnOFR2M296?=
 =?utf-8?B?YVpHamVhM09YWDhjT2g1ODVlMzhVR0Rta0FrZUhoYkR4a1IwYzMranBBazla?=
 =?utf-8?B?R3RtVzBic2VlZTRsNXhBMTdyYkh2ejhEdmcwbEsrZHVYeHBKQlR3RWlNeHpS?=
 =?utf-8?B?SVV4SCs4WnZZR0ZURmthalhwbk1Yb1Y1RUFMNkU3Zk1Jd2RzbStVVHlCYWh0?=
 =?utf-8?B?cm01V3VIdUhFakR2REY1ZWdCenpIN2RuQkVnY3JWM0sxaTJzM1V3cHplSTZ6?=
 =?utf-8?B?UkdQblpCMGNOV3A5RzBQdWM2eTVXb0haeXFWVVp3eGN5VUtjdXRsdlROeDV2?=
 =?utf-8?B?MThxMTZ3T2ZpamM0blo0QVplcFFaUmJ0QnVDVVJTcFdwRGRVZ1VaMWZIVHdR?=
 =?utf-8?B?Mnd3WkRsZEE4ZmFjU1M1dnBFS2dCVXBYSzQyS2tKZlBGV0J0S2pRQ0Y4Ymo5?=
 =?utf-8?B?aENDellsNXNIc2ViVzQ3QjBWUkhvYkdYaTBmVStTbnMvanZKOUptOWcwYk00?=
 =?utf-8?B?L3NQa0NXVkZXaTIyVGx5T0d3MEEwU2tVOEFhRC8wVVdPVXVEZDAwNUlTT2lY?=
 =?utf-8?B?MlhtMlZKd1k1alNLNkdpdXFwL2IwUytJSHhPaDcxZ3pBS09TeUpEOVBIM25D?=
 =?utf-8?B?UldldXp4TkN5WU9jNWlzRk1HUVdoQ0ZNQlRVK0UrTkd5Vk53ZWFiV0xuU0Uv?=
 =?utf-8?B?RXZLckVydFQ1ZTA1QllpTEJKODFMNXVKYitzZHhIWXl5QzFZcWVITWhnRTVr?=
 =?utf-8?B?dkZoWVBqcU9vSlRSWElhaHRvZWxUTC9vcjk0OWtXOXFoVXRrZWUxcjNYZjNw?=
 =?utf-8?B?aDRwdmJoZStQL25MNitZTThGSWpoUGpBWnpZUHBlWGVyOHpxUGVQUmRnLzUz?=
 =?utf-8?B?d0t1OEp0U3BhNnVVMUdON2FON3FLVlBJRmhFYjZKMmV0cmpycEZyMDFvNVI4?=
 =?utf-8?B?UzRLTWhVWlNFRGFGYjd2K3RtTmhZZE5hNnNjSlFiZWFiT0ZqcWttQktWTzBi?=
 =?utf-8?B?QTRtcEd0NC9Kb1h0Y0VrUlh0aGk2M2xSUW5Sa0lTTFNSNzBCRXloY2thdk5H?=
 =?utf-8?B?WUZkTWlZS1ZNLzl4aUI5bnNUQzEzVnU2WHo1WXFQcVgwTEZwdGZSTTNlaVBH?=
 =?utf-8?B?TDJMbDl2WDhaMUdHSHhOWHVNWmNkVElwMEsrdlNkSUhrbVRQWTBjYm12bmlu?=
 =?utf-8?B?aW9SN1hJRWZJMHgvUzd5RS91dGpScithY1RhSWxHZHBIWFJiSzh5ejRCVDN2?=
 =?utf-8?B?T21HVWNUaUMyam54TzlreTlrTUVSK3UvaXk3Z3lSdTVnMnBZWmVPQWZ5dmxt?=
 =?utf-8?B?dUhhd0hZeUJOaFQyT05tZkhxN3IvZWpod2RvU0JJK05qOEdtN1ZLSlJsd2VT?=
 =?utf-8?B?UStwUVVkZityY1IyM3Rzc2V0TGJsdWFEQlFRWVVOYXNBV3o1N01MejJpMlJW?=
 =?utf-8?B?U3NiSkJHRzNndGwxcmswT0ltQUJWRlpWQTRXbkZjVWc0VjFNSVgzMGd2MjE1?=
 =?utf-8?B?aVdVc1NZclRHSkNFMzBYVDNLQlB6Nm5jMTh0enR0Y25EVjB6TTBCMUdzcE5O?=
 =?utf-8?B?NXUzaUk1VkdBUlJZZG9LN3AraXVMNnljOFRQS09LL1hhL2s2SEJ6ODhja1ZC?=
 =?utf-8?B?SURQN1BVNEpmRDVTMjVaWDNZWllJdENhbVdDUzI0MWRwZTYvYzVyMXloNzFX?=
 =?utf-8?B?WGZjSk1vMVhBdS91Z0ppQ2NDNUJKK2tpMHd2d01PbjJJNjBtc3pmMlRLTGgr?=
 =?utf-8?B?VkErRGVGVHI1SU55QkpjKzJEdnNURmFyNTlJRFM0WHkydlJrNjlQUHBCTlJ6?=
 =?utf-8?B?Nk1MZ21ZeWl4cWdkY1lteVY0dktRY2tTdWhkQWZObTMydkM2M08rNmpMRkdX?=
 =?utf-8?Q?KHBRxYvN3ZtqlADJcMWGadpTqu5Fh7gpHyUoB?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2819a72-d0fe-48c7-bdf9-08df2af1be9b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 19:23:08.6754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKIA/K5vcyqx7KXXmDVNxdOn+Dnn3fiBTwWOleXgF9wCLLpaNlXHxHzlJyMmdOGZPM7i33NB1rDIGj2BRTv1iUhWpVOamZzT7QlIbexgvCXa3KhJk7IWBJF/E+a75zi4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB358405

From: Frank Li <Frank.Li@nxp.com>

Remove all async_tx usage from drivers/md/raid5.c. Replace each
async operation with its synchronous equivalent:

- async_copy_data()     -> sync_copy_data() using kmap_local_page/memcpy
- async_memcpy()        -> memcpy() directly on page_address()
- async_xor_offs() ZERO_DST -> memset(dst,0) + xor_gen()
- async_xor_offs() DROP_DST -> xor_gen() (dest included in src ptrs)
- async_gen_syndrome()  -> raid6_gen_syndrome()
- async_gen_syndrome() PQ_XOR_DST -> raid6_xor_syndrome()
- async_raid6_datap_recov() -> raid6_datap_recov()
- async_raid6_2data_recov() -> raid6_2data_recov()
- async_xor_val_offs()  -> xor_gen() + memchr_inv()
- async_syndrome_val()  -> xor_gen() + raid6_gen_syndrome() + memcmp()
- async_trigger_callback() -> direct callback invocation
- async_tx_quiesce()    -> removed (synchronous, no-op needed)
- async_tx_issue_pending_all() -> removed (no-op)

Also remove the addr_conv_t region from the scribble buffer and
the to_addr_conv() helper since DMA address conversion is no
longer needed.

async_tx adds significant complexity and maintenance overhead while
providing little practical benefit on modern systems, where RAID parity
computation is typically performed more efficiently by CPU-based XOR/PQ
implementations than by DMA engine offload.

Replace #include <linux/async_tx.h> with #include <linux/raid/xor.h>.
---
 drivers/md/raid5-log.h |   4 +-
 drivers/md/raid5.c     | 467 ++++++++++++++++++++++++++-----------------------
 2 files changed, 251 insertions(+), 220 deletions(-)

diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
index c8332502669e5..52408067a40cb 100644
--- a/drivers/md/raid5-log.h
+++ b/drivers/md/raid5-log.h
@@ -31,9 +31,7 @@ void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev);
 bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
 int r5l_start(struct r5l_log *log);
 
-struct dma_async_tx_descriptor *
-ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
-		       struct dma_async_tx_descriptor *tx);
+void ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu);
 int ppl_init_log(struct r5conf *conf);
 void ppl_exit_log(struct r5conf *conf);
 int ppl_write_stripe(struct r5conf *conf, struct stripe_head *sh);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090de..b1121e6f4bfbe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -38,7 +38,7 @@
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
-#include <linux/async_tx.h>
+#include <linux/raid/xor.h>
 #include <linux/module.h>
 #include <linux/async.h>
 #include <linux/seq_file.h>
@@ -1373,17 +1373,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		defer_issue_bios(conf, head_sh->sector, &pending_bios);
 }
 
-static struct dma_async_tx_descriptor *
-async_copy_data(int frombio, struct bio *bio, struct page **page,
-	unsigned int poff, sector_t sector, struct dma_async_tx_descriptor *tx,
-	struct stripe_head *sh, int no_skipcopy)
+static void sync_copy_data(int frombio, struct bio *bio, struct page **page,
+	unsigned int poff, sector_t sector, struct stripe_head *sh,
+	int no_skipcopy)
 {
 	struct bio_vec bvl;
 	struct bvec_iter iter;
 	struct page *bio_page;
 	int page_offset;
-	struct async_submit_ctl submit;
-	enum async_tx_flags flags = 0;
 	struct r5conf *conf = sh->raid_conf;
 
 	if (bio->bi_iter.bi_sector >= sector)
@@ -1391,10 +1388,6 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 	else
 		page_offset = (signed)(sector - bio->bi_iter.bi_sector) * -512;
 
-	if (frombio)
-		flags |= ASYNC_TX_FENCE;
-	init_async_submit(&submit, flags, tx, NULL, NULL, NULL);
-
 	bio_for_each_segment(bvl, bio, iter) {
 		int len = bvl.bv_len;
 		int clen;
@@ -1412,30 +1405,34 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 			clen = len;
 
 		if (clen > 0) {
+			void *dst, *src;
+
 			b_offset += bvl.bv_offset;
 			bio_page = bvl.bv_page;
 			if (frombio) {
 				if (conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
 				    clen == RAID5_STRIPE_SIZE(conf) &&
-				    !no_skipcopy)
+				    !no_skipcopy) {
 					*page = bio_page;
-				else
-					tx = async_memcpy(*page, bio_page, page_offset + poff,
-						  b_offset, clen, &submit);
-			} else
-				tx = async_memcpy(bio_page, *page, b_offset,
-						  page_offset + poff, clen, &submit);
+				} else {
+					src = kmap_local_page(bio_page) + b_offset;
+					dst = page_address(*page) + page_offset + poff;
+					memcpy(dst, src, clen);
+					kunmap_local(src);
+				}
+			} else {
+				dst = kmap_local_page(bio_page) + b_offset;
+				src = page_address(*page) + page_offset + poff;
+				memcpy(dst, src, clen);
+				kunmap_local(dst);
+			}
 		}
-		/* chain the operations */
-		submit.depend_tx = tx;
 
 		if (clen < len) /* hit end of page */
 			break;
-		page_offset +=  len;
+		page_offset += len;
 	}
-
-	return tx;
 }
 
 static void ops_complete_biofill(void *stripe_head_ref)
@@ -1478,8 +1475,6 @@ static void ops_complete_biofill(void *stripe_head_ref)
 
 static void ops_run_biofill(struct stripe_head *sh)
 {
-	struct dma_async_tx_descriptor *tx = NULL;
-	struct async_submit_ctl submit;
 	int i;
 	struct r5conf *conf = sh->raid_conf;
 
@@ -1497,17 +1492,15 @@ static void ops_run_biofill(struct stripe_head *sh)
 			spin_unlock_irq(&sh->stripe_lock);
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + RAID5_STRIPE_SECTORS(conf)) {
-				tx = async_copy_data(0, rbi, &dev->page,
-						     dev->offset,
-						     dev->sector, tx, sh, 0);
+				sync_copy_data(0, rbi, &dev->page,
+					       dev->offset, dev->sector, sh, 0);
 				rbi = r5_next_bio(conf, rbi, dev->sector);
 			}
 		}
 	}
 
 	atomic_inc(&sh->count);
-	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_biofill, sh, NULL);
-	async_trigger_callback(&submit);
+	ops_complete_biofill(sh);
 }
 
 static void mark_target_uptodate(struct stripe_head *sh, int target)
@@ -1541,30 +1534,20 @@ static void ops_complete_compute(void *stripe_head_ref)
 	raid5_release_stripe(sh);
 }
 
-/* return a pointer to the address conversion region of the scribble buffer */
+/* return a pointer to the page-pointer region of the scribble buffer */
 static struct page **to_addr_page(struct raid5_percpu *percpu, int i)
 {
 	return percpu->scribble + i * percpu->scribble_obj_size;
 }
 
-/* return a pointer to the address conversion region of the scribble buffer */
-static addr_conv_t *to_addr_conv(struct stripe_head *sh,
-				 struct raid5_percpu *percpu, int i)
-{
-	return (void *) (to_addr_page(percpu, i) + sh->disks + 2);
-}
-
-/*
- * Return a pointer to record offset address.
- */
+/* return a pointer to the offset array in the scribble buffer */
 static unsigned int *
 to_addr_offs(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
-	return (unsigned int *) (to_addr_conv(sh, percpu, 0) + sh->disks + 2);
+	return (unsigned int *) (to_addr_page(percpu, 0) + sh->disks + 2);
 }
 
-static struct dma_async_tx_descriptor *
-ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
+static void ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
@@ -1573,9 +1556,10 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 	struct r5dev *tgt = &sh->dev[target];
 	struct page *xor_dest = tgt->page;
 	unsigned int off_dest = tgt->offset;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
 	int count = 0;
-	struct dma_async_tx_descriptor *tx;
-	struct async_submit_ctl submit;
+	void **ptrs = (void **)xor_srcs;
+	void *dst;
 	int i;
 
 	BUG_ON(sh->batch_head);
@@ -1593,16 +1577,17 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 
 	atomic_inc(&sh->count);
 
-	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
-			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
-	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
-				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
-	else
-		tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
-				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
+	dst = page_address(xor_dest) + off_dest;
+	if (unlikely(count == 1)) {
+		memcpy(dst, page_address(xor_srcs[0]) + off_srcs[0], len);
+	} else {
+		for (i = 0; i < count; i++)
+			ptrs[i] = page_address(xor_srcs[i]) + off_srcs[i];
+		memset(dst, 0, len);
+		xor_gen(dst, ptrs, count, len);
+	}
 
-	return tx;
+	ops_complete_compute(sh);
 }
 
 /* set_syndrome_sources - populate source buffers for gen_syndrome
@@ -1660,19 +1645,18 @@ static int set_syndrome_sources(struct page **srcs,
 	return syndrome_disks;
 }
 
-static struct dma_async_tx_descriptor *
-ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
+static void ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **blocks = to_addr_page(percpu, 0);
 	unsigned int *offs = to_addr_offs(sh, percpu);
 	int target;
 	int qd_idx = sh->qd_idx;
-	struct dma_async_tx_descriptor *tx;
-	struct async_submit_ctl submit;
 	struct r5dev *tgt;
 	struct page *dest;
 	unsigned int dest_off;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
+	void **ptrs = (void **)blocks;
 	int i;
 	int count;
 
@@ -1699,13 +1683,17 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 		count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_ALL);
 		blocks[count] = NULL; /* regenerating p is not necessary */
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
-		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
-				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu, 0));
-		tx = async_gen_syndrome(blocks, offs, count+2,
-				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
+		for (i = 0; i < count+2; i++) {
+			if (blocks[i])
+				ptrs[i] = page_address(blocks[i]) + offs[i];
+			else
+				ptrs[i] = NULL;
+		}
+		raid6_gen_syndrome(count+2, len, ptrs);
 	} else {
 		/* Compute any data- or p-drive using XOR */
+		void *dst = page_address(dest) + dest_off;
+
 		count = 0;
 		for (i = disks; i-- ; ) {
 			if (i == target || i == qd_idx)
@@ -1713,19 +1701,16 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 			offs[count] = sh->dev[i].offset;
 			blocks[count++] = sh->dev[i].page;
 		}
-
-		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
-				  NULL, ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu, 0));
-		tx = async_xor_offs(dest, dest_off, blocks, offs, count,
-				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
+		for (i = 0; i < count; i++)
+			ptrs[i] = page_address(blocks[i]) + offs[i];
+		memset(dst, 0, len);
+		xor_gen(dst, ptrs, count, len);
 	}
 
-	return tx;
+	ops_complete_compute(sh);
 }
 
-static struct dma_async_tx_descriptor *
-ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
+static void ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int i, count, disks = sh->disks;
 	int syndrome_disks = sh->ddf_layout ? disks : disks-2;
@@ -1735,10 +1720,10 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	int target2 = sh->ops.target2;
 	struct r5dev *tgt = &sh->dev[target];
 	struct r5dev *tgt2 = &sh->dev[target2];
-	struct dma_async_tx_descriptor *tx;
 	struct page **blocks = to_addr_page(percpu, 0);
 	unsigned int *offs = to_addr_offs(sh, percpu);
-	struct async_submit_ctl submit;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
+	void **ptrs = (void **)blocks;
 
 	BUG_ON(sh->batch_head);
 	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
@@ -1781,17 +1766,19 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 		/* Q disk is one of the missing disks */
 		if (faila == syndrome_disks) {
 			/* Missing P+Q, just recompute */
-			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
-					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, offs, syndrome_disks+2,
-						  RAID5_STRIPE_SIZE(sh->raid_conf),
-						  &submit);
+			for (i = 0; i < syndrome_disks+2; i++) {
+				if (blocks[i])
+					ptrs[i] = page_address(blocks[i]) + offs[i];
+				else
+					ptrs[i] = NULL;
+			}
+			raid6_gen_syndrome(syndrome_disks+2, len, ptrs);
 		} else {
 			struct page *dest;
 			unsigned int dest_off;
 			int data_target;
 			int qd_idx = sh->qd_idx;
+			void *d;
 
 			/* Missing D+Q: recompute D from P, then recompute Q */
 			if (target == qd_idx)
@@ -1808,40 +1795,38 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			}
 			dest = sh->dev[data_target].page;
 			dest_off = sh->dev[data_target].offset;
-			init_async_submit(&submit,
-					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
-					  NULL, NULL, NULL,
-					  to_addr_conv(sh, percpu, 0));
-			tx = async_xor_offs(dest, dest_off, blocks, offs, count,
-				       RAID5_STRIPE_SIZE(sh->raid_conf),
-				       &submit);
+			d = page_address(dest) + dest_off;
+			for (i = 0; i < count; i++)
+				ptrs[i] = page_address(blocks[i]) + offs[i];
+			memset(d, 0, len);
+			xor_gen(d, ptrs, count, len);
 
 			count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_ALL);
-			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
-					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, offs, count+2,
-						  RAID5_STRIPE_SIZE(sh->raid_conf),
-						  &submit);
+			for (i = 0; i < count+2; i++) {
+				if (blocks[i])
+					ptrs[i] = page_address(blocks[i]) + offs[i];
+				else
+					ptrs[i] = NULL;
+			}
+			raid6_gen_syndrome(count+2, len, ptrs);
 		}
 	} else {
-		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
-				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu, 0));
+		for (i = 0; i < syndrome_disks+2; i++) {
+			if (blocks[i])
+				ptrs[i] = page_address(blocks[i]) + offs[i];
+			else
+				ptrs[i] = NULL;
+		}
 		if (failb == syndrome_disks) {
 			/* We're missing D+P. */
-			return async_raid6_datap_recov(syndrome_disks+2,
-						RAID5_STRIPE_SIZE(sh->raid_conf),
-						faila,
-						blocks, offs, &submit);
+			raid6_recov_datap(syndrome_disks+2, len, faila, ptrs);
 		} else {
 			/* We're missing D+D. */
-			return async_raid6_2data_recov(syndrome_disks+2,
-						RAID5_STRIPE_SIZE(sh->raid_conf),
-						faila, failb,
-						blocks, offs, &submit);
+			raid6_recov_2data(syndrome_disks+2, len, faila, failb, ptrs);
 		}
 	}
+
+	ops_complete_compute(sh);
 }
 
 static void ops_complete_prexor(void *stripe_head_ref)
@@ -1859,15 +1844,14 @@ static void ops_complete_prexor(void *stripe_head_ref)
 		r5c_release_extra_page(sh);
 }
 
-static struct dma_async_tx_descriptor *
-ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
-		struct dma_async_tx_descriptor *tx)
+static void ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
 	unsigned int *off_srcs = to_addr_offs(sh, percpu);
 	int count = 0, pd_idx = sh->pd_idx, i;
-	struct async_submit_ctl submit;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
+	void **ptrs = (void **)xor_srcs;
 
 	/* existing parity data subtracted */
 	unsigned int off_dest = off_srcs[count] = sh->dev[pd_idx].offset;
@@ -1893,38 +1877,55 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		}
 	}
 
-	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
-			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
-			RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
+	/* XOR_DROP_DST: dest (parity) is at ptrs[0], data pages follow.
+	 * xor_gen(dst, ptrs, count, len) computes dst ^= ptrs[0..count-1],
+	 * which cancels the old parity and folds in all written data. */
+	for (i = 0; i < count; i++)
+		ptrs[i] = page_address(xor_srcs[i]) + off_srcs[i];
+	xor_gen(page_address(xor_dest) + off_dest, ptrs, count, len);
 
-	return tx;
+	ops_complete_prexor(sh);
 }
 
-static struct dma_async_tx_descriptor *
-ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
-		struct dma_async_tx_descriptor *tx)
+static void ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	struct page **blocks = to_addr_page(percpu, 0);
 	unsigned int *offs = to_addr_offs(sh, percpu);
-	int count;
-	struct async_submit_ctl submit;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
+	void **ptrs = (void **)blocks;
+	int count, i, start = -1, stop = -1;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_WANT_DRAIN);
 
-	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_PQ_XOR_DST, tx,
-			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_gen_syndrome(blocks, offs, count+2,
-			RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
+	/* PQ_XOR_DST: use xor_syndrome to fold in only the changed disks */
+	for (i = 0; i < count; i++) {
+		if (blocks[i]) {
+			if (start < 0)
+				start = i;
+			stop = i;
+		}
+		if (blocks[i])
+			ptrs[i] = page_address(blocks[i]) + offs[i];
+		else
+			ptrs[i] = NULL;
+	}
+	/* P slot */
+	ptrs[count] = blocks[count] ? page_address(blocks[count]) + offs[count] : NULL;
+	/* Q slot */
+	ptrs[count+1] = blocks[count+1] ? page_address(blocks[count+1]) + offs[count+1] : NULL;
+
+	if (start >= 0 && raid6_can_xor_syndrome())
+		raid6_xor_syndrome(count+2, start, stop, len, ptrs);
+	else
+		raid6_gen_syndrome(count+2, len, ptrs);
 
-	return tx;
+	ops_complete_prexor(sh);
 }
 
-static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+static void ops_run_biodrain(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks;
@@ -1967,9 +1968,9 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 				if (bio_op(wbi) == REQ_OP_DISCARD)
 					set_bit(R5_Discard, &dev->flags);
 				else {
-					tx = async_copy_data(1, wbi, &dev->page,
+					sync_copy_data(1, wbi, &dev->page,
 							     dev->offset,
-							     dev->sector, tx, sh,
+							     dev->sector, sh,
 							     r5c_is_writeback(conf->log));
 					if (dev->page != dev->orig_page &&
 					    !r5c_is_writeback(conf->log)) {
@@ -1991,8 +1992,6 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			}
 		}
 	}
-
-	return tx;
 }
 
 static void ops_complete_reconstruct(void *stripe_head_ref)
@@ -2043,18 +2042,16 @@ static void ops_complete_reconstruct(void *stripe_head_ref)
 }
 
 static void
-ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
-		     struct dma_async_tx_descriptor *tx)
+ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **xor_srcs;
 	unsigned int *off_srcs;
-	struct async_submit_ctl submit;
 	int count, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
 	unsigned int off_dest;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
 	int prexor = 0;
-	unsigned long flags;
 	int j = 0;
 	struct stripe_head *head_sh = sh;
 	int last_stripe;
@@ -2113,45 +2110,48 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	last_stripe = !head_sh->batch_head ||
 		list_first_entry(&sh->batch_list,
 				 struct stripe_head, batch_list) == head_sh;
-	if (last_stripe) {
-		flags = ASYNC_TX_ACK |
-			(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
 
-		atomic_inc(&head_sh->count);
-		init_async_submit(&submit, flags, tx, ops_complete_reconstruct, head_sh,
-				  to_addr_conv(sh, percpu, j));
-	} else {
-		flags = prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST;
-		init_async_submit(&submit, flags, tx, NULL, NULL,
-				  to_addr_conv(sh, percpu, j));
+	{
+		void **ptrs = (void **)xor_srcs;
+		void *dst = page_address(xor_dest) + off_dest;
+
+		if (unlikely(count == 1)) {
+			if (prexor)
+				memcpy(dst, page_address(xor_srcs[0]) + off_srcs[0], len);
+			else
+				memcpy(dst, page_address(xor_srcs[0]) + off_srcs[0], len);
+		} else {
+			int k;
+
+			for (k = 0; k < count; k++)
+				ptrs[k] = page_address(xor_srcs[k]) + off_srcs[k];
+			if (!prexor)
+				memset(dst, 0, len);
+			xor_gen(dst, ptrs, count, len);
+		}
 	}
 
-	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
-				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
-	else
-		tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
-				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	if (!last_stripe) {
 		j++;
 		sh = list_first_entry(&sh->batch_list, struct stripe_head,
 				      batch_list);
 		goto again;
 	}
+
+	atomic_inc(&head_sh->count);
+	ops_complete_reconstruct(head_sh);
 }
 
 static void
-ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
-		     struct dma_async_tx_descriptor *tx)
+ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
-	struct async_submit_ctl submit;
 	struct page **blocks;
 	unsigned int *offs;
 	int count, i, j = 0;
 	struct stripe_head *head_sh = sh;
 	int last_stripe;
-	int synflags;
-	unsigned long txflags;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
+	int prexor_mode;
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
@@ -2173,34 +2173,43 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	blocks = to_addr_page(percpu, j);
 	offs = to_addr_offs(sh, percpu);
 
-	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
-		synflags = SYNDROME_SRC_WRITTEN;
-		txflags = ASYNC_TX_ACK | ASYNC_TX_PQ_XOR_DST;
-	} else {
-		synflags = SYNDROME_SRC_ALL;
-		txflags = ASYNC_TX_ACK;
-	}
-
-	count = set_syndrome_sources(blocks, offs, sh, synflags);
+	prexor_mode = (sh->reconstruct_state == reconstruct_state_prexor_drain_run);
+	count = set_syndrome_sources(blocks, offs, sh,
+				     prexor_mode ? SYNDROME_SRC_WRITTEN : SYNDROME_SRC_ALL);
 	last_stripe = !head_sh->batch_head ||
 		list_first_entry(&sh->batch_list,
 				 struct stripe_head, batch_list) == head_sh;
 
-	if (last_stripe) {
-		atomic_inc(&head_sh->count);
-		init_async_submit(&submit, txflags, tx, ops_complete_reconstruct,
-				  head_sh, to_addr_conv(sh, percpu, j));
-	} else
-		init_async_submit(&submit, 0, tx, NULL, NULL,
-				  to_addr_conv(sh, percpu, j));
-	tx = async_gen_syndrome(blocks, offs, count+2,
-			RAID5_STRIPE_SIZE(sh->raid_conf),  &submit);
+	{
+		void **ptrs = (void **)blocks;
+		int start = -1, stop = -1;
+
+		for (i = 0; i < count; i++) {
+			if (blocks[i]) {
+				if (start < 0)
+					start = i;
+				stop = i;
+			}
+			ptrs[i] = blocks[i] ? page_address(blocks[i]) + offs[i] : NULL;
+		}
+		ptrs[count]   = blocks[count]   ? page_address(blocks[count])   + offs[count]   : NULL;
+		ptrs[count+1] = blocks[count+1] ? page_address(blocks[count+1]) + offs[count+1] : NULL;
+
+		if (prexor_mode && start >= 0 && raid6_can_xor_syndrome())
+			raid6_xor_syndrome(count+2, start, stop, len, ptrs);
+		else
+			raid6_gen_syndrome(count+2, len, ptrs);
+	}
+
 	if (!last_stripe) {
 		j++;
 		sh = list_first_entry(&sh->batch_list, struct stripe_head,
 				      batch_list);
 		goto again;
 	}
+
+	atomic_inc(&head_sh->count);
+	ops_complete_reconstruct(head_sh);
 }
 
 static void ops_complete_check(void *stripe_head_ref)
@@ -2224,8 +2233,8 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	unsigned int off_dest;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
 	unsigned int *off_srcs = to_addr_offs(sh, percpu);
-	struct dma_async_tx_descriptor *tx;
-	struct async_submit_ctl submit;
+	void **ptrs = (void **)xor_srcs;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
 	int count;
 	int i;
 
@@ -2245,23 +2254,27 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 		xor_srcs[count++] = sh->dev[i].page;
 	}
 
-	init_async_submit(&submit, 0, NULL, NULL, NULL,
-			  to_addr_conv(sh, percpu, 0));
-	tx = async_xor_val_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
-			   RAID5_STRIPE_SIZE(sh->raid_conf),
-			   &sh->ops.zero_sum_result, &submit);
+	/* XOR_DROP_DST: xor_dest is ptrs[0]; xor_gen computes
+	 * xor_dest ^= xor_dest ^ data0 ^ data1 ^ ... = data XOR.
+	 * Then check whether the result is zero. */
+	for (i = 0; i < count; i++)
+		ptrs[i] = page_address(xor_srcs[i]) + off_srcs[i];
+	xor_gen(page_address(xor_dest) + off_dest, ptrs, count, len);
+	sh->ops.zero_sum_result =
+		!!memchr_inv(page_address(xor_dest) + off_dest, 0, len) << SUM_CHECK_P;
 
 	atomic_inc(&sh->count);
-	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NULL);
-	tx = async_trigger_callback(&submit);
+	ops_complete_check(sh);
 }
 
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
 	struct page **srcs = to_addr_page(percpu, 0);
 	unsigned int *offs = to_addr_offs(sh, percpu);
-	struct async_submit_ctl submit;
-	int count;
+	size_t len = RAID5_STRIPE_SIZE(sh->raid_conf);
+	struct page *spare = percpu->spare_page;
+	void **ptrs = (void **)srcs;
+	int count, i;
 
 	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
 		(unsigned long long)sh->sector, checkp);
@@ -2271,18 +2284,52 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 	if (!checkp)
 		srcs[count] = NULL;
 
+	sh->ops.zero_sum_result = 0;
 	atomic_inc(&sh->count);
-	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
-			  sh, to_addr_conv(sh, percpu, 0));
-	async_syndrome_val(srcs, offs, count+2,
-			   RAID5_STRIPE_SIZE(sh->raid_conf),
-			   &sh->ops.zero_sum_result, percpu->spare_page, 0, &submit);
+
+	if (srcs[count]) {
+		/* Check P: XOR all data into spare, compare with P. */
+		int xcnt = 0;
+		void *s = page_address(spare);
+		struct page *p_src = srcs[count];
+		unsigned int p_off = offs[count];
+
+		for (i = 0; i < count; i++) {
+			if (srcs[i])
+				ptrs[xcnt++] = page_address(srcs[i]) + offs[i];
+		}
+		memset(s, 0, len);
+		if (xcnt)
+			xor_gen(s, ptrs, xcnt, len);
+		sh->ops.zero_sum_result |=
+			!!memcmp(page_address(p_src) + p_off, s, len) << SUM_CHECK_P;
+	}
+
+	if (srcs[count+1]) {
+		/* Check Q: recompute syndrome, compare with Q. */
+		struct page *q_src = srcs[count+1];
+		unsigned int q_off = offs[count+1];
+		void *s = page_address(spare);
+
+		/* Re-populate srcs for Q-only syndrome computation. */
+		count = set_syndrome_sources(srcs, offs, sh, SYNDROME_SRC_ALL);
+		srcs[count]   = NULL;  /* skip P regen */
+		srcs[count+1] = spare;
+		offs[count+1] = 0;
+		for (i = 0; i <= count+1; i++) {
+			ptrs[i] = srcs[i] ? page_address(srcs[i]) + offs[i] : NULL;
+		}
+		raid6_gen_syndrome(count+2, len, ptrs);
+		sh->ops.zero_sum_result |=
+			!!memcmp(page_address(q_src) + q_off, s, len) << SUM_CHECK_Q;
+	}
+
+	ops_complete_check(sh);
 }
 
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
-	struct dma_async_tx_descriptor *tx = NULL;
 	struct r5conf *conf = sh->raid_conf;
 	int level = conf->level;
 	struct raid5_percpu *percpu;
@@ -2296,38 +2343,35 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 
 	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
 		if (level < 6)
-			tx = ops_run_compute5(sh, percpu);
+			ops_run_compute5(sh, percpu);
 		else {
 			if (sh->ops.target2 < 0 || sh->ops.target < 0)
-				tx = ops_run_compute6_1(sh, percpu);
+				ops_run_compute6_1(sh, percpu);
 			else
-				tx = ops_run_compute6_2(sh, percpu);
+				ops_run_compute6_2(sh, percpu);
 		}
-		/* terminate the chain if reconstruct is not set to be run */
-		if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
-			async_tx_ack(tx);
 	}
 
 	if (test_bit(STRIPE_OP_PREXOR, &ops_request)) {
 		if (level < 6)
-			tx = ops_run_prexor5(sh, percpu, tx);
+			ops_run_prexor5(sh, percpu);
 		else
-			tx = ops_run_prexor6(sh, percpu, tx);
+			ops_run_prexor6(sh, percpu);
 	}
 
 	if (test_bit(STRIPE_OP_PARTIAL_PARITY, &ops_request))
-		tx = ops_run_partial_parity(sh, percpu, tx);
+		ops_run_partial_parity(sh, percpu);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
-		tx = ops_run_biodrain(sh, tx);
+		ops_run_biodrain(sh);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_RECONSTRUCT, &ops_request)) {
 		if (level < 6)
-			ops_run_reconstruct5(sh, percpu, tx);
+			ops_run_reconstruct5(sh, percpu);
 		else
-			ops_run_reconstruct6(sh, percpu, tx);
+			ops_run_reconstruct6(sh, percpu);
 	}
 
 	if (test_bit(STRIPE_OP_CHECK, &ops_request)) {
@@ -2455,8 +2499,7 @@ static int grow_stripes(struct r5conf *conf, int num)
  *
  * The scribble buffer size must be enough to contain:
  * 1/ a struct page pointer for each device in the array +2
- * 2/ room to convert each entry in (1) to its corresponding dma
- *    (dma_map_page()) or page (page_address()) address.
+ * 2/ an unsigned int offset for each entry in (1)
  *
  * Note: the +2 is for the destination buffers of the ddf/raid6 case where we
  * calculate over all devices (not just the data blocks), using zeros in place
@@ -2467,7 +2510,6 @@ static int scribble_alloc(struct raid5_percpu *percpu,
 {
 	size_t obj_size =
 		sizeof(struct page *) * (num + 2) +
-		sizeof(addr_conv_t) * (num + 2) +
 		sizeof(unsigned int) * (num + 2);
 	void *scribble;
 
@@ -4629,14 +4671,12 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 	/* We have read all the blocks in this stripe and now we need to
 	 * copy some of them into a target stripe for expand.
 	 */
-	struct dma_async_tx_descriptor *tx = NULL;
 	BUG_ON(sh->batch_head);
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
 		if (i != sh->pd_idx && i != sh->qd_idx) {
 			int dd_idx, j;
 			struct stripe_head *sh2;
-			struct async_submit_ctl submit;
 
 			sector_t bn = raid5_compute_blocknr(sh, i, 1);
 			sector_t s = raid5_compute_sector(conf, bn, 0,
@@ -4656,12 +4696,9 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 				continue;
 			}
 
-			/* place all the copies on one channel */
-			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
-			tx = async_memcpy(sh2->dev[dd_idx].page,
-					  sh->dev[i].page, sh2->dev[dd_idx].offset,
-					  sh->dev[i].offset, RAID5_STRIPE_SIZE(conf),
-					  &submit);
+			memcpy(page_address(sh2->dev[dd_idx].page) + sh2->dev[dd_idx].offset,
+			       page_address(sh->dev[i].page) + sh->dev[i].offset,
+			       RAID5_STRIPE_SIZE(conf));
 
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
@@ -4677,8 +4714,6 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 			raid5_release_stripe(sh2);
 
 		}
-	/* done submitting copies, wait for them to complete */
-	async_tx_quiesce(&tx);
 }
 
 static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
@@ -6917,7 +6952,6 @@ static void raid5_do_work(struct work_struct *work)
 
 	r5l_flush_stripe_to_raid(conf->log);
 
-	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
 	pr_debug("--- raid5worker inactive\n");
@@ -7011,7 +7045,6 @@ static void raid5d(struct md_thread *thread)
 
 	r5l_flush_stripe_to_raid(conf->log);
 
-	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
 	pr_debug("--- raid5d inactive\n");

-- 
2.43.0

