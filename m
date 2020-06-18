Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD74C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 10:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B0D920773
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 10:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="bNPVtXxf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgFRKlF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 06:41:05 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:40095
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728193AbgFRKlB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 06:41:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT9FPgCro3ktANOiJHD+PPMCDO1vc6plJ38uGJCHRXSnuB4dIF0VX6GylAC4c8UAibTMByYGu2l3DtjReckP29YduZi7BiGCJTn43Nspgqnldwkvtd2UTBOb96QPay+zF54t2VRDP8cFpdRTqBs2MP8sp1D/ERNwkO6nsDPu+Rar/GgURnLvzMeyJUBkzQ/B+qn4Q6adL9pgdSjMw3wfIY+e+/aW3eLnF5LvSZux9mCiKMZkyfnmzxeb5OFVIWg6UHmuwHwYbsSXHftbnDOMLaq4XDcJBssVal5MIJqIkIiH3R0Voshduvj+UgXxNlVJ8YVHsYXmabg70Tv2bV2ntQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zo74kednEl2TbWBu03r4IVHQ2n4i8Ze4TBZspqkp4CY=;
 b=OXOMKCnBmUfX1eCA0GsYPUtN0VPbHW2p5xZcc+VZ9fjGAxZcnvJVBpY6O155Zw9imDXy73NqGG0asV+AKQE0ZmFYKhizg4RB86LEWXq4l/v6Fbyw8Nv+Cy7t3ZKgCnKB6PynUpf4mycwU8cvXOG0ULIXIIGHgcEY7ZBMFAp2V/owePO1b6ETKuw68taRWV4MCpbD8co4OTmXOfbZfpuV+PM0Je7h96oES2hj2U3o9M38wI9dD4APb2vQnp22M0UaCG3ZLHcsXnG566mIbpPcv4/U5KJiBYzY+15WK/0/E7VvolyfhIc5W9sUfkQrcKpnvpcnsD5ZRldIrnLA27+ppw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zo74kednEl2TbWBu03r4IVHQ2n4i8Ze4TBZspqkp4CY=;
 b=bNPVtXxfKqlJcuq4cxmQKD0mr2xOmgl7TSqXVxm5OXw9MQEDKWqGQ4OHMIzXsdr6nGdnJwvsEWut5v4SmkJxdFRh2JWyj1K287Avn0UAyhuXyRswu4CyNm2Lqtxa+GoL6qltO0cCD927HucdUgd51HB2pKTzH+jPrL4hxFNjEgY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4014.eurprd04.prod.outlook.com (2603:10a6:803:4c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 10:40:57 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 10:40:57 +0000
Subject: Re: [PATCH] crypto: caam/qi2: remove redundant assignment to ret
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Colin King <colin.king@canonical.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200611153934.928021-1-colin.king@canonical.com>
 <20200618075816.GI10091@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <5452e045-bd48-3b29-b364-bf123540ae21@nxp.com>
Date:   Thu, 18 Jun 2020 13:40:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200618075816.GI10091@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0095.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::36) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR06CA0095.eurprd06.prod.outlook.com (2603:10a6:208:fa::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Thu, 18 Jun 2020 10:40:56 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e315f176-d618-4165-bcb7-08d8137415b8
X-MS-TrafficTypeDiagnostic: VI1PR04MB4014:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4014A12FA57CBAD7097CF788989B0@VI1PR04MB4014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zh07lZNfxEyMYdHF6gHR5NRFpYKSD88Q14Ep0xfhHuOTXyIWH/FkD2GJFcn6a3YC0mlCeB79XxTSHR5f3yCmogar+8m21YyA/PXRJwfJanjf6Ua/XbMyolgjx4eSOdnl+ikojGp8gw0pbk1PMZdDcnzUf3jNNS5NHQuoe5DEwSDDUSf5hJ5UIsVIJIJckX6M9YHQ1R+RkwhVsvHxVlEt4ya/QI7t/39KiY9apPL71YjW1dv6jDs3QNCq6fRQ9q6cPQUuxtaCg14zveVia1ix1JWea5Uk6WaI8jTBvdKvu6OQKKHjKOagXwYEIVSZNkR6Sr3idPXOIymG3oKSLskXnkZzlqinhZdo7oCwrTvEXo35K17NZZS0StP7rQIho4dq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(66476007)(66556008)(66946007)(110136005)(54906003)(36756003)(956004)(316002)(2616005)(16576012)(478600001)(6486002)(4326008)(53546011)(86362001)(5660300002)(186003)(8936002)(2906002)(4744005)(26005)(83380400001)(8676002)(52116002)(31696002)(31686004)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SI6Cy1C/xsH0f5CSz2w9Sj7iFiRA18VpIlBIEc0s3JQjuJm9sAAs+wZvLZCpROQmrI57RjhxgEIvj7rkGacPj/7RjTHoFXp6m7+J9bPHSpfKmcaVzg6CWOpJMZ8qG/LL/dtfulEqdwgmJK26owcGdM556JE6UePie3ya8Ua9l1lJ9J949zj0n0xdhSKX5pVNTXGHqjPmKJGeOsG3I6O42LD5IzGvtVfb+yQtNwQzUpk7+/NcK2PXuD8nRmbQ8kqMP7yqpZ1rpliOdTpypvjqdn0HmIQcKflxRuyaNW40yTNX3uQaSiV+PPfH+8+T/NUzxKBZQRNQf6SwgdGwhjBR547WY9VuJHEmG+nnxDXvVMPYYWF8Eent7o4bRsmL0FiZk51+h+eWJBx3XCInAc9D+9TruRxac5jKXR1mzmOE03eI8gdbfp94JDUOCpKSphhuhJDa6w9km1NKxAtaYq9kWbAWWFCU5237lwQMnxc95tjQbqFjfkCujvm+1/lBDDQA
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e315f176-d618-4165-bcb7-08d8137415b8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 10:40:57.6236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJgYc2SXIZr+FSUnI+RiaLOUjtDSprpQogO9jD+PgaXuOmt4nbwXKGdsCoZ295eEbRPYBm2Q2DHxTLTZ21vgDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4014
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/18/2020 10:58 AM, Herbert Xu wrote:
> On Thu, Jun 11, 2020 at 04:39:34PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The variable ret is being assigned a value that is never read, the
>> error exit path via label 'unmap' returns -ENOMEM anyhow, so assigning
>> ret with -ENOMEM is redundamt.
>>
>> Addresses-Coverity: ("Unused value")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/crypto/caam/caamalg_qi2.c | 2 --
>>  1 file changed, 2 deletions(-)
> 
> Patch applied.  Thanks.
> 
Unfortunately I missed this patch, and it doesn't look correct.

Do I need to send a revert?

Thanks,
Horia
