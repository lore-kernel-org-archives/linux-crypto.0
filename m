Return-Path: <SRS0=i+zF=BU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F013C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 16:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C64E207FF
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 16:47:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="RLrZlIFG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgHJQrv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Aug 2020 12:47:51 -0400
Received: from mail-eopbgr00042.outbound.protection.outlook.com ([40.107.0.42]:7236
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727867AbgHJQrr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Aug 2020 12:47:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfFlZjuuu2601DR25uNJmgUjVcVm+TuKmngl8z4y1I1x6rN3zomUhn5uzRXWlL8KRrNbsgC9pUfjPMZ2ZdJ2LnGIK7VE7X86idPXsflkL+puD/jnidoDLzFHHdziY4BJygt341pHST+WvZHhgZkzQvYXwsXICalrETmT9dN6tU7mvBSWcGih1MuuEVgIohD+m20prwJhFy0yHkSS3uTW5MC1/UbH09KUcZP7WNFCv4HLBrKQhbwZcauvnUxYC+R8RDMIyg8SXimGdYETWvzV5+8D6ZEbMIG1nqeH4cvuCBL1PKpZ+hsWg71PhAZEqLMc7/2pfGV06uQxVNmixGsecA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i64OgJ2gqJIDru8809LusrGsxA2elDEdp3ms+lYxPdg=;
 b=GWx+mh13j7q48hRC5alSeEJVh6E9WbHWNUBFoCSVDbZ6GGJfbkCJ5KHsiliERZVDmvFO2hfkFInsMW6xVEAISMWzo4+rVpVdYOvS0GX78V/D1mzrgJ5EZ24b3w32ZsFaMHoL5o6IUYSNwpp5qK82xUCNprqICcjPJyh+02HrBX4UN6Abu95WVip4bT+iOyilJqN+ssmW1bFhyQQmqcV280iJ8UTl6OWrGwP3nEsT1fXU/iUDg/ZrTI7QKOfV70AyXeR3afU3gUWTHFtgOIzOfFI+eai3pQCk95V9jqhlXRZ9oenKh0qkTJcrtqbRWAwjjF0ZfIDC6jLZJyiGHO2j0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i64OgJ2gqJIDru8809LusrGsxA2elDEdp3ms+lYxPdg=;
 b=RLrZlIFGRsuwqylyGY+gHSof568fQbWZJd8ZcidtF4uZfJw7UP9cTKLkziB2GgwG7uEDaA6gpiIEtRNFOltNXduWUlREbo46KurqjXluFp+csvB4bftc7tQeIK9aOvo1lblVvb2PQ80vqY0OrHK9faPWx8EMevTQCRp8OTWI0O8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Mon, 10 Aug
 2020 16:47:43 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 16:47:43 +0000
Subject: Re: [v3 PATCH 19/31] crypto: caam - Remove rfc3686 implementations
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0JtR-0006Rx-Oq@fornost.hmeau.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <92042403-0379-55ab-ccbc-4610555f0a93@nxp.com>
Date:   Mon, 10 Aug 2020 19:47:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <E1k0JtR-0006Rx-Oq@fornost.hmeau.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0202CA0015.eurprd02.prod.outlook.com
 (2603:10a6:200:89::25) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0202CA0015.eurprd02.prod.outlook.com (2603:10a6:200:89::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Mon, 10 Aug 2020 16:47:42 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6aeba02c-a58f-4de9-e700-08d83d4d19eb
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6560266251D24D166711AF5B98440@VE1PR04MB6560.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxXkVygJO5DyfI41vaqGDJbTLuxrThVAHR6t13EW3babT+TiGQWtuFwG5WJIX2dvlgAuN14aKXbbd4ZZEa3efwGIiGyCOQZ/SL3meyGj/KA5uMLMYj7D1AseD78xQiQmAjm0LEGBgFFKJOVtH0asIWJy0D6MYBMWWNyqFzCL2Ha4dTtpAYEyBN8aa2j0Sf/7pC3zkeFKylUCygp6b0mYjkmNMabbNymY94t4Wtyti8bfdvXb1pfOyNiBwhehN/E46l/YybM6rQSUECbTU1YU3HmmxwzBte0pl2f6FSSGAoahY+Th6VIjbP6AGdLHl4a3FaFJr0AE0MOI9RhfCB8zH8xkCxQpJPb6BFCJo9rFQx3WiduKCUiItZ3wgx1F3IOg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(86362001)(66556008)(66946007)(66476007)(2906002)(5660300002)(4744005)(8936002)(31696002)(31686004)(36756003)(478600001)(6486002)(110136005)(16526019)(2616005)(186003)(956004)(16576012)(26005)(52116002)(316002)(53546011)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QawHyHwSLwxAAhkZi3sVq9h9d/LUu4aIxm2rlMIvmdX0n7NQQIHmYxxkp53hH6SJmGBicHOosHPrHbh9YSEU79QDaDuijEw55IuVVo9BfxtxqaMjLCUTorgSX83XBg1dxU1PhvsZwIMsZAYwJstOafqKvCB6H7t+t7IsCYSAakbXU+cNwVAYvKiIDiuFwR2jyEgzflpbjbBvpymNJ6bcimC+ug7C1/rr8jIrt0Mx5EU6MZfhZsVTLFVmqYiywAoujlvb/lkHiWq1BHw9KfMF+V8LdiycrHQTwq4MuRTzM43xH1eGzxdgCp7D0ge/MkSdLzt04ROro00ZlIN8XHYUjke/gSDWqE2uruPont/gqMynFTQ5u+Z2RGb27aY+3dx0lqJYiC2ISfiH+rD9kiGu9Fjzkby4m0jTopYcR75LyEEWeZt4XdDVdZczXu/RnKzLcmKhesM/T7EH6NYutgXmldLKCDLAL5y3ueHKMFa9TAib6xNPJfw3WEDG9VFw8Qzj0ts9la7mKWLzZMd4gZSbqF7mIBz94OIhSP6qsI9oVG+xZ0egN4ZY6tadXjIGevSUm8pst8hQjLCmJPUw8Lu6yPDjXr9J+aHTnjZzw5sq0X4ngFgoWF8jNqLiKqG430dkSaF2EX011Qao2w/lcxOxCg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aeba02c-a58f-4de9-e700-08d83d4d19eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2020 16:47:43.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJIATgt0lvFStEuUBZGVWFTSISVQH8Bhc4bK/V+bd1+6z6lI1wCJeAFjenFcqRMwEh1Hq3ecAEd3Sr/b0LwMxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6560
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/28/2020 10:19 AM, Herbert Xu wrote:
> The rfc3686 implementations in caam are pretty much the same
> as the generic rfc3686 wrapper.  So they can simply be removed
> to reduce complexity.
> 
I would prefer keeping the caam rfc3686(ctr(aes)) implementation.
It's almost cost-free when compared to ctr(aes), since:
-there are no (accelerator-)external DMAs generated
-shared descriptors are constructed at .setkey time
-code complexity is manageable

Thanks,
Horia
