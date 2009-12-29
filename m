From: Max Vozeler <max@hinterhof.net>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Tue, 29 Dec 2009 02:46:39 +0100
Message-ID: <20091229014639.GC26723@chaos.nusquama.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net> <4B390907.8010609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from chaos.nusquama.org ([85.131.211.23]:53605 "EHLO
	chaos.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZL2Bqm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 20:46:42 -0500
Content-Disposition: inline
In-Reply-To: <4B390907.8010609@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 28, 2009 at 08:37:43PM +0100, Milan Broz wrote:
> On 12/28/2009 07:59 PM, Max Vozeler wrote:
> > The original code used cc->cipher for two things:
> 
> > @@ -1014,6 +1014,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >  	char *ivopts;
> >  	unsigned int key_size;
> >  	unsigned long long tmpll;
> > +	char ciphermode[CRYPTO_MAX_ALG_NAME];
> 
> Today is CRYPTO_MAX_ALG_NAME 64 bytes but it can increase in future.
> This should not be allocated on the stack.

OK. The mode string is only ever used within crypt_ctr(). It 
does not seem worth to move it into struct crypt_config or have
it dynamically allocated, so I'll drop this cleanup.

> But anyway, I see that the reason for this is to introduce multikey feature
> (compatible with loop-AES mode). That's interesting idea.
> 
> But please can you add more explanation into documentation about this mode?

Sure, let me see what I can do.

The most detailed description I know of is [1]. Besides the
description in the Loop-AES documentation there are also some 
notes I took while doing the reimplementation.

I'll see if I can put all these bits together into a document
to have one mode and format specification.

> Is there any paper which analyses that mode - if so can you add link
> to description?
> (and yes, I know loop-AES documentation:-)

I'm not aware of any papers which analyze these modes.

The 2004 paper by Saarinen[2] I think is what prompted the
creation of these modes, specifically do protect against the
weaknesses pointed out therein. 

The resulting v2 and v3 modes have not been independently 
analyzed as far as I'm aware. Anyone know better?

Thanks for your comments, 

	Max

-- 
[1] http://mail.nl.linux.org/linux-crypto/2006-01/msg00006.html
[2] http://mareichelt.de/pub/notmine/diskenc.pdf


