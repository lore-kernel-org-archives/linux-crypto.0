Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F96C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 13:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A88207E8
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 13:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="IpTq6o03"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgFRNwD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:52:03 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:27328
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730686AbgFRNv7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 09:51:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bbv2utfSDe2u3DONvUOVKEFe2D60JsABlUBU7lMzNb7GagO6t1aXvi3M6bA6v7KVh6tvSkF5Ykljv+itEmg6Z0Ivh8nJWNcIke17hxhIg0xg2N7soBNhkigd7sAkIiK88eal5JE9o3a1orv7JZ4jAxrRLKWtfNVMUsRuNs0SvFT8kaQmz34SkuLeBdWP8HsClYRXOTa4ohAAAo+1hfL/nDcrTSVkRRxFjpdmFVaXt0cuUMy/Dv4IQaTbp3QtB9xtJTFQKQ/D/eJWAx07OTaV8x3J1avpSkLiu0XvoHBi1EDRKC9ZaW+dMIM60YfVBjl9Z7trSEthoSlpqFWpgDtUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBOp1RIVw+1M72fxkefVlSYO8A1efQGdVEFgwlU0/ls=;
 b=Q2cWPQNhHdBHNa3U2TsqgKWIBslStV/KWCXCsi5Ly/lwQjbXwAWapqBsl5m+cRh6iaw1Wtx28XH6cCjx/cqfrlf6QNXmX14EH8tEB7g+UYwkqU/FDr+SzcNsDi5d9jSyKT4U3UuIDM0Eysi8Lc7KJkHoEWnlz5ZGMQNl4pbZEB0poFo60AgRzgOaI5htUNKeCOQoEpJ/vAUX0qz0ayyEh+mwplWZyp7eFZGUxfBa4PZ7SxX6voj4XPjtAs+iLVaCLl65fcXNQKCQHUuSTPl6UlOiUBJS4uAbsWnYIa08d6G1ufhqL2WB94bTy1s8gnvvhSDHyJJEUP/NhkHjpAKYUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBOp1RIVw+1M72fxkefVlSYO8A1efQGdVEFgwlU0/ls=;
 b=IpTq6o03GSxgDc2o1pAtZ2/LRixsWr54vlPOHjJfSZmgF7wOYoZHKAqYg7LlyMd3+/7TE/lJi9iP9Ea1tx1Ow0snypTWOmnSssD6OwSe4GdF4LuVMmbPqkYcBBeBRgk8/EjUKliWA3+FC5tjtTHJAm3S2XOSF6viz9JJTEpA9nc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3274.namprd12.prod.outlook.com (2603:10b6:5:182::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3088.24; Thu, 18 Jun 2020 13:51:56 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3088.028; Thu, 18 Jun
 2020 13:51:56 +0000
Subject: Re: [PATCH] crypto: ccp: remove redundant assignment to variable ret
To:     Colin King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200618101229.11772-1-colin.king@canonical.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <dcbf3e93-b370-8190-4374-afd9cb4f87b8@amd.com>
Date:   Thu, 18 Jun 2020 08:51:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200618101229.11772-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0083.prod.exchangelabs.com (2603:10b6:800::51) To
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0083.prod.exchangelabs.com (2603:10b6:800::51) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Thu, 18 Jun 2020 13:51:55 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e084020-fe61-4c5f-c4e7-08d8138ec3a0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3274:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3274D06A60BA729CAD91DEDAEC9B0@DM6PR12MB3274.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:517;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ape+xYpP3x7GXF8HZXReFqkUyjpyEWGYd/YLHjn0aT+JDxM0UT8Pj3sopoN5i8qBUHsmrmf4u1Cnuu08lj6FDiIO9zO1S9J0E4K/eX24geGYjT2R1qf3UWVWsj3pf3/r27kVX0n8NKiZr2vwYdXLXZkenjBzEmhX/xFrI3ddJK9kwCbZ9q6SdsOoaoX6hsJq1GSMbgXd2oTHWKrJzNK+Q+CP6xze9NGouy8Nx7+WQ7S4IgIxkk0vBM9XK9fjUbB7naoQLYixx/LZRjCyQ+aNPtxm76aaQtn67HDt5daJr7dGDD0Xaha3SQtvVZ2/0Hzx/39qRWw3g22j6NgMsoskoUauB980bi48FexdJrAeRlS3alWI52dk3+zUG4OOGdNh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(31686004)(36756003)(86362001)(4744005)(5660300002)(186003)(66946007)(66556008)(53546011)(66476007)(6506007)(31696002)(16526019)(6486002)(110136005)(478600001)(8676002)(4326008)(26005)(2616005)(316002)(956004)(6512007)(83380400001)(52116002)(2906002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: O0W61Tk/q54Azcw7lyaKw72d+YTWHaAEslB2+f+2+UNO0wmvQ9lgNUb7I819MCLE6Q8hxyAdAdi65eGv5I/2/i2E4Rh9C8+e+pVP9IBPWiofEJpP9PXrN2j5gEr7lFRU/WYdSfvEI5ZMyaUNwz6Dk7iFKW4R9gztQByA1VWNVLDh6+u18Sw3EeNV7X1DYyihTbVHEarDjlxrWJF6KzTe+d2B8XPdYUtYO96iA5Uey82KAQdPA2iq1gLlt13xhdA/ZU6UlIyJ/u7NuQOsJAEZmx1nAXQtprKjBLgbuv0Q3QdGVdWhfCpOsqQs3bOX0rHCfm3Lrsl/fpe3nUzlmTZWr685LARpLRulyz6+9d/sMfIz9eTS1Zl5fGT8U3MsU9kUNkq62wL9yhO4N43ZT5+t1pyVSWv7e0ogD5jdomvgLpQFqgPCJBip75NhP5gOu7jtZ1/po5rrZ70BeaOpRVT4cefsQ5rH3S+r+HGJAeYcoTBjxMECu1iSUqhitXtGG6FB
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e084020-fe61-4c5f-c4e7-08d8138ec3a0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 13:51:56.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTe7gFhMgAmDdEPboyfmnAJtpmDjc8xqOzHDt9BUFqBgOG1QTypyFe/lzRiYtOyiJgbt8iZdfUzAr01jvmKYsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3274
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/18/20 5:12 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being assigned with a value that is never read
> and it is being updated later with a new value.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/ccp-ops.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 422193690fd4..d270aa792888 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1308,7 +1308,6 @@ ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   			return -EINVAL;
>   	}
>   
> -	ret = -EIO;
>   	/* Zero out all the fields of the command desc */
>   	memset(&op, 0, sizeof(op));
>   
> 
