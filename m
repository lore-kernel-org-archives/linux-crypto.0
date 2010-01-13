From: Max Vozeler <max@hinterhof.net>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Wed, 13 Jan 2010 18:27:15 +0100
Message-ID: <20100113172715.GA29443@quark.vpn.nusquama.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
 <1262026755-23056-2-git-send-email-max@hinterhof.net>
 <4B390907.8010609@redhat.com>
 <20091229014639.GC26723@chaos.nusquama.org>
 <20100104152542.GA5388@quark.vpn.nusquama.org>
 <20100111212839.GA29008@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Cc: Milan Broz <mbroz@redhat.com>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:34632 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab0AMR3x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2010 12:29:53 -0500
Content-Disposition: inline
In-Reply-To: <20100111212839.GA29008@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Richard,

On Mon, Jan 11, 2010 at 10:28:39PM +0100, Richard Zidlicky wrote:
> On Mon, Jan 04, 2010 at 04:25:42PM +0100, Max Vozeler wrote:
> > +
> > +These modes have two main characteristics compared to regular CBC
> > +with sector IV. The first is implemented in dm-crypt, the second
> > +is implemented in the lmk2 and lmk3 blkciphers.
> 
> the formulation is not very clear. Possibly better wording -
> 
> + There are two main differences distinguishing the lmk2 and lmk3 modes 
> + from the blok cipher implemented in dm-crypt:

I reworked this part in the new version below.

> > +1) Use of 64 independent keys which are alternatingly applied to
> > +different sectors.
> > +
> > +  key = keys[sectornum % 64]
> 
> not really "alternating" when there is more than 2, my try
> "different sectors are encrypted with 64 independent keys selected by the
> following rule"
> +  key = keys[sectornum % 64]

Good point, thanks.

> > +2) IV derivation from an MD5 digest of the sector number, parts
> > +of the plaintext data and a mode specific format constant. The
> > +multi-key-v3 mode additionally uses a 128-bit IV seed.
> 
> slightly rephrased:
> 
> +2) IVs are derived from an MD5 digest of the sector number, parts
> +of the plaintext data and a mode specific format constant. The
> +multi-key-v3 mode additionally uses a 128-bit IV seed.

Agreed. I included your rephrasing.

> > +  v2IV = MD5(plaintext[16..511] ||
> > +  	     truncated-sector-number ||
> > +	     format-magic)
> > +
> > +  v3IV = MD5(ivseed ||
> > +	     plaintext[16..511] ||
> > +  	     truncated-sector-number ||
> > +	     format-magic)
> 
> that seems different than what is described here -
>  http://mail.nl.linux.org/linux-crypto/2006-01/msg00006.html
> 
> so is it compatible after all? Or where is format-magic' equivalent
> hidden in Jari's description?

The format-magic is not mentioned in Jari's description, but
is indeed used by Loop-AES.

Compare loop-AES-v3.2h/glue.c:402:

  /* 4024 bits == 31 * 128 bit plaintext blocks + 56 bits of sector number */
  /* For version 3 on-disk format this really should be 4536 bits, but can't be */
  /* changed without breaking compatibility. V3 uses MD5-with-wrong-length IV */
  buf[14] = 4024;
  buf[15] = 0;

> > +The format-magic for both modes is fixed at the value 4024
> > +encoded as 32-bit little endian.
> 
> I am not familiar with this detail and the description does not make it
> completely clear, it appears to refer to some magic value of the on disk 
> representation?

The magic is only used as an additional input to the MD5 digest 
as part of the IV derivation.

Changed the description to hopefully clarify this.

> > +Encryption:
> > +
> > +  IV = IVFUNC(optional-ivseed,
> > +  	   plaintext[16..511],
> > +  	   truncated-sector-number,
> > +	   format-magic)
> 
> optional first argument in formalism makes it hard to relate to above decriptions.
> So maybe introduce IVFUNC where you describe them above, including ivseed which is
> simply unused in one variant.
>
> > +  ciphertext[0..511] = CBC-ENCRYPT(key, IV, plaintext[0..511])
> 
> I know that key=key_table[sector_number & 63] is mentioned further above but
> might be "too far back" for many readers as it is one of the things that are 
> special about this encryption modes.

Agreed on both points. Could you have a look and see if you
find it clearer now in the new version?

Thanks a lot for your comments,

	Max

--KsGdsel6WgEHnImy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="lmk_doc_v2.patch"

diff --git a/Documentation/crypto/lmk.txt b/Documentation/crypto/lmk.txt
new file mode 100644
index 0000000..91ca7f7
--- /dev/null
+++ b/Documentation/crypto/lmk.txt
@@ -0,0 +1,102 @@
+Loop-AES compatible cipher block chaining modes
+-----------------------------------------------
+
+The following table shows the Loop-AES name of the mode, the
+Loop-AES version first supporting it, and the equivalent cipher
+specification string for dm-crypt:
+
+  single-key     Loop-AES v1.x   cbc-plain
+  multi-key-v2   Loop-AES v2.x   lmk2-plain64-multi:64
+  multi-key-v3   Loop-AES v3.x   lmk3-plain64-multi:64
+
+This text describes the multi-key-v2 and multi-key-v3 modes and
+their implementation in the Linux kernel.
+
+The multi-key modes describe a combination of CBC using a 
+specific IV derivation function with the use of multiple
+independent encryption keys.
+
+The IV derivation and block chaining are implemented as
+blkciphers named "lmk2" and "lmk3". The support for multiple
+encryption keys is implemented in dm-crypt.
+
+Multiple keys:
+
+  Each sector is encrypted/decrypted with one of 64 independent
+  keys selected by the following rule:
+
+  key = keys[sectornum % 64]
+
+IV derivation:
+
+  IVs are derived from an MD5 digest of the sector number, parts
+  of the plaintext data and a mode specific format constant. The
+  multi-key-v3 mode additionally uses a 128-bit IV seed.
+
+  v2IV = MD5(plaintext[16..511] ||
+             le64(truncated-sector-number) ||
+             le32(format-magic))
+
+  v3IV = MD5(ivseed ||
+             plaintext[16..511] ||
+             le64(truncated-sector-number) ||
+             le32(format-magic))
+
+  The format-magic is a constant value (4024).
+
+  The input IV supplied to lmk2 or lmk3 is expected to be the
+  sector number in 64-bit little endian as supplied by the
+  plain64 dm-crypt IV generator. It gets truncated to 56 bits
+  with the most significant byte set to 0x80:
+
+  truncated-sector-number =
+    (sectornum & 0x00ffffffffffffff) | 0x8000000000000000
+
+Mode multi-key-v2 (lmk2-plain64-multi:64):
+
+  key = keys[sectornum % 64]
+
+  encrypt:
+    IV = MD5(plaintext[16..511] ||
+             le64(truncated-sector-number) ||
+             le32(format-magic))
+
+    ciphertext[0..511] = CBC-ENCRYPT(key, IV, plaintext[0..511])
+
+  decrypt:
+    IV1 = ciphertext[0..15]
+    plaintext[16..511] = CBC-DECRYPT(key, IV1, ciphertext[16..511])
+
+    IV2 = MD5(plaintext[16..511] ||
+              le64(truncated-sector-number) ||
+              le32(format-magic))
+
+    plaintext[0..15] = DECRYPT(key, IV2, ciphertext[0..15])
+
+Mode multi-key-v3 (lmk3-plain64-multi:64):
+
+  key = keys[sectornum % 64]
+
+  encrypt:
+    IV = MD5(ivseed,
+             plaintext[16..511],
+             le64(truncated-sector-number),
+             le32(format-magic))
+
+    ciphertext[0..511] = CBC-ENCRYPT(key, IV, plaintext[0..511])
+
+  decrypt:
+    IV1 = ciphertext[0..15]
+    plaintext[16..511] = CBC-DECRYPT(key, IV1, ciphertext[16..511])
+
+    IV2 = MD5(ivseed,
+              plaintext[16..511],
+              le64(truncated-sector-number),
+              le32(format-magic))
+
+    plaintext[0..15] = DECRYPT(key, IV2, ciphertext[0..15])
+
+References:
+
+Mode description by the author of Loop-AES, Jari Ruusu:
+http://mail.nl.linux.org/linux-crypto/2006-01/msg00006.html

--KsGdsel6WgEHnImy--
