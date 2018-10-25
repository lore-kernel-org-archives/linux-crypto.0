Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57214 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbeJZACX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Oct 2018 20:02:23 -0400
Date: Thu, 25 Oct 2018 11:28:56 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Rob Herring <robh@kernel.org>
Cc: AnilKumar Chimata <anilc@codeaurora.org>, andy.gross@linaro.org,
        david.brown@linaro.org, mark.rutland@arm.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: qce: ice: Add support for Inline Crypto
 Engine
Message-ID: <20181025152856.GD4970@thunk.org>
References: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
 <1539789476-6098-4-git-send-email-anilc@codeaurora.org>
 <20181025145548.GA30244@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025145548.GA30244@bogus>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 25, 2018 at 09:55:48AM -0500, Rob Herring wrote:
> > +Introduction:
> > +=============
> > +Storage encryption has been one of the most required feature from security
> > +point of view. QTI based storage encryption solution uses general purpose
> > +crypto engine. While this kind of solution provide a decent amount of
> > +performance, it falls short as storage speed is improving significantly
> > +continuously. To overcome performance degradation, newer chips are going to
> > +have Inline Crypto Engine (ICE) embedded into storage device. ICE is supposed
> > +to meet the line speed of storage devices.
> 
> Is ICE part of the storage device or part of the host as the binding 
> suggests?

My understanding is that for this particular instantiation, the Inline
Crypto Engine is located on the SOC.

However, from the perspective of generic kernel support, the inline
crypto support could be implemented on the SOC, or in the host bus
adaptor, or as a "bump in the wire", or on the storage device.  And
whatever abstract interface in the block layer should be able to
support all of these cases.

I do not believe it would be wise to assume that inline crypto will
forever be a mobile-only thing.  I could easily see use cases in the
data center; for example, if you believe that Nation State Actors
might be trying to create "implants" that attack hard drive firmware,
per some of the Snowden leaks, creating an open design ICE engine with
auditable firmware and a trusted secure key store, and which sits
between the host CPU and the storage device might be one way to
mitigate against this threat.

					- Ted
