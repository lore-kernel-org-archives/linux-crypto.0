From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL pointer
	dereference at 0000000000000018
Date: Mon, 15 Feb 2010 10:14:08 +0200
Message-ID: <b6fcc0a1002150014j43415772mea21790c0667a32b@mail.gmail.com>
References: <20100214174507.GA8688@x200>
	 <20100215052729.GA17156@gondor.apana.org.au>
	 <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com>
	 <20100215081155.GA18566@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:50973 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0BOIOJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2010 03:14:09 -0500
Received: by iwn39 with SMTP id 39so1943051iwn.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Feb 2010 00:14:08 -0800 (PST)
In-Reply-To: <20100215081155.GA18566@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 15, 2010 at 10:11 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Mon, Feb 15, 2010 at 09:47:25AM +0200, Alexey Dobriyan wrote:
>> On Mon, Feb 15, 2010 at 7:27 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> > Is this reproducible every time you unload aes_x86_64 after boot?
>>
>> No, what I do is
>>
>> 1. setup ipcomp in tunnel mode _in fresh netns_ and immediately exit
>> 2. modprobe/rmmod all modules (not much)
>>
>> ~1 hour of this workload and it hits sometimes with aes_x86_64,
>> sometimes with aes_generic.
>
> Was this with that IPCOMP bug fixed?

Yes, ipcomp bug triggers almost immediately.
Anyway, this is just description of what I do.
