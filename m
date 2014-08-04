From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH 1/2] crypto: add support for TLS 1.0 record encryption
Date: Mon, 4 Aug 2014 09:21:28 +0300
Message-ID: <53DF2668.1010603@freescale.com>
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
 <1406626353-23309-2-git-send-email-cristian.stoica@freescale.com>
 <53DAA097.90005@amacapital.net> <53DB58A8.3070600@freescale.com>
 <CALCETrX3r2shBVTCR=WEmXNV+L=Qk7+ZxKYamWZ4EjVLgqU5kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:29449
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbaHDGVj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2014 02:21:39 -0400
In-Reply-To: <CALCETrX3r2shBVTCR=WEmXNV+L=Qk7+ZxKYamWZ4EjVLgqU5kg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andy,

On 01.08.2014 17:44, Andy Lutomirski wrote:
> If I understand it correctly, the issue is that cryptlen depends on
> the padding.  I added some notes inline above.  See here, too:
> 
> https://www.imperialviolet.org/2013/02/04/luckythirteen.html

Thanks for review. We'll address this issue and resend an updated patch.

Cristian S.
