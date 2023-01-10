Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9432CC54EBE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 03:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjAJDlw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 22:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjAJDlv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 22:41:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876B93C383
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 19:41:50 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id k19so7771456pfg.11
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2023 19:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOunmGsE6zoHdf/rvKc+p3Dc6IxSircpX69k/W1g6mM=;
        b=dQvfXnAUnxR9/8wFo6ZH1eFvZHOkVTrvtm+IrYbZhcRPUDfWJZJyXR+wfx0kiEAF1k
         7m5Loc9WKSSGvy9llRY375ARn1jn+8peFd9OQV2NSh9TZPPw5Vjvn2I7osktQebqCX+m
         /4rRIgl757N82v+D0ygq/9D14fBnJObMqhMWfL51DPptNGSq/zXZ/LCZ/P9QwSEfEeaQ
         xf0DvBAR/v4D+qOwzACK/ZS9UusAPfWQmwEzyimxZ1av/f7Os0tm83lSkRIBsrBJgp1/
         JPl13Pnc73o9otoZOGhpUqiu8B6q4FpODrROLlfMrI+arHhSGkiLjF7RjhzGbnhJGMxq
         lfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UOunmGsE6zoHdf/rvKc+p3Dc6IxSircpX69k/W1g6mM=;
        b=ArnBE0xppyLIJaVZcc9d08pmJJYAnqsyogWe5d2yv8wll3XGGbXd93aVTDsuEFEnh+
         bIVJin3BsI+afutc7NzHiQnECT3AZVa4duYoJQV0cAHvPdLYYHbrZNgr7A6q8qsxTRun
         waUTLUXzbf+VOxDIl2DB/3VpsG+eDTJJuoYcNrMUUd/Wbqt/j7kX/27AEyHFKAUFNdrl
         hsdNeO6RY+4H/JeeizcgIjX65P3SIz3EjeY1xMhi8ajeUDmTxGozfdE+WNTluoyH+RCE
         dhBdBnMM7Ru7YEwsVIA7sv7UduhEr/F6rg4qd5q7K+hE0HBFqPU8t4Wl5kOMRO7fUcig
         vW0Q==
X-Gm-Message-State: AFqh2korsOnDxHtnKN8UCMmUKvwY18VX9CebiWKSDPcTj7Yf8V5tNypO
        ZXMJKit10JZ2x0qAv0LRTS8=
X-Google-Smtp-Source: AMrXdXuPADiNMs8pl93i/nvApMOtvcp0kY3zkpak0DclM/cGUisjtOpnSq+NTi4MpLfZgtTiQN1CgA==
X-Received: by 2002:a05:6a00:981:b0:586:8ead:a8e8 with SMTP id u1-20020a056a00098100b005868eada8e8mr14444746pfg.8.1673322109932;
        Mon, 09 Jan 2023 19:41:49 -0800 (PST)
Received: from [172.25.138.193] ([203.246.171.161])
        by smtp.gmail.com with ESMTPSA id e18-20020aa79812000000b0058119caa82csm6776427pfl.205.2023.01.09.19.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 19:41:48 -0800 (PST)
Message-ID: <4395e670-5886-e219-32d9-130f066d56c4@gmail.com>
Date:   Tue, 10 Jan 2023 12:41:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: crypto: aria-avx - add AES-NI/AVX/x86_64/GFNI assembler
 implementation of aria cipher
To:     Jan Beulich <jbeulich@suse.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <5a07ddfd-eb8e-a9a1-6952-67fb45f2727e@suse.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <5a07ddfd-eb8e-a9a1-6952-67fb45f2727e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jan,
Thank you so much for the report!

On 2023. 1. 9. 오후 7:08, Jan Beulich wrote:
 > Hello,
 >
 > sadly I don't have the original thread to hand to reply, so this 
standalone
 > mail will need to do.
 >
 > The documented GNU binutils baseline for the kernel (6.1) is 2.23, 
yet this
 > new drivers uses GFNI unconditionally. This breaks with any pre-2.30 gas.
 >
 > Regards, Jan

I tested to build with the binutils 2.26.1 and I found a failure as you 
mentioned.

   AS [M]  arch/x86/crypto/aria-aesni-avx-asm_64.o
arch/x86/crypto/aria-aesni-avx-asm_64.S: Assembler messages:
arch/x86/crypto/aria-aesni-avx-asm_64.S:1101: Error: no such 
instruction: `vgf2p8affineinvqb $(( 
(((0)&1)<<0)|(((1)&1)<<1)|(((0)&1)<<2)|(((0)&1)<<3)|(((0)&1)<<4)|(((1)&1)<<5)|(((1)&1)<<6)|(((1)&1)<<7))),%xmm0,%xmm9,%xmm9'
arch/x86/crypto/aria-aesni-avx-asm_64.S:1101: Error: no such 
instruction: `vgf2p8affineinvqb $(( 
(((0)&1)<<0)|(((1)&1)<<1)|(((0)&1)<<2)|(((0)&1)<<3)|(((0)&1)<<4)|(((1)&1)<<5)|(((1)&1)<<6)|(((1)&1)<<7))),%xmm0,%xmm13,%xmm13'
arch/x86/crypto/aria-aesni-avx-asm_64.S:1101: Error: no such 
instruction: `vgf2p8affineqb $(( 
(((1)&1)<<0)|(((0)&1)<<1)|(((1)&1)<<2)|(((0)&1)<<3)|(((0)&1)<<4)|(((0)&1)<<5)|(((0)&1)<<6)|(((0)&1)<<7))),%xmm1,%xmm10,%xmm10'
arch/x86/crypto/aria-aesni-avx-asm_64.S:1101: Error: no such 
instruction: `vgf2p8affineqb $(( 
(((1)&1)<<0)|(((0)&1)<<1)|(((1)&1)<<2)|(((0)&1)<<3)|(((0)&1)<<4)|(((0)&1)<<5)|(((0)&1)<<6)|(((0)&1)<<7))),%xmm1,%xmm14,%xmm14'

My plan is to use AS_* macro such as AS_AVX512 to disable building code 
that uses GFNI.
So, I may add AS_GFNI for this.

Thank you so much again for the report!
Taehee Yoo
