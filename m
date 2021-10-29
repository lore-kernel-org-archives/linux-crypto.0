Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE61BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 15:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864FF60F55
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 15:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhJ2P2u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 11:28:50 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:40700 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229527AbhJ2P2t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 11:28:49 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDDFCP001362;
        Fri, 29 Oct 2021 17:21:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=selector1;
 bh=tlJPjaHr3bopdMN69Mr2F3ZcC3w0YkJhjYgUllbtTzk=;
 b=pPsh8uZN+ePssNyktStyh7o0Dg/jk9WMjY2jihqFmYkCghCj1EQOXga0aNjz3D3DpUEL
 Mw74NxKPI/F8330np5Ii9uggT+7oyLNubEwC3gxK7ZHh7CpSZ0aA3rt4meILPcRQEdVN
 ip5BTO/7rS03ZyzdYOFuYsTEWRL/qyL0BRdveISBgj4N9DRYbPU229QqV5fNF/qspnNr
 xCUHSOlhP50GVDd6PtxZ1Rr6yyKRdCbYMcSEz+vXjpLNETaTMUbV25vq/KQz3Zl9tFj+
 eVuTBMm5Ho5NDupycvI8/Bz6LwDzgS1KO+7RZggca6Lgw9JBhgdKqVrv2p+N20Aoa/aV zQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3c07xgm36t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 17:21:37 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4DD1C10002A;
        Fri, 29 Oct 2021 17:21:36 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 14B87240741;
        Fri, 29 Oct 2021 17:21:36 +0200 (CEST)
Received: from gnbcxd0088.gnb.st.com (10.75.127.48) by SFHDAG2NODE2.st.com
 (10.75.127.5) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct
 2021 17:21:35 +0200
Date:   Fri, 29 Oct 2021 17:21:24 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
X-X-Sender: toromano@gnbcxd0088.gnb.st.com
To:     Marek Vasut <marex@denx.de>
CC:     Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] crypto: stm32/cryp - fix race condition
In-Reply-To: <1ec60d9c-1ab4-8a92-1c6d-8093232ca039@denx.de>
Message-ID: <alpine.DEB.2.21.2110291708040.20378@gnbcxd0088.gnb.st.com>
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com> <20211029135454.4383-5-nicolas.toromanoff@foss.st.com> <1ec60d9c-1ab4-8a92-1c6d-8093232ca039@denx.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_04,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 29 Oct 2021, Marek Vasut wrote:

> On 10/29/21 3:54 PM, Nicolas Toromanoff wrote:
>> Erase key before finalizing request.
>> Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto 
>> module")
>
> Can you be a bit more specific in your commit messages ? That applies to the 
> entire patchset. It is absolutely impossible to tell what race is fixed here 
> or why it is fixed by exactly this change. This applies to the entire series.

I'll send a v2 with better commit messages.

for this specific patch:
We reset the saved key before the crypto_finalize_*() call. Otherwise a 
still pending crypto action could be ran with a wrong key = {0};

> And while I am at it, does the CRYP finally pass at least the most basic 
> kernel boot time crypto tests or does running those still overwrite kernel 
> memory and/or completely crash or lock up the machine ?

All extra tests (finally) pass.

With a kernel config :
   # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
   CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
   CONFIG_CRYPTO_DEV_STM32_CRYP=m

while(true) do ; modprobe stm32-cryp && modprobe -r stm32-cryp ; done

ran a whole day without a crash, nor a detected error.

-- 
Nicolas.
