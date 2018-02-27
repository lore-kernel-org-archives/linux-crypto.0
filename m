From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Can a driver->probe be called for two devices at the same time (WAS:
 Re: [PATCH] crypto/ccp: don't disable interrupts while setting up debugfs)
Date: Tue, 27 Feb 2018 18:33:14 +0100
Message-ID: <20180227173314.uko5xpf4od2fn74g@linutronix.de>
References: <20180223223307.18882-1-bigeasy@linutronix.de>
 <3f0e1a62-a7ea-6d0c-d305-67080803aefd@amd.com>
 <20180226083508.th2m3xssp36lx3zh@linutronix.de>
 <372b353d-017d-a72c-b750-9417f6265874@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Hook, Gary" <ghook@amd.com>, linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <372b353d-017d-a72c-b750-9417f6265874@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2018-02-27 11:08:56 [-0600], Gary R Hook wrote:
> That issue remains unclear to me: Are probes of PCI devices guaranteed to be
> serialized? Observations on my CCPs says that they occur in order, but I
> don't know for certain that serialization is guaranteed.
> 
> Is there a definitive statement on this somewhere that I just don't know
> about?

So the question if a driver can probe two devices simultaneously. I'm
not sure. We have PROBE_PREFER_ASYNCHRONOUS which defers the probe to
worker. However I have no idea if two of those worker can run at the
same time.

> I think a mutex would be just fine; I got this wrong, clearly. Let me work
> up a patch using a mutex.

I've sent one. Why not just ack it and be done with it?

> Gary

Sebastian
