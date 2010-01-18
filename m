From: Max Vozeler <max@hinterhof.net>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Mon, 18 Jan 2010 18:08:58 +0100
Message-ID: <20100118170858.GE3964@quark.vpn.nusquama.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
 <1262026755-23056-2-git-send-email-max@hinterhof.net>
 <4B390907.8010609@redhat.com>
 <20091229014639.GC26723@chaos.nusquama.org>
 <20100104152542.GA5388@quark.vpn.nusquama.org>
 <20100111212839.GA29008@linux-m68k.org>
 <20100113172715.GA29443@quark.vpn.nusquama.org>
 <20100117220234.GB25292@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:50282 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0ARRJX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2010 12:09:23 -0500
Content-Disposition: inline
In-Reply-To: <20100117220234.GB25292@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Richard,

On Sun, Jan 17, 2010 at 11:02:34PM +0100, Richard Zidlicky wrote:
> > diff --git a/Documentation/crypto/lmk.txt b/Documentation/crypto/lmk.txt
> > new file mode 100644
> > index 0000000..91ca7f7
> > --- /dev/null
> > +++ b/Documentation/crypto/lmk.txt
> > @@ -0,0 +1,102 @@
> > +Loop-AES compatible cipher block chaining modes
> > +-----------------------------------------------
> > +
> > +The following table shows the Loop-AES name of the mode, the
> > +Loop-AES version first supporting it, and the equivalent cipher
> > +specification string for dm-crypt:
> > +
> > +  single-key     Loop-AES v1.x   cbc-plain
> > +  multi-key-v2   Loop-AES v2.x   lmk2-plain64-multi:64
> > +  multi-key-v3   Loop-AES v3.x   lmk3-plain64-multi:64
> > +
> > +This text describes the multi-key-v2 and multi-key-v3 modes and
> > +their implementation in the Linux kernel.
> 
> pointer to alternative implementation with loop-AES?

OK, I will point to Loop-AES itself.

> > +The multi-key modes describe a combination of CBC using a 
> > +specific IV derivation function with the use of multiple
> > +independent encryption keys.
> > +
> > +The IV derivation and block chaining are implemented as
> > +blkciphers named "lmk2" and "lmk3". The support for multiple
> > +encryption keys is implemented in dm-crypt.
> > +
> > +Multiple keys:
> > +
> > +  Each sector is encrypted/decrypted with one of 64 independent
> > +  keys selected by the following rule:
> > +
> > +  key = keys[sectornum % 64]
> > +
> > +IV derivation:
> > +
> > +  IVs are derived from an MD5 digest of the sector number, parts
> > +  of the plaintext data and a mode specific format constant. The
> > +  multi-key-v3 mode additionally uses a 128-bit IV seed.
> > +
> > +  v2IV = MD5(plaintext[16..511] ||
> > +             le64(truncated-sector-number) ||
> > +             le32(format-magic))
> > +
> > +  v3IV = MD5(ivseed ||
> > +             plaintext[16..511] ||
> > +             le64(truncated-sector-number) ||
> > +             le32(format-magic))
> 
> ivseed = key_table[64] is nowhere declared. 

This is an implementation detail of Loop-AES, so I don't consider it 
belonging to the description of the modes here. Loop-AES v3 keyfiles
contain 65 keys of which the last key is used as IV seed.

> Also "||" should be explained, it is probably conatenation like in
> Jari's description? Hard to think of a really intuitive notation.."o"
> or "<<" might be intuitive for many but does not look too good in this
> case, especially in ASCII.

OK, I agree this needs pointing out. The "||" for concatenation is
what I'm familiar with, I don't think I would understand "o" or "<<"
as well. I will explain what it does.

> > +  The input IV supplied to lmk2 or lmk3 is expected to be the
> > +  sector number in 64-bit little endian as supplied by the
> > +  plain64 dm-crypt IV generator. It gets truncated to 56 bits
> > +  with the most significant byte set to 0x80:
> 
> I believe preceding paragraoh can be completely omitted, is not easier to 
> understand than the pseudocode.

OK. I'll drop the last sentence, the first one describing where the
IV is expected to come from seems relevant.

> > +  truncated-sector-number =
> > +    (sectornum & 0x00ffffffffffffff) | 0x8000000000000000
> 
> would be better above the IV derivation descriptions.

Noted.

> > +Mode multi-key-v2 (lmk2-plain64-multi:64):
> > +
> > +  key = keys[sectornum % 64]
> > +
> > +  encrypt:
> > +    IV = MD5(plaintext[16..511] ||
> > +             le64(truncated-sector-number) ||
> > +             le32(format-magic))
> 
> no need to repeat the IV description here, could use the v2/v3IV in the pseudocode
> bellow. 

I think repeating it makes it clearer which parts happen at 
which time, so I'd leave this as is.

> For the decryption IVs it would be then better to use some more distinct 
> names because eg IV2 is fairly close to v2IV.

Good point, thanks. Will change.

> Btw did you send the other parts of the patch to the list? I did only
> ever receive the description part so feel free to email me the other
> parts.

I did send them all to linux-crypto@vger. I'm not sure why you 
didn't receive them. I'll send you the missing parts and CC you
on the next submission.

Thanks again for your comments,

	Max
