Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF2DC04A94
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Aug 2023 09:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjHJJfz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Aug 2023 05:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbjHJJfy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2023 05:35:54 -0400
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9862129
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 02:35:46 -0700 (PDT)
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.22/8.17.1.22) with ESMTP id 37A7sSNr008184;
        Thu, 10 Aug 2023 11:35:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=
        selector1; bh=zGTx/TPYvNkGvWVgmB1ZlY4LSYz/JQyApXK4ovlxMGU=; b=Tv
        BqwBEIGCeYndObMm1vFfuQakqEwlAE6ymXG8v9JDStGQ5f1tUPQ1ADWXtnWJfA9m
        mHCrufTvq8yXEQKGCWoOBnJ3xfQZLHHOU6wNulOwu7NBlsXkTwpMFT8IhRxQAMTc
        v1hO9Ekd48hOsbVyP47GbTgWVwoRelIbUXyMm+W53Ia+/c/nedemQ94CGCVY/RTE
        NhG60yfJOEyAwpC50hr0HmeVVebrmdsMR35xSiRt9OS9SCEXSp1upd3tmTYqm6PI
        KglTUkrfWWkcjnycGiqfCnkwg0ZlyJlm5in0XZWEPSITwxZbZjF23567LB2iubP2
        v9/qw8MxwWbt9dRHCLYw==
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3scdv7n0bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:35:25 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 558CC100053;
        Thu, 10 Aug 2023 11:35:22 +0200 (CEST)
Received: from Webmail-eu.st.com (eqndag1node6.st.com [10.75.129.135])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 13F552138D5;
        Thu, 10 Aug 2023 11:35:22 +0200 (CEST)
Received: from [10.201.21.98] (10.201.21.98) by EQNDAG1NODE6.st.com
 (10.75.129.135) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 10 Aug
 2023 11:35:21 +0200
Message-ID: <78eedd86-bc3b-9e0a-96b2-a16018aa0c62@foss.st.com>
Date:   Thu, 10 Aug 2023 11:35:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 1/3] crypto: stm32/hash - Properly handle pm_runtime_get
 failing
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        <kernel@pengutronix.de>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
References: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
 <20230731165456.799784-2-u.kleine-koenig@pengutronix.de>
 <f9ddac2f-28c0-1804-a1de-b8c8e9972638@foss.st.com>
 <20230809105820.5yp3jzv4spe47qb4@pengutronix.de>
From:   Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
In-Reply-To: <20230809105820.5yp3jzv4spe47qb4@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.21.98]
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To EQNDAG1NODE6.st.com
 (10.75.129.135)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_09,2023-08-09_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

On 8/9/23 12:58, Uwe Kleine-König wrote:
> I usually let maintainers decide if they want this Cc line and in
> practise the Fixes: line seems to be enough for the stable team to pick
> up a commit for backporting.

Ok, I thought this was required to apply the patch correctly on previous 
stable releases. (Someone asked me to do it on one of my previous patch)

> If your mail means I should resend the patch just to add the Cc: line,
> please tell me again. Should I resent patches 2 and 3 then, too?

No, patch 3 will break the driver on previous version because remove_new
does not exist.
I don't think it's mandatory for patch 2, it's an optimisation it does 
not fix something broken. The driver works as intended with the 
condition so no need to remove it.

Thomas

