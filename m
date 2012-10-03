From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
Date: Wed, 03 Oct 2012 03:17:34 -0400
Message-ID: <506BE68E.5000004@pobox.com>
References: <20121003054542.GA2416@havoc.gtf.org> <20121003.020619.772556428995851933.davem@davemloft.net> <506BE0E7.1070701@pobox.com> <20121003071119.GA2571@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121003071119.GA2571@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/03/2012 03:11 AM, Herbert Xu wrote:
> On Wed, Oct 03, 2012 at 02:53:27AM -0400, Jeff Garzik wrote:
>>
>> Maybe my patch is the best we can do in the current kernel, if
>> dynamic digest size is not currently possible. Register "sha3_224",
>> "sha3_256", ... as you describe, and wait for actual users to appear
>> with unsupported digest sizes.
>
> Let's see what people use before we do anything more fancy.
>
> If the variants really start proliferating, we can add a template
> called "trunc" and then have things like "trunc(sha3,224)", etc.

If they start proliferating, you really just want a single "sha3(n)", 
one single shash_alg registered at driver init time.

	Jeff
