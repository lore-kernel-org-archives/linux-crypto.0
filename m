Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476A4C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Apr 2022 11:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiDLLpB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Apr 2022 07:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354884AbiDLLoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Apr 2022 07:44:00 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41B47B118
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 03:25:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t12so4027082pll.7
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 03:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vo+e8XwHkTEoVxz5IEpTN/1YQf55sAfVJWv5HhomO6Y=;
        b=c3HOTK0Ri/tKw2z2Fc1QWLTxIKKObZPCobJOQxkL/ogtWB2wssWLFLyq/NoBj7ACjb
         jv+meEkQ4CCMsKJEq5FlQwtVKju1h/WcvPNLMgQTZ9QWj5MCsc10um3vrjz1HbUkH8w2
         sSJJDdC8ETgxsGMpcFDvbtGwLG91x5UMdlSU3c/UO+FjsqEOzCbVNQUbE9cPY6MQwE0l
         exGpMoVoSGLR246HrlKRo1Yc+McwtVb20siAwQhxydwmFjEa8J3AToxoT6LXx8SdTy4Y
         E1hJSa+wmNW7S8pO2wpmgvcIYKF1bScAjtiOZfZuYdUkeVg1HRMZ+Yo5Abjk6e1vQnCE
         CxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vo+e8XwHkTEoVxz5IEpTN/1YQf55sAfVJWv5HhomO6Y=;
        b=leB+Xcm3Qr6R2yOEZ6sieXJf8Jo1ZDcQNFG4UOQ0oJk5IEdFAsfPmYgN/VczGseWQW
         olZRckKw/iDO2dc1wdDQ1Di9exTyA3fQpxUm1NW0YViEwDaXBTnQuX1vcE+poHDsLXdh
         BfkOcIV7tlKgv0HmeHV2CX9a4opsjfCFIjqM3LqheokGLbokiuQxyTkRkgKjttTjROUj
         5y+ELX6XSxmReoXBnU5O2XgqVcTUIuRL8ltrmvLIO/ZE4pyXuNSlzFehvOxizAvnQ0GF
         sg4zmEz4R7OTEA7vWoo6Sgd5855ow84PnDHPDMXFm0eq27kzdAxyo6NJDLzNGErlubpf
         rxOg==
X-Gm-Message-State: AOAM530S5+Uc5+C9dOXiTwAQJQrtdXHg3zsTdv+IPJDPqk+QFR8H+ZBP
        3QuPBrGrAcVpX9gwYu+1TfEJjA==
X-Google-Smtp-Source: ABdhPJw5zpOGNlLWF2IyuBkyt9JwXLfL2DtYY/Me9NmOeJBUW3JZzYQAcn6hfyQ4z7sCO2wEuNUr3Q==
X-Received: by 2002:a17:90b:1bc8:b0:1c7:443:3ffb with SMTP id oa8-20020a17090b1bc800b001c704433ffbmr4187757pjb.84.1649759110165;
        Tue, 12 Apr 2022 03:25:10 -0700 (PDT)
Received: from [10.76.15.169] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id f23-20020a635117000000b0039d4f859738sm2400249pgb.71.2022.04.12.03.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 03:25:09 -0700 (PDT)
Message-ID: <6a4202bf-6595-a60d-369d-3b943fb98bdd@bytedance.com>
Date:   Tue, 12 Apr 2022 18:21:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Re: [PATCH v4 0/8] Introduce akcipher service for virtio-crypto
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     helei.sig11@bytedance.com, jasowang@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org, arei.gonglei@huawei.com,
        Simo Sorce <simo@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, mst@redhat.com, berrange@redhat.com
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
 <df758c80-ea85-d324-ad05-9bf07bb569e3@redhat.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <df758c80-ea85-d324-ad05-9bf07bb569e3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 4/12/22 17:47, Paolo Bonzini wrote:
> 
>> In our plan, the feature is designed for HTTPS offloading case and
>> other applications which use kernel RSA/ecdsa by keyctl syscall.
> 
> Hi Zhenwei,
> 
> what is the % of time spent doing asymmetric key operations in your
> benchmark?  I am not very familiar with crypto acceleration but my
> understanding has always been that most time is spent doing either
> hashing (for signing) or symmetric key operations (for encryption).
> 
> If I understand correctly, without support for acceleration these 
> patches are more of a demonstration of virtio-crypto, or usable for 
> testing purposes.
> 

Hi, Paolo

This is the perf result of nginx+openssl CPU calculation, the heavy load 
from openssl uses the most time(as same as you mentioned).
27.37%    26.00%  nginx            libcrypto.so.1.1          [.] 
__bn_sqrx8x_reduction
20.58%    19.52%  nginx            libcrypto.so.1.1          [.] 
mulx4x_internal
16.73%    15.89%  nginx            libcrypto.so.1.1          [.] 
bn_sqrx8x_internal
  8.79%     0.00%  nginx            [unknown]                 [k] 
0000000000000000
  7.26%     0.00%  nginx            [unknown]                 [.] 
0x89388669992a0cbc
  7.00%     0.00%  nginx            [unknown]                 [k] 
0x45f0e480d5f2a58e
  6.76%     0.02%  nginx            [kernel.kallsyms]         [k] 
entry_SYSCALL_64_after_hwframe
  6.74%     0.02%  nginx            [kernel.kallsyms]         [k] 
do_syscall_64
  6.61%     0.00%  nginx            [unknown]                 [.] 
0xa75a60d7820f9ffb
  6.47%     0.00%  nginx            [unknown]                 [k] 
0xe91223f6da36254c
  5.51%     0.01%  nginx            [kernel.kallsyms]         [k] 
asm_common_interrupt
  5.46%     0.01%  nginx            [kernel.kallsyms]         [k] 
common_interrupt
  5.16%     0.04%  nginx            [kernel.kallsyms]         [k] 
__softirqentry_text_start
  4.92%     0.01%  nginx            [kernel.kallsyms]         [k] 
irq_exit_rcu
  4.91%     0.04%  nginx            [kernel.kallsyms]         [k] 
net_rx_action


This is the result of nginx+openssl keyctl offload(virtio crypto + host 
keyctl + Intel QAT):
30.38%     0.08%  nginx            [kernel.kallsyms]         [k] 
entry_SYSCALL_64_after_hwframe
30.29%     0.07%  nginx            [kernel.kallsyms]         [k] 
do_syscall_64
23.84%     0.00%  nginx            [unknown]                 [k] 
0000000000000000
14.24%     0.03%  nginx            [kernel.kallsyms]         [k] 
asm_common_interrupt
14.06%     0.05%  nginx            [kernel.kallsyms]         [k] 
common_interrupt
12.99%     0.11%  nginx            [kernel.kallsyms]         [k] 
__softirqentry_text_start
12.27%     0.12%  nginx            [kernel.kallsyms]         [k] 
net_rx_action
12.13%     0.03%  nginx            [kernel.kallsyms]         [k] __napi_poll
12.06%     0.06%  nginx            [kernel.kallsyms]         [k] 
irq_exit_rcu
10.49%     0.14%  nginx            libssl.so.1.1             [.] 
tls_process_client_key_exchange
10.21%     0.12%  nginx            [virtio_net]              [k] 
virtnet_poll
10.13%     0.04%  nginx            libc-2.28.so              [.] syscall
10.12%     0.03%  nginx            kctl-engine.so            [.] 
kctl_rsa_priv_dec
10.02%     0.02%  nginx            kctl-engine.so            [.] 
kctl_hw_rsa_priv_func
  9.98%     0.01%  nginx            libkeyutils.so.1.10       [.] 
keyctl_pkey_decrypt
  9.95%     0.02%  nginx            libkeyutils.so.1.10       [.] keyctl
  9.77%     0.03%  nginx            [kernel.kallsyms]         [k] 
keyctl_pkey_e_d_s
  8.97%     0.00%  nginx            [unknown]                 [k] 
0x00007f4adbb81f0b
  8.78%     0.08%  nginx            libpthread-2.28.so        [.] 
__libc_write
  8.49%     0.05%  nginx            [kernel.kallsyms]         [k] 
netif_receive_skb_list_internal

The RSA part gets reduced, and the QPS of https improves to ~200%.

Something may be ignored in this cover letter:
[4] Currently RSA is supported only in builtin driver. This driver is 
supposed to test the full feature without other software(Ex vhost 
process) and hardware dependence.
-> Yes, this patch is a demonstration of virtio-crypto.

[5] keyctl backend is in development, we will post this feature in 
Q2-2022. keyctl backend can use hardware acceleration(Ex, Intel QAT).
-> This is our plan. Currently it's still in developing.


> Would it be possible to extend virtio-crypto to use keys already in the
> host keyctl, or in a PKCS#11 smartcard, so that virtio-crypto could also
> provide the functionality of an HSM?  Or does the standard require that
> the keys are provided by the guest?
> 
> Paolo

I'm very interested in this, I'll try in Q3-2022 or later.

-- 
zhenwei pi
