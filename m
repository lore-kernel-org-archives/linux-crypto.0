From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: aes - make assembler implementation default
 for i386 and x86-64
Date: Wed, 20 Jun 2012 14:49:07 +0300
Message-ID: <20120620144907.19996rt0vpgn7zys@www.81.fi>
References: <20120530215333.32995tjzj9dr4jwo@www.81.fi>
 <20120609145055.12766.42439.stgit@localhost6.localdomain6>
 <20120612082651.GA13419@gondor.apana.org.au>
 <20120612212518.22246qw5kuyn2osg@www.81.fi>
 <20120618090201.GA25104@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120618090201.GA25104@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> On Tue, Jun 12, 2012 at 09:25:18PM +0300, Jussi Kivilinna wrote:
>>
>> Well, how about letting arch specific assembler implementations
>> replace aes-generic
>> completely.. in this case add "depends on !X86" on
>> CRYPTO_AES_GENERIC. Hardware
>> modules get autoloaded (cpuid/pci/platform/etc) but generic
>> assembler implementation
>> might as well be replacement as it cannot autoload depending on
>> hardware support (or
>> it can, but will be always loaded).
>
> Perhaps we can just force a modprobe of a given algorithm at least
> once for each boot (when requested for the first time).  I think
> that should be easy to implement and should solve your problem
> scenario.
>
> What do you think?

Well, that could work.

-Jussi


>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
>
