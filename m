From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Old PADATA patch vs crypto-2.6 tree
Date: Fri, 30 Mar 2012 11:30:08 +0200
Message-ID: <20120330093007.GF1021@secunet.com>
References: <CAFB-WE9o5TDZrxiFz=Lbe=87XdcHw4wEcEwtC3FKJ_DR2_MYCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastien Agnolini <sebastien.agnolini@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:50646 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab2C3JaQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Mar 2012 05:30:16 -0400
Content-Disposition: inline
In-Reply-To: <CAFB-WE9o5TDZrxiFz=Lbe=87XdcHw4wEcEwtC3FKJ_DR2_MYCA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 28, 2012 at 01:53:41PM +0200, Sebastien Agnolini wrote:
> Hey,
> 
> How activate the IPsec parallelization ?

You need to instantiate pcrypt.

You need either crconf (linux-3.2 or newer with the crypto userconfig
api enabled) or the tcrypt module to instantiate pcrypt.

With crconf:

You can get crconf from https://sourceforge.net/projects/crconf/
Use the git tree for the newest version. After installing crconf
do e.g.

crconf add driver "pcrypt(authenc(hmac(sha1-generic),cbc(aes-asm)))" type 3


With tcrypt:

modprobe tcrypt alg="pcrypt(authenc(hmac(sha1-generic),cbc(aes-asm)))" type=3

The modprobe will return with an error, don't worry about it, thats ok.



Once you've did one of the above, your /proc/crypto should show
something like:

name         : authenc(hmac(sha1),cbc(aes))
driver       : pcrypt(authenc(hmac(sha1-generic),cbc(aes-asm)))
module       : pcrypt
priority     : 2100
refcnt       : 1
selftest     : passed
type         : aead
async        : yes
blocksize    : 16
ivsize       : 16
maxauthsize  : 20
geniv        : <built-in>


Now pcrypt is instantiated, e.g. all new IPsec states (that do
hmac-sha1, cbc-aes) will use it.


> I compiled the crypto-2.6 kernel with this param :
> CONFIG_CRYPTO_... = y
> CONFIG_PADATA = y
> CONFIG_SMP=y
> After installation on 2 servers (IPSEC tunnel), i don't detect the IPsec
> parallelization.
> The algorithm is loaded (present in /proc/crypto), but only one core works.
> 
> So, What are the other parameters that I forgot for the compilation of the
> kernel? IRQ, IO, Scheduler parameters... Am i missing something ?
> I thought that the parallelization was automatically started. True ?

No, see above.

> What are the conditions to observe a parallel work ?

padata/pcrypt uses workqueues for parallelization, so you should see a
lot of busy kworkers when you put your IPsec network under load.
Also the refcnt (/proc/crypto) of the pcrypt algorithm should increase
when you add IPsec states.
