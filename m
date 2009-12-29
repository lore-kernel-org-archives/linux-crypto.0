From: Max Vozeler <max@hinterhof.net>
Subject: Re: [PATCH 4/4] crypto: lmk2/lmk3 cipher block modes
Date: Tue, 29 Dec 2009 02:56:28 +0100
Message-ID: <20091229015628.GD26723@chaos.nusquama.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-5-git-send-email-max@hinterhof.net> <20091229011821.GC1348@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: Richard Zidlicky <rz@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from chaos.nusquama.org ([85.131.211.23]:56174 "EHLO
	chaos.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZL2B4a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 20:56:30 -0500
Content-Disposition: inline
In-Reply-To: <20091229011821.GC1348@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 29, 2009 at 02:18:21AM +0100, Richard Zidlicky wrote:
> On Mon, Dec 28, 2009 at 07:59:15PM +0100, Max Vozeler wrote:
> 
> > +	help
> > +	  LMK block cipher modes (lmk2/lmk3).
> > +
> > +	  These modes are compatible with Loop-AES. Use them with a 
> > +	  dm-crypt cipher string aes-lmk2-plain64-multi:64 (for Loop-AES
> > +	  v2.x) or aes-lmk2-plain64-multi:64 (for Loop-AES v3.x).
>                        ^^^^
> should that be lmk3 ?

Yes, you are right. Thanks for catching it,

	Max
