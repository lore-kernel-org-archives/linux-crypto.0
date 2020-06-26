Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B413CC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 919F6206BE
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="y7cV+Mtj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgFZTQG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 15:16:06 -0400
Received: from mail-dm6nam12on2074.outbound.protection.outlook.com ([40.107.243.74]:11776
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbgFZTQF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 15:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNFlZ7c0MW7p6XgiKhR+uwWTAZi0iEsyDOiYwYJxLxZcpEfWlBCl0g7WyFOjD88uxMooQk2cY4xGVzxZVsKgYMHc+xWbCnprNnpmCyKMfRebEYbkjD4LtYX/qUgNLhMt9Gp2EsmQ7ZOE2qWpXTt6nse9LDL0qxsupLA2vtIFAh0++qZBrOL6sCnYM8izjgwgsQlF43iiYh8tZyWe0OHAId3neXQgT4wleL1FxzcoD18ZKFBxFaxiiO49u30SQiqK2LEZOUO04x861R2nJd178lcHNTOKUBMkmhWLBdEbkVzM1OaH9EoXocv7FRqEBVo/GdRqUfe6oSAMopIVs1Lc7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=If13ripyUo6hq6VM2A1JQEkYuqTiRYHAeU/1oYFGGw0=;
 b=PN+C2ixlWAzLwTQJzS28/DOaJtvUpauUVwkczaKOGl3JfZpVXdsUuWsdjbD58jf0q9FFHtK6LDiiSq6xTDGRXwSt3zCDSg//cNhUGfbpR7VyzMzyXlSaWhj2TSCjNHVdn/8rt2nSRx45uBOc0VdkoIYZQJ/7Vz0YrLtFytwUiaaJslz7Y/Bky4rtb8u6+65p/TKBK6YoWAZj95R+rwVXdoqqVx2s4QsX3WapoG5RirriD4wM8JwZYQqP+1EWR+JP4wamMWnJza/O3Tb7C44rXrPe0ZDefRZkw8eCF+iiX/WhAgGHWxgu4vpkF8i+AAoDwQ12jDjyAc67MuDF5jqRPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=If13ripyUo6hq6VM2A1JQEkYuqTiRYHAeU/1oYFGGw0=;
 b=y7cV+MtjFV7WF+HrR5MLF0O/ENJi3LH5q5USuY+wFXpY5Cv+qfG04GxX6+Of8PcUsR5yS4yURI1H65gH/MqTZZWeUvgXxZ2OaEbvEwSV9ZKV5scmmlUOj8ySffQVFv+a9ai0gcBJCoN438AJXPrwplsF2l0VaLcr9+tGxPYAeFY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4542.namprd12.prod.outlook.com (2603:10b6:806:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 19:16:02 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::698e:73e7:484d:e3c9]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::698e:73e7:484d:e3c9%4]) with mapi id 15.20.3131.025; Fri, 26 Jun 2020
 19:16:02 +0000
Cc:     brijesh.singh@amd.com, Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        John Allen <john.allen@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - Update CCP driver maintainer information
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0a2a04b15abc35af1ec651b3f45d43365e286ac4.1593198579.git.thomas.lendacky@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <dc9a5d00-fe99-3f10-d87b-2e5bdb48b2c1@amd.com>
Date:   Fri, 26 Jun 2020 14:16:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <0a2a04b15abc35af1ec651b3f45d43365e286ac4.1593198579.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:805:de::46) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN6PR05CA0033.namprd05.prod.outlook.com (2603:10b6:805:de::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.11 via Frontend Transport; Fri, 26 Jun 2020 19:16:01 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e90c0209-2149-4cbb-b4bf-08d81a055ddd
X-MS-TrafficTypeDiagnostic: SA0PR12MB4542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB454215B285438E883B41DA66E5930@SA0PR12MB4542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hEn6pBlx9xH4p4H6FL2nNWrRd5JtEhcl9uMAVK6mqftWqgnc7qdFGQ1CIwBGq89A2M/6aErzC5AMWTFPvAbQf02YLW6GKB9S0pduWqpVjkekftk8ROL/QsxrKKodiaE1sC4gNeysFDxQhHTrHMouEA3VXclHXQ6G9ow61CB67pKxERQKU/BGS331zTHe0WQ2mShkMteoKpOuJcXP/iEF1sXc/uGhPIP1mxG1pOC6G41ZIbWneLHVQhiZAoLE2J+k1xXJQ2Q4owKJvxznXYNJUINZKTyqlgqEcI7aEzE99wl8kYUUJ7zTRRdiQhoggg9KGEIGDD7Cq4IAnNrpT7tg4s3yX83y9pEdpxCYH0hr7lOD7I3kpmOKheBzDAKSk92A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(16526019)(54906003)(5660300002)(316002)(66476007)(52116002)(44832011)(478600001)(66556008)(2906002)(31686004)(66946007)(8676002)(8936002)(6506007)(6486002)(6512007)(26005)(53546011)(36756003)(4326008)(31696002)(86362001)(186003)(956004)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Iaw+PkYqjPhxFw4rZxNpLcBJK2LqaiSYCqQmYyNVVp4wNHOsvB2+Sy3UR2fnzL96fdQ07mnP9QcJVfDDBOsG42SKCG8Dn8Vx09+rABPYNh58jGPU0ybXEUgyHlgEAwX7TGapJV0UakNHDOel6almxQLW8JZtyZ7hXziOPbpKEIbBay+PB6C/NZBVshTuFhRykGslZWkwvkkyaahykQi3xfHO004Sx0VLcEPK8EtKba78ViBvwRf63pkJRfU9dMsw0Z4VHbq7zGN76z3viEYpabgR7O0ULbkTE0/oo+1T5bfoAGsvHy7ZZ3/K9jeim8zc6jXLx9Dfshqi0c1f3AN7TjU13Bc0Um1+egj4QdfM0N6aRK7g5Plv1fS1y63iG/Id5wZXKlnBhHJtvXbl61GMvjbTfdwOhu/WIgxW++XON4RbN9M07d2SAykNcJ2//CQhUNujUW5TbM5wZi7fTp454yDFdmgtvk0siyhl4Ooh2n4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90c0209-2149-4cbb-b4bf-08d81a055ddd
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 19:16:02.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FaL0epoin2ouXiEdZ+gJdDiSs7J0VZM0S2UF8WF+a37eThZMFejRmLMRGldA76RINrfYp4bFh5lQFxyO85UUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4542
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 6/26/20 2:09 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> Add John Allen as a new CCP driver maintainer. Additionally, break out
> the driver SEV support and create a new maintainer entry, with Brijesh
> Singh and Tom Lendacky as maintainers.
>
> Cc: John Allen <john.allen@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>
> ---
>
> Changes from v1:
> - Change the email for Brijesh. The previous one is an alias, use the
>   proper email address in case the alias is ever removed.

Acked-by: Brijesh Singh <brijesh.singh@amd.com>

> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 68f21d46614c..de266ca5f921 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -830,11 +830,20 @@ F:	include/uapi/rdma/efa-abi.h
>  
>  AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
>  M:	Tom Lendacky <thomas.lendacky@amd.com>
> +M:	John Allen <john.allen@amd.com>
>  L:	linux-crypto@vger.kernel.org
>  S:	Supported
>  F:	drivers/crypto/ccp/
>  F:	include/linux/ccp.h
>  
> +AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
> +M:	Brijesh Singh <brijesh.singh@amd.com>
> +M:	Tom Lendacky <thomas.lendacky@amd.com>
> +L:	linux-crypto@vger.kernel.org
> +S:	Supported
> +F:	drivers/crypto/ccp/sev*
> +F:	include/uapi/linux/psp-sev.h
> +
>  AMD DISPLAY CORE
>  M:	Harry Wentland <harry.wentland@amd.com>
>  M:	Leo Li <sunpeng.li@amd.com>
