From: Thiago Galesi <thiagogalesi@gmail.com>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 11:29:12 -0300
Message-ID: <82ecf08e0902250629n6a190165u557c21b0ebe797d5@mail.gmail.com>
References: <49A54C23.8090209@suse.de>
	 <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
	darrenrjenkins@gmail.com
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:44853 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246AbZBYO3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 09:29:14 -0500
In-Reply-To: <49A55499.6090700@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 25, 2009 at 11:24 AM, Frank Seidel <fseidel@suse.de> wrote:
> Herbert Xu wrote:
>>> - =A0 =A0char output[1024];
>>
>> How about just making it static?
>
> Well, it was static before. But there
> are efforts to reduce current stack memory
> footprints.

If you write static char output[1024]; (even inside a function) it's
not allocated on the stack.

--=20
