Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F95E810DA
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Sep 2023 13:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjI0N0R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Sep 2023 09:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjI0N0L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Sep 2023 09:26:11 -0400
Received: from wxsgout04.xfusion.com (wxsgout03.xfusion.com [36.139.52.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BBA10A;
        Wed, 27 Sep 2023 06:26:08 -0700 (PDT)
Received: from wuxshcsitd00600.xfusion.com (unknown [10.32.133.213])
        by wxsgout04.xfusion.com (SkyGuard) with ESMTPS id 4Rwcky6sGqzB0JRS;
        Wed, 27 Sep 2023 21:23:54 +0800 (CST)
Received: from localhost (10.82.147.3) by wuxshcsitd00600.xfusion.com
 (10.32.133.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 27 Sep
 2023 21:25:55 +0800
Date:   Wed, 27 Sep 2023 21:25:54 +0800
From:   Wang Jinchao <wangjinchao@xfusion.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <stone.xulei@xfusion.com>
Subject: Issue: Can padata avoid dealing with CPU-related operations?
Message-ID: <ZRQtYnAhF2byr784@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.82.147.3]
X-ClientProxiedBy: wuxshcsitd00601.xfusion.com (10.32.135.241) To
 wuxshcsitd00600.xfusion.com (10.32.133.213)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello, I have a few questions about the padata code I've been studying recently:

- Why does padata use the WQ_UNBOUND attribute of the workqueue? Because I've noticed a significant maintenance cost related to CPUs. Are there any specific benefits?

- In what scenarios is it necessary to specify a CPU for serial execution, or is ensuring the order sufficient?

In fact, the two questions can be summarized into one: Is it possible to avoid handling CPU-related operations to simplify the code logic?

Thanks.
