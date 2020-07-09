Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8586C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 18:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714E4207DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 18:14:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="A35g7KYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgGISO5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 14:14:57 -0400
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:53684
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726671AbgGISO4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 14:14:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vq/sAm0n9LXqDipNHiTVB+jnL5gF+S2SuhzwQ+m9tjJggeh/x5boNE+YGQE9bykGuwiKMjqcCusgo2MJw7M9J6nw04h6Zk6Q0ZpiQz0B2dwewStvmVplLUR4NkOyl/QbbAv4z7N4tFCWNvBKAxhHiZ5oRpht9/C1pWkS9lKrzXJ4ZPpoe8+3iD8YlvzUDlrj12sPp+d3AiCIrHf/59Tws+U0GOVNUtUrq/nLE+i1EyfmyRSD/VrgUZr8tBVtsPin2tpmbd8J5UNdovbF+7a3bp6rO5EHPlw833+/+MbZUdz8F25p8culTYdQbl8yt0Go5rSLcAVGHJLnqR42m5pwDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc2jSzWcrB9/8AESpegwdgoVOxHC3sKu9xOo8gksxyA=;
 b=hY7A6BTl4b2I1Sr2bEVNiNdbLJ7WaA3ZIis8GWJIEId9obCHjsvJpr0xqZYMLYkKNSjZm0zMTJpNWqmf/VGop0nSqDcd24TidF4BuJMiYAnRO1OKRNeSC330ja/lQP/i7DaPYyN6wcxG8G5/hvJ0L+jZI3fm/lQrzS7baY+nOI8pre+K2rHPtC9ULoT5np02vgRyDCUyXeSC76CyVmBfOZaER8rpSSSVTUOs3ytVCaXzFjVZal5Ovopy4Fl6gNMm9qaAYyF5xgY2Y2Hx21VRANI7jGpMSGi+dVSiPSj8GZcljOS5gaWrF6JgKuGgPZjoQyDF+P831g4qXkef4g/Ktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc2jSzWcrB9/8AESpegwdgoVOxHC3sKu9xOo8gksxyA=;
 b=A35g7KYzs6zIImrmN4aJu53lPaWJ6VjEB2KWjlojmAHH5CUaAYVgYMH4gdFfiRTJaRdZ80ezSzWF0Iw3qR4/9ujCeNK8TfJ6+24gsvpimmP/qPOgjyRK1GgAjITOiYjZTIAWhskjfLE/KTPzM0H5imGLf0jfrtJhxlLd83G+QfQ=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 9 Jul
 2020 18:14:54 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 18:14:54 +0000
Date:   Thu, 9 Jul 2020 13:14:48 -0500
From:   John Allen <john.allen@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Silence strncpy warning
Message-ID: <20200709181448.GA113025@mojo.amd.com>
References: <20200709124404.GA27076@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709124404.GA27076@gondor.apana.org.au>
X-ClientProxiedBy: DM5PR1101CA0011.namprd11.prod.outlook.com
 (2603:10b6:4:4c::21) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by DM5PR1101CA0011.namprd11.prod.outlook.com (2603:10b6:4:4c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Thu, 9 Jul 2020 18:14:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 081a3c3e-bce7-416d-df65-08d82433fad9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4352B8AA3FF436DCC2D936529A640@SA0PR12MB4352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVns+/EaepCYfNt78CYuvO7LYkrA/if8SeOi7wyDy/+Y8nQwK21cVtGBQTpJ8mjax+YD1O56/lgS6EunkYNWcJCea9nASC2coFgj+X1HqPsaM7fHWCC2i2T7ep+AVLaCpFVeERs9KAQOVJJcK9rIQCjWEUjtkTFfaY3TxyKwVJLHkgT4wWFE8KYrMqF4JJOOTSyqgaMgxW72RNh+RweYoEA5hjAmBQDmk6ze6i/iI/EwGrOernjwvr+Ot/cufEyDqxNLRlts99+PM6u3h8py1dANDcEaxqu6w8Q2j0Sv6DuNN1nwc4I7ibTQH0XHXYheHxRKuYeaRuHbdFOY3G/WtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(54906003)(66946007)(7696005)(86362001)(6916009)(8676002)(52116002)(1076003)(8936002)(5660300002)(66476007)(55016002)(66556008)(2906002)(4326008)(558084003)(316002)(44832011)(33656002)(16526019)(956004)(478600001)(26005)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v4y6qi4wu9hKEJSJkCeEANR3jkeJjB0UowWesNnvaKaCs4gzw/u8kq3gg1G/nUiBXECDWyRbGI7WXmJOQkLSibTYpBqG5OWvj7ehJEYW4M6JEnIABsB1DNdk27m1875KkM8sm+hsMM1mD/Bstqr51w4LC8IYvmZRcFAljyFUJJpuPowHF1ZydZ1pPpTZgcbV1sCcLJGtnE8oZ4ezYFSEUpS4bwrcpglQe8OJ1LqwnmTiCJpecensxL1S2SjSOVw6jfEevi5uLYuBA7VMYdGoLRR8PS9rFGmoIfTG0IfNWmlmtVnhilyrW/R4BlyJlsTbcWQt+2mXF0m1JiwHXeYwgbt33tRFg1d5hkQsGel7478HgGJ24EuySW124E2esRfvY4G+4un1nv4iF3Nadc/5/N/ubSF/hmmY16XpeSt2SKfMT5GPFOEKSKwMx1v8Zwq8hLaHwsYX/wHRbOchevl/JMeWl5qY5Y5yGDsgcXHrRgM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081a3c3e-bce7-416d-df65-08d82433fad9
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 18:14:54.5198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jc65haWAF8e/NSydjxKqjJEX5uWwrrcTpKq62t858VVIgoRSDycReK6CM8mfdQxpQ2MxnGExhVAff7wywP0Nww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 10:44:04PM +1000, Herbert Xu wrote:
> This patch kills an strncpy by using strscpy instead.  The name
> would be silently truncated if it is too long.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: John Allen <john.allen@amd.com>
