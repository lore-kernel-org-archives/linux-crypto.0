Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6897EC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 11:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D159206E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 11:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lElr+hUK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgFDLE6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 07:04:58 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:42213
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726456AbgFDLE6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 07:04:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+0B7BVR/w9lD8bn2nrvhb+0jxtO+e6EdrUU+mDLfB+UZhMWzhBxqJ9iGHJ+ka6+uAg5XG2HqoyxrzZBZfiLG6lKQ2Ctfy10j25OrlZQ9PYStnYvsg9PyzO1CYNJOu6RL3hfJEn2PGPw6+vLnlQYL3MroRPJdx/gvQR2VH2vN6Gxqx6HMM3a/TkX0hZKwl4pgqDFUBq/O+7mshJnwD51ke2ZZQbD66vGMmDhEZ/cU9K7WkJjTj56yC6CDlirgU6skgRsbscRMblZiBjQjyF0O/5vGcUJFIJYk8iSSpvJaJdSm8fyJoud9qQCfml6ErKaKwjoDzHZWyC4KqlmHBRoqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbHFphvGpFkW1Q72a0vJZ+aeJaS7vYw67pQlTIR4Kv0=;
 b=l08ZEfdAbTRVqUJQljIBE5tCU66pcNOfwqnX6gU1ysT7AqQKfJcmj6cFRiy7dyqF730zF9LXiIREzao/dxkpOANFseZG/XMh9Kq0ijMuKBtBDdcpakhf6KLWlCuVd2A6ozA9AXQq8riiVP7z1Vh2t0VUtfgDRhWshv2TRTHPC64b5jzYLmwcmaMRCP3V0G+fLTwxDYPpAnugAZgf2psIoT1d/8bI3n0AVNkbp0l9mbGjiiiaJGCOXanIme7XSVnCPfuHoWMqSyfoDnAIHQ5mPZMKuJc5agrrt6zMf7oCk/3iSezD4PNV9PujK4D76du1Zw2/GLeeI+aXOZkjN5ytzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbHFphvGpFkW1Q72a0vJZ+aeJaS7vYw67pQlTIR4Kv0=;
 b=lElr+hUK8upzru0st8xknAouz0ccUK93hOKE0VxSIEDOwLBM30l+38gou/YGQekP/3ZobzdVK6O+qvDYAgW1sSH41aXkJJDalP4b36RgFlV+DZr4/YnfqwOH5n5v9HodMzlObWWpXspF3CIz7afGDKzX73TFDd9vz/KqHqrsm9o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB3166.eurprd04.prod.outlook.com (2603:10a6:802:d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Thu, 4 Jun
 2020 11:04:52 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3066.018; Thu, 4 Jun 2020
 11:04:52 +0000
Subject: Re: [PATCH v2 1/1] crypto: caam - fix typos
To:     Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200604103947.11276-1-xypron.glpk@gmx.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <ed2db29d-e02b-218d-adc0-bee3b170e12d@nxp.com>
Date:   Thu, 4 Jun 2020 14:04:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200604103947.11276-1-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0080.eurprd07.prod.outlook.com
 (2603:10a6:207:6::14) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR07CA0080.eurprd07.prod.outlook.com (2603:10a6:207:6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.7 via Frontend Transport; Thu, 4 Jun 2020 11:04:51 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b79d722-120f-41c1-fd7a-08d808771b17
X-MS-TrafficTypeDiagnostic: VI1PR04MB3166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3166B5F9174EDDD3130A0FB298890@VI1PR04MB3166.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-Forefront-PRVS: 04244E0DC5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BtPUdh2xiJ+W8rMyJfLEhLEpzB5bncsReWlSa2udy0T4JzRpMNjEmyE80GrSkCF44LYXgb7TBTmPOa/0fEqkDeMTihyUI+Dbx5LRmS5/cpfssOxmUEuy3OI6/CE0YkfZTXzXvNIfQ3G9ruYbzXB7nZGyghCcpPmodu5Nk0SrTTvK5upRpPft+eNyLfacGl+Pq7Nhu6SDocvjWB5psn++y7RzdnMZKagGDR2dmUTYw3naotRqLzXSleZyX3CJnk6vUFAbI3z9uqxFA7OjMmurDCJtV7KTjqUIMtQXWkiUpikHNoiurYxvATIyzckv6E74snWMPfhkxMDzRR8AMVTN/4RxAkAcEIg7MtvaTkbDi64jiX/9i3Hw+cs9gdezI9AI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(53546011)(54906003)(956004)(6486002)(31696002)(4326008)(36756003)(26005)(86362001)(558084003)(8676002)(6916009)(66556008)(316002)(8936002)(2906002)(31686004)(66476007)(16526019)(5660300002)(52116002)(16576012)(478600001)(66946007)(186003)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3zpS3zssUZCOjZ3M+6EhwoifU5iX06tyaH63i2DbRXkW102uQpTg83u1Uo8eIx4JCcisHL/egS/2quRLW1jyE7LuvQBxJ7djOAcrLq2Vw5x4obwiX3+Y6o6tpwtF6ws1nlm4Ldo+8dRLtfMzv431fQ7YBS1DM5GRdBuDFhVcZp0WwXjsFFR3PKxS/eIKwgV1rFrgsNvpru0+5WSGeauYGrGIjhgGHh4suzVHiQj7YDpTEo+VSgxOMDkIsCgE6FhcTpt8NXjU5PsXvG+++R61hkMnolTCAS+RdiBFj9IRDl2QTOurje11pD6ZlnieGJYTVkmZSq0TKwfxUkAJawkSsZLTGUtvNWtfetPzIFatEo/m9hJTSZHtM1yKw3PtgvDXq/DNvG4spVWz9fbinEiQz+TciFcN7HZqFD4eR1FH7Cy2mZZXKKUeled9BnjJTSQ75x12CE8NPEcpAc1WO3sp3Bfptsbq+iEuwU58WfXzWhsGR4MJaudFg+tZ8hnz5L5K
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b79d722-120f-41c1-fd7a-08d808771b17
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2020 11:04:52.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIEWE4ymHGVNjjUeXnhvIOcPnFlvFrqBSxva8y88aU1yus1vOP64xETm1FQ9kXVU6anSQ13UTvXqUhtAGKJ/Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3166
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/4/2020 1:40 PM, Heinrich Schuchardt wrote:
> Fix CAAM related typos.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
