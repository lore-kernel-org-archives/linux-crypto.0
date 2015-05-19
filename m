From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Tue, 19 May 2015 18:40:20 -0400
Message-ID: <CACXcFmnZw9eS1EuokG54OYgCXnju2iD2q2o9miWmQMab5SJmDQ@mail.gmail.com>
References: <477328243.LmeEDk1ili@tauon>
	<20150518225807.GA25931@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Stephan Mueller <smueller@chronox.de>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36618 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbESWkV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 May 2015 18:40:21 -0400
In-Reply-To: <20150518225807.GA25931@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 18, 2015 at 6:58 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Stephan Mueller <smueller@chronox.de> wrote:
>>
>> I hear more and more discussions about recommendations to use AES 256 and not
>> AES 128.

Or perhaps other ciphers with 256-bit keys. Salsa, ChaCha and several of
the Caesar candidates support those.

>> These kind of recommendations will eventually also affect the entropy
>> requirements for noise sources. This is my motivation for the patch: allowing
>> different user groups to set the minimum bar for the nonblocking pool to
>> *higher* levels (the examples for 80 to 112 bits or 100 to 125 bits shall just
>> show that there are active revisions of entropy requirements).
>
> Does anyone need to raise this from 128 today? If not then this
> patch is pointless.

There is an RFC for ChaCha in IETF protocols
https://www.rfc-editor.org/rfc/rfc7539.txt
That RFC is new, issued this month, so it will probably be a while
before we need to worry about it.

I do think finding a way to support changing the init requirement from
128 to 256 bits will be useful at some point. However, I doubt it is
urgent since few protocols need it now. On the other hand, IPsec and
TLS both include AES-256, I think.

When we do do it, I see no reason to support anything other than 128
and 256, and I am not sure about retaining 128. Nor do I see any
reason this should be a command-line option rather than just a
compile-time constant.
