From: "Barry G" <mr.scada@gmail.com>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Wed, 29 Oct 2008 10:33:39 -0700
Message-ID: <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
	 <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Kim Phillips" <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:65406 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbYJ2Rdk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Oct 2008 13:33:40 -0400
Received: by yw-out-2324.google.com with SMTP id 9so38300ywe.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2008 10:33:39 -0700 (PDT)
In-Reply-To: <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> CONFIG_CRYPTO_DEV_TALITOS set to y, strongswan still successfully negotiates
>> an IPsec SA, but no traffic flows.
>
> does no traffic flow at all or is it all getting dropped?

Unencrypted traffic still flows fine.  Sniffing traffic on the encrypted link,
I see the ISAKMP SA init, but no ESP traffic flows after the link is
established even though I have traffic that matches the policy happening.

The firewall is not dropping traffic, as all default filter chain
policies are ACCEPT and
I have no rules added.

Interesting enough, the counters for the INPUT, FORWARD, and OUTPUT chain
all still increase even though no traffic leaves the device on the
remote network pointing
interface.

It looks to me like the kernel gets the SA and still processes
packets, but doesn't actually let them leave box.  The mangle and nat tables
are empty, so I don't know what would stop the packet that late in the flow.

>
>> Also, is it correct that Talitos only accelerates AEAD connections, not ESP/AH
>> protocols so there will be no performance increase for me until Strongswan
>> adds rfc5282 support?
>
> I'm not sure what you mean here; talitos supports aes-cbc but doesn't
> support aes-ccm nor aes-gcm.
The reason I ask is:
# cat /proc/crypto | grep -i talitos
driver       : authenc-hmac-md5-cbc-3des-talitos
driver       : authenc-hmac-md5-cbc-aes-talitos
driver       : authenc-hmac-sha256-cbc-3des-talitos
driver       : authenc-hmac-sha256-cbc-aes-talitos
driver       : authenc-hmac-sha1-cbc-3des-talitos
driver       : authenc-hmac-sha1-cbc-aes-talitos

All talitos drivers have the authenc prefix.  The aes-cbc entry in my
crypto is:
name         : cbc(aes)
driver       : cbc(aes-generic)
module       : kernel
priority     : 100
refcnt       : 1
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

Since its priority isn't 3000 and its driver isn't a talitos driver, I figure
it is software.   Disabling the software AES driver in the kernel
results in an error
from strongswan when it tries to add the SA to the kernel.

> can you try hmac(sha1) until I get a decent setkey?
Certainly.  I have reconfigured Strongswan to use AES-128 and SHA1:

# ip xfrm state
src 192.168.1.1 dst 192.168.1.2
	proto esp spi 0xca44d182 reqid 1 mode tunnel
	replay-window 32
	auth hmac(sha1) 0x48eacafaaaeb134933642d83c44f2293c277810b
	enc cbc(aes) 0x31f28f683a1e9774110abbafe462ac18
	sel src 0.0.0.0/0 dst 0.0.0.0/0
src 192.168.1.2 dst 192.168.1.1
	proto esp spi 0xc5240eb5 reqid 1 mode tunnel
	replay-window 32
	auth hmac(sha1) 0xbdf7f26e1ee7339f98dd12c35c85e4af3b671ebc
	enc cbc(aes) 0x49ffa621e1baf7921857f4fe1a8003e4
	sel src 0.0.0.0/0 dst 0.0.0.0/0

Moving to aes-128 and sha1 had no affect on the problem.
Unsetting CONFIG_CRYPTO_DEV_TALITOS gives me ESP traffic
and everything works as desired.

FYI, my network is 10.201.0./16--192.168.1.1/24==192.168.1.2/24--192.168.2.0/24

Thanks Kim!

Barry
