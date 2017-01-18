From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and dm-crypt
Date: Wed, 18 Jan 2017 22:39:45 +0530
Message-ID: <CAHv-k_-gcj8t8xw_iCrbq-Tt0zQP+O0s+EDGm5OJQVWFuX37cw@mail.gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com> <20170113104128.GA23497@gondor.apana.org.au>
 <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>
To: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34849 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdARRKK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2017 12:10:10 -0500
Received: by mail-ua0-f174.google.com with SMTP id y9so14219985uae.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2017 09:09:47 -0800 (PST)
In-Reply-To: <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Milan,

On 13 January 2017 at 17:31, Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com=
> wrote:
> 2017-01-13 11:41 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
>> On Thu, Jan 12, 2017 at 01:59:52PM +0100, Ondrej Mosnacek wrote:
>>> the goal of this patchset is to allow those skcipher API users that nee=
d to
>>> process batches of small messages (especially dm-crypt) to do so effici=
ently.
>>
>> Please explain why this can't be done with the existing framework
>> using IV generators similar to the ones used for IPsec.
>
> As I already mentioned in another thread, there are basically two reasons=
:
>
> 1) Milan would like to add authenticated encryption support to
> dm-crypt (see [1]) and as part of this change, a new random IV mode
> would be introduced. This mode generates a random IV for each sector
> write, includes it in the authenticated data and stores it in the
> sector's metadata (in a separate part of the disk). In this case
> dm-crypt will need to have control over the IV generation (or at least
> be able to somehow retrieve it after the crypto operation... but
> passing RNG responsibility to drivers doesn't seem to be a good idea
> anyway).
>
> 2) With this API, drivers wouldn't have to provide implementations for
> specific IV generation modes, and just implement bulk requests for the
> common modes/algorithms (XTS, CBC, ...) while still getting
> performance benefit.

I just sent out v3 for the dm-crypt changes I was working on. I
came across your patches for authenticated encryption support.
Although I haven't looked at it entirely, I was wondering how it could
be put together including the points Ondrej was mentioning. Will look at
it more. Please keep me in cc when you send out the next revision if
that is possible.

Thanks,
Binoy
