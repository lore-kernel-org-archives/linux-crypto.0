From: Gary R Hook <gary.hook@amd.com>
Subject: Re: Can a driver->probe be called for two devices at the same time
 (WAS: Re: [PATCH] crypto/ccp: don't disable interrupts while setting up
 debugfs)
Date: Tue, 27 Feb 2018 14:11:24 -0600
Message-ID: <d9fd273b-5d48-a005-ac30-c8bc8aa803ab@amd.com>
References: <20180223223307.18882-1-bigeasy@linutronix.de>
 <3f0e1a62-a7ea-6d0c-d305-67080803aefd@amd.com>
 <20180226083508.th2m3xssp36lx3zh@linutronix.de>
 <372b353d-017d-a72c-b750-9417f6265874@amd.com>
 <20180227173314.uko5xpf4od2fn74g@linutronix.de>
 <20180227184034.GI20601@kroah.com>
 <20180227193605.nhkagbqjkadqqruo@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Hook, Gary" <ghook@amd.com>, linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180227193605.nhkagbqjkadqqruo@linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/27/2018 01:36 PM, Sebastian Andrzej Siewior wrote:
> On 2018-02-27 19:40:34 [+0100], Greg Kroah-Hartman wrote:
>> On Tue, Feb 27, 2018 at 06:33:14PM +0100, Sebastian Andrzej Siewior wrote:
>>> On 2018-02-27 11:08:56 [-0600], Gary R Hook wrote:
>>>> That issue remains unclear to me: Are probes of PCI devices guaranteed to be
>>>> serialized? Observations on my CCPs says that they occur in order, but I
>>>> don't know for certain that serialization is guaranteed.
>>>>
>>>> Is there a definitive statement on this somewhere that I just don't know
>>>> about?
>>
>> The bus enforces this.
>>
>>> So the question if a driver can probe two devices simultaneously.
>>
>> Depends on the bus type.
> 
> PCI

So the question is whether or not PCI enforces serial activity within a 
domain. The CCPs are all on different buses, so that doesn't matter.

I think we don't care in this situation, given that the CCP driver has 
minor requirements for locking. I just found it an interesting (albeit 
somewhat academic) question.

Thanks,
Gary
