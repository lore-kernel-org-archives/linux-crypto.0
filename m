Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9A9C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 14:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A893204FD
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 14:36:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="KFNmuuiC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgHKOgt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:36:49 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:57696
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728750AbgHKOgq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Aug 2020 10:36:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl7MuogsZaZmrj2vRmZj+gtIcFoj/3KVuGqVHRGzK6phlSNsBYTA7fnkm4o7IQWfof0yuWCjbW0JNqKi1sVXh7Dvlsn67UPGt4lr20vuv2LUkD6UHlLdLYcSK6dQsPxZRNdpz9ILgTnnnsJuKz20gnKqKMNSwSV8P5Ou+YBeUfZgJAqo9tIF1kHeZsMS4/p4mvpgobv4ueDcI5TGJs1nzKR5xKO63FR8Oa0IgL3v6PsFaMaK7MbI3RNRb0ZxDSJh2MKK5oFZwE0iMFaU5WvY3ebYLZ0n1MbgFFvY6p4DQ1/Qhu7B3/DLGT46xaGzpHaDQM29zGtmuGmjx25fi8dtsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5folC1eFusF5OAmkFsjZET5TCbjgC4yG8cNIR31QOc=;
 b=SCVW1qhPtK/AmWwu7p7Ls+i8y83zl1jHeStJjkO0AtRJv74h0lWmXSjjWevLtesYgONNuo/0d2iGr4xQB+7Vs7pt/w4NPTzTpZNQH3i+IneUFSMAm5H9nvcemgd3mUjryeE5GRtlFE8sc7WHUHokgn2do7cQm6RKwdsV0vORFJDP6Aqkw2p3OLgh9ixut7uxza64h0s3GvmIcIxIpdEV8vYGZhffeGwgC9d+tUNWMWK/XJv27gA5kWZA3h7wJvcLOtfRF62H4cZ/C/UnuNVFyx3gM2Hb//TfQDR1HCVBGWD1ACmUbOKWd2IUFKrnYkKOp3akQrbN5KQ+3yAiojlOow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5folC1eFusF5OAmkFsjZET5TCbjgC4yG8cNIR31QOc=;
 b=KFNmuuiCjmyHwSX0GP4uTdKKXAAdW6Mt7bIVeX0dnlWtgCbzSbFywnisEEnvXQzVypkd3ErwoLXbCFwKhr5mEYbtT3w8Qny3N2a2wqBJ5PvBvhYMdooQqKhpPe8V7G36G+eIutNVxIw/1C9Lcv6W51rFWPxNwTx4fvc64Ew6E7I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB2814.eurprd04.prod.outlook.com (2603:10a6:800:ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Tue, 11 Aug
 2020 14:36:43 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3261.024; Tue, 11 Aug 2020
 14:36:43 +0000
Subject: Re: [PATCH RESEND 4/9] crypto: caam/jr - add support for more XTS key
 lengths
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-5-andrei.botila@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <48a802bc-e79a-f243-f680-59434106048c@nxp.com>
Date:   Tue, 11 Aug 2020 17:36:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200806163551.14395-5-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0047.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::15) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0101CA0047.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Tue, 11 Aug 2020 14:36:42 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 39272aa1-f001-411b-eedc-08d83e03f77a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2814:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2814FC6845276A28C6CF51A098450@VI1PR0402MB2814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGQsnJ409mWw++XDhq31Vp9L2dSjstBaHyT1MUXaa53ykYweoBw3KmJKN7q/msqzUVlcgS45bj7PGkI3zAco+MRT9EGdVzg805+tDIqnQG5ZdIknZO1obNR8MhyIKnAKpFEaXE4evluNVYHkOK79YhC+6JFUqLZjV/is9cdRDQZi9tEKg4q6XVPvE/5lRNXEvP7j+PJqmd3uiVzpFyKJVbwWcNufAoCJ44XddutO23hKty5to1qVSNCXVSZNfsLBnAHL/kDka8Pnqn+qRIv3ARz4MGRjvcUy3hlguIi64+K5GZBKvLBulRl64dRPah5SoIBka5CvfXUoCajFm1nlEd55atoFkQ0uZJKWuZKlPe6JFR88pto8pb/Lp9zYFvrI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(86362001)(36756003)(4744005)(4326008)(52116002)(2616005)(5660300002)(956004)(66476007)(6486002)(186003)(16526019)(16576012)(26005)(66946007)(83380400001)(66556008)(2906002)(8676002)(31696002)(498600001)(53546011)(54906003)(110136005)(8936002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wSQxqigHeanWnXPJYowCCmscdFHyAqEQsLzIOpj4yrBXqOYBU3txDL7O/UKE5cxVsi25ORatff+oEBztWbJMJQdw73XsBx1Gw+p2j99jSMgSzMW0tA6uZ1BcNCpEo8TLYTz3J2u7vr9KbhA6BirVmHhdS6ENZKfXs5W2hOJrCuxgP2+BDzFw81CdM2Op6TNFpGXHxNzw1WBqUCXRW059GNSMAuMfG+QsYuEJVX3t9TKnDPwJiB8cHeeLxy+wFnj+1Tfk7Py8ql6TlZuTVieBD/f1A5+X2B2oT9QNidyyZZ6Je2SO0af5TR6UyNyN3+vMlhAAB5RJseG2Fb/3pNCItmizBnw2jlHMDCiDqvw7B3z8ToN7fYoxk4CR4MoZoVWUQZHyp1iU+z89oTehoJGhXl5c+P8ZVZbhQvO2Nui/be+aVKfGXaHJyrbttLQAmq60s43GgsQ9T2QiT2lqPcc0YW3XEC3R9Vrx/2hCr7krNpScj3y1U6XnXft4kf18vzOuysJnczgqHRO6zSOBl2dNQxQnn5y2nA4qj3R0LaIdQEqgnL7YLZjXfXJFSI7YBnGsjFsK+1zdnM6o2OoON+UhrrqngWjjv7GZGHqX5jcEV6IJqb0Mny3x2q94y7PAMvs55ZwCfzHI3qA9IrpAQZCPmg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39272aa1-f001-411b-eedc-08d83e03f77a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2020 14:36:43.2716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHOpaJ1az04gdoJZTFB8LR5+VJ/r+1dCCOiNZRf1U66ZyGIyQehg3olApasRtEAs0MbPlKpESWMqUcGxP7WDgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/6/2020 7:36 PM, Andrei Botila (OSS) wrote:
> @@ -1790,7 +1792,9 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
>  	if (!req->cryptlen)
>  		return 0;
>  
> -	if (ctx->fallback && xts_skcipher_ivsize(req)) {
> +	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
> +			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
> +			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
Let's avoid doing this check for every request.
This could be achieved by moving it into the .setkey callback and
setting a flag in the caam_ctx indicating if the fallback is needed or not
for this tfm.

Horia
