From: Max Vozeler <max@hinterhof.net>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Mon, 4 Jan 2010 16:25:42 +0100
Message-ID: <20100104152542.GA5388@quark.vpn.nusquama.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
 <1262026755-23056-2-git-send-email-max@hinterhof.net>
 <4B390907.8010609@redhat.com>
 <20091229014639.GC26723@chaos.nusquama.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Milan Broz <mbroz@redhat.com>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:52407 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0ADP0P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jan 2010 10:26:15 -0500
Content-Disposition: inline
In-Reply-To: <20091229014639.GC26723@chaos.nusquama.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 29, 2009 at 02:46:39AM +0100, Max Vozeler wrote:
> On Mon, Dec 28, 2009 at 08:37:43PM +0100, Milan Broz wrote:
> > But anyway, I see that the reason for this is to introduce multikey feature
> > (compatible with loop-AES mode). That's interesting idea.
> > 
> > But please can you add more explanation into documentation about this mode?
> 
> Sure, let me see what I can do.
> 
> The most detailed description I know of is [1]. Besides the
> description in the Loop-AES documentation there are also some 
> notes I took while doing the reimplementation.
> 
> I'll see if I can put all these bits together into a document
> to have one mode and format specification.

This adds a short document detailing the two multi-key modes. I 
think it covers all important points.

Review much appreciated. Thanks,

	Max

-- 
diff --git a/Documentation/crypto/lmk.txt b/Documentation/crypto/lmk.txt
new file mode 100644
index 0000000..cb7d9da
--- /dev/null
+++ b/Documentation/crypto/lmk.txt
@@ -0,0 +1,72 @@
+Loop-AES compatible cipher block chaining modes
+-----------------------------------------------
+
+There are three modes supported by loop-AES at the time of this
+writing:
+
+  Loop-AES v1.x    single-key      cbc-plain
+  Loop-AES v2.x    multi-key-v2    lmk2-plain64-multi:64
+  Loop-AES v3.x    multi-key-v3    lmk3-plain64-multi:64
+
+This text describes the multi-key-v2 and multi-key-v3 modes and
+their implementation in the Linux kernel.
+
+These modes have two main characteristics compared to regular CBC
+with sector IV. The first is implemented in dm-crypt, the second
+is implemented in the lmk2 and lmk3 blkciphers.
+
+1) Use of 64 independent keys which are alternatingly applied to
+different sectors.
+
+  key = keys[sectornum % 64]
+
+2) IV derivation from an MD5 digest of the sector number, parts
+of the plaintext data and a mode specific format constant. The
+multi-key-v3 mode additionally uses a 128-bit IV seed.
+
+  v2IV = MD5(plaintext[16..511] ||
+  	     truncated-sector-number ||
+	     format-magic)
+
+  v3IV = MD5(ivseed ||
+	     plaintext[16..511] ||
+  	     truncated-sector-number ||
+	     format-magic)
+
+The sector number is obtained from the plain64 dm-crypt IV
+generator. It is converted to 64-bit little endian and then
+truncated to 56 bits:
+
+  truncated-sector-number =
+     (sectornum & 0x00ffffffffffffff) | 0x8000000000000000
+
+The format-magic for both modes is fixed at the value 4024
+encoded as 32-bit little endian.
+
+Encryption:
+
+  IV = IVFUNC(optional-ivseed,
+  	   plaintext[16..511],
+  	   truncated-sector-number,
+	   format-magic)
+
+  ciphertext[0..511] = CBC-ENCRYPT(key, IV, plaintext[0..511])
+
+Decryption:
+
+  IV1 = ciphertext[0..15]
+
+  plaintext[16..511] = CBC-DECRYPT(key, IV1, ciphertext[16..511])
+
+  IV2 = IVFUNC(optional-ivseed,
+  	   plaintext[16..511],
+  	   truncated-sector-number,
+	   format-magic)
+
+  plaintext[0..15] = DECRYPT(key, IV2, ciphertext[0..15])
+
+References:
+
+  Mode description by the author of Loop-AES, Jari Ruusu:
+  http://mail.nl.linux.org/linux-crypto/2006-01/msg00006.html
+
