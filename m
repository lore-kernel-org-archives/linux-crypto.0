From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: "deflate" crypto module questions
Date: Thu, 26 Jun 2008 11:17:33 +0200
Message-ID: <20080626091733.GA2464@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.0806251916240.8685@vixen.sonytel.be> <20080625191457.GA30142@Chamillionaire.breakpoint.cc> <Pine.LNX.4.64.0806260912120.9465@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: James Morris <jmorris@namei.org>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41052 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbYFZJRg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jun 2008 05:17:36 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806260912120.9465@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Geert Uytterhoeven | 2008-06-26 09:14:51 [+0200]:

>On Wed, 25 Jun 2008, Sebastian Siewior wrote:
>> see. Other zlib users like ppp or jffs2 user zlib directly. However, the
>> crypto API is the only place in kernel which provides you a generic
>> interface for compression.
>
>Indeed. So if a hardware-assisted deflate would be available as a crypto
>module, "deflate" crypto module users would benefit from it automatically,
>right? While direct zlib users are out of luck.
Haven't look at this from that perspective but yes. This is allready the
case for crypto HW.

>With kind regards,
>
>Geert Uytterhoeven
>Software Architect

Sebastian
