From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v6 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Thu, 12 May 2016 12:34:08 -0700
Message-ID: <5E019EB7-E841-4C35-80D8-6A89675F46C9@holtmann.org>
References: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:55102 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932088AbcELTeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 15:34:13 -0400
In-Reply-To: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> the following patchset introduces a new API for abstracting key-agreement
> protocols such as DH and ECDH. It provides the primitives required for implementing
> the protocol, thus the name KPP (Key-agreement Protocol Primitives).
> 
> Regards,
> Salvatore
> 
> Changes from v5:
> * Fix ecdh loading in fips mode.
> 
> Changes from v4:
> * If fips_enabled is set allow only P256 (or higher) as Stephan suggested
> * Pass ndigits as argument to ecdh_make_pub_key and ecdh_shared_secret
>  so that VLA can be used like in the rest of the module
> 
> Changes from v3:
> * Move curve ID definition to public header ecdh.h as users need to
>  have access to those ids when selecting the curve
> 
> Changes from v2:
> * Add support for ECDH (curve P192 and P256). I reused the ecc module
>  already present in net/bluetooth and extended it in order to select
>  different curves at runtime. Code for P192 was taken from tinycrypt.
> 
> Changes from v1:
> * Change check in dh_check_params_length based on Stephan review
> 
> 
> Salvatore Benedetto (3):
>  crypto: Key-agreement Protocol Primitives API (KPP)
>  crypto: kpp - Add DH software implementation
>  crypto: kpp - Add ECDH software support

we have tested this with the Bluetooth subsystem to use ECDH for key generation and shared secret generation. This seems to work as expected. Feel free to merge this patchset.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel
