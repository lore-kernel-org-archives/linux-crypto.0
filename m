From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH 2/3] crypto: ccp - return an actual key size from RSA
 max_size callback
Date: Fri, 2 Mar 2018 18:16:09 -0600
Message-ID: <d3b268a9-1ebe-d9bd-01db-a513538e74c5@amd.com>
References: <51c265e4-6153-3e5e-316a-ebef059ac36a@maciej.szmigiero.name>
 <20180302164451.GJ21579@gondor.apana.org.au>
 <087e7b27-f839-8d4b-8da8-5d0fa2f8caf1@maciej.szmigiero.name>
 <bcf42353-4b07-a14a-e76f-6c520b7b0ba1@amd.com>
 <7deb1115-b4b2-8fe3-885f-0162f2fe359f@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        "Hook, Gary" <ghook@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7deb1115-b4b2-8fe3-885f-0162f2fe359f@maciej.szmigiero.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/02/2018 05:58 PM, Maciej S. Szmigiero wrote:
> On 03.03.2018 00:49, Hook, Gary wrote:
>> On 3/2/2018 5:15 PM, Maciej S. Szmigiero wrote:
>>>
>>> Thanks.
>>>
>>> However, what about the first patch from this series?
>>> Without it, while it no longer should cause a buffer overflow, in-kernel
>>> X.509 certificate verification will still fail with CCP driver loaded
>>> (since CCP RSA implementation has a higher priority than the software
>>> RSA implementation).
>>>
>>> Maciej
>>>
>>
>>
>> I commented on that one here:
>> https://marc.info/?l=linux-crypto-vger&m=151986452422791&w=2
>>
>> Effectively a NACK. We are a reviewing a proposed patch right now.
> 
> Your earlier comment referred to the third patch from this series.
> My message above was about the first one.

Apologies; my mistake.
