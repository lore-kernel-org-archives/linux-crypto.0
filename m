From: Catalin Vasile <cata.vasile@nxp.com>
Subject: Re: [RFC 1/2] crypto: tcrypt - Add acipher bandwidth tests support
Date: Tue, 2 Feb 2016 11:27:07 +0000
Message-ID: <DB5PR04MB130208D1DB2F7D0C1430E9AAEEDF0@DB5PR04MB1302.eurprd04.prod.outlook.com>
References: <1454074387-8321-2-git-send-email-cata.vasile@nxp.com>,<20160201142159.GA11292@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-crypto-owner@vger.kernel.org"
	<linux-crypto-owner@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0057.outbound.protection.outlook.com ([157.56.112.57]:62833
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754499AbcBBL1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Feb 2016 06:27:10 -0500
In-Reply-To: <20160201142159.GA11292@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



________________________________________
>From: Herbert Xu <herbert@gondor.apana.org.au>
>Sent: Monday, February 1, 2016 4:21 PM
>To: Catalin Vasile
>Cc: linux-crypto@vger.kernel.org; linux-crypto-owner@vger.kernel.org; Horia Ioan Geanta Neag; Cristian Stoica; Alexandru Porosanu; Catalin Vasile
>Subject: Re: [RFC 1/2] crypto: tcrypt - Add acipher bandwidth tests support>

>Catalin Vasile <cata.vasile@nxp.com> wrote:
>> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>>

>Please give a description of what your patch does here.>

>> +       case 600:
>> +               band_acipher("ecb(aes)", ENCRYPT, sec, NULL, 0,
>> +                                  speed_template_16_24_32);>

>Rather than creating new test modes, which you would have to do
>for every asynchronous type going forward, how about making a new
>parameter that toggled this on and off? For example,>

>modprobe tcrypt mode=601 band=1>
Are you referring to modify the speed tests to include a flag to start bandwidth tests?
If so, it sounds reasonable.

>Thanks,
>--
>Email: Herbert Xu <herbert@gondor.apana.org.au>
>Home Page: http://gondor.apana.org.au/~herbert/
>PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Cata
