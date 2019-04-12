Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05844C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C71BA2084D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMTXDcC8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfDLNpy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:45:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41788 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfDLNpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 09:45:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id 188so5177072pfd.8
        for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2019 06:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bFZMhv06zVxlEPEGtzBq6yFvms3RwPUSIO+Xrg0xxqg=;
        b=NMTXDcC8EBq0QyWuS62LWuDs10W5OEYosjAEWx019Vt0l0qinWNIFZM/YnsLxntGgt
         4pbYYP635rxjPOY8SXDXbO+Dv5YbAxzAD8LzJ4gkJH3qEV+S+GR6/32DNQo3sPhUgcGN
         iZ8ooBU2t1SCr/+SJWi+zHAqOlI9h42gpG0oPmNhrH2Ke+w6bRFD/fw7ZnqageI20P6j
         ZMKEqD8wETUTtFCXUlSnzusCm5cmoXO2Iv1NJ6wWjcOuYBXDDXE+2+WprrQwxeBCezgX
         NKSlRIFFggSPMu9wL7JICTSfnhUUbHulxBEJ9jLJ8oZD1dUFBP7VtRAKSm3mVRxHDrjg
         T55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bFZMhv06zVxlEPEGtzBq6yFvms3RwPUSIO+Xrg0xxqg=;
        b=Tq6qpCMfCOnMAAb+aU33+Dg81q3tHz9JBCc7Z8QsL2K+vO9mKSlsPeQQAVrfHi2G2v
         VIAehL84FaXOXKiMn1t2fN9YQtKKvorp+PyEf9jf0/1b0QgOG4YyT+bOeW7IyKGmVeXp
         GWUl9y9IBSa6/yP8JzTzcf6Vf22LgGZ8TTG+OQ3BPAR+WG0zSW8fNdwk2Omc6BlbXOJ6
         Q2WtAiCNjLMyyZM7xvXVHe81PW5L5twXu6xJyYjXpQ6MNrpXqzwgiC/m8eFP8EEGuqYF
         N/3ncjxbu7GxwV2myKBOKOkOOdjJf2yt6V9KFg+8na/EIVhXXeEKXM8RQeMbVr6xcG6d
         5X+g==
X-Gm-Message-State: APjAAAVj/ml4Ohg+b1HMn4ZC2uYkmMgXSOLeM2IZbvf6d2JfF/tey+w2
        ZkeNq0ptG5B89zBuoG/5sxc=
X-Google-Smtp-Source: APXvYqx0u7kaYlea6vl7uMQxN4jysIP0GlRruFmgDslZb5icL7RJTZ73Z8LHmkDqhPlB9M3Fa2LSLQ==
X-Received: by 2002:a62:2687:: with SMTP id m129mr55978872pfm.204.1555076753304;
        Fri, 12 Apr 2019 06:45:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g5sm23995281pfo.53.2019.04.12.06.45.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 06:45:52 -0700 (PDT)
Subject: Re: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead
 multiple variables
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
References: <20190329130956.15935-1-bigeasy@linutronix.de>
 <20190329130956.15935-2-bigeasy@linutronix.de>
 <20190411040734.GA2292@roeck-us.net> <20190411043933.GA5866@sol.localdomain>
 <20190412085450.c7bmgi3pqym67vzm@linutronix.de>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d02457b6-eb5c-c385-787e-c135f585c7d8@roeck-us.net>
Date:   Fri, 12 Apr 2019 06:45:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190412085450.c7bmgi3pqym67vzm@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/12/19 1:54 AM, Sebastian Andrzej Siewior wrote:
> On 2019-04-10 21:39:34 [-0700], Eric Biggers wrote:
>> Well, from a quick read of the patch, it's probably because it uses
>> raw_cpu_ptr() instead of per_cpu_ptr() when allocating/freeing the buffers, so
>> they are unlikely to actually be allocated for all CPUs.
> 
> memory is allocated in crypto_scomp_alloc_scratches() before the
> algorithm is first used for for_each_possible_cpu. So all CPUs should
> have it.
> 
>> Also Sebastian, I don't understand the point of the spinlock.  What was wrong
>> with get_cpu()?  Note that taking the spinlock disables preemption too...  Also
>> now it's possible to spin for a long time on the spinlock, for no reason really.
> 
> The long spin is only possible PREEMPT kernel if the context switches
> the CPU between getting the pointer and acquiring the CPU. Should this
> really become a problem I could try to think of something.
> That spin_lock gives us lock annotation and a lock context. With
> preempt_disable() it is just a BKL like thing with no context. And this
> basically kills PREEMPT_RT.
> 

arm64:defconfig:

CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPT_RCU=y
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_DEBUG_PREEMPT is not set

Hmm ... maybe I should add specific PREEMPT tests to my suite.

Guenter
