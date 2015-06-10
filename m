From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] trivial: report backend_cra_name when allocation fails
Date: Wed, 10 Jun 2015 22:27:47 +0900
Message-ID: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergey.senozhatsky.work@gmail.com,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36452 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438AbbFJN2a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 09:28:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

A trivial patch.

My wifi stopped working recently, and the error message was not too
informative (at least to me):

kernel: wlp2s0: authenticate with 64:e5:99:74:dc:44
kernel: wlp2s0: send auth to 64:e5:99:74:dc:44 (try 1/3)
kernel: wlp2s0: authenticated
kernel: wlp2s0: associate with 64:e5:99:74:dc:44 (try 1/3)
kernel: wlp2s0: RX AssocResp from 64:e5:99:74:dc:44 (capab=0x411 status=0 aid=1)
kernel: wlp2s0: associated
kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
dhclient[355]: DHCPREQUEST on wlp2s0 to 255.255.255.255 port 67
kernel: DRBG: could not allocate digest TFM handle
kernel: wlp2s0: deauthenticating from 64:e5:99:74:dc:44 by local choice (Reason: 1=UNSPECIFIED)
kernel: cfg80211: Calling CRDA to update world regulatory domain


an update error message
  DRBG: could not allocate digest TFM handle: hmac(sha256)

is slightly more helpful (didn't have sha256 config enabled).

Sergey Senozhatsky (1):
  crypto/drbg: report backend_cra_name when allocation fails

 crypto/drbg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.4.3.368.g7974889
