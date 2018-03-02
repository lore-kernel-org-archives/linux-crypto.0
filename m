From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 2/3] crypto: ccp - return an actual key size from RSA
 max_size callback
Date: Sat, 3 Mar 2018 00:58:18 +0100
Message-ID: <7deb1115-b4b2-8fe3-885f-0162f2fe359f@maciej.szmigiero.name>
References: <51c265e4-6153-3e5e-316a-ebef059ac36a@maciej.szmigiero.name>
 <20180302164451.GJ21579@gondor.apana.org.au>
 <087e7b27-f839-8d4b-8da8-5d0fa2f8caf1@maciej.szmigiero.name>
 <bcf42353-4b07-a14a-e76f-6c520b7b0ba1@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Hook, Gary" <ghook@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bcf42353-4b07-a14a-e76f-6c520b7b0ba1@amd.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03.03.2018 00:49, Hook, Gary wrote:
> On 3/2/2018 5:15 PM, Maciej S. Szmigiero wrote:
>> On 02.03.2018 17:44, Herbert Xu wrote:
>>> On Sat, Feb 24, 2018 at 05:03:21PM +0100, Maciej S. Szmigiero wrote:
>>>> rsa-pkcs1pad uses a value returned from a RSA implementation max_size
>>>> callback as a size of an input buffer passed to the RSA implementation for
>>>> encrypt and sign operations.
>>>>
>>>> CCP RSA implementation uses a hardware input buffer which size depends only
>>>> on the current RSA key length, so it should return this key length in
>>>> the max_size callback, too.
>>>> This also matches what the kernel software RSA implementation does.
>>>>
>>>> Previously, the value returned from this callback was always the maximum
>>>> RSA key size the CCP hardware supports.
>>>> This resulted in this huge buffer being passed by rsa-pkcs1pad to CCP even
>>>> for smaller key sizes and then in a buffer overflow when ccp_run_rsa_cmd()
>>>> tried to copy this large input buffer into a RSA key length-sized hardware
>>>> input buffer.
>>>>
>>>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>>>> Fixes: ceeec0afd684 ("crypto: ccp - Add support for RSA on the CCP")
>>>> Cc: stable@vger.kernel.org
>>>
>>> Patch applied.  Thanks.
>>
>> Thanks.
>>
>> However, what about the first patch from this series?
>> Without it, while it no longer should cause a buffer overflow, in-kernel
>> X.509 certificate verification will still fail with CCP driver loaded
>> (since CCP RSA implementation has a higher priority than the software
>> RSA implementation).
>>
>> Maciej
>>
> 
> 
> I commented on that one here:
> https://marc.info/?l=linux-crypto-vger&m=151986452422791&w=2
> 
> Effectively a NACK. We are a reviewing a proposed patch right now.

Your earlier comment referred to the third patch from this series.
My message above was about the first one.

Maciej
