Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98241EB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 14:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjF3Osx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 10:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbjF3Osw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 10:48:52 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523D31996;
        Fri, 30 Jun 2023 07:48:48 -0700 (PDT)
Date:   Fri, 30 Jun 2023 14:48:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
        s=protonmail; t=1688136523; x=1688395723;
        bh=WsdGP+L2oYDp+SU/yqBwbM06vYtzjPM1iocWewyvaz8=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=TtnmgdyyDxXoJBsWTR6ylN09DdXsbbIu0EdsFOhvsHepp4TCYsBt6DCeXj7NwLzrA
         zQ7qeJh3OUDkfoqIEv4RzpGIgkuHLOZfeeWUZjNLzqUp1J9oO+2ST0BR43U1/Llaev
         /r+aMFmpkgL3nBfLsPjaELxxNLkaktGPNqZkgclV4nguHctzJfi1RrB4C66AgKA5zi
         o96vbq7vRNpJtfL8LvPDEzJqusSB1fim7p9gBwUQAD6xmabMSN7nU2vhkIgmOUhYaY
         wTdjeQe77bEO05LBTwdAlbo2K/vc8cv9ilYu3qtDSxiNLVApRQJYmGfQCerLtqPQhj
         DUputDl/JDgBg==
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
From:   Benno Lossin <benno.lossin@proton.me>
Cc:     FUJITA Tomonori <fujita.tomonori@gmail.com>,
        rust-for-linux@vger.kernel.org, Gary Guo <gary@garyguo.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] rust: add synchronous message digest support
Message-ID: <o6lMzg30KAx1IKuGUzjTWb8ciTkkb_vbseDHu2u5nqLeijQ0vX1QgDOij0HGjQkW4NhJcOMoXHvMCstcByEzjq_CjMuN61l1rUo9DaIf97Y=@proton.me>
In-Reply-To: <0a9af5fa-4df2-11da-b3cb-0a6b1d27fdc2@proton.me>
References: <20230615142311.4055228-1-fujita.tomonori@gmail.com> <20230615142311.4055228-2-fujita.tomonori@gmail.com> <udHI3v-OLUqHQt3fwnH71QuRJjzGxexw2rkIYEfnsChCmrLoJTIL_GL1wLCARf-UotY51jkPT6tC8nVDvjf8LkY2zvddpgeRQ5owysZwJos=@proton.me> <20230622.111419.241422502377572827.ubuntu@gmail.com> <0a9af5fa-4df2-11da-b3cb-0a6b1d27fdc2@proton.me>
Feedback-ID: 71780778:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dear crypto maintainers,

Fujita Tomonori has created some Rust bindings for the crypto API seen in
this thread. Here is a fragment of my review of said code:

On 25.06.23 12:08, Benno Lossin wrote:
>>>> +    /// Adds data to message digest for processing.
>>>> +    pub fn update(&mut self, data: &[u8]) -> Result {
>>>> +        // SAFETY: The type invariant guarantees that the pointer is =
valid.
>>>> +        to_result(unsafe {
>>>> +            bindings::crypto_shash_update(self.ptr, data.as_ptr(), da=
ta.len() as u32)
>>>> +        })
>>>
>>> What if `data.len() > u32::MAX`?
>>
>> The buffer might not be updated properly, I guess. Should check the case=
?
>=20
> Not sure what we should do in that case, will bring it up at the next
> team meeting. In Rust, `write` and `read` functions often output the
> number of bytes that were actually read/written. So maybe we should also
> do that here? Then you could just return `u32::MAX` and the user would
> have to call again. We could also call the C side multiple times until
> the entire buffer has been processed. But as the C side only supports
> u32 anyway, I think it would be a rare occurrence for `data` to be large.

I noted that in the code segment above that the length of the data
that is to be hashed is cast from a `usize` to a `u32`. Since
`usize =3D uintptr_t` this might be a problem for very large arguments.

Since the C side only accepts an `unsigned int`, it seems as if large input=
s
are never the case. On the Rust side we are forced to use `usize`, since th=
at
is the length of slices (the input type `&[u8]`).

We came up with the following solutions, but could not come to a consensus =
on any
particular one, could you please assist us in making this decision?

1. create a loop that calls the C API multiple times if the input is large
2. panic
3. truncate
4. return an error

Thanks a lot!

--
Cheers,
Benno
