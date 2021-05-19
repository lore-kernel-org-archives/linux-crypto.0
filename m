Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CC9C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 20:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF07561040
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 20:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbhESU5f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 16:57:35 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:34368
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhESU5d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 16:57:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUpNXJyWaJnrJs3BQTvoWfMs64oCSW+oeUwMEX+D0nOI6bXoBbqni/KpRSM/rBxqveMvxmopmCpkQIft669MxCQBDvelqeigpLxobKDRKhPLyFyZb+6qpL+AAv7L53Hrx/JoKc2wpT30h+8LNEOA/oaKyAP9N5/52h9qvkrvAARkc1cdm/mkmG7GqDKFuoHywYyU7g0VzYeByomWARgRBBUUXE0mLoeZglKILy3GA5jeK2lmX7JP8JXlh3GKKdAvjbdHGUyy9OiwiEj9yBQsakgl6OnUHFIgOzQJKSxCwndZe0BTMnsd0A3QWyJdjoTaxZzPv5nxv0CePc1TURki3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJL+ORYHUxk0s+3JCRFASlcqAxqYHDKlRhY2n6drJN8=;
 b=CF9WjAIGg2PYXQlDRv6AIMf26L7ZwHvNYwREynhAMZ4j+YjXI4nlWPvRFBI2aNI9BjrZWhdUEeliYSiORKz27pqGcYkU7p7drmG0NCKe+uT0ABwf88m3e/7AX0f71oKogiCp+jouoHgBRSnvagHMvvolETIXWWMI6L+7bGdVo0Zhb3w+0x/nJHj9IFHfqd2tC06t4y43sBcM5l1MBhZ+o4FRWTAJzbnkOx7Y8sxOif/c5QXhLaTQos+qCnX2QC0vKV6v9k0x+/vnr9CBlZ07puNSzrlZlTczinY7XkD8tHepoMWjixSyGqys8puGr8hlQP/eRRXytDQ4p9IUzmQsbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJL+ORYHUxk0s+3JCRFASlcqAxqYHDKlRhY2n6drJN8=;
 b=pmxV9VvT4agbm4zayS5MK2wUxOv4azBqvOATJTQGwzpmMVGIov1EL3PICRYIcWVUhcytNVzhzjBAyv5EjsAs0hl/lzC2o/6f4HN4Y53bXpZL7zgQjtADKcH3bOoHNfI6NIGJbdLnw9AbIgXA59QKzDaoQ1HLRbBe+TSiWTH9/bM=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN6PR12MB2624.namprd12.prod.outlook.com (2603:10b6:805:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 20:56:11 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::e86b:eb7e:c7a5:50eb]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::e86b:eb7e:c7a5:50eb%7]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 20:56:11 +0000
Date:   Wed, 19 May 2021 15:56:02 -0500
From:   John Allen <john.allen@amd.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, gary.hook@amd.com, brijesh.singh@amd.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Fix a resource leak in an error handling
 path
Message-ID: <YKV7YkyFKQYY9WE7@AUS-LX-JohALLEN.amd.com>
References: <4af832b7e75b729ebfb0f07fe039dc47712512c2.1621146079.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4af832b7e75b729ebfb0f07fe039dc47712512c2.1621146079.git.christophe.jaillet@wanadoo.fr>
X-Originating-IP: [165.204.53.104]
X-ClientProxiedBy: BY3PR10CA0008.namprd10.prod.outlook.com
 (2603:10b6:a03:255::13) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from AUS-LX-JohALLEN.amd.com (165.204.53.104) by BY3PR10CA0008.namprd10.prod.outlook.com (2603:10b6:a03:255::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Wed, 19 May 2021 20:56:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bc0920c-0e88-4b06-88b0-08d91b08886b
X-MS-TrafficTypeDiagnostic: SN6PR12MB2624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26243967FEA99114412391419A2B9@SN6PR12MB2624.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VLN1fckAlqxjzQ4ilS0aqcPjGnoT34mjfEOZ2b2S+U7T6jPhP39RgKrZIVhf3ONBODDYunCugb5MMmRxD5fw7ijpoGc4ZImDGzAm4e7xpBJGKEEE/eTnspCs1JTb+51M3yjmAN1//4RL4dfJwED6x0W9z0MgVzKvFmFIQVEZ8/QzTU01MVCdupS1/owxchUxweaR9aUn/BQuAc9zgw4Qs1yjMRt0UCUXgasR8JE2law5JmRT6p3oeOo5gbncFHeTCGa4QZuXMOchUHVcUwXbmedKcvwE2qznVoIMmdbr3JKRXArYmBhRqmHwGwG07X2Mx9+u6UkEt3uNQSz6+ZOTI91/BJhjAzg11DywsadEebOzu5FaZ22nLe0e7poyRJau07J20i/hGGt7bOs0ffTlr9dC5Qi1YNoXvuNxOTV27hCL5g4ZIpvvlM0C1+C6hWwNC97JpHOgRpbndoNfsU3SQwKNnThmRBpxpYrSY1yJaLD90J/4h6KKt3/WYPL+8uur9KFRLBsPA89jBAEt6hmju8wo7+lP9pWtIL4Jy/NFmrl4wwQIGir/erEOow3npvT+A9rlpiOpLH3Ki0ybF3EOZxwGoH6DJTZawj9lnpNiHWx/1lxFuv9qgKQ3wfYloqOH0KNq0ujKd7J1anGovAeitBCLPf/azvz+yUXH7ZxcRmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(55016002)(66556008)(4326008)(66476007)(83380400001)(52116002)(26005)(44832011)(7696005)(38100700002)(5660300002)(8936002)(38350700002)(86362001)(956004)(186003)(316002)(2906002)(6666004)(8676002)(6916009)(16526019)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UHfM4UpROdASn26ptTDFaDCfU2Pd5NtgLZRhJS63y7syw3IlPfgFXRFlYQRT?=
 =?us-ascii?Q?V5LxNycvflSYaUcFROKeSTc6mfp8PvpnTGcDgf7GBaDo0opqMM5KSIrHb4rg?=
 =?us-ascii?Q?B/+JFrKKjYWDmzfj2Oq4O86ERcJHIdFgHR0Rt3l2r9MIfEtAy3G5O7rlARCo?=
 =?us-ascii?Q?DJCxLnlyO3g5ICLv+OZfp5hh3TeeJSDXOs8+1EUf4xnmlifJ083OzzfK9S6P?=
 =?us-ascii?Q?8A/9Svg+PKFMjTLPQ5HLG8D4uIFonAEHaMBNYS/SVRmpxZ8IKAVad1SfVbkL?=
 =?us-ascii?Q?JbFsbk8hRP/9tajxUB+T3xKTQvuaM+jMpRlD/yiz6anHHkueG2hbf9g0qQes?=
 =?us-ascii?Q?c9I5jbQErIrWZbWpEl8+YtV28WZVXsuXs6i0viGHQX6Z7JjWElZUwUqU/V8m?=
 =?us-ascii?Q?LZ4WKGhYqqPiJxoy1uj34vPoXjrfTNhJ/8rYR4sKdYGIytw2vo503Ckbp+EA?=
 =?us-ascii?Q?Fgi+FVgDSYPEa6QqFlNp+nLDrW7/JxqXkqTiluCnuIyOQ5J3XHSashkHrrtl?=
 =?us-ascii?Q?1sc5/gkhWfY5QXqtrkuadAtpl1xLry8dPMV38Wd0Rde+LTQoVvlxxZkGGjO/?=
 =?us-ascii?Q?sRG/3QI3ne8PX6AuAVPKVcuRiG8onl4EQEf6KjKgzMgmsp71fPezhQSS2w3p?=
 =?us-ascii?Q?b0R51bxKvS063+JN8iWZngt2y/k5CRQQdVCxUsaX8EpDbsPjvZV31K4kdwze?=
 =?us-ascii?Q?7AfNhhhtUX5HxRcryXzZD6UiEReBlza2gjmCaEbaKTVGjkdJbyOLVISYpMor?=
 =?us-ascii?Q?DrcwM27XyF2bVmIkT9xMbXQCkTSTsZpehKfRfJNiGZ95pLV6mfsjxpzjDDFs?=
 =?us-ascii?Q?09n525Z1AAoo3W8lA8M4o/qdIMvtmG/PrfkVs2zK3eP8t+40qRujxuBTL9k4?=
 =?us-ascii?Q?Ib2aF2BTD9hH5K/pra785Ccpmjo3tPwWGc1Z4ll2VUC2QT0KrDhtMQqlmhHN?=
 =?us-ascii?Q?rSl4nmtJ4oiNG7Usw9XWB6dxcoAvKhVXRNOo7p9DG3vprrvlsGBpAOQiaaYp?=
 =?us-ascii?Q?ay98cBp2yHFwBgjE5G3zcoijbr9VGObPIKmgYdZnVrfWLv0VPn42JPfBuVFw?=
 =?us-ascii?Q?OuYE2+UD7oxwzjcRtvtMb/LAzKdPMeJSokZmzW7qJwKmY0wOalXNDl4uJT/E?=
 =?us-ascii?Q?bWOJYDq/xOapXGr5nD67gAY52Ee2J4dks9wK26TArvcfzf8HIISnUcD5TKvG?=
 =?us-ascii?Q?qosuafUH3mHeIJnVUDnpjUjDlPM+IAqjGNtPW9kS7jDufJ4dQh99tGf/Yk0d?=
 =?us-ascii?Q?JJHFMXwpORA6cCj6UklLVasp9c0BCCiq4siJ5t23OOs7jXXiL2c6FdM95Io4?=
 =?us-ascii?Q?TJZzY3Rf8I+YvOe9qyQugI7A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc0920c-0e88-4b06-88b0-08d91b08886b
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 20:56:11.4841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DhkCYaP3nexFyvIsXPY8YfEWaIDAdvWKdni3jwlqeaCtQX3kl4VH8hqW7xdjEYSYrl03PUrQE8wz0H4MGnzgPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2624
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 16, 2021 at 08:58:04AM +0200, Christophe JAILLET wrote:
> If an error occurs after calling 'sp_get_irqs()', 'sp_free_irqs()' must be
> called as already done in the error handling path.
> 
> Fixes: f4d18d656f88 ("crypto: ccp - Abstract interrupt registeration")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: John Allen <john.allen@amd.com>

> ---
>  drivers/crypto/ccp/sp-pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index f468594ef8af..6fb6ba35f89d 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -222,7 +222,7 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		if (ret) {
>  			dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n",
>  				ret);
> -			goto e_err;
> +			goto free_irqs;
>  		}
>  	}
>  
> @@ -230,10 +230,12 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	ret = sp_init(sp);
>  	if (ret)
> -		goto e_err;
> +		goto free_irqs;
>  
>  	return 0;
>  
> +free_irqs:
> +	sp_free_irqs(sp);
>  e_err:
>  	dev_notice(dev, "initialization failed\n");
>  	return ret;
> -- 
> 2.30.2
> 
