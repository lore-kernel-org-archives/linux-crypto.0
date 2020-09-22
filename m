Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD99C4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 13:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED87320B1F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 13:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="18D+CZcZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgIVNlL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 09:41:11 -0400
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:3009
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726576AbgIVNlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 09:41:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KySX/cdr2cJq2azLbkyq+NybDZ2B/vU8hiBdc5pI7gT14f2shexfwopAPDv51TA3OM90B2gWVOP6yVUvsKlcqUDWBH7VwY0zJz5NjcixdTSnb5yjnSRaGIVOz3A+hDbhHlBYDLBoJvp0SHWn/N4Qu0Q+S+4qFukPiEdAMH0TVSQtvRnsh1iI+tf55HfSl1GQxr2MhKjga7TD9IvK6i8nDxin57Uk7qZEy0YL9XiSo79veUCGaWX+cI8sWuaxql8b1c5zoL7aduMYQ2tx8mM/+Ktt+yOTBu5kGjjou3L0mH7shk5mIS5h81hEVRJnf2YU1I40bCuILRttWVfnpA3Xjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylMbd3LjXvnyrrVWPsOvwQ/3x0p2lLKvYR58z6x2qX4=;
 b=fjcPsavt2v6eblk3jRFvFo+qfAYRqZjSwQ9/2yJiX0lHomk3emtVvy4rV5nS3CEJonsDT7mQEBGi6YqON2nFwnZAscZtLI+KUmPONqOYKMtbSkYsE+zNJU5+reWkG6qYwwQdYPYDeZKRHEfEvZikZ1rcRb2DuyLFqpHsvaEkaVgF+Bv24i2MThniPmMqIh0Pb823Wgg1KkAP0JWAwCIftJ9GpUBJwqszGhBfGMWs0mmnTNJJZo1aEKa5RIDzsK3rGnhEDenEO0luwuEXzz1EREqkwh7/P4qKFm6vwKLqzihY4xDlNObvwOnBUlc0JbZlvpVDrPocskkqChv9jkY7iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylMbd3LjXvnyrrVWPsOvwQ/3x0p2lLKvYR58z6x2qX4=;
 b=18D+CZcZ1AT9rNXvuTCC3O7lUN87AiF8uFPv1IdvKKQVZyTp9dv4QvVne2brJJ1szI1neEFYTQmE90v/s6JVUAqhan2YUH8NfwCgT3dpY+nJ7zDItItJrv1VReyHHQKTt+/xCuPt7I+KNYlATs9PwfyPUNjs+BEMLA7wa0RUH2Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.20; Tue, 22 Sep 2020 13:41:08 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Tue, 22 Sep 2020
 13:41:08 +0000
Subject: Re: [PATCH] crypto: ccp - fix error handling
To:     Pavel Machek <pavel@denx.de>, "Allen, John" <John.Allen@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200921113435.GA20450@duo.ucw.cz>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <620833c5-a2bf-852e-16f1-f8ed04bf8fea@amd.com>
Date:   Tue, 22 Sep 2020 08:41:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200921113435.GA20450@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:3:ac::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR21CA0006.namprd21.prod.outlook.com (2603:10b6:3:ac::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.7 via Frontend Transport; Tue, 22 Sep 2020 13:41:07 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f47ee9a-5118-4503-2ae7-08d85efd28f1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3179DF7656937C446976F2A4EC3B0@DM6PR12MB3179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CvBvPCAUNmQVKEGV8+iz4qMt8NlQmN3jcdtsH5LvLQhwEWz15ULYZ9k0U9G1iU2UEsTyVLEPxi1E4xvUqjGK0sLN1JYajuonovKVi/3L1ceVcZj8Bj2dH5gAcKut1jUbbcW9JOrjZIDEJeG6tJNTTrZg5/R/AtsYdEbrjUQk5CXsHFx8YnnJ7LfdbwNCx2zybjZqxL3ycRQKzLpzC69j0TvSarVyK3Ei411yfLQ+ctgW7J7hOavXaAL4Z8+LltPc8qNgYYj8GIYjHk8cRQVvDX4w2vZW2zcjONDTcuxOWa1yPoAbeHgbRIedTwMJa9/hyLUwDZDVD6yE3Vl63I0N/oDZPgCsOP2aqme2E1w9C1HaI/THzoDKug537QIHy5ZF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(31686004)(26005)(52116002)(6486002)(53546011)(36756003)(16526019)(478600001)(186003)(316002)(2616005)(956004)(110136005)(16576012)(8676002)(2906002)(86362001)(5660300002)(66946007)(8936002)(31696002)(4744005)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OXAGnMIWUeRjLqVQ1uVUA4m1KvE7/CreD+oPklmAP2ad4/qk1dLh+CjiiTHTX6YhN92viMym3u2ur8k85uuGJmHseL2GhLBgXMuBeDkIN0QTe6x2i6UtmO+qzG/ReZEEc6u0frlv4ndfYdi4Wj5NN7vIK1Zd7TpiMRpmp9XOdRxfJ4eOO6qe56oEv92NznRS6pmuNEBgnELRh0XUU4dkLoz/yxatRNvEIknquNWOQKWdN7MV7H1O6n2pKzPY0LOoYnlpkhqJY2frJW2YLavwox7q9hi73URk2AojYNNPNgysETuN0k2PBf4tDneQGarBzEi+UL51XnPKQR+cVUPsNUpVrOcHnSKJyruucRSj/D90YiAF72lTLjx29ymfq/ulbYgbqY0skbjzz7BNKzK2nq7QbgJpaipOity5oCZev/Kk12tJ1w+L0lz9r8Em3FuCkjYgorIZdiDFuQWelZHTDjfl+H01EtKKIb1JLzzkAfnt4T8zeV65GkPif9hT+n9rO3Y6fVSsNYrhBnAa5zQCMhMzKQc4pr0ePSbXPrQngjkiXxZdPpej7BX6leBDj8ivrz3UR3226ErTUoJlFjDiGOQ9RikzgOoN1OZkFwW4T+ty+AGq/166wGqOZeidF+tn0exNS/VQWpbrgw7P50qNRw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f47ee9a-5118-4503-2ae7-08d85efd28f1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 13:41:08.6132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXC3wEt6p7lhtPjt9rwl2dqz/X/OX9IKuHUXjdd1NS0+Sg+R/THnL5wRlsgR6ROxXCY/eeyPyJjCBSVOTKbnWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/21/20 6:34 AM, Pavel Machek wrote:
> Fix resource leak in error handling.

Does it need a Fixes: tag?

Thanks,
Tom

> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index bd270e66185e..40869ea1ed20 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1744,7 +1744,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  			break;
>  		default:
>  			ret = -EINVAL;
> -			goto e_ctx;
> +			goto e_data;
>  		}
>  	} else {
>  		/* Stash the context */
> 
