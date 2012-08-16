From: David Daney <ddaney.cavm@gmail.com>
Subject: Re: on stack dynamic allocations
Date: Thu, 16 Aug 2012 14:30:57 -0700
Message-ID: <502D6691.5010101@gmail.com>
References: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au,
	linux-crypto <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/16/2012 02:20 PM, Kasatkin, Dmitry wrote:
> Hello,
>
> Some places in the code uses variable-size allocation on stack..
> For example from hmac_setkey():
>
> 	struct {
> 		struct shash_desc shash;
> 		char ctx[crypto_shash_descsize(hash)];
> 	} desc;
>
>
> sparse complains
>
> CHECK   crypto/hmac.c
> crypto/hmac.c:57:47: error: bad constant expression
>
> I like it instead of kmalloc..
>
> But what is position of kernel community about it?

If you know that the range of crypto_shash_descsize(hash) is bounded, 
just use the upper bound.

If the range of crypto_shash_descsize(hash) is unbounded, then the stack 
will overflow and ... BOOM!

David Daney



