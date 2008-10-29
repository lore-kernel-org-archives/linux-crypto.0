From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Tue, 28 Oct 2008 19:02:57 -0500
Message-ID: <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Barry G" <mr.scada@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:36876 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbYJ1Xwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Oct 2008 19:52:53 -0400
In-Reply-To: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 23 Oct 2008 16:12:22 -0700
"Barry G" <mr.scada@gmail.com> wrote:

> I wanted to enable the Talitos driver for hw entropy.  If I rebuild
> the kernel with
> CONFIG_CRYPTO_DEV_TALITOS set to y, strongswan still successfully negotiates
> an IPsec SA, but no traffic flows.

does no traffic flow at all or is it all getting dropped?

> Also, is it correct that Talitos only accelerates AEAD connections, not ESP/AH
> protocols so there will be no performance increase for me until Strongswan
> adds rfc5282 support?

I'm not sure what you mean here; talitos supports aes-cbc but doesn't
support aes-ccm nor aes-gcm.

> 	auth hmac(sha256)
> 0xffab7c320d8375cad9633af7c67d923df47183296b9eb8a25fca5c8e5670e8ac

can you try hmac(sha1) until I get a decent setkey?

Kim
