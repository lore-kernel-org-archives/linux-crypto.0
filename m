From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to ASM_EXPORT
Date: Mon, 24 Apr 2017 09:04:19 +0100
Message-ID: <CAKv+Gu8bpEiM_idZeJBpAvqBy-a7+ivQmoyuYHW-Z05rZHNhkA@mail.gmail.com>
References: <20170405183458.193068-1-mka@chromium.org> <CAP=VYLpejcYwXUMtCCkXmjXw=T1tBJLn21aVi-9v_VGmEinjRg@mail.gmail.com>
 <CAKv+Gu_DHBT=2YA9h+ao3pZXgEV5KsO9ia+J90wtLuDX=a4+eg@mail.gmail.com>
 <20170418173401.GA128305@google.com> <20170424080056.GA20285@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matthias Kaehlcke <mka@chromium.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Hackmann <ghackmann@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38686 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166363AbdDXIGO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 04:06:14 -0400
Received: by mail-it0-f52.google.com with SMTP id e132so45067514ite.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Apr 2017 01:06:14 -0700 (PDT)
In-Reply-To: <20170424080056.GA20285@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 April 2017 at 09:00, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Apr 18, 2017 at 10:34:01AM -0700, Matthias Kaehlcke wrote:
>> El Tue, Apr 18, 2017 at 04:35:02PM +0100 Ard Biesheuvel ha dit:
>>
>> > On 18 April 2017 at 15:47, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>> > > On Wed, Apr 5, 2017 at 2:34 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
>> > >> The operand is an integer constant, make the constness explicit by
>> > >> adding the modifier. This is needed for clang to generate valid code
>> > >> and also works with gcc.
>> > >
>> > > Actually it doesn't work with all gcc.  I've got an older arm64 toolchain that I
>> > > only use for syntax checking (and hence I don't care if it is the latest and
>> > > greatest) and this commit breaks it:
>> > >
>> > > arch/arm64/crypto/sha1-ce-glue.c:21:2: error: invalid 'asm': invalid
>> > > operand prefix '%c'
>> > >   asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
>>
>> Sorry about that :(
>
> So what's the consensus? Should I revert this patch?
>

Yes please.
