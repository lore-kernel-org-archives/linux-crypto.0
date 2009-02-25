From: Thiago Galesi <thiagogalesi@gmail.com>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 11:06:18 -0300
Message-ID: <82ecf08e0902250606g1e1a0a16l3a20fd1e8222d94e@mail.gmail.com>
References: <49A54C23.8090209@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
	akpm@linux-foundation.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
	lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:51673 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZBYOGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 09:06:20 -0500
In-Reply-To: <49A54C23.8090209@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> =A0 =A0 =A0 =A0int i;
> =A0 =A0 =A0 =A0int ret;
>
> - =A0 =A0 =A0 printk("\ntesting speed of %s\n", algo);
> + =A0 =A0 =A0 printk(KERN_INFO "\ntesting speed of %s\n", algo);

Wouldn't it be better to take the first \n out as well??


--=20
