Return-Path: <SRS0=2iMm=A7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D130C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 12:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41CDC2070A
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 12:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Ew8zAkM3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgGTMCH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jul 2020 08:02:07 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:64152
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728058AbgGTMCH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jul 2020 08:02:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnhVuAwR4itdcWrWOteQrQR5qK8RyvMSIaMSXOBxKlJqrvtTn/Dj/uzsJhpjNqctGxqj2qI+fhqkym9vvpheeYJnNytYujoKTwHa4QLWANdJp92yEC0/T74Jyhfx+s9ecUL8g1s2u6AFo/cpyK1BQLps4imtign7Z+UvavLfEHCy6ub49nkWiBOv2UvsGINF/eVmlKzn6veYEc0cnkzCcAgbHkVdNb+3KVd9chFXPuJzVqtoXEWkilvqWP2FChhxw3sa6UPlL96HYz5vfsJ/TdkrwgBGomjjFJ/F8EtItZj5kTkLtghzpQzkXkpdUBT3/w286/gJ/T3LgfdhqOGIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjFs0J90QAFsHMFr24nq+atxqAuvvFgfwmdwv2MJpKk=;
 b=BURj9bxyBkZDsCN861JiufIcT1MOh0HGGrWZiFNthEs7Yxrm9wsCIhET4gUHSMrs62CI0BhlyDzKvRSGM5KZzWN2XidKoS1wCqcb0oQXfwN7+gKzPaFlqbvKdZBPZ9rAcOonv+khw2pzec+aB3jzpVtRNdh4ncEqXIPzV5klC5nn9b1LVgRiuZFJv1fe2ySzrv8yNwL4zJsqJyutZLHsj4gjKDRv/Z32KYWAaclkxJkOYk1s0NpXswCOAlgQBg8A510iRSotabgVEQ+sgqfdeXlDxfdLpOCGMSy/SU2tTNVqSsbbUs08zBKDJtPBso4ldKMTLrjVQYKVrWRsj3CzWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjFs0J90QAFsHMFr24nq+atxqAuvvFgfwmdwv2MJpKk=;
 b=Ew8zAkM3ymHIsrpYQYMki/5C8LZcqCYne18f9qypN4RY1qzBDr9+jX4b8LfAA+sGQa03jG9TCf29pv5YZrB1RxAV8CmiK2fSVuF9FaorMDDxA8s0n8skSXfVpKAqxKwMurPW+4z2/1r97jLgu1/SB+LNPg7soNCtsGKyGF6HqwQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB2974.eurprd04.prod.outlook.com (2603:10a6:802:a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Mon, 20 Jul
 2020 12:02:01 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3195.023; Mon, 20 Jul 2020
 12:02:01 +0000
Subject: Re: [PATCH -next] crypto: caam: Convert to DEFINE_SHOW_ATTRIBUTE
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200716090403.13507-1-miaoqinglang@huawei.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <00ab6498-a1cb-afb2-b1e4-75389bfbbd4c@nxp.com>
Date:   Mon, 20 Jul 2020 15:01:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200716090403.13507-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0902CA0021.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::31) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0902CA0021.eurprd09.prod.outlook.com (2603:10a6:200:9b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Mon, 20 Jul 2020 12:02:00 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a7c8934-27ff-4c7a-0023-08d82ca4b5f2
X-MS-TrafficTypeDiagnostic: VI1PR04MB2974:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB297444BA56A2F7479AEA2603987B0@VI1PR04MB2974.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:154;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5Cvv4E4MYm1ud947Huy/i/AVGrzf8kiplcHBftiXxLheh1r4d8A1T5Yw3yq1zyIl31Br4iWgADEqX2k7JT+HH1gYvpV4zApiECPq3WUypsqfMwTBEY8w8i+8qTGBuJsG/+gUsYp7Go4zJkimi2Xd1WJbEfmTBhpaTAmUr3do3IoA3+wUUR6ZjVeoGkfWZXd7b6bGlxvRkkr7SZqnFzRFGxURJV8z59WygB49ZoEaVKbB2GZwUsR6pV+qv7NgdGCUT3M3RSu+fuj4en6oi868ajjl+sXkHjmxawGvMEjejPa0bBltWtK7/fndKy0KC6YG4m9cPKN7VvEYTJS7UAiqCDTF/Zf/9Aj89QEIZoekeFh2dTbUhFXFbBwF8swN3YT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(52116002)(31686004)(16576012)(316002)(956004)(2616005)(26005)(6486002)(66946007)(54906003)(5660300002)(110136005)(36756003)(8936002)(16526019)(186003)(6636002)(53546011)(8676002)(4326008)(66556008)(31696002)(66476007)(2906002)(4744005)(86362001)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eLy9NwnDkc/IUqzNGKlTfDrHrWaVg3lsrFJEQhInOok4nmuEdg2RIqkBuLku3MDlwFLIDPU7q7Srnes67c1q+OiP6PmtUTmfMgy1VwuXkjG8+R9yeUI/zAiymG0bMHu+8Zxh0t0+8fPFJPFpdJQN78pRX2ogweRw9sej4PbaJHLq2ZBEXBq73tHM5BOMg4g4FGNawqY+UqPP1QAnxZyi2pYRZC0cKnJT0Z7UzTNmY+CSzMQxM88CigDc2nJrzbGQkF/lGEuxTOUx5BKhc82An38aAMGlhisUm3B8ieDrVZJgHY7tFuELnJcmIRnFbv5knugDW/UkaMB3q4h3H0HxK/bnZo3q9dDrxz+Bmztj25tAoh8LmUVgyns48hpiO06AnbMhVhKALmUCS5fjhAd4ug8/X7kk6+7nb0/O7qBgLXBLoL3d5KQzN2DVfupsgDClZSY6vqLCVEZ5np12aEHWEytiDEQyB/CDfQIOIl1H1qoeEN12Ks+q4UrbmuZJIHdB
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7c8934-27ff-4c7a-0023-08d82ca4b5f2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2020 12:02:01.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7itZkNXO22hkRHjTQpmEpZ3tK9jCyNiSpGLpYw9OIGHONk+ECgdU1zdo8ugT9vA4ZkjHsXYdFaoZmZv5dF+JIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2974
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/16/2020 12:00 PM, Qinglang Miao wrote:
> From: Liu Shixin <liushixin2@huawei.com>
> 
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

This patch depends on linux-next
commit 4d4901c6d748 ("seq_file: switch over direct seq_read method calls to seq_read_iter")

Horia
