From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [PATCH 01/19] User-space API definition
Date: Sat, 21 Aug 2010 16:54:29 +0200
Message-ID: <4C6FE8A5.30309@gnutls.org>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com> <AANLkTinzUuihbS_Znm1rgxPPxiLTXeNx8ySF8LHqU=Jz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
	linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
To: Kyle Moffett <kyle@moffetthome.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38488 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0HUOyd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Aug 2010 10:54:33 -0400
In-Reply-To: <AANLkTinzUuihbS_Znm1rgxPPxiLTXeNx8ySF8LHqU=Jz@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/21/2010 03:09 PM, Kyle Moffett wrote:

>> This patch introduces the new user-space API, <ncr.h>.
>>
>> Quick overview:
>>
>> * open("/dev/crypto") to get a FD, which acts as a namespace for key and
>>  session identifiers.
>>
>> * ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the key
>>  material inside the kernel, load a plaintext key, unwrap a key, or
>>  derive a key.  Similarly the key material can be copied out of the
>>  kernel or wrapped.
>>
>> [...snip...]
> 
> Ugh... We already have one very nice key/keyring API in the kernel
> (see Documentation/keys.txt) that's being used for crypto keys for
> NFSv4, AFS, etc.  Can't you just add a bunch of cryptoapi key types to
> that API instead?

It is not that simple. My understanding of the keyring API is that it
allows exporting of the keys to user-space and this crypto API
explicitly prevents that, so enhancing the API that way will remove the
benefits of using it. It would be ideal to combine somehow those
solutions but this is more elaborate work than adding a bunch of new key
types. If anyone is interested in attempting that I'd be glad to help.


regards,
Nikos
