From: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH v2 2/2] HWRNG: thunderx: Add Cavium HWRNG driver for ThunderX
 SoC.
Date: Wed, 24 Aug 2016 16:07:25 -0700
Message-ID: <57BE28AD.5080607@gmail.com>
References: <1471994835-2423-1-git-send-email-okhaliq@caviumnetworks.com> <1471994835-2423-3-git-send-email-okhaliq@caviumnetworks.com> <874d0bce-cf9b-8772-5af4-ec3844b3b255@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Omer Khaliq <okhaliq@caviumnetworks.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bhelgaas@google.com, mpm@selenic.com, herbert@gondor.apana.org.au,
        Ananth.Jasty@cavium.com, David.Daney@cavium.com
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36237 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754320AbcHXXHn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 19:07:43 -0400
In-Reply-To: <874d0bce-cf9b-8772-5af4-ec3844b3b255@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/23/2016 10:46 PM, Corentin LABBE wrote:
> Hello
>
>> +/* Read data from the RNG unit */
>> +static int cavium_rng_read(struct hwrng *rng, void *dat, size_t max, bool wait)
>> +{
>> +	struct cavium_rng *p = container_of(rng, struct cavium_rng, ops);
>> +	unsigned int size = max;
>> +
>> +	while (size >= 8) {
>> +		*((u64 *)dat) = readq(p->result);
>> +		size -= 8;
>> +		dat += 8;
>> +	}
>
> I think you could use readsq()
> This will increase throughput

If you look at the implementation of readsq(), you will see that it is a 
similar loop.  Since the overhead is primarily I/O latency from the RNG 
hardware, the throughput cannot really be changed with micro 
optimizations to this simple loop.

Also, on big-endian kernels, it appears that a loop of readq() and 
readsq() will give different results as readq will byte swap the result 
and readsq does not.  Since this is a RNG, the byte swapping is not 
important, but it is a difference.

Because of this, I think it should be acceptable to stick with the loop 
we currently have.

If the hwrng maintainers want to change the loop, to a readsq(), we 
might investigate this more.

Thanks,
David Daney
