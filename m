Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BD0C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 14:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A586F2083B
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 14:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BhLpxWGA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgHKOas (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:30:48 -0400
Received: from mail-eopbgr60068.outbound.protection.outlook.com ([40.107.6.68]:37698
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728516AbgHKOas (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Aug 2020 10:30:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbmWLfgM2JbicQnpDjC1jr1bVpA8T6PF4P8LFnIvL+wX651jvVW3i6HiW94FWYN4/Rq43hNJZgMZwzcntZJA3jgwyykNgW6UcUFElDWamJE9Z3THzXX1orsRAilvfHs/8xWF2bpsgn6piSnzHR7UgwuIgMwgS9bYOSUyRAcrBP22OecbTR3q8AMJ2mvJ1rU+7/pA7pTmW+PL0NMz0lhhexfTd0XLRZPIIcumX8LLejtgrEEMOskpz5d+/jLWAAKc3FCDlGteIQrlFVv/aDVHnGb6RQMzlehIjCa9DOgfgYqbnyCS8xN1qnAMAmYM57GRdwJB2mFlwf2vX2N1Jc3k3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMRCoDZK/hj/h8+Q0u0UPC93jqDj7VE46FRLrJq6DE8=;
 b=oPlzpM+semcGvxZ+wJO/a7MIjE4MvLFHMCKUAVt1nUhC9ftkJI4siLbLLzpFWF5hXRMV+156Klz1JjCu06XHw9KzWbNgmP/jxuznUW1BybLQdPYfzHZ6wTsDohBek6UJjhKiUXOo0SHUVuApZWMosoz64L17ktSepzTQSmX/PZTj3SNmwUVlq3YsHESkI0O+XsU804TgJCeYhZwDqclM7pI3IGBqf1cMCGfrLzCggY6X+/ECMR5K/ZlBvWZ31npN5nQ6ke239m7HHuHe0ghzSvTZJwvO5RtHRDeZvTn6cLtvv7Bowk5W4S5UiIr6LWpb+9JSLosRUcWk8HuaVddvkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMRCoDZK/hj/h8+Q0u0UPC93jqDj7VE46FRLrJq6DE8=;
 b=BhLpxWGAnQn2WH3KRf5/5JDijQpaQwyeWRlc7D0i/aaGsvtDUIrdcWUpY02KnrkFfb1hAEpJvDPIyitA7yZuP6QkZNcyTmKYr9NmyfiB9PDcIgpKbYROGaMchK+Bs2/uGC6ohG8eBom59xPJU06ai6yJzG2X6gLFTnf4vfGWdiw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB3422.eurprd04.prod.outlook.com (2603:10a6:803:6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16; Tue, 11 Aug
 2020 14:30:44 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3261.024; Tue, 11 Aug 2020
 14:30:44 +0000
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <fe251307-ba89-a4bc-23f5-205a1e1343ea@nxp.com>
Date:   Tue, 11 Aug 2020 17:30:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200806163551.14395-2-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::35) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16 via Frontend Transport; Tue, 11 Aug 2020 14:30:43 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fdc67255-8c1d-4e7d-227a-08d83e0321a0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB342216ADC16D92B04F52A42298450@VI1PR0402MB3422.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0Irqe3KRqrki2xERZYObVPiYJcOUGUu4PI9/Jv/UZfXtCRr1xBFzwdXJwTjPes7/zo7p/VMpWZo9tVzq+frmr9MZRFduO6M2AsL7obGGx3TkVfHl38j0MuKMwpwwWGVsN+SYet0ykfZFZpp3ujfFNOspwDdBmdXrSyt6n8lMJShh9TgBUVnXBo5qSqEeWvyPa3OVZygKe7IVdqvPWrqEJc9DRW9wg1zk0Pc3ZU/oorY8PCuCP3iXO3T+M0vsTRrdzeGxwVhJNB8kjSaiFhouD7NIkwxIqrLp4KVihbvnqIJJt1n66adMAghRPZDYHMDlhnV4QwuqOupBc6KmJi4459Frjk72G3Jz3sbTL25hci0JNIk9nDX0C+J821wPH2B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(31696002)(498600001)(53546011)(31686004)(110136005)(8676002)(8936002)(54906003)(2906002)(66556008)(52116002)(2616005)(4326008)(956004)(36756003)(86362001)(16576012)(16526019)(83380400001)(66946007)(26005)(5660300002)(66476007)(6486002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0oyItuBqsqflXo+gFXl2kKKctHM54mDInJ2sm76HY0mSXHknZw2D++1OPSCYyeW3zA32em640lpHXedoMX1Eto4WyGpj72cl6xJbWLD6mWwnn3NBzmG51H22uvsZFkLIX/6m7JXUKuJ0IW2p96zbuGTMX2kk7dm3alc49/jjYogU9nSwIQXBpSPVVpbcPfTinfqEoShJZ8e17DraGjejJO/Io4gZpLDUY52dvqj2d7J54lTIAliGgpCAu5vzpCJq92ZV4chkudcDJlbTwHcKiup4jnlOcGFbwAZfVOFZQ6KuAGpfXv3Gykt+auCMhJ2i/sjPSUfRI4KBP+JrI+LQrZuq3Pn8/LA1Tx/U/TrDnYhdX++M0YnTLjNtl7nIUbwCyLzjEzeELYkx+xlzen16FUwdxJ5DMjdHaCei7rlwCxlFf0kh4xwKnXtRtF56fsCwR7M2l2lxLFSjKWPSjqIRIfJjiIGQ6IvlDSCSXEqkpjKUsg3c0YAGdvQ1HFDrhSJoFK+Dwy6aOmioAWpejpT9kxc8NMCpGEBJhPr/jqi192Q5aiSWVc+wqW4Juz7LgZ//Igpiv62csQvE+NZGnY73q/xe7Gptd+jvXh5YbQh47tDl3qJzMrC32W0avVuvlMTeca9hFPiec0SRc+pmaAEySg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc67255-8c1d-4e7d-227a-08d83e0321a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2020 14:30:44.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ML2chZ0z3EAsPP1aryPn9SLsM9cB4jZU73cMLKWhUlIvIDT5OinfApifCzc2dgwmPkX/R0A5GXsuaX5Y+bU6hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3422
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/6/2020 7:36 PM, Andrei Botila (OSS) wrote:
> @@ -3344,12 +3382,30 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
>  	struct caam_skcipher_alg *caam_alg =
>  		container_of(alg, typeof(*caam_alg), skcipher);
>  	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
>  
>  	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
This is being called twice in case of XTS.

>  
>  	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
>  
> -	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
> +	if (alg_aai == OP_ALG_AAI_XTS) {
> +		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
> +		struct crypto_skcipher *fallback;
> +
> +		fallback = crypto_alloc_skcipher(tfm_name, 0,
> +						 CRYPTO_ALG_NEED_FALLBACK);
Driver should select CRYPTO_XTS, such that at least the generic
xts implementation is available.

> +		if (IS_ERR(fallback)) {
> +			pr_err("Failed to allocate %s fallback: %ld\n",
> +			       tfm_name, PTR_ERR(fallback));
> +			return PTR_ERR(fallback);
Shouldn't error out so early. It might be that the fallback won't be needed.
Let's postpone this until we're sure fallback is required.

Horia
