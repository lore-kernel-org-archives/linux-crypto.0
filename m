Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010022.outbound.protection.outlook.com [52.101.193.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF57362159;
	Thu, 15 Jan 2026 10:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768471739; cv=fail; b=eRIf703dvpE/EGeqHNp3QfJpgbuPxb+TFuL9CSpV6rQ8YnsUBj7bt6zZh7si+26C0pa8gYjxl1uD6C/tSlLwgwfxdug8jOCwJrLm6QKB4zDjjc334aMYKpmSekl1uDZ2hPumd+/dS7P6pjysCoio8XZ+OYoPBjTp7pIws6VBzfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768471739; c=relaxed/simple;
	bh=KmHr/FBH9af8xdx8IKcMt/5xGrlLhrKDkrxZxyZriV4=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=jWxmAYjdFBVHeh7ArtFqeVTCPtT/i/2/7cUX69Gy03EoFGuKcy97XYAMPX5k7CEHAPnjx4QsirKjIRpmWkOS2UboTCupDBIMR87ZMJAiAoTpJFRjR9spi8GY4Kr+iUsPj983n0XiGw/Moakn8eTlPJuVpOrtSF/HiOkxFTMslTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=aG6+dyXO; arc=fail smtp.client-ip=52.101.193.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="aG6+dyXO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbefY6J0p89z2wQ42wr7hSGHwKUhm9DYRuMrx1PgRffb849SBOR7G+HULYkmu7jhWY7EWNdk+gxwiH+YvG9XUHGrKtbflhW8/6BNVtOOzUtEUmZiOdEnRD2lrg2EJDSWaSta51YunKBUZ/C4OqRBUDQpLtC425CCmR0wSJe2sGUhHFMY3CxZsmapU3D2d+5QNb/5rTzc6MzWsd6XBCny/RfTfzAP6V3fFIKPWWGRkM3OQvvER4IDuRA38QPChfyNJt2qJQ4tOxplXrIeCztJcybqll1IhAi4dvVwf/Ksp7ZLK1PM1l8jc5V88xtycfoYhCIRS4ttdj0BPnnnCFRwxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrrjJQGRbLoCya5EB2QCnYGfbdokAjLcDL8zR6SPs+4=;
 b=sNjn0k2yZYdoMzD1r+6WTdMnlSoiBPXnJrqp8LfKNEfCdFhNTW3eYC6tKAKI7xd+xkvfSaIGQmSCeKd0kTp2Db/1TOE0SgvRyca1D4CfJfUwy97v7HkqNivdL+rpNT7SCDxw7/nVROhjvNF1qpxLhmsbEoaNYW3Mdyxcihyyr7LaISaCbZ5VWMrfWVR6HGNuP+OqjxR1FFQqGb+JDdIIxyHOpWyiqZS0TXdjHPiWSs94v8fE0y8BHkyJMeoVKLMOVDXij4TRUB4R7pE6jLs2rrUMmDiX5hsgMM1mKj1F70iB419Q3pcEAnoEJOksQM4JHjB1qy/4SC33qZE1S96dHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrrjJQGRbLoCya5EB2QCnYGfbdokAjLcDL8zR6SPs+4=;
 b=aG6+dyXOHvgAmkQvepb09ANTHocXACHZyN99oC3glKOiT1YeWyVFvXvYKzR8s3BE/K9gVnpPeBy1Kx8CVIT7QpCB4sfcbuRfmDRmh/VcEQpX3kj9V8l/qiVvGP1J5ME0+obt4NzcSYjM6cubjnygg4GTAsvddS4zpmazhTlX0FQ=
Received: from CH0PR03CA0320.namprd03.prod.outlook.com (2603:10b6:610:118::25)
 by IA0PR10MB7327.namprd10.prod.outlook.com (2603:10b6:208:40e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 10:08:54 +0000
Received: from DS2PEPF00003448.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::2e) by CH0PR03CA0320.outlook.office365.com
 (2603:10b6:610:118::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Thu,
 15 Jan 2026 10:08:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 DS2PEPF00003448.mail.protection.outlook.com (10.167.17.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 15 Jan 2026 10:08:54 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 04:08:53 -0600
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 04:08:53 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 15 Jan 2026 04:08:53 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 60FA8pvM1389749;
	Thu, 15 Jan 2026 04:08:51 -0600
Message-ID: <70710115-6bde-465b-91f2-a005bede1602@ti.com>
Date: Thu, 15 Jan 2026 15:38:50 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Manorit
 Chawdhry" <m-chawdhry@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>, "Kamlesh
 Gurudasani" <kamlesh@ti.com>
From: T Pratham <t-pratham@ti.com>
Subject: [BUG] crypto: tcrypt - data corruption in ahash tests with
 CRYPTO_AHASH_ALG_BLOCK_ONLY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003448:EE_|IA0PR10MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: fe16c953-b3f7-4bdf-adf0-08de541e1702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|34020700016|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NW1jclQzTVR1T3BxQ2I1cmZYc1Z4K3JibFNhUzJ5M3NaM3k1ak9lSEdjbTlY?=
 =?utf-8?B?dkozWjIrVGpaNkQrOW5URHAxZkFZRk8rWmV6SVN5OEkzcUFuVWxBK3gySjVr?=
 =?utf-8?B?dWZybWhKU3BDVjd3VGZHQ2ZzbTZBUDNydTNCMm95aUU5dU5lYTVibzUvWWt3?=
 =?utf-8?B?V3pFcldzUUsxZUtRUm15b1RDaHN0bk5ibFRua25NNjBGODByMThWSjZxMkhx?=
 =?utf-8?B?cmdmb3U5ak80dnRTUlRzb0FXSldycUN0YlVMZGFDYnp5R0dCUjlEMm9MZkVq?=
 =?utf-8?B?MDRHSnB0aFVoUk5vUlVoWWo3VkVtMWErTS9jQ3p2TGdjZ2xPeDMzU29VenNl?=
 =?utf-8?B?ZUtJNG9qYm15M2hBKzhBb0lGWEMxY0psc2d4VDBnRnNSSDBqZnFxb2I3UDVN?=
 =?utf-8?B?YkxrdDM4UUFrNGJuSDFNZzIrbWFMZHlXVDN4TDZIUWpwK0I0YU9MellWckNa?=
 =?utf-8?B?SnE5U01HSjZPYklYNGNEM0l2cDRZcEtuc0M4L0pkbGpOVXZiRXhpRXRTQkRZ?=
 =?utf-8?B?V2lsMm1jcStIZHQ4Q09VNjN5aFphSTNBUFJicE1rZ1VtOWprOUQrNTNGakVD?=
 =?utf-8?B?OXRhSEFCb1BiREczYmRVNUhnMWp2bEtNaVJ4YnJmNFRaZkRaZkxYSmhxUERu?=
 =?utf-8?B?QVk0V0tMTXVmdTVTMDNaWm9YWE9GUVFJV1JDbUxNMU14NEszR0YwNStyVEVp?=
 =?utf-8?B?Qzd3QXNadlFtd2kxUHM1STNOaWhTWmpBRzcybzZHK0xYUkVXRkEzd1ZmV0xx?=
 =?utf-8?B?Nnd3eXpxU24xWGVJWHJGODFaRVNXOGlNZkpyT1B6V2F5U0RrZXJsK0YrSWlL?=
 =?utf-8?B?MWJyamhsK3pPMjBhblRqYnd5R2tNZnFIdUd1QVJWOG95L1lwUmFNak5xOGxW?=
 =?utf-8?B?OElQQmw5TGRQVnVqekpndnFPRHZ1aXlOVzNKVytDSUJTNXh4MHBJK2dDNjVs?=
 =?utf-8?B?Zy9kZHJRSnRkREc4UHVER3Q1UFQ2ODRqemFDQXoyQmU4djY5RGRzOURkd0wx?=
 =?utf-8?B?em9CUUpLNDZpblRFOWtQSVFMeVFxdmplYzBhdS9zUUF1VlkxUndheDVLeDAw?=
 =?utf-8?B?Z0M3QlZWODJjeVcwZEtnQjZvOUs0STFJOVFOL0FkVkcrdVFPb2VIc3FPb00x?=
 =?utf-8?B?OWtpYmJjUmFrcjczVUVuODFtdFdKQnQ0NTNGVjVGMkxUMkhxelJWZFI5K01j?=
 =?utf-8?B?R0FYTk51NGp1YjlteG9qbWcxM1lIQ0gwRUpJcW8vcUQ0MnJZVSt4R1hiSWNp?=
 =?utf-8?B?QUJHaXIzaDFiOUN6UVBTRGdGNXRQb2h2MFcxdEk3aU1ick9ZVWllY3dPcDdj?=
 =?utf-8?B?SmFFYXd2TGNDN1pTZTk2VTBzNit4a0dGZXprSEhCejhwR3lpRjZPNGMrVFpi?=
 =?utf-8?B?VlNmNUtkV25DTWx3a1d4cjBKMHZNQW4wb1ZXTlZEcER1RENDMGJwMWVJYUgw?=
 =?utf-8?B?dVF3ZUQ2TmRNNDZueXg0NEVnUlovdzYrM1RDQTFHaGcvd2RJVDAxOXVabWJm?=
 =?utf-8?B?dWM2OUx2d3Nwb05SNmh3ZWV3UkYvWlFHeTBZcVpwQklpNjZkeE90eFF0UWs4?=
 =?utf-8?B?NTJsL2ZxbU9rQ1RqNWlOdXQ5bW8xSUs3R3QyUk5LUGE4bW94Qjd2SWV6eFJw?=
 =?utf-8?B?ajVTY3Zwemo4bkNCVFFaVC82T2d0TEpEbFBqbjIxWHpqVllPRVZLblZGUXAw?=
 =?utf-8?B?YlkweFQxRU0zSzVmK04yci9oSjFEVC91aEZ0MjdvSUpSL3dyNEM3MnFSU1dy?=
 =?utf-8?B?cFBlNktTNkxldWtIZEFHVFZ5MkRZU0hkK2xQQ1BwZUs4NlhpaFEvZkMrOUM5?=
 =?utf-8?B?S2hRU2s2OVcrc1dNcm1OZ1RPdlNNb3pDRHpIZlRKVytVZCtIWURJZTJZR0VS?=
 =?utf-8?B?QStvMU5LQVhnR1ZJZGdBZGNtcC85eE9QV3BhRlNjQ3VGRWllODBKeGJUMzNE?=
 =?utf-8?B?VHlhZWxpN3RheWtrZTE5Nm1zNitNUThWdkdsZUg5SFJKbzFDOHI2bkdRSndY?=
 =?utf-8?B?SjZZMWdTeUI2ZnZrK3krYVZiRWE1Q3A0OEtKdnZlZTc4T3J5Y3BweXNSS1hy?=
 =?utf-8?B?NzBYbEEwL3Q3dmJIcVJWbUQ4Y041YWhHY0RMQ3hRcGI2M0J0N3hNdHFEOXVZ?=
 =?utf-8?B?REJrSllDcTVyWHZQY1RRaDczNEk1NWd0Qm9ES2pqeW5SMThFb3lOREc5dmdB?=
 =?utf-8?B?c0tSUlFaV3NYOXg1MXhVRFpnUktZQzZRbWQrclNPT2plVUhkQWUzNlJLN2Ny?=
 =?utf-8?B?UmRzaDhMcmtzWGYrQXduS2JHMUNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(34020700016)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 10:08:54.3880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe16c953-b3f7-4bdf-adf0-08de541e1702
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003448.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7327

Hi,

Commit 9d7a0ab1c7536 ("crypto: ahash - Handle partial blocks in API")
introduced partial block handling for ahashes in the crypto API layer
itself.

In ahash with CRYPTO_AHASH_ALG_BLOCK_ONLY flag set, the code replaces
the callback in the request in ahash_save_req:

crypto/ahash.c:
int crypto_ahash_update(struct ahash_request *req)
{
	// stuff happens
	[...]

	ahash_save_req(req, ahash_update_done);

	err = ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->update);
	if (err == -EINPROGRESS || err == -EBUSY)
		return err;

	return ahash_update_finish(req, err);
}

Same in crypto_ahash_finup().

When the update or finup returns -EINPROGRESS or -EBUSY, see that
ahash_update_finish/ahash_finup_finish is not called which calls the
ahash_restore_req to restore the callback and data. This seems
intentional as the code wants to call it's custom callback to cleanup
stuff done for block only algos.

However, in tcrypt, the wait struct is accessed as below:

crypto/tcrypt.c:
static inline int do_one_ahash_op(struct ahash_request *req, int ret)
{
	struct crypto_wait *wait = req->base.data;

	return crypto_wait_req(ret, wait);
}

Hence, when -EINPROGRESS or -EBUSY is returned by ahash, inside tcrypt,
when do_one_ahash_op accesses req->base.data, it gets the modified data
and then goes on to operate with the same, resulting in data corruption
and segfault.

Here are the logs when I test with DTHEv2 SHA512 driver (yet to send
upstream):
https://gist.github.com/Pratham-T/3c017c719d3e8c8a0bc7ea96bf896996

-- 
Regards
T Pratham <t-pratham@ti.com>

