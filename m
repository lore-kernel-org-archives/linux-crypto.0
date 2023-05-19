Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324AFC77B7A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 12:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjESMva (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 08:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjESMv2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 08:51:28 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1190D10E7
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 05:50:48 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id D251F24E1D3;
        Fri, 19 May 2023 20:50:42 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 19 May
 2023 20:50:42 +0800
Received: from [192.168.100.10] (161.142.156.50) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 19 May
 2023 20:50:39 +0800
Message-ID: <5cb75db7-0293-1cee-02aa-ac7159404f65@starfivetech.com>
Date:   Fri, 19 May 2023 20:50:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [herbert-cryptodev-2.6:master 21/22]
 drivers/tty/serial/amba-pl011.c:379:30: error: implicit declaration of
 function 'phys_to_page'; did you mean 'pfn_to_page'?
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
References: <202305191929.Eq4OVZ6D-lkp@intel.com>
 <d4751f66-6e57-66da-f8ad-4ac2c8c46fd2@starfivetech.com>
 <ZGdvGWenGxwzOU4C@gondor.apana.org.au>
From:   Jia Jie Ho <jiajie.ho@starfivetech.com>
In-Reply-To: <ZGdvGWenGxwzOU4C@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [161.142.156.50]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX168.cuchost.com
 (172.16.6.78)
X-YovoleRuleAgent: yovoleflag
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19/5/2023 8:44 pm, Herbert Xu wrote:
> On Fri, May 19, 2023 at 08:39:26PM +0800, Jia Jie Ho wrote:
>>
>> Should I submit a new patch to select HAS_DMA in my Kconfig?
> 
> No you should change the select to a dependency.  Nobody else
> selects it.
> 

Sure, should I submit new patch series again or just a new patch with this change?

Thanks
Jia Jie

