From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: user - Allow CRYPTO_MSG_GETALG without CAP_NET_ADMIN
Date: Thu, 1 May 2014 12:53:25 +0200
Message-ID: <201405011253.25329.marex@denx.de>
References: <534016A0.6020702@mirix.org> <201404282337.34142.marex@denx.de> <53614DBC.9090304@mirix.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Matthias-Christian Ott" <ott@mirix.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:57619 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaEAO1o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 10:27:44 -0400
In-Reply-To: <53614DBC.9090304@mirix.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, April 30, 2014 at 09:23:40 PM, Matthias-Christian Ott wrote:
> On 04/28/14 23:37, Marek Vasut wrote:
> > On Friday, April 25, 2014 at 12:51:06 AM, Matthias-Christian Ott wrote:
> >> CRYPTO_USER requires CAP_NET_ADMIN for all operations. Most information
> >> provided by CRYPTO_MSG_GETALG is also accessible through /proc/modules
> >> and AF_ALG. CRYPTO_MSG_GETALG should not require CAP_NET_ADMIN so that
> >> processes without CAP_NET_ADMIN can use CRYPTO_MSG_GETALG to get cipher
> >> details, such as cipher priorities, for AF_ALG.
> >> 
> >> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
> >> ---
> >> 
> >>  crypto/crypto_user.c | 12 +++++++++---
> >>  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > Can you please submit the patch using git send-email so we can properly
> > review it?
> 
> git-send-email or more specifically Net::SMTP only works with IPv4. The
> SMTP server I use for submission only listens IPv6 addresses. Moreover,
> TLS seems broken. I patched Net::SMTP to use IO::Socket::INET6 but gave
> up because of the TLS issues and used git format-patch and git imap-send.

You can always set up a separate mailserver or use one of the many free-to-use 
mailservers to follow the agreed-upon submission process, right?

Of course, patches for Net::SMTP are welcome.

Best regards,
Marek Vasut
