From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: RSA verification in the kernel
Date: Thu, 13 Jan 2011 09:08:05 +0100
Message-ID: <AANLkTi=O3Kn3u8-4P0MaFfzWBRY4P4bfE6a3n+xHt+EQ@mail.gmail.com>
References: <4D2EA764.4070109@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53436 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab1AMIIH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Jan 2011 03:08:07 -0500
Received: by qwa26 with SMTP id 26so1512480qwa.19
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jan 2011 00:08:05 -0800 (PST)
In-Reply-To: <4D2EA764.4070109@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 13, 2011 at 8:19 AM, Dmitry Kasatkin
<dmitry.kasatkin@nokia.com> wrote:
> Hi,
> Does anybody know if there is a GPL implementation of RSA verification
> for the Linux kernel?
> I know DigSig, but is anything recent available?

In NCR [http://home.gna.org/cryptodev-linux/ncr.html] I've added RSA and DSA
using the public domain libtommath/libtomcrypt. You could use them. The internal
API for RSA is the libtomcrypt one.

regards,
Nikos
