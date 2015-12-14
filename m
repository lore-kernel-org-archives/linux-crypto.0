From: Fabrizio Demaria <fabrizio.f.demaria@gmail.com>
Subject: Re: "crypto_hash_setkey" call from atomic context
Date: Mon, 14 Dec 2015 09:53:03 +0100
Message-ID: <CACzeOEfOSi7T2CmE1HjU-ryCGEBj-b0h2E-o0BrmKWiFvMcEHQ@mail.gmail.com>
References: <CACzeOEfg9x+aEwuP9xH3BLd5+RzpDBZBGsnsLw7skW9FP5LVGw@mail.gmail.com>
	<20151211074223.GA11688@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	"Nordell, Joakim" <joakim.nordell@intel.com>,
	"Chen, Shujuan" <shujuan.chen@intel.com>, doru.gucea@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33526 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbLNIxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Dec 2015 03:53:03 -0500
Received: by oigy66 with SMTP id y66so14764129oig.0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2015 00:53:03 -0800 (PST)
In-Reply-To: <20151211074223.GA11688@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In our MPTCP implementation we handled the setkey problem by
pre-allocating a properly aligned key's buffer right after
"crypto_alloc_hash", outside atomic context [1]. Would this workaround
be enough to guarantee that "crypto_hash_setkey" can be safely called
in atomic contexts? Is it always the case that "crypto_hash_setkey"
calls "crypto_shash_setkey"?

Thanks,
=46abrizio

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/06e7644bdac1=
ac6e97767bc714586fbfadcdeaa8

2015-12-11 8:42 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
> Fabrizio Demaria <fabrizio.f.demaria@gmail.com> wrote:
>> Hello,
>>
>> I am investigating the current usage of kernel crypto-libraries in t=
he
>> SCTP code, considering to adopt the same crypto framework for the
>> MPTCP implementation.
>>
>> In sm_make_chunk.c, the crypto function "crypto_hash_setkey" is call=
ed
>> in an atomic context, despite the fact that this function CAN invoke=
 a
>> GFP_KERNEL (sleeping) memory allocation. Calling a sleeping function
>> from an atomic context can end up in deadlock.
>> Is there a way to make sure that =E2=80=9Ccrypto_hash_setkey=E2=80=9D=
 can be safely
>> called in an atomic context, considering all the possible code-paths
>> followed by the function?
>
> Indeed, in general setkey should not be invoked in atomic contexts.
> The only exception would be extremely simple hashes such as CRC.
>
> Keys should be setup before hand.  So SCTP needs to be fixed.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
