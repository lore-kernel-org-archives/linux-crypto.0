Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3E5C77B73
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Apr 2023 11:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243694AbjD0LZh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243722AbjD0LZf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Apr 2023 07:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E08A5FDB;
        Thu, 27 Apr 2023 04:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D081563BC6;
        Thu, 27 Apr 2023 11:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A4C433EF;
        Thu, 27 Apr 2023 11:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682594701;
        bh=OzHT2qTnSZ/6rYXPLMQadBazAPcPJebviyobz9E7whE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=aJPmoZ17dQ73Ug2IUwCqoxjDTxPx9zMuQsrD9UBTnRHOXJrPMnB7IJBSleExAS1IN
         NXYePCad8txcaRNN+9Kk/gc79S7QdE8Z1ddbQ4GvBYwaJ0P0lyZ+5wRlNHK20+YP7y
         PZsASASJEsd01fDIwGh6x8ImfhrftlDGDom4jBDdFm80zq8faeriS8VVnmwld1iEHr
         xwmqGDzFeXl8UaD5VlwsGlq/5XUD0HmybYIQo/XOc4gYG5R3yCyBeeETNPXHeKH3Ya
         b5iqyCc1BGcTwbwtKjk323DB8VOBBHW/u4wehct6e2PUm75ajivs3ESk8JxR2OWRyK
         PFM55Tzy/LI+A==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Sunil V L <sunilvl@ventanamicro.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Len Brown <lenb@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marc Zyngier <maz@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH V4 05/23] ACPI: OSL: Make should_use_kmap() 0 for RISC-V
In-Reply-To: <ZEpAHfccImGsJGjk@sunil-laptop>
References: <20230404182037.863533-1-sunilvl@ventanamicro.com>
 <20230404182037.863533-6-sunilvl@ventanamicro.com>
 <87a5yua8vb.fsf@all.your.base.are.belong.to.us>
 <ZEpAHfccImGsJGjk@sunil-laptop>
Date:   Thu, 27 Apr 2023 13:24:58 +0200
Message-ID: <87leidtvn9.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sunil V L <sunilvl@ventanamicro.com> writes:

>> An observation, which can be addressed later; The acpi_os_ioremap()
>> (called when the config above is enabled for RV), does not have an arch
>> specific implementation for RISC-V. The generic one calls
>> ioremap_cached(), which on RISC-V defaults to ioremap() -- caching
>> disabled/_PAGE_IO.
>> 
>> That is probably not what we want, but rather something similar that
>> arm64 does.
>> 
> Actually, for RISC-V acpi_os_ioremap() is currently a wrapper around
> memremap(). Sure, this can be enhanced in future if required.

Yeah, realized that when I continued thru the series!

Thanks for clearing it up!
