From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Tue, 29 Dec 2009 12:38:26 +0100
Message-ID: <4B39EA32.8010707@redhat.com>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net> <4B390907.8010609@redhat.com> <20091229092158.GA10017@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Max Vozeler <max@hinterhof.net>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbZL2Ljc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2009 06:39:32 -0500
In-Reply-To: <20091229092158.GA10017@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/29/2009 10:21 AM, Richard Zidlicky wrote:
> On Mon, Dec 28, 2009 at 08:37:43PM +0100, Milan Broz wrote:

> While we are at it - are you aware of any documentation of the "mainline" dm-crypt
> implementation? I have not seen anything, much less any explanation if it has improved 
> any since the ancient watermarking attack.
> 
> http://luks.endorphin.org/ is down, http://www.saout.de/misc/dm-crypt/ has plenty of
> information but I am not sure if it is up to date.. well if it is than it seems default
> dm-crypt still has more or less snake oil quality encryption.

ok, I should probably add some info, probably to new cryptsetup pages
http://code.google.com/p/cryptsetup/ and kernel to documentation, if needed.

 - the watermarking attack is not possible with introducing ESSIV long time ago
 (essiv default for LUKS formatted devices by cryptsetup - for several years)
 - I prefer using XTS mode, but user can use whatever is supported in kernel

 - AFAIK there is no known problem with dm-crypt (stability or security) when properly
 configured (you can of course use old vulnerable IV mode if you want).
 (And many distributions and uses dm-crypt/LUKS based full disk encryption currently,
  also Truecrypt uses dm-crypt as backend on Linux for new containers.)

 (If you think about coldboot or something similar - dm-crypt provides functions to
 temporarily freeze device and empty keys and I also added support for this to cryptsetup.
 So the controlled suspend/resume to RAM can ask for LUKS passphrase and unlock master key,
 preventing active encryption keys in RAM.
 Of course this do not apply to if the shutdown is not controlled, but that's common
 problem of all these implementations.)

If you know about some problem in dm-crypt, just let me know (or write to dm-crypt mailing list).

Milan
--
mbroz@redhat.com
