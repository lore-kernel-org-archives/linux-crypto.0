Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2076.outbound.protection.outlook.com [40.107.215.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A6514D431
	for <linux-crypto@vger.kernel.org>; Fri, 23 Aug 2024 09:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724405861; cv=fail; b=E94svj3kK6d+aJBpt1qQCPzrB0uVQ0QYH84Js3fvSuS60YhimfOAfrYbYbgCFMbKdx8bryaW5RoBSf5G4IwY9CcuviE5mIyguHZ9koDYwpO2q4bFDFwMedoiWdWjkk7x7HlAMn7g+UTHk16PBCz1jcWBj7sAOY7zztfo6OfW1KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724405861; c=relaxed/simple;
	bh=3k/YzfztCdUorrIZYeGH6W868fSqBVxEQsVPbEVp9/U=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=CzS/djw7CNP63BL3ux+q/mqV8VJe4HIJ9gfkBTNwiDsEwHPqF/PAlGhmp+6wEk38f3HaFeYRCiWo6cgaxr8MlDxCcu3ahP5d7sCCqu1Q+BJWQDXCN5gT50ZeZa+OYVzZrNVKJTpCviGv2Hh+4hIeH1hMEiaCdB5hhHbleOYL/Wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=N9X9QYZq; arc=fail smtp.client-ip=40.107.215.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="N9X9QYZq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KQ9atAAp4w23cpimanpGm0EZKSKXLrBfum81HXh7S/eQ7WZueGlnVknCZlwNIuY/sBUi4GHPgZqki7XzT6ZlrQA+oRXWGMcjdbuH+ytMKtb3vpkM1+NDikdKrZHtxcA/Ul/5eAUMYtorPZ2TjEIKo2qQq4//Kk8ZD0LVXDnho/Ddd/Dxm3Z8OX7ziFE22wsDclhsHkGicGXl6/4s1AHcVPD5fMXUgR2RoaK/GEjomkuKP+3BDqx5hqf8UcgsEjb2vmfDBjdW3YbSQNE9++CrpdjCXQqzZMY6JMiDlFoSHTgOD0sC4X05KfysRUKDM6QAUb3GTW/Qq5MwoRzqu4sG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLdXo7asFn+Een/QIQXVv+LJ5qVgXyx3dDaW/d88yg4=;
 b=XyT/YrGJZq3HBVXXbtSi9FPIFPNnfBMNob+R/rD75qKspLFDgDFlKUQB5Oxq2tdemqC1Htk4JIiulrYzoQPcK6KKeghDDeQ8PYgkXgOizpleuGqbbcX/OaKdA1kk+cbK/npFA1BO7ACGC/A6R9jyBDTNU3QH3M1VO8Bfbz0z4KhTew/cUp61nD02hF3y4rW2xQosQWeVRjz+d0S4ev862q77hkkxsGOLZrpHzQ5dGQXofbbRCptO47PuL77Vnzzajvc2jcdgObujotoB7jj26LqazIHQjcxXXbfJ1GqmVloxEoKwq7iz9H3bPUY1akU9UiZkzaJCPkXyv6/3iM5ILA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLdXo7asFn+Een/QIQXVv+LJ5qVgXyx3dDaW/d88yg4=;
 b=N9X9QYZqDlhV2Yc58ujsSXr6VoQmrfrvBKn7JG9IJ8v3lT6PPUMfV5e4AESedSiE+D+jDR29UUJg0HK3swXVUukqYPiJMd41WIxTl/kI/SWuBqcJwDe2S7v05igpbLGb0pY59o0DaIsfrvXLOlei8xgeE5LDjpSlk4y+4u9jXaVbacvC/CizbtKLRi9+YfTr3R7sUkjuvll+XIAAWRf4P2xkgKbtoDE74u2JkjlHHfkVlMxh485OZws3aTxKB2rDoGnNj7VueTuAhKfs5YavmA3/010q2EFWpPsyNKEEGlRkj0V+45uioaSZAzUxfzG9TAbTsGtUlAC+awqMyIuXiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB7096.apcprd06.prod.outlook.com (2603:1096:405:b5::13)
 by TYZPR06MB6915.apcprd06.prod.outlook.com (2603:1096:405:3c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Fri, 23 Aug
 2024 09:37:36 +0000
Received: from TYZPR06MB7096.apcprd06.prod.outlook.com
 ([fe80::6c3a:9f76:c4a5:c2b]) by TYZPR06MB7096.apcprd06.prod.outlook.com
 ([fe80::6c3a:9f76:c4a5:c2b%5]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 09:37:36 +0000
From: Chunhai Guo <guochunhai@vivo.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	Chunhai Guo <guochunhai@vivo.com>
Subject: [PATCH] crypto: img-hash - use devm_clk_get_enabled() helpers
Date: Fri, 23 Aug 2024 03:52:12 -0600
Message-Id: <20240823095212.2174370-1-guochunhai@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To TYZPR06MB7096.apcprd06.prod.outlook.com
 (2603:1096:405:b5::13)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB7096:EE_|TYZPR06MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 10dd2b3f-1bf8-4cec-aefe-08dcc35738b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dap69nDghqC+eafwkI/I6GfM5gQEFKVYD/us9aO1I+Os+pW9jvMXm85azM8N?=
 =?us-ascii?Q?/Q3QFdhV7lhWmZCLVFNg8Vi0GW8/+IwA8BWw8RIp20zoZda3iZfB3fjHN2Qh?=
 =?us-ascii?Q?j2c6zXHi5QYdmAbNkr083ZWNtj/mtIbiMBvrbNSTrjWS11m8IGeG4nP6LDii?=
 =?us-ascii?Q?L2DBdBti8OUxg0W268oA9AI3JY6zdiK+SHMELkpXk+d9U0TVHQYOXuhsvyFR?=
 =?us-ascii?Q?AfoEiJrE1SLPOpadBseeWHRMkR/pQmfg3h7n1sxVft9LH1P7urhi3P9GpAzQ?=
 =?us-ascii?Q?/QnoD2bVaq6URJKaKZEEHRbSybn+wpWWnXJHP/cCSDpnB05D9cKAexvgse7E?=
 =?us-ascii?Q?Fh1eJJ27aSHRrpAeyL1TncydUOzfRGb/ybtPnpXDDku3m3f0nCFKSznFCKQ5?=
 =?us-ascii?Q?7gkF+aPTdj1qglLwJ2fihGRQ9bx7zVRDf+n5nZuXRVr0usLlCpBp2RWYDOYM?=
 =?us-ascii?Q?+TVtK15Aq22aaOmM7IvFaD2ny8JeQEDDZEAa41QhhsS6UTj5dnGr76QPOSIQ?=
 =?us-ascii?Q?a/r41O08Ndne4BaPieUL8YJqSiW/bcp3kuVaG6a830PMUB/qM56I7MFQji/Y?=
 =?us-ascii?Q?Kw11G1Lf43QvMQ4S0Pd936xo+7LQwrE8LOi5BdtUmj1TYGK8/9v5F8F2H20J?=
 =?us-ascii?Q?9OR+25WKmHOA/FMQDeLIV2THNnPmclFeP7JLDgGK54TJbZXSwgOtgF7cem60?=
 =?us-ascii?Q?TFBL/xGSltQmzcwp54rCRdguW9bw7ZL/eYiXTt/LNetX/WviP+m9HiLIqXu+?=
 =?us-ascii?Q?e3zAYygI74Vvg4er18wZjkjsifj3M3aJfuV/vLGkmOfcbfQ3l7NYWQn8xfaz?=
 =?us-ascii?Q?jGYITBJG8/cGjYn8k2GwhY5EqgiBF6YkcDEfKPnToXuOqJvEXi7z82SY0jQZ?=
 =?us-ascii?Q?D7Ac/uNJXNGgDWkESTwnAWX3y/ryc1f3iZJYRxyK3IKc/W35k7VOTjOUhmdw?=
 =?us-ascii?Q?MK+EQ865uMnq909vasIBRctpjLi5Jh6OBnCohwstGc6tNe8XSxjbC01a37zE?=
 =?us-ascii?Q?4nKTPCtxkcwj7XRjuQvO0vAsHTSUcB+qnl5kFRq6xrrIGYzoxcSESI8U2DU+?=
 =?us-ascii?Q?adrErrL9qzfXVOrSiRsYNzEhFviwxk7yFdJ4bmABx7gC6OGbGH1gMqWAjrQg?=
 =?us-ascii?Q?quMjA5xmCMVnwFdk+m+xT/Gy+2HG+sBF47YnC+8+Fu6nkV6TOXJDmjRx7vQa?=
 =?us-ascii?Q?bnT9AfVpHAe4jlZyktkLdDl60JFOVmPfIHNKDXx3D8m0qVScbojrcM4QOmdg?=
 =?us-ascii?Q?np8yShJv5FVYETptFv20DLabbWvD95PjEdaUlqMpucLHfd+tyMmZrzKwmLA8?=
 =?us-ascii?Q?JFq5uubIbsD8nqoFuABy+5d3Jq9PbhQoBzujyL5Toi22/2N4qGi7Iflki2SF?=
 =?us-ascii?Q?1Y3DzVd5/lyCSMVCq2xc9psq+DpVpddvaCf9xK+PDxdWFkZQ9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB7096.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M0vUaWVKOUvPsFZF7W149EIjbrH33NkN+P+16kGtcv/R5u3TYSjMIxbTEuHW?=
 =?us-ascii?Q?OA8Yy98+QOdtJjNHGVDYGjYvFyIcaEg8of5wNDv3DbgLWeNAvGVv2SxiTfb5?=
 =?us-ascii?Q?DNfSBJGn5ASDq5EKk1jdMD2KGUlCc30IYM6nqw46mVlO13/98DIuW68boNAu?=
 =?us-ascii?Q?5as3g6NwAZMT6sULiOh82AXOfm81uQTMDP+3sfXxyz+2toYojJcPaJyViuuB?=
 =?us-ascii?Q?cOxLF5cn1nCG2CM9d6S+ywxVrZ8yPaVRF4WO0lhWkQ1x9RRLMDFhqZX38P2s?=
 =?us-ascii?Q?YkjiU2JU14rz59DCEZ/0I/B/mzmRb9JM5zhKUtlpDA3E7Fnztkc+Xs9Fj1hf?=
 =?us-ascii?Q?7tusN9Hg4bln+SAVeqMFFV3HyZhdeSbMD31dyPFfEYNiI7Mt2EHOhVw/SgOW?=
 =?us-ascii?Q?bZPZDx/rzhTnkS8fXkAOjL2T6DUsb5Sh2Y18kWofeWWYvMxgKKgmcuOKW9Pj?=
 =?us-ascii?Q?37eOXFzrdbE3Vd/CC01sTIDs4rG11tJpsoUNiVfqF43dlZa6G5OB+E5/vPh0?=
 =?us-ascii?Q?HAAvXjzLX4APzBLJkllIe4GCRV94XtTnRIBnnNqWFNyIAYdU+2nUeXdwQJo3?=
 =?us-ascii?Q?3cwT7IWlmSyCDLLeHjbzYNL2e+x7TVWPJGeiEyVqlCCP2VgJmS0h51q8qwez?=
 =?us-ascii?Q?rSyml+vgKb5gPYv84yD0XkH9/n8Kf7wVg1WZBLZ6SGd93yeovrj7XnJJnAdN?=
 =?us-ascii?Q?r2UoGfbcCqY3IROgu1betzZLI+xokr1+uumj+zfj7TI9m/lHk+GlXJQWTSe1?=
 =?us-ascii?Q?PARCDyxnyW8OlFm8ARoq7qN0h9L9CHdjY63xog4A1RmJD8zjqz7VcxbpQFfg?=
 =?us-ascii?Q?gR7sRfFtUxKhJuALpA5uFpJap+F4xq05dOjYUuP2W99ZuuSGI+1ExH2RfFXe?=
 =?us-ascii?Q?zbkARHhQT57hc+aFRKXOJNEKZyHmlX2RYp3r6y+4nbxb78WAqNduX9wFTs7J?=
 =?us-ascii?Q?dst38/1lPw2KbHko9q+WvXx//FTzOoDUppMSuqMEzmYOtMeSC/aKgMJea39I?=
 =?us-ascii?Q?iwi2XcRSWwX2vL6QFMr0/GglRt3/afShhJqsMvO+vkhXPx6qEmfjZQimGZcY?=
 =?us-ascii?Q?P5fCrUcC3uRrKjzVBh/Mr4QY7ywCB6X2pBQ9DE9yK/FkarwNTjaz0BZAMq0A?=
 =?us-ascii?Q?CNzRme0DCJ+QL0npaU2pgMAZfftWECwiFkgclclvJIIc7hxbPnQfEGvvMScl?=
 =?us-ascii?Q?BNjn1/GYrIwuFasAvIoY/tCjJcW0LEGkRYC4S+bNhCBEPo12EKFmTbPyH5+0?=
 =?us-ascii?Q?vySD7DZmto0l/xhD2sxWQJzIrJhS9egQhtK6x+fj0SeVo37WCYx20MS1nVrZ?=
 =?us-ascii?Q?TYuG0+t+pnjoNWUjRqwhNETajky+vQuQo4DT4ULQmSLomHKSOfnomxzNr5S7?=
 =?us-ascii?Q?JF7rr7SG6tupDrODNllRgjcF9h9PatdyITtwSM1aMioVILsdCnU8PMYsvXaK?=
 =?us-ascii?Q?nytqm1snmnHEYDCsqiuWAs2Ae9/HwORVY7B06wiQQi0XSdERZumCQqMx+IEA?=
 =?us-ascii?Q?A3ESWi9Mmok13DJ7yR+DfXKa7tqwzSdZWetsRe53Yge4EHJxDSN0UvmflC4W?=
 =?us-ascii?Q?edNhVDKKwOd3gZv2pmNA6tx7EvZuo9Eg/E2BztNI?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10dd2b3f-1bf8-4cec-aefe-08dcc35738b2
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB7096.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 09:37:36.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNLh8LoSixbr2a6PGNyTc5+6lrG83zShOamWB+0pKVqbu+kn4mh3afVQchZDk/D2fEKeKe7ub7bLf1mv8QVrig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6915

Simplify the code by replacing devm_clk_get() and clk_prepare_enable()
with devm_clk_get_enabled(), which also avoids the call to
clk_disable_unprepare().

Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
---
 drivers/crypto/img-hash.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index d269036bdaa3..7e93159c3b6b 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -987,31 +987,23 @@ static int img_hash_probe(struct platform_device *pdev)
 	}
 	dev_dbg(dev, "using IRQ channel %d\n", irq);
 
-	hdev->hash_clk = devm_clk_get(&pdev->dev, "hash");
+	hdev->hash_clk = devm_clk_get_enabled(&pdev->dev, "hash");
 	if (IS_ERR(hdev->hash_clk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(hdev->hash_clk);
 		goto res_err;
 	}
 
-	hdev->sys_clk = devm_clk_get(&pdev->dev, "sys");
+	hdev->sys_clk = devm_clk_get_enabled(&pdev->dev, "sys");
 	if (IS_ERR(hdev->sys_clk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(hdev->sys_clk);
 		goto res_err;
 	}
 
-	err = clk_prepare_enable(hdev->hash_clk);
-	if (err)
-		goto res_err;
-
-	err = clk_prepare_enable(hdev->sys_clk);
-	if (err)
-		goto clk_err;
-
 	err = img_hash_dma_init(hdev);
 	if (err)
-		goto dma_err;
+		goto res_err;
 
 	dev_dbg(dev, "using %s for DMA transfers\n",
 		dma_chan_name(hdev->dma_lch));
@@ -1032,10 +1024,6 @@ static int img_hash_probe(struct platform_device *pdev)
 	list_del(&hdev->list);
 	spin_unlock(&img_hash.lock);
 	dma_release_channel(hdev->dma_lch);
-dma_err:
-	clk_disable_unprepare(hdev->sys_clk);
-clk_err:
-	clk_disable_unprepare(hdev->hash_clk);
 res_err:
 	tasklet_kill(&hdev->done_task);
 	tasklet_kill(&hdev->dma_task);
@@ -1058,9 +1046,6 @@ static void img_hash_remove(struct platform_device *pdev)
 	tasklet_kill(&hdev->dma_task);
 
 	dma_release_channel(hdev->dma_lch);
-
-	clk_disable_unprepare(hdev->hash_clk);
-	clk_disable_unprepare(hdev->sys_clk);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.25.1

