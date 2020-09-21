Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE5AC43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C90E72151B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="XXVHX3Sq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgIULrA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 07:47:00 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:40355
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbgIULrA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 07:47:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6Q0IHvwGt3ZLx46hPdgKsb12Ytrkjisn5sj0p5wbYU3793SvrO6bQYBZDgLNyECJEFWLKxnPGKox2vvrx+FNM6CeRiMF4Ddn1JD1ImxyGbLZBSLXRoHZzLBoVQh60cNNFVy4GDRdp2OfuRG3xEhpAUZ5PePYb3kJ+XlKAEJlq0XEdZxKGBDrQXxncuXEi/WAQNYmqxuZKbGdOzKJr3lsoIlQFPfS3HhxQ2JP7QcTjfDIwJku4rhy9GiBw1/wvDVK1bX0FeVHBUrqVowVpSyd63QE+ZRrlfR3eK8s0mC/FnU7I6p2k+U62mbvQ6EKHwqfV4EwAm3ggXjyoBsg9Bz6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jchTzW8LcExDA/y1+NGVBdA1l6Cmq6B3prqTlLsbic=;
 b=hK9eZD09co2j3JloWEf+yrTHvjl1nVy8BD0jTyqdVDFQRoDIMoEhAK/r1K28zI9K0Coj6b56Sbzy00VMkrFr3Dllzkh5KFiCCUieWlFZdgfgrog6deYUrV8zBi6IvwMZxye76Tmle0PHR0+HSNhfSAEjRdtn47++DXMBwiC1H1paV2xB6LydbKullu7RiomrAIWHCwUHg646PBPJHzM9bqfFozfAoHqOhspZmu6+HU5wP84hOrD0Nn2lGci8OoN1IeIB/BB8FfOgpvyTZ3iJlmkFtDz1OwKvEQq61CVIy/mAC3jTcP9J8Mg5IKeEu5MawklHbU49RcWzBtgy1S9VPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jchTzW8LcExDA/y1+NGVBdA1l6Cmq6B3prqTlLsbic=;
 b=XXVHX3SqfXm3NZafFvTTMSmYe41HdvytHjzxbRDFgwHh7JowSb0lMtbZjTQzf8wNK741kqwxFb9ufEHFxiJEM+FUfk0xtjSbb4HeaD5gWUVup2fh+vvkbVivyZek8Fhfo0Aytha2nd62bypselToQGgeiQ3VrDNQrexTrpSE+mg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5039.eurprd04.prod.outlook.com (2603:10a6:803:59::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.17; Mon, 21 Sep
 2020 11:46:56 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3391.026; Mon, 21 Sep 2020
 11:46:56 +0000
Subject: Re: [PATCH v2 00/12] crypto: caam - xts(aes) updates
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <a0645203-340a-f298-c407-8691c04cf47d@nxp.com>
Date:   Mon, 21 Sep 2020 14:46:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0108.eurprd02.prod.outlook.com
 (2603:10a6:208:154::49) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR02CA0108.eurprd02.prod.outlook.com (2603:10a6:208:154::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 11:46:55 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1938865-50e7-4a38-68cb-08d85e240aa4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5039EDE7454D7CF644741C92983A0@VI1PR04MB5039.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SISKqTvMmuYJsDT5/jDy1MN00zyx3r5OjZDkcJjgsnv7Wm24Uwisatary/oe1K38p1sQ9y/SahIOumydNELks+lTfW1OJHBLyQObiReAnj6mk+Rznsv3TG/nCXlxxm30v1mkQBjQxvxF14K59gmeI0lpoWu8IcHWlN4v1G60UR7X2ztUCKPQdTCBDjTgPEXeRHZL+4Went78GqnxIWCQNd2DuEKTKLLj8BQq+ToPAB/55ZJkVfcXuuvJnTEwph4Ld3KGgBxpxIr2hiPfr7kXSDOvqJEgwJqNL+43iG+p5EsNA4TqfvZ7HU5HbYiGi0f0n572sraEAtBrBG6iVRMVVa9j4gVeNbdPHjNE4QhRll57xtUb+FNcHwTkpvK7V9u6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(26005)(52116002)(110136005)(66556008)(66476007)(66946007)(16526019)(186003)(16576012)(316002)(4326008)(36756003)(83380400001)(31686004)(478600001)(2906002)(6486002)(86362001)(2616005)(5660300002)(31696002)(956004)(4744005)(54906003)(8676002)(8936002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m1xNqDm4O4RxW62i3xehqvNvkr+Irdqhpc/eyybeg+I3R0cXT0qIXAFM8JjC+RpkfDAngjMON7YLk/YPNX8tBysvFnuL/8sxpkiwH7xBhGpiF3GI/T61bffBV86KzMtVxoXNcCevZch8iKbK/Argx7mSIFzJH+sjSrbjLmQcuKeQ8f19E5ylGXglrsRtaofGkmNZ4lawUiamznXN64/qmvJl6LxJ43NvYwsSMQfk38xeZWnEQYxF6kzBDDmP8DlnBX71KPS0MOiw6TanOtoYZb75IRd/LnHEQI3jyrF1U/3oTEGWT9IPc/YPO6Pv5Dvrpp2H1h861IXvoEQ2ukuYuo6luQloyyMOIaa66i6PnhjrCmIhiWmngmBnJeYBMDcwPqJW31GBgAvrgrQBIbLM74HQ7uv3PTfn32TwN9ZWONgMb1xWpS9FZkYibLVpTN0lO4S6X0qX2uUataJT6B1A3eaSLuF3Kge0m3qHsajWN0aZKXh51+vcn8vDcEP3VmPCLXi5CnUC0YnD+ozE1qmmBnmcfrHGHY21BaS1o8IZTKQdannfByVZqdp1Pz1Y7zW6Plx2hR360rpRXgUNOIke9Ll9AE0roUJLEh4C/AefqnVY/R3bv/qIIfYh4O/9SlfQ5qpJtILoSGYJgHtV4o22XA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1938865-50e7-4a38-68cb-08d85e240aa4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 11:46:56.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyP6rQVZ/nPzy0Du8zjZFdtJEGGfZHyl4yFIhE5uiSC6SG2sYViRNQZ5V3DXZR8fADCJEChME7tmXYg9hGnnog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5039
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/21/2020 10:32 AM, Andrei Botila (OSS) wrote:
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
> Changes since v1:
> - use only get_unaligned() for calculating XTS IV size
> - fixed the double calling of crypto_skcipher_set_reqsize() in case of XTS
> - added a patch which modifies the return value for XTS when block length
>   is equal to zero
> 
Nitpick:
The new patches are 7-9/12.
Since they have the same Fixes tag and solve the same issue,
it would probably be better to squash them into a single patch.

Thanks,
Horia
