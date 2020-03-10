Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92B9C10F27
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 14:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871C520848
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 14:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="4TtugL9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCJOhc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 10:37:32 -0400
Received: from mail-co1nam11on2061.outbound.protection.outlook.com ([40.107.220.61]:21473
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726462AbgCJOhb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 10:37:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hp/DJMUZWi0EAuSJG1adodnWhypNY3Ktl+65tjyrRwFC95o3wWZMMoE0U5l/c5JGLWe5YMZG9mnROWNlgypOHhkK2lcmh3SMGZ8bEkHxsmhMLtoFHprYDehwlse7Gq4256pf4byaVirRlWzCcgqbE+HO7jCLvCRgUeayzDqufXOWq4tKbTNj6gDx3vsBlsxhRoEkExBZZ8Ybhak3+OOe8GZgc51bJCLarrQ0rQp+Cfm4B40HCZFnkT1mqU6k84Qxh2/nVynF3c1lHDsnlgGyvnfmG1/RFu3PkVOhvN+5pfN82GtPrGCaBx9PoIzhOxaN3QRn5+yc6aMfi/QnizX3nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GF2kvLbx1KjcEBGqQrHCxqmUHqTiWRp/UlydL6k2L/I=;
 b=PVg+JzwGp8xTVfTGpSFHohe7/MMQsAdhNtZK+y+aICbkXWf+ucRPjVP/t5vMaqRM09fUnWJUAAaWLKNugaR/wv83rxlh0ajrf3GJXCepa+B3m/k9/gFwp0gKgpjf4JNR84G+5F76q8DBHmGwFoXBtfxcSHuKLdI19KBJL9Ccp1Lg1N1C1UWW7spDrRMbRQ8fcm4tz7RRCIv4RdblgSgf82cWmxSEv1yNQ2nm6qfTEJkY+QYKeGSD0Lth8TlhrwWmp42BpoZc7Vu8Hk3SxFnktGm5MtVjeXq0eHMf7WT+BS05ARygwk6W3Elrxid/6Gd0OLZ8bJ6M1Lzdf4nnRC+pcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GF2kvLbx1KjcEBGqQrHCxqmUHqTiWRp/UlydL6k2L/I=;
 b=4TtugL9MJ3qr9Pwq3cRtGRBhXpOgf0MB6OTupE4x9w2V5nBgsS/uc6teLgzE58gcHwGFbtV7ijp/qGipDLfCdS+XsVTMPc+RrmsNeUUSIenl79TV126ky3kzeX/2fUKfWj/psJJvBbEq5kf/YJP1RJrVJ/QEfY/HFY62jtesabU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from CY4PR12MB1926.namprd12.prod.outlook.com (2603:10b6:903:11b::11)
 by CY4PR12MB1606.namprd12.prod.outlook.com (2603:10b6:910:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Tue, 10 Mar
 2020 14:37:25 +0000
Received: from CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4]) by CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4%12]) with mapi id 15.20.2793.013; Tue, 10 Mar
 2020 14:37:25 +0000
Cc:     brijesh.singh@amd.com, gary.hook@amd.com, erdemaktas@google.com,
        rientjes@google.com, npmccallum@redhat.com, bsd@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: ccp: use file mode for sev ioctl permissions
To:     Connor Kuehl <ckuehl@redhat.com>, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
References: <20200306172010.1213899-1-ckuehl@redhat.com>
 <20200306172010.1213899-2-ckuehl@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b037d70f-c23f-72d6-3866-57cb1e501eba@amd.com>
Date:   Tue, 10 Mar 2020 09:37:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200306172010.1213899-2-ckuehl@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0057.namprd02.prod.outlook.com
 (2603:10b6:803:20::19) To CY4PR12MB1926.namprd12.prod.outlook.com
 (2603:10b6:903:11b::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0201CA0057.namprd02.prod.outlook.com (2603:10b6:803:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 14:37:23 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a96b45f-42f4-45ea-98b0-08d7c5008cc5
X-MS-TrafficTypeDiagnostic: CY4PR12MB1606:|CY4PR12MB1606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB16063F38C0B46130DAD28013E5FF0@CY4PR12MB1606.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(199004)(189003)(31686004)(5660300002)(478600001)(36756003)(81166006)(8676002)(16526019)(186003)(4326008)(81156014)(2616005)(86362001)(31696002)(956004)(26005)(66476007)(316002)(8936002)(6486002)(2906002)(16576012)(66556008)(52116002)(44832011)(66946007)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1606;H:CY4PR12MB1926.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w+PvEbvF8B5KfMMuXq+XVBZfgYKc1PZgX4WuOnIARzQcBeHTeD7ZjTBpsIs3lJ9bzMgLFH8yDpwReA00hcIwfU8ylFPnnW6PjY5AoQagjCXyb69mtnueTvFnOOM5VGy/x3rQjQrIUaq9pdJx0bsAxTYapdJQdDOkrJ4sDN26Q7BY6VF3BvyY0MHXCL2WFwFEBPchLnlqzRISwWUkQmyfR9OG0hw96nKQtU02Eiau+YLre/Cf28SOY3hYB33W3/mfHGETP6DGCAWjN6m0gU5C66trZ37yAnzDkmQ4yRfD9D0/ud40FdxnkPVwLnd9dzdldnGHOphQBGLt/v7F/FhBpbFU5PIGLDIG8VfHbUgOb51oIBi2wfcJ6PD6YOFRNm3Ez56lFwH/+ZIF1GY5aDdk2A59tgengmLjjoTy5dCfk7Hg9mGXzZoILUnpmPw+lfKD
X-MS-Exchange-AntiSpam-MessageData: +ngbBnTRn0Mr7cLCP/JleI/4Fn0MCWxoftTvdQbaPVo02UWiAgIovfyL2rqoXm/OE0IVM3c49fpGfLAzWU9hVIe3r+NGX2HEOBPvykcwvCI7040PaILY82s7iliDaqmLTp0KBejN3NRVFovINjT6Rg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a96b45f-42f4-45ea-98b0-08d7c5008cc5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 14:37:25.0825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCtmS1t5qcpfS9t9mc9TrRdDZU5C9m0HUneKlqGb2KcHakwTnZOhfWl5LAZhisfDGRMZvmwlJqQY86uxpJznfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1606
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 3/6/20 11:20 AM, Connor Kuehl wrote:
> Instead of using CAP_SYS_ADMIN which is restricted to the root user,
> check the file mode for write permissions before executing commands that
> can affect the platform. This allows for more fine-grained access
> control to the SEV ioctl interface. This would allow a SEV-only user
> or group the ability to administer the platform without requiring them
> to be root or granting them overly powerful permissions.
> 
> For example:
> 
> chown root:root /dev/sev
> chmod 600 /dev/sev
> setfacl -m g:sev:r /dev/sev
> setfacl -m g:sev-admin:rw /dev/sev
> 
> In this instance, members of the "sev-admin" group have the ability to
> perform all ioctl calls (including the ones that modify platform state).
> Members of the "sev" group only have access to the ioctls that do not
> modify the platform state.
> 
> This also makes opening "/dev/sev" more consistent with how file
> descriptors are usually handled. By only checking for CAP_SYS_ADMIN,
> the file descriptor could be opened read-only but could still execute
> ioctls that modify the platform state. This patch enforces that the file
> descriptor is opened with write privileges if it is going to be used to
> modify the platform state.
> 
> This flexibility is completely opt-in, and if it is not desirable by
> the administrator then they do not need to give anyone else access to
> /dev/sev.
> 
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
>   1 file changed, 17 insertions(+), 16 deletions(-)
> 

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

thanks
