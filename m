From: Nicholas Piggin <nicholas.piggin@gmail.com>
Subject: Re: [PATCH V2 0/6] Enable NX 842 compression engine on Power9
Date: Tue, 18 Jul 2017 16:14:44 +1000
Message-ID: <20170718161444.72252c9c@roar.ozlabs.ibm.com>
References: <1500334999.995.6.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: mpe@ellerman.id.au, herbert@gondor.apana.org.au, mikey@neuling.org,
        suka@us.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, ddstreet@ieee.org
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36060 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdGRGSA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 02:18:00 -0400
Received: by mail-pg0-f65.google.com with SMTP id y129so1583446pgy.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 23:18:00 -0700 (PDT)
In-Reply-To: <1500334999.995.6.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 17 Jul 2017 16:43:19 -0700
Haren Myneni <haren@linux.vnet.ibm.com> wrote:

> [PATCH V2 0/6] Enable NX 842 compression engine on Power9
> 
> P9 introduces Virtual Accelerator Switchboard (VAS) to communicate
> with NX 842 engine. icswx function is used to access NX before.
> On powerNV systems, NX-842 driver invokes VAS functions for
> configuring RxFIFO (receive window) per each NX engine. VAS uses
> this FIFO to communicate the request to NX. The kernel opens send
> window which is used to transfer compression/decompression requests
> to VAS. It maps the send window to the corresponding RxFIFO.
> copy/paste instructions are used to pass the CRB to VAS.
> 
> This patch series adds P9 NX support for 842 compression engine.
> First 4 patches reorganize the current code so that VAS function
> can be added.
> - nx842_powernv_function points to VAS function if VAS feature is
>   available. Otherwise icswx function is used.
> - Move configure CRB code nx842_cfg_crb() 
> - In addition to freeing co-processor structs for initialization 
>   failures and exit, both send and receive windows have to closed
>   for VAS.
> - Move updating coprocessor info list to nx842_add_coprocs_list().
> 
> The last 2 patches adds configuring and invoking VAS, and also
> checking P9 NX specific errors that are provided in co-processor
> status block (CSB) for failures.
> 
> Patches have been tested on P9 DD1 system using VAS changes and
> on P8 HW to make sure no regression.
> 
> This patchset depends on VAS kernel changes:
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-May/158178.html

Just a question, we no longer invalidate the copy buffer on context
switch after this patch:

07d2a628bc ("powerpc/64s: Avoid cpabort in context switch when possible")

If your vas address mappings are visible only to kernel, only used in
process / kthread context, and only used with kernel preemption disabled,
this is okay.

If userspace can possibly copy/paste to the mappings or if you need to
sleep or call this from interrupt context, we need to work out how to
invalidate the copy buffer.

Thanks,
Nick
