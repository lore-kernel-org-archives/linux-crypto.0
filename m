Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF5FC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Oct 2022 06:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJLGId (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Oct 2022 02:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJLGIb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Oct 2022 02:08:31 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42911DE90
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2022 23:08:30 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b2so15313342plc.7
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2022 23:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXPwhDEno8WppMwcdGdxGZla4T7knIHdP81b3128AZY=;
        b=Oxt3WPazMlkrL7mVCN99lrZpczJFc0ojBx7zjFnv6PAXWotZLTJOoHBd+LRRtCzt50
         /nCkp0weW1Uo7hhz1YS6fX4wolxAgEvOHU3CMQqJncVg+/7dEACnS8Sa7KZZJFohWjtM
         9x7raVqQeiF9z+BQSAl0X6zskUuqn+8RNf1Taop8BTmUth09CswthLeNj+TMQWWU3gvt
         W8jXzxdBr+YPJQHSw33ceRFC1NXsxtigjFZqdoEjA5BUsx+Ajv3PxLG2sNqc63i8z2BD
         vBJRRlO+FEWJClGcfXhE5v++2DLhN+YYvJ6vaPKdRjakfCP8/S1DhPxeIcBV6/ckxgVw
         pnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iXPwhDEno8WppMwcdGdxGZla4T7knIHdP81b3128AZY=;
        b=SZJIrBuO19aEx+Yo8Dwgs0x73J3rh6N34eqtGfYBQt1SCJc6yjnP68J1LOc8KP2twX
         FMtSDvZp7+84YjGxTwDhVS3n4NIcsyn3VSZVEkbwUWWKcWhOVcoTBFvDXgmxH3Flltze
         NmzipSmI2Jo8bsDomrMHe/THw7fsi+I810l4fkdWhSPxUOKQAOyvmyHTHnHhezf/mMKA
         v6Jb8Kqz41cU2csx1Lavjr3W/wmCpzpvlUmA9qkaOeFLf4fvWnVcqfQWHaGKlAVZFjxf
         xi22fIYTbOYVGUFyHISvaWjUy1emTdmkzPY2qugiiMTuVwILpOUZd+1rNcQPoCGrba7a
         8JbQ==
X-Gm-Message-State: ACrzQf1qgkA9RKV38QB63tkkstqSIAsS6BD1SrYSnfurn/GfqGXHRzlQ
        wlIxpm5o8KRvG//hWNdUsD8=
X-Google-Smtp-Source: AMsMyM5RNs8KeGWo/M7rxjuhEe2o37SqdeT8IJgvwuPtgFwWl3kSdGmHNy8I0s5ujD4QtxDGg9ivjQ==
X-Received: by 2002:a17:903:2347:b0:181:33f0:f64e with SMTP id c7-20020a170903234700b0018133f0f64emr21060431plh.106.1665554909660;
        Tue, 11 Oct 2022 23:08:29 -0700 (PDT)
Received: from [192.168.123.100] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id pf15-20020a17090b1d8f00b00200a85fa777sm604912pjb.1.2022.10.11.23.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 23:08:29 -0700 (PDT)
Message-ID: <d12093d7-d01c-081f-fa04-c608f8021a60@gmail.com>
Date:   Wed, 12 Oct 2022 15:08:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] crypto: x86: Do not acquire fpu context for too long
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "ebiggers@google.com" <ebiggers@google.com>
References: <20221004044912.24770-1-ap420073@gmail.com>
 <Yzu8Kd2botr3eegj@gondor.apana.org.au>
 <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com>
 <MW5PR84MB18420D6E1A31D9C765EF6ED4AB5A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <CAMj1kXGmKunh-OCvGFf8T6KJJXSHRYzacjSojBD3__u0o-3D1w@mail.gmail.com>
 <MW5PR84MB1842762F8B2ABC27A1A13614AB5E9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <Y0JoDWx0Q5BmO/wR@gondor.apana.org.au>
 <MW5PR84MB1842FD77B90B1553367235CEAB219@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <MW5PR84MB1842FD77B90B1553367235CEAB219@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Elliott, Robert

2022. 10. 10. 오전 4:58에 Elliott, Robert (Servers) 이(가) 쓴 글:
 >
 >
 >> -----Original Message-----
 >> From: Herbert Xu <herbert@gondor.apana.org.au>
 >> Sent: Sunday, October 9, 2022 1:20 AM
 >> To: Elliott, Robert (Servers) <elliott@hpe.com>
 >> Cc: Ard Biesheuvel <ardb@kernel.org>; Taehee Yoo 
<ap420073@gmail.com>; linux-
 >> crypto@vger.kernel.org; davem@davemloft.net; tglx@linutronix.de;
 >> mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com; 
x86@kernel.org;
 >> hpa@zytor.com; ebiggers@google.com
 >> Subject: Re: [PATCH] crypto: x86: Do not acquire fpu context for too 
long
 >>
 >> On Sat, Oct 08, 2022 at 07:48:07PM +0000, Elliott, Robert (Servers) 
wrote:
 >>>
 >>> Perhaps the cycles mode needs to call cond_resched() too?
 >>
 >> Yes, just make the cond_resched unconditional.  Having a few too many
 >> rescheds shouldn't be an issue.
 >
 > This looks promising. I was able to trigger a lot of rcu stalls by 
setting:
 >    echo 2 > /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
 >    echo 200 > /sys/module/rcupdate/parameters/rcu_exp_cpu_stall_timeout
 >
 > and running these concurrently:
 >    watch -n 0 modprobe tcrypt=200
 >    watch -n 0 module tcrypt=0 through 999
 >
 > After changing tcrypt to call cond_resched in both cases, I don't see any
 > more rcu stalls.
 >
 > I am getting miscompares from the extended self-test for crc32 and
 > crct10dif, and will investigate those further.
 >
 > BTW, the way tcrypt always refuses to load leads to an ever-growing 
list in
 > the Call Traces:
 >
 > kernel: Unloaded tainted modules: tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 t
 > crypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1
 > tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1
 >   tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():
 > 1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 
tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt()
 > :1 tcrypt():1 tcrypt():1 tcrypt():1
 >
 >
 >

I tested mb_aead as well.

I can find rcu stalls easily while testing gcm(aes-generic) with the 
below commands.
#shell1
while :
do
     modprobe tcrypt mode=215 num_mb=1024
done
#shell2
while :
do
     modprobe tcrypt mode=0
done

Then, I added cond_resched() as you mentioned.

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a82679b576bb..eeb3abb4eece 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -415,6 +415,7 @@ static void test_mb_aead_speed(const char *algo, int 
enc, int secs,
                         } else {
                                 ret = test_mb_aead_cycles(data, enc, bs,
                                                           num_mb);
+                               cond_resched();
                         }

I can't see rcu stalls anymore, I think it works well.
