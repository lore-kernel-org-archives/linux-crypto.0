From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Date: Thu, 01 Sep 2011 18:19:00 +0200
Message-ID: <4E5FB074.6000404@gnutls.org>
References: <CAJU7za+OAusW-n9F4CLJNSAXVQTE2gxkdgpDFZb2tfys3EZspw@mail.gmail.com>	<20110901145902.GA31834@gondor.apana.org.au>	<CAJU7zaKnKYYLx6W_9WsZCcwhNd0KMM9R8fs2D0=Xd_6T_AE4=A@mail.gmail.com> <20110901.113234.755815899606372879.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.hengli.com.au, phil@nwl.cc,
	cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43286 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1IAQTD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 12:19:03 -0400
In-Reply-To: <20110901.113234.755815899606372879.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/01/2011 05:32 PM, David Miller wrote:
> From: Nikos Mavrogiannopoulos<nmav@gnutls.org>
> Date: Thu, 1 Sep 2011 17:06:06 +0200
>
>> It would be interesting to have a partial kernel-space TLS
>> implementation but I don't know whether such a thing could ever make
>> it to kernel.
> Herbert and I have discussed this several times and we plan on
> implementing this at some point.

The problem is that TLS is not a universal thing. There is still SSH,
kerberos, openvpn (as far as I remember it is a custom protocol), etc. 
It makes sense to have something to apply broadly, especially when it is 
in the Linux kernel. Currently have a device such as /dev/crypto looks 
like a good compromise.

regards,
Nikos
