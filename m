Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66239C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E9772084D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5iDy6mM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfDLNnf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:43:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33722 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfDLNnf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 09:43:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id h5so5200873pfo.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2019 06:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L6/dPNArMhjVKiC7n5nd+HpKPbstszmpc1vCV4HIjfY=;
        b=Q5iDy6mM/926pKWnGxnkDb+FgAfHiprj+cFc3WAMKEZgZO5K5KHK9hm9QG50QR+KRl
         UXqFF+Y3FUPYYD3YFPBCWDmelt9k2kkGC5WEzrAGqO54MVg8N6cDqCYQpBGR7M9xjDbI
         VvhLy7Mxl8HsenG7gk3P4sKeSK3GlYtR6BpCYxXDMciy9pU+n5aDpd5l/PXPAUkzAgAd
         h5ADFw8JFX/3zjAfEhq9MpJPMa7SQIoovyG+mivU51m+OfEz79gJ59ce7YuipZPe2CPm
         A8Bqu3f9xY/KXvoNGkulB+1PW1fmQkTa6n0DCHL6O+O6Ev/gxTZyhYKW47ZD5tZzM3uc
         Lvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L6/dPNArMhjVKiC7n5nd+HpKPbstszmpc1vCV4HIjfY=;
        b=Fx13p0Wr+qrPC3kfxUnFgfZ2hpqy5KhDGFJxo/cXKXu/8KDy6AUtiCgpOY0hNcagIz
         4W295EAiLD2y5i5PQtpcfUO8Xc4/1ImUKvc0r4T+98RIH5F4WFZ8etSQ+XqDBl2Y49iz
         MHBtnX/xnfzgPBwE4orIIKgpOqRogw54fuhp3rYo2Mf9JhwCsD/zYBsEcbs88cLYefqS
         zHLV4kpD7orxn5EN5C1YHktMRd8O92ZZwJkuEHUtLlU+MbakAg9QXyX9D0ekIpG/x8mv
         9KEzyjqDTAptLwZ6W4H/X3bIa4JoYMxh+30nyuNEBWU4oePt+WSNFd25PrSQdPSTVA8e
         aVKw==
X-Gm-Message-State: APjAAAU8bU95ZWwWOpLkwhQ6Lc5fr/29y/g9SiRGqUbAZOvHSnpLR7ic
        8DDKgM4hjYGecpi497acvCF6LBR2
X-Google-Smtp-Source: APXvYqzD5OFVb1nMkqoOL5Q3uUtNPBvev3KsuR6JiBr7E6lgiVaZ4udPEQ1tDA4U9kpXWsX/SKgDxg==
X-Received: by 2002:aa7:8e55:: with SMTP id d21mr15357038pfr.62.1555076614139;
        Fri, 12 Apr 2019 06:43:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b19sm48250858pgb.51.2019.04.12.06.43.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 06:43:33 -0700 (PDT)
Subject: Re: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead
 multiple variables
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
References: <20190329130956.15935-1-bigeasy@linutronix.de>
 <20190329130956.15935-2-bigeasy@linutronix.de>
 <20190411040734.GA2292@roeck-us.net>
 <20190412084228.lrf2c6r54xsqknhf@linutronix.de>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ac7fb436-2286-1eb2-662b-e2236ad02718@roeck-us.net>
Date:   Fri, 12 Apr 2019 06:43:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190412084228.lrf2c6r54xsqknhf@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/12/19 1:42 AM, Sebastian Andrzej Siewior wrote:
> On 2019-04-10 21:07:35 [-0700], Guenter Roeck wrote:
>> Hi Sebastian,
> Hi Guenter,
> 
>> Unfortunately, this patch causes random crashes.
> …
>> This is seen with an arm64 image running on qemu with machine xlnx-zcu102
>> and two CPUs, and crypto test options enabled. It happens roughly every
>> other boot. Reverting the patch fixes the problem. Bisect log (from
>> crypto/master) is attached.
> 
> What is it that you are doing? I had it tcrypt tested on x86-64 before
> posting. Let me check it again with the next tree on qemu…
> 

Nothing special. Booting arm64:defconfig+various debug and test options in qemu.
It does not seem to depend on specific boot options. Crash failure rate, based
on the last three of days testing, seems to be roughly 20%. The problem is only
seen if there is more than one CPU. I have seen it with 2, 4, and 6 CPUs active,
but it seems to be most likely to happen with 2 CPUs. I don't have enough data
yet to be sure, though.

The problem is only seen with arm64, at least in my tests.

Guenter
