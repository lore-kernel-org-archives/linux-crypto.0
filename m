From: Matthias-Christian Ott <ott@mirix.org>
Subject: Re: [PATCH] crypto: user - Allow CRYPTO_MSG_GETALG without CAP_NET_ADMIN
Date: Sun, 04 May 2014 01:45:42 +0200
Message-ID: <53657FA6.8090707@mirix.org>
References: <534016A0.6020702@mirix.org> <201404282337.34142.marex@denx.de> <53614DBC.9090304@mirix.org> <201405011253.25329.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mirix.org ([78.46.130.147]:38476 "EHLO a.mirix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbaEDBnr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 May 2014 21:43:47 -0400
In-Reply-To: <201405011253.25329.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/01/14 12:53, Marek Vasut wrote:
> On Wednesday, April 30, 2014 at 09:23:40 PM, Matthias-Christian Ott w=
rote:
>> On 04/28/14 23:37, Marek Vasut wrote:
>>> On Friday, April 25, 2014 at 12:51:06 AM, Matthias-Christian Ott wr=
ote:
>>>> CRYPTO_USER requires CAP_NET_ADMIN for all operations. Most inform=
ation
>>>> provided by CRYPTO_MSG_GETALG is also accessible through /proc/mod=
ules
>>>> and AF_ALG. CRYPTO_MSG_GETALG should not require CAP_NET_ADMIN so =
that
>>>> processes without CAP_NET_ADMIN can use CRYPTO_MSG_GETALG to get c=
ipher
>>>> details, such as cipher priorities, for AF_ALG.
>>>>
>>>> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
>>>> ---
>>>>
>>>>  crypto/crypto_user.c | 12 +++++++++---
>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> Can you please submit the patch using git send-email so we can prop=
erly
>>> review it?
>>
>> git-send-email or more specifically Net::SMTP only works with IPv4. =
The
>> SMTP server I use for submission only listens IPv6 addresses. Moreov=
er,
>> TLS seems broken. I patched Net::SMTP to use IO::Socket::INET6 but g=
ave
>> up because of the TLS issues and used git format-patch and git imap-=
send.
>=20
> You can always set up a separate mailserver or use one of the many fr=
ee-to-use=20
> mailservers to follow the agreed-upon submission process, right?

I don't comment on this statement to keep this discussion focused (send
me a private email if you want to discuss it).

I did try to submit the email directly (with SPF disabled) from git
send-email to vger.kernel.org but vger.kernel.org uses greylisting, so =
I
can't help you with that.

Can you simply copy the file that was attached on the first email I
sent, save it to the filesystem and simply commit it in git? You would
have to do this anyway if I filed a bug in the Kernel Bug Tracker. So
there is an =93agreed-upon submission process=94 to commit a file.

> Of course, patches for Net::SMTP are welcome.

I reported the bug and someone who actually knows Perl is working on it=
=2E
