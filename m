Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED892EB64D7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 19:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjFTTJd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 15:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjFTTJb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 15:09:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC89B
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 12:09:30 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-25e89791877so2336803a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 12:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1687288170; x=1689880170;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytH528+6WpSb0dZHhh81EzPmGbD3lujTa1m5kVVR73U=;
        b=Vg7aRJiobSB8vabvycHKxt9jE2Zod2WVtG+dK8ZV/AkXk074E7eGpkxQ8ePIp35vEh
         pDsjlWfj3tK6z0wZ1HtQ8O9vrEklZ2CoKxKPcwPuA4QWzQySfxnycGv48wnVht6n8CvJ
         Jnb8/hsYpeX2PHzTgFGK+NhgCTcZsLANNcuWlJbyPsMElPzb+C+K/8znFfqWHlQfiGaU
         W8L7VIjSSTD9MJqC4BlkBIyfwMgVdyHOjJvo+EKKJdMZA1saAfIZ/vIYB0k6WoCIXKMM
         u/LmeBaQIKzhff8qH3wnigbi9pDYb2AizucCgP+oYvfFdENBb4xiPdWRKh8DdlTNSCtd
         ROfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687288170; x=1689880170;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytH528+6WpSb0dZHhh81EzPmGbD3lujTa1m5kVVR73U=;
        b=MmsVGTvJHu9vS2O/IpCbjEPkbzIgRygywC5f8aLsQNLw/cDdEVfoARmmVA4WRTtfrt
         K4kdiJjXPUpHoAD3y7+e4H4ntyBdVUPkgCX6q3z6W03/Os6LMT306Qbl1PsjkKlK6b0e
         jRnB+bq313GBOvOOFa4o7SyI9V1BmTddXbs+74SnNagKIZTnBInL9LOLWT+c7uCtac8U
         XKADram6gmDZwx2nJiOoCPhNCR3zmb4uLeNW+6twr7rxTCs1cvaT0zeAyIHtxzd5ZlEv
         dwo/p8Dcb4RpvjRs9uyMuTsNC3rikzr1lsOR8O1XKiEubmUDpKOIy57fSSEzQkXhaZW9
         MN7A==
X-Gm-Message-State: AC+VfDwJF6gl0SV5Z0Ew3tUnhHov0o3I0en0t7Cr4lpQBC2FMF9xQ9Or
        Z/YpM0HoyL38cF5k3MKW2y1EVA==
X-Google-Smtp-Source: ACHHUZ72JLPQLZAYpsNebvtJdqti/7re0M1kuGAadWiHswxLCmxzbR3HDZS0v6hY64vy34weYmzHGQ==
X-Received: by 2002:a17:90a:43e5:b0:25e:d013:c22c with SMTP id r92-20020a17090a43e500b0025ed013c22cmr5639863pjg.47.1687288169637;
        Tue, 20 Jun 2023 12:09:29 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090b078200b00259b53dccddsm1813287pjz.34.2023.06.20.12.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 12:09:28 -0700 (PDT)
Date:   Tue, 20 Jun 2023 12:09:28 -0700 (PDT)
X-Google-Original-Date: Tue, 20 Jun 2023 12:08:47 PDT (-0700)
Subject:     Re: [PATCH v5 1/4] RISC-V: add Zbc extension detection
In-Reply-To: <20230612-unstable-tilt-1835f84363b1@spud>
CC:     heiko@sntech.de, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
        davem@davemloft.net, Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, christoph.muellner@vrull.eu,
        heiko.stuebner@vrull.eu
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Conor Dooley <conor@kernel.org>
Message-ID: <mhng-919a6ed5-c8b0-4311-9a8f-8c204b81a8e0@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Jun 2023 14:31:14 PDT (-0700), Conor Dooley wrote:
> Hey Heiko,
>
> On Mon, Jun 12, 2023 at 11:04:39PM +0200, Heiko Stuebner wrote:
>> From: Heiko Stuebner <heiko.stuebner@vrull.eu>
>> 
>> Add handling for Zbc extension.
>> 
>> Zbc provides instruction for carry-less multiplication.
>> 
>> Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
>> ---
>>  arch/riscv/Kconfig             | 22 ++++++++++++++++++++++
>>  arch/riscv/include/asm/hwcap.h |  1 +
>>  arch/riscv/kernel/cpu.c        |  1 +
>>  arch/riscv/kernel/cpufeature.c |  1 +
>>  4 files changed, 25 insertions(+)
>
> Plumbing into the hwprobe stuff would be nice, but that's not a
> requirement for getting stuff merged :)

IIRC we talked about this on IRC, but IMO we shouldn't require something 
be user visible for it to be merged in the kernel.

>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index a3d54cd14fca..754cd154eca5 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -523,6 +523,28 @@ config RISCV_ISA_ZBB
>>  
>>  	   If you don't know what to do here, say Y.
>>  
>> +config TOOLCHAIN_HAS_ZBC
>> +	bool
>> +	default y
>> +	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbc)
>> +	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbc)
>> +	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
>> +	depends on AS_IS_GNU
>> +
>> +config RISCV_ISA_ZBC
>> +	bool "Zbc extension support for bit manipulation instructions"
>> +	depends on TOOLCHAIN_HAS_ZBC
>> +	depends on !XIP_KERNEL && MMU
>> +	default y
>> +	help
>> +	   Adds support to dynamically detect the presence of the ZBC
>
> Nit: s/ZBC/Zbc/
>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>
> Cheers,
> Conor.
