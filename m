Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013044.outbound.protection.outlook.com [40.107.201.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73474A2E37;
	Fri,  5 Jun 2026 10:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780656125; cv=fail; b=MxS1V7fDglunTBpbbQzcP8R2KLDYKFXMy7Dy4m0ZeGlDfkaa7yl7VEka9dWkIcPVN+PPibAvHeTGWovZ089mJNTqZVQo0zHfYqsLcsY2BDwp3J8xJOyFhDSy1sTQQbS4WomkuTRsMbKaBf36rrG4mK/+wZpVZT0lC/zr2Dr7x+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780656125; c=relaxed/simple;
	bh=BSOR28U+ubszxsVCKQ6tV+ECCR8/Igirlvc7EPt/MJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UC2BP+ydDLIeEWBFi+5POh1sa0GQ1AMKw7Hf+b+J5Xs8ncgaYzCQpRExMhAlbffkOLr55CcpapuTk/P9XVwKfdRtdRQj+UmmLtR47obmdTSpb10od7c/O5gjhzyZHHpMYZVyVj0zgx20IhKRWvTBVHpLblJ4AZbpWaLsfrzTSAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=A450DeZs; arc=fail smtp.client-ip=40.107.201.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="A450DeZs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJeThikX7QKYHSndE3qx3nIVlCvNJcP9v1VmLCqFlCLbQhVPAOXNaPto/OGukdBjrGQciGZpxIAHJQPjMMkCajAu093KRSlMssx1SKAuX4bicsaVilTnSqFOzf/zJD6w6KQFiSeSj3dii+pYBd+RxH4/lx2cLQkdR4h6+qObeZvXkZQN0pb5o4xV8PCY4Knu7uJ5/73wXNlkunKyiDNXbk0JIQJQhYVlbGRlJJ93mnKczbT4E5LvuVQBmqAeN8xG7USE9T7CwQYvVZTWhGvw4QuMTljZNLAeHSVtnp4Syp74z9b++B1vLBoNJwau/OTxOVM82/MbSGzH1BpvILDUoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzvRTjl8uAIeQi/Nl+eu5MLUV8nDcmFY8Hu/W7+Cyaw=;
 b=d7Yrw83w8A6QmIyFnwiCXqwikjyg36pPrzT6t9v2SRJRmRzlWinXaPNT34Kmlsp2roio2eaYFYP/fDM+LRn4OD5nvIYFZtV6r/yN2sDVpmpL7SE7VRE0G8wbToKV28E3WoL58lyPCztH/2+qPD0FIGejgTzRjgysp4DdnvZEaF4kU5kZw2p1YncM64Y5hvkqk9xFBKrcUWiy9W8NKcSomyNgPVr6C0OMiTYT4g0MoFIWKn631/y22EYEoNBOoxVERtS8AqFvxHTvT04xXgoIIDdpTvioUUGU3Fegw9LLwsluTUDd+Zx0hs4YJN+krRIlJ1fZabAvIEk/jiMhMaGyBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzvRTjl8uAIeQi/Nl+eu5MLUV8nDcmFY8Hu/W7+Cyaw=;
 b=A450DeZspiJekv0eFT3a3z0ksFlQTNr5FWN+VIldUcjGaouBcV2moYKzz5mq9i6lIsmiTYWv0pXylt2LmQCMQO17qxUkMHDm2r+ZNNcOaUuHvpd6AmtA/SGwASj15GrsPll5h1qlmHzXoAr+7amfoCj9GyOupn6c0499ZDnmh8c=
Received: from BN9PR03CA0096.namprd03.prod.outlook.com (2603:10b6:408:fd::11)
 by CH2PR10MB4373.namprd10.prod.outlook.com (2603:10b6:610:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Fri, 5 Jun 2026
 10:42:02 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:408:fd:cafe::58) by BN9PR03CA0096.outlook.office365.com
 (2603:10b6:408:fd::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.8 via Frontend Transport; Fri, 5
 Jun 2026 10:42:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Fri, 5 Jun 2026 10:42:00 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 5 Jun
 2026 05:41:53 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 5 Jun
 2026 05:41:52 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Fri, 5 Jun 2026 05:41:52 -0500
Received: from [172.24.233.212] (pratham-workstation-pc.dhcp.ti.com [172.24.233.212])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 655AfnAQ1175407;
	Fri, 5 Jun 2026 05:41:50 -0500
Message-ID: <e0aec964-3303-4ca2-8d96-6a5d8f5ec9e5@ti.com>
Date: Fri, 5 Jun 2026 16:11:49 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] crypto: ti - Add support for SHA224/256/384/512 in
 DTHEv2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Manorit Chawdhry
	<m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, Shiva Tripathi
	<s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20260526094355.555712-1-t-pratham@ti.com>
 <20260526094355.555712-2-t-pratham@ti.com>
 <aiKgs8ipDLPlz6c4@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aiKgs8ipDLPlz6c4@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|CH2PR10MB4373:EE_
X-MS-Office365-Filtering-Correlation-Id: e54027be-85e3-4fe1-2543-08dec2ef1341
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HFqFSjJgSv9z5TOAJnJ50WYUlT2KPPH4unpBVXtNVbvuGfzluSnf/OhuClkB/B9pPLQ5RJaTAuw9ofkP6FxbECyuzJI5ibERPjyj0SucQhVG/WQwNMcy7oOdPDosGhkmfhgKNZHryYaJTSY8EyPVZlc5nhsuDaDkmgjC6gviHscylwiWy18MzhWvoAlrjKqTfe8T7y8Hjk3mBOTjUOBCqCF5KTKszTS5oqDreuJY31AhQ6v2NRjDjgbhhqj45fLqn2zSBgpmnRo4oD723fqcVOQS9nAFG2Y+Dene3T7jEjzhVLGRGbebY/OiyDNcJHltnt5RP43PmOW41cwf2WoyUgpApMVexKBNh7tyHe7UeOeNvNrmmv4idQMoQkVxwUrPC/KyqvK8Kfz7ciwvPwlsGlfO6ICdJLY5ONmCUOjzlNSNoi8UoRqaZYkXgANk1tutSncI4dQRH6e4bvF6zA2uyrpLWgYMAEsBUWjeDRF3kMCsfGmhve047xlPY1yPWbs2yU9krWCMSt/ucO6GAPfx8bNIil9IFLOIUmkVKqtXyspyVHCaAh4vkOXXzwbK230fT9lAX3rlwJ5wYjJAYnW+s9K6bmuJ39VbENu5fS9rZXANx3wJhWBc9GfBFuY/ZO78w5twg6Rkxf2QwcXPbML5Ho+qrUWpQVH1bk+NP1hzwh7oBQSOD6HdOkjHzimz3p44hvakRp4oMjq964tKkQ+OGOOqgZLeBski6nwBlicr9jM=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J59hZ5cexgoNHeQiY2gn7DNHeLomJTUPOW6JfiKzHVImsHQSqrviajtdeEcmyKx0ia7+x65youWCRGfeY6WyLOFr8NIWnFAKvC0ywTATeSLI9uQRmF5FGRjoxIOk0Vd9zvzfyGCeCarZOxMRvY2tX8fucxC/4m4oBNNifjhH8Mtdjaevsa0ehVhQJ/qXEgsvLRGkIQO64n3VJijwgORF9qMWQF9J3C7ALoQP5TvzLFnPB1HNXdf/xFTHJOxhag1oRVyncuuX9tdgoZ4JwfGyIHsCHEDTaMq5mjiz9Syz7d52GnmlbqmbZPCEMOdPDK6Z1TeH7KBJhbrhTvHzzWRSxlHb/jVqSe2/nyNTQ2cl1vLF1c7xvrzu2yYIB0EY3b2JW5jxOXquHN2vPHV6XPLTTlym+lLL2VCAgJ0FF0n2UBPSPj7BVUp2hbctm7Hc2+Vn
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 10:42:00.8049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e54027be-85e3-4fe1-2543-08dec2ef1341
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4373

On 6/5/26 15:40, Herbert Xu wrote:
> On Tue, May 26, 2026 at 03:13:51PM +0530, T Pratham wrote:
>>
>> +static int dthe_hash_final(struct ahash_request *req)
>> +{
>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>> +	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
>> +	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
>> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
>> +	struct crypto_engine *engine = dev_data->hash_engine;
>> +
>> +	/**
>> +	 * We are always buffering data in update, except when nbytes = 0.
>> +	 * So, either we get the buffered data here (nbytes > 0) or
>> +	 * it is the case that we got zero message to begin with
>> +	 */
>> +	if (req->nbytes > 0) {
>> +		rctx->flags = DTHE_HASH_OP_FINUP;
>> +
>> +		return crypto_transfer_hash_request_to_engine(engine, req);
>> +	}
>> +
>> +	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
> 
> This doesn't look right.  If I do an update of 64 bytes, and then
> call final with req->nbytes == 0, this will give me a zero-length
> hash.
> 
> Cheers,

.cra_flags sets CRYPTO_AHASH_ALG_BLOCK_ONLY and
CRYPTO_AHASH_ALG_FINAL_NONZERO flags. An update of 64 bytes will do an
update of block size and carry over at least one byte to final. We
always go into this if block when there is non-zero data coming into update.

-- 
Regards
T Pratham <t-pratham@ti.com>
