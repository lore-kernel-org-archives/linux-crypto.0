From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: ahash vs. shash
Date: Wed, 14 May 2014 10:52:30 +0300
Message-ID: <CACE9dm-KCFzTg2iSUhZrNZsnuoM-OHm0eWDkNk95Zi_BbfCKBA@mail.gmail.com>
References: <CACE9dm-6kTZ91Ha8sMS=Zviqg-Dx6tzeTRVJtsGHKxwwP+TRzQ@mail.gmail.com>
	<20140514013940.GA29183@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50652 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaENHwc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 03:52:32 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so1481662wgh.8
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2014 00:52:31 -0700 (PDT)
In-Reply-To: <20140514013940.GA29183@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14 May 2014 04:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:
>> Hi,
>>
>> ahash allows to use HW acceleration, but usually it comes at a cost of
>> additional HW related configuration overhead, such as configuring hash
>> module, DMA, etc. For that reason hashing small chucks of data is
>> faster doing it with shash (CPU) rather than HW acceleration.
>>
>> I measured long time ago on omap-sham driver but cannot recall any data.
>>
>> Does anyone have any experience under what data size it is still
>> better to use shash?
>
> It's going to be hardware-specific.  It'll also depend on whether
> you're coming from user-space or not as that would entail a bigger
> per-request overhead, meaning that you need more data to break
> even.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Thanks for the reply.

Integrity subsystem hashing files and file sizes of course are much different.
It is nice to minimize overall hashing time.

I made a patch for ahash support, but without removing shash.
It defines kernel command line parameter for file size threshold when
start using ahash.
It may be adjusted/tuned based on the particular HW.

http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/commit/?h=ima-experimental&id=85189d1265da83c4a5c537071b1fe4cddec59a54


-Dmitry
