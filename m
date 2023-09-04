Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798FEC71153
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Sep 2023 05:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349072AbjIDFkd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Sep 2023 01:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjIDFkc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Sep 2023 01:40:32 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F82B6
        for <linux-crypto@vger.kernel.org>; Sun,  3 Sep 2023 22:40:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2742E204B4;
        Mon,  4 Sep 2023 07:40:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wEgNc1B9oJb9; Mon,  4 Sep 2023 07:40:26 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8F11B201D5;
        Mon,  4 Sep 2023 07:40:26 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 8687F80004A;
        Mon,  4 Sep 2023 07:40:26 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 4 Sep 2023 07:40:26 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 4 Sep
 2023 07:40:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CCA663182A93; Mon,  4 Sep 2023 07:40:25 +0200 (CEST)
Date:   Mon, 4 Sep 2023 07:40:25 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Lu Jialin <lujialin4@huawei.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: Fix hungtask for PADATA_RESET
Message-ID: <ZPVtyXevpj4Fiduw@gauss3.secunet.de>
References: <20230823073047.1515137-1-lujialin4@huawei.com>
 <ZOXRNntcDBuuJ2yg@gondor.apana.org.au>
 <c9b91a0c-5663-c351-3d4b-ad4ff74965f2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c9b91a0c-5663-c351-3d4b-ad4ff74965f2@huawei.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 01, 2023 at 10:28:08AM +0800, Guozihua (Scott) wrote:
> On 2023/8/23 17:28, Herbert Xu wrote:
> > On Wed, Aug 23, 2023 at 07:30:47AM +0000, Lu Jialin wrote:
> >>
> >> In order to resolve the problem, we retry at most 5 times when
> >> padata_do_parallel return -EBUSY. For more than 5 times, we replace the
> >> return err -EBUSY with -EAGAIN, which means parallel_data is changing, and
> >> the caller should call it again.
> > 
> > Steffen, should we retry this at all? Or should it just fail as it
> > did before?
> > 
> > Thanks,
> 
> It should be fine if we don't retry and just fail with -EAGAIN and let
> caller handles it. It should not break the meaning of the error code.

Just failing without a retry should be ok.
