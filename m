Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEE0EB64DA
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 19:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGJT7S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 15:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjGJT7R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 15:59:17 -0400
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541C413E;
        Mon, 10 Jul 2023 12:59:13 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:59:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
        s=protonmail; t=1689019149; x=1689278349;
        bh=fwTczJjO5YIeWHPdb8frxed9Xwy/RsdVULIpyuRV/9s=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=UiBU+YqZ/zP8STxUEcG9HzxFvjnSZ/IB9Z+cX4tsBK9DgeQfUYVdVy74mkR+30PoA
         Wf6pPdd3n9Fo7KuplCxZwt6KZNh4MOdKq9Eb42BdnLPz95ogZXZLarSBuhpPWCGvI0
         O/k+LV0yWi0M6ZYdaZx1y09Qv+xDeuo0EUSi1xkss/y3G1auJMqFSV90QevDXTqVSQ
         Y9M12ogkB5eZzg5mzWLrPfd5pZadkgKIhJUkLA/ajA1vdKpDYiqCDBIjyBezKNh1qr
         92ntvXovlJxeJNR8uJ9QJEvegwNZAzb2qUgr7NF1H2ovSbctDXarXJaXa2kjs2NHsH
         z2Dw4HsKemJlw==
To:     Herbert Xu <herbert@gondor.apana.org.au>
From:   Benno Lossin <benno.lossin@proton.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        FUJITA Tomonori <fujita.tomonori@gmail.com>,
        rust-for-linux@vger.kernel.org, Gary Guo <gary@garyguo.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] rust: add synchronous message digest support
Message-ID: <35ylz3z7b7bamGPbpNxUZiu46bLTDm374XORwrK3O18N408p9yPyMAWfnFJOuiEkT6booUB4dx-X7V4vjGPyA_uIA7o4_tS8-l23OCGmiY4=@proton.me>
In-Reply-To: <ZKNXcYXacvP8vyom@gondor.apana.org.au>
References: <20230615142311.4055228-1-fujita.tomonori@gmail.com> <20230615142311.4055228-2-fujita.tomonori@gmail.com> <udHI3v-OLUqHQt3fwnH71QuRJjzGxexw2rkIYEfnsChCmrLoJTIL_GL1wLCARf-UotY51jkPT6tC8nVDvjf8LkY2zvddpgeRQ5owysZwJos=@proton.me> <20230622.111419.241422502377572827.ubuntu@gmail.com> <0a9af5fa-4df2-11da-b3cb-0a6b1d27fdc2@proton.me> <o6lMzg30KAx1IKuGUzjTWb8ciTkkb_vbseDHu2u5nqLeijQ0vX1QgDOij0HGjQkW4NhJcOMoXHvMCstcByEzjq_CjMuN61l1rUo9DaIf97Y=@proton.me> <ZKNXcYXacvP8vyom@gondor.apana.org.au>
Feedback-ID: 71780778:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

------- Original Message -------
On Tuesday, July 4th, 2023 at 01:19, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> On Fri, Jun 30, 2023 at 02:48:37PM +0000, Benno Lossin wrote:
>=20
> > 4. return an error
>=20
>=20
> This would seem to make the most sense.
>=20
> If there is ever a need to hash more than 4G of data, we would
> be adding this to C first.
>=20
> At this point I can't see why we would need to do that so an
> error would be the appropriate response.
>=20
> Thanks,
> --
> Email: Herbert Xu herbert@gondor.apana.org.au
>=20
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Thanks a lot for taking a look!

--
Cheers,
Benno

