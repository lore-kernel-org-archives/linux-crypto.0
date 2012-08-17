From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: on stack dynamic allocations
Date: Fri, 17 Aug 2012 11:18:26 +0300
Message-ID: <20120817111826.15226265ph07g70g@www.81.fi>
References: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
 <502D6691.5010101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	herbert@gondor.apana.org.au,
	linux-crypto <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
To: David Daney <ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <502D6691.5010101@gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting David Daney <ddaney.cavm@gmail.com>:

> On 08/16/2012 02:20 PM, Kasatkin, Dmitry wrote:
>> Hello,
>>
>> Some places in the code uses variable-size allocation on stack..
>> For example from hmac_setkey():
>>
>> 	struct {
>> 		struct shash_desc shash;
>> 		char ctx[crypto_shash_descsize(hash)];
>> 	} desc;
>>
>>
>> sparse complains
>>
>> CHECK   crypto/hmac.c
>> crypto/hmac.c:57:47: error: bad constant expression
>>
>> I like it instead of kmalloc..
>>
>> But what is position of kernel community about it?
>
> If you know that the range of crypto_shash_descsize(hash) is  
> bounded, just use the upper bound.
>
> If the range of crypto_shash_descsize(hash) is unbounded, then the  
> stack will overflow and ... BOOM!
>

Quick look shows that largest crypto_shash_descsize() would be with  
hmac+s390/sha512, 16 + 332 = 348. Crypto-api also prevents registering  
shash with descsize larger than (PAGE_SIZE / 8).

-Jussi
