From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 16:54:53 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be>
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
	lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com,
	Frank Seidel <frank@f-seidel.de>
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34091 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754143AbZBYPy4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 10:54:56 -0500
In-Reply-To: <49A55B5A.70705@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 25 Feb 2009, Frank Seidel wrote:
> -	printk("\ntesting speed of %s\n", algo);
> +	printk(KERN_INFO "\ntesting speed of %s\n", algo);
                          ^^
			  woops

BTW, why are you using printk(KERN_INFO "..."), and not pr_info("...")?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
