Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C70C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 04:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EE0A2133D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 04:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ls04cxqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbfDKEHi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 00:07:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33653 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfDKEHi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 00:07:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id k19so2842760pgh.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Apr 2019 21:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vCZnK1YGILVHFO/a0hwwYCwLuG01n1Mx9qaIcaTGA6A=;
        b=Ls04cxqNCHzTeiQ1co/qlUSvBalKmvmyCLl3I9imFeU6SacM6K+txBXHzPNlWI8zIw
         T9uofBQx9+mOJyRQgm9p5rUtzAlyKUJOePYgTra2d9R6QDFzAJgG6/QET1OlOcOFJvaU
         z5Is6m/6D/iass9KojwQzlSCIvX/KkxsOaJx118GBf18oH2DZMOCQSh8ZSilrYv2XuZE
         qOKbUc4KURv/OYyjo1soHlcOFW55hnrN8x3+EB6ov6cIoy9Zv/MIX9aLwOuMYtzcjIVT
         3+ZBa8ybzQ4OXgvNJtN4suXmw3KlIt5DWvbIi2HFAJC9vMGjoNvFRWz5892nT5kEdrS5
         ng8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vCZnK1YGILVHFO/a0hwwYCwLuG01n1Mx9qaIcaTGA6A=;
        b=g5+N//crfXmAWgsDBLnF4UF0mKr1XcyFuZ6SG25sArC1h8BKBllbicBH9q2OJHaFGM
         by0+zI+8v7ncS2EhJqaCYkvz7uOxNDDT1GOzm5epNJVnEv3WIKmH5Z84gfL+gI3alDiA
         BoidGFFdkCKKwqN3YvyWVypn6A7cffsrNbu/ruZdA+M6mxzkwUNR9VTnn30zSmE5sZ+1
         c+LwL4PY3RZ+O2py+FFd2UWj9gvHt40jSl+/tcTGByVpjCyzH7g2aDkvYzFLTIgsUfeF
         JgFaUpsBFgAUDUEmIJ08PWEympHuUn4/OgIVpH5lXceXrZJF6ggPpSCrxq1cSJodizTG
         Vafg==
X-Gm-Message-State: APjAAAWYi3ciXwAhK79lJC0K5PDV3/qjU/sMj3lGoTQv4THG+0JU/ivB
        sUu+BhgHwEmSPMqPH+Sifs4=
X-Google-Smtp-Source: APXvYqzQnAnfV+N/i0Gs5chaXNLTjJGc2i+dUYHCFxRhk3NJieRCuFNWg/FyPSjYmBjEfGqCCTyaWw==
X-Received: by 2002:a63:2208:: with SMTP id i8mr44051403pgi.223.1554955657392;
        Wed, 10 Apr 2019 21:07:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w11sm25670860pfi.37.2019.04.10.21.07.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 21:07:36 -0700 (PDT)
Date:   Wed, 10 Apr 2019 21:07:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
Subject: Re: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead
 multiple variables
Message-ID: <20190411040734.GA2292@roeck-us.net>
References: <20190329130956.15935-1-bigeasy@linutronix.de>
 <20190329130956.15935-2-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329130956.15935-2-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sebastian,

On Fri, Mar 29, 2019 at 02:09:56PM +0100, Sebastian Andrzej Siewior wrote:
> Two per-CPU variables are allocated as pointer to per-CPU memory which
> then are used as scratch buffers.
> We could be smart about this and use instead a per-CPU struct which
> contains the pointers already and then we need to allocate just the
> scratch buffers.
> Add a lock to the struct. By doing so we can avoid the get_cpu()
> statement and gain lockdep coverage (if enabled) to ensure that the lock
> is always acquired in the right context. On non-preemptible kernels the
> lock vanishes.
> It is okay to use raw_cpu_ptr() in order to get a pointer to the struct
> since it is protected by the spinlock.
> 
> The diffstat of this is negative and according to size scompress.o:
>    text    data     bss     dec     hex filename
>    1847     160      24    2031     7ef dbg_before.o
>    1754     232       4    1990     7c6 dbg_after.o
>    1799      64      24    1887     75f no_dbg-before.o
>    1703      88       4    1795     703 no_dbg-after.o
> 
> The overall size increase difference is also negative. The increase in
> the data section is only four bytes without lockdep.
> 

Unfortunately, this patch causes random crashes.

[   13.084225] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[   13.084687] Mem abort info:
[   13.084821]   ESR = 0x96000044
[   13.085008]   Exception class = DABT (current EL), IL = 32 bits
[   13.085189]   SET = 0, FnV = 0
[   13.085331]   EA = 0, S1PTW = 0
[   13.085468] Data abort info:
[   13.086018]   ISV = 0, ISS = 0x00000044
[   13.086185]   CM = 0, WnR = 1
[   13.086379] [0000000000000000] user address but active_mm is swapper
[   13.087032] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[   13.087322] Modules linked in:
[   13.087645] Process cryptomgr_test (pid: 165, stack limit = 0x(____ptrval____))
[   13.088038] CPU: 1 PID: 165 Comm: cryptomgr_test Not tainted 5.1.0-rc4-next-20190410 #1
[   13.088250] Hardware name: ZynqMP ZCU102 Rev1.0 (DT)
[   13.088530] pstate: 80000005 (Nzcv daif -PAN -UAO)
[   13.088740] pc : __memcpy+0xc0/0x180
[   13.088887] lr : scatterwalk_copychunks+0xd4/0x1e8
[   13.089033] sp : ffff000012f2ba50
[   13.089139] x29: ffff000012f2ba50 x28: ffff80007a7c0500 
[   13.089324] x27: 0000000000000000 x26: ffff000012f2bae8 
[   13.089460] x25: 0000000000000046 x24: 0000000000000046 
[   13.089643] x23: ffff80007a004440 x22: 0000000000000046 
[   13.089815] x21: 0000000000000000 x20: 000081ffffffffff 
[   13.089974] x19: 0000000000000000 x18: 00000000000007ff 
[   13.090111] x17: 0000000000000000 x16: 0000000000000000 
[   13.090264] x15: ffff0000130ff748 x14: 0000000000000000 
[   13.090414] x13: ffff000011c509e8 x12: ffff000011a46980 
[   13.090569] x11: ffff000011a46000 x10: 0000000000000001 
[   13.090736] x9 : 0000000000000000 x8 : 20646e6120776f6e 
[   13.090885] x7 : 207375206e696f4a x6 : 0000000000000000 
[   13.091022] x5 : ffff0000117bf808 x4 : 0000000000000000 
[   13.091168] x3 : 0000000000000000 x2 : ffffffffffffffc6 
[   13.091313] x1 : ffff80007a62e610 x0 : 0000000000000000 
[   13.091554] Call trace:
[   13.091682]  __memcpy+0xc0/0x180
[   13.091810]  scatterwalk_map_and_copy+0x88/0xf0
[   13.091956]  scomp_acomp_comp_decomp+0x94/0x140
[   13.092083]  scomp_acomp_compress+0x10/0x18
[   13.092201]  test_acomp+0x158/0x5c0
[   13.092307]  alg_test_comp+0x298/0x440
[   13.092420]  alg_test.part.8+0xbc/0x398
[   13.092542]  alg_test+0x3c/0x68
[   13.092642]  cryptomgr_test+0x44/0x50
[   13.092754]  kthread+0x128/0x130
[   13.092867]  ret_from_fork+0x10/0x18
[   13.093158] Code: 14000028 f1020042 5400024a a8c12027 (a88120c7) 

This is seen with an arm64 image running on qemu with machine xlnx-zcu102
and two CPUs, and crypto test options enabled. It happens roughly every
other boot. Reverting the patch fixes the problem. Bisect log (from
crypto/master) is attached.

Guenter

---
# bad: [eda69b0c06bc615f4b055d560ed19001619e611a] crypto: testmgr - add panic_on_fail module parameter
# good: [9e98c678c2d6ae3a17cb2de55d17f69dddaa231b] Linux 5.1-rc1
git bisect start 'HEAD' 'v5.1-rc1'
# good: [52c899ec472e88e33c31c33bea844217c0963a05] crypto: ccp - Make ccp_register_rsa_alg static
git bisect good 52c899ec472e88e33c31c33bea844217c0963a05
# good: [6a4d1b18ef00a7b182740b7b4d8a0fcd317368f8] crypto: scompress - return proper error code for allocation failure
git bisect good 6a4d1b18ef00a7b182740b7b4d8a0fcd317368f8
# bad: [307508d1072979f4435416f87936f87eaeb82054] crypto: crct10dif-generic - fix use via crypto_shash_digest()
git bisect bad 307508d1072979f4435416f87936f87eaeb82054
# bad: [8316da02e3e07b0da9b2d812a619b5513c7f59d2] crypto: ccp - Use kmemdup in ccp_copy_and_save_keypart()
git bisect bad 8316da02e3e07b0da9b2d812a619b5513c7f59d2
# bad: [61abc356bf310d346d2d469cb009f6d4334f34de] crypto: aes - Use ___cacheline_aligned for aes data
git bisect bad 61abc356bf310d346d2d469cb009f6d4334f34de
# bad: [71052dcf4be70be4077817297dcde7b155e745f2] crypto: scompress - Use per-CPU struct instead multiple variables
git bisect bad 71052dcf4be70be4077817297dcde7b155e745f2
# first bad commit: [71052dcf4be70be4077817297dcde7b155e745f2] crypto: scompress - Use per-CPU struct instead multiple variables
