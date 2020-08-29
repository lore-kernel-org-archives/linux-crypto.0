Return-Path: <SRS0=VKkI=CH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A09DC433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Aug 2020 12:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ECC720776
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Aug 2020 12:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgH2M0F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Aug 2020 08:26:05 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46786 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbgH2M0B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Aug 2020 08:26:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4BC36205DB;
        Sat, 29 Aug 2020 14:25:58 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2kjml7kb9nq9; Sat, 29 Aug 2020 14:25:57 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E0377205B4;
        Sat, 29 Aug 2020 14:25:57 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sat, 29 Aug 2020 14:25:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 29 Aug
 2020 14:25:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 42D9031812CF;
 Sat, 29 Aug 2020 14:25:57 +0200 (CEST)
Date:   Sat, 29 Aug 2020 14:25:57 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] padata: add another maintainer and another list
Message-ID: <20200829122557.GS13121@gauss3.secunet.de>
References: <20200828015944.tk45hzuyzkabbrs3@ca-dmjordan1.us.oracle.com>
 <20200828015328.86800-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200828015328.86800-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 09:53:28PM -0400, Daniel Jordan wrote:
> At Steffen's request, I'll help maintain padata for the foreseeable
> future.
> 
> While at it, let's have patches go to lkml too since the code is now
> used outside of crypto.
> 
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>

Great, thanks a lot Daniel!

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
