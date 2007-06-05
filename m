From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Tue, 5 Jun 2007 19:02:45 +0400
Message-ID: <20070605150245.GA29400@2ka.mipt.ru>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070605125604.GA16327@Chamillionaire.breakpoint.cc> <20070605130731.GA4643@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53567 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbXFEPD1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jun 2007 11:03:27 -0400
Content-Disposition: inline
In-Reply-To: <20070605130731.GA4643@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 05, 2007 at 05:07:31PM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> This is tricky, hifn requires to have a key per crypto setup, so this
> one must be in a crypto context, but context is not used right now, so
> yes, it supports only one user. I will update it to use context, since
> it is smaller that hifn_device.

Hmm, I was wrong, it is not possible (from first view).

Here is a sequence of events to setup a crypto session:
1. user calls setkey, which results in tfm. It is possible to get a
context from tfm. Context can be initialized via cra_init() callback in
registered algorithm. But there is no way to provide a private pointer
into that callback. So, there is no way to provide a pointer to
hifn_device and thus tfm context can not find a hardware device to setup
this session.

Herbert, could you please elaborate how to provide a private pointer
into cra_init without searching via static lists of all devices?

-- 
	Evgeniy Polyakov
