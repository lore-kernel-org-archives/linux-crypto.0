From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3 v3] Key-agreement Protocol Primitives (KPP) API
Date: Thu, 5 May 2016 14:21:40 +0800
Message-ID: <20160505062140.GA3949@gondor.apana.org.au>
References: <1462275843-19926-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36287 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbcEEGVs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 02:21:48 -0400
Content-Disposition: inline
In-Reply-To: <1462275843-19926-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 03, 2016 at 12:44:00PM +0100, Salvatore Benedetto wrote:
> Hi Herb,
> 
> the following patchset introduces a new API for abstracting key-agreement
> protocols such as DH and ECDH. It provides the primitives required for implementing
> the protocol, thus the name KPP (Key-agreement Protocol Primitives).
> 
> Regards,
> Salvatore
> 
> Changes from v1:
>  * Change check in dh_check_params_length based on Stephan review
> 
> Changed from v2:
>  * Add support for ECDH (curve P192 and P256). I reused the ecc module
>    already present in net/bluetooth and extended it in order to select
>    different curves at runtime. Code for P192 was taken from tinycrypt.

Are you going to post the patches to use this as well?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
