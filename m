From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Query in Crypto framework
Date: Tue, 2 Oct 2018 10:42:02 +0800
Message-ID: <20181002024202.kgnno6wrnmjkumpk@gondor.apana.org.au>
References: <BN7PR02MB51249DB95E4CCBC5257C1F45AFEF0@BN7PR02MB5124.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
To: Kalyani Akula <kalyania@xilinx.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BN7PR02MB51249DB95E4CCBC5257C1F45AFEF0@BN7PR02MB5124.namprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 01, 2018 at 09:30:35AM +0000, Kalyani Akula wrote:
> Hi ,
> 
> We wrote a Xilinx specific AES driver in the crypto framework, while testing we have seen one issue.
> We are trying to send a input data of size 1MB using sendmsg system call from the application, and we could see it is hanging in the af_alg_sendmsg.
> Our analysis is, it is waiting for the availability of the writable memory inside af_alg_wait_for_wmem (entered into infinite loop).
> 
> Is there any limitation on the maximum data that can sent via AF_ALG socket ?

When you make a send(2) system call, you're essentially allocating
kernel memory.  For obvious reasons we don't allow unbounded
allocation of kernel memory from user-space.

In order to process a large amount of data, you should use chaining
for algorithms that support it.  So instead of writing everything
at once, write a certain multiple of blocks and then read the partial
result before writing more.

For AEAD algorithms which do not support chaining, you can work
around this by adjusting the appropriate socket buffer limits.

Note that if you increase the socket buffer limits too much you will
run into system-wide limits which can also be adjusted under /proc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
