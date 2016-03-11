From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: ccp - CCP driver updates  2016-03-01
Date: Fri, 11 Mar 2016 21:30:30 +0800
Message-ID: <20160311133030.GA24332@gondor.apana.org.au>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
	davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35069 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbcCKNah (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 08:30:37 -0500
Content-Disposition: inline
In-Reply-To: <20160301194831.6788.2154.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 01, 2016 at 01:48:43PM -0600, Gary R Hook wrote:
> The following patches are includes in this update series:
> 
> - Remove the extraneous family check
> - Refactor code to enable support for >1 CCPs in a system
> - Add initial support for versioning
> - Refactor: move version-specific code to separate files 
>   where possible; abstract worker functions through a
>   struct of function pointers
> 
> This patch series is based on cryptodev-2.6

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
