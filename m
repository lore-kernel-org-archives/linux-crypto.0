From: Tomas Mraz <tmraz@redhat.com>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Mon, 15 Nov 2010 09:43:12 +0100
Message-ID: <1289810592.30446.410.camel@vespa.frost.loc>
References: <1289568721.3090.267.camel@Dan>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Dan Rosenberg <drosenberg@vsecurity.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0KOInP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 03:43:15 -0500
In-Reply-To: <1289568721.3090.267.camel@Dan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2010-11-12 at 08:32 -0500, Dan Rosenberg wrote: 
> Hi Crypto people,
> 
> I'm planning on submitting a patch that introduces a new %p format
> specifier that obfuscates kernel pointers depending on privileges.  This
> change is for security reasons - many networking protocols expose
> pointers to socket structures in their /proc interfaces, which are
> attractive targets when exploiting other issues.
> 
> It's been suggested that I initialize a secret value at boot, and use
> that as the key to a crypto hash function.  I should use a function that
> is relatively fast (ideally), produces a unique output based on its
> input of a pointer, and produces consistent output when given the same
> input.  It should be difficult to infer the input given only the output.
> 
> I have two questions:
> 
> 1. What is a proper, safe way of initializing a random value at boot?
> Are there any existing examples that do this?
> 
> 2. Can you recommend a crypto algorithm that would be well suited for
> this pointer obfuscation?
This would not be a 'hashing' algorithm but a simple block encryption
algorithm in the ECB mode with the random key initialized at boot. The
problem here is that the standard block ciphers have at least 64 bit
block length as smaller block length ciphers would not be secure for
general purpose uses. You would have to take an existing block cipher
algorithm and modify it to achieve the smaller block length.

-- 
Tomas Mraz
No matter how far down the wrong road you've gone, turn back.
                                              Turkish proverb
