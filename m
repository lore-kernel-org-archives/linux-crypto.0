Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA63C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 15:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C123323426
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 15:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbhAGPMH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 10:12:07 -0500
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:58081
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725894AbhAGPMG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 10:12:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxhnhTnlzwGxkHs5PrDHKxh6NXQ1eMWi29vH27xEI6mkcHIB0QjQ8Ud2oBD4LL2oMaCBGoQw5KZTkkZX4ya6wiHRCjLQMzC6tdnxha0qRy07pxH6HV5mAEfKpM5dNJkFXzruQgLkMTQpaaDIVAmW8HFczudy7pADzvkhIy125mc659LUu4ERSsHQO3U7p5aGlixtKxTIl0tIQitkfpgX0FdRIJJw0hzG7q0A8puoh3HJHayaaRAsHx8thiw7++XN2ROAgTtnEHa/gsay5LDw9NYMuprGqVvyMjnJr/vjrks3pZISpoEK66C8iUSxJursKpc9u1EEe24Z+Pn7V2SqsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Sv9NfZNEYtaWomCDYpvP80hD6u2WjaUnryrGNUGhL0=;
 b=fhdPLYl0IKmsj1ECE5G+apaj2k6n1jnia7PwTQ8YmqqXG3j51yL+gJdHw/lVQTqAvW+LHtGDbhwa10UcBPBud02paPpeCrrUoEm4AUEMn81RPHVH/2iIrx1basTXZ49ArkB3PGctxvBmE4ywXpr3MAe7SCVXEUKArrejRMDC3aKIg+bD6t9wSqonrZAbQrBogiVDtjxc2xm3sZ9VrNzWoqpHoPxf+PjwhHJaSoZWQTMT8H+tVTrMqCJRQ5cIjftEZQjhxoeoR3mG2bb/sXg9M2BW48qayp/oYJpChGnEMxwymFeTlgoj1t1fB5NC52+CzIHhrgVZjYndJs/5v7S28Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Sv9NfZNEYtaWomCDYpvP80hD6u2WjaUnryrGNUGhL0=;
 b=1jA4YYKqDGScv0zYNPvF1uIt/wSlqkKRC2Lf93+aXzIEhsQzgGgal5Aws0d3AGdyWzBDJ21DPwyCgSXs8i+ZjGQrGfjyl7C3PoqDb3jYtXm1oPel32LlYuZvJ0JKwd+UkslHergHkrtLXnsptOsHdJsLKSs3hAurD6gtjUcJ268=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN1PR12MB2431.namprd12.prod.outlook.com (2603:10b6:802:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 7 Jan
 2021 15:11:14 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::21ed:fdce:2ba8:2179]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::21ed:fdce:2ba8:2179%7]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 15:11:14 +0000
Date:   Thu, 7 Jan 2021 09:10:50 -0600
From:   John Allen <john.allen@amd.com>
To:     Domen Stangar <domen.stangar@gmail.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: problem with ccp-crypto module on apu
Message-ID: <20210107151050.GA30454@nikka.amd.com>
References: <em96a2a8ae-80a7-4608-905e-5d932c0cf9bb@domen1-pc>
 <20201228152245.GA90548@nikka.amd.com>
 <95c0d9f7-e8e9-0b71-1f0a-44230c3dbfe5@amd.com>
 <eme43aecb9-708c-4fda-ba76-a446ecc12790@domen-5950x>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eme43aecb9-708c-4fda-ba76-a446ecc12790@domen-5950x>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [165.204.78.2]
X-ClientProxiedBy: SA9PR13CA0215.namprd13.prod.outlook.com
 (2603:10b6:806:25::10) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nikka.amd.com (165.204.78.2) by SA9PR13CA0215.namprd13.prod.outlook.com (2603:10b6:806:25::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.4 via Frontend Transport; Thu, 7 Jan 2021 15:11:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6658c9ac-7a8b-4d70-7705-08d8b31e7977
X-MS-TrafficTypeDiagnostic: SN1PR12MB2431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2431E13FCF8467F660A36DD39AAF0@SN1PR12MB2431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYqfVW7JLxCK92sQ8Og8VeQE8e7+osV6qxNVk2e1tvkcYUct4YZ5UaLwH+FspDVt4Ic+2U2NzKxtA8KNZm4Y/yXNc3ADUIWzZvSapPFnlmv9WjGJkPXKBOhWK8Ez2cH5nxXUL9zltgDOoBvpw3q/kfgBM504rFeV8xsCOnCdHpge3zqgrToBRG4cD53vCbTnn1J+xtpS921cAj4SLrSucFpfcQMzuuWmyBmg2ns4NFpUse3V/Jd8vUMEzZo7JHh/gB6IuJSx3MTXFd6UiqGHbR7eU/FlwHtc0hPlTzoDVVc0tbXh5t4vOZNClhyiNh6aCoRSIPSWK5q40PJzHuq1se1JNF+zAQrjWDHgzkC6U2kcfiDy9NHIQEhvneKBUs22TXhKSTssQEz1He5fV188Ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(4326008)(55016002)(8676002)(478600001)(7696005)(52116002)(316002)(6916009)(5660300002)(4744005)(2906002)(1076003)(54906003)(16526019)(83380400001)(186003)(33656002)(6666004)(8936002)(66556008)(86362001)(66946007)(956004)(66476007)(44832011)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jl2PfGnhEmnYi3ha5SflWHqejDQb/DMSSEo5RQA2uQdMncWo6f+bhx34dl3r?=
 =?us-ascii?Q?otemNY1+ff9kPT65OJ+ETMOQiktEA6tdsz2I2EGkWotIiSKzZBYtlk9qHL/6?=
 =?us-ascii?Q?7/vtxDhZ5W408EuMBgVmHzZlmaqIrFT1IlZWF4j0kC+uOAsBPiXHcNwFQCGA?=
 =?us-ascii?Q?QMw2+T3quzEdxveYQAh2YkPBmsBx5jMAE4HcZxPeSjXeObCboiJlEACMo4lX?=
 =?us-ascii?Q?8iJaQEILsuuCODsV3Uj/cyBHTXlFxYL83iOi/ugNs2XgInZ9RdXZHdN+bCEs?=
 =?us-ascii?Q?6S9L6xivHNgVpcFB3gOML5+hCpw/fHwY/9PzjSWe+FUKk0bfNhncMX5jk4eh?=
 =?us-ascii?Q?KQwVmnD5V+WmIT8ZhKrBn5wII3v7GjfcGE/BhMGrwQx5aK3TGCauDZOtvzny?=
 =?us-ascii?Q?gEoG5UixJTDIdXBsS98bKMl+8QtWDuLjYhhHLcVAn+8mGrVhqKlRDSS1lweH?=
 =?us-ascii?Q?hQCQ9bW9takANL2koOZj5LB/PaQbuZKzo2RcGDe/w8z/42m4c9QgbbFPiBa7?=
 =?us-ascii?Q?lYygPOXuIFhSf+574P6xyE5mttMessoaZcI+ZL0/mw/6peMBCMcP1Co7a0zc?=
 =?us-ascii?Q?61zYI1UEAsdMYEGht8NIzBJUu8kzNd8OWDIXOgx2qC5rY+ozg9d34xRmoF17?=
 =?us-ascii?Q?xU+UJ2wSKfqd05JOZb0oTaUIlqjcrxtTNwDYnOZGVb6Yb8okgWUa0m1sPOqg?=
 =?us-ascii?Q?9wjMLoX4LAfOXTvB9mfmB/Evjxco50Ez1fB/8Sxdl4nEYEA+ahkPO9/SJjb7?=
 =?us-ascii?Q?IWygHaE4/a7Fd9hY/R22O9AoxuRs4EO9EwWj6c9FDem717PIUwcpjpbaFUUF?=
 =?us-ascii?Q?ZLHMPkvAJaW/yrsL2ivF4QUmOg6nGoXymfFYLzTHYfElRqnS3onxF6kivBTO?=
 =?us-ascii?Q?kCMHDQlNEekSdpnqpV7l5IY3HnMHjfa7Rgt5uAPartn99U9atBLT89jGRDsV?=
 =?us-ascii?Q?X1AhzLuyHxXzZauM2BvRm1YqSUJ4KNrxEwkHjP8rZTo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 15:11:13.9849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 6658c9ac-7a8b-4d70-7705-08d8b31e7977
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpkyH16Q2l/zBna/vfvul6y6mM+rpuMrzNFNLhXkdvYsX22rx73vncNamoAqH3C+hkJN5hMSq8gbigu6bdeYCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2431
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 04, 2021 at 04:10:26PM +0000, Domen Stangar wrote:
> Device name: ccp-1
>    RNG name: ccp-1-rng
>    # Queues: 3
>      # Cmds: 0
>     Version: 5
>     Engines: AES 3DES SHA RSA ECC ZDE TRNG
>      Queues: 5
> LSB Entries: 128
> 
> Let me know if you need anything else.

Hi Domen,

Looks like we may have a lead on this problem.

Could you provide the following when you're loading the module?

dmesg
/proc/interrupts
/sys/kernel/debug/ccp/ccp-1/stats

Thanks,
John

> Domen
> 
> > Domen, do you have the debugfs support enabled? Could you supply the output from /sys/kernel/debug/ccp/ccp-X/info (where X is replaced with each of the present ccp ordinal values)?
> > 
> > Thanks,
> > Tom
> > 
> 
