From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto/arc4: now arc needs blockcipher support
Date: Wed, 27 Jun 2012 07:35:08 +0300
Message-ID: <20120627073508.70954k3niixnwhwk@www.81.fi>
References: <20120626161346.GB6509@breakpoint.cc>
 <CACXcFmkrKWyyWEkud_p=vWDX1aUi2YSpA0b4KYRQ6sJArOb_sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:33892 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2F0EfM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 00:35:12 -0400
In-Reply-To: <CACXcFmkrKWyyWEkud_p=vWDX1aUi2YSpA0b4KYRQ6sJArOb_sQ@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Sandy Harris <sandyinchina@gmail.com>:

> On Wed, Jun 27, 2012 at 12:13 AM, Sebastian Andrzej Siewior
> <sebastian@breakpoint.cc> wrote:
>> Since commit ce6dd368 ("crypto: arc4 - improve performance by adding
>> ecb(arc4)) we need to pull in a blkcipher.
>>
>> |ERROR: "crypto_blkcipher_type" [crypto/arc4.ko] undefined!
>> |ERROR: "blkcipher_walk_done" [crypto/arc4.ko] undefined!
>> |ERROR: "blkcipher_walk_virt" [crypto/arc4.ko] undefined!
>>
>> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>> ---
>>
>> On a side note: do we pull in the blkcipher block mode for each  
>> cipher now to
>> gain some extra performance like the openssl project? I was under the
>> impression that is in general not worth it.
>
> Arc4 is a stream cipher, NOT a block cipher. They are completely different
> things, and the requirements for using them securely are different. In
> particular, modes like ECB apply to block ciphers not to stream ciphers.
>
> Unless these changes have been thoroughly analyzed by several
> people who actually know crypto, they should be immediately reverted.

The 'arc4' is defined as one-byte cipher (that modifies its context to  
remember current stream state) and ecb module is just used to make  
arc4 iterate throught variable length buffers. 'ecb(arc4)' is then the  
actual stream cipher, with confusing and wrong name. I guess now that  
'ecb(arc4)' is moved to arc4 module completely, it could be renamed to  
'arc4stream' and in-kernel arc4 users which to use that.

-Jussi
