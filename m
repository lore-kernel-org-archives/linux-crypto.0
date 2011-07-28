From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Bugme-new] [Bug 37862] New: padlock related kernel NULL
	pointer dereference
Date: Thu, 28 Jul 2011 16:11:10 +0800
Message-ID: <20110728081110.GA5031@gondor.apana.org.au>
References: <4DFE10F2.20204@scintilla.utwente.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	bugzilla-daemon@bugzilla.kernel.org,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: "Jethro Beekman - E.T.S.V. Scintilla" <jethrob@scintilla.utwente.nl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52191 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1G1ILT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2011 04:11:19 -0400
Content-Disposition: inline
In-Reply-To: <4DFE10F2.20204@scintilla.utwente.nl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 19, 2011 at 03:08:34PM +0000, Jethro Beekman - E.T.S.V. Scintilla wrote:
> I'm running into a problem with what I think is the padlock_aes driver. 
> It seems to be related to the fix of commit 
> faf996d6cdc3a8e6205ae5226f667aa7d1f5f6c2 (crypto: padlock - fix VIA 
> PadLock instruction usage with irq_ts_save/restore()), but I'm pretty 
> sure that that fix is already in my kernel. So here's a copy of the 
> bugzilla report ( https://bugzilla.kernel.org/show_bug.cgi?id=37862 ):

Hmm, why do you think that patch is in your 2.6.26 kernel when
it was added in 2.6.27?

In any case, please try to reproduce this with the latest upstream
kernel instead of an ancient distro kernel.

If for whatever reason you're stuck with your distro kernel then
please seek advice from your distribution maker.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
