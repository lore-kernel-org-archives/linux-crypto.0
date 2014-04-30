From: Matthias-Christian Ott <ott@mirix.org>
Subject: Re: [PATCH] crypto: user - Allow CRYPTO_MSG_GETALG without CAP_NET_ADMIN
Date: Wed, 30 Apr 2014 21:23:40 +0200
Message-ID: <53614DBC.9090304@mirix.org>
References: <534016A0.6020702@mirix.org> <5359955A.4070903@mirix.org> <201404282337.34142.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mirix.org ([78.46.130.147]:57567 "EHLO a.mirix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758944AbaD3TW4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Apr 2014 15:22:56 -0400
In-Reply-To: <201404282337.34142.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/28/14 23:37, Marek Vasut wrote:
> On Friday, April 25, 2014 at 12:51:06 AM, Matthias-Christian Ott wrote:
>> CRYPTO_USER requires CAP_NET_ADMIN for all operations. Most information
>> provided by CRYPTO_MSG_GETALG is also accessible through /proc/modules
>> and AF_ALG. CRYPTO_MSG_GETALG should not require CAP_NET_ADMIN so that
>> processes without CAP_NET_ADMIN can use CRYPTO_MSG_GETALG to get cipher
>> details, such as cipher priorities, for AF_ALG.
>>
>> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
>> ---
>>  crypto/crypto_user.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> Can you please submit the patch using git send-email so we can properly review 
> it?

git-send-email or more specifically Net::SMTP only works with IPv4. The
SMTP server I use for submission only listens IPv6 addresses. Moreover,
TLS seems broken. I patched Net::SMTP to use IO::Socket::INET6 but gave
up because of the TLS issues and used git format-patch and git imap-send.

Regards,
Matthias-Christian
