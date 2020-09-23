Return-Path: <SRS0=nWKA=DA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B75DC2D0A8
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 11:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8825221F0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 11:59:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="RFaM3pzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgIWL7z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 07:59:55 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:59366
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbgIWL7y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 07:59:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ey63/CkgtCfUFnzF/x3NNlN4uUHaDU8gHe5pMWO078RbUIpnIGU+AoBbgqmwJ0zeQ1SIocLXTRQ6wJkNjHoH6tydLica1L7qK9D1mxWMoYTx7LrDRqoMrnkyhLQ4k2v1oEt11OVKXD334ZOWBNfhudq4ro8RjfYJEB1kfFjwlbKOJbBsgicjGERA5tXS3clfLT/GkMu5x/PNk9whCUqxbsfHgWOMll/rFDcJL/hKWi18YJi04Fcm68MvqlofZcIKDV+zAWvafu4uQeUYXeNYYU6+H2gqhV9RHTsjmhWBac75/Zkj6O2L1IZD4YQgM/YR2z36E7v1G29KVTQp39AeEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuPUhO0nCg+2NkjXYoqCwM9KMgKCBOedyMkursRSX3A=;
 b=UJNAFZIrM0BxTgau/pB9rvhLmgslHezmd426/f0Ajd/UxdMsDPisjpECHPvS2Gb7sqidgQJZc8mfXGIyeJ1e15vWry0GyUBIp3sm0zneiQRJYxIKbAUYrpda5IkMVZYDRyrhlWXlhhQpAOiXSMxpNb/FKtwaEIyd2KOvuYwf0AUi29J3x5liSyexabNHpb1vrcCkLQp784yhYQP7DL+YGn6xRfrNkviJKtnbHjknRxxwds337H867xzoUob6KQk8YN40CvVlXzpycLTwfzhsNpfFsaNqPY9/uH42HCX6AJqW9LouWw2fVRYgYiqC2ZZKpzt/Df8CzfScp4issh79TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuPUhO0nCg+2NkjXYoqCwM9KMgKCBOedyMkursRSX3A=;
 b=RFaM3pzgQLuIEp+HoTTQMmv7LxAL+a4IpyblmaLTeEDubwAbh1JxP+HmW2BW5Y0ui/XCLc62o/FAhV5pYiyxh0LLOaGHjXFBuWBJgGhO1doYjvYdYt08OQ+JplogDfOoJdkzG2r+JvuX5OptEzbf7toUXvBRwEtq2JMtYWUBuRo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB3982.eurprd04.prod.outlook.com (2603:10a6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 23 Sep
 2020 11:59:51 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3391.026; Wed, 23 Sep 2020
 11:59:51 +0000
Subject: Re: [PATCH v3 00/10] crypto: caam - xts(aes) updates
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <70fa9fb9-d785-1928-e761-2332c305948e@nxp.com>
Date:   Wed, 23 Sep 2020 14:59:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0148.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::17) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR01CA0148.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 23 Sep 2020 11:59:50 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cda6ee45-eee9-400b-71f8-08d85fb82d2f
X-MS-TrafficTypeDiagnostic: VI1PR04MB3982:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB398265A23EB51FD46A7EF28C98380@VI1PR04MB3982.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zjOQ0cngpwsWuiaRayboEO2RuqLq67H/SbZMI2ySOkmmo3SzHmBDVuic8AEyrv8PduFIlgBmaCHDHl5HRAwgrk/qPFJ2z1fPzcg3yYGI0q13JcEh1VicvhNKya6dQu3fDwV6SnWDnBtzpY02QlGrlm404DDiHA4a9+94csGKi22bpCwX/U2euTHV87fqRWGJH9HWiQFKoIvj6E1jm3dtgzNCw6Iw/TwYW9Mpx+fIn9vj6NJtbZ2TMHcg4pWW6HveliVS7JiqtyYWxTfXbpG1dBkeFipAjjQ19JxZdlkxmAoyJFarV8zmNG7OXymcaaYvKsQk/6SKK/54YIhKTz3pSDW2x6MD4TEQ1FNZHSlMvc03I4yzJTWx3XGHG61MIeHG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39850400004)(16576012)(86362001)(26005)(110136005)(36756003)(83380400001)(316002)(31686004)(53546011)(186003)(5660300002)(16526019)(31696002)(8936002)(2616005)(956004)(2906002)(54906003)(52116002)(8676002)(6486002)(66946007)(66476007)(66556008)(4326008)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Om3Q9zDeZG+OlJuKUtS+IendRLSiuQ3SayH6WQxtjngjVgpo7FSFR+AuO3fkzniknXBXYngq0fdwc03i3KNWlW31TVyWsgN4cRVlXWh8NfieqcFZmRxFIsOOFPZhwaLUF5/cOTTKsAsE8S5Z976kK4UpWm6UJtkFOzbCmNEG8xNX4Rg+ZjLvC0jZsJmAYZAwWxD8DA6Lm4SdSJNREhgpzM8mJ5hlV43poDIpqhGd7ZiHe1NqCc+sbz98SITGUbuoL6w/XsvbiWnCSS24UVN00W4thz484HFRRR69WT8edLHjmpWL2fby3kbQim00srXiRgkmMoEqrxRx+pGhBOAVaXRMPyJoy/r+JksqUzF143mR35g/HJ32sNwsABJIVreIo4S12YRazaZh5zzLJbP46PcD/xxLo3UFc3/HixDHIgsVr5jmN0MjXRVSdyrSOrhVq2E2sv4l62dYLldUXfVts/QEi4/yIjSPamjTCBnjHE1kvD2eQ2nMW476Y3ITzxVzaN66Ix3Lj6RVC+m+ORuRSv6QYKnjPhY4lw9XMwiJ8nIwdoD+CMc15R5SRuc+7Gwzl9pVCGXuyjMlsHM3Dt0vPMaaeCekbwqAOQEbBwH+X2N2rszG6RrB4FBDHBvBP4hNRQ5ZF1WBr6WEvMHLRltdsQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda6ee45-eee9-400b-71f8-08d85fb82d2f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 11:59:51.2428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irKE93dPr5Pbye4KuSyVnCcSmku1t8RB0uWEgHBqh4m9Z+cUBOn7cV0/WqaihM6CVuGmldbHNK1JYSdWfH6JWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3982
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/22/2020 7:03 PM, Andrei Botila (OSS) wrote:
> From: Andrei Botila <andrei.botila@nxp.com>
> 
> This patch series fixes some problems in CAAM's implementation of xts(aes):
>  - CAAM until Era 9 can't process XTS with 16B IV
>  - CAAM can only process in hardware XTS key lengths of 16B and 32B
>  - These hardware limitations are resolved through a fallback
>  - CAAM used to return 0 for XTS block length equal to zero
> 
> This patch series also adds a new feature in CAAM's xts(aes):
>  - CAAM is now able to process XTS with 16B IV in HW
> 
> Changes since v2:
> - modified xts_skcipher_ivsize() based on comments
> - squashed the previous 7-9/12 commits
> 
> Changes since v1:
> - use only get_unaligned() for calculating XTS IV size
> - fixed the double calling of crypto_skcipher_set_reqsize() in case of XTS
> - added a patch which modifies the return value for XTS when block length
>   is equal to zero
> 
> Andrei Botila (10):
>   crypto: caam/jr - add fallback for XTS with more than 8B IV
>   crypto: caam/qi - add fallback for XTS with more than 8B IV
>   crypto: caam/qi2 - add fallback for XTS with more than 8B IV
>   crypto: caam/jr - add support for more XTS key lengths
>   crypto: caam/qi - add support for more XTS key lengths
>   crypto: caam/qi2 - add support for more XTS key lengths
>   crypto: caam - add xts check for block length equal to zero
>   crypto: caam/jr - add support for XTS with 16B IV
>   crypto: caam/qi - add support for XTS with 16B IV
>   crypto: caam/qi2 - add support for XTS with 16B IV
> 
>  drivers/crypto/caam/Kconfig        |   3 +
>  drivers/crypto/caam/caamalg.c      |  94 +++++++++++++++++++++---
>  drivers/crypto/caam/caamalg_desc.c |  27 ++++---
>  drivers/crypto/caam/caamalg_qi.c   |  94 +++++++++++++++++++++---
>  drivers/crypto/caam/caamalg_qi2.c  | 111 ++++++++++++++++++++++++++---
>  drivers/crypto/caam/caamalg_qi2.h  |   2 +
>  6 files changed, 293 insertions(+), 38 deletions(-)
> 
For the series:
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
