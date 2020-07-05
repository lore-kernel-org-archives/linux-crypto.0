Return-Path: <SRS0=i4aU=AQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C80C433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 18:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD1820760
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 18:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BvoFyisT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGES2X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Jul 2020 14:28:23 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:61508
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728048AbgGES2W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Jul 2020 14:28:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az6cUZGRNKFZH7CAmiJOHQoe6PKdnoYDqwJB15P1XFlQvDcQaz04HPQNXzAinVZvNGuqbR9aDD5u0mQ6zkAuZ3xNCaJ8z6XMUnzh9z0bixp58XEVMxuw2pa98u6fZwIORaJ7OqyF7hs6FAgRufehSSO/1NZOGxgFRkt2PqtWBtdgyO5M7rxN/sETvMkB0PBuF6/se46wuh3MAKkDhunpOhoYdlwyAp6tLA9Ml40kiMozEMsjsB2NSlLNUvnjaT25NXhSTF9SZK7Ke9BMta9lcHd2fRNYHeV+zork0ynh8lp/6I8YPD8SnA18vFon+LPrhv9zeC6nB7eY+Q99fYSQSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYd9nDEkesi4C1vItqF6aSA5s+BOUZQ7jPjHLpRJwmQ=;
 b=Dd1CQv+zgPjQW/Hvxcx6mZxKGyTlSMvbhE48CIq4U6iSlGKMwDFWgaaQWO8c+LgGyEGgvKmb6a1tj3Jyxo7tEqSqU0ULjazfBUEj/3o37PaAmRdUd+GoYujrb+5WXsN9WWdyk9sLQq/UmdrAbj78pQFTmFFwYn1Tn0wgXpgnRfwqrXfdNRhCWTva/TUjrXxhuDuG2xRQ9HOs92BWwmcdFmbUZv2/aS6TACuGTdjwhiOFfdHk1lMpgz3goDf3XxaC1kQjs1oab18ArRfWJ8k3GA6u5d8a8MBbQ8xQR3aFMPfyxl29tpI5YAQ4+Gqs8miIq866H7ZeVNr4yK6zjZ0XFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYd9nDEkesi4C1vItqF6aSA5s+BOUZQ7jPjHLpRJwmQ=;
 b=BvoFyisTOTq5qFVj1bOSZfgdeZOTSSrhj1FUmisPYnjTXbQ63bCUGmOV4kwciy8hK59hgmLOakMm9BY6nfxZrj8xdES60j/fOSfNtq34ZLvaVB4mgOgjCW91yrSuJ1cJHxZUwDvaqx0vRYl2CtCVpAH+MLdEMFjssIJS2xZykdo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB2973.eurprd04.prod.outlook.com (2603:10a6:802:10::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Sun, 5 Jul
 2020 18:28:19 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 18:28:19 +0000
Subject: Re: [PATCH v3 09/13] crypto: mxs-dcp - permit asynchronous skcipher
 as fallback
To:     Ard Biesheuvel <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Eric Biggers <ebiggers@google.com>,
        Tero Kristo <t-kristo@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-10-ardb@kernel.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <b2ebb3f8-06dd-3e4b-5053-ac75099d5033@nxp.com>
Date:   Sun, 5 Jul 2020 21:28:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200630121907.24274-10-ardb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0052.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::32) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR10CA0052.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Sun, 5 Jul 2020 18:28:16 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 845d8487-0743-4bfd-ec2d-08d8211130b3
X-MS-TrafficTypeDiagnostic: VI1PR04MB2973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB2973450D1837A83C7907FCCF98680@VI1PR04MB2973.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 045584D28C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VP4eO4c1QkONbnTgngEj6ZDpzex/ksXSi6oWH6ABoeVfaTODBdBpoEUB/O7tMPTZgXaohR1Hx70/5lqPHgFBWsaJLgv/x5HnFu0EqMcoQUMLdFZF1y6APIoVTbPHSkTQqhBaWD4WGv/tPEfqB9IGGn6BsUO6Kgp2Bc7HCAT+BOQKZEXCFQuh44fYHraNQdoP5iKtCks23OPGPHzEovimXYAD/J7TEGHw4PGZuXKW9bITHTY5YT3Z9EBdpgWXnA5c5iGwC4K8D7jlto+qR3rdNczDGe9kjH0vL+T4ICfWuStMNAjTSCOCREsgHpjW+8+L1cZYjmj9B/fzz/AaueIlZ4UfW3TlgHFcJWwQvVO6sJrXQ7zrpbQFvdzEcCXscmpm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(110136005)(54906003)(36756003)(6486002)(52116002)(53546011)(8676002)(478600001)(7416002)(83380400001)(316002)(16576012)(2616005)(86362001)(5660300002)(31696002)(31686004)(66946007)(26005)(186003)(956004)(66556008)(66476007)(16526019)(2906002)(8936002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: k3bbKYFMPjrSiKL/KhU/xI/B41I0NutHxr/3C0zGZE4yB7ZO1MxxY1LLCgsYp2XBhdoGoymqF6qvK/yK9szU5IPODX5Gv8Xh5yLxsABhXBmxfYfnMyqgFWSNehrnbH14stbn6Era6sRFEhhhzOVLdGVdLhRT1rErFtxuDhWzVIeKlLs64lmYbRmk1AnIAalCMFlZdNDjAm094jY77ZF0vmHs93PWwAEbdgDm6tD793raGU8SmtKCqtnZ9Zkz8yAs5+F85SckcTtoTnkbln552yHcM0auNCje0jocynddGUppQK0Xz1Km87nerIyxSDh1fd+Gfwi+pKmK1r4kHR3hejZ3yzlnKe1TOYhHMe96c7nQNv9yJ7reXHu0MmTaqpZEZ2hpvAr6Xp5dPXn483EsB/VthgPO9cCBFRZDA8spNISJtfUoVxzx/jYRhJQSRpc9QPTwPgXN1A1E4DcA3y0jkUPC0mI2L8vNM7VukPHTrcla9jFoTqtIWeuXEGMhLaDO
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845d8487-0743-4bfd-ec2d-08d8211130b3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2020 18:28:19.1831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMakduQAyqJzaUUSWRizqeJcDBarFLZcmk4v2ZF0CMloABb3DUI0fIjuJ+IfrPHOQJlKOq8CBynxiFRSOx5aXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2973
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/30/2020 3:20 PM, Ard Biesheuvel wrote:
> Even though the mxs-dcp driver implements asynchronous versions of
> ecb(aes) and cbc(aes), the fallbacks it allocates are required to be
> synchronous. Given that SIMD based software implementations are usually
> asynchronous as well, even though they rarely complete asynchronously
> (this typically only happens in cases where the request was made from
> softirq context, while SIMD was already in use in the task context that
> it interrupted), these implementations are disregarded, and either the
> generic C version or another table based version implemented in assembler
> is selected instead.
> 
> Since falling back to synchronous AES is not only a performance issue, but
> potentially a security issue as well (due to the fact that table based AES
> is not time invariant), let's fix this, by allocating an ordinary skcipher
> as the fallback, and invoke it with the completion routine that was given
> to the outer request.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
