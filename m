From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sha384 self-test failure oddity
Date: Tue, 2 Jun 2009 15:10:27 +1000
Message-ID: <20090602051027.GA24415@gondor.apana.org.au>
References: <200905291435.50237.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45769 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753198AbZFBFK2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 01:10:28 -0400
Content-Disposition: inline
In-Reply-To: <200905291435.50237.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jarod Wilson <jarod@redhat.com> wrote:
> While doing a bit of testing of some other crypto code, I've repeatedly
> noticed a sha384 self-test failure. If you 'modprobe tcrypt', the
> sha384 self-test fails, then immediately after it, sha384-generic
> self-tests succeed. Something is awry w/sha384 initialization, as
> can be more plainly seen by the following after a reboot:
> 
> # modprobe tcrypt mode=11 (run sha384 self-test)
> 
> dmesg
> -----
> alg: hash: Failed to load transform for sha384: -2

What kernel version and config? I can't reproduce this with
2.6.30-rc7.  What does modinfo sha512_generic say?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
