Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BA1C4743E
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 16:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC15611CA
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 16:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFDQvh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 12:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFDQvh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 12:51:37 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA83C061766
        for <linux-crypto@vger.kernel.org>; Fri,  4 Jun 2021 09:49:50 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c124so9962014qkd.8
        for <linux-crypto@vger.kernel.org>; Fri, 04 Jun 2021 09:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fbrknCH2vbby+m6sJDW2xyfJlzKeJZUszdPMgrqvItA=;
        b=LcDa4rEP8tgp2Z9UtTKWD/82ciJAtX7ynXqvqZCdC2smBByA6MvJnBze0HA7M8mq6A
         7sgT6CSXkq04gqFW8KFg9ta30wDl/bQHT0WQmZnRrjuZfVAnOmevpT5SYC4NVO4HLkFj
         Vd5IU+tsRk8J7i2yUZV3PWajQGXFanxlMyEmiHlonoiCLKpvQHWq091fq/NVia2LOOhq
         OK1ums0mbHw+wjNiMjVczCbhYmBbJ6Cp9obGgp7V3VQaCX6DBQoUYAX62DNb7J85p8qs
         D2Q3W4aD1rBPuMHQu92AVhKqq2xTPjhtGCsD3fB3WswnPQDz/iaQ5ebY2V/xpY+efA3T
         kWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fbrknCH2vbby+m6sJDW2xyfJlzKeJZUszdPMgrqvItA=;
        b=bie2ocx+2JTY1Dg+LTri7+HKjL4+zwo5YVZB1GHg+d7L8vjotORo8RjwYGiwKngxVb
         VqQoPmuuF5RsgAi9s1uyK1hqL2HT0/4ZNnUNMPQrNfvTdtUh72BdLS3NYvTPJvNpQgzg
         UJb935gd+sxBci2IzKh/OVkCWHo8PYBB3EkEKx/J9qYL6UynaICpNlHKzWdjpWd03MMT
         CdchIzzJMgourYxDihevY6go4pOQfQwQ10/VpVBGk+hZ96wGeVUnAGQvn6o8X14HfhR7
         J2y0HVre301vW0TnorAwYyr0k4TFXrB66DPcBz/jmMpZ77HZgPxh3aYllsWiES+RXK+c
         HPog==
X-Gm-Message-State: AOAM533yutwwhpQaLVuOhXY1IG0UVKeVUHgmPlVP/z9fKi3nyMOrXeKZ
        eg5rxZfLSGzWfyM8P3vxasjq/7D8/0z8wtB5
X-Google-Smtp-Source: ABdhPJy5LaTZz9UJB7BmVbShctgH/0xLeAGvS0aMe5OFrFskhozwH0VqL6DuKEmNqruIAxRSeuRAjw==
X-Received: by 2002:a37:496:: with SMTP id 144mr5094900qke.456.1622825386306;
        Fri, 04 Jun 2021 09:49:46 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id z15sm4246959qkj.49.2021.06.04.09.49.45
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:49:45 -0700 (PDT)
To:     linux-crypto@vger.kernel.org
From:   Thara Gopinath <thara.gopinath@linaro.org>
Subject: Qualcomm Crypto Engine performance numbers on mainline kernel
Message-ID: <bc3c139f-4c0c-a9b7-ae00-59c2f8292ef8@linaro.org>
Date:   Fri, 4 Jun 2021 12:49:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hi All,

Below are the performance numbers from running "crypsetup benchmark" on 
CE algorithms in the mainline kernel. All numbers are in MiB/s. The 
platform used is RB3 for sdm845 and MTPs for rest of them.


			SDM845 	  SM8150     SM8250 	SM8350
AES-CBC (128)
Encrypt / Decrypt	114/106  36/48 	     120/188    133/197

AES-XTS (256)
Encrypt / Decrypt	100/102  49/48 	     186/187 	n/a


-- 
Warm Regards
Thara (She/Her/Hers)
