Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D503AC5519F
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 10:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72ED122202
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 10:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=openvpn.net header.i=@openvpn.net header.b="MgM5nsMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgKQKQp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 05:16:45 -0500
Received: from smtp114.iad3a.emailsrvr.com ([173.203.187.114]:56234 "EHLO
        smtp114.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727188AbgKQKQp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 05:16:45 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2020 05:16:44 EST
Received: from smtp78.iad3a.emailsrvr.com (relay.iad3a.rsapps.net [172.27.255.110])
        by smtp7.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTPS id 1524C4390
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 05:07:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1605607660;
        bh=OoSt4zI/A55xd2DmFGEKW06kRreOILROaH9aCHdoT70=;
        h=To:From:Subject:Date:From;
        b=MgM5nsMqzl6NvYT70GkQLaNWEi3sv6HhVY8rhkLkqN81v03JT1oBZOuJ2UfFwEVr2
         fibYI7U9518Oi7nddW/kZVDex+x4jI0IZX3B5Kjx1oHVHupMKDN5cjk6CQnBtJMLiy
         uxayVsr7qFYgGoAprmv/CNMmsxuSOhMplBYvx0Eg=
X-Auth-ID: antonio@openvpn.net
Received: by smtp26.relay.iad3a.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 8742A1A17;
        Tue, 17 Nov 2020 05:07:38 -0500 (EST)
To:     Ard Biesheuvel <ardb@kernel.org>, Antonio Quartulli <a@unstable.cc>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        wireguard@lists.zx2c4.com,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201117021839.4146-1-a@unstable.cc>
 <CAMj1kXFxk31wtD3H8V0KbMd82UL_babEWpVTSkfqPpNjSqPNLA@mail.gmail.com>
 <5096882f-2b39-eafb-4901-0899783c5519@unstable.cc>
 <CAMj1kXGZATR7XyFb2SWiAxcBCUzXgvojvgR9fHczEu9zrpF9ug@mail.gmail.com>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
Subject: Re: [PATCH cryptodev] crypto: lib/chacha20poly1305 - allow users to
 specify 96bit nonce
Message-ID: <47819bd4-3bed-d7e5-523a-6ec5c70caad8@openvpn.net>
Date:   Tue, 17 Nov 2020 11:06:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGZATR7XyFb2SWiAxcBCUzXgvojvgR9fHczEu9zrpF9ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Classification-ID: 3c7d4df9-03f3-4138-8fe9-03b0ab2b7cbf-1-2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 17/11/2020 10:52, Ard Biesheuvel wrote:
> On Tue, 17 Nov 2020 at 10:47, Antonio Quartulli <a@unstable.cc> wrote:
>>
>> Hi,
>>
>>
>> On 17/11/2020 09:31, Ard Biesheuvel wrote:
>>> If you are going back to the drawing board with in-kernel acceleration
>>> for OpenVPN, I strongly suggest to:
>>> a) either stick to one implementation, and use the library interface,
>>> or use dynamic dispatch using the crypto API AEAD abstraction, which
>>> already implements 96-bit nonces for ChaCha20Poly1305,
>>
>> What we are implementing is a simple Data Channel Offload, which is
>> expected to be compatible with the current userspace implementation.
>> Therefore we don't want to change how encryption is performed.
>>
>> Using the crypto API AEAD abstraction will be my next move at this point.
>>
> 
> Aren't you already using that for gcm(aes) ?

Yes, correct. That's why I had no real objection to using it :-)

At first I was confused and I thought this new library interface was
"the preferred way" for using chacha20poly1305, therefore I went down
this path.

> 
>> I just find it a bit strange that an API of a well defined crypto schema
>> is implemented in a way that accommodates only some of its use cases.
>>
> 
> You mean the 64-bit nonce used by the library version of
> ChaCha20Poly1305? I agree that this is a bit unusual, but a library
> interface doesn't seem like the right abstraction for this in the
> first place, so I guess it is irrelevant.

Alright.

> 
>>
>> But I guess it's accepted that we will have to live with two APIs for a bit.
>>
>>
>>> b) consider using Aegis128 instead of AES-GCM or ChaChaPoly - it is
>>> one of the winners of the CAESAR competition, and on hardware that
>>> supports AES instructions, it is extremely efficient, and not
>>> encumbered by the same issues that make AES-GCM tricky to use.
>>>
>>> We might implement a library interface for Aegis128 if that is preferable.
>>
>> Thanks for the pointer!
>> I guess we will consider supporting Aegis128 once it gets standardized
>> (AFAIK it is not yet).
>>
> 
> It is. The CAESAR competition is over, and produced a suite of
> recommended algorithms, one of which is Aegis128 for the high
> performance use case. (Note that other variants of Aegis did not make
> it into the final recommendation)

oops, I was not up-to-date. Thanks again!
We'll definitely look into this soon.


Best Regards,

-- 
Antonio Quartulli
OpenVPN Inc.
