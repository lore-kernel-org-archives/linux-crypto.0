From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] treewide: Update sha_transform
Date: Tue, 09 Aug 2011 17:57:28 -0700
Message-ID: <1312937848.11924.44.camel@Joe-Laptop>
References: <1312844837-10086-1-git-send-email-msb@chromium.org>
	 <1312847115.1643.22.camel@Joe-Laptop> <20110809055226.GE6103@google.com>
	 <1312880303.1676.5.camel@Joe-Laptop>
	 <CA+55aFwHEoDkWr6Mh=r1KG4MLRbY0_iVF-v3BPkK+zhxkriHdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Mandeep Singh Baines <msb@chromium.org>,
	linux-kernel@vger.kernel.org,
	Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
	Nicolas Pitre <nico@fluxnic.net>,
	Joachim Eastwood <manabian@gmail.com>,
	Andreas Schwab <schwab@linux-m68k.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	GeertUytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:44967 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164Ab1HJA5b (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2011 20:57:31 -0400
In-Reply-To: <CA+55aFwHEoDkWr6Mh=r1KG4MLRbY0_iVF-v3BPkK+zhxkriHdw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-08-09 at 08:41 -0700, Linus Torvalds wrote:
> On Tue, Aug 9, 2011 at 1:58 AM, Joe Perches <joe@perches.com> wrote:
> > Eliminate possible sha_transform unaligned accesses to data by copying
> > data to an aligned __u32 array if necessary.
> This is wrong. Not only does it double the stack space, when I tried
> it for git it just made things slower. So don't do it.

Maybe the aligned copy should be in an
#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS block.

Maybe Mandeep could test aligned/unaligned speeds
for his board?
