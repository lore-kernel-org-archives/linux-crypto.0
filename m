Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D4CEB64D8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 19:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjFTTmW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 15:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjFTTmQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 15:42:16 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2CB172B
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 12:42:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b55643507dso25217245ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 12:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1687290131; x=1689882131;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KHU5CwA5u8pSrmDppHcT4qFU7dGFryoenZ6OqORvEs8=;
        b=F/4PvAGbsDJNMQNZRVwv4lMqDOI41XUjCyn+5TQG4/s17oVEsd/Cihbm/Sxav0pkON
         pbv+U1N1KxMshXDXoW0C1j7II1qehV4llRKEAU8f8IVNfBRrhB739/AtdkiR4SbEkkCC
         R4teCwxSranNzpKONPzRHai9FyQf+zBbHejZUcNu5JtGkDDxcwRaoFlUMXm4sVwudHyC
         sTzdUjL+NShCSigwrAroMAwD29HI4El1WLCPgJrbam8yzZDr7ogsO/PvbAfbzmrCQKTN
         bAk1Jj6SmKaaHKM566zCi6lNRuDtsbc6lXb+mV8AyeA0qaVlJK1yd8SMdgEy988DbhFE
         33ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687290131; x=1689882131;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHU5CwA5u8pSrmDppHcT4qFU7dGFryoenZ6OqORvEs8=;
        b=CPDPVClX2CGJfH9C6caZVPdPhCgXm+AK0U+fAlPV18lY+V6UPWv5wflA3CkZ82JYn/
         9bMs7YwTZgDuDYI8e+me4iQIDlYNwb8x4QpsNg38lRnPXZQeZtpCXVIk9gj2fZuTp4nM
         X0Fe0gNMF4ITn2eVFRGTUa6a+Kgzc0TniUaf5v7rMlA6flYxD3ljMdsIijQueeTLx7I7
         2y44zBqjwzHdelYqL2vCL/9a37TunCaYsGNPGuf92z3A3Za6mRJ6VGuUz1taa4L2vXgz
         qdpJPLk0ezFongMzyGJ+eFLl0R/wkq3QdZqCQG7tyj4w0er9+9U7LcfZwwClEeHTZumK
         nJzQ==
X-Gm-Message-State: AC+VfDzS9/gBK7AT7mjQF3p8XDxrD+kVwzQ7DQVfbiJGSRhJJfraMvDc
        RA38CN3njx8q2Lgkx/q2HZnqpw==
X-Google-Smtp-Source: ACHHUZ7M5H+Lb2l7RjrGwDbavqFd07Q1CmIGajRPCoPGx5ZVej4nFjxGA1fiO3QiDimYzv6xtZ1t2A==
X-Received: by 2002:a17:903:48a:b0:1b5:cbc:b4c with SMTP id jj10-20020a170903048a00b001b50cbc0b4cmr12337830plb.46.1687290131574;
        Tue, 20 Jun 2023 12:42:11 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id jm2-20020a17090304c200b001b558c37f91sm1950372plb.288.2023.06.20.12.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 12:42:11 -0700 (PDT)
Date:   Tue, 20 Jun 2023 12:42:11 -0700 (PDT)
X-Google-Original-Date: Tue, 20 Jun 2023 12:41:31 PDT (-0700)
Subject:     Re: [PATCH v5 1/4] RISC-V: add Zbc extension detection
In-Reply-To: <75cf8335-af1f-e06c-c770-b2b540e812ed@ventanamicro.com>
CC:     Conor Dooley <conor@kernel.org>, heiko@sntech.de,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
        davem@davemloft.net, Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, christoph.muellner@vrull.eu,
        heiko.stuebner@vrull.eu
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Jeff Law <jlaw@ventanamicro.com>
Message-ID: <mhng-5286e1ed-b3ae-40ce-bd33-8871a1a07f3a@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 20 Jun 2023 12:37:00 PDT (-0700), Jeff Law wrote:
>
>
> On 6/20/23 13:09, Palmer Dabbelt wrote:
>> On Mon, 12 Jun 2023 14:31:14 PDT (-0700), Conor Dooley wrote:
>>> Hey Heiko,
>>>
>>> On Mon, Jun 12, 2023 at 11:04:39PM +0200, Heiko Stuebner wrote:
>>>> From: Heiko Stuebner <heiko.stuebner@vrull.eu>
>>>>
>>>> Add handling for Zbc extension.
>>>>
>>>> Zbc provides instruction for carry-less multiplication.
>>>>
>>>> Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
>>>> ---
>>>>  arch/riscv/Kconfig             | 22 ++++++++++++++++++++++
>>>>  arch/riscv/include/asm/hwcap.h |  1 +
>>>>  arch/riscv/kernel/cpu.c        |  1 +
>>>>  arch/riscv/kernel/cpufeature.c |  1 +
>>>>  4 files changed, 25 insertions(+)
>>>
>>> Plumbing into the hwprobe stuff would be nice, but that's not a
>>> requirement for getting stuff merged :)
>>
>> IIRC we talked about this on IRC, but IMO we shouldn't require something
>> be user visible for it to be merged in the kernel.
> Note that exposing Zbc is potentially useful.  We've got GCC and LLVM
> code that can detect and rewrite a bitwise CRC into clmul.

Ya, there's another thread about adding it.  IMO we should do so, just 
that we shouldn't gate kernel support on also sorting out the uABI as 
sometimes that's complicated.

It's simple for this one, though, so I'm not opposed to taking it for 
the merge window if it shows up in the next day or two...

>
> Jeff
