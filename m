Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CF5C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 07:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6708C21726
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 07:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfAWHhW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 02:37:22 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:38808 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAWHhW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 02:37:22 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 4E681184F0;
        Wed, 23 Jan 2019 08:37:20 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id NlHpBvvo-gF1; Wed, 23 Jan 2019 08:37:18 +0100 (CET)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id B7936184A3;
        Wed, 23 Jan 2019 08:37:15 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2E201E077;
        Wed, 23 Jan 2019 08:37:15 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 968251E06A;
        Wed, 23 Jan 2019 08:37:15 +0100 (CET)
Received: from thoth.se.axis.com (unknown [10.0.2.173])
        by boulder03.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 08:37:15 +0100 (CET)
Received: from XBOX04.axis.com (xbox04.axis.com [10.0.5.18])
        by thoth.se.axis.com (Postfix) with ESMTP id 8A5B6202D;
        Wed, 23 Jan 2019 08:37:15 +0100 (CET)
Received: from [10.88.41.2] (10.0.5.60) by XBOX04.axis.com (10.0.5.18) with
 Microsoft SMTP Server (TLS) id 15.0.1365.1; Wed, 23 Jan 2019 08:37:14 +0100
Subject: Re: [PATCH 3/7] crypto: axis: no need to check return value of
 debugfs_create functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        "Jesper Nilsson" <jespern@axis.com>,
        Lars Persson <larper@axis.com>, <linux-arm-kernel@axis.com>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
 <20190122151422.14204-4-gregkh@linuxfoundation.org>
From:   Lars Persson <lars.persson@axis.com>
Message-ID: <ad5fd669-a717-ee17-cebf-fc6b717ba46c@axis.com>
Date:   Wed, 23 Jan 2019 08:37:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122151422.14204-4-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: sv
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: XBOX01.axis.com (10.0.5.15) To XBOX04.axis.com (10.0.5.18)
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 1/22/19 4:14 PM, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Lars Persson <lars.persson@axis.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-arm-kernel@axis.com
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/crypto/axis/artpec6_crypto.c | 9 ---------
>   1 file changed, 9 deletions(-)

Acked-by: Lars Persson <lars.persson@axis.com>

Thanks,
  Lars
