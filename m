From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and
 dm-crypt
Date: Fri, 13 Jan 2017 22:29:59 +0800
Message-ID: <20170113142959.GA24258@gondor.apana.org.au>
References: <cover.1484215956.git.omosnacek@gmail.com>
 <20170113104128.GA23497@gondor.apana.org.au>
 <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47303 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751445AbdAMOaL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 09:30:11 -0500
Content-Disposition: inline
In-Reply-To: <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 01:01:56PM +0100, Ondrej Mosnáček wrote:
>
> As I already mentioned in another thread, there are basically two reasons:
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

This sounds exactly like the IV generator for IPsec modes such as
CTR or GCM.  The only difference is that you deal with sectors
instead of packets.

> 2) With this API, drivers wouldn't have to provide implementations for
> specific IV generation modes, and just implement bulk requests for the
> common modes/algorithms (XTS, CBC, ...) while still getting
> performance benefit.

What if the driver had hardware support for generating these IVs?
With your scheme this cannot be supported at all.

Getting the IVs back is not actually that hard.  We could simply
change the algorithm definition for the IV generator so that
the IVs are embedded in the plaintext and ciphertext.  For
example, you could declare it so that the for n sectors the
first n*ivsize bytes would be the IV, and the actual plaintext
or ciphertext would follow.

With such a definition you could either generate the IVs in dm-crypt
or have them generated in the IV generator.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
