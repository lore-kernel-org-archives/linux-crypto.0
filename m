From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: sha1 - Add test vector to test partial block processing
Date: Fri, 18 Feb 2011 20:43:28 +1100
Message-ID: <20110218094328.GA27184@gondor.apana.org.au>
References: <20110207092817.GA16881@gondor.apana.org.au> <1297082827.11137.15.camel@bender> <20110217032557.GA12955@gondor.apana.org.au> <1297955462.3547.14.camel@localhost.localdomain> <20110217205226.GA21423@gondor.apana.org.au> <1298021837.17221.33.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34262 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1BRJnb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Feb 2011 04:43:31 -0500
Content-Disposition: inline
In-Reply-To: <1298021837.17221.33.camel@bender>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 18, 2011 at 09:37:17AM +0000, Jan Glauber wrote:
>
> Without 9d20b57 it gives:
> 
> [root@h4245005 ~]# modprobe tcrypt mode=2
> FATAL: Error inserting tcrypt (/lib/modules/2.6.38-rc4-dirty/kernel/crypto/tcrypt.ko): Resource temporarily unavailable
> [root@h4245005 ~]# tail -f /var/log/messages 
> ...
> Feb 18 10:22:13 h4245005 kernel: alg: hash: Chunking test 2 failed for sha1-s390
> Feb 18 10:22:13 h4245005 kernel: 00000000: 4a d0 d6 bd 53 2b 6b df cd 34 b9 60 d1 90 85 d0
> Feb 18 10:22:13 h4245005 kernel: 00000010: 38 70 2b 41
> 
> With the patch applied nothing shows up in dmesg.
> 
> --Jan

Excellent.  Thanks a lot for testing Jan!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
