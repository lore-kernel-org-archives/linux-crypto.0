From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [RESEND PATCH 3/6] ARM: dts: imx7s: add CAAM device node
Date: Wed, 24 Jan 2018 22:56:45 +0000
Message-ID: <08d9947e-4d2b-61f1-c8ed-0e1350025f76@nexus-software.ie>
References: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
 <1516805435-15034-4-git-send-email-pure.logic@nexus-software.ie>
 <1516817565.29323.74.camel@aisec.fraunhofer.de>
 <0b3c415f-64e4-1fcf-45ef-c447d65e8e89@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "peng.fan@nxp.com" <peng.fan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        "fabio.estevam@nxp.com" <fabio.estevam@nxp.com>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: "Auer, Lukas" <lukas.auer@aisec.fraunhofer.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aymen.sghaier@nxp.com" <aymen.sghaier@nxp.com>,
        "horia.geanta@nxp.com" <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:45029 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbeAXW4q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 17:56:46 -0500
Received: by mail-wm0-f54.google.com with SMTP id t74so11395434wme.3
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2018 14:56:46 -0800 (PST)
In-Reply-To: <0b3c415f-64e4-1fcf-45ef-c447d65e8e89@nexus-software.ie>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/01/18 22:48, Bryan O'Donoghue wrote:
>> The clock configuration has changed to just one CAAM-specific clock in
>> addition to the ahb clock. This also means that additional
>> modifications to the CAAM driver are necessary or it will complain that
>> it doesn't find all clocks.
> 
> Sure - but, those clock changes aren't merged to upstream just yet, so 
> we won't those changes to this DTS addition yet.
> 
> Thanks for the review.
> 
> ---
> bod

Ah Rui has pointed out to me for i.mx7 there are two clocks on on i.mx6 
there are four clocks.

The bit that confused me there was the clock names on the 4.1 tree you 
pointed to was clock-names = "caam_ipg", "caam_aclk"; and for 4.15 those 
should be "ipg" and "aclk" by the looks of it.

So yes.

We will add the second job-ring and subtract the two extraneous clocks.

---
bod
