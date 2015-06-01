From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 7/7] mac80211: Switch to new AEAD interface
Date: Mon, 01 Jun 2015 15:21:41 +0200
Message-ID: <1706098.2opyZ2hT8S@tachyon.chronox.de>
References: <20150521103938.GA23035@gondor.apana.org.au> <E1YvNxS-00063i-AZ@gondolin.me.apana.org.au> <1432207249.2343.9.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Johannes Berg <johannes@sipsolutions.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58414 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbbFANVu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 09:21:50 -0400
In-Reply-To: <1432207249.2343.9.camel@sipsolutions.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 21. Mai 2015, 13:20:49 schrieb Johannes Berg:

Hi Johannes,

> On Thu, 2015-05-21 at 18:44 +0800, Herbert Xu wrote:
> > This patch makes use of the new AEAD interface which uses a single
> > SG list instead of separate lists for the AD and plain text.
> 
> Looks fine - want me to run any tests on it?

Just a short question on ieee80211_aes_ccm_encrypt, ieee80211_aes_ccm_decrypt, 
ieee80211_aes_gcm_encrypt, ieee80211_aes_gcm_decrypt, ieee80211_aes_gmac: can 
the aad parameter of these functions be zero?

-- 
Ciao
Stephan
