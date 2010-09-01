From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: crypto_xor
Date: Wed, 01 Sep 2010 16:59:25 +0200
Message-ID: <4C7E6A4D.4010609@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41879 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab0IAPC3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Sep 2010 11:02:29 -0400
Received: by eyb6 with SMTP id 6so577650eyb.19
        for <linux-crypto@vger.kernel.org>; Wed, 01 Sep 2010 08:02:28 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,
 I was checking the crypto_xor() function and it is for some reason
limited to 32 bit integers. Why not make it depend on the architecture
by replacing the u32 with unsigned long? That way 64bit machines should
perform xor with less instructions...

Something like:

void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
{
        unsigned long *a = (unsigned long *)dst;
        unsigned long *b = (unsigned long *)src;

        for (; size >= sizeof(unsigned long); size -= sizeof(unsigned long))
                *a++ ^= *b++;

        crypto_xor_byte((u8 *)a, (u8 *)b, size);
}


regards,
Nikos
