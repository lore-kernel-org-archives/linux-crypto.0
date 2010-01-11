From: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Mon, 11 Jan 2010 22:28:39 +0100
Message-ID: <20100111212839.GA29008@linux-m68k.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net> <4B390907.8010609@redhat.com> <20091229014639.GC26723@chaos.nusquama.org> <20100104152542.GA5388@quark.vpn.nusquama.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Max Vozeler <max@hinterhof.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:60501 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0AKV21 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2010 16:28:27 -0500
Received: by fg-out-1718.google.com with SMTP id 22so925811fge.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2010 13:28:25 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20100104152542.GA5388@quark.vpn.nusquama.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 04, 2010 at 04:25:42PM +0100, Max Vozeler wrote:


> +
> +These modes have two main characteristics compared to regular CBC
> +with sector IV. The first is implemented in dm-crypt, the second
> +is implemented in the lmk2 and lmk3 blkciphers.

the formulation is not very clear. Possibly better wording -

+ There are two main differences distinguishing the lmk2 and lmk3 modes 
+ from the blok cipher implemented in dm-crypt:


> +1) Use of 64 independent keys which are alternatingly applied to
> +different sectors.
> +
> +  key = keys[sectornum % 64]

not really "alternating" when there is more than 2, my try
"different sectors are encrypted with 64 independent keys selected by the
following rule"
+  key = keys[sectornum % 64]

> +2) IV derivation from an MD5 digest of the sector number, parts
> +of the plaintext data and a mode specific format constant. The
> +multi-key-v3 mode additionally uses a 128-bit IV seed.

slightly rephrased:

+2) IVs are derived from an MD5 digest of the sector number, parts
+of the plaintext data and a mode specific format constant. The
+multi-key-v3 mode additionally uses a 128-bit IV seed.

> +  v2IV = MD5(plaintext[16..511] ||
> +  	     truncated-sector-number ||
> +	     format-magic)
> +
> +  v3IV = MD5(ivseed ||
> +	     plaintext[16..511] ||
> +  	     truncated-sector-number ||
> +	     format-magic)

that seems different than what is described here -
 http://mail.nl.linux.org/linux-crypto/2006-01/msg00006.html

so is it compatible after all? Or where is format-magic' equivalent
hidden in Jari's description?

> +The format-magic for both modes is fixed at the value 4024
> +encoded as 32-bit little endian.

I am not familiar with this detail and the description does not make it
completely clear, it appears to refer to some magic value of the on disk 
representation?

> +Encryption:
> +
> +  IV = IVFUNC(optional-ivseed,
> +  	   plaintext[16..511],
> +  	   truncated-sector-number,
> +	   format-magic)

optional first argument in formalism makes it hard to relate to above decriptions.
So maybe introduce IVFUNC where you describe them above, including ivseed which is
simply unused in one variant.

> +  ciphertext[0..511] = CBC-ENCRYPT(key, IV, plaintext[0..511])

I know that key=key_table[sector_number & 63] is mentioned further above but
might be "too far back" for many readers as it is one of the things that are 
special about this encryption modes.

Richard

