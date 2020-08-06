Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEDAC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 19:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 133682177B
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 19:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="WWNZgDcD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgHFTQU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 15:16:20 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:23137
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725272AbgHFTQU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 15:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BX65wZlYm5QsclWQ0VcwTFFSAY3yt+JdgrcYmPSVgVNbYR5ztEAXVuMY+bpd7HV6Rom+fR/V/+Fc8t78BacW+926rK/SriRl5v1HwGqtwIsGaZqWZlJjIVVFbgZ7KHQlqVd2MfJ5/cUCSeQiVZ2b+S4BrEV+AjgUwUVhWSTR77aVKbTxNBvKVpmGPC/+JGbFfQxeUEGPkUxWTLkbQJh6KELjyMBFPLr6UWer5E4MPLWh5dx1xCPIf+VjlsG4vIoOo+hR0VQI1OJio/aFgMhHcxxebg3MTvEQvaBBucDcmULuHFiCKiKv5Me5H2z424yyOWASvy4hSQTHUC5tESY7cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiRW2SXNNS+Kef8PqBtvEh4UMo0iptVJ09nWNURLpzE=;
 b=WEDWxet7ngX+THSILpjjSFtL5dAk7YAN/UONaLJArjntQRAbrlGNAZJMcUfzvvoVZ6221yPOvTf9wAiYnBcaBDFqCji7+E/VmToE4lnrQxieVDv241zSZSrEUyNi6hJhAIIlkiirXt6Z1Nahp52gJfldclQ/U/H+GynkIrWN4B+uU5iJz27xP4nhPuXgUcF9RtC26CvQrmtHaixfcP1faUWX7mMm2GrGu5zInos4xQHY6zd49ToGLFOHytO1tzx7dRULwB4iqtW2rWgZ/XjUH40hXqRddVooWZGJ8xiyRWksgowu+NllrbAO+GdqnH6frxi6lBmlgYVQ1cEIzDRLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiRW2SXNNS+Kef8PqBtvEh4UMo0iptVJ09nWNURLpzE=;
 b=WWNZgDcDJwzmx8Dlh+L9mA/wcBoUYeTRg9YqRUFf/A9E8yIIItLaMH0ebNl70w7govsQsAZWM4hVORGoi36+2nKn7+XhAUpJoBP1K/Ns4lEXwuyuuM/o2MiiQemDA5DHZFXwDCIm3rrFUXOonfrXhscXjjWbWci5quwvdf/KXd4=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN1PR12MB2589.namprd12.prod.outlook.com (2603:10b6:802:2c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Thu, 6 Aug
 2020 19:16:18 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05%7]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 19:16:18 +0000
Date:   Thu, 6 Aug 2020 14:16:08 -0500
From:   John Allen <john.allen@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v3 PATCH 21/31] crypto: ccp - Remove rfc3686 implementation
Message-ID: <20200806191608.GA404854@mojo.amd.com>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0JtW-0006St-CN@fornost.hmeau.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1k0JtW-0006St-CN@fornost.hmeau.com>
X-ClientProxiedBy: DM6PR02CA0082.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::23) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by DM6PR02CA0082.namprd02.prod.outlook.com (2603:10b6:5:1f4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 19:16:17 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db5df01f-3a40-4e93-9d1f-08d83a3d31d4
X-MS-TrafficTypeDiagnostic: SN1PR12MB2589:
X-Microsoft-Antispam-PRVS: <SN1PR12MB25896F0D39BA40AD7F4D838F9A480@SN1PR12MB2589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQY999na8LySPAq+oktldgvJZcaEbCJbIoSl60f99uTnspiX0pH+7FYPGdJmNMWVNoB6IGEFUtkb9/iAR0al8wf0axkhtXVwWafpGSRQFNRYK9lPmzHT430M7LRA/IY6bFB/oLAEbqiUVD+cGDhTQqmW/75vYUtO6wC8poZ6Tvntl+/G4J2T657ZDBKvG4QOxtgw8xRJyOcClEvZ8Tf0qF4n1NgCgJoKLNFE+tc48e9ty2XTATJnMCpN8tWtqHyD7bz3zq7xOMYzyUjFtLoN9qhM1lWwdCGXGDVsKQxI71SFq/0zedhIA1Ydx8vvbpSbJ2kZK37dY8f/2ZOjLDwlXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(6916009)(86362001)(26005)(316002)(5660300002)(6666004)(956004)(8936002)(186003)(2906002)(44832011)(4326008)(7696005)(66556008)(1076003)(66946007)(16526019)(33656002)(52116002)(478600001)(8676002)(54906003)(66476007)(55016002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m4c/IEW5ehG6Kz+DeLOgPJ3DuBznt51ii0/9zqZBvu68uLq9Uk9bgNOrH6rezyVl/VQu5hbH4v3sUSakUnQ3rHPtris29kEYab2R6YEIDQCJsI8E8nd6LA4entRXydNglNRX0Cbmp0iAHMpHbVRWESr7SeFOn4S1Kvs+dPWJgQTmk8s8CgfVlAQ7Yi6Tl0OENGa8QoxiT32PUAapEu5eTyTX5Tergccwl9A937ZfYnlgdfLRuGI1KTrZYwir6UMZTQ3ZFJwbKdQgSAh/bgjONcFsideCnhZUyl/6MHJvRs8poEQQ1QlQRQF53eOIduEsQ8caTvzGZUfKTl3Z7RYn5SPlBk5uLtfztUtE9bsJHqNZjTc6WGQEW64NY3nBrNwaSWsrXf0YW8TgEKApn7oT7PLwrSEKX8WYxkt9kBwmo44+mdE6iQDoABIMyeA1m/ZzlP3NoVPaKO/yJQUbWVDcpgW6oWEvxRMqZTFzy5EPYAhkzG++KSY5hoFtD1gM2kSYVOyqWrT77qH/wKfsenniWzZi600zjUiUKCxuM9yXRT4mlfqgzzbacyoLWg4B+/UMC3Yyn/ZQQjY+KPjlgxDMjgy4E/0Otf4e1HxuGmd6nupUOy8boWus+m0UseV40mbI2wxSm60LpsoHefaM80t+kg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db5df01f-3a40-4e93-9d1f-08d83a3d31d4
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 19:16:18.2075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+6I0cASa4jhOwbrYvg1VMiG087FAKe0BUcIL+iCwCsAv3CY7H+zgJXrt3cQMPxzVfEYONo7c5f5JcvQDd/SDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2589
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 28, 2020 at 05:19:26PM +1000, Herbert Xu wrote:
> The rfc3686 implementation in ccp is pretty much the same
> as the generic rfc3686 wrapper.  So it can simply be removed to
> reduce complexity.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: John Allen <john.allen@amd.com>
