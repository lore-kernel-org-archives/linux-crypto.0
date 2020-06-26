Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D00C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CF752053B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:03:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="2zX8AiNk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgFZTDf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 15:03:35 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:16705
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725275AbgFZTDe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 15:03:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F873ehxY8IHVrF8eQ9MxSWEJbt6gkhxjCi5AIq/QxeoOFA4O3A2GPMSdY60xBUEmHDpFmQd3sBsiRRx1iDdk2dBIsvboM7bMQhcZkH+FuqbsbMbA3EHd49RWmjl17rbAcYR/z2+Afw2Nv4Pb8e5qaJ1rPIJmvi2QBPDkGWwjojO99rkZxKPxGVRwuEi9bpOPrlSeuGMvNv1wCQOsyXIrFWUYBC5vVIvGJwZ+WKEdFUAErM7K5mSPgLKz3t068x00bKUEwzzItKY1q9GnZUxs1CIqyPdb0X/z+saAWe0wLDnrM0J5d1RCNCx/AWJFs7S+wlzEPh0EGRDAhA4Sm7jOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmW86HBDORHvRMJrEeQDqr79A3KqDd7+FCszJfPbt0s=;
 b=XaDfH4MQCo3Vqne1ZyEjEl3KNSJpjPqTBt1ehIVDCTIfzyKDUPySSMQV3VBN/wr4V0uuF6+Kgy3O8NWQ9VB1Q/YELZFdzxdniy2II1llWNWKjAzVVK+hJLh8zG5ftziO52xgCj0lg+1H2K1lfsGT6lMl60GMqpxaoOxwCulXr7O9lWyCx/NGoTUt11iUA2MDVSvqPQmFpyYkIR1mC3atx7jihImY/Izv5CBjBKiqJVreC0645lWcImxjVEAXE2GuSGC5OHhQWhM4bjpAo2F/Tzcey1MJLZsxB55OTh1Kz0NfACU+cnQGf/56T/XMxb/169uMP8mafpUoxTC+McBpXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmW86HBDORHvRMJrEeQDqr79A3KqDd7+FCszJfPbt0s=;
 b=2zX8AiNk0CUkcuzOCvAVTus6x4LMhObLF3ZuPJzO4fd1fB4r7AmcLfo6RiruuWkbgKniKeHAeVIgJIKu1UUSsKiO0UzNjoCcJCcW7HYjIJ2Jrn5dSrOLesYTlbhFEqQtpYgF44mUEZShUzoUq4GE6KleroyhEbvrAXwxKZQoVDo=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 19:03:32 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::698e:73e7:484d:e3c9]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::698e:73e7:484d:e3c9%4]) with mapi id 15.20.3131.025; Fri, 26 Jun 2020
 19:03:31 +0000
Cc:     brijesh.singh@amd.com, Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        John Allen <john.allen@amd.com>
Subject: Re: [PATCH] crypto: ccp - Update CCP driver maintainer information
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <10d21bb66593de4ab9b07bd4fa053b5cbe2d9278.1593198017.git.thomas.lendacky@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <78c7302d-49da-e911-9dd5-7d065af6f0dc@amd.com>
Date:   Fri, 26 Jun 2020 14:03:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <10d21bb66593de4ab9b07bd4fa053b5cbe2d9278.1593198017.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: DM5PR06CA0057.namprd06.prod.outlook.com
 (2603:10b6:3:37::19) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM5PR06CA0057.namprd06.prod.outlook.com (2603:10b6:3:37::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23 via Frontend Transport; Fri, 26 Jun 2020 19:03:30 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b3a1cff-ecc0-4aed-f265-08d81a039e59
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4447AD35B0B21E0C1B50FEBEE5930@SA0PR12MB4447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIAR3x4buBdWd9dugJMiAIDcwElnFJ1KwIUJ2TcX0broKH36mAcyGGRIfZt99eAAxplLz5LkjPAlNLzl656igUJ44nTw16iyU0WTtgsdsS+QhenX0+kOY4C/UYKGX9h4XvIEdKmTlK/w47lmbjBPQPi0UhblF0j8EblE01/U+FKZXHChAkdmBRNtRkA7ghcGJq+mJkvTs15Z4R6Evlyv0OkbBBdqoWAewZC9v6hNE/DztrWEpCC4tXwt0w9v4+aLv5meXnpOdi2wpL2RPfpgExmzGaZJaeOQIrk6MAFrRyg9A+l2WhX2gkEKQ3w0RGzMQBf+No/PlZOo7zlHJw2Lc2ssSHvGAoWIWeeOxcuSj9wNkDK6YxHKgKRaG9e9x0Tr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(478600001)(31696002)(2906002)(8936002)(8676002)(31686004)(52116002)(54906003)(6512007)(86362001)(66556008)(6506007)(66476007)(53546011)(36756003)(26005)(186003)(16526019)(316002)(4326008)(956004)(2616005)(44832011)(66946007)(5660300002)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kWNFcuaEigMoJyErig70Af+QnkydfeXOiz5uAd/zJUnMusyNgQyCAXwsfNOHcdRyynjaOFS+x9SUZWGPmSqewtj+9spl6MbSYWdj2j8ZSPk+Wn5Q8KrleUb7h4V2pPfR6ESQgz6lIh2Ooc4Exo2ZlYALsC1aPt0VoVQ/yRp2V9NRqvWcleWOmcD6eKztoi1wS/ODKfyclZPz2tSxj7bI3RrmYWhQK73RoMKPbTCaA5HfQZihAW+VJuwqAHW1FnLkim2uGliyiOA11DWo/Irg0ofW8b2CBrTfYUwcKPwGtacgx8FFLCdr+4HHZgggPj4TarZyl5zHTZeS4I7ou9d3W7DNXPc3v6y1rKG2PtgwtCWUcujT9C+cG3oKoE9W214j5+rUkDrE5mNxOLuUoV9Fu/1ikTKZ/v7xgS3veYFJ5DeA3A6yxOfKeVMK+kK/zxmrnWqElfqT09k22ID4HUoly0jdvl34uD78jW+/c2/IEiU=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3a1cff-ecc0-4aed-f265-08d81a039e59
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 19:03:31.8596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zUEh6n7+803JkRn6AcxwVUcHbuzw8qfoUqfFzqXi6eNG2riJx0pDBYJmi18fhRJiIQIb+LhsTW6Z8s2c4VFHag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4447
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 6/26/20 2:00 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> Add John Allen as a new CCP driver maintainer. Additionally, break out
> the driver SEV support and create a new maintainer entry, with Brijesh
> Singh and Tom Lendacky as maintainers.
>
> Cc: John Allen <john.allen@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>


Acked-by: Brijesh Singh <brijesh.singh@amd.com>

thanks

> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 68f21d46614c..8af94aea20fd 100644
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
> +M:	Brijesh Singh <brijeshkumar.singh@amd.com>
> +M:	Tom Lendacky <thomas.lendacky@amd.com>
> +L:	linux-crypto@vger.kernel.org
> +S:	Supported
> +F:	drivers/crypto/ccp/sev*
> +F:	include/uapi/linux/psp-sev.h
> +
>  AMD DISPLAY CORE
>  M:	Harry Wentland <harry.wentland@amd.com>
>  M:	Leo Li <sunpeng.li@amd.com>
