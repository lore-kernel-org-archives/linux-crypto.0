From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Thu, 23 Jun 2016 18:44:30 +0800
Message-ID: <20160623104430.GB10350@gondor.apana.org.au>
References: <1466614155-24840-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52659 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbcFWKof (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 06:44:35 -0400
Content-Disposition: inline
In-Reply-To: <1466614155-24840-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 05:49:12PM +0100, Salvatore Benedetto wrote:
> Hi Herb,
> 
> the following patchset introduces a new API for abstracting key-agreement
> protocols such as DH and ECDH. It provides the primitives required for implementing
> the protocol, thus the name KPP (Key-agreement Protocol Primitives).
> 
> Regards,
> Salvatore
> 
> Changes from v10:
> * Remove all DH/ECDH code from testmgr. Secret is now encoded both
>   in little and big endian in the testvector

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
