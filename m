From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: "deflate" crypto module questions
Date: Wed, 25 Jun 2008 21:14:57 +0200
Message-ID: <20080625191457.GA30142@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.0806251916240.8685@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: James Morris <jmorris@namei.org>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48531 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYFYTPA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2008 15:15:00 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806251916240.8685@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Geert Uytterhoeven | 2008-06-25 19:26:28 [+0200]:

>	Hi,
Hello,

>
>I have a few questions about the "deflate" crypto module (crypto/deflate.c).
>
>  1. Why does it support decompression of full chunks only (i.e. all compressed
>     data has to be passed at once)?  Is there a specific reason for that?
>     Or is it just because so far nobody needed partial decompression?
I guess the latter. The only user is ipcomp_decompress() as far as I can
see. Other zlib users like ppp or jffs2 user zlib directly. However, the
crypto API is the only place in kernel which provides you a generic
interface for compression.

>Please CC me, as I'm not subscribed, and
>http://vger.kernel.org/vger-lists.html#linux-crypto doesn't list any archives.
Try
http://www.mail-archive.com/linux-crypto@vger.kernel.org/
or
http://marc.info/?l=linux-crypto-vger&r=1&b=200806&w=2

David: do you thing it is a good idea to add them to the list?

>Geert Uytterhoeven
>Software Architect

Sebastian
