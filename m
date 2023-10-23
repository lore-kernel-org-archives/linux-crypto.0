Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103D2CDB474
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Oct 2023 07:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbjJWHgv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Oct 2023 03:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjJWHgu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2023 03:36:50 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70257D66
        for <linux-crypto@vger.kernel.org>; Mon, 23 Oct 2023 00:36:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJqkBayP9aAKjejq6Vt6Bc3XAE+qtHiDD89hJf6QawaOYMPrMtt9FpceR+6da8hrfZmV1fBh3DKR2nEXbfhRYy8DL5u5tX/AGzKFLhU4iK/d6+t8rA8WXQ0KviA9q7JmCtyUlZXI2fufyclKgF2LGeYf377n7DRuojWtgO1eSB1H5oE4FbA18RTogx4gmeKx2jXbfo/9lnKNc69mK39L1pk5FeNotphUr9nfyCoi89ynGrg5BGumsMqwvNBzEnR2mV0dpACAVijarxhsNpUR7An8fxsQlqMjujlnW2AuEM457REShrCjgTJyWoJrIkY57eu0keo58jM1BI5m9tDh0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lkrej/oypd/lZUZmboU1toHAnSv6bOwuwY0MIP0mJLw=;
 b=Dd6VrRm7sUi7/VclVdeLPgB0jXzFmdvuO1AEdG0w6clXWDwV3n8cdD4Xe0Bb6twP4KgIXLMKXnTIoz3O9EDwQGAlQ0dK/zVpDmR5LiIDnx7b8Y4M4oT3dHeFsNsJQ1ViQYGXFXHhHv67xON+r/4zqxNFnR7Kj07NV1FaP9CRjSW171XkXy17DI69g19m748ukFk2V8IuDR2M546OJNN+PrpvuEY6ta/W9BQzcsgnQ0//eqihifp1Ly2ClAXSVphGaj7jIad4TugCLS+d8iYIm7s6Rz/m0gJ3kGg9eeB2LpZnavuxm8W5QR67dXLWcwsrq6M6lnXwDPqj9qb35oDQOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 195.60.68.100) smtp.rcpttodomain=davemloft.net smtp.mailfrom=axis.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=axis.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lkrej/oypd/lZUZmboU1toHAnSv6bOwuwY0MIP0mJLw=;
 b=aKJXWXvCKVEm1dOLdJ9ETYbKgmbFzFr/NKky+9FkwZFvuSMaruOgGrwZZwO10OqVV6LhhNQs/7AkkPul7QBU7JAN2pDBNMQvcX3AWyTKRyLBQyliV/zKG2W4PfKXxJGJrR7XO9piWaUJpK/n06YQfr9Q5Fl5YQQvsKJD1UUKU0A=
Received: from AM0PR04CA0029.eurprd04.prod.outlook.com (2603:10a6:208:122::42)
 by PAWPR02MB10091.eurprd02.prod.outlook.com (2603:10a6:102:35b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 07:36:45 +0000
Received: from AM4PEPF00027A63.eurprd04.prod.outlook.com
 (2603:10a6:208:122:cafe::11) by AM0PR04CA0029.outlook.office365.com
 (2603:10a6:208:122::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33 via Frontend
 Transport; Mon, 23 Oct 2023 07:36:45 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 195.60.68.100)
 smtp.mailfrom=axis.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=axis.com;
Received-SPF: Fail (protection.outlook.com: domain of axis.com does not
 designate 195.60.68.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=195.60.68.100; helo=mail.axis.com;
Received: from mail.axis.com (195.60.68.100) by
 AM4PEPF00027A63.mail.protection.outlook.com (10.167.16.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Mon, 23 Oct 2023 07:36:44 +0000
Received: from SE-MAILARCH01W.axis.com (10.20.40.15) by se-mail01w.axis.com
 (10.20.40.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Oct
 2023 09:36:44 +0200
Received: from se-mail01w.axis.com (10.20.40.7) by SE-MAILARCH01W.axis.com
 (10.20.40.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Oct
 2023 09:36:44 +0200
Received: from se-intmail01x.se.axis.com (10.0.5.60) by se-mail01w.axis.com
 (10.20.40.7) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 23 Oct 2023 09:36:44 +0200
Received: from pc36611-1939.se.axis.com (pc36611-1939.se.axis.com [10.88.125.175])
        by se-intmail01x.se.axis.com (Postfix) with ESMTP id 4AB83F8D;
        Mon, 23 Oct 2023 09:36:44 +0200 (CEST)
Received: by pc36611-1939.se.axis.com (Postfix, from userid 363)
        id 457AA6291A; Mon, 23 Oct 2023 09:36:44 +0200 (CEST)
Date:   Mon, 23 Oct 2023 09:36:44 +0200
From:   Jesper Nilsson <jesper.nilsson@axis.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        <linux-arm-kernel@axis.com>, <linux-crypto@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH 11/42] crypto: axis/artpec6 - Convert to platform remove
 callback returning void
Message-ID: <20231023073644.GB11306@axis.com>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-55-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-55-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM4PEPF00027A63:EE_|PAWPR02MB10091:EE_
X-MS-Office365-Filtering-Correlation-Id: cbe3e421-baf7-41e2-f540-08dbd39acea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXNGmJrkYn1v3gWsQSR/2TYJTi62RcIFFztJ8QlFX6TQrr9JzsckOY7V2BbWiDgsuhOjwdJ9F7BP4QTh4RUAwqff90E80r4pG/IzJqQXZFH2Z235X5QhX1rH0OE1TN17xlz8LiOxKb8SpdQ1z2VKvP0KRpuqouqnK7oVtvDgWkIg6jdvV6TjObvdyjKaeqNxJBd5pJaUeEqABrGZFTdAxt3UUMcUI0dYaLcoMAp0bkWJIEomP9cYlxwg6OAvdBwaWfvWjyHfEpe6Sjy2+4GvZnRj54GcnNGXYYgCGl5sJ2/HGekS6VgAg6eb6Pkp3Ucor1/sICr3Ry45ZYW1k/UMQLPJG/aVaIciwS4RCrvqBMHlv/XjHOGXd1zL6Odoc4S07+NIoCyGbaBIIkQI0zTiO90xYFX+YXEv+Mq4Qy+cvsma3yqB1A3L4zai5fICeFGE1pnKcpBbXjxgSvNyJ28lr8vC/9MeqPizQMjRgOd+LmOL6OlsXnACBYe1vE5JMl6n1T8YgRUPRODajAu/SWpZdAYb2Oz43SH4RCgJ/yN2WijJor5qR19LInm0vmRIVb/JIY4UGd0b5eRYTfFUorCQVqepbTd8LWDyxw39dB6R1msKp+tvOCrw8rW9EyFGgPfGUuwe0pMPbYmH2tfqazYcc/YokVV3uxd1M+VROuuHCjyMl2hOfljg05aPXpaTGXnUBTw8XVxadqWxyp5ezMv0EXp4N06owMAV0aEdNWTFFSNobHLK+U1QR0gIvIMqN3x31hJSfoY03wZFLDhOAtEXgA==
X-Forefront-Antispam-Report: CIP:195.60.68.100;CTRY:SE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.axis.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(64100799003)(82310400011)(1800799009)(186009)(451199024)(36840700001)(40470700004)(46966006)(83380400001)(40460700003)(36860700001)(2906002)(4744005)(8936002)(4326008)(33656002)(36756003)(8676002)(44832011)(66574015)(82740400003)(47076005)(81166007)(356005)(26005)(1076003)(6266002)(336012)(426003)(2616005)(40480700001)(316002)(6916009)(5660300002)(478600001)(86362001)(42186006)(41300700001)(70586007)(70206006)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 07:36:44.7798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe3e421-baf7-41e2-f540-08dbd39acea2
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=78703d3c-b907-432f-b066-88f7af9ca3af;Ip=[195.60.68.100];Helo=[mail.axis.com]
X-MS-Exchange-CrossTenant-AuthSource: AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR02MB10091
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 20, 2023 at 09:55:33AM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
