Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB511C4332E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 20:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9AF820781
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 20:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgCTUZQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 16:25:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37039 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgCTUZQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 16:25:16 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFOCA-0003F1-0T; Fri, 20 Mar 2020 21:24:42 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7019C1039FC; Fri, 20 Mar 2020 21:24:41 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "maintainer\:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Gross <mgross@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-edac@vger.kernel.org,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [patch 01/22] x86/devicetable: Move x86 specific macro out of generic code
In-Reply-To: <CAHp75Vca0j0=EB2qdvGgFOq2s_ohHUEzY4OeNrv-oynLBVYh1w@mail.gmail.com>
References: <20200320131345.635023594@linutronix.de> <20200320131508.736205164@linutronix.de> <CAHp75Vca0j0=EB2qdvGgFOq2s_ohHUEzY4OeNrv-oynLBVYh1w@mail.gmail.com>
Date:   Fri, 20 Mar 2020 21:24:41 +0100
Message-ID: <87k13epyeu.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:
> On Fri, Mar 20, 2020 at 3:17 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>> --- a/arch/x86/include/asm/cpu_device_id.h
>> +++ b/arch/x86/include/asm/cpu_device_id.h
>> @@ -6,10 +6,21 @@
>>   * Declare drivers belonging to specific x86 CPUs
>>   * Similar in spirit to pci_device_id and related PCI functions
>>   */
>
>> -
>
> Seems you are going to remove below anyway in the next patches, so,
> why not to do this also there?
>
>>  #include <linux/mod_devicetable.h>

No it stays, but yes I could do that comment change right here.

Thanks,

        tglx


