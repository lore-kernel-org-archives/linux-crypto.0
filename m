From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: Can a driver->probe be called for two devices at the same time
 (WAS: Re: [PATCH] crypto/ccp: don't disable interrupts while setting up
 debugfs)
Date: Tue, 27 Feb 2018 20:36:05 +0100
Message-ID: <20180227193605.nhkagbqjkadqqruo@linutronix.de>
References: <20180223223307.18882-1-bigeasy@linutronix.de>
 <3f0e1a62-a7ea-6d0c-d305-67080803aefd@amd.com>
 <20180226083508.th2m3xssp36lx3zh@linutronix.de>
 <372b353d-017d-a72c-b750-9417f6265874@amd.com>
 <20180227173314.uko5xpf4od2fn74g@linutronix.de>
 <20180227184034.GI20601@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Gary R Hook <gary.hook@amd.com>, "Hook, Gary" <ghook@amd.com>,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180227184034.GI20601@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2018-02-27 19:40:34 [+0100], Greg Kroah-Hartman wrote:
> On Tue, Feb 27, 2018 at 06:33:14PM +0100, Sebastian Andrzej Siewior wrote:
> > On 2018-02-27 11:08:56 [-0600], Gary R Hook wrote:
> > > That issue remains unclear to me: Are probes of PCI devices guaranteed to be
> > > serialized? Observations on my CCPs says that they occur in order, but I
> > > don't know for certain that serialization is guaranteed.
> > > 
> > > Is there a definitive statement on this somewhere that I just don't know
> > > about?
> 
> The bus enforces this.
> 
> > So the question if a driver can probe two devices simultaneously.
> 
> Depends on the bus type.

PCI

> thanks,
> 
> greg k-h

Sebastian
