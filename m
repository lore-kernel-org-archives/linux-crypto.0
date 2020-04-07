Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D31CC2D0EC
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 18:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF4F320730
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 18:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DNOK2pf+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDGS4F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Apr 2020 14:56:05 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6053
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgDGS4F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Apr 2020 14:56:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIadzEamwwws7A+nKNumsSCtoV/N0REGB4nYpQOPTteaXd4o4KVotNRVvRQO7mpZQVNuYq74GX58Nx9fvd5JenBOa0HXiTFihBAInjghMV0A7uUjyCpVGxGzz3nEQIPV5K9q3fNn3sA0wqoEYLjO/NvvfiHxb3+ofKYg+w6rXjXSzP3zwnuhI0LYXbX0s7umvYrRQo58KCTxirHPxxYhVAYjVZNZlIoYSXHjNoFh4BxqK43XkAdix1RxY9hUfMnG8JYWB3NgnV1VT+7oRXwJxSrysP+VzNfBpjdFHettXP3qCy8l6Vzu7BuaefFE+iEO+veKWg7T5ZSJoJZlruRWBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WuO9sdzmjuaGXvuSNzNJLVbOF6TRNvf4DembhgZDCY=;
 b=LTIkpVJuX0QErt7QkbvkmUkzyUqSXo0wFgrEksO+rIpnv0x+DUoX+sKbBCJ4B+Lph8yrRQd8kG0Kpf0DKkOzORyD9gz9gZZU604CtZPYKpzybnifc4B59ULBLr+ARJe1vbq4Ivupl2hMLR4eyXVuNStGZn8RsbjXU+z+1Qb1/1H/63EfU4vqY4dPzx7g5bkVc7ffofUDxQeryiyE6WXCswZwwsJ1zsAFtuUoIFCL3JelpoinSjiJd1H8/otURLnUg8AGaAldVqb7ddYzB+o4xcRkQgjKFrphZ7fis5CuzEG8kZvSPGspeGlq4gg2L/sw8k2rlDrD8i+mV9pdEnzw+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WuO9sdzmjuaGXvuSNzNJLVbOF6TRNvf4DembhgZDCY=;
 b=DNOK2pf+WfayazeMfUHYOHxgFOnXQF2990oTku5Yvi3OdxXTAp1LAUWcwBjWdkkS51yiLqjCjuh9nkVddRJ542PXXMiTntWgYr/CRRnP+i9kmKXTqIbS/0fIDbIjEb+1MVnzFvkDpYG8Z1uoLh3ATSVuYb7ySXilxn/SkyxVF28=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (2603:10a6:803:7::25)
 by VI1PR0402MB3469.eurprd04.prod.outlook.com (2603:10a6:803:d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Tue, 7 Apr
 2020 18:55:59 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2878.021; Tue, 7 Apr 2020
 18:55:59 +0000
Subject: Re: [PATCH] crypto: caam - fix the address of the last entry of S/G
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1586275125-20571-1-git-send-email-iuliana.prodan@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <023d6704-557f-d701-a19b-2edcb002bf6c@nxp.com>
Date:   Tue, 7 Apr 2020 21:55:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <1586275125-20571-1-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR03CA0066.eurprd03.prod.outlook.com
 (2603:10a6:207:5::24) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Tue, 7 Apr 2020 18:55:58 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ce690f5-18ec-44bc-96e6-08d7db254fa2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3469:|VI1PR0402MB3469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB346942268608BBEA2F252E5998C30@VI1PR0402MB3469.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(396003)(39850400004)(366004)(376002)(4744005)(81166006)(66556008)(16526019)(26005)(2906002)(66946007)(5660300002)(6666004)(110136005)(54906003)(8676002)(186003)(316002)(52116002)(8936002)(478600001)(16576012)(66476007)(6486002)(4326008)(86362001)(2616005)(31696002)(53546011)(31686004)(6636002)(36756003)(956004)(81156014)(966005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZBVNi/+9wG5hZjQh5GR/EJD+XoR/PhGTNPzw4JKcrb9RTcrNw1Ji/b8wuCFbVDSpsrkC8i1lIn+xP75qMXPJ5GNczcjFqr+q7ubrjfHvpM+oQFEz117ryr/Mmhs4yYfpPPoPeg/vdmMcZrUFDghazHcb9oVOgSZ0O5o++nhUaRvjbC1M7atFT6dpsvgvZ5ZZnqq7lwr7tVAC7iFqz3plCiBXE49FpGlzNPc/GD/pPqcZJR27YLVkzZboponodkIyxU31gYTC+dsKiTMiL7vcHX6wIPb2TAYwNsBDkMeH26Zm8cZxNaMWLxuVr8iw1kujJraWF1+vkWBKbMv4pPTDRkVTjrZ4Y7t0h+X/NCpR8i7CiOkgaRSV1NjvPO/zdNt4uvb3ZuamY9lAywBJAfBRazZualGw1V6AOzrOVinC8g4F0GBF5NkQ+bJEGUDT5xGW1G8e7NzB+5hsy32wvH6StUX3pnCGFquh4ytnTtn2Oz7Kw8KZTXIqOEMJ6IqhmgSv//TqFrTESzrvkUDRyQS+/w==
X-MS-Exchange-AntiSpam-MessageData: eZ+1ECNTfiJ1R4jwOuuuDDYDYQGfxvbSnWbkUyPoNjSdC1/9Ej3jtoK0qem+6Tuu8AGI2t4LAPcZ7XSjmqSHWnm6tS6soHH0yXuOna8YIfjcBWSXIXfSCBTBuFSO8gdh7qvey5NedsB9KUJzhxBlHw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce690f5-18ec-44bc-96e6-08d7db254fa2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2020 18:55:59.4851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PHAt1TdqcBA3JpbgR819IOKuuqV/D+qsygIQ4m6iMBrUbsWNuPh71NF3QI+OywHIe8Am5b4lxOEApHeLX8R45g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3469
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/7/2020 6:59 PM, Iuliana Prodan wrote:
> For skcipher algorithms, the input, output HW S/G tables
> look like this: [IV, src][dst, IV]
> Now, we can have 2 conditions here:
> - there is no IV;
> - src and dst are equal (in-place encryption) and scattered
> and the error is an "off-by-one" in the HW S/G table.
> 
> This issue was seen with KASAN:
> BUG: KASAN: slab-out-of-bounds in skcipher_edesc_alloc+0x95c/0x1018
> 
> Read of size 4 at addr ffff000022a02958 by task cryptomgr_test/321
> 
> CPU: 2 PID: 321 Comm: cryptomgr_test Not tainted
> 5.6.0-rc1-00165-ge4ef8383-dirty #4
Non-public SHA1, dirty tree.

Probably it's not reproducible without applying previous fixes?
https://patchwork.kernel.org/project/linux-crypto/list/?series=266561

> Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")
> Cc: <stable@vger.kernel.org> # v5.3+
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
