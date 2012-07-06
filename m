From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish-avx - remove useless instruction
Date: Fri, 6 Jul 2012 02:13:00 +0200
Message-ID: <20120706001300.GF2091@kronos.redsun>
References: <20120705184358.GE2091@kronos.redsun>
 <20120705234612.GD29301@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2GFANH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jul 2012 20:13:07 -0400
Content-Disposition: inline
In-Reply-To: <20120705234612.GD29301@khazad-dum.debian.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 05, 2012 at 08:46:12PM -0300, Henrique de Moraes Holschuh wrote:
> Is it useless, or is it there to harden against some side-channel
> attack?

When writing this implementation, I first had a different approach with more
data getting read in and I just forgot to delete this instruction in the end.
The instruction didn't have any purpose regarding side-channel attacks. In the
decryption routine the instruction has been correctly deleted in the same
place.
