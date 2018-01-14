From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [cryptodev:master 130/134] aes_generic.c:undefined reference to `_restgpr_31_x'
Date: Sun, 14 Jan 2018 22:40:36 +0100
Message-ID: <CAK8P3a30k-JjMJ0M9KWXqUMT3eHmuuFvAe1KuKdqNoAiSZrgog@mail.gmail.com>
References: <201801122249.RHvvGQJ6%fengguang.wu@intel.com> <CAK8P3a0Rfbo=wJgEAm3vVFY1MpPWLE3HMGcUdoOXxqOVm8jRyw@mail.gmail.com>
 <20180112163946.GE21977@gate.crashing.org> <CAK8P3a39=PVpwiSk_3CjRnYBawhXqMatHKSsHCd2KHCgR+Zmyg@mail.gmail.com>
 <20180112204154.GM21977@gate.crashing.org> <CAK8P3a2YVVseBFNoDbwOtqR3-JHFuZ-WZD6-PzztNTO_X_soaw@mail.gmail.com>
 <20180112214111.GQ21977@gate.crashing.org> <CAK8P3a3XKwrVpXH9=8n1=qAKtqHE+1sh6OhaJ_39GZcWSP-j=Q@mail.gmail.com>
 <20180112221050.GR21977@gate.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Segher Boessenkool <segher@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:37863 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752491AbeANVkh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Jan 2018 16:40:37 -0500
Received: by mail-oi0-f41.google.com with SMTP id e144so7132050oib.4
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jan 2018 13:40:37 -0800 (PST)
In-Reply-To: <20180112221050.GR21977@gate.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 12, 2018 at 11:10 PM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
> On Fri, Jan 12, 2018 at 10:45:31PM +0100, Arnd Bergmann wrote:
>> > I guess you could enable the _x routines whenever you use ubsan?  Ubsan
>> > will cause much bigger code growth than the handful of insns in those
>> > routines?
>>
>> Right, that could work, too. My patch that Herbert merged intentionally
>> used -Os also for non-UBSAN builds because it turned out to
>> be much faster (see gcc PR83651),
>
> "Much"?
>
> -Os is *slower* with 8.0, 5% faster with 7.2, 4% faster with 7.1,
> slower with 7.0 and 6.3.  Your numbers, #c1.
>
> Anf this is the generic code of course, which is slow anyway (not to
> mention insecure).

Right. I've done some more investigation anyway, starting over with the
analysis of the gcc options that change it. I've found now that turning
off '-fcode-hoisting' but leaving on the other options I had suspected
earlier (-O2 instead of -Os, -ftree-sra, -ftree-pre) also fixes the
stack problem, and appears to result in the best performance so
far. I need to rerun the whole test matrix, but that seems rather
promising, and the result may also help debug what's really happening.

       Arnd
