From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Thu, 5 May 2016 09:17:32 -0700
Message-ID: <a3758abe-ec4e-56f7-c05a-7e9dd462d7c2@intel.com>
References: <20160503.123301.298039059390449291.davem@davemloft.net>
 <20160504040731.GA25758@gondor.apana.org.au>
 <CADxRZqws2yAMSqeMDYb6w6OUXJMMbv9wMaY7Zc6YX+szk2vO3g@mail.gmail.com>
 <20160505084249.GA4971@gondor.apana.org.au>
 <CADxRZqwxB-+DTV-qKFK6CVXwVV0h9yDkH6GxcjmA-M9KY2HM7g@mail.gmail.com>
 <20160505095020.GA5473@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Anatoly Pugachev <matorola@gmail.com>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20160505095020.GA5473@gondor.apana.org.au>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/05/2016 02:50 AM, Herbert Xu wrote:
> On Thu, May 05, 2016 at 12:40:18PM +0300, Anatoly Pugachev wrote:
>>
>> sure, based on your cryptodev git, just tried 4.3 (6a13feb , good)
>> kernel in attempt to find (bisect) when RSA code break, already tested
>> 4.5 (44d1b6d , bad) , 4.4 (afd2ff9 , bad).
>> Going to try your patch soon (when I'm back home).
>> So far 4.3 passes RSA stage without OOPS, but for other reason does
>> not boot to login prompt. Boot log exempt (4.3), this is with
>> CONFIG_CRYPTO_RSA=y :
> 
> That jibes with this being a problem with the SG list since it
> was only added in 4.4.

Before 4.4 the rsa sw implementation kmalloced intermediate flat buffer
and copied the data internally.
Thanks,
-- 
TS
