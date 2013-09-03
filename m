From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: Mistake ?
Date: Tue, 03 Sep 2013 16:01:52 +0300
Message-ID: <5225DDC0.8080202@iki.fi>
References: <5da2c075ce2fc47b4174aed8995fb62f@kiwi.fruits>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Pierre-Mayeul Badaire <pierre-mayeul.badaire@m4x.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55025 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3ICNB6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Sep 2013 09:01:58 -0400
In-Reply-To: <5da2c075ce2fc47b4174aed8995fb62f@kiwi.fruits>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03.09.2013 15:36, Pierre-Mayeul Badaire wrote:
> Good afternoon,
> 
> Don't you have a mistake on the MODULE_ALIAS at the last line of the commit ? Shouldn't it be MODULE_ALIAS("sha224") here ?

Yes, that's correct, it should be "ssh224" instead of "sha384". I'll post patch soon.

-Jussi

> 
> Reference:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a710f761fc9ae5728765a5917f8beabb49f98483
> 
> Best regards,
> 
