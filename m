From: David Miller <davem@davemloft.net>
Subject: Re: inconsistent handling of unaligned hash inputs
Date: Wed, 01 Oct 2014 22:35:57 -0400 (EDT)
Message-ID: <20141001.223557.1385169137486165396.davem@davemloft.net>
References: <20141002003353.GA23780@gondor.apana.org.au>
	<20141001.180614.1843735881125772362.davem@davemloft.net>
	<CAA-+O6EDQP1x_5Wzr_K66xUBRNrFMroYEhGTKPH1ViX=5uzNRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Cc: bob.picco@oracle.com, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, bpicco@meloft.net
To: herbert@gondor.apana.org.au
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CAA-+O6EDQP1x_5Wzr_K66xUBRNrFMroYEhGTKPH1ViX=5uzNRA@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 2 Oct 2014 09:30:28 +0800

> 2014-10-2 上午9:05于 "David Miller" <davem@davemloft.net>写道：
>>
>> From: Herbert Xu <herbert@gondor.apana.org.au>
>> Date: Thu, 2 Oct 2014 08:33:53 +0800
>>
>> In these specific hash functions we only read the u32/u64 inputs
>> a byte at a time once, to get them into the work buffer.
>>
>> If we have the crypto layer do it, we'll bounce the data around
>> once to the crypto layer bounce buffer, then once again into
>> the hash implementation's work buffer.
> 
> Oh of course if your data is unaligned it'll be worse.  But most
> in-kernel input should be aligned.  So we need to balance this
> against the cost of unaligned loads on aligned data.  If the cost
> of unaligned loads on aligned data is negligible then sure let's
> just do unaligned loads unconditionally.

I see what you're saying.

Probably things are aligned most of the time.

Actually the "cost" of the unaligned load is variable, in that it
depends upon the host cpu endianness.  By doing the byte loads that
part of the byte shuffling is sort of free. :-)  But if the native
endianness matches what the SHA code wants (big endian) then there
isn't any such ammortization going on.

Furthermore, this doesn't take into consideration when the cpu
has endian swapping load/store instructions.

It would be nice to have all the modules specify the alignment,
however in the SHA1 case the code is under lib/ and therefore getting
rid of the get_unaligned_*() usage would prove difficult without
code duplication.

Therefore, for now, it's probably best to use my patch, and use
get_unaligned_*() consistently throughout the sha* implementations.
