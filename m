Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C122C636CC
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Feb 2023 18:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBKSlR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Feb 2023 13:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBKSlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2023 13:41:16 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9353F16AC2
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2023 10:41:15 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id e17so964123plg.12
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2023 10:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QW44fT1BaYgPVyUtsxu6/qEJHtDG7Yhra5N1MAWl2dc=;
        b=YKKoKtKKomH6uWv/elRmwO9Mk3a7XllByrQ6SI/byR14tJ7C6WOgqV5hWYDI7CLlRN
         NIIu9DYlUfsfR2P1E3EwUBABdoYO4zxMfRyipIcPwyN25Iq1xREoj8dwo37ANZNf31JC
         ryIVN0dOS+GfAnPTHn/vB/dI2eJKqDiF52AhCctMLflwFLFBEMZ7sK4Mi//LYs7GgMa+
         h8VZIyu+Z/MWsZ58W5V3iypn5oxUD9mNOUNa7WCc/HaTfPgnQA51wF0LCtsq4IQw/18z
         TkWw+rXyCGSDXww5cOOG2+vHHukD1Yat7BIHVQOQrSZjshqi04CfsXzB40nse/VWbT4T
         T7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QW44fT1BaYgPVyUtsxu6/qEJHtDG7Yhra5N1MAWl2dc=;
        b=nZ0XJkRN+SKgSgXdwdKsPYPaHiZIkI4q86fof5KDX5aE3ukORyKbnnoe2ooqk3B17Y
         mRQQIypOgGfK0bYuTlHR9bwGDrp0tbE5HpFrFMUl1KkreWFwBtPpdNF7WCix0XNfgtIl
         4m4NcptdqY7IQYQyAQCrDQGungxvmO+RU4SgRRJm90ahhHZkT5w//rXAXrSsqYyniXjN
         sTXxA4WZttsHWHKt/Ki/sjKxun8yqdMHO3Rc/bI9W1BLs3/ezlS3CKlbRXJ8rfDjUcQw
         6M+oQe24xsLF1F0juKuPW1uXPHEndPDfSBxseZQZ68xD2P/4HJ2jV6W3HNdLl8gKAPCa
         hY9Q==
X-Gm-Message-State: AO0yUKVNsQkKZevsyg1DWoJwXkRvI3o1fmIGQ1rn66OjF2XSyhW/dcrR
        +bFw+eKUUt758FOMR2wWCvGwCa9CE+0EBw==
X-Google-Smtp-Source: AK7set9SNW5MmTDFDGmkZmO+Uakv47BRPi+POYKUfAZfS/3dYjspjMVAvcSYtUxD8KsDq0OmhXVUMQ==
X-Received: by 2002:a17:902:e843:b0:199:2a89:f912 with SMTP id t3-20020a170902e84300b001992a89f912mr22132681plg.20.1676140874683;
        Sat, 11 Feb 2023 10:41:14 -0800 (PST)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902848b00b00186748fe6ccsm5248449plo.214.2023.02.11.10.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 10:41:13 -0800 (PST)
Message-ID: <5123c801-268f-cba9-19dc-499dcf2d351f@gmail.com>
Date:   Sun, 12 Feb 2023 03:41:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net, x86@kernel.org
Cc:     erhard_f@mailbox.org
References: <20230210181541.2895144-1-ap420073@gmail.com>
 <d31209ec-ba33-3326-be58-d227c2be8c6d@intel.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <d31209ec-ba33-3326-be58-d227c2be8c6d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/11/23 04:19, Dave Hansen wrote:

Hi Dave,
Thank you so much for the review!

 > On 2/10/23 10:15, Taehee Yoo wrote:
 >> vpbroadcastb and vpbroadcastd are not AVX instructions.
 >> But the aria-avx assembly code contains these instructions.
 >> So, kernel panic will occur if the aria-avx works on AVX2 unsupported
 >> CPU.
 > ...
 >> My CPU supports AVX2.
 >> So, I disabled AVX2 with QEMU.
 >> In the VM, lscpu doesn't show AVX2, but kernel panic didn't occur.
 >> Therefore, I couldn't reproduce kernel panic.
 >> I will really appreciate it if someone test this patch.
 >
 > So, someone reported this issue and you _think_ you know what went
 > wrong.  But, you can't reproduce the issue so it sounds like you're not
 > confident if this is the right fix or if you are fixing the right
 > problem in the first place.
 >
 > We can certainly apply obvious fixes, but it would be *really* nice if
 > you could try a bit harder to reproduce this.

Yes, you're right.
I'm so sorry for this careless testing.
I think I didn't use enough time for making the reproducer environment.
I will try to make a proper environment for this work.

Thank you so much!
Taehee Yoo
