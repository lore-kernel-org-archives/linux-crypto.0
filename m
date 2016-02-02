From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/2] crypto: tcrypt - Add acipher bandwidth tests support
Date: Tue, 2 Feb 2016 23:11:41 +0800
Message-ID: <20160202151141.GA21240@gondor.apana.org.au>
References: <1454074387-8321-2-git-send-email-cata.vasile@nxp.com>
 <20160201142159.GA11292@gondor.apana.org.au>
 <DB5PR04MB130208D1DB2F7D0C1430E9AAEEDF0@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-crypto-owner@vger.kernel.org"
	<linux-crypto-owner@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37791 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbcBBPLo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Feb 2016 10:11:44 -0500
Content-Disposition: inline
In-Reply-To: <DB5PR04MB130208D1DB2F7D0C1430E9AAEEDF0@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 02, 2016 at 11:27:07AM +0000, Catalin Vasile wrote:
>
> >modprobe tcrypt mode=601 band=1>
> Are you referring to modify the speed tests to include a flag to start bandwidth tests?
> If so, it sounds reasonable.

Yes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
