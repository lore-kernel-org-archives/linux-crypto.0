Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938A6C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 20:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56FF36102A
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 20:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbhCaUAf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:00:35 -0400
Received: from mail-mw2nam08on2077.outbound.protection.outlook.com ([40.107.101.77]:22241
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236238AbhCaUA1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Mar 2021 16:00:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVbAsTFO+MOtrmw6aVAqsHeqSLFFAI/sOaPDmbGGqrCyLX2jhjHrtx+pYTgDBZNBXN7HlDAp2eHAI7mPqybFaUhFq8ULonOWL6XrtfmII0sdngZLHH51C57RxfGYCGk94gg9GvIqca5CcDcDV+q402cvE/NzKPSzcPKB6xx0pulv3MdcOT8u6qit7JlX/cPMj4McmG8Hw/f+ABf+NZXrXUsINAUqWzX5yY2nqQPEjDjI4zF+Fq+FqKoD35tUWGz9j7s83bcjW7ApEaT8g5IS+HB/GmmiQ3MFwNdDY7d+gFlILG6i1BVnof48Fj7GVua4IrozX0h9d4MIY5XOomGCmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDGQZfQU8XRDdl9xB6Z1T2gAvtiLQw6wt0E/F7HqPss=;
 b=k7nhOGIjx2laB/3DpGuID9/3iY54eEQMYztVAaVdjurPiSokPtwTvi2rez2KvVDyOXE9oQPuXFSymHjuQlDFRzGP/7faXLDKTaD+qryIow+dYT64tqvb2aDpC1UkCz4F9d97cJIGYqsLI2leZJPaGQ9YV2IGrGDH0LXOe4TcXY25dgfd8QD7ZF+UiFdwLSVPUC+klWPiyHxVuSRx2iIDDg6BVqrmLSX/w15GC8K7638IdGh8782viN2YFj9ZJaWY/rjLoXCH7aGJTlUgjXOtLPoil+dBHUCU2QIVFASKmpLMvedttuR+b2Ke7BD73q5mXgck3VtKjCHhPRdZNqFmIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDGQZfQU8XRDdl9xB6Z1T2gAvtiLQw6wt0E/F7HqPss=;
 b=Ifi/if+WgMzOSJvXFvcED5hH29cyp1L+BzwcwWBN3fWn6zOC0VEebG+RkCdzVLQnx3Jhwb6c8pZLbkMXpXos217/MFnWWnrARJ8EX3PYkb5kqfE2LN4Hj3M30BIBqznUd1bxzuuSSeAsoo1Fn+ufb/DrIM02ivRrdV/gBNran3A=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN6PR12MB4752.namprd12.prod.outlook.com (2603:10b6:805:e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 31 Mar
 2021 20:00:25 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::cc57:2080:e945:55ce]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::cc57:2080:e945:55ce%3]) with mapi id 15.20.3999.027; Wed, 31 Mar 2021
 20:00:25 +0000
Date:   Wed, 31 Mar 2021 15:00:18 -0500
From:   John Allen <john.allen@amd.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp -A value assigned to a variable is never
 used.
Message-ID: <20210331200018.GA32734@nikka.amd.com>
References: <1617099029-50434-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617099029-50434-1-git-send-email-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [165.204.78.2]
X-ClientProxiedBy: SN4PR0401CA0030.namprd04.prod.outlook.com
 (2603:10b6:803:2a::16) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nikka.amd.com (165.204.78.2) by SN4PR0401CA0030.namprd04.prod.outlook.com (2603:10b6:803:2a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Wed, 31 Mar 2021 20:00:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8b38c10-2577-4244-b27d-08d8f47f9f8d
X-MS-TrafficTypeDiagnostic: SN6PR12MB4752:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB475299E55F27F14EE7554AC09A7C9@SN6PR12MB4752.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/4PYcn1ikWy7PQgOlTZfeMUquheiQ1s5SlAEzumx7VtB6ysARZ80gRlR+hsbbAcg6DlR8/6T98wcBbVQDe26JeFQ9fPz9kt0LvpP+/9uoCV3VtGPf8IZOaUdhRPSaryWPDJq2OgPOc9B/b1skJ0HJbVgnH5ACx3jIcnI/0GRgQYTRoR70Ov/cA2Hgqn5H3+XqzuUM4E942YTkLcNalZynD5zAYuxUrmPnGS3g3TbgvzkKZYZP/iwXxGd3RIBxXZ5BkgPT9aXo9nGRvAUPjjkNu6Z6KvSGtKzdQxMkfXJeFxJtuJnixJYCsT+I+PkaeKGYgbdQ9SDJyg8wN2FKibq/QjJ38M9MoqoFuAuLFUUCAjkxfy534yzOqybC5hXA5NOJPNM1ASq6B3hYWPxPLp5oSzPXqc34EDi+P81HlPXAqt+JbQeNNlYuZxCW7wgfcCq6r/j7du7zdpqVv+8UxCoW3SOC7SLmJLewuWFgiTgldgrl4JGorK+D854gUmSkq9hlWFVYtY9yab7f5Th5iw3op8/7sM9yRWmhKKc5nfs5fWXva11TAsatEaaQrjZBSKw0RqdfKYY6G5IztWILfDusjfnuiPXMuGv4zhG8I94u0RxlrQPeiso6xfpaBW2EQdWoN9k8BENV0PQgeDmGrGLCaNd7TsvaKQdkljK8X8ZOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(8676002)(186003)(66946007)(38100700001)(316002)(66476007)(4744005)(66556008)(1076003)(6666004)(55016002)(478600001)(8936002)(33656002)(2906002)(4326008)(86362001)(5660300002)(83380400001)(7696005)(52116002)(956004)(16526019)(26005)(6916009)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5mnZuEiiCeZZn4zAJMX/j/1jMek/f6VhUZGaBb/hoOpsyqQ6GyU5nUvG9qcn?=
 =?us-ascii?Q?WOK6NGyyyH34uuPbWWgT6E1gJQsQz6v3Y3SJ8rEfXqkwPKm2mscMBI1B/l+q?=
 =?us-ascii?Q?wiiXHPq/Gb3w/4N7fr/LZbGW3WPkVxtNC0Mgw3wQDVRVaXRKc0f9p7fXqK6/?=
 =?us-ascii?Q?MdRwujqfLMc84B+39eBxssRTRevJ5oTaaTpQf1tiATSVLO9i1mGRyz8J6QQQ?=
 =?us-ascii?Q?rDmzHnr3gWsmrQQf9TNeFzbt93GK3dLVp2XSkAd0ZZap5uxR1h5jBVFBmZXu?=
 =?us-ascii?Q?v1P338q9CxvK5Iz7rvS9zTdUj9Bji3MRhN8IepJPwD7exm+zjiQ5dNR9E77O?=
 =?us-ascii?Q?NXt1efD7ak0Eg83Ivpq3IbYwU7Yxutd/ByZKyeEsPSiRBuWwY7XupPAql0bL?=
 =?us-ascii?Q?OL9Kxu6DYRPuiGuH9SR4b4eEI5INtJe2TAhTg+YPOu6182R42U3IvtkoMH5C?=
 =?us-ascii?Q?n9Xx5De/HLSFlXEGObphMQch8m16KBby33n5GIITOP97gK937Ir8dUth4Br1?=
 =?us-ascii?Q?EO9imalK2yRjMM5vJQ0UsbU81wIlDe5EZKmDtRZyEugnymCpfsI+nIn1zpPL?=
 =?us-ascii?Q?CqnRKUVcWuyZdh3QsqFMLW5pUuIEaTyGtVsotRfmDnCXP01NIt84pJ3nPrnF?=
 =?us-ascii?Q?81u3KvmKJCNMSiQUoZY2yFoeDwt7XmYA+xI9Bdnr3QT+UG3MITeMMjh3/c5E?=
 =?us-ascii?Q?iAIf5dSdOpuBo0G/LRTTWBRQTyGDqTNzfxqsPNuOo37fC0bJC7jNjQGqgHtj?=
 =?us-ascii?Q?iRXJGoc9taYWMEFJVSIGjoF67dJZESiEAp6XXwxHArCkizo8StkZIp87VTeI?=
 =?us-ascii?Q?YebKtwfs1T6EO6VIaw5JaPXNwOYN8Tey6bCf2VwIH2C0vz9xoVRsZdCpJmqf?=
 =?us-ascii?Q?gCvyATsL99hy9n5ixUb6cZr6RpEXFbXFDTbBJzKcfMiiDEvhmf5uKulgQVZd?=
 =?us-ascii?Q?st3j3BooVs2xFK4QmArFij2njJcz6WvRwFEt3JZTco/q4pp8vYPLsP9hxSAu?=
 =?us-ascii?Q?LwwSJ1ayeQJVjHs9mLIK5LQWdzARqIFEcAZaz5yk3AF7KhVckodgTtqxmihl?=
 =?us-ascii?Q?h/O2n+9FdjR+UhTkkLPx4xu3SpwQZRJIIqGaqhEMv0BU3lhsPoclHEW+EVnA?=
 =?us-ascii?Q?1uPAtkVhHbrog0aUysBjXZ4GZ1UYKNWpHvdx+ixZNnhC8GYwHmF90pXhyeh8?=
 =?us-ascii?Q?BMw3ye6k+eu1LMXasHcS9MsyKINlQ9B6K3TTbHwtlgxbQeXZuJ+DDUHKe5M4?=
 =?us-ascii?Q?ypv8X7oR5sa4PY6XNnpXHuuFCJ+8w9dYMn2qZFYK1o+w5kgtbXiXNtd48axR?=
 =?us-ascii?Q?FRUWoQNd5z961WMUvTPc2ZF1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b38c10-2577-4244-b27d-08d8f47f9f8d
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 20:00:25.1500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4WvbidheP+5+egTZXKErirBntvHplkex6JGxN4jLVrNKGhw4HbNw4PfmxxJZPPcpEyfn49hYJ1/v+1UkUwwig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4752
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 30, 2021 at 06:10:29PM +0800, Jiapeng Chong wrote:
> Fix the following whitescan warning:
> 
> Assigning value "64" to "dst.address" here, but that stored value is
> overwritten before it can be used.
> 

Thanks for reporting.

Acked-by: John Allen <john.allen@amd.com>

> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/crypto/ccp/ccp-ops.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index d6a8f4e..bb88198 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -2418,7 +2418,6 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	dst.address += CCP_ECC_OUTPUT_SIZE;
>  	ccp_reverse_get_dm_area(&dst, 0, ecc->u.pm.result.y, 0,
>  				CCP_ECC_MODULUS_BYTES);
> -	dst.address += CCP_ECC_OUTPUT_SIZE;
>  
>  	/* Restore the workarea address */
>  	dst.address = save;
> -- 
> 1.8.3.1
> 
