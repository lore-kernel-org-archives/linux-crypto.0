Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6B0C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 09:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD196205CB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 09:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="abDYLO2X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgFCJfs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:35:48 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:45688
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbgFCJfs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 05:35:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCf1aGd7q5DdNiyQAdesHmiKFoEQnNf+jiiiTqvWTbsseFOVJq5L0qgGLjw3PK428UTNdKO4VRjNaHRVH3e5YR9rA1mX92ZWd+wNybsUrzZ/pD3k34gLIvxNZcN69NnZRm6AGzXdXVhvrVRYatlTSPMuQTSlsM4gk2gYRSytZu0pQQkNVtIc2zYqPOa2SrmttJzkUwaenEq47TQdibDHIPO8/Ckr2+a+GW7WorAS2QagaEvroerp6BFlw/3r68SXLyPNGCVHKhJA8m4wfQREegKYDUKWFU5WgHF8MIqP7ocA5wmHq4Mkd9mp29fjlXmwWgdjwQ1sb3MIgtCrKGu7rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bF2cGYEiw57DjTJG4k4WBraDParV5iPqlNSFppnyJyo=;
 b=jfZrT2u1eMZWYIC/8H37jp9qT/eVvBq0gOMJg69BRqZl5DCN5fXBuaHNtFRDZFiGmsaG1GsQsXp4sDM2yATCDYOu57Vs1DV1vKaBuxnwvzeh0RoPfx2jsMJMA7fl3Nubqu13d7aHMtp8f4Yb37Ar/JdS51IvFdBNuPKlRlZFKJ0MdY32CwlV+9X9s4frQl5kRWHYOzgKqBxbyeDP0Z4kRnKkTbenT6Ppzz0T4SH6IUvxX9ufECfNoDh8z5ymHHQcXwadIDfmK2b++aC/xL7txBqtoWezHBlkD5gSgvgH1tUCLd9ET9F20q6bjkyOpjQk7x5ZKh5HT/cFU6ABsLJwtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bF2cGYEiw57DjTJG4k4WBraDParV5iPqlNSFppnyJyo=;
 b=abDYLO2X/l9UQhk2iQcEsAhMvUsv9CY29JVEQb7Pnv+bUZRmfqvcz5qF6BfHIL78VxGcradMU5R5Tjw3oRcNICf7Tu86AI0K/N45DX80D4ZDY+JlIgxkBWzcAzF6xLe5uFjMhTWVe+aSsCHgNvc7wv7QkoOqwUllgHuRhsOKnj0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5022.eurprd04.prod.outlook.com (2603:10a6:803:5f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Wed, 3 Jun
 2020 09:35:43 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3066.018; Wed, 3 Jun 2020
 09:35:43 +0000
Subject: Re: [PATCH v2] crypto: caam/qi2 - add support for dpseci_reset()
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200603084704.5895-1-andrei.botila@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <40d8e2e6-a7c9-0132-3139-1a07a2024c18@nxp.com>
Date:   Wed, 3 Jun 2020 12:35:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200603084704.5895-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0060.eurprd03.prod.outlook.com (2603:10a6:208::37)
 To VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR03CA0060.eurprd03.prod.outlook.com (2603:10a6:208::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 09:35:42 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9721aa2b-a382-4517-c771-08d807a17ca3
X-MS-TrafficTypeDiagnostic: VI1PR04MB5022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5022A9576CDF41AA3B15047498880@VI1PR04MB5022.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPcaknMVSKimGv4sRJt2EcN4/abAi2I9S35wNn0IVUvqGLif/y+qH+q6qsbHVf919cpwrMOt+ocDX8fQsmE8iP7ddCfURVDIRWKDDFxGjvQYXnqb4Xj73CpBbpCkHvGzPEv96c3lDp1BAkUy5opZjLjPAmJ5GvQXqd4oP0IR+ZtrLIuwwuxx1n2J/YY0EqPMkR4D86VMD3oQshSWcBNcDFJ0k4y3s0JhRNn4FhcTMudOQcGMPZ9XyGwqYIofJ4ki1IIDxgv1PraXCG+leTmUS1SdbamYvK59Ik2KsvVFRO6naGGKIH+aMPLqaGoO6ZQQSkLcMrxPvtn9PW840a2Cw/sSzYIh193Np4Ja6EQGg6Kd/z0BAME1NCpIlV+wvBz4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(54906003)(31696002)(316002)(5660300002)(8676002)(110136005)(2906002)(66556008)(66476007)(6486002)(16576012)(36756003)(86362001)(8936002)(66946007)(956004)(2616005)(4744005)(16526019)(53546011)(31686004)(186003)(4326008)(52116002)(26005)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x8ts5ZYYKjrlZ+ruNFe345MqGBdiYbtZdUzM06skMNl1pepG4G3sfZ4pKhrYBVMpaE5m2ezP3NTAc3uXhD0uu8BAKGAdHmSjL/WtOSizueIymycT6/G+hrkZzhifzLWtFLi7XmX+6SlHiQ2iTxP2QjYksm0uWuKXgF1RgucDRXeX7Xsk1Rbs0gN0JrMSrtXle1ktkvZ/6MwbFWiWXSdt8VsurvndIkRn12uLQm505dNr7RCMh6ENdY/fCZy9SqlorYP9ieKB9b4ylsibVlSpQkZXaUZ2S1PYGHb1uLi1yApcA0vyL0VZGeBDOz8aDuBt6IyYQ3ZeEv3Ep3cCCBe/VfWdsrXsKf0Tq8zQEFmR36e3iyrKCKMjV8SMBWO/Ves2FudnI88noMqTHvXE7h+W8aKxzjiHWibyrxLdvAr5WznpOrIoxSIPU1JCm+nK3iKI9AlihYp5fi9SHauui8uLL1UscLEgAQ0Uj77uToL9AExBP60lN3bboJGpn/4x632I
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9721aa2b-a382-4517-c771-08d807a17ca3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 09:35:43.6811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0s7PaujA9HmmANZFRCJGHCkRbahuTW2DAU1J2lWUEEjY32ZU6r0Z5YmRr1N6+MKvKTxUCRsBCV3ZujJJItOWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5022
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/3/2020 11:47 AM, Andrei Botila (OSS) wrote:
> From: Andrei Botila <andrei.botila@nxp.com>
> 
> Add support for dpseci_reset() command for DPSECI objects.
> For DPSECI DPAA2 objects with version lower than v5.4 reset command
> was broken in MC f/w.
> 
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
