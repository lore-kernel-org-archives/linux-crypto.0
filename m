From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Mon, 15 Nov 2010 06:21:30 -0500
Message-ID: <20101115112130.GA12043@hmsreliant.think-freely.org>
References: <1289568721.3090.267.camel@Dan>
 <1289810592.30446.410.camel@vespa.frost.loc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
	linux-crypto@vger.kernel.org
To: Tomas Mraz <tmraz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36624 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab0KOLYd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 06:24:33 -0500
Content-Disposition: inline
In-Reply-To: <1289810592.30446.410.camel@vespa.frost.loc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 15, 2010 at 09:43:12AM +0100, Tomas Mraz wrote:
> On Fri, 2010-11-12 at 08:32 -0500, Dan Rosenberg wrote: 
> > Hi Crypto people,
> > 
> > I'm planning on submitting a patch that introduces a new %p format
> > specifier that obfuscates kernel pointers depending on privileges.  This
> > change is for security reasons - many networking protocols expose
> > pointers to socket structures in their /proc interfaces, which are
> > attractive targets when exploiting other issues.
> > 
> > It's been suggested that I initialize a secret value at boot, and use
> > that as the key to a crypto hash function.  I should use a function that
> > is relatively fast (ideally), produces a unique output based on its
> > input of a pointer, and produces consistent output when given the same
> > input.  It should be difficult to infer the input given only the output.
> > 
> > I have two questions:
> > 
> > 1. What is a proper, safe way of initializing a random value at boot?
> > Are there any existing examples that do this?
> > 
> > 2. Can you recommend a crypto algorithm that would be well suited for
> > this pointer obfuscation?
> This would not be a 'hashing' algorithm but a simple block encryption
> algorithm in the ECB mode with the random key initialized at boot. The
> problem here is that the standard block ciphers have at least 64 bit
> block length as smaller block length ciphers would not be secure for
> general purpose uses. You would have to take an existing block cipher
> algorithm and modify it to achieve the smaller block length.
> 
> -- 
> Tomas Mraz
> No matter how far down the wrong road you've gone, turn back.
>                                               Turkish proverb
> 
Something else occurs to me.  If this is to be implemented as an internal
modification to the %p format token, you're going to have to be careful as to
when you're able to use it.  Crypto algorithms can be built as individual
modules, and the api has them auto-load on demand when instances of them are
requested.  How are you going to be certain that the hash that you choose is
available?  For that matter, how are you going to know when its safe to ask for
the algorithm?  If you do a printk(...%p\n") early during the boot, you'll be
calling request_moule->...->call_usermodehelper_exec before the workqueue or any
of its datastructures are initalized, and that will oops you.

Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
