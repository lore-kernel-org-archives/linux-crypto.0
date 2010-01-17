From: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Sun, 17 Jan 2010 23:02:34 +0100
Message-ID: <20100117220234.GB25292@linux-m68k.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net> <4B390907.8010609@redhat.com> <20091229014639.GC26723@chaos.nusquama.org> <20100104152542.GA5388@quark.vpn.nusquama.org> <20100111212839.GA29008@linux-m68k.org> <20100113172715.GA29443@quark.vpn.nusquama.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Max Vozeler <max@hinterhof.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:27797 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0AQWBv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2010 17:01:51 -0500
Received: by fg-out-1718.google.com with SMTP id 22so464570fge.1
        for <linux-crypto@vger.kernel.org>; Sun, 17 Jan 2010 14:01:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20100113172715.GA29443@quark.vpn.nusquama.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

> The format-magic is not mentioned in Jari's description, but
> is indeed used by Loop-AES.
> 
> Compare loop-AES-v3.2h/glue.c:402:
> 
>   /* 4024 bits == 31 * 128 bit plaintext blocks + 56 bits of sector number */
>   /* For version 3 on-disk format this really should be 4536 bits, but can't be */
>   /* changed without breaking compatibility. V3 uses MD5-with-wrong-length IV */
>   buf[14] = 4024;
>   buf[15] = 0;
> 
> > > +The format-magic for both modes is fixed at the value 4024
> > > +encoded as 32-bit little endian.
> > 
> > I am not familiar with this detail and the description does not make it
> > completely clear, it appears to refer to some magic value of the on disk 
> > representation?
> 
> The magic is only used as an additional input to the MD5 digest 
> as part of the IV derivation.

> diff --git a/Documentation/crypto/lmk.txt b/Documentation/crypto/lmk.txt
> new file mode 100644
> index 0000000..91ca7f7
> --- /dev/null
> +++ b/Documentation/crypto/lmk.txt
> @@ -0,0 +1,102 @@
> +Loop-AES compatible cipher block chaining modes
> +-----------------------------------------------
> +
> +The following table shows the Loop-AES name of the mode, the
> +Loop-AES version first supporting it, and the equivalent cipher
> +specification string for dm-crypt:
> +
> +  single-key     Loop-AES v1.x   cbc-plain
> +  multi-key-v2   Loop-AES v2.x   lmk2-plain64-multi:64
> +  multi-key-v3   Loop-AES v3.x   lmk3-plain64-multi:64
> +
> +This text describes the multi-key-v2 and multi-key-v3 modes and
> +their implementation in the Linux kernel.

pointer to alternative implementation with loop-AES?

> +The multi-key modes describe a combination of CBC using a 
> +specific IV derivation function with the use of multiple
> +independent encryption keys.
> +
> +The IV derivation and block chaining are implemented as
> +blkciphers named "lmk2" and "lmk3". The support for multiple
> +encryption keys is implemented in dm-crypt.
> +
> +Multiple keys:
> +
> +  Each sector is encrypted/decrypted with one of 64 independent
> +  keys selected by the following rule:
> +
> +  key = keys[sectornum % 64]
> +
> +IV derivation:
> +
> +  IVs are derived from an MD5 digest of the sector number, parts
> +  of the plaintext data and a mode specific format constant. The
> +  multi-key-v3 mode additionally uses a 128-bit IV seed.
> +
> +  v2IV = MD5(plaintext[16..511] ||
> +             le64(truncated-sector-number) ||
> +             le32(format-magic))
> +
> +  v3IV = MD5(ivseed ||
> +             plaintext[16..511] ||
> +             le64(truncated-sector-number) ||
> +             le32(format-magic))

ivseed = key_table[64] is nowhere declared. Also "||" should be explained,
it is probably conatenation like in Jari's description? Hard to think of
a really intuitive notation.."o" or "<<" might be intuitive for many but
does not look too good in this case, especially in ASCII.

> +  The input IV supplied to lmk2 or lmk3 is expected to be the
> +  sector number in 64-bit little endian as supplied by the
> +  plain64 dm-crypt IV generator. It gets truncated to 56 bits
> +  with the most significant byte set to 0x80:

I believe preceding paragraoh can be completely omitted, is not easier to 
understand than the pseudocode.

> +  truncated-sector-number =
> +    (sectornum & 0x00ffffffffffffff) | 0x8000000000000000

would be better above the IV derivation descriptions.

> +Mode multi-key-v2 (lmk2-plain64-multi:64):
> +
> +  key = keys[sectornum % 64]
> +
> +  encrypt:
> +    IV = MD5(plaintext[16..511] ||
> +             le64(truncated-sector-number) ||
> +             le32(format-magic))

no need to repeat the IV description here, could use the v2/v3IV in the pseudocode
bellow. For the decryption IVs it would be then better to use some more distinct 
names because eg IV2 is fairly close to v2IV.

Btw did you send the other parts of the patch to the list? I did only ever receive the
description part so feel free to email me the other parts.

Richard
