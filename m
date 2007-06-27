From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC 0/2] AES ablkcipher driver for SPUs
Date: Wed, 27 Jun 2007 13:41:59 +0200
Message-ID: <20070627114159.GA6456@Chamillionaire.breakpoint.cc>
References: <20070626225952.GA4571@Chamillionaire.breakpoint.cc> <20070627102420.GA11016@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53538 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbXF0LmE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2007 07:42:04 -0400
Content-Disposition: inline
In-Reply-To: <20070627102420.GA11016@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-06-27 14:24:20 [+0400]:

>On Wed, Jun 27, 2007 at 12:59:52AM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
>> This driver adds support for AES on SPU. Patch is for review only because
>> some parts of the code are not upstream yet.
>> Patch one contains the main driver (which uses ablkcipher_ctx_cast()), 
>> patch two is for clarity (parts of the missing API that is used).
>> 
>> Currently only ECB block mode is supported. I plan support for CBC but the
>> way the IV currently handled is unfavorable (later more).
>
>Interesting. Do you have any benchmark of the SPU handling AES crypto?
Yes I do. Those number are gathered from a PS3 and with a sync
interface. sync means the SPU is idle, I queue the request, start the
SPU, SPU requests the data, waits from completion, computes it,
transfers it back and finally the SPU stops (idle again). Oh and only
one SPU is used.
The test is generated with a simple module that allocated four pages (16
kb) and calls the SPU crypto code over and over again until approx 156
MB of memory passed/processed. From the time and total size I get my
kb/sec.
Diagram [1] is exactly that. SIMD is my SIMD version of AES on SPU,
generic is the already present version of AES (crypto/aes.c, modified
to fit the required signature for the encryption. decryption has been
left apart since it is the same code, only different tables) also on the
SPU. 
Diagram [2] shows how relevant the transfer size actually is. I still
transfer 156 MB data but in different transfer sizes. Smaller transfer
size means more transfers, waiting, sbox reloading and more start/stop.
Generic-PPU is "wrong". This speed is taken the first diagram. With more
loops I should get slightly slower (at least due to branches). Operation
is ECB+Encryption+128b key

I did not measure how my SIMD code behaves if the buffers are already
there and I have never to start the SPU. Maybe later that week (as well
as fixing/completing diagram 2).

Ach one last thing: Everything is ECB mode. From experience with VMX I
must say that that one little xor operation in CBC makes no difference
at all.

[1] http://breakpoint.cc/spu_aes/spu_code.png
[2] http://breakpoint.cc/spu_aes/spu_sync_blocksize.png

>-- 
>	Evgeniy Polyakov
Sebastian
