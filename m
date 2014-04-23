From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Parity Error on keys used for DES crypto test
Date: Wed, 23 Apr 2014 18:58:13 -0500
Message-ID: <20140423185813.c885f8de953ed216b8895437@freescale.com>
References: <535777C0.9090000@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:20572
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751164AbaDXADS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Apr 2014 20:03:18 -0400
In-Reply-To: <535777C0.9090000@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 23 Apr 2014 10:20:16 +0200
leroy christophe <christophe.leroy@c-s.fr> wrote:

> I'm altering the Freescale Talitos Driver in order to support the SEC1 
> security engine, and I have a big issue with the DES test vectors in 
> testmgr.h:
> 
> The Sec Engine reports key parity error.
> 
> Looking at the keys defined in testmgr.h for DES3, it looks like there 
> is a real parity issue with the test vectors. A DES key is supposed to 
> have all bytes with an odd number of ones. It is not the case in the key 
> below. At least the second byte 0xC0 has an even number of ones.
> 
> static struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
>      { /* Generated from openssl */
>          .key    = "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
>                "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
>                "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
> 
> So, how can this test vector work ?

I'm not going to comment on the validity of the test key vector
other than to say that you can turn off key parity errors in the
SEC1 in the DEU Interrupt Control Register.

Kim
