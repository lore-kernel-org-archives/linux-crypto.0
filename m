Return-Path: <SRS0=MSze=AS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B712FC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 19:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 934DC206BE
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 19:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="LQbwOC4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgGGTp5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jul 2020 15:45:57 -0400
Received: from mail-eopbgr690071.outbound.protection.outlook.com ([40.107.69.71]:15854
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728061AbgGGTp4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jul 2020 15:45:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaucHn5Rgv85FHek7RmQoihjsMrCVnZ3kkZ+hu92vvvBBhbwg0N9YZNb8JWVrlNGLghVkTB2oHmYeSLT3MXyjpy3AVbtL22528pshtFuEEJpY06xg/WMjJhL6GkiY/svfLrhlXY88llsZV69sLSWyFjTlzFd0NA/zVzYxEAkW6ljTThnZwECxGF9qwROczAU4hZdCTOFA7Gw+JX1TTIZfLDI7h9UwCfFdWw2OFKAetnfte2cKitBYR4L43brCUHf/VM0BvkB0KYB/5YZgG0p6LvOMFGU9DYy+oscxgzSU4+mNQY1AB5dj4PqeU7SwKjYGJrJ6bmyRq5ey6T/cvR0cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BINpCDqOvzHx3HhMwRaEwPnMtK94pAAmoEUuW+1QcTI=;
 b=geFfcUK32WGd9coABf5D7B/XUv0k6pKH4vok7x0FUM98AVK+6Zk0kKINnLAhzGx/N4tRTDPrkpP63FlnIpH3Vt2iLchuYMvCQyAkUZZXWvqy6j5JftkbkGiZFMtRIxV6BzcuXpjJv6DoiUEDT4lZNHaiAI1IKJWzF//SYpI9egfIMiGg7DiQbjxo08EF6+52UtRUZiSKlHXCl9cTjRlKiTNYmtLM81KIXUTzyKdJ+nTrmL+J/kRbKWRPE8hIp8BrFegAuTxUjJmQZrH/BfKn4v5jf7pxBZtwgmhHeFAYwv6LCc3xLyLH7MIq/1pQ0vvT1+WNQ7rVA77XdDGF3b0mXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BINpCDqOvzHx3HhMwRaEwPnMtK94pAAmoEUuW+1QcTI=;
 b=LQbwOC4t42GWs79hs7wcpBRvAJBXq0x3Bde9WCogfxpa2/f53VZlqtAwMiMg9wJXzsxyoJ5vckaadkxUhrAQKYwkkZD2dVxo5zX/yTlJj5FoRjLuWNEfHw3HhIcDVHSZdK2JwDLNwx/nS7WMLBmgz/PVLY2/cdJfQvlKHusGIpY=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Tue, 7 Jul
 2020 19:45:55 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 19:45:55 +0000
Date:   Tue, 7 Jul 2020 14:45:47 -0500
From:   John Allen <john.allen@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Fix sparse warnings
Message-ID: <20200707194518.GA127040@mojo.amd.com>
References: <20200703044652.GA23139@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703044652.GA23139@gondor.apana.org.au>
X-ClientProxiedBy: SN4PR0201CA0028.namprd02.prod.outlook.com
 (2603:10b6:803:2e::14) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by SN4PR0201CA0028.namprd02.prod.outlook.com (2603:10b6:803:2e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Tue, 7 Jul 2020 19:45:54 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d13a549d-46d7-4d62-6e72-08d822ae5cb8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44795D76251519F84AFBAEE79A660@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vW3uxdpbZlsWJZLgH79NC1JlULekJl7oYWe1ZVMl27QH/b7VRl3T4T67CWX0xy+ogKSkSsdOQp6Skuxl78guE1C/TMRYrRydm5LcXXSm+lyQ5eCu5NutNNuYrNYAA7wskGsStgrbp3+Z/vV0Ejm6222z38t3+o4FpvvGtVXTTEUnQqtqTYZ4jCcgy3ySse8l2OTGv5gHbO4a0EllPqbIZI0cN8Sw8EGiSjPDeIHJZzgqIRNUIwjZy5Bws4Y2h4HqVdvtKINYYsm86qh+EOJa5sJbTGg/FT1JkYHKx0nySqZjgM3Yw8FSVH6RmSixrzMZrOjt3BzTbuuz6tez1CnF/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(8676002)(316002)(558084003)(66556008)(26005)(8936002)(4326008)(54906003)(1076003)(6916009)(66476007)(5660300002)(186003)(478600001)(86362001)(16526019)(6666004)(956004)(7696005)(66946007)(52116002)(44832011)(2906002)(55016002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: smJ9RvdDGs2+QirvmzEdwNgpiLH5nzkSW2ZadnrUmI90SskQ34DIwFN62oZ8noJS6QbLE2OibPagrXT3R24Dbmbl13SGuUngddECFK+Wxq5ZND23RMGFT1+A0+nn/L4pFGkAlTOBRKuH6KiMLCRkmEcXlGQGpzpbc4x3tNgGufrMbMAGywZrvk9aY71tSFw/WnXbonUsaQzGA6PKgeYrufQoh3lLnml2AtNB040dAoI0be5RbfGLYc/ZjBFqMpQ9zrTW+8RQUWg7creD2RpANAKjCSWw9Q8EDa1NmIKikbXPamY2uhAPqW1M8BlnYLAASFEcgBXmlfQFjn+sOA77YM1jTIEBStgkBUM2wymeexUpwqVyZs0pG8HHr4VnfijCRSTP3PJ+Z4Ejt+FOjvH7BJk2QuRlMeUPHlqUxjTy94DD76+a1ksQQsT9+5TTHvoAChHp8J+erqMhogA3zY1Djo8XEj8QkPYVjcn5vp1Y5lo=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13a549d-46d7-4d62-6e72-08d822ae5cb8
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 19:45:54.9908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaakOvxYPU8xdfH92TriRFQKqsOTwIvSF6G8fs9xlMuXHds9s3GL31j2aooFv8qiNnhnta5FPUn0Qsl+xq+YqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 03, 2020 at 02:46:52PM +1000, Herbert Xu wrote:
> This patch fixes a number of endianness marking issues in the ccp
> driver.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: John Allen <john.allen@amd.com>
