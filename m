From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-AES, use generic setkey function
Date: Tue, 1 Apr 2008 21:25:42 +0800
Message-ID: <20080401132542.GA25108@gondor.apana.org.au>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <1203850864-16681-3-git-send-email-sebastian@breakpoint.cc> <47D99F62.7010100@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <sebastian@breakpoint.cc>,
	linux-crypto@vger.kernel.org, Michal Ludvig <michal@logix.cz>
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47715 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757534AbYDANZz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2008 09:25:55 -0400
Content-Disposition: inline
In-Reply-To: <47D99F62.7010100@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 13, 2008 at 10:40:50PM +0100, Stefan Hellermann wrote:
> Sebastian Siewior schrieb:
> > Padlock AES' setkey routine is the same as exported by the generic
> > implementation. So we could use it.
> > 
> 
> I tested this and "[RFC] generic_aes: export generic setkey" on a padlock-enabled Via
> board, and did the following test:
> 
> Create, open, write to, read from and close a linux dm-crypt device with aes-cbc-essiv,
> aes-lrw-benbi and aes-xts-plain.
> 
> Then I took a huge encrypted disk-image (encrypted without this patches), opened it with
> cryptsetup-luks, booted the OS from the disc over iscsi, started a filesystem-check. The
> check completed successful.
> 
> So I think this and the other patch are save.
> 
> 
> Tested-by: Stefan Hellermann <stefan@the2masters.de>

Both patches applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
