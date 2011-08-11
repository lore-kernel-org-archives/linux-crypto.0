From: Andy Lutomirski <luto@MIT.EDU>
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for
 x86-64
Date: Thu, 11 Aug 2011 10:50:49 -0400
Message-ID: <4E43EC49.1040803@mit.edu>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com> <1311529994-7924-3-git-send-email-minipli@googlemail.com> <20110804064436.GA16247@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mathias Krause <minipli@googlemail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110804064436.GA16247@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/04/2011 02:44 AM, Herbert Xu wrote:
> On Sun, Jul 24, 2011 at 07:53:14PM +0200, Mathias Krause wrote:
>>
>> With this algorithm I was able to increase the throughput of a single
>> IPsec link from 344 Mbit/s to 464 Mbit/s on a Core 2 Quad CPU using
>> the SSSE3 variant -- a speedup of +34.8%.
>
> Were you testing this on the transmit side or the receive side?
>
> As the IPsec receive code path usually runs in a softirq context,
> does this code have any effect there at all?
>
> This is pretty similar to the situation with the Intel AES code.
> Over there they solved it by using the asynchronous interface and
> deferring the processing to a work queue.

I have vague plans to clean up extended state handling and make 
kernel_fpu_begin work efficiently from any context.  (i.e. the first 
kernel_fpu_begin after a context switch could take up to ~60 ns on Sandy 
Bridge, but further calls to kernel_fpu_begin would be a single branch.)

The current code that handles context switches when user code is using 
extended state is terrible and will almost certainly become faster in 
the near future.

Hopefully I'll have patches for 3.2 or 3.3.

IOW, please don't introduce another thing like the fpu crypto module 
quite yet unless there's a good reason.  I'm looking forward to deleting 
the fpu module entirely.

--Andy
