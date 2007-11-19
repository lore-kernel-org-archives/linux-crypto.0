From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Moving xor_* functions into common header file
Date: Tue, 20 Nov 2007 02:34:48 +0800
Message-ID: <fd3e431c0711191034qe0bda50r5123544076795b42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>
To: "Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:27507 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXKSSev (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2007 13:34:51 -0500
Received: by ik-out-1112.google.com with SMTP id c28so816769ika
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2007 10:34:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

'grep "static void xor_" crypto/*' shows that cbc.c, ctr.c, pcbc.c and
xcbc.c share similar xor_* functions. It seems a good idea to
encourage code reuse by putting them into a common header (iirc
Evgeniy  suggested it when reviewing one of my earlier mail). It will
also be useful to me when porting other eSTREAM ciphers. So I would
like to move them into include/crypto/xor_n.h and make them all
"static inline". Any objections?

For xor_byte and xor_quad, the implementation in ctr.c differs from
that in cbc.c and pcbc.c. In cbc.c and pcbc.c we have:

    static void xor_byte(u8 *a, const u8 *b, unsigned int bs)
    {
            do {
                    *a++ ^= *b++;
            } while (--bs);
    }

  static void xor_quad(u8 *dst, const u8 *src, unsigned int bs)
    {
            u32 *a = (u32 *)dst;
            u32 *b = (u32 *)src;

            do {
                    *a++ ^= *b++;
            } while ((bs -= 4));
    }

while in ctr.c it is:

    static void xor_byte(u8 *a, const u8 *b, unsigned int bs)
    {
            for (; bs; bs--)
                    *a++ ^= *b++;
    }

    static void xor_quad(u8 *dst, const u8 *src, unsigned int bs)
    {
            u32 *a = (u32 *)dst;
            u32 *b = (u32 *)src;

            for (; bs >= 4; bs -= 4)
                    *a++ ^= *b++;

            xor_byte((u8 *)a, (u8 *)b, bs);
    }

The former saves one check by assuming bs > 0. For cbc.c and pcbc.c,
we can assume bs > 0 since xor() uses the non-negative blocksize. For
ctr.c, we check bs == 0 as the call to xor_quad uses min(nbytes,
bsize). Given that we need both semantics, I would like to propose
renaming the former as xor_byte_quick() and xor_quad_block() in the
common header. Would that be fine?

Swee Heng
