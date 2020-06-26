Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9581CC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72BEA206BE
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="tATA6D+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFZTPP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 15:15:15 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:40567
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725275AbgFZTPO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 15:15:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD74S+AZOVFNbuHoxaeKDtcQdtMgQlfbTuVXO62GSJjN0co+oCnyTOwccVvST15QLcxn5NKkOgNJjK+RHwSZU9ajNXA4NHuiSUqre34D6mR+yEwvvn5jJHwdLtChe9VKCn9GZwV/K9SsqdJy80BJJRXngVPAd+4afz4w6muHcrh7uENGtDJ/RDLAxJohwgcQPPKDld8Xq46Kw1SwqsW8AyrKBEixFDW3ZcA9fIGO7/A4wzg0Nh4hc/NoiRHE1woekHGVTf83gUCQZjNN+I5G88hRxd9ROQBmjWIlr5pA+FnzEIdzxLDQYEBPm/BM65qrvJWOJKtuZBORCp9mOBfQcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un1lH3DlTwIdGDEFYAWzJx6J3XkaOg7zO6bQJ+uo5GM=;
 b=CKP8nkAoDMH//APUa/wA4VxmVii+Q0AEwjUTJKEfdgS4dYDy78NRuv3iFcMAaert5lI+bSkZ/NKkDSqrtb98EeECOohztF2v7pTEkiS2eUxQRmZynTLtdVXrnhsmRrhPZyvHuSbUI2gsS/5ayYCMg9eo+L4oC7wqOqR3/7tM5knjwDf3my07KbDwz1mdq2n72KXlAUaAr+iDgw2W4oIfzlw8+02QIo0LCB4YX56Tq82Qx+KzTufwZ8IK8ZGqSaxXEu5j6bheAzCq7rXczcxBF0jr/KZ7oGKv8SkCyJ+QFRDNvPCfad5mi4beHbPsWdcdOrkvZ1FRST45obs7MRs7YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un1lH3DlTwIdGDEFYAWzJx6J3XkaOg7zO6bQJ+uo5GM=;
 b=tATA6D+D/lo5/lXkuBdYGqAlLTJdVPRYH8ucYLADvmsPCHGwUZZtNsnheXvtZgiB7tibCpwz6N84D6/43wPtesCnQU0AueCH7mDRgGXLv6UQoZo8G9NPuiPGixfFsF0YftEW9x8t+Qvk1Xj2ECetmfT+mUIQvRzxhQXpzL69QkE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN1PR12MB2589.namprd12.prod.outlook.com (2603:10b6:802:2c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 19:15:12 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05%7]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 19:15:12 +0000
Date:   Fri, 26 Jun 2020 14:15:03 -0500
From:   John Allen <john.allen@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - Update CCP driver maintainer information
Message-ID: <20200626191503.GA115589@mojo.amd.com>
References: <0a2a04b15abc35af1ec651b3f45d43365e286ac4.1593198579.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a2a04b15abc35af1ec651b3f45d43365e286ac4.1593198579.git.thomas.lendacky@amd.com>
X-ClientProxiedBy: SN2PR01CA0013.prod.exchangelabs.com (2603:10b6:804:2::23)
 To SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by SN2PR01CA0013.prod.exchangelabs.com (2603:10b6:804:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 19:15:11 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4d8c9ee-ac2e-4710-6e7f-08d81a053fe3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2589F0100F19E6D59D387A399A930@SN1PR12MB2589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCP1v+B+lAmXO0hdcOguhVae8LdxoAZUTCnlJ2FbXW31Aybz5trJBCWXQC5AF3WLA404S2F3WwlwvJBlsu/Vdpg3tp5USryTGxHMzJ/5xx3wx5dxPCRLeD7dc0tsGifz3Gfop3Ze5QL8IhAFEN0q8Rbx77r4+P2HX8mAt1hzoPlNRwXTN+kFGE9rRUH5L07x4VaS5I1+Rh1Rl13zVYc7weEKCZBJsrz1DdF9lwqwLp2jm87v9gvekk6vtoqKgeTV60/x45tjRMv3ThkHhdgIwrek1u/ku0M2Zwv0Ug1UbvBRMQy0Aiq+bBEzHPAvntOgbrc/GnkRJXFu7UnD5ZV86Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(26005)(6666004)(86362001)(66946007)(33656002)(16526019)(66476007)(186003)(5660300002)(66556008)(6636002)(4326008)(1076003)(8936002)(316002)(54906003)(55016002)(478600001)(2906002)(44832011)(52116002)(6862004)(8676002)(956004)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4ixqBmM4jPOMDct6iHRYG0fKHrqgtPAf43WWC0fx0z1ywnKqmUz844B4/3FssA1GCgWE1a9zp6Y83reDN88MRBxOJjlqe6iU5xKjzUdHOQlQQvifB/o7UTajv/hiVONylaiXYts0ORQJgOmRT9Q5kRDxhRL6lT1qFB6rtajbOqsNr8QqkNvRlHM9Ocy5viIubAYcuwGZIBdHrO10JrumxbAo94+sWJW3P9NUX9o/SQ1aofUlqmzykehdG+hNcexPWwWXTpPD3pzBkhDrLdfqPLUZ5QJ1SlnOtQ7k0KdARClRWkBK6ilXU8xFuVQFkuEp7IDERc1jt8j/UY12wBA6dqSU9NXSBYxufLIXXcwN/x4xVj+sVQAVtxoOLjM0dRiLKOF47HMrHZMD58E3VRABT4rM97GXCEIAt6vX9A1wPBikdP4eW6mFrkPEKmqqedjdy8VRoCuVhdGhY0T+pZMV4A0MLzuuS+cVGml0LsUqgak=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d8c9ee-ac2e-4710-6e7f-08d81a053fe3
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 19:15:12.3812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdOBdrYapNjwsioCRlq2xvMtC/s/FfrVO1eHvJDiA7ingrCF4Hcx7fQzigko22CaAuhaKGiRKC2bXb0oGvVBFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2589
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 26, 2020 at 02:09:39PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Add John Allen as a new CCP driver maintainer. Additionally, break out
> the driver SEV support and create a new maintainer entry, with Brijesh
> Singh and Tom Lendacky as maintainers.
> 
> Cc: John Allen <john.allen@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Acked-by: John Allen <john.allen@amd.com>

> 
> ---
> 
> Changes from v1:
> - Change the email for Brijesh. The previous one is an alias, use the
>   proper email address in case the alias is ever removed.
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
> -- 
> 2.27.0
> 
