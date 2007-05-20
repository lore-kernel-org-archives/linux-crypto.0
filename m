From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [1/2] 2.6.22-rc2: known regressions with patches
Date: Sun, 20 May 2007 03:10:50 +0200
Message-ID: <20070520011050.GA31667@uranus.ravnborg.org>
References: <464F74F2.8090207@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Bob Tracy <rct@gherkin.frus.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	Christian Volkmann <haveaniceday@cv-sv.de>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Luca Tettamanti <kronos.it@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:46749 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbXETBJy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 May 2007 21:09:54 -0400
Content-Disposition: inline
In-Reply-To: <464F74F2.8090207@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, May 20, 2007 at 12:06:42AM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc2
> with patches available.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> 
> Unclassified
> 
> Subject    : 2.6.22-rc2: section mismatch
> References : http://lkml.org/lkml/2007/5/19/59
> Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
> Handled-By : Sam Ravnborg <sam@ravnborg.org>
> Status     : fixed in kbuild-git.git
2 warnings are fixed in kbuild.git
The rest are fixed by http://lkml.org/lkml/2007/5/19/89 which I assume Andi Keen
take care of.

	Sam
