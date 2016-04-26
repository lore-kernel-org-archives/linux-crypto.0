From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2 v2] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Tue, 26 Apr 2016 09:30:11 +0800
Message-ID: <20160426013011.GA16271@gondor.apana.org.au>
References: <1460712316-3127-1-git-send-email-salvatore.benedetto@intel.com>
 <1460712316-3127-2-git-send-email-salvatore.benedetto@intel.com>
 <20160426011957.GA16114@gondor.apana.org.au>
 <C7D40AFA-25E0-4E0F-9F2E-10B3380A3C3A@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53882 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbcDZBaT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 21:30:19 -0400
Content-Disposition: inline
In-Reply-To: <C7D40AFA-25E0-4E0F-9F2E-10B3380A3C3A@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 26, 2016 at 10:27:25AM +0900, Marcel Holtmann wrote:
>
> actually if we have support for ECDH P-256, then Bluetooth could be converted easily and we get an internal user of this API.

Great, then I would like to see the KPP patch come with an implementation
for that algorithm and a conversion patch for bluetooth so that they
can be reviewed together.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
