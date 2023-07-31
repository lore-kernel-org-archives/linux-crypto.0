Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A04EEB64DD
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jul 2023 03:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjGaDTo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jul 2023 23:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjGaDTo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jul 2023 23:19:44 -0400
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C1A127
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2023 20:19:42 -0700 (PDT)
X-ASG-Debug-ID: 1690773578-086e23186902950001-Xm9f1P
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx1.zhaoxin.com with ESMTP id bCoJ4vjXW14X1l7e (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 31 Jul 2023 11:19:38 +0800 (CST)
X-Barracuda-Envelope-From: LeoLiu-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXBJMBX03.zhaoxin.com (10.29.252.7) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Mon, 31 Jul
 2023 11:19:38 +0800
Received: from [192.168.111.204] (125.76.214.122) by ZXBJMBX03.zhaoxin.com
 (10.29.252.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Mon, 31 Jul
 2023 11:19:36 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Message-ID: <e8140373-9249-e2cb-9767-8459f90245ee@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 192.168.111.204
Date:   Mon, 31 Jul 2023 11:19:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: add Zhaoxin HW RNG driver
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] hwrng: add Zhaoxin HW RNG driver
CC:     <olivia@selenic.com>, <herbert@gondor.apana.org.au>,
        <jiajie.ho@starfivetech.com>, <conor.dooley@microchip.com>,
        <martin@kaiser.cx>, <mmyangfl@gmail.com>,
        <jenny.zhang@starfivetech.com>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <leoliu@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <YunShen@zhaoxin.com>,
        <TonyWWang@zhaoxin.com>
References: <20230726113553.1965627-1-LeoLiu-oc@zhaoxin.com>
 <ZMITRjPOQAZ8qaZL@Red>
From:   LeoLiu-oc <leoliu-oc@zhaoxin.com>
In-Reply-To: <ZMITRjPOQAZ8qaZL@Red>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [125.76.214.122]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 ZXBJMBX03.zhaoxin.com (10.29.252.7)
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1690773578
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 677
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.112103
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2023/7/27 14:48, Corentin Labbe 写道:
> Le Wed, Jul 26, 2023 at 07:35:53PM +0800, LeoLiu-oc a écrit :
>> From: leoliu-oc <leoliu-oc@zhaoxin.com>
>>
>> Add support for Zhaoxin HW RNG.
>>
>> Signed-off-by: leoliu-oc <leoliu-oc@zhaoxin.com>
>> ---
>>   drivers/char/hw_random/Kconfig       |  13 +++
>>   drivers/char/hw_random/Makefile      |   1 +
>>   drivers/char/hw_random/via-rng.c     |  17 ++--
> 
> Hello
> 
> You are doing changes in via-rng without stating why.
> If changes are needed in via-rng, you should do this in a separate patch.
> 
> Regards

OK，Got it.Thanks for your advice,I will modify it in the next version.

Leoliu-oc
