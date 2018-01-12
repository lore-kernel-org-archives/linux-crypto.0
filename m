From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [cryptodev:master 130/134] aes_generic.c:undefined reference to `_restgpr_31_x'
Date: Fri, 12 Jan 2018 22:29:01 +0100
Message-ID: <CAK8P3a2YVVseBFNoDbwOtqR3-JHFuZ-WZD6-PzztNTO_X_soaw@mail.gmail.com>
References: <201801122249.RHvvGQJ6%fengguang.wu@intel.com> <CAK8P3a0Rfbo=wJgEAm3vVFY1MpPWLE3HMGcUdoOXxqOVm8jRyw@mail.gmail.com>
 <20180112163946.GE21977@gate.crashing.org> <CAK8P3a39=PVpwiSk_3CjRnYBawhXqMatHKSsHCd2KHCgR+Zmyg@mail.gmail.com>
 <20180112204154.GM21977@gate.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, kbuild-all@01.org
To: Segher Boessenkool <segher@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:44074 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965067AbeALV3D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 16:29:03 -0500
Received: by mail-ot0-f194.google.com with SMTP id g59so6184166otg.11
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jan 2018 13:29:03 -0800 (PST)
In-Reply-To: <20180112204154.GM21977@gate.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 12, 2018 at 9:41 PM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
> On Fri, Jan 12, 2018 at 08:43:21PM +0100, Arnd Bergmann wrote:
>> On Fri, Jan 12, 2018 at 5:39 PM, Segher Boessenkool

>> We could theoretically work around it by turning that into
>> "#if defined(CONFIG_CC_OPTIMIZE_FOR_SIZE) ||
>> defined(CONFIG_CRYPTO_AES)", but that seems rather ugly.
>>
>> My earlier patch already tried to be more specific, turning very
>> specific optimizations off rather than moving from -O2 to -Os,
>> but that turned out to lead to significantly worse performance,
>> where -Os improved performance slightly. Is there a way
>> to ask powerpc compilers to use mostly -Os but not the
>> specific thing that makes it link to _restgpr_31_x?
>
> There is no such thing, sorry.  Would be very hard to implement, and
> older compilers will never get it, so it won't help you anyway :-(

We use -Os only for gcc-7.1 and higher, where it produces faster
code for AES and avoids running into
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356

> Maybe for now just enable it in crtsavres.S always, with a comment?
> That -Os workaround is hopefully not going to live long either...

It depends on whether or how soon someone comes up with a
better fix for PR83356.
gcc-8.0.0 is currently not affected by it, so we could limit the
workaround (and the hack in crtsavres.S) to gcc-7-only.

     Arnd
