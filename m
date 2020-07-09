Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0B8C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394C620708
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="KMsQSbeQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgGIIxq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:53:46 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:64109
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgGIIxq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 04:53:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUqkhaN7Sm0bajYfLFfGDmcM4MwzdVWBEyG88MoJ+xh2bC0Wb/3UtpmAKNOd9Aq5pDAt+qqRKMfh0NIU7Nv5ujEwSdg+Uwj6xjOWpXnUlVCSLkWxqz5dYuqoINVvkR6syofzr9A17FETNH7TpW5JUT0gwZz36xUyZOsfICMCYD69kMyEIznNdmM819V0t/UB4KFu34A9wltPqmO4Z0oA3OFSHvKTeZvt00gAWOBxPBa894+SjhNzRANUlvuoD16oJ8MPedSQ0EACLd/iPHhjQb/n+tnTjqG4/ewRAkEHB5cEWyVb7MFQISr58H9VWwp3b4mrYcu2qUApi8Vur1Ejjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rmkCh1/vppCM0h/SiUCE8YJao10FE1VPUgwgw5Ckw4=;
 b=gDdofyD563vhC1diFybPWHETx9V+Opv2myzrqdTb8kxT8xHbIiHo9D+Oa1hWHDN9HlGmngWKqnLNiyHjWBk0hbptzfkDhb0FBU/kp68QEh+w5a3xf5L5yyCiD9ENDESHft3ah/f1DDgYi/ZbYhkO/hq9PkhxbluZhWWgmmUoGe+GBSdOW4WaTXrMnOdlBrypwATGVCgFupsqGejTThzwunCxA5iHw96iMOzkUwIGPIlJt/tD3QNIYjstFTHkOG4ZNr702GZjPTHkuPJCUsrIjOFoLqG6hVlenfY8+ZUfp8u848oo2pU0Y5kMez3hp4kuP7Hi0xRXGYBTPYLmz848rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rmkCh1/vppCM0h/SiUCE8YJao10FE1VPUgwgw5Ckw4=;
 b=KMsQSbeQnSXPINXKFBPxCAqSA7Rvoi5F86eeKhP16qYEv0cEoKJ4fFI2hGc1LMcUgtafugN2RmUMjP2NX2VE3S3h6gOsaadvJrBQlcUC5j/e4MUZaS5+m8eT4NaQ8+hq3wqhF25eyjsFKh/lLDXo27KS70dH+NNoNC5KIduAHao=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5583.eurprd04.prod.outlook.com (2603:10a6:803:d4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 08:53:42 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 08:53:42 +0000
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20200702043648.GA21823@gondor.apana.org.au>
 <31734e86-951a-6063-942a-1d62abeb5490@nxp.com>
 <CAMj1kXGK3v+YWd6E8zNP-tKWgq+aim7X67Ze4Bxrent4hndECw@mail.gmail.com>
 <8e974767-7aa6-c644-8562-445a90206f47@nxp.com>
 <20200709004728.GA4492@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <036c2f99-7f9c-28ae-02bf-99e5fbdedba2@nxp.com>
Date:   Thu, 9 Jul 2020 11:53:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200709004728.GA4492@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0115.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::32) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR10CA0115.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Thu, 9 Jul 2020 08:53:42 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf02ea2b-9eb8-437e-dbc7-08d823e594ef
X-MS-TrafficTypeDiagnostic: VI1PR04MB5583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB55836CA354D6B4EFD124845F98640@VI1PR04MB5583.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nL6abyByQxFhtp7doakJuy2Ebyz7KAMPCGeLUUkbR56pxW4ZPGcAas8h1CNTgK2L+6w9A21bApdwUem2J3q/Kf977C+cRyN6WSDcDNVBfgFuxsUFi2h2iSAOB512tMEY4NX/eGuf897knSJt1d0dCwyjIrSorOYlUyO2lgb7ljrzH1dXrc6aTT9X/CCq+qNLNJZaqWIPmZ3euUy9MKydU8KYURjBl4ft4uMxZb0WlinARqQ2lkjvKRJApGPMbaushs2Ae946LpSXgy1/NhlaWVKoXUV167m2+WdpkDc1rxg37EWfQ3xQ97zJb1DvWQZtCPXYq/Z9nvepc/WmAL6yfb7cNAhRJLJRGGMQyrnksiaI8lXFzk+qPyFRBSAszPp5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(53546011)(4326008)(8676002)(6486002)(186003)(66476007)(66556008)(2616005)(956004)(16526019)(66946007)(8936002)(52116002)(86362001)(2906002)(31696002)(316002)(31686004)(478600001)(54906003)(6916009)(16576012)(5660300002)(36756003)(26005)(83380400001)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L8rw1/IM7BOuZmMnrU1RzHt2pj2S2Jkkom3jE4XVdwfkx1ZvJEfkoMDxwiV/ow6yngvAbYWmu50DBXT0NvyZ6yXMcebCEUlBmaqmTGDkOikSFnJJ+/MfMDrlQoL3eHPMlXqG3RcQzFPaJIvs2VOPJA6JT+a9JDOMczkOAlw/53iSFDG65cyuNTTmNoLMNUE0jmeHWiM2hA0mG+k5pnjh3CPHXiwzgR/I/KqvxQ//ZVThvbsz9XPtAMFsOKCDTEmH8124KMF/dKS9VZA8g+gh3BQvYKHptfcU5shHs3WuwaNO777gCyD9fITHcklK72CbJw8VeSWGUm8UV+O4w/HmVgzIe7eGbwy4OGzPKPLMhrH4XVGULRSekouB2E9ad1EuN6SiUEyG3D0pgYDxK3hg6YPd4jPpzxkdFVlI3XVZ7A3/C/h+n5QCsLBBQb75/SPCv/N5F7qOLxBxwrS7Uk4+G3pTFynPSKbKL1YgwDnk20neveViZmBzIhTzwQVZ/rlN
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf02ea2b-9eb8-437e-dbc7-08d823e594ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 08:53:42.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27YHhD17XPj0LMAMN8ndri8Fdi1aGSZY+Vim4djoLdDef7RIgVznnu3V/8BqgFbPWuZaD4iqgd8wavnvfzU92Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5583
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/9/2020 3:47 AM, Herbert Xu wrote:
> On Wed, Jul 08, 2020 at 07:24:08PM +0300, Horia Geantă wrote:
>>
>> I think the commit message should be updated to reflect this logic:
>> indeed, caam's implementation of ecb(arc4) is broken,
>> but instead of fixing it, crypto API-based ecb(arc4)
>> is removed completely from the kernel (hence from caam driver)
>> due to skcipher limitations in terms of handling the keystream.
> 
> Actually that's not quite true.  The reason I create this patch
> in the first place is to remove this limitation from skcipher.
> 
But the reason / context has changed in the meantime right?

If skcipher limitation is eliminated,
will it be possible to add ecb(arc4) implementation back in caam,
this time with the state stored in the request object?

My understanding is: no, if Ard's arc4 RFC series is merged.

Thanks,
Horia
