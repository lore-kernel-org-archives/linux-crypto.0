Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7778AC433E5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 06:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB3C20658
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 06:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgGWGQ6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 02:16:58 -0400
Received: from out28-145.mail.aliyun.com ([115.124.28.145]:60821 "EHLO
        out28-145.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgGWGQ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 02:16:58 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1183656|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0542861-0.0440707-0.901643;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03308;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=22;RT=22;SR=0;TI=SMTPD_---.I6H4xer_1595484991;
Received: from 192.168.10.205(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.I6H4xer_1595484991)
          by smtp.aliyun-inc.com(10.147.42.16);
          Thu, 23 Jul 2020 14:16:32 +0800
Subject: Re: [PATCH 2/2] crypto: Ingenic: Add hardware RNG for Ingenic JZ4780
 and X1000.
To:     Randy Dunlap <rdunlap@infradead.org>, arnd@arndb.de,
        gregkh@linuxfoundation.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, hadar.gat@arm.com,
        prasannatsmkumar@gmail.com, krzk@kernel.org, masahiroy@kernel.org,
        xuzaibo@huawei.com, daniel.thompson@linaro.org,
        tmaimon77@gmail.com, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        yanfei.li@ingenic.com, sernia.zhou@foxmail.com,
        zhenwenjin@gmail.com
References: <20200722164007.77655-1-zhouyanjie@wanyeetech.com>
 <20200722164007.77655-3-zhouyanjie@wanyeetech.com>
 <779949c8-8b1a-52ed-f695-7006f0045d7e@infradead.org>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <cb9d9d4d-4f85-5e41-8597-946698649c5e@wanyeetech.com>
Date:   Thu, 23 Jul 2020 14:16:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <779949c8-8b1a-52ed-f695-7006f0045d7e@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Randy,

在 2020/7/23 上午2:27, Randy Dunlap 写道:
> On 7/22/20 9:40 AM, 周琰杰 (Zhou Yanjie) wrote:
>> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
>> index 0ad17efc96df..fcb06027cd88 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -257,6 +257,21 @@ config HW_RANDOM_IMX_RNGC
>>   
>>   	  If unsure, say Y.
>>   
>> +config HW_RANDOM_INGENIC_RNG
>> +	tristate "Ingenic Random Number Generator support"
>> +	depends on HW_RANDOM
>> +	depends on MACH_JZ4780 || MACH_X1000
>> +	default HW_RANDOM
>> +	---help---
> Just use:
> 	help
> here. See this for why:
>
> commit 8f268881d7d278047b00eed54bbb9288dbd6ab23
> Author: Masahiro Yamada <masahiroy@kernel.org>
> Date:   Tue Dec 17 20:51:51 2019 +0900
>
>      kconfig: remove ---help--- from documentation
>      
>      Since commit 84af7a6194e4 ("checkpatch: kconfig: prefer 'help' over
>      '---help---'"), scripts/checkpatch.pl warns the use of ---help---.
>      
>      Kconfig still supports ---help---, but new code should avoid using it.
>      Let's stop advertising it in documentation.
>

Sure, I will change it in v2.

Thanks and best regards!


>> +	  This driver provides kernel-side support for the Random Number Generator
>> +	  hardware found in ingenic JZ4780 and X1000 SoC. MIPS Creator CI20 uses
>> +	  JZ4780 SoC, YSH & ATIL CU1000-Neo uses X1000 SoC.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called ingenic-rng.
>> +
>> +	  If unsure, say Y.
>> +
>>   config HW_RANDOM_NOMADIK
>>   	tristate "ST-Ericsson Nomadik Random Number Generator support"
>>   	depends on ARCH_NOMADIK
> thanks.
