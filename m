From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [RFC PATCH 6/6] dm-crypt: Add bulk crypto processing support
Date: Tue, 17 Jan 2017 12:15:59 +0100
Message-ID: <CAAUqJDuAKYbxNEEct7G+B8Rt4XpenXy2KCmBdfUuc5O-4UmShw@mail.gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com> <75887e6759ac308a017c83b7fa377516dcd5e2a3.1484215956.git.omosnacek@gmail.com>
 <CAHv-k_92j=C8AOzfFzyuiJO=NXWh=zP3=N8MqdyqSUUZf9Hzzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34480 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdAQLQW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 06:16:22 -0500
Received: by mail-lf0-f65.google.com with SMTP id q89so15812321lfi.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2017 03:16:21 -0800 (PST)
In-Reply-To: <CAHv-k_92j=C8AOzfFzyuiJO=NXWh=zP3=N8MqdyqSUUZf9Hzzw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Binoy,

2017-01-16 9:37 GMT+01:00 Binoy Jayan <binoy.jayan@linaro.org>:
> The initial goal of our proposal was to process the encryption requests with the
> maximum possible block sizes with a hardware which has automated iv generation
> capabilities. But when it is done in software, and if the bulk
> requests are processed
> sequentially, one block at a time, the memory foot print could be
> reduced even if
> the bulk request exceeds a page. While your patch looks good, there
> are couple of
> drawbacks one of which is the maximum size of a bulk request is a page. This
> could limit the capability of the crypto hardware. If the whole bio is
> processed at
> once, which is what qualcomm's version of dm-req-crypt does, it achieves an even
> better performance.

I see... well, I added the limit only so that the async fallback
implementation can allocate multiple requests, so they can be
processed in parallel, as they would be in the current dm-crypt code.
I'm not really sure if that brings any benefit, but I guess if some HW
accelerator has multiple engines, then this allows distributing the
work among them. (I wonder how switching to the crypto API's IV
generation will affect the situation for drivers that can process
requests in parallel, but do not support the IV generators...)

I could remove the limit and switch the fallback to sequential
processing (or maybe even allocate the requests from a mempool, the
way dm-crypt does it now...), but after Herbert's feedback I'm
probably going to scrap this patchset anyway...

>> Note that if the 'keycount' parameter of the cipher specification is set to a
>> value other than 1, dm-crypt still sends only one sector in each request, since
>> in such case the neighboring sectors are encrypted with different keys.
>
> This could be avoided if the key management is done at the crypto layer.

Yes, but remember that the only reasonable use-case for using keycount
!= 1 is mounting loop-AES partitions (which is kind of a legacy
format, so there is not much point in making HW drivers for it). It is
an unfortunate consequence of Milan's decision to make keycount an
independent part of the cipher specification (instead of making it
specific for the LMK mode), that all the other IV modes are now
'polluted' with the requirement to support it.

I discussed with Milan the possibility of deprecating the keycount
parameter (i.e. allowing only value of 64 for LMK and 1 for all the
other IV modes) and then converting the IV modes to skciphers (or IV
generators, or some combination of both). This would significantly
simplify the key management and allow for better optimization
strategies. However, I don't know if such change would be accepted by
device-mapper maintainers, since it may break someone's unusual
dm-crypt configuration...

Cheers,
Ondrej
