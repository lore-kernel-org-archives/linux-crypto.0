Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46756 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbeJ2Wfx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 18:35:53 -0400
From: AnilKumar Chimata <anilc@codeaurora.org>
Subject: Re: [PATCH 3/3] crypto: qce: ice: Add support for Inline Crypto
 Engine
To: Rob Herring <robh@kernel.org>
Cc: andy.gross@linaro.org, david.brown@linaro.org,
        mark.rutland@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
 <1539789476-6098-4-git-send-email-anilc@codeaurora.org>
 <20181025145548.GA30244@bogus> <20181025152856.GD4970@thunk.org>
Message-ID: <a00932da-72a5-42f9-bf82-eb3e611c35b5@codeaurora.org>
Date: Mon, 29 Oct 2018 19:17:02 +0530
MIME-Version: 1.0
In-Reply-To: <20181025152856.GD4970@thunk.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi Rob,

Thanks for the comments,

On 2018-10-25 20:58, Theodore Y. Ts'o wrote:
> On Thu, Oct 25, 2018 at 09:55:48AM -0500, Rob Herring wrote:
>> > +Introduction:
>> > +=============
>> > +Storage encryption has been one of the most required feature from security
>> > +point of view. QTI based storage encryption solution uses general purpose
>> > +crypto engine. While this kind of solution provide a decent amount of
>> > +performance, it falls short as storage speed is improving significantly
>> > +continuously. To overcome performance degradation, newer chips are going to
>> > +have Inline Crypto Engine (ICE) embedded into storage device. ICE is supposed
>> > +to meet the line speed of storage devices.
>> 
>> Is ICE part of the storage device or part of the host as the binding
>> suggests?
> 
> My understanding is that for this particular instantiation, the Inline
> Crypto Engine is located on the SOC.

This is part of the Storage controller, illustration below

--------------------
|            !_ICE_!
|                  |
|    UFS/SDCC      |
|   Controller     |
|                  |
|                  |
--------------------

> 
> However, from the perspective of generic kernel support, the inline
> crypto support could be implemented on the SOC, or in the host bus
> adaptor, or as a "bump in the wire", or on the storage device.  And
> whatever abstract interface in the block layer should be able to
> support all of these cases.

As name suggests ICE hardware is inline with the data lines of storage 
controller that is the reason why throughput is inline with storage 
speed. Having it out side of the controller kills the purpose of 
introducing ICE on storage controller. If this ICE hardware is placed 
outside then its similar to other crypto engines which are used for 
cryptographic operations. The main reason to keep ICE hardware inline 
with storage is to avoid extra latency (buffer copy) during read/writes 
which involves decryption/encryption.

> 
> I do not believe it would be wise to assume that inline crypto will
> forever be a mobile-only thing.  I could easily see use cases in the
> data center; for example, if you believe that Nation State Actors
> might be trying to create "implants" that attack hard drive firmware,
> per some of the Snowden leaks, creating an open design ICE engine with
> auditable firmware and a trusted secure key store, and which sits
> between the host CPU and the storage device might be one way to
> mitigate against this threat.

Above comments valid here as well.

> 
> 					- Ted
