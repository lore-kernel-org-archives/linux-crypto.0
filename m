Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49004ECAAD2
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 02:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiIBCo2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 22:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIBCo1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 22:44:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D138A6C1C
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 19:44:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p8-20020a17090ad30800b001fdfc8c7567so6698889pju.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 19:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject:cc
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=1PsNBaLfV1Id2Ps+k+xZeZ9CQh6z+T/lqy7cZttruW4=;
        b=mJFIZPefAUVGRuuGRLNt/QVEESYl4SJJ8OLxZTHykqKSwdX6IAu7u4GQrU5wJOndNJ
         A54IWO5icPzMuAGkerUhEVGCqCmW22WU1d4+bx3acBwHed5Nmku3TVRx1YtV/OllcAgx
         7COtaIsegf/unJHmZafaynkbYoBCt5TFo+vF+kdoud7xEg+lgYJjPU1NHCgyxn41mCYN
         4JAC6LmUKcsolsYib6sCeG4Eau+doMtaItYEbnkeF1IQnWLla1JUazAlPMuYzR8cVVZ1
         c8JPh+bhR+l+Cxwtn0jMHCX5hRnmL091YnbmYAgV7StWJLN6VXdkZ4kAjBgTUaAX0OpZ
         gxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject:cc
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=1PsNBaLfV1Id2Ps+k+xZeZ9CQh6z+T/lqy7cZttruW4=;
        b=5/jaw6PK9twNN0fQwqMhNZJT5RvoOhB/ZovA8B5bieg0qGgsGs+GlXqKflvqblMpLj
         UMC5zB/mNEcSxRz8+L9E1GDODQVSh31IaWiTlYANIcgUy0b1KkuRcRjMBF+x6wQ6HD7V
         XZo4fRyl/eB9U2xY92I9iaOi/R33iW40j0NHe/7eMg2O85L8epBsOCC4DmwLWlBtnY+U
         IIdgK9pjyJK4dQOYK8jhtB1XO+yMFeukpohegencdDvkutMp+qRQgcPZfxQNXAlQAe1I
         dSjR5QNkIxRdEz671cdHzZlULeOGheqff1FG8eGWR5yyTMNmbQU4Zkhksyd5X6vQorJm
         KgpQ==
X-Gm-Message-State: ACgBeo3YucqlTo7z4rNSxdtcjasHJ2OmZ5NY9kRQfSvzNE0N81KUA6R7
        cNCIrczBuEwTWMXL21LcpxciSw==
X-Google-Smtp-Source: AA6agR4cHRiyiyP/rvbZkNNhlGX8J+isHIgNHQ2x5TVKqke/YUgPL8aZsq42ipgThfMvm92fYOS13Q==
X-Received: by 2002:a17:90b:1d0b:b0:1f5:72f:652c with SMTP id on11-20020a17090b1d0b00b001f5072f652cmr2423803pjb.38.1662086666703;
        Thu, 01 Sep 2022 19:44:26 -0700 (PDT)
Received: from ?IPV6:fdbd:ff1:ce00:422:5de3:70d0:6600:c574? ([2404:9dc0:cd01::1e])
        by smtp.gmail.com with ESMTPSA id ms22-20020a17090b235600b001fb398e5e6esm320609pjb.55.2022.09.01.19.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 19:44:26 -0700 (PDT)
Message-ID: <f56fadd1-2a6a-060e-06af-c3923795d4e0@bytedance.com>
Date:   Fri, 2 Sep 2022 10:44:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.0
Cc:     helei.sig11@bytedance.com,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com
Subject: PING: [PATCH v2] virtio-crypto: fix memory-leak
To:     mst@redhat.com, herbert@gondor.apana.org.au,
        arei.gonglei@huawei.com
References: <20220816094336.27806-1-helei.sig11@bytedance.com>
 <95f6eec3-62f7-46d8-9bb1-664fb9e36534@bytedance.com>
From:   Lei He <helei.sig11@bytedance.com>
In-Reply-To: <95f6eec3-62f7-46d8-9bb1-664fb9e36534@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/8/24 下午4:38, Lei He wrote:
> On 2022/8/16 下午5:43, Lei He wrote:
>> From: lei he <helei.sig11@bytedance.com>
>>
>> Fix memory-leak for virtio-crypto akcipher request, this problem is
>> introduced by 59ca6c93387d3(virtio-crypto: implement RSA algorithm).
>> The leak can be reproduced and tested with the following script
>> inside virtual machine:

PING

Best regards,
Lei He
--
helei.sig11@bytedance.com

