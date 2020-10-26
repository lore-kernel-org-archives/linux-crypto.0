Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC7FC4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 21:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40EEB20795
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 21:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="cRWjN6UD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbgJZVTk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:19:40 -0400
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:44612
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730452AbgJZVTk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 17:19:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6t6n0N4jT+PfceGTinvqMz2rDB2+dDxgAMU1al1VkjBNNktUEt9CGx8InpDGSOUtk68S+5FiqtnNg0lcsJk3mATb1JSkDjgCuRqCW4FQ8rad1T2Ln1wGHbW7btQRmLd1PNXZY9fEjg27HswatoDI62fASYX56cE+6715I85x4rlCtWvt59jqMX9JEs1BxVUAYev8hl6uaofxIdUhWEo19BftGTpIKNXbnXw0V21tT9wLc79J4nL2Nth7WhbWjQ5VimaSSg7dZO0ufNczpIA/V11gB2dH/DAilHlr8lWcuHak6STNdQixjJ4ZfoDHeF9s9DvClwdM5T/uQhkkx1LFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGqKrVAPOXGxIIfTV7iXhgUoZS952Vt3kBOXFD7d+A8=;
 b=fOgCDyJx5AI8sDqmV1nwnyxkuN1UML2qPp7zrjfJUWKGMSNSJpkDVaGkzedD2P9Csy3sIBFMyaNSlXBnqo2uNnBXAD2BGXMZHrY/EXfTu7lUp9MaDoFPMgudTIhR/9NYROmIJ33wFc0swJ9DiDJHK0YNfopmKsPI+5Bz165nOdzSgphzCCF/TZl52o2peF8JOX485DqYb/AsjrJjXVIvvVIjIlDRo17tmt+1qVdBEsVjz2BxCB/B8IkM9/6STgRytJuYfdC57bz5+1x/kMSTTulqyM+Lq8JNH6KVAZgscRFJzqs/iCfO1PCyfM4vSsFrybMVJLPTIbT74qeZ2MPC3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGqKrVAPOXGxIIfTV7iXhgUoZS952Vt3kBOXFD7d+A8=;
 b=cRWjN6UDcIQuDze19mDqHpltf3r3rT1RPandRmL377G+XfzUiPY5sOMEwMm4rLZ0JrOAXk22aCjHOJQynQoM3ZPz1b7wRva8rI8Y81InmW3QPPxS2nSZacKjtYD1SFW728TZrKew212S+J4aqcQuGRBsSLNu5ty3AEzWrDKiUls=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6989.eurprd04.prod.outlook.com (2603:10a6:803:131::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 21:19:35 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 21:19:35 +0000
Subject: Re: [PATCH v2] crypto: caam - enable crypto-engine retry mechanism
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Dragos Rosioru <dragos.rosioru@nxp.com>
References: <1603739186-4007-1-git-send-email-iuliana.prodan@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <76c8f7f6-017b-0b27-0279-a7a4542b526d@nxp.com>
Date:   Mon, 26 Oct 2020 23:19:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <1603739186-4007-1-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM3PR07CA0058.eurprd07.prod.outlook.com
 (2603:10a6:207:4::16) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM3PR07CA0058.eurprd07.prod.outlook.com (2603:10a6:207:4::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.13 via Frontend Transport; Mon, 26 Oct 2020 21:19:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e71cbc57-eac4-4322-631d-08d879f4d675
X-MS-TrafficTypeDiagnostic: VI1PR04MB6989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6989F449FB577F913FC813D898190@VI1PR04MB6989.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iOSpj7kIftNtSyGrW/pGcZCX/FKslSekBFBTyedDOPwG0Anmsm3/B7yGIphpvPelB9N9/o41n355WeqldpMwfbMEQ42JeJBF2RAU/V5LPZbM8sCGjhw9G783ilVysK9DMwxCeFRLKU2FtRSw975+o4wL0QAnH8rTlmg55uwp5VaqF3D/h6cevRorrI0TdkpXmK7aj63Yvl6yaY+6SgKdZmjmNFaVWGgnVFNzkK0ISTQH/y/SJ30ZHt90vHaBXWhrGxKXVuMSo3dIjbTQQwNpsrYJA0HnUuVUnxxTBc3zuSHcqz/axgVT3KSefhFIs9Iwz6DW1UiDyV4oCOL70OcD4axdaha143iVy7j9f5i0Fl9fNfwdifIkTjzdX3dPxhQ4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(346002)(366004)(956004)(31686004)(478600001)(2616005)(2906002)(8936002)(83380400001)(6486002)(8676002)(5660300002)(36756003)(4326008)(66946007)(16526019)(54906003)(4744005)(86362001)(26005)(66556008)(66476007)(186003)(316002)(16576012)(53546011)(31696002)(6636002)(52116002)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pDY9fqml1dtj52R9lhGnSLuqRunKpRi7/IkQV1+ENU4y3972YewThkkOwHBD+awwu2bT1g03q3SX88xd6BSwvMtY590LK0IxFDIhPAyN0rZJ30TwgQR+qkdYgS7S2lUQrf5ezqTmNpzqsbZmQDAk9WJ4dTpg1rIm7eHLicsaANeVl4okb1dRXAWOFgyu3tUIf085U6vlq2syoND23tw6t8RZqPo/+xz7VhL+GUeklWPqQZIBQBOxlhB5ClOf/JNfHsw4/uiflcZypy7vRLXTPUhQmLPQZyuXwEMrSXvkylk76fQvhbeSlw3IkMt6qtQAkrcvEEfEY9ww01yMMU/sx9MJ47sg4FzbF3FyBQTbG5fCQC70KcmkhZjNwttrVkaIX3pU/4/KFDZG8/VQrASaH1AlvHp0OiOB6FXaF1RRn/OVJyFuA44CfUUmONANlsNzG9n66YFUISwygfdd0qBz433hDa6Hh5zM0BClOCv2dp+YxY1soYkZCJWEGbB63VivyiTunOAtY5sKbtSMbV+hQM+tgWNwxaSSt0Y3AB3m1K2sWPLqSAlNJZulg6hErfEBJhh9irogPRnhWMjchnorSIMdhgTGyRSx0lgS2sYOz95g8XpEEIWrDWzLPEyrM0o+PaQDfhYPUQdEEKnDe2plIw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71cbc57-eac4-4322-631d-08d879f4d675
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 21:19:35.1942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HNZS06lq5WkZvD6iHqszOSmZhmUdYrQ6CiWN1Pq8qr2HrCzzsztXWNrZ6bzQ+HZl5CENrG5gbQhCWWFMfgT2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6989
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/26/2020 9:06 PM, Iuliana Prodan wrote:
> Use the new crypto_engine_alloc_init_and_set() function to
> initialize crypto-engine and enable retry mechanism.
> 
> Set the maximum size for crypto-engine software queue based on
> Job Ring size (JOBR_DEPTH) and a threshold (reserved for the
> non-crypto-API requests that are not passed through crypto-engine).
> 
> The callback for do_batch_requests is NULL, since CAAM
> doesn't support linked requests.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
