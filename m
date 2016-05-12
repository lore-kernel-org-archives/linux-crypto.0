From: Johan Hedberg <johan.hedberg@intel.com>
Subject: Re: [PATCH v2] Bluetooth: convert smp and selftest to crypto kpp API
Date: Thu, 12 May 2016 21:04:55 +0300
Message-ID: <20160512180455.GA4802@t440s.P-661HNU-F1>
References: <1462831206-2947-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, gustavo@padovan.org,
	linux-bluetooth@vger.kernel.org, linux-crypto@vger.kernel.org,
	marcel@holtmann.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36530 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbcELSFD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 14:05:03 -0400
Received: by mail-lf0-f54.google.com with SMTP id u64so76444879lff.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 May 2016 11:05:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1462831206-2947-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Salvatore,

On Mon, May 09, 2016, Salvatore Benedetto wrote:
>  * Convert both smp and selftest to crypto kpp API
>  * Remove module ecc as not more required
>  * Add ecdh_helper functions for wrapping kpp async calls
> 
> This patch has been tested *only* with selftest, which is called on
> module loading. smp-tester passes all tests but the first one, which
> often times out. Same behavior is observed without this patch though.
> 
> This patch is based on https://patchwork.kernel.org/patch/9050061/
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> ---
>  net/bluetooth/Makefile      |   2 +-
>  net/bluetooth/ecc.c         | 816 --------------------------------------------
>  net/bluetooth/ecc.h         |  54 ---
>  net/bluetooth/ecdh_helper.c | 204 +++++++++++
>  net/bluetooth/ecdh_helper.h |  32 ++
>  net/bluetooth/selftest.c    |   6 +-
>  net/bluetooth/smp.c         |   8 +-
>  7 files changed, 244 insertions(+), 878 deletions(-)
>  delete mode 100644 net/bluetooth/ecc.c
>  delete mode 100644 net/bluetooth/ecc.h
>  create mode 100644 net/bluetooth/ecdh_helper.c
>  create mode 100644 net/bluetooth/ecdh_helper.h

I tried this together with your kpp patches and I was able to
successfully pair, so from that perspective we're fine and I have no
objections for those patches being merged.

There are a couple of things to improve with this patch however:

The first issue is that you're missing a 'select CRYPTO_ECDH' in
net/bluetooth/Kconfig. Without this you'll end up creating a kernel that
either doesn't build or a module that doesn't load.

> +#ifndef __ECDH_HELPER_H
> +#define __ECDH_HELPER_H

Please leave out these include guards for internal headers. We try to
avoid them there to force keeping the dependency chains simple. I
realize you might have copied this from smp.h (which is the only
internal header I could see having this) so that might need fixing in a
separate patch.

> +bool compute_ecdh_shared_secret(const u8 pub_a[64], const u8 priv_b[32],
> +				u8 secret[32]);
> +bool generate_ecdh_key_pair(u8 public_key[64], u8 private_key[32]);

Could you try to come up with some shorter names than these since they
cause the line lengths to go past 80 chars. In fact, can't you just keep
the same names as our ecc.c was using. I don't think those names are
taken by your new kpp code?

Johan
