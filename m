From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: do not attempt to write to readonly variable
Date: Fri, 4 Mar 2011 15:29:20 +0800
Message-ID: <20110304072920.GA9973@gondor.apana.org.au>
References: <1298298442-24697-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60390 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1CDH3Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Mar 2011 02:29:24 -0500
Content-Disposition: inline
In-Reply-To: <1298298442-24697-1-git-send-email-dsterba@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 21, 2011 at 03:27:22PM +0100, David Sterba wrote:
> Commit da7f033ddc9fdeb (=E2=80=9Dcrypto: cryptomgr - Add test infrast=
ructure=E2=80=9D) added a
> const to variable which is later used as target buffer of memcpy.

Patch applied.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
